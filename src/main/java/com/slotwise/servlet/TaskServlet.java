package com.slotwise.servlet;

import com.slotwise.dao.TaskDAO;
import com.slotwise.model.Task;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.util.List;

/**
 * TaskServlet — Handles all Task CRUD operations
 * =================================================
 * GET:  Displays task list, add form, or edit form
 * POST: Creates, updates, or deletes tasks
 *
 * Action parameter determines the operation:
 * - (none/list) → Show all tasks
 * - add         → Show add task form
 * - edit        → Show edit task form
 * - create      → Process new task creation
 * - update      → Process task update
 * - delete      → Process task deletion
 */
public class TaskServlet extends HttpServlet {

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
        String action = request.getParameter("action");

        try {
            if ("add".equals(action)) {
                // Show add task form
                request.getRequestDispatcher("/tasks.jsp?mode=add").forward(request, response);
                return;
            }

            if ("edit".equals(action)) {
                // Show edit task form
                int taskId = Integer.parseInt(request.getParameter("id"));
                Task task = taskDAO.getTaskById(taskId, studentId);
                if (task == null) {
                    request.setAttribute("error", "Task not found.");
                } else {
                    request.setAttribute("editTask", task);
                }
                request.setAttribute("mode", "edit");
                loadAndForward(request, response, studentId);
                return;
            }

            if ("delete".equals(action)) {
                // Show delete confirmation
                int taskId = Integer.parseInt(request.getParameter("id"));
                Task task = taskDAO.getTaskById(taskId, studentId);
                if (task != null) {
                    request.setAttribute("deleteTask", task);
                    request.setAttribute("mode", "delete");
                }
                loadAndForward(request, response, studentId);
                return;
            }

            // Default: list all tasks with optional filters
            String statusFilter = request.getParameter("status");
            String priorityFilter = request.getParameter("priority");
            List<Task> tasks;

            if (statusFilter != null && !statusFilter.isEmpty()) {
                tasks = taskDAO.getTasksByStatus(studentId, statusFilter);
                request.setAttribute("statusFilter", statusFilter);
            } else if (priorityFilter != null && !priorityFilter.isEmpty()) {
                tasks = taskDAO.getTasksByPriority(studentId, priorityFilter);
                request.setAttribute("priorityFilter", priorityFilter);
            } else {
                tasks = taskDAO.getTasksByStudentId(studentId);
            }

            request.setAttribute("tasks", tasks);
            request.setAttribute("mode", "list");
            request.getRequestDispatcher("/tasks.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid task ID.");
            loadAndForward(request, response, studentId);
        } catch (Exception e) {
            request.setAttribute("error", "An error occurred. Please try again.");
            loadAndForward(request, response, studentId);
        }
    }

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

        try {
            if ("create".equals(action)) {
                createTask(request, response, studentId);
            } else if ("update".equals(action)) {
                updateTask(request, response, studentId);
            } else if ("delete".equals(action)) {
                deleteTask(request, response, studentId);
            } else {
                response.sendRedirect(request.getContextPath() + "/tasks");
            }
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            loadAndForward(request, response, studentId);
        }
    }

    private void createTask(HttpServletRequest request, HttpServletResponse response,
                            int studentId) throws Exception {
        Task task = parseTaskFromRequest(request, studentId);
        int taskId = taskDAO.createTask(task);

        if (taskId > 0) {
            request.getSession().setAttribute("success", "Task created successfully!");
            response.sendRedirect(request.getContextPath() + "/tasks");
        } else {
            request.setAttribute("error", "Failed to create task.");
            request.setAttribute("mode", "add");
            loadAndForward(request, response, studentId);
        }
    }

    private void updateTask(HttpServletRequest request, HttpServletResponse response,
                            int studentId) throws Exception {
        int taskId = Integer.parseInt(request.getParameter("taskId"));
        Task task = parseTaskFromRequest(request, studentId);
        task.setTaskId(taskId);

        if (taskDAO.updateTask(task)) {
            request.getSession().setAttribute("success", "Task updated successfully!");
            response.sendRedirect(request.getContextPath() + "/tasks");
        } else {
            request.setAttribute("error", "Failed to update task. You may not have permission.");
            loadAndForward(request, response, studentId);
        }
    }

    private void deleteTask(HttpServletRequest request, HttpServletResponse response,
                            int studentId) throws Exception {
        int taskId = Integer.parseInt(request.getParameter("taskId"));

        if (taskDAO.deleteTask(taskId, studentId)) {
            request.getSession().setAttribute("success", "Task deleted successfully!");
        } else {
            request.getSession().setAttribute("error", "Failed to delete task.");
        }
        response.sendRedirect(request.getContextPath() + "/tasks");
    }

    private Task parseTaskFromRequest(HttpServletRequest request, int studentId) {
        Task task = new Task();
        task.setStudentId(studentId);
        task.setTitle(request.getParameter("title"));
        task.setDescription(request.getParameter("description"));
        task.setTaskTypeFromString(request.getParameter("taskType"));
        task.setPriorityFromString(request.getParameter("priority"));

        String minutes = request.getParameter("estimatedMinutes");
        if (minutes != null && !minutes.isEmpty()) {
            task.setEstimatedMinutes(Integer.parseInt(minutes));
        }

        String deadline = request.getParameter("deadline");
        if (deadline != null && !deadline.isEmpty()) {
            task.setDeadline(Date.valueOf(deadline));
        }

        String status = request.getParameter("status");
        if (status != null && !status.isEmpty()) {
            task.setStatusFromString(status);
        }

        return task;
    }

    private void loadAndForward(HttpServletRequest request, HttpServletResponse response,
                                int studentId) throws ServletException, IOException {
        try {
            List<Task> tasks = taskDAO.getTasksByStudentId(studentId);
            request.setAttribute("tasks", tasks);
        } catch (Exception e) {
            // Tasks list will be empty
        }
        request.getRequestDispatcher("/tasks.jsp").forward(request, response);
    }
}
