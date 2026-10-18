package com.slotwise.servlet;

import com.slotwise.model.FreeTimeSlot;
import com.slotwise.model.Recommendation;
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
 * PlannerServlet — Smart Free-Time Planner
 * ==========================================
 * GET:  Displays the planner page with day selection
 * POST: Generates recommendations for the selected day
 */
public class PlannerServlet extends HttpServlet {

    private final SmartPlannerService plannerService = new SmartPlannerService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("studentId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int studentId = (int) session.getAttribute("studentId");
        String selectedDay = request.getParameter("day");

        if (selectedDay == null || selectedDay.isEmpty()) {
            selectedDay = LocalDate.now().getDayOfWeek()
                    .getDisplayName(TextStyle.FULL, Locale.ENGLISH);
        }

        try {
            // Find free slots
            List<FreeTimeSlot> freeSlots = plannerService.findFreeSlots(studentId, selectedDay);
            request.setAttribute("freeSlots", freeSlots);

            // Generate recommendations
            List<Recommendation> recommendations = plannerService.generateRecommendations(studentId, selectedDay);
            request.setAttribute("recommendations", recommendations);

        } catch (Exception e) {
            request.setAttribute("error", "Could not generate plan. Please try again.");
        }

        request.setAttribute("selectedDay", selectedDay);
        request.getRequestDispatcher("/planner.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect POST to GET with day parameter
        String day = request.getParameter("day");
        response.sendRedirect(request.getContextPath() + "/planner?day=" + day);
    }
}
