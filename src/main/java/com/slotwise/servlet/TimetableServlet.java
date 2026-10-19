package com.slotwise.servlet;

import com.slotwise.dao.TimetableDAO;
import com.slotwise.model.TimetableEntry;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Time;
import java.util.List;

/**
 * TimetableServlet — Handles all Timetable CRUD operations
 * ===========================================================
 * GET:  Displays timetable, add form, or edit form
 * POST: Creates, updates, or deletes timetable entries
 */
public class TimetableServlet extends HttpServlet {

    private final TimetableDAO timetableDAO = new TimetableDAO();

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
        String dayFilter = request.getParameter("day");
        String view = request.getParameter("view");

        if ("today".equalsIgnoreCase(view) || "today-timetable".equalsIgnoreCase(view)) {
            request.getRequestDispatcher("/today-timetable.jsp").forward(request, response);
            return;
        }

        try {
            if ("add".equals(action)) {
                request.setAttribute("mode", "add");
                loadAndForward(request, response, studentId, dayFilter);
                return;
            }

            if ("edit".equals(action)) {
                int entryId = Integer.parseInt(request.getParameter("id"));
                TimetableEntry entry = timetableDAO.getEntryById(entryId, studentId);
                if (entry == null) {
                    request.setAttribute("error", "Timetable entry not found.");
                } else {
                    request.setAttribute("editEntry", entry);
                }
                request.setAttribute("mode", "edit");
                loadAndForward(request, response, studentId, dayFilter);
                return;
            }

            if ("delete".equals(action)) {
                int entryId = Integer.parseInt(request.getParameter("id"));
                TimetableEntry entry = timetableDAO.getEntryById(entryId, studentId);
                if (entry != null) {
                    request.setAttribute("deleteEntry", entry);
                    request.setAttribute("mode", "delete");
                }
                loadAndForward(request, response, studentId, dayFilter);
                return;
            }

            // Default: list timetable
            request.setAttribute("mode", "list");
            loadAndForward(request, response, studentId, dayFilter);

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid entry ID.");
            loadAndForward(request, response, studentId, dayFilter);
        } catch (Exception e) {
            request.setAttribute("error", "An error occurred. Please try again.");
            loadAndForward(request, response, studentId, dayFilter);
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
                createEntry(request, response, studentId);
            } else if ("update".equals(action)) {
                updateEntry(request, response, studentId);
            } else if ("delete".equals(action)) {
                deleteEntry(request, response, studentId);
            } else {
                response.sendRedirect(request.getContextPath() + "/timetable");
            }
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            loadAndForward(request, response, studentId, null);
        }
    }

    private void createEntry(HttpServletRequest request, HttpServletResponse response,
                             int studentId) throws Exception {
        TimetableEntry entry = parseEntryFromRequest(request, studentId);

        // Validate time range
        if (!entry.getEndTime().after(entry.getStartTime())) {
            throw new IllegalArgumentException("End time must be after start time.");
        }

        // Check for overlapping classes
        if (timetableDAO.hasOverlap(studentId, entry.getDayOfWeek(),
                entry.getStartTime(), entry.getEndTime(), -1)) {
            throw new IllegalArgumentException("This time slot overlaps with an existing class.");
        }

        int entryId = timetableDAO.createEntry(entry);
        if (entryId > 0) {
            request.getSession().setAttribute("success", "Class added successfully!");
            response.sendRedirect(request.getContextPath() + "/timetable");
        } else {
            request.setAttribute("error", "Failed to add class.");
            request.setAttribute("mode", "add");
            loadAndForward(request, response, studentId, null);
        }
    }

    private void updateEntry(HttpServletRequest request, HttpServletResponse response,
                             int studentId) throws Exception {
        int entryId = Integer.parseInt(request.getParameter("entryId"));
        TimetableEntry entry = parseEntryFromRequest(request, studentId);
        entry.setTimetableId(entryId);

        // Validate time range
        if (!entry.getEndTime().after(entry.getStartTime())) {
            throw new IllegalArgumentException("End time must be after start time.");
        }

        // Check for overlapping classes (exclude current entry)
        if (timetableDAO.hasOverlap(studentId, entry.getDayOfWeek(),
                entry.getStartTime(), entry.getEndTime(), entryId)) {
            throw new IllegalArgumentException("This time slot overlaps with an existing class.");
        }

        if (timetableDAO.updateEntry(entry)) {
            request.getSession().setAttribute("success", "Class updated successfully!");
            response.sendRedirect(request.getContextPath() + "/timetable");
        } else {
            request.setAttribute("error", "Failed to update class.");
            loadAndForward(request, response, studentId, null);
        }
    }

    private void deleteEntry(HttpServletRequest request, HttpServletResponse response,
                             int studentId) throws Exception {
        int entryId = Integer.parseInt(request.getParameter("entryId"));

        if (timetableDAO.deleteEntry(entryId, studentId)) {
            request.getSession().setAttribute("success", "Class deleted successfully!");
        } else {
            request.getSession().setAttribute("error", "Failed to delete class.");
        }
        response.sendRedirect(request.getContextPath() + "/timetable");
    }

    private TimetableEntry parseEntryFromRequest(HttpServletRequest request, int studentId) {
        TimetableEntry entry = new TimetableEntry();
        entry.setStudentId(studentId);
        entry.setSubjectName(request.getParameter("subjectName"));
        entry.setRoomNumber(request.getParameter("roomNumber"));
        entry.setDayOfWeek(request.getParameter("dayOfWeek"));

        String startTime = request.getParameter("startTime");
        String endTime = request.getParameter("endTime");
        entry.setStartTime(Time.valueOf(startTime + ":00"));
        entry.setEndTime(Time.valueOf(endTime + ":00"));

        return entry;
    }

    private void loadAndForward(HttpServletRequest request, HttpServletResponse response,
                                int studentId, String dayFilter) throws ServletException, IOException {
        try {
            List<TimetableEntry> entries;
            if (dayFilter != null && !dayFilter.isEmpty()) {
                entries = timetableDAO.getEntriesByDay(studentId, dayFilter);
                request.setAttribute("dayFilter", dayFilter);
            } else {
                entries = timetableDAO.getEntriesByStudentId(studentId);
            }
            request.setAttribute("entries", entries);
        } catch (Exception e) {
            // entries will be empty
        }
        request.getRequestDispatcher("/timetable.jsp").forward(request, response);
    }
}
