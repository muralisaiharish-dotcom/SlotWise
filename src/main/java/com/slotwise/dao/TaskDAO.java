package com.slotwise.dao;

import com.slotwise.model.Task;
import com.slotwise.model.TaskFactory;
import com.slotwise.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * TaskDAO — Data Access Object for Task CRUD operations
 * =======================================================
 * Handles all MySQL CRUD operations for the tasks table.
 *
 * JDBC USAGE:
 * - INSERT, SELECT, UPDATE, DELETE with PreparedStatement.
 * - Uses try-with-resources for automatic resource cleanup.
 * - Uses TaskFactory to create correct subclass instances (Polymorphism).
 *
 * SECURITY:
 * - All queries are parameterized to prevent SQL injection.
 * - Ownership checks: queries always filter by student_id.
 */
public class TaskDAO {

    /**
     * CREATE (INSERT): Adds a new task to the database.
     *
     * @param task The task to insert
     * @return The generated task_id, or -1 on failure
     */
    public int createTask(Task task) throws SQLException {
        String sql = "INSERT INTO tasks (student_id, title, description, task_type, "
                   + "priority, estimated_minutes, deadline, status) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, task.getStudentId());
            stmt.setString(2, task.getTitle());
            stmt.setString(3, task.getDescription());
            stmt.setString(4, task.getTaskType().name());
            stmt.setString(5, task.getPriority().name());
            stmt.setInt(6, task.getEstimatedMinutes());
            stmt.setDate(7, task.getDeadline());
            stmt.setString(8, task.getStatus().name());

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
     * READ (SELECT): Gets all tasks for a student.
     * Demonstrates: SELECT with WHERE and ORDER BY.
     *
     * @param studentId The student's ID
     * @return List of tasks belonging to the student
     */
    public List<Task> getTasksByStudentId(int studentId) throws SQLException {
        String sql = "SELECT * FROM tasks WHERE student_id = ? ORDER BY "
                   + "FIELD(priority, 'HIGH', 'MEDIUM', 'LOW'), deadline ASC";

        List<Task> tasks = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, studentId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    tasks.add(mapRow(rs));
                }
            }
        }
        return tasks;
    }

    /**
     * READ (SELECT): Gets a single task by ID, with ownership check.
     * Demonstrates: SELECT with compound WHERE clause.
     *
     * @param taskId    The task's primary key
     * @param studentId The student's ID (ownership check)
     * @return The task, or null if not found or not owned by student
     */
    public Task getTaskById(int taskId, int studentId) throws SQLException {
        String sql = "SELECT * FROM tasks WHERE task_id = ? AND student_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, taskId);
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
     * READ (SELECT): Gets tasks filtered by status.
     * Demonstrates: Dynamic WHERE clause with PreparedStatement.
     */
    public List<Task> getTasksByStatus(int studentId, String status) throws SQLException {
        String sql = "SELECT * FROM tasks WHERE student_id = ? AND status = ? "
                   + "ORDER BY FIELD(priority, 'HIGH', 'MEDIUM', 'LOW'), deadline ASC";

        List<Task> tasks = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, studentId);
            stmt.setString(2, status);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    tasks.add(mapRow(rs));
                }
            }
        }
        return tasks;
    }

    /**
     * READ (SELECT): Gets tasks filtered by priority.
     */
    public List<Task> getTasksByPriority(int studentId, String priority) throws SQLException {
        String sql = "SELECT * FROM tasks WHERE student_id = ? AND priority = ? "
                   + "ORDER BY deadline ASC";

        List<Task> tasks = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, studentId);
            stmt.setString(2, priority);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    tasks.add(mapRow(rs));
                }
            }
        }
        return tasks;
    }

    /**
     * READ (SELECT): Gets only pending/in-progress tasks (not completed).
     * Used by the Smart Planner to find tasks that need scheduling.
     */
    public List<Task> getPendingTasks(int studentId) throws SQLException {
        String sql = "SELECT * FROM tasks WHERE student_id = ? AND status != 'COMPLETED' "
                   + "ORDER BY FIELD(priority, 'HIGH', 'MEDIUM', 'LOW'), deadline ASC";

        List<Task> tasks = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, studentId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    tasks.add(mapRow(rs));
                }
            }
        }
        return tasks;
    }

    /**
     * UPDATE: Updates an existing task.
     * Demonstrates: UPDATE with multiple SET columns and ownership check.
     *
     * @param task The task with updated fields
     * @return true if the update was successful
     */
    public boolean updateTask(Task task) throws SQLException {
        String sql = "UPDATE tasks SET title = ?, description = ?, task_type = ?, "
                   + "priority = ?, estimated_minutes = ?, deadline = ?, status = ? "
                   + "WHERE task_id = ? AND student_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, task.getTitle());
            stmt.setString(2, task.getDescription());
            stmt.setString(3, task.getTaskType().name());
            stmt.setString(4, task.getPriority().name());
            stmt.setInt(5, task.getEstimatedMinutes());
            stmt.setDate(6, task.getDeadline());
            stmt.setString(7, task.getStatus().name());
            stmt.setInt(8, task.getTaskId());
            stmt.setInt(9, task.getStudentId());

            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * DELETE: Removes a task from the database.
     * Demonstrates: DELETE with ownership check.
     *
     * @param taskId    The task's primary key
     * @param studentId The student's ID (ownership check)
     * @return true if the deletion was successful
     */
    public boolean deleteTask(int taskId, int studentId) throws SQLException {
        String sql = "DELETE FROM tasks WHERE task_id = ? AND student_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, taskId);
            stmt.setInt(2, studentId);

            return stmt.executeUpdate() > 0;
        }
    }

    // --- Progress/Statistics queries ---

    /** Counts total tasks for a student */
    public int countTotalTasks(int studentId) throws SQLException {
        return countByCondition(studentId, "1=1");
    }

    /** Counts pending tasks */
    public int countPendingTasks(int studentId) throws SQLException {
        return countByCondition(studentId, "status = 'PENDING'");
    }

    /** Counts in-progress tasks */
    public int countInProgressTasks(int studentId) throws SQLException {
        return countByCondition(studentId, "status = 'IN_PROGRESS'");
    }

    /** Counts completed tasks */
    public int countCompletedTasks(int studentId) throws SQLException {
        return countByCondition(studentId, "status = 'COMPLETED'");
    }

    /** Counts overdue tasks (past deadline and not completed) */
    public int countOverdueTasks(int studentId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM tasks WHERE student_id = ? "
                   + "AND status != 'COMPLETED' AND deadline < CURDATE()";

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

    private int countByCondition(int studentId, String condition) throws SQLException {
        String sql = "SELECT COUNT(*) FROM tasks WHERE student_id = ? AND " + condition;

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

    /**
     * Maps a ResultSet row to a Task object using TaskFactory.
     * This enables polymorphism: the correct subclass is instantiated
     * based on the task_type column value.
     */
    private Task mapRow(ResultSet rs) throws SQLException {
        // Use TaskFactory to create the correct subclass (Polymorphism)
        String taskType = rs.getString("task_type");
        Task task = TaskFactory.createTask(taskType);

        task.setTaskId(rs.getInt("task_id"));
        task.setStudentId(rs.getInt("student_id"));
        task.setTitle(rs.getString("title"));
        task.setDescription(rs.getString("description"));
        task.setTaskTypeFromString(taskType);
        task.setPriorityFromString(rs.getString("priority"));
        task.setEstimatedMinutes(rs.getInt("estimated_minutes"));
        task.setDeadline(rs.getDate("deadline"));
        task.setStatusFromString(rs.getString("status"));
        task.setCreatedAt(rs.getTimestamp("created_at"));

        return task;
    }
}
