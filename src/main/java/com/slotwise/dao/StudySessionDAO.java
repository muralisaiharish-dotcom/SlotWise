package com.slotwise.dao;

import com.slotwise.model.StudySession;
import com.slotwise.util.DBConnection;

import java.sql.*;
import java.util.*;

/**
 * StudySessionDAO — Data Access Object for Study Sessions
 * =========================================================
 * Handles all JDBC CRUD operations for the study_sessions table.
 *
 * JDBC USAGE:
 * - INSERT, SELECT with PreparedStatement to prevent SQL injection.
 * - Uses try-with-resources for automatic connection cleanup.
 * - Uses GROUP BY / SUM aggregation for computing daily study hours.
 *
 * All queries filter by student_id for data security.
 */
public class StudySessionDAO {

    /**
     * CREATE (INSERT): Logs a new study session.
     *
     * @param session the session to insert
     * @return generated session_id, or -1 on failure
     */
    public int createSession(StudySession session) throws SQLException {
        String sql = "INSERT INTO study_sessions (student_id, subject_name, session_date, duration_minutes, notes) "
                   + "VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, session.getStudentId());
            stmt.setString(2, session.getSubjectName());
            stmt.setDate(3, session.getSessionDate());
            stmt.setInt(4, session.getDurationMinutes());
            stmt.setString(5, session.getNotes());

            int rows = stmt.executeUpdate();
            if (rows > 0) {
                try (ResultSet keys = stmt.getGeneratedKeys()) {
                    if (keys.next()) return keys.getInt(1);
                }
            }
        }
        return -1;
    }

    /**
     * READ: Gets all study sessions for a student, ordered by date descending.
     *
     * @param studentId the student's ID
     * @return list of study sessions
     */
    public List<StudySession> getSessionsByStudentId(int studentId) throws SQLException {
        String sql = "SELECT * FROM study_sessions WHERE student_id = ? ORDER BY session_date DESC, created_at DESC";
        List<StudySession> sessions = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, studentId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) sessions.add(mapRow(rs));
            }
        }
        return sessions;
    }

    /**
     * READ: Gets recent study sessions (last N records) for the activity feed.
     */
    public List<StudySession> getRecentSessions(int studentId, int limit) throws SQLException {
        String sql = "SELECT * FROM study_sessions WHERE student_id = ? ORDER BY created_at DESC LIMIT ?";
        List<StudySession> sessions = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, studentId);
            stmt.setInt(2, limit);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) sessions.add(mapRow(rs));
            }
        }
        return sessions;
    }

    /**
     * AGGREGATION: Returns total study minutes for each day of the current week.
     * The map key is the day name (e.g., "Monday"), value is total minutes.
     *
     * SQL demonstrates: GROUP BY, SUM, DAYNAME, and date range filtering.
     */
    public Map<String, Integer> getWeeklyStudyMinutes(int studentId) throws SQLException {
        String sql = "SELECT DAYNAME(session_date) AS day_name, SUM(duration_minutes) AS total_minutes "
                   + "FROM study_sessions "
                   + "WHERE student_id = ? "
                   + "  AND session_date >= DATE_SUB(CURDATE(), INTERVAL WEEKDAY(CURDATE()) DAY) "
                   + "  AND session_date <= DATE_ADD(DATE_SUB(CURDATE(), INTERVAL WEEKDAY(CURDATE()) DAY), INTERVAL 6 DAY) "
                   + "GROUP BY DAYNAME(session_date), DAYOFWEEK(session_date) "
                   + "ORDER BY DAYOFWEEK(session_date)";

        // Initialize with 0 for all 7 days
        Map<String, Integer> weeklyMap = new LinkedHashMap<>();
        weeklyMap.put("Monday", 0);
        weeklyMap.put("Tuesday", 0);
        weeklyMap.put("Wednesday", 0);
        weeklyMap.put("Thursday", 0);
        weeklyMap.put("Friday", 0);
        weeklyMap.put("Saturday", 0);
        weeklyMap.put("Sunday", 0);

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, studentId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    String day = rs.getString("day_name");
                    int minutes = rs.getInt("total_minutes");
                    if (weeklyMap.containsKey(day)) {
                        weeklyMap.put(day, minutes);
                    }
                }
            }
        }
        return weeklyMap;
    }

    /**
     * AGGREGATION: Total study minutes for the current week.
     */
    public int getTotalWeeklyMinutes(int studentId) throws SQLException {
        String sql = "SELECT COALESCE(SUM(duration_minutes), 0) FROM study_sessions "
                   + "WHERE student_id = ? "
                   + "  AND session_date >= DATE_SUB(CURDATE(), INTERVAL WEEKDAY(CURDATE()) DAY) "
                   + "  AND session_date <= DATE_ADD(DATE_SUB(CURDATE(), INTERVAL WEEKDAY(CURDATE()) DAY), INTERVAL 6 DAY)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, studentId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return 0;
    }

    /**
     * AGGREGATION: Total study minutes for the previous week (for comparison).
     */
    public int getPreviousWeeklyMinutes(int studentId) throws SQLException {
        String sql = "SELECT COALESCE(SUM(duration_minutes), 0) FROM study_sessions "
                   + "WHERE student_id = ? "
                   + "  AND session_date >= DATE_SUB(DATE_SUB(CURDATE(), INTERVAL WEEKDAY(CURDATE()) DAY), INTERVAL 7 DAY) "
                   + "  AND session_date < DATE_SUB(CURDATE(), INTERVAL WEEKDAY(CURDATE()) DAY)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, studentId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return 0;
    }

    /**
     * AGGREGATION: Returns total study minutes grouped by subject.
     * Used for subject-wise progress bars.
     */
    public Map<String, Integer> getStudyMinutesBySubject(int studentId) throws SQLException {
        String sql = "SELECT subject_name, SUM(duration_minutes) AS total_minutes "
                   + "FROM study_sessions WHERE student_id = ? "
                   + "GROUP BY subject_name ORDER BY total_minutes DESC";

        Map<String, Integer> subjectMap = new LinkedHashMap<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, studentId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    subjectMap.put(rs.getString("subject_name"), rs.getInt("total_minutes"));
                }
            }
        }
        return subjectMap;
    }

    /**
     * DELETE: Removes a study session (ownership-checked).
     */
    public boolean deleteSession(int sessionId, int studentId) throws SQLException {
        String sql = "DELETE FROM study_sessions WHERE session_id = ? AND student_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, sessionId);
            stmt.setInt(2, studentId);
            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * Maps a ResultSet row to a StudySession object.
     */
    private StudySession mapRow(ResultSet rs) throws SQLException {
        StudySession s = new StudySession();
        s.setSessionId(rs.getInt("session_id"));
        s.setStudentId(rs.getInt("student_id"));
        s.setSubjectName(rs.getString("subject_name"));
        s.setSessionDate(rs.getDate("session_date"));
        s.setDurationMinutes(rs.getInt("duration_minutes"));
        s.setNotes(rs.getString("notes"));
        s.setCreatedAt(rs.getTimestamp("created_at"));
        return s;
    }
}
