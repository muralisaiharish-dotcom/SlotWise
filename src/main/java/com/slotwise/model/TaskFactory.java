package com.slotwise.model;

/**
 * TaskFactory — Factory Method Pattern
 * ======================================
 * OOP CONCEPT: POLYMORPHISM (used in factory method)
 *
 * This factory creates the appropriate Task subclass based on the
 * task type string from the database or form submission.
 *
 * When reading tasks from the database, this ensures each task is
 * instantiated as its correct subclass (AssignmentTask, ExamPreparationTask,
 * or LabTask), enabling polymorphic behavior when calculatePriorityScore()
 * is called.
 */
public class TaskFactory {

    /**
     * Creates the appropriate Task subclass based on the type string.
     *
     * @param taskType The task type string (e.g., "ASSIGNMENT", "EXAM_PREP", "LAB")
     * @return A Task object of the appropriate subclass
     */
    public static Task createTask(String taskType) {
        if (taskType == null) {
            return new Task();
        }

        switch (taskType.toUpperCase()) {
            case "ASSIGNMENT":
                return new AssignmentTask();
            case "EXAM_PREP":
                return new ExamPreparationTask();
            case "LAB":
                return new LabTask();
            default:
                return new Task();
        }
    }
}
