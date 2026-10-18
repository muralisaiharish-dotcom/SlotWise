package com.slotwise.servlet;

import com.slotwise.dao.TaskDAO;
import com.slotwise.dao.TimetableDAO;
import com.slotwise.model.FreeTimeSlot;
import com.slotwise.model.Recommendation;
import com.slotwise.model.Task;
import com.slotwise.model.TimetableEntry;
import com.slotwise.service.ProgressService;
import com.slotwise.service.SmartPlannerService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.TextStyle;
import java.util.List;
import java.util.Locale;

/**
 * DashboardServlet — Main dashboard for logged-in students
 * ==========================================================
 * Loads summary data from the database and forwards to dashboard.jsp.
 */
public class DashboardServlet extends HttpServlet {

    private final TaskDAO taskDAO = new TaskDAO();
    private final TimetableDAO timetableDAO = new TimetableDAO();
    private final SmartPlannerService plannerService = new SmartPlannerService();
    private final ProgressService progressService = new ProgressService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check authentication
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("studentId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int studentId = (int) session.getAttribute("studentId");
        String studentName = (String) session.getAttribute("studentName");

        try {
            // Get current day of the week
            String today = LocalDate.now().getDayOfWeek()
                    .getDisplayName(TextStyle.FULL, Locale.ENGLISH);

            // Load today's timetable
            List<TimetableEntry> todayClasses = timetableDAO.getEntriesByDay(studentId, today);
            request.setAttribute("todayClasses", todayClasses);
            request.setAttribute("todayClassCount", todayClasses.size());

            // Load task statistics
            int pendingCount = taskDAO.countPendingTasks(studentId) + taskDAO.countInProgressTasks(studentId);
            request.setAttribute("pendingTaskCount", pendingCount);

            // Load free slots for today
            List<FreeTimeSlot> freeSlots = plannerService.findFreeSlots(studentId, today);
            request.setAttribute("freeSlots", freeSlots);
            request.setAttribute("freeSlotCount", freeSlots.size());

            // Load progress
            progressService.loadProgress(studentId);
            request.setAttribute("completionPercentage", progressService.getCompletionPercentageInt());

            // Load top recommendations (auto-generate for today)
            List<Recommendation> recommendations = plannerService.generateRecommendations(studentId, today);
            request.setAttribute("recommendations", recommendations);

            // Set display data
            request.setAttribute("studentName", studentName);
            request.setAttribute("today", today);
            request.setAttribute("currentDate", LocalDate.now().toString());

        } catch (Exception e) {
            System.err.println("[Dashboard] Error loading data: " + e.getMessage());
            request.setAttribute("error", "Could not load dashboard data. Please try again.");
        }

        request.getRequestDispatcher("/dashboard.jsp").forward(request, response);
    }
}
