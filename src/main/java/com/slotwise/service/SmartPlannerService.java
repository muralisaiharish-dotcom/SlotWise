package com.slotwise.service;

import com.slotwise.dao.RecommendationDAO;
import com.slotwise.dao.TaskDAO;
import com.slotwise.dao.TimetableDAO;
import com.slotwise.model.*;

import java.sql.SQLException;
import java.sql.Time;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

/**
 * SmartPlannerService — Rule-Based Scheduling Algorithm
 * =======================================================
 * OOP CONCEPTS: ABSTRACTION (implements TaskSchedulingStrategy),
 *               POLYMORPHISM (uses polymorphic calculatePriorityScore())
 *
 * This service implements the TaskSchedulingStrategy interface (ABSTRACTION)
 * and provides a practical, rule-based scheduling algorithm that:
 *
 * 1. Reads the student's timetable from MySQL.
 * 2. Identifies gaps between classes on the selected day.
 * 3. Reads pending tasks from MySQL.
 * 4. Considers each task's estimated duration.
 * 5. Considers task priority and deadline urgency (via POLYMORPHISM).
 * 6. Recommends tasks that fit into available gaps.
 * 7. Avoids scheduling during occupied class periods.
 * 8. Avoids recommending completed tasks.
 * 9. Explains why each task was recommended.
 *
 * The scheduling algorithm is purely rule-based Java logic.
 * It does NOT use any external AI system.
 */
public class SmartPlannerService implements TaskSchedulingStrategy {

    private final TimetableDAO timetableDAO = new TimetableDAO();
    private final TaskDAO taskDAO = new TaskDAO();
    private final RecommendationDAO recommendationDAO = new RecommendationDAO();

    // Define the study day boundaries (8:00 AM to 6:00 PM)
    private static final Time DAY_START = Time.valueOf("08:00:00");
    private static final Time DAY_END   = Time.valueOf("18:00:00");

    /**
     * ABSTRACTION: Implements the findFreeSlots method from
     * TaskSchedulingStrategy interface.
     *
     * Algorithm:
     * 1. Get all classes for the student on the given day, sorted by start time.
     * 2. Walk through the day from DAY_START to DAY_END.
     * 3. Any gap between the end of one class and the start of the next
     *    (or DAY_START/DAY_END boundaries) is a free slot.
     * 4. Only include gaps of at least 15 minutes (practical minimum).
     */
    @Override
    public List<FreeTimeSlot> findFreeSlots(int studentId, String dayOfWeek) {
        List<FreeTimeSlot> freeSlots = new ArrayList<>();

        try {
            List<TimetableEntry> classes = timetableDAO.getEntriesByDay(studentId, dayOfWeek);

            if (classes.isEmpty()) {
                // Entire day is free
                freeSlots.add(new FreeTimeSlot(DAY_START, DAY_END, dayOfWeek));
                return freeSlots;
            }

            // Sort classes by start time (should already be sorted from DB)
            classes.sort(Comparator.comparing(TimetableEntry::getStartTime));

            // Check gap before first class
            Time cursor = DAY_START;

            for (TimetableEntry entry : classes) {
                Time classStart = entry.getStartTime();
                Time classEnd = entry.getEndTime();

                // If there's a gap between cursor and this class start
                if (classStart.after(cursor)) {
                    int gapMinutes = minutesBetween(cursor, classStart);
                    if (gapMinutes >= 15) {
                        freeSlots.add(new FreeTimeSlot(cursor, classStart, dayOfWeek));
                    }
                }

                // Move cursor to end of this class
                if (classEnd.after(cursor)) {
                    cursor = classEnd;
                }
            }

            // Check gap after last class until day end
            if (DAY_END.after(cursor)) {
                int gapMinutes = minutesBetween(cursor, DAY_END);
                if (gapMinutes >= 15) {
                    freeSlots.add(new FreeTimeSlot(cursor, DAY_END, dayOfWeek));
                }
            }

        } catch (SQLException e) {
            System.err.println("[SmartPlanner] Error finding free slots: " + e.getMessage());
        }

        return freeSlots;
    }

