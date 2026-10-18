package com.slotwise.model;

import java.sql.Time;
import java.sql.Timestamp;

/**
 * TimetableEntry Model Class
 * ============================
 * OOP CONCEPT: ENCAPSULATION
 *
 * Represents a single class/lecture in a student's weekly timetable.
 * Each entry has a subject, room, day of the week, and time range.
 *
 * ENCAPSULATION:
 * - All fields are private.
 * - Access is controlled through getters and setters.
 * - Time validation ensures end_time > start_time.
 */
public class TimetableEntry {

    private int timetableId;
    private int studentId;
    private String subjectName;
    private String roomNumber;
    private String dayOfWeek;
    private Time startTime;
    private Time endTime;
    private String professorName;
    private Timestamp createdAt;

    // --- Constructors ---

    public TimetableEntry() {
    }

    public TimetableEntry(int studentId, String subjectName, String roomNumber,
                          String dayOfWeek, Time startTime, Time endTime) {
        this.studentId = studentId;
        setSubjectName(subjectName);
        setRoomNumber(roomNumber);
        setDayOfWeek(dayOfWeek);
        setTimeRange(startTime, endTime);
    }

    // --- Getters and Setters ---

    public int getTimetableId() { return timetableId; }
    public void setTimetableId(int timetableId) { this.timetableId = timetableId; }

    public int getEntryId() { return timetableId; }
    public void setEntryId(int entryId) { this.timetableId = entryId; }

    public String getProfessorName() { return professorName; }
    public void setProfessorName(String professorName) { this.professorName = professorName; }

    public int getStudentId() { return studentId; }
    public void setStudentId(int studentId) { this.studentId = studentId; }

    public String getSubjectName() { return subjectName; }
    public void setSubjectName(String subjectName) {
        if (subjectName == null || subjectName.trim().isEmpty()) {
            throw new IllegalArgumentException("Subject name cannot be empty.");
        }
        this.subjectName = subjectName.trim();
    }

    public String getRoomNumber() { return roomNumber; }
    public void setRoomNumber(String roomNumber) {
        if (roomNumber == null || roomNumber.trim().isEmpty()) {
            throw new IllegalArgumentException("Room number cannot be empty.");
        }
        this.roomNumber = roomNumber.trim();
    }

    public String getDayOfWeek() { return dayOfWeek; }
    public void setDayOfWeek(String dayOfWeek) {
        if (dayOfWeek == null || dayOfWeek.trim().isEmpty()) {
            throw new IllegalArgumentException("Day of week cannot be empty.");
        }
        this.dayOfWeek = dayOfWeek.trim();
    }

    public Time getStartTime() { return startTime; }
    public void setStartTime(Time startTime) { this.startTime = startTime; }

    public Time getEndTime() { return endTime; }
    public void setEndTime(Time endTime) { this.endTime = endTime; }

    /**
     * Sets both start and end time with validation.
     * Ensures end time is strictly after start time.
     */
    public void setTimeRange(Time startTime, Time endTime) {
        if (startTime != null && endTime != null && !endTime.after(startTime)) {
            throw new IllegalArgumentException("End time must be after start time.");
        }
        this.startTime = startTime;
        this.endTime = endTime;
    }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    /**
     * Returns the duration of this class in minutes.
     */
    public int getDurationMinutes() {
        if (startTime == null || endTime == null) return 0;
        long diff = endTime.getTime() - startTime.getTime();
        return (int) (diff / (1000 * 60));
    }

    /**
     * Formats start time as HH:MM for display.
     */
    public String getFormattedStartTime() {
        if (startTime == null) return "";
        return startTime.toString().substring(0, 5);
    }

    /**
     * Formats end time as HH:MM for display.
     */
    public String getFormattedEndTime() {
        if (endTime == null) return "";
        return endTime.toString().substring(0, 5);
    }

    @Override
    public String toString() {
        return "TimetableEntry{" + subjectName + " @ " + roomNumber
               + " on " + dayOfWeek + " " + startTime + "-" + endTime + "}";
    }
}
