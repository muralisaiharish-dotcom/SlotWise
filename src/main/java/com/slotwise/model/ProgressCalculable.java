package com.slotwise.model;

/**
 * ProgressCalculable — Abstraction Interface
 * ============================================
 * OOP CONCEPT: ABSTRACTION
 *
 * Defines a common contract for any object that can calculate
 * a progress percentage and return a status label.
 *
 * This interface is implemented by:
 *   - AbstractGoal (and all its subclasses)
 *
 * By programming to this interface, the ProgressService and
 * ProductivityInsightService can work with any progress-capable
 * object without knowing its concrete type (polymorphism).
 */
public interface ProgressCalculable {

    /**
     * Calculates and returns a completion percentage (0–100).
     * Implementations decide how to compute this based on
     * their specific domain (e.g., tasks, study hours, streaks).
     *
     * @return percentage as an integer, clamped to [0, 100]
     */
    int calculateProgressPercent();

    /**
     * Returns a human-readable status label such as
     * "In Progress", "On Track", "At Risk", or "Completed".
     *
     * @return status string for UI display
     */
    String getStatusLabel();

    /**
     * Returns true when this item's progress is considered complete
     * (i.e., calculateProgressPercent() returns 100).
     *
     * @return true if fully completed
     */
    default boolean isFullyCompleted() {
        return calculateProgressPercent() >= 100;
    }
}
