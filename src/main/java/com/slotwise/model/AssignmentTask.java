package com.slotwise.model;

import java.sql.Date;

/**
 * AssignmentTask — Subclass of Task
 * ===================================
 * OOP CONCEPT: INHERITANCE and POLYMORPHISM
 *
 * This class INHERITS from Task and represents academic assignments
 * (homework, problem sets, written reports, etc.).
 *
 * INHERITANCE: Reuses all fields and methods from the Task base class.
 *
 * POLYMORPHISM: Overrides calculatePriorityScore() to add bonus points
 * for assignments, since they often have strict submission deadlines
 * and penalties for late submission.
 */
public class AssignmentTask extends Task {

    public AssignmentTask() {
        super();
        setTaskType(TaskType.ASSIGNMENT);
    }

    public AssignmentTask(int studentId, String title, String description,
                          Priority priority, int estimatedMinutes, Date deadline) {
        super(studentId, title, description, TaskType.ASSIGNMENT,
              priority, estimatedMinutes, deadline);
    }

    /**
     * POLYMORPHISM: Overrides the base class method.
     *
     * Assignments get a +10 urgency bonus because they typically have
     * strict submission deadlines with grade penalties for late work.
     * This ensures assignments are prioritized in the Smart Planner.
     */
    @Override
    public int calculatePriorityScore() {
        int baseScore = super.calculatePriorityScore();
        // Assignments have strict deadlines — add urgency bonus
        return baseScore + 10;
    }

    /**
     * POLYMORPHISM: Returns a specific label for assignment tasks.
     */
    @Override
    public String getTaskTypeLabel() {
        return "Assignment";
    }
}
