package com.slotwise.model;

import java.sql.Timestamp;

/**
 * AbstractGoal — Abstract Base Class for Academic Goals
 * =======================================================
 * OOP CONCEPTS: ABSTRACTION + ENCAPSULATION + INHERITANCE
 *
 * ABSTRACTION:
 *   This abstract class implements ProgressCalculable and provides
 *   a default calculateProgressPercent() implementation based on
 *   currentValue / targetValue. Subclasses may override this if
 *   their domain requires different calculation logic.
 *
 * ENCAPSULATION:
 *   All fields are private with public getters/setters.
 *   Validation is enforced in setters.
 *
 * INHERITANCE:
 *   Subclasses (StudyHoursGoal, TaskCompletionGoal) inherit all
 *   common fields and extend with specialized behavior.
 *
 * This class cannot be instantiated directly — subclasses must
 *   be used for concrete goal instances.
 */
public abstract class AbstractGoal implements ProgressCalculable {

    // --- Goal Type Enum ---
    public enum GoalType {
        STUDY_HOURS, TASK_COMPLETION, SUBJECT_MASTERY, STREAK, CUSTOM
    }

    // --- Status Enum ---
    public enum GoalStatus {
        IN_PROGRESS, COMPLETED, AT_RISK, ON_TRACK
    }

    // --- Private Fields (Encapsulation) ---
    private int goalId;
    private int studentId;
    private String title;
    private String description;
    private GoalType goalType;
    private int targetValue;
    private int currentValue;
    private java.sql.Date deadline;
    private GoalStatus status;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // --- Constructors ---

    protected AbstractGoal() {
        this.goalType  = GoalType.CUSTOM;
        this.status    = GoalStatus.IN_PROGRESS;
        this.targetValue = 100;
        this.currentValue = 0;
    }

    protected AbstractGoal(int studentId, String title, GoalType goalType,
                           int targetValue, int currentValue) {
        this();
        this.studentId    = studentId;
        setTitle(title);
        this.goalType     = goalType;
        setTargetValue(targetValue);
        setCurrentValue(currentValue);
    }

    // --- ProgressCalculable Implementation (POLYMORPHISM) ---

    /**
     * POLYMORPHISM: Default implementation — calculates percent from
     * currentValue / targetValue. Subclasses override for custom logic.
     */
    @Override
    public int calculateProgressPercent() {
        if (targetValue <= 0) return 0;
        int percent = (int) Math.round((currentValue * 100.0) / targetValue);
        return Math.min(percent, 100);
    }

    /**
     * POLYMORPHISM: Returns status label for UI display.
     * Subclasses may override to add more nuanced labels.
     */
    @Override
    public String getStatusLabel() {
        switch (status) {
            case COMPLETED:   return "Completed";
            case ON_TRACK:    return "On Track";
            case AT_RISK:     return "At Risk";
            default:          return "In Progress";
        }
    }

    // --- Getters and Setters (Encapsulation) ---

    public int getGoalId() { return goalId; }
    public void setGoalId(int goalId) { this.goalId = goalId; }

    public int getStudentId() { return studentId; }
    public void setStudentId(int studentId) { this.studentId = studentId; }

    public String getTitle() { return title; }
    public void setTitle(String title) {
        if (title == null || title.trim().isEmpty()) {
            throw new IllegalArgumentException("Goal title cannot be empty.");
        }
        this.title = title.trim();
    }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public GoalType getGoalType() { return goalType; }
    public void setGoalType(GoalType goalType) { this.goalType = goalType; }
    public void setGoalTypeFromString(String s) {
        try { this.goalType = GoalType.valueOf(s.toUpperCase()); }
        catch (Exception e) { this.goalType = GoalType.CUSTOM; }
    }

    public int getTargetValue() { return targetValue; }
    public void setTargetValue(int targetValue) {
        if (targetValue <= 0) throw new IllegalArgumentException("Target value must be positive.");
        this.targetValue = targetValue;
    }

    public int getCurrentValue() { return currentValue; }
    public void setCurrentValue(int currentValue) {
        if (currentValue < 0) throw new IllegalArgumentException("Current value cannot be negative.");
        this.currentValue = currentValue;
    }

    public java.sql.Date getDeadline() { return deadline; }
    public void setDeadline(java.sql.Date deadline) { this.deadline = deadline; }

    public GoalStatus getStatus() { return status; }
    public void setStatus(GoalStatus status) { this.status = status; }
    public void setStatusFromString(String s) {
        try { this.status = GoalStatus.valueOf(s.toUpperCase()); }
        catch (Exception e) { this.status = GoalStatus.IN_PROGRESS; }
    }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

    /**
     * Returns a CSS class name for the status badge (used in JSP).
     */
    public String getStatusCssClass() {
        switch (status) {
            case COMPLETED:  return "goal-completed";
            case ON_TRACK:   return "goal-on-track";
            case AT_RISK:    return "goal-at-risk";
            default:         return "goal-in-progress";
        }
    }

    /**
     * Returns the icon emoji for the goal type.
     */
    public String getGoalTypeIcon() {
        switch (goalType) {
            case STUDY_HOURS:      return "&#128337;";
            case TASK_COMPLETION:  return "&#9989;";
            case SUBJECT_MASTERY:  return "&#128218;";
            case STREAK:           return "&#128293;";
            default:               return "&#127919;";
        }
    }

    @Override
    public String toString() {
        return "Goal{id=" + goalId + ", title='" + title + "', progress="
               + calculateProgressPercent() + "%, status=" + status + "}";
    }
}
