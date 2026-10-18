package com.slotwise.model;

import java.sql.Date;

/**
 * LabTask — Subclass of Task
 * ============================
 * OOP CONCEPT: INHERITANCE and POLYMORPHISM
 *
 * This class INHERITS from Task and represents lab experiment work
 * (writing observations, coding exercises, preparing lab records, etc.).
 *
 * INHERITANCE: Reuses all fields and methods from the Task base class.
 *
 * POLYMORPHISM: Overrides calculatePriorityScore() because lab tasks
 * are generally less urgent than assignments or exams, but still need
 * to be completed before the next lab session. Lab tasks receive a
 * smaller priority boost compared to assignments.
 */
public class LabTask extends Task {

    public LabTask() {
        super();
        setTaskType(TaskType.LAB);
    }

    public LabTask(int studentId, String title, String description,
                   Priority priority, int estimatedMinutes, Date deadline) {
        super(studentId, title, description, TaskType.LAB,
              priority, estimatedMinutes, deadline);
    }

    /**
     * POLYMORPHISM: Overrides the base class method.
     *
     * Lab tasks get a smaller urgency boost (+5) compared to assignments
     * and exam prep, since lab records can often be partially completed
     * and submitted incrementally. However, if the lab task is HIGH
     * priority, it gets an extra boost.
     */
    @Override
    public int calculatePriorityScore() {
        int baseScore = super.calculatePriorityScore();
        if (getPriority() == Priority.HIGH) {
            return baseScore + 8;
        }
        return baseScore + 5;
    }

    /**
     * POLYMORPHISM: Returns a specific label for lab tasks.
     */
    @Override
    public String getTaskTypeLabel() {
        return "Lab Work";
    }
}
