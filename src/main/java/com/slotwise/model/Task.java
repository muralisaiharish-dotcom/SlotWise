package com.slotwise.model;

import java.sql.Date;
import java.sql.Timestamp;

/**
 * Task Base Class
 * ================
 * OOP CONCEPTS: ENCAPSULATION, INHERITANCE (base class), ABSTRACTION, POLYMORPHISM
 *
 * This is the BASE class in our task inheritance hierarchy:
 *
 *   Task (base class — contains common task fields and behavior)
 *     ├── AssignmentTask   (specialized for homework/assignments)
 *     ├── ExamPreparationTask (specialized for exam study)
 *     └── LabTask          (specialized for lab experiments)
 *
 * ENCAPSULATION:
 *   All fields are private with public getters/setters.
 *
 * ABSTRACTION:
 *   The method calculatePriorityScore() provides a default implementation
 *   but is designed to be overridden by subclasses (polymorphism).
 *
 * POLYMORPHISM:
 *   Subclasses override calculatePriorityScore() and getTaskTypeLabel()
 *   to provide specialized behavior. The application code works with the
 *   Task type, and the correct subclass method is called at runtime.
 */
public class Task {

    // --- Enum for task type ---
    public enum TaskType {
        ASSIGNMENT, EXAM_PREP, LAB, OTHER
    }

    // --- Enum for priority ---
    public enum Priority {
        HIGH, MEDIUM, LOW
    }

    // --- Enum for status ---
    public enum Status {
        PENDING, IN_PROGRESS, COMPLETED
    }

    // --- Private fields (Encapsulation) ---
    private int taskId;
    private int studentId;
    private String title;
    private String description;
    private TaskType taskType;
    private Priority priority;
    private int estimatedMinutes;
    private Date deadline;
    private Status status;
    private Timestamp createdAt;

    // --- Constructors ---

    public Task() {
        this.taskType = TaskType.OTHER;
        this.priority = Priority.MEDIUM;
        this.status = Status.PENDING;
        this.estimatedMinutes = 30;
    }

    public Task(int studentId, String title, String description,
                TaskType taskType, Priority priority,
                int estimatedMinutes, Date deadline) {
        this.studentId = studentId;
        setTitle(title);
        this.description = description;
        this.taskType = taskType;
        this.priority = priority;
        setEstimatedMinutes(estimatedMinutes);
        this.deadline = deadline;
        this.status = Status.PENDING;
    }

    // --- Getters and Setters ---

    public int getTaskId() { return taskId; }
    public void setTaskId(int taskId) { this.taskId = taskId; }

    public int getStudentId() { return studentId; }
    public void setStudentId(int studentId) { this.studentId = studentId; }

    public String getTitle() { return title; }
    public void setTitle(String title) {
        if (title == null || title.trim().isEmpty()) {
            throw new IllegalArgumentException("Task title cannot be empty.");
        }
        this.title = title.trim();
    }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public TaskType getTaskType() { return taskType; }
    public void setTaskType(TaskType taskType) { this.taskType = taskType; }

    /** Convenience setter from String (used when reading form data) */
    public void setTaskTypeFromString(String type) {
        try {
            this.taskType = TaskType.valueOf(type.toUpperCase());
        } catch (Exception e) {
            this.taskType = TaskType.OTHER;
        }
    }

    public Priority getPriority() { return priority; }
    public void setPriority(Priority priority) { this.priority = priority; }

    public void setPriorityFromString(String p) {
        try {
            this.priority = Priority.valueOf(p.toUpperCase());
        } catch (Exception e) {
            this.priority = Priority.MEDIUM;
        }
    }

    public int getEstimatedMinutes() { return estimatedMinutes; }
    public void setEstimatedMinutes(int estimatedMinutes) {
        if (estimatedMinutes <= 0) {
            throw new IllegalArgumentException("Estimated minutes must be positive.");
        }
        this.estimatedMinutes = estimatedMinutes;
    }

    public int getEstimatedDurationMinutes() { return estimatedMinutes; }
    public void setEstimatedDurationMinutes(int estimatedMinutes) {
        setEstimatedMinutes(estimatedMinutes);
    }

    public Date getDeadline() { return deadline; }
    public void setDeadline(Date deadline) { this.deadline = deadline; }

    public Status getStatus() { return status; }
    public void setStatus(Status status) { this.status = status; }

    public void setStatusFromString(String s) {
        try {
            this.status = Status.valueOf(s.toUpperCase());
        } catch (Exception e) {
            this.status = Status.PENDING;
        }
    }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    // --- Methods demonstrating POLYMORPHISM (designed to be overridden) ---

    /**
     * POLYMORPHISM: This method calculates a priority score for the task.
     * Subclasses override this method to provide specialized scoring.
     *
     * The score is used by the Smart Planner to rank tasks.
     * Higher score = higher urgency/importance.
     *
     * Base implementation considers priority level and deadline proximity.
     */
    public int calculatePriorityScore() {
        int score = 0;

        // Priority weight
        switch (priority) {
            case HIGH:   score += 30; break;
            case MEDIUM: score += 20; break;
            case LOW:    score += 10; break;
        }

        // Deadline urgency: tasks due sooner get higher scores
        if (deadline != null) {
            long daysUntilDeadline = (deadline.getTime() - System.currentTimeMillis())
                                     / (1000L * 60 * 60 * 24);
            if (daysUntilDeadline < 0) {
                score += 50; // Overdue — highest urgency
            } else if (daysUntilDeadline <= 1) {
                score += 40; // Due today or tomorrow
            } else if (daysUntilDeadline <= 3) {
                score += 25; // Due within 3 days
            } else if (daysUntilDeadline <= 7) {
                score += 15; // Due this week
            } else {
                score += 5;  // More than a week away
            }
        }

        return score;
    }

    /**
     * POLYMORPHISM: Returns a human-readable label for the task type.
     * Subclasses override this to return their specific label.
     */
    public String getTaskTypeLabel() {
        switch (taskType) {
            case ASSIGNMENT: return "Assignment";
            case EXAM_PREP:  return "Exam Preparation";
            case LAB:        return "Lab Work";
            default:         return "Other";
        }
    }

    /**
     * Returns a CSS-friendly class name for the priority.
     */
    public String getPriorityClass() {
        return priority.name().toLowerCase();
    }

    /**
     * Returns a CSS-friendly class name for the status.
     */
    public String getStatusClass() {
        return status.name().toLowerCase().replace("_", "-");
    }

    /**
     * Checks if this task is overdue (deadline passed and not completed).
     */
    public boolean isOverdue() {
        if (deadline == null || status == Status.COMPLETED) {
            return false;
        }
        return deadline.before(new Date(System.currentTimeMillis()));
    }

    @Override
    public String toString() {
        return "Task{id=" + taskId + ", title='" + title + "', type=" + taskType
               + ", priority=" + priority + ", status=" + status + "}";
    }
}
