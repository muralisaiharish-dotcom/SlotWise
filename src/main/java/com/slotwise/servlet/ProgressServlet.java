package com.slotwise.servlet;

import com.slotwise.dao.AcademicGoalDAO;
import com.slotwise.dao.StudySessionDAO;
import com.slotwise.dao.TaskDAO;
import com.slotwise.model.AbstractGoal;
import com.slotwise.model.StudySession;
import com.slotwise.model.Task;
import com.slotwise.service.ProductivityInsightService;
import com.slotwise.service.ProgressService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.util.List;
import java.util.Map;

/**
 * ProgressServlet — Progress Tracking Page Controller
 * =====================================================
 * Handles GET (display) and POST (goal CRUD) requests.
 *
 * SESSION SECURITY:
 * - Every request validates the session before accessing data.
 * - All DAO queries filter by studentId — no cross-student data leakage.
 *
 * DATA FLOW:
 * 1. Authenticate session.
 * 2. Load all progress metrics from database via DAOs.
 * 3. Set request attributes.
 * 4. Forward to progress.jsp.
 *
 * For POST (goal management):
 * - action=addGoal    → inserts a new goal
 * - action=deleteGoal → deletes a goal by id
 * - action=addSession → logs a study session
 */
public class ProgressServlet extends HttpServlet {

    private final ProgressService           progressService  = new ProgressService();
    private final TaskDAO                   taskDAO          = new TaskDAO();
    private final StudySessionDAO           sessionDAO       = new StudySessionDAO();
    private final AcademicGoalDAO           goalDAO          = new AcademicGoalDAO();
    private final ProductivityInsightService insightService  = new ProductivityInsightService();

    // ---------------------------------------------------------------
    // GET — Display the Progress page
    // ---------------------------------------------------------------
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("studentId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int studentId = (int) session.getAttribute("studentId");

        try {
            // --- A. Task Completion Metrics ---
            progressService.loadProgress(studentId);
            request.setAttribute("totalTasks",            progressService.getTotalTasks());
            request.setAttribute("pendingTasks",           progressService.getPendingTasks());
            request.setAttribute("inProgressTasks",        progressService.getInProgressTasks());
            request.setAttribute("completedTasks",         progressService.getCompletedTasks());
            request.setAttribute("overdueTasks",           progressService.getOverdueTasks());
            request.setAttribute("completionPercentage",   progressService.getCompletionPercentage());
            request.setAttribute("completionPercentageInt",progressService.getCompletionPercentageInt());

            // --- B. Study Session Metrics ---
            int thisWeekMinutes  = sessionDAO.getTotalWeeklyMinutes(studentId);
            int lastWeekMinutes  = sessionDAO.getPreviousWeeklyMinutes(studentId);
            double thisWeekHours = Math.round(thisWeekMinutes / 60.0 * 10) / 10.0;
            double lastWeekHours = Math.round(lastWeekMinutes / 60.0 * 10) / 10.0;

            int weeklyDelta = 0;
            boolean weeklyPositive = true;
            if (lastWeekMinutes > 0) {
                weeklyDelta = (int) Math.round(
                    ((thisWeekMinutes - lastWeekMinutes) * 100.0) / lastWeekMinutes
                );
                weeklyPositive = thisWeekMinutes >= lastWeekMinutes;
            }

            request.setAttribute("thisWeekHours",    thisWeekHours);
            request.setAttribute("lastWeekHours",    lastWeekHours);
            request.setAttribute("weeklyDelta",      Math.abs(weeklyDelta));
            request.setAttribute("weeklyPositive",   weeklyPositive);

            // --- C. Weekly bar chart data (Mon–Sun) ---
            Map<String, Integer> weeklyMap = sessionDAO.getWeeklyStudyMinutes(studentId);
            request.setAttribute("weeklyMinutesMap", weeklyMap);

            // Compute max for bar scaling
            int maxMinutes = 1;
            for (int v : weeklyMap.values()) if (v > maxMinutes) maxMinutes = v;
            request.setAttribute("maxWeeklyMinutes", maxMinutes);

            // --- D. Subject-wise study minutes ---
            Map<String, Integer> subjectMap = sessionDAO.getStudyMinutesBySubject(studentId);
            int totalSubjectMinutes = 0;
            for (int v : subjectMap.values()) totalSubjectMinutes += v;
            request.setAttribute("subjectStudyMap",     subjectMap);
            request.setAttribute("totalSubjectMinutes", totalSubjectMinutes);

            // --- E. Academic Goals ---
            List<AbstractGoal> goals  = goalDAO.getGoalsByStudentId(studentId);
            int completedGoals = goalDAO.countCompletedGoals(studentId);
            int totalGoals     = goalDAO.countTotalGoals(studentId);
            request.setAttribute("goals",          goals);
            request.setAttribute("completedGoals", completedGoals);
            request.setAttribute("totalGoals",     totalGoals);

            // --- F. Recent Activity (last 5 completed tasks + last 5 study sessions) ---
            List<Task>         recentTasks    = taskDAO.getTasksByStatus(studentId, "COMPLETED");
            List<StudySession> recentSessions = sessionDAO.getRecentSessions(studentId, 5);
            // Limit tasks to last 5
            if (recentTasks.size() > 5) recentTasks = recentTasks.subList(0, 5);
            request.setAttribute("recentCompletedTasks", recentTasks);
            request.setAttribute("recentStudySessions",  recentSessions);

            // --- G. Productivity Insights ---
            request.setAttribute("insights", insightService.generateInsights(studentId));

            // --- H. Study streak (days in a row with study sessions) ---
            request.setAttribute("studyStreak", calculateStreak(studentId));

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Could not load progress data: " + e.getMessage());
        }

        String view = request.getParameter("view");
        if ("recent-activity".equalsIgnoreCase(view) || "recent".equalsIgnoreCase(view) || "activities".equalsIgnoreCase(view)) {
            request.getRequestDispatcher("/recent-activity.jsp").forward(request, response);
            return;
        }

        request.getRequestDispatcher("/progress.jsp").forward(request, response);
    }