    /**
     * ABSTRACTION: Implements the generateRecommendations method from
     * TaskSchedulingStrategy interface.
     *
     * POLYMORPHISM: Calls calculatePriorityScore() on each task.
     * Since tasks are instantiated as their correct subclass via TaskFactory,
     * the overridden method in AssignmentTask, ExamPreparationTask, or LabTask
     * is called automatically at runtime.
     *
     * Algorithm:
     * 1. Find free slots for the day.
     * 2. Get all pending tasks, ranked by priority score.
     * 3. For each free slot, try to fit the highest-priority pending tasks.
     * 4. Generate a recommendation with an explanation.
     * 5. Save to database.
     */
    @Override
    public List<Recommendation> generateRecommendations(int studentId, String dayOfWeek) {
        List<Recommendation> recommendations = new ArrayList<>();

        try {
            // Clear previous recommendations
            recommendationDAO.clearRecommendations(studentId);

            // Step 1: Find free time slots
            List<FreeTimeSlot> freeSlots = findFreeSlots(studentId, dayOfWeek);

            if (freeSlots.isEmpty()) {
                return recommendations; // No free time available
            }

            // Step 2: Get pending tasks, ranked by priority
            List<Task> pendingTasks = taskDAO.getPendingTasks(studentId);
            pendingTasks = rankTasksByPriority(pendingTasks);

            if (pendingTasks.isEmpty()) {
                return recommendations; // No pending tasks
            }

            // Step 3: Match tasks to free slots
            // Keep track of which tasks have been recommended
            List<Integer> recommendedTaskIds = new ArrayList<>();

            for (FreeTimeSlot slot : freeSlots) {
                for (Task task : pendingTasks) {
                    // Skip already recommended tasks
                    if (recommendedTaskIds.contains(task.getTaskId())) {
                        continue;
                    }

                    // Check if task fits in this slot
                    if (slot.canFitTask(task.getEstimatedMinutes())) {
                        // Generate explanation
                        String reason = generateReason(task, slot);

                        // Determine how many minutes to recommend
                        int recommendedMinutes = Math.min(
                            task.getEstimatedMinutes(),
                            slot.getDurationMinutes()
                        );

                        // Create recommendation
                        Recommendation rec = new Recommendation(
                            studentId,
                            task.getTaskId(),
                            slot.getStartTime(),
                            slot.getEndTime(),
                            recommendedMinutes,
                            reason
                        );

                        // Save to database
                        int recId = recommendationDAO.createRecommendation(rec);
                        rec.setRecommendationId(recId);
                        rec.setTaskTitle(task.getTitle());
                        rec.setTaskPriority(task.getPriority().name());
                        rec.setTaskType(task.getTaskType().name());
                        recommendations.add(rec);

                        recommendedTaskIds.add(task.getTaskId());
                        break; // Move to next slot
                    } else if (slot.getDurationMinutes() >= 15 &&
                               !recommendedTaskIds.contains(task.getTaskId())) {
                        // Partial fit: recommend working on the task for available time
                        String reason = "Partial session: Work on this task for "
                                + slot.getDurationMinutes() + " minutes. "
                                + generateReasonSuffix(task);

                        Recommendation rec = new Recommendation(
                            studentId,
                            task.getTaskId(),
                            slot.getStartTime(),
                            slot.getEndTime(),
                            slot.getDurationMinutes(),
                            reason
                        );

                        int recId = recommendationDAO.createRecommendation(rec);
                        rec.setRecommendationId(recId);
                        rec.setTaskTitle(task.getTitle());
                        rec.setTaskPriority(task.getPriority().name());
                        rec.setTaskType(task.getTaskType().name());
                        recommendations.add(rec);

                        recommendedTaskIds.add(task.getTaskId());
                        break;
                    }
                }
            }

        } catch (SQLException e) {
            System.err.println("[SmartPlanner] Error generating recommendations: " + e.getMessage());
        }

        return recommendations;
    }

    /**
     * ABSTRACTION + POLYMORPHISM: Ranks tasks by their priority score.
     *
     * Each task's calculatePriorityScore() method is called polymorphically:
     * - AssignmentTask adds +10 for deadline urgency
     * - ExamPreparationTask adds +5 to +15 based on study duration
     * - LabTask adds +5 to +8 based on priority level
     *
     * Tasks are sorted in descending order (highest score first).
     */
    @Override
    public List<Task> rankTasksByPriority(List<Task> tasks) {
        List<Task> sorted = new ArrayList<>(tasks);

        // POLYMORPHISM: Each task subclass calculates its own score
        sorted.sort((t1, t2) -> t2.calculatePriorityScore() - t1.calculatePriorityScore());

        return sorted;
    }

    /**
     * Generates a human-readable reason for the recommendation.
     */
    private String generateReason(Task task, FreeTimeSlot slot) {
        StringBuilder reason = new StringBuilder();

        // Priority-based reason
        switch (task.getPriority()) {
            case HIGH:
                reason.append("High priority task. ");
                break;
            case MEDIUM:
                reason.append("Medium priority task. ");
                break;
            case LOW:
                reason.append("Low priority task. ");
                break;
        }

        reason.append(generateReasonSuffix(task));

        reason.append("You have ").append(slot.getDurationMinutes())
              .append(" minutes available in this slot.");

        return reason.toString();
    }

    private String generateReasonSuffix(Task task) {
        StringBuilder suffix = new StringBuilder();

        // Deadline-based reason
        if (task.isOverdue()) {
            suffix.append("OVERDUE — complete as soon as possible! ");
        } else if (task.getDeadline() != null) {
            long daysLeft = (task.getDeadline().getTime() - System.currentTimeMillis())
                           / (1000L * 60 * 60 * 24);
            if (daysLeft <= 1) {
                suffix.append("Due very soon — prioritize this today. ");
            } else if (daysLeft <= 3) {
                suffix.append("Due within ").append(daysLeft).append(" days. ");
            }
        }

        // Type-based reason
        switch (task.getTaskType()) {
            case ASSIGNMENT:
                suffix.append("Assignment submissions have strict deadlines. ");
                break;
            case EXAM_PREP:
                suffix.append("Consistent study sessions improve retention. ");
                break;
            case LAB:
                suffix.append("Complete lab work before your next session. ");
                break;
            default:
                break;
        }

        return suffix.toString();
    }

    /**
     * Calculates minutes between two Time values.
     */
    private int minutesBetween(Time start, Time end) {
        long diff = end.getTime() - start.getTime();
        return (int) (diff / (1000 * 60));
    }
}
