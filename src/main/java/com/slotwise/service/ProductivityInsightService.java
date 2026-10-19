package com.slotwise.service;

import com.slotwise.dao.TaskDAO;
import com.slotwise.dao.StudySessionDAO;
import com.slotwise.dao.AcademicGoalDAO;
import com.slotwise.model.AbstractGoal;
import com.slotwise.model.Task;

import java.sql.SQLException;
import java.util.*;

/**
 * ProductivityInsightService — Rule-Based Insight Generator
 * ===========================================================
 * OOP CONCEPTS: ENCAPSULATION + POLYMORPHISM
 *
 * Generates meaningful, data-driven productivity insights by
 * analyzing actual database records using business rules.
 *
 * IMPORTANT: This is purely rule-based logic. No AI/ML model
 * is used. Insights are generated only when supported by data.
 *
 * POLYMORPHISM: Uses the ProgressCalculable interface to interact
 * with AbstractGoal subclasses without knowing their concrete type.
 *
 * ENCAPSULATION: All insight logic is private; only the public
 * generateInsights() method is exposed to callers.
 */
public class ProductivityInsightService {

    /**
     * Inner class representing a single productivity insight.
     * ENCAPSULATION: Fields are private with getters.
     */
    public static class Insight {
        private final String icon;
        private final String title;
        private final String detail;
        private final String type; // "positive", "warning", "info", "streak"

        public Insight(String icon, String title, String detail, String type) {
            this.icon   = icon;
            this.title  = title;
            this.detail = detail;
            this.type   = type;
        }

        public String getIcon()   { return icon;   }
        public String getTitle()  { return title;  }
        public String getDetail() { return detail; }
        public String getType()   { return type;   }
    }

    private final TaskDAO taskDAO = new TaskDAO();
    private final StudySessionDAO sessionDAO = new StudySessionDAO();
    private final AcademicGoalDAO goalDAO = new AcademicGoalDAO();

    /**
     * Generates a list of productivity insights for a student.
     * Each insight is backed by real data — none are fabricated.
     *
     * @param studentId the student's ID
     * @return list of insights (may be empty if no data exists)
     */
    public List<Insight> generateInsights(int studentId) throws SQLException {
        List<Insight> insights = new ArrayList<>();

        // --- Insight 1: Study hours comparison vs last week ---
        int thisWeekMinutes  = sessionDAO.getTotalWeeklyMinutes(studentId);
        int lastWeekMinutes  = sessionDAO.getPreviousWeeklyMinutes(studentId);

        if (thisWeekMinutes > 0 || lastWeekMinutes > 0) {
            if (lastWeekMinutes > 0 && thisWeekMinutes > lastWeekMinutes) {
                int increase = (int) Math.round(
                    ((thisWeekMinutes - lastWeekMinutes) * 100.0) / lastWeekMinutes
                );
                double thisH = Math.round(thisWeekMinutes / 60.0 * 10) / 10.0;
                double lastH = Math.round(lastWeekMinutes / 60.0 * 10) / 10.0;
                insights.add(new Insight(
                    "&#128200;",
                    "Your study time increased by " + increase + "%",
                    "You studied " + thisH + " hours this week compared to " + lastH + " hours last week.",
                    "positive"
                ));
            } else if (lastWeekMinutes > 0 && thisWeekMinutes < lastWeekMinutes) {
                double thisH = Math.round(thisWeekMinutes / 60.0 * 10) / 10.0;
                double lastH = Math.round(lastWeekMinutes / 60.0 * 10) / 10.0;
                insights.add(new Insight(
                    "&#9201;",
                    "Study time decreased this week",
                    "You studied " + thisH + " hours this week vs " + lastH + " last week. Try to catch up!",
                    "warning"
                ));
            }
        }

        // --- Insight 2: Subject with least study time ---
        Map<String, Integer> subjectMinutes = sessionDAO.getStudyMinutesBySubject(studentId);
        if (!subjectMinutes.isEmpty()) {
            Map.Entry<String, Integer> least = null;
            for (Map.Entry<String, Integer> entry : subjectMinutes.entrySet()) {
                if (least == null || entry.getValue() < least.getValue()) {
                    least = entry;
                }
            }
            if (least != null && least.getValue() < 120) {
                double hrs = Math.round(least.getValue() / 60.0 * 10) / 10.0;
                insights.add(new Insight(
                    "&#128218;",
                    "Focus more on " + least.getKey(),
                    "You spent only " + hrs + " hour(s) on this subject. Consider increasing study time.",
                    "warning"
                ));
            }
        }

        // --- Insight 3: Overdue tasks warning ---
        int overdue = taskDAO.countOverdueTasks(studentId);
        if (overdue > 0) {
            insights.add(new Insight(
                "&#9888;",
                "You have " + overdue + " overdue task" + (overdue > 1 ? "s" : ""),
                "Address these immediately to avoid falling further behind.",
                "warning"
            ));
        }

        // --- Insight 4: Goal close to completion ---
        List<AbstractGoal> goals = goalDAO.getGoalsByStudentId(studentId);
        for (AbstractGoal goal : goals) {
            // POLYMORPHISM: calling calculateProgressPercent() on abstract type
            int pct = goal.calculateProgressPercent();
            if (pct >= 80 && pct < 100 && goal.getStatus() != AbstractGoal.GoalStatus.COMPLETED) {
                int remaining = goal.getTargetValue() - goal.getCurrentValue();
                insights.add(new Insight(
                    "&#127919;",
                    "You're close to your goal!",
                    "Only " + remaining + " more unit(s) needed to complete: \"" + goal.getTitle() + "\".",
                    "positive"
                ));
                break; // Show max one "close goal" insight
            }
        }

        // --- Insight 5: Weekly study goal reached ---
        if (thisWeekMinutes >= 20 * 60) { // 20 hours = 1200 minutes
            double hrs = Math.round(thisWeekMinutes / 60.0 * 10) / 10.0;
            insights.add(new Insight(
                "&#128293;",
                "Weekly study goal reached!",
                "You've logged " + hrs + " hours this week. Keep it up!",
                "streak"
            ));
        }

        // --- Insight 6: Tasks nearing deadline (within 2 days) ---
        List<Task> allTasks = taskDAO.getTasksByStudentId(studentId);
        long now = System.currentTimeMillis();
        int nearDeadline = 0;
        for (Task t : allTasks) {
            if (t.getDeadline() != null && t.getStatus() != Task.Status.COMPLETED) {
                long daysLeft = (t.getDeadline().getTime() - now) / (1000L * 60 * 60 * 24);
                if (daysLeft >= 0 && daysLeft <= 2) nearDeadline++;
            }
        }
        if (nearDeadline > 0) {
            insights.add(new Insight(
                "&#128338;",
                nearDeadline + " task" + (nearDeadline > 1 ? "s are" : " is") + " due within 2 days",
                "Prioritize these tasks in your next study session.",
                "warning"
            ));
        }

        // Limit to 4 insights for clean display
        return insights.subList(0, Math.min(insights.size(), 4));
    }
}