    // ---------------------------------------------------------------
    // POST — Handle Goal CRUD + Study Session logging
    // ---------------------------------------------------------------
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("studentId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int studentId = (int) session.getAttribute("studentId");
        String action = request.getParameter("action");
        if (action == null) action = "";

        try {
            switch (action) {

                // ---- Add a new academic goal ----
                case "addGoal": {
                    String title       = request.getParameter("goalTitle");
                    String description = request.getParameter("goalDescription");
                    String typeStr     = request.getParameter("goalType");
                    String targetStr   = request.getParameter("targetValue");
                    String deadlineStr = request.getParameter("goalDeadline");

                    if (title == null || title.trim().isEmpty()) {
                        session.setAttribute("flashError", "Goal title is required.");
                        break;
                    }
                    if (targetStr == null || targetStr.trim().isEmpty()) {
                        session.setAttribute("flashError", "Target value is required.");
                        break;
                    }

                    int target;
                    try { target = Integer.parseInt(targetStr.trim()); }
                    catch (NumberFormatException e) {
                        session.setAttribute("flashError", "Target value must be a number.");
                        break;
                    }

                    AbstractGoal.GoalType goalType;
                    try { goalType = AbstractGoal.GoalType.valueOf(typeStr.toUpperCase()); }
                    catch (Exception e) { goalType = AbstractGoal.GoalType.CUSTOM; }

                    // Create appropriate subclass (Polymorphism)
                    AbstractGoal goal;
                    if (goalType == AbstractGoal.GoalType.STUDY_HOURS) {
                        goal = new com.slotwise.model.StudyHoursGoal();
                    } else {
                        goal = new com.slotwise.model.TaskCompletionGoal();
                    }
                    goal.setStudentId(studentId);
                    goal.setTitle(title.trim());
                    goal.setDescription(description);
                    goal.setGoalType(goalType);
                    goal.setTargetValue(Math.max(1, target));
                    goal.setCurrentValue(0);
                    if (deadlineStr != null && !deadlineStr.isEmpty()) {
                        goal.setDeadline(Date.valueOf(deadlineStr));
                    }

                    goalDAO.createGoal(goal);
                    session.setAttribute("flashSuccess", "Goal added successfully!");
                    break;
                }

                // ---- Delete an academic goal ----
                case "deleteGoal": {
                    String goalIdStr = request.getParameter("goalId");
                    if (goalIdStr != null && !goalIdStr.isEmpty()) {
                        int goalId = Integer.parseInt(goalIdStr);
                        goalDAO.deleteGoal(goalId, studentId);
                        session.setAttribute("flashSuccess", "Goal deleted.");
                    }
                    break;
                }

                // ---- Update a goal's current progress value ----
                case "updateGoalProgress": {
                    String goalIdStr   = request.getParameter("goalId");
                    String currentStr  = request.getParameter("currentValue");
                    String statusStr   = request.getParameter("goalStatus");

                    if (goalIdStr != null && currentStr != null) {
                        int goalId      = Integer.parseInt(goalIdStr);
                        int currentVal  = Integer.parseInt(currentStr);
                        AbstractGoal goal = goalDAO.getGoalById(goalId, studentId);
                        if (goal != null) {
                            goal.setCurrentValue(Math.max(0, currentVal));
                            if (statusStr != null && !statusStr.isEmpty()) {
                                goal.setStatusFromString(statusStr);
                            }
                            goalDAO.updateGoal(goal);
                            session.setAttribute("flashSuccess", "Goal progress updated.");
                        }
                    }
                    break;
                }

                // ---- Log a new study session ----
                case "addSession": {
                    String subject     = request.getParameter("sessionSubject");
                    String dateStr     = request.getParameter("sessionDate");
                    String durationStr = request.getParameter("sessionDuration");
                    String notes       = request.getParameter("sessionNotes");

                    if (subject == null || subject.trim().isEmpty()) {
                        session.setAttribute("flashError", "Subject name is required.");
                        break;
                    }
                    if (dateStr == null || dateStr.isEmpty()) {
                        session.setAttribute("flashError", "Session date is required.");
                        break;
                    }
                    int duration;
                    try { duration = Integer.parseInt(durationStr != null ? durationStr.trim() : "0"); }
                    catch (NumberFormatException e) { duration = 0; }

                    if (duration <= 0) {
                        session.setAttribute("flashError", "Duration must be a positive number of minutes.");
                        break;
                    }

                    StudySession ss = new StudySession();
                    ss.setStudentId(studentId);
                    ss.setSubjectName(subject.trim());
                    ss.setSessionDate(Date.valueOf(dateStr));
                    ss.setDurationMinutes(duration);
                    ss.setNotes(notes);
                    sessionDAO.createSession(ss);
                    session.setAttribute("flashSuccess", "Study session logged successfully!");
                    break;
                }

                // ---- Delete a study session ----
                case "deleteSession": {
                    String sessionIdStr = request.getParameter("sessionId");
                    if (sessionIdStr != null && !sessionIdStr.isEmpty()) {
                        sessionDAO.deleteSession(Integer.parseInt(sessionIdStr), studentId);
                        session.setAttribute("flashSuccess", "Session removed.");
                    }
                    break;
                }

                default:
                    break;
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("flashError", "An error occurred: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/progress");
    }

    /**
     * Calculates consecutive study days (streak) ending today.
     * Queries study_sessions and counts backward from today.
     */
    private int calculateStreak(int studentId) {
        try {
            String sql = "SELECT DISTINCT session_date FROM study_sessions "
                       + "WHERE student_id = ? AND session_date <= CURDATE() "
                       + "ORDER BY session_date DESC";

            try (java.sql.Connection conn = com.slotwise.util.DBConnection.getConnection();
                 java.sql.PreparedStatement stmt = conn.prepareStatement(sql)) {

                stmt.setInt(1, studentId);
                try (java.sql.ResultSet rs = stmt.executeQuery()) {
                    int streak = 0;
                    java.util.Calendar cal = java.util.Calendar.getInstance();
                    cal.set(java.util.Calendar.HOUR_OF_DAY, 0);
                    cal.set(java.util.Calendar.MINUTE, 0);
                    cal.set(java.util.Calendar.SECOND, 0);
                    cal.set(java.util.Calendar.MILLISECOND, 0);

                    while (rs.next()) {
                        java.sql.Date d = rs.getDate("session_date");
                        java.util.Calendar dc = java.util.Calendar.getInstance();
                        dc.setTime(d);
                        dc.set(java.util.Calendar.HOUR_OF_DAY, 0);
                        dc.set(java.util.Calendar.MINUTE, 0);
                        dc.set(java.util.Calendar.SECOND, 0);
                        dc.set(java.util.Calendar.MILLISECOND, 0);

                        if (dc.equals(cal)) {
                            streak++;
                            cal.add(java.util.Calendar.DAY_OF_MONTH, -1);
                        } else {
                            break;
                        }
                    }
                    return streak;
                }
            }
        } catch (Exception e) {
            return 0;
        }
    }
}
