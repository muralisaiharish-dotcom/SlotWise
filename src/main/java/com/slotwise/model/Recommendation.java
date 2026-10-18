package com.slotwise.model;

import java.sql.Time;
import java.sql.Timestamp;

/**
 * Recommendation Model Class
 * ============================
 * Represents a planner-generated recommendation that maps a pending
 * task to an available free-time slot.
 *
 * ENCAPSULATION: Private fields with controlled access.
 */
public class Recommendation {

    private int recommendationId;
    private int studentId;
    private int taskId;
    private Time availableStart;
    private Time availableEnd;
    private int recommendedMinutes;
    private String reason;
    private Timestamp createdAt;

    // Additional fields for display (populated via JOIN queries)
    private String taskTitle;
    private String taskPriority;
    private String taskType;

    public Recommendation() {
    }

    public Recommendation(int studentId, int taskId, Time availableStart,
                          Time availableEnd, int recommendedMinutes, String reason) {
        this.studentId = studentId;
        this.taskId = taskId;
        this.availableStart = availableStart;
        this.availableEnd = availableEnd;
        this.recommendedMinutes = recommendedMinutes;
        this.reason = reason;
    }

    // --- Getters and Setters ---

    public int getRecommendationId() { return recommendationId; }
    public void setRecommendationId(int recommendationId) { this.recommendationId = recommendationId; }

    public int getStudentId() { return studentId; }
    public void setStudentId(int studentId) { this.studentId = studentId; }

    public int getTaskId() { return taskId; }
    public void setTaskId(int taskId) { this.taskId = taskId; }

    public Time getAvailableStart() { return availableStart; }
    public void setAvailableStart(Time availableStart) { this.availableStart = availableStart; }

    public Time getAvailableEnd() { return availableEnd; }
    public void setAvailableEnd(Time availableEnd) { this.availableEnd = availableEnd; }

    public int getRecommendedMinutes() { return recommendedMinutes; }
    public void setRecommendedMinutes(int recommendedMinutes) { this.recommendedMinutes = recommendedMinutes; }

    public String getReason() { return reason; }
    public void setReason(String reason) { this.reason = reason; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public String getTaskTitle() { return taskTitle; }
    public void setTaskTitle(String taskTitle) { this.taskTitle = taskTitle; }

    public String getTaskPriority() { return taskPriority; }
    public void setTaskPriority(String taskPriority) { this.taskPriority = taskPriority; }

    public String getTaskType() { return taskType; }
    public void setTaskType(String taskType) { this.taskType = taskType; }

    public String getFormattedStartTime() {
        if (availableStart == null) return "";
        return availableStart.toString().substring(0, 5);
    }

    public String getFormattedEndTime() {
        if (availableEnd == null) return "";
        return availableEnd.toString().substring(0, 5);
    }

    public String getSlotStartTime() {
        return getFormattedStartTime();
    }

    public String getSlotEndTime() {
        return getFormattedEndTime();
    }
}
