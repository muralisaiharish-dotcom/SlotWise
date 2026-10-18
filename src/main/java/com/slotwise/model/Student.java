package com.slotwise.model;

/**
 * Student Model Class
 * ====================
 * OOP CONCEPT: ENCAPSULATION
 *
 * This class demonstrates Encapsulation by:
 * 1. Declaring all fields as private (data hiding).
 * 2. Providing public getter and setter methods (controlled access).
 * 3. Validating data in setters before accepting values.
 *
 * The Student class represents a registered user of the SlotWise system.
 * Each student has a unique email and a hashed password (never plaintext).
 */
public class Student {

    // --- Private Fields (Encapsulation: data hiding) ---
    private int studentId;
    private String fullName;
    private String email;
    private String passwordHash;
    private java.sql.Timestamp createdAt;
    private String rollNumber = "250701626";
    private String department = "Computer Science and Engineering";
    private String yearOfStudy = "CSE - 2nd Year";
    private boolean taskReminders = true;
    private boolean timetableUpdates = true;
    private boolean weeklySummary = true;
    private String themePreference = "dark";
    private String avatarUrl;

    // --- Constructors ---

    /** Default constructor */
    public Student() {
    }

    /** Parameterized constructor for registration */
    public Student(String fullName, String email, String passwordHash) {
        setFullName(fullName);
        setEmail(email);
        this.passwordHash = passwordHash;
    }

    /** Full constructor including ID (used when reading from database) */
    public Student(int studentId, String fullName, String email,
                   String passwordHash, java.sql.Timestamp createdAt) {
        this.studentId = studentId;
        setFullName(fullName);
        setEmail(email);
        this.passwordHash = passwordHash;
        this.createdAt = createdAt;
    }

    // --- Getters and Setters (Encapsulation: controlled access) ---

    public int getStudentId() {
        return studentId;
    }

    public void setStudentId(int studentId) {
        this.studentId = studentId;
    }

    public String getFullName() {
        return fullName;
    }

    /**
     * Sets the full name after validating it is not null or empty.
     * Demonstrates validation within encapsulation.
     */
    public void setFullName(String fullName) {
        if (fullName == null || fullName.trim().isEmpty()) {
            throw new IllegalArgumentException("Full name cannot be empty.");
        }
        this.fullName = fullName.trim();
    }

    public String getEmail() {
        return email;
    }

    /**
     * Sets the email after basic validation.
     * Demonstrates validation within encapsulation.
     */
    public void setEmail(String email) {
        if (email == null || !email.contains("@")) {
            throw new IllegalArgumentException("Invalid email address.");
        }
        this.email = email.trim().toLowerCase();
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public java.sql.Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(java.sql.Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getRollNumber() {
        return rollNumber != null && !rollNumber.isEmpty() ? rollNumber : "250701626";
    }

    public void setRollNumber(String rollNumber) {
        this.rollNumber = rollNumber;
    }

    public String getDepartment() {
        return department != null && !department.isEmpty() ? department : "Computer Science and Engineering";
    }

    public void setDepartment(String department) {
        this.department = department;
    }

    public String getYearOfStudy() {
        return yearOfStudy != null && !yearOfStudy.isEmpty() ? yearOfStudy : "CSE - 2nd Year";
    }

    public void setYearOfStudy(String yearOfStudy) {
        this.yearOfStudy = yearOfStudy;
    }

    public boolean isTaskReminders() {
        return taskReminders;
    }

    public void setTaskReminders(boolean taskReminders) {
        this.taskReminders = taskReminders;
    }

    public boolean isTimetableUpdates() {
        return timetableUpdates;
    }

    public void setTimetableUpdates(boolean timetableUpdates) {
        this.timetableUpdates = timetableUpdates;
    }

    public boolean isWeeklySummary() {
        return weeklySummary;
    }

    public void setWeeklySummary(boolean weeklySummary) {
        this.weeklySummary = weeklySummary;
    }

    public String getThemePreference() {
        return themePreference != null ? themePreference : "dark";
    }

    public void setThemePreference(String themePreference) {
        this.themePreference = themePreference;
    }

    public String getAvatarUrl() {
        return avatarUrl;
    }

    public void setAvatarUrl(String avatarUrl) {
        this.avatarUrl = avatarUrl;
    }

    @Override
    public String toString() {
        return "Student{id=" + studentId + ", name='" + fullName + "', email='" + email + "'}";
    }
}
