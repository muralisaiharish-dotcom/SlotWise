package com.slotwise.model;

/**
 * StudyHoursGoal — Concrete Goal Subclass
 * ==========================================
 * OOP CONCEPTS: INHERITANCE + POLYMORPHISM
 *
 * INHERITANCE:
 *   Extends AbstractGoal, inheriting all fields and methods.
 *   Adds study-hours-specific behavior.
 *
 * POLYMORPHISM:
 *   Overrides calculateProgressPercent() to handle the case
 *   where currentValue represents hours (not percent), and
 *   overrides getStatusLabel() to provide meaningful study labels.
 *
 * Use case: "Study 20 hours this week" — targetValue = 20 hours,
 *            currentValue = hours actually logged.
 */
public class StudyHoursGoal extends AbstractGoal {

    public StudyHoursGoal() {
        super();
        setGoalType(GoalType.STUDY_HOURS);
    }

    public StudyHoursGoal(int studentId, String title,
                          int targetHours, int currentHours) {
        super(studentId, title, GoalType.STUDY_HOURS, targetHours, currentHours);
    }

    /**
     * POLYMORPHISM: Override — percentage is currentHours / targetHours.
     * Same formula as base, but semantically tied to hours.
     */
    @Override
    public int calculateProgressPercent() {
        // Uses same formula — hours / target hours × 100
        return super.calculateProgressPercent();
    }

    /**
     * POLYMORPHISM: Override — returns hours-specific status labels.
     */
    @Override
    public String getStatusLabel() {
        int percent = calculateProgressPercent();
        if (percent >= 100)  return "Completed";
        if (percent >= 80)   return "On Track";
        if (percent >= 50)   return "In Progress";
        return "At Risk";
    }
}
