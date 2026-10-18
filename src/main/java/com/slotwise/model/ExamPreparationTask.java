package com.slotwise.model;

import java.sql.Date;

/**
 * ExamPreparationTask — Subclass of Task
 * ========================================
 * OOP CONCEPT: INHERITANCE and POLYMORPHISM
 *
 * This class INHERITS from Task and represents exam study sessions
 * (revision, practice problems, concept review, etc.).
 *
 * INHERITANCE: Reuses all fields and methods from the Task base class.
 *
 * POLYMORPHISM: Overrides calculatePriorityScore() to factor in the
 * typically longer study duration needed for exams. Exam prep tasks
 * that require more than 60 minutes get an additional urgency boost,
 * since they are harder to fit into small free-time gaps.
 */
public class ExamPreparationTask extends Task {

    public ExamPreparationTask() {
        super();
        setTaskType(TaskType.EXAM_PREP);
    }

    public ExamPreparationTask(int studentId, String title, String description,
                                Priority priority, int estimatedMinutes, Date deadline) {
        super(studentId, title, description, TaskType.EXAM_PREP,
              priority, estimatedMinutes, deadline);
    }

    /**
     * POLYMORPHISM: Overrides the base class method.
     *
     * Exam preparation tasks get a bonus based on study duration.
     * Longer study sessions (> 60 min) get +15 because they need
     * to be scheduled in larger free-time gaps — making them harder
     * to fit and thus more urgent to plan ahead.
     */
    @Override
    public int calculatePriorityScore() {
        int baseScore = super.calculatePriorityScore();
        // Long exam prep sessions are harder to fit — boost priority
        if (getEstimatedMinutes() > 60) {
            return baseScore + 15;
        }
        return baseScore + 5;
    }

    /**
     * POLYMORPHISM: Returns a specific label for exam prep tasks.
     */
    @Override
    public String getTaskTypeLabel() {
        return "Exam Preparation";
    }
}
