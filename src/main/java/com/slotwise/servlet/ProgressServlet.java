package com.slotwise.servlet;

import com.slotwise.dao.TaskDAO;
import com.slotwise.model.Task;
import com.slotwise.service.ProgressService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * ProgressServlet — Progress Tracking Page
 * ===========================================
 * Loads progress statistics from the database and forwards to progress.jsp.
 */
public class ProgressServlet extends HttpServlet {

    private final ProgressService progressService = new ProgressService();
    private final TaskDAO taskDAO = new TaskDAO();

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
            progressService.loadProgress(studentId);

            request.setAttribute("totalTasks", progressService.getTotalTasks());
            request.setAttribute("pendingTasks", progressService.getPendingTasks());
            request.setAttribute("inProgressTasks", progressService.getInProgressTasks());
            request.setAttribute("completedTasks", progressService.getCompletedTasks());
            request.setAttribute("overdueTasks", progressService.getOverdueTasks());
            request.setAttribute("completionPercentage", progressService.getCompletionPercentage());
            request.setAttribute("completionPercentageInt", progressService.getCompletionPercentageInt());

            // Load all tasks for breakdown display
            List<Task> allTasks = taskDAO.getTasksByStudentId(studentId);
            request.setAttribute("allTasks", allTasks);

        } catch (Exception e) {
            request.setAttribute("error", "Could not load progress data.");
        }

        request.getRequestDispatcher("/progress.jsp").forward(request, response);
    }
}
