package com.slotwise.dao;

import com.slotwise.model.AbstractGoal;
import com.slotwise.model.StudyHoursGoal;
import com.slotwise.model.TaskCompletionGoal;
import com.slotwise.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * AcademicGoalDAO — Data Access Object for Academic Goals
 * ==========================================================
 * Handles all JDBC CRUD operations for the academic_goals table.
 *
 * POLYMORPHISM:
 *   The mapRow() method inspects the goal_type column and instantiates
 *   the correct subclass (StudyHoursGoal or TaskCompletionGoal),
 *   demonstrating runtime polymorphism through factory-style mapping.
 *
 * JDBC:
 *   All queries use PreparedStatement. Queries filter by student_id
 *   to prevent data leakage between students.
 */
public class AcademicGoalDAO {

    /**
     * CREATE (INSERT): Adds a new academic goal.
     *
     * @param goal the goal to insert (can be any AbstractGoal subclass)
     * @return generated goal_id, or -1 on failure
     */
    public int createGoal(AbstractGoal goal) throws SQLException {
        String sql = "INSERT INTO academic_goals "
                   + "(student_id, title, description, goal_type, target_value, current_value, deadline, status) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, goal.getStudentId());
            stmt.setString(2, goal.getTitle());
            stmt.setString(3, goal.getDescription());
            stmt.setString(4, goal.getGoalType().name());
            stmt.setInt(5, goal.getTargetValue());
            stmt.setInt(6, goal.getCurrentValue());
            stmt.setDate(7, goal.getDeadline());
            stmt.setString(8, goal.getStatus().name());

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
     * READ: Gets all goals for a student, ordered by status and deadline.
     */
    public List<AbstractGoal> getGoalsByStudentId(int studentId) throws SQLException {
        String sql = "SELECT * FROM academic_goals WHERE student_id = ? "
                   + "ORDER BY FIELD(status, 'AT_RISK', 'IN_PROGRESS', 'ON_TRACK', 'COMPLETED'), deadline ASC";
        List<AbstractGoal> goals = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, studentId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) goals.add(mapRow(rs));
            }
        }
        return goals;
    }

    /**
     * READ: Gets a single goal by ID with ownership check.
     */
    public AbstractGoal getGoalById(int goalId, int studentId) throws SQLException {
        String sql = "SELECT * FROM academic_goals WHERE goal_id = ? AND student_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, goalId);
            stmt.setInt(2, studentId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        }
        return null;
    }

    /**
     * COUNT: Returns number of completed goals.
     */
    public int countCompletedGoals(int studentId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM academic_goals WHERE student_id = ? AND status = 'COMPLETED'";
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
     * COUNT: Returns total number of goals.
     */
    public int countTotalGoals(int studentId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM academic_goals WHERE student_id = ?";
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
     * UPDATE: Updates an existing goal's title, description, values, and status.
     *
     * @param goal the goal with updated fields
     * @return true if update was successful
     */
    public boolean updateGoal(AbstractGoal goal) throws SQLException {
        String sql = "UPDATE academic_goals SET title = ?, description = ?, target_value = ?, "
                   + "current_value = ?, deadline = ?, status = ? "
                   + "WHERE goal_id = ? AND student_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, goal.getTitle());
            stmt.setString(2, goal.getDescription());
            stmt.setInt(3, goal.getTargetValue());
            stmt.setInt(4, goal.getCurrentValue());
            stmt.setDate(5, goal.getDeadline());
            stmt.setString(6, goal.getStatus().name());
            stmt.setInt(7, goal.getGoalId());
            stmt.setInt(8, goal.getStudentId());

            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * DELETE: Removes a goal with ownership check.
     */
    public boolean deleteGoal(int goalId, int studentId) throws SQLException {
        String sql = "DELETE FROM academic_goals WHERE goal_id = ? AND student_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, goalId);
            stmt.setInt(2, studentId);
            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * POLYMORPHISM: Factory-style mapRow — instantiates the correct
     * AbstractGoal subclass based on the goal_type column.
     */
    private AbstractGoal mapRow(ResultSet rs) throws SQLException {
        String typeStr = rs.getString("goal_type");
        AbstractGoal.GoalType type;
        try { type = AbstractGoal.GoalType.valueOf(typeStr); }
        catch (Exception e) { type = AbstractGoal.GoalType.CUSTOM; }

        // Create the appropriate subclass (Polymorphism)
        AbstractGoal goal;
        switch (type) {
            case STUDY_HOURS:     goal = new StudyHoursGoal();     break;
            case TASK_COMPLETION: goal = new TaskCompletionGoal(); break;
            default:              goal = new TaskCompletionGoal(); break; // generic fallback
        }

        goal.setGoalId(rs.getInt("goal_id"));
        goal.setStudentId(rs.getInt("student_id"));
        goal.setTitle(rs.getString("title"));
        goal.setDescription(rs.getString("description"));
        goal.setGoalType(type);
        goal.setTargetValue(rs.getInt("target_value"));
        goal.setCurrentValue(rs.getInt("current_value"));
        goal.setDeadline(rs.getDate("deadline"));
        goal.setStatusFromString(rs.getString("status"));
        goal.setCreatedAt(rs.getTimestamp("created_at"));
        goal.setUpdatedAt(rs.getTimestamp("updated_at"));

        return goal;
    }
}
