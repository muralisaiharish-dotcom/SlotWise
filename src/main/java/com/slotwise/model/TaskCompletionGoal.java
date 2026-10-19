package com.slotwise.model;

/**
 * TaskCompletionGoal — Concrete Goal Subclass
 * ==============================================
 * OOP CONCEPTS: INHERITANCE + POLYMORPHISM
 *
 * INHERITANCE:
 *   Extends AbstractGoal, reusing all base class fields/methods.
 *
 * POLYMORPHISM:
 *   Overrides getStatusLabel() to return task-completion-specific
 *   status messages, giving a different label than the base class.
 *
 * Use case: "Complete 10 tasks this semester" — targetValue = 10,
 *            currentValue = tasks completed so far.
 */
public class TaskCompletionGoal extends AbstractGoal {

    public TaskCompletionGoal() {
        super();
        setGoalType(GoalType.TASK_COMPLETION);
    }

    public TaskCompletionGoal(int studentId, String title,
                              int targetTasks, int completedTasks) {
        super(studentId, title, GoalType.TASK_COMPLETION, targetTasks, completedTasks);
    }

    /**
     * POLYMORPHISM: Override — uses task counts, not hours.
     * Adds a small "effort bonus" for being in progress (at least started).
     */
    @Override
    public int calculateProgressPercent() {
        return super.calculateProgressPercent(); // straightforward ratio
    }

    /**
     * POLYMORPHISM: Override — task-specific status labels.
     */
    @Override
    public String getStatusLabel() {
        int percent = calculateProgressPercent();
        if (percent >= 100) return "Completed";
        if (percent >= 70)  return "On Track";
        if (percent >= 40)  return "In Progress";
        return "At Risk";
    }
}
