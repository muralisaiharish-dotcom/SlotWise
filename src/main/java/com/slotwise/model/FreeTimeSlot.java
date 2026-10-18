package com.slotwise.model;

import java.sql.Time;

/**
 * FreeTimeSlot Model Class
 * =========================
 * Represents an available gap between two classes in a student's timetable.
 *
 * This is used by the Smart Planner to identify when a student is free
 * and can work on pending tasks.
 *
 * ENCAPSULATION: Private fields with controlled access.
 */
public class FreeTimeSlot {

    private Time startTime;
    private Time endTime;
    private String dayOfWeek;
    private int durationMinutes;

    public FreeTimeSlot() {
    }

    public FreeTimeSlot(Time startTime, Time endTime, String dayOfWeek) {
        this.startTime = startTime;
        this.endTime = endTime;
        this.dayOfWeek = dayOfWeek;
        this.durationMinutes = calculateDuration();
    }

    private int calculateDuration() {
        if (startTime == null || endTime == null) return 0;
        long diff = endTime.getTime() - startTime.getTime();
        return (int) (diff / (1000 * 60));
    }

    // --- Getters and Setters ---

    public Time getStartTime() { return startTime; }
    public void setStartTime(Time startTime) {
        this.startTime = startTime;
        this.durationMinutes = calculateDuration();
    }

    public Time getEndTime() { return endTime; }
    public void setEndTime(Time endTime) {
        this.endTime = endTime;
        this.durationMinutes = calculateDuration();
    }

    public String getDayOfWeek() { return dayOfWeek; }
    public void setDayOfWeek(String dayOfWeek) { this.dayOfWeek = dayOfWeek; }

    public int getDurationMinutes() { return durationMinutes; }

    public String getFormattedStartTime() {
        if (startTime == null) return "";
        return startTime.toString().substring(0, 5);
    }

    public String getFormattedEndTime() {
        if (endTime == null) return "";
        return endTime.toString().substring(0, 5);
    }

    public String getTimeRangeFormatted() {
        return getFormattedStartTime() + " - " + getFormattedEndTime();
    }

    /**
     * Checks if a task with the given duration (in minutes) can fit
     * within this free-time slot.
     */
    public boolean canFitTask(int taskMinutes) {
        return taskMinutes > 0 && taskMinutes <= durationMinutes;
    }

    @Override
    public String toString() {
        return "FreeSlot{" + dayOfWeek + " " + startTime + "-" + endTime
               + " (" + durationMinutes + " min)}";
    }
}
