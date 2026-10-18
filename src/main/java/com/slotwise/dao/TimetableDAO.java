package com.slotwise.dao;

import com.slotwise.model.TimetableEntry;
import com.slotwise.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * TimetableDAO — Data Access Object for Timetable CRUD operations
 * =================================================================
 * Handles all MySQL CRUD operations for the timetable_entries table.
 *
 * JDBC USAGE:
 * - INSERT, SELECT, UPDATE, DELETE with PreparedStatement.
 * - Overlap detection query using SQL time comparisons.
 * - Uses try-with-resources for automatic resource cleanup.
 */
public class TimetableDAO {

    /**
     * CREATE (INSERT): Adds a new timetable entry.
     *
     * @param entry The timetable entry to insert
     * @return The generated timetable_id, or -1 on failure
     */
    public int createEntry(TimetableEntry entry) throws SQLException {
        String sql = "INSERT INTO timetable_entries (student_id, subject_name, room_number, "
                   + "day_of_week, start_time, end_time) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, entry.getStudentId());
            stmt.setString(2, entry.getSubjectName());
            stmt.setString(3, entry.getRoomNumber());
            stmt.setString(4, entry.getDayOfWeek());
            stmt.setTime(5, entry.getStartTime());
            stmt.setTime(6, entry.getEndTime());

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
     * READ (SELECT): Gets all timetable entries for a student.
     * Demonstrates: SELECT with ORDER BY multiple columns.
     */
    public List<TimetableEntry> getEntriesByStudentId(int studentId) throws SQLException {
        String sql = "SELECT * FROM timetable_entries WHERE student_id = ? "
                   + "ORDER BY FIELD(day_of_week, 'Monday','Tuesday','Wednesday',"
                   + "'Thursday','Friday','Saturday','Sunday'), start_time ASC";

        List<TimetableEntry> entries = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, studentId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    entries.add(mapRow(rs));
                }
            }
        }
        return entries;
    }

    /**
     * READ (SELECT): Gets timetable entries for a specific day.
     * Used by the Smart Planner to identify occupied time slots.
     */
    public List<TimetableEntry> getEntriesByDay(int studentId, String dayOfWeek) throws SQLException {
        String sql = "SELECT * FROM timetable_entries WHERE student_id = ? "
                   + "AND day_of_week = ? ORDER BY start_time ASC";

        List<TimetableEntry> entries = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, studentId);
            stmt.setString(2, dayOfWeek);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    entries.add(mapRow(rs));
                }
            }
        }
        return entries;
    }

    /**
     * READ (SELECT): Gets a single entry by ID with ownership check.
     */
    public TimetableEntry getEntryById(int timetableId, int studentId) throws SQLException {
        String sql = "SELECT * FROM timetable_entries WHERE timetable_id = ? AND student_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, timetableId);
            stmt.setInt(2, studentId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        }
        return null;
    }

    /**
     * UPDATE: Updates an existing timetable entry.
     */
    public boolean updateEntry(TimetableEntry entry) throws SQLException {
        String sql = "UPDATE timetable_entries SET subject_name = ?, room_number = ?, "
                   + "day_of_week = ?, start_time = ?, end_time = ? "
                   + "WHERE timetable_id = ? AND student_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, entry.getSubjectName());
            stmt.setString(2, entry.getRoomNumber());
            stmt.setString(3, entry.getDayOfWeek());
            stmt.setTime(4, entry.getStartTime());
            stmt.setTime(5, entry.getEndTime());
            stmt.setInt(6, entry.getTimetableId());
            stmt.setInt(7, entry.getStudentId());

            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * DELETE: Removes a timetable entry.
     */
    public boolean deleteEntry(int timetableId, int studentId) throws SQLException {
        String sql = "DELETE FROM timetable_entries WHERE timetable_id = ? AND student_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, timetableId);
            stmt.setInt(2, studentId);

            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * OVERLAP DETECTION: Checks if a new entry overlaps with existing entries.
     * Two time ranges overlap if: start1 < end2 AND start2 < end1.
     *
     * @param studentId  The student's ID
     * @param dayOfWeek  The day to check
     * @param startTime  The proposed start time
     * @param endTime    The proposed end time
     * @param excludeId  Entry ID to exclude (for updates), use -1 for new entries
     * @return true if there is an overlap
     */
    public boolean hasOverlap(int studentId, String dayOfWeek,
                              Time startTime, Time endTime, int excludeId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM timetable_entries "
                   + "WHERE student_id = ? AND day_of_week = ? "
                   + "AND start_time < ? AND end_time > ? "
                   + "AND timetable_id != ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, studentId);
            stmt.setString(2, dayOfWeek);
            stmt.setTime(3, endTime);
            stmt.setTime(4, startTime);
            stmt.setInt(5, excludeId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    /** Counts total classes for a student */
    public int countEntries(int studentId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM timetable_entries WHERE student_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, studentId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    /** Counts classes for a specific day */
    public int countEntriesByDay(int studentId, String dayOfWeek) throws SQLException {
        String sql = "SELECT COUNT(*) FROM timetable_entries WHERE student_id = ? AND day_of_week = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, studentId);
            stmt.setString(2, dayOfWeek);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    /**
     * Maps a ResultSet row to a TimetableEntry object.
     */
    private TimetableEntry mapRow(ResultSet rs) throws SQLException {
        TimetableEntry entry = new TimetableEntry();
        entry.setTimetableId(rs.getInt("timetable_id"));
        entry.setStudentId(rs.getInt("student_id"));
        entry.setSubjectName(rs.getString("subject_name"));
        entry.setRoomNumber(rs.getString("room_number"));
        entry.setDayOfWeek(rs.getString("day_of_week"));
        entry.setStartTime(rs.getTime("start_time"));
        entry.setEndTime(rs.getTime("end_time"));
        entry.setCreatedAt(rs.getTimestamp("created_at"));
        return entry;
    }
}
