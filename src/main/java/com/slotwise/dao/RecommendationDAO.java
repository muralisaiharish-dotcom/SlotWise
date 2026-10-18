package com.slotwise.dao;

import com.slotwise.model.Recommendation;
import com.slotwise.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * RecommendationDAO — Data Access Object for Recommendation operations
 * =====================================================================
 * Handles MySQL operations for the recommendations table.
 * Demonstrates: INSERT, SELECT with JOIN, DELETE.
 */
public class RecommendationDAO {

    /**
     * INSERT: Saves a new recommendation.
     */
    public int createRecommendation(Recommendation rec) throws SQLException {
        String sql = "INSERT INTO recommendations (student_id, task_id, available_start, "
                   + "available_end, recommended_minutes, reason) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, rec.getStudentId());
            stmt.setInt(2, rec.getTaskId());
            stmt.setTime(3, rec.getAvailableStart());
            stmt.setTime(4, rec.getAvailableEnd());
            stmt.setInt(5, rec.getRecommendedMinutes());
            stmt.setString(6, rec.getReason());

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
     * SELECT with JOIN: Gets recommendations with task details.
     * Demonstrates: INNER JOIN between recommendations and tasks tables.
     */
    public List<Recommendation> getRecommendationsByStudentId(int studentId) throws SQLException {
        String sql = "SELECT r.*, t.title AS task_title, t.priority AS task_priority, "
                   + "t.task_type AS task_type "
                   + "FROM recommendations r "
                   + "INNER JOIN tasks t ON r.task_id = t.task_id "
                   + "WHERE r.student_id = ? "
                   + "ORDER BY r.available_start ASC";

        List<Recommendation> recs = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, studentId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Recommendation rec = new Recommendation();
                    rec.setRecommendationId(rs.getInt("recommendation_id"));
                    rec.setStudentId(rs.getInt("student_id"));
                    rec.setTaskId(rs.getInt("task_id"));
                    rec.setAvailableStart(rs.getTime("available_start"));
                    rec.setAvailableEnd(rs.getTime("available_end"));
                    rec.setRecommendedMinutes(rs.getInt("recommended_minutes"));
                    rec.setReason(rs.getString("reason"));
                    rec.setCreatedAt(rs.getTimestamp("created_at"));
                    rec.setTaskTitle(rs.getString("task_title"));
                    rec.setTaskPriority(rs.getString("task_priority"));
                    rec.setTaskType(rs.getString("task_type"));
                    recs.add(rec);
                }
            }
        }
        return recs;
    }

    /**
     * DELETE: Clears all recommendations for a student.
     * Called before generating new recommendations.
     */
    public boolean clearRecommendations(int studentId) throws SQLException {
        String sql = "DELETE FROM recommendations WHERE student_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, studentId);
            stmt.executeUpdate();
            return true;
        }
    }
}
