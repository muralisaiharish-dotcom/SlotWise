package com.slotwise.model;

import java.util.List;

/**
 * TaskSchedulingStrategy Interface
 * ==================================
 * OOP CONCEPT: ABSTRACTION
 *
 * This interface defines the CONTRACT for any scheduling strategy.
 * It uses ABSTRACTION to hide the implementation details of how
 * tasks are scheduled — callers only need to know WHAT methods
 * are available, not HOW they work internally.
 *
 * Any class implementing this interface must provide concrete
 * implementations for all declared methods.
 *
 * This enables the system to support different scheduling algorithms
 * in the future without changing the code that uses them.
 *
 * Current implementations:
 *   - SmartPlannerService (rule-based scheduling)
 *
 * Potential future implementations could include:
 *   - GreedyScheduler
 *   - WeightedScheduler
 */
public interface TaskSchedulingStrategy {

    /**
     * Calculates available free-time slots for a student on a given day,
     * based on their timetable entries.
     *
     * @param studentId  The student's ID
     * @param dayOfWeek  The day to analyze (e.g., "Monday")
     * @return List of FreeTimeSlot objects representing available gaps
     */
    List<FreeTimeSlot> findFreeSlots(int studentId, String dayOfWeek);

    /**
     * Generates task recommendations by matching pending tasks
     * to available free-time slots.
     *
     * @param studentId  The student's ID
     * @param dayOfWeek  The day to plan for
     * @return List of Recommendation objects
     */
    List<Recommendation> generateRecommendations(int studentId, String dayOfWeek);

    /**
     * Sorts and ranks tasks by their priority score.
     * Uses polymorphism: each task subclass calculates its own score.
     *
     * @param tasks List of tasks to rank
     * @return Sorted list with highest-priority tasks first
     */
    List<Task> rankTasksByPriority(List<Task> tasks);
}
