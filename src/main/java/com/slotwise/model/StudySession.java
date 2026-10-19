package com.slotwise.model;

import java.sql.Timestamp;

/**
 * StudySession Model Class
 * ==========================
 * OOP CONCEPT: ENCAPSULATION
 *
 * Represents a single recorded study session for a student.
 * Each session tracks: subject, date, duration (minutes), and notes.
 *
 * ENCAPSULATION:
 * - All fields are private.
 * - Getters and setters provide controlled access.
 * - Validation enforced in setters (e.g. duration must be positive).
 *
 * Used for:
 * - Computing daily and weekly study hours (bar chart).
 * - Generating productivity insights.
 * - Recent activity feed.
 */
public class StudySession {

    // --- Private Fields (Encapsulation) ---
    private int sessionId;
    private int studentId;
    private String subjectName;
    private java.sql.Date sessionDate;
    private int durationMinutes;
    private String notes;
    private Timestamp createdAt;

    // --- Constructors ---

    public StudySession() {}

    public StudySession(int studentId, String subjectName,
                        java.sql.Date sessionDate, int durationMinutes) {
        this.studentId = studentId;
        setSubjectName(subjectName);
        this.sessionDate = sessionDate;
        setDurationMinutes(durationMinutes);
    }

    // --- Getters and Setters ---

    public int getSessionId() { return sessionId; }
    public void setSessionId(int sessionId) { this.sessionId = sessionId; }

    public int getStudentId() { return studentId; }
    public void setStudentId(int studentId) { this.studentId = studentId; }

    public String getSubjectName() { return subjectName; }
    public void setSubjectName(String subjectName) {
        if (subjectName == null || subjectName.trim().isEmpty()) {
            throw new IllegalArgumentException("Subject name cannot be empty.");
        }
        this.subjectName = subjectName.trim();
    }

    public java.sql.Date getSessionDate() { return sessionDate; }
    public void setSessionDate(java.sql.Date sessionDate) { this.sessionDate = sessionDate; }

    public int getDurationMinutes() { return durationMinutes; }
    public void setDurationMinutes(int durationMinutes) {
        if (durationMinutes <= 0) {
            throw new IllegalArgumentException("Duration must be positive.");
        }
        this.durationMinutes = durationMinutes;
    }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    /**
     * Returns duration in hours (rounded to 1 decimal place).
     * Convenient for display purposes.
     */
    public double getDurationHours() {
        return Math.round((durationMinutes / 60.0) * 10.0) / 10.0;
    }

    @Override
    public String toString() {
        return "StudySession{id=" + sessionId + ", subject='" + subjectName
               + "', date=" + sessionDate + ", duration=" + durationMinutes + "min}";
    }
}
