package com.slotwise.service;

import com.slotwise.dao.TaskDAO;

import java.sql.SQLException;

/**
 * ProgressService — Progress Tracking Business Logic
 * =====================================================
 * Calculates student progress statistics from actual database records.
 * No hardcoded values — all data comes from MySQL.
 */
public class ProgressService {

    private final TaskDAO taskDAO = new TaskDAO();

    private int totalTasks;
    private int pendingTasks;
    private int inProgressTasks;
    private int completedTasks;
    private int overdueTasks;
    private double completionPercentage;

    /**
     * Loads all progress statistics for a student from the database.
     */
    public void loadProgress(int studentId) throws SQLException {
        this.totalTasks = taskDAO.countTotalTasks(studentId);
        this.pendingTasks = taskDAO.countPendingTasks(studentId);
        this.inProgressTasks = taskDAO.countInProgressTasks(studentId);
        this.completedTasks = taskDAO.countCompletedTasks(studentId);
        this.overdueTasks = taskDAO.countOverdueTasks(studentId);

        if (totalTasks > 0) {
            this.completionPercentage = Math.round(
                ((double) completedTasks / totalTasks) * 100.0 * 10
            ) / 10.0;
        } else {
            this.completionPercentage = 0.0;
        }
    }

    // --- Getters ---
    public int getTotalTasks() { return totalTasks; }
    public int getPendingTasks() { return pendingTasks; }
    public int getInProgressTasks() { return inProgressTasks; }
    public int getCompletedTasks() { return completedTasks; }
    public int getOverdueTasks() { return overdueTasks; }
    public double getCompletionPercentage() { return completionPercentage; }

    /** Returns completion percentage as an integer for CSS width */
    public int getCompletionPercentageInt() {
        return (int) Math.round(completionPercentage);
    }
}
