package com.slotwise.dao;

import com.slotwise.model.Student;
import com.slotwise.util.DBConnection;

import java.sql.*;

/**
 * StudentDAO — Data Access Object for Student operations
 * ========================================================
 * Handles all MySQL CRUD operations for the students table.
 *
 * JDBC USAGE:
 * - Uses PreparedStatement to prevent SQL injection.
 * - Uses try-with-resources for automatic resource cleanup.
 * - Demonstrates INSERT, SELECT operations.
 */
public class StudentDAO {

    /**
     * INSERT: Registers a new student in the database.
     * Demonstrates: PreparedStatement INSERT with generated keys.
     *
     * @param student The student object to insert
     * @return The generated student_id, or -1 on failure
     */
    public int createStudent(Student student) throws SQLException {
        String sql = "INSERT INTO students (full_name, email, password_hash) VALUES (?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, student.getFullName());
            stmt.setString(2, student.getEmail());
            stmt.setString(3, student.getPasswordHash());

            int rows = stmt.executeUpdate();
            if (rows > 0) {
                try (ResultSet keys = stmt.getGeneratedKeys()) {
                    if (keys.next()) {
                        return keys.getInt(1);
                    }
                }
            }
        }
        return -1;
    }

    /**
     * SELECT: Finds a student by email address.
     * Used during login to verify credentials.
     * Demonstrates: PreparedStatement SELECT with WHERE clause.
     *
     * @param email The email to search for
     * @return Student object, or null if not found
     */
    public Student findByEmail(String email) throws SQLException {
        String sql = "SELECT student_id, full_name, email, password_hash, created_at, "
                   + "roll_number, department, year_of_study, task_reminders, "
                   + "timetable_updates, weekly_summary, theme_preference, avatar_url "
                   + "FROM students WHERE email = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email.trim().toLowerCase());

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        }
        return null;
    }

    /**
     * SELECT: Finds a student by ID.
     * Used for session validation and profile display.
     *
     * @param studentId The student's primary key
     * @return Student object, or null if not found
     */
    public Student findById(int studentId) throws SQLException {
        String sql = "SELECT student_id, full_name, email, password_hash, created_at, "
                   + "roll_number, department, year_of_study, task_reminders, "
                   + "timetable_updates, weekly_summary, theme_preference, avatar_url "
                   + "FROM students WHERE student_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, studentId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        }
        return null;
    }

    /**
     * SELECT: Checks if an email already exists in the database.
     * Used during registration to enforce unique emails.
     *
     * @param email The email to check
     * @return true if the email is already registered
     */
    public boolean emailExists(String email) throws SQLException {
        String sql = "SELECT COUNT(*) FROM students WHERE email = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email.trim().toLowerCase());

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    /**
     * UPDATE: Updates a student's profile information.
     *
     * @param student The student with updated fields
     * @return true if the update was successful
     */
    public boolean updateStudent(Student student) throws SQLException {
        String sql = "UPDATE students SET full_name = ?, email = ?, roll_number = ?, "
                   + "department = ?, year_of_study = ? WHERE student_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, student.getFullName());
            stmt.setString(2, student.getEmail());
            stmt.setString(3, student.getRollNumber());
            stmt.setString(4, student.getDepartment());
            stmt.setString(5, student.getYearOfStudy());
            stmt.setInt(6, student.getStudentId());

            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * UPDATE: Updates a student's notification preferences.
     */
    public boolean updateNotificationPreferences(int studentId, boolean taskReminders,
                                                 boolean timetableUpdates, boolean weeklySummary) throws SQLException {
        String sql = "UPDATE students SET task_reminders = ?, timetable_updates = ?, weekly_summary = ? WHERE student_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setBoolean(1, taskReminders);
            stmt.setBoolean(2, timetableUpdates);
            stmt.setBoolean(3, weeklySummary);
            stmt.setInt(4, studentId);

            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * UPDATE: Updates a student's appearance theme preference.
     */
    public boolean updateThemePreference(int studentId, String theme) throws SQLException {
        String sql = "UPDATE students SET theme_preference = ? WHERE student_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, theme);
            stmt.setInt(2, studentId);

            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * UPDATE: Updates a student's password hash.
     */
    public boolean updatePassword(int studentId, String newPasswordHash) throws SQLException {
        String sql = "UPDATE students SET password_hash = ? WHERE student_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, newPasswordHash);
            stmt.setInt(2, studentId);

            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * Maps a ResultSet row to a Student object.
     */
    private Student mapRow(ResultSet rs) throws SQLException {
        Student s = new Student(
            rs.getInt("student_id"),
            rs.getString("full_name"),
            rs.getString("email"),
            rs.getString("password_hash"),
            rs.getTimestamp("created_at")
        );

        try {
            s.setRollNumber(rs.getString("roll_number"));
            s.setDepartment(rs.getString("department"));
            s.setYearOfStudy(rs.getString("year_of_study"));
            s.setTaskReminders(rs.getBoolean("task_reminders"));
            s.setTimetableUpdates(rs.getBoolean("timetable_updates"));
            s.setWeeklySummary(rs.getBoolean("weekly_summary"));
            s.setThemePreference(rs.getString("theme_preference"));
            s.setAvatarUrl(rs.getString("avatar_url"));
        } catch (SQLException ignored) {
            // Fallback gracefully if columns are not present
        }

        return s;
    }
}
