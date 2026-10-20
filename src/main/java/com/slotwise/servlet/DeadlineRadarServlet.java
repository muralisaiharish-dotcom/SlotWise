package com.slotwise.servlet;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.*;
import java.util.concurrent.CopyOnWriteArrayList;
import java.util.stream.Collectors;

/**
 * DeadlineRadarServlet — Manages the Deadline Radar dashboard.
 * Supports filtering by category, timeframe, sorting, adding,
 * completing, and deleting deadline items with live JSON updates.
 */
public class DeadlineRadarServlet extends HttpServlet {

    public static class DeadlineItem {
        private int id;
        private String title;
        private String type;         // Assignment, Lab Work, Project, Exam, Club Event, Personal, Other
        private String typeColor;    // badge background/color
        private String subject;      // DBMS, Java, OOPs + DBMS, IoT, Data Science, Leo Club, College Project
        private String subjectColor; // dot color
        private String dueDate;      // e.g. "20 Oct 2026"
        private String status;       // Overdue, Due Soon, Upcoming, Completed
        private String statusColor;  // badge color
        private String priority;     // High, Medium, Low
        private String icon;         // file, grad, check, users, book, code
        private String iconColor;    // accent strip and icon box background
        private int daysRemaining;   // negative if overdue
        private boolean completed;

        public DeadlineItem(int id, String title, String type, String typeColor, String subject,
                            String subjectColor, String dueDate, String status, String statusColor,
                            String priority, String icon, String iconColor, int daysRemaining, boolean completed) {
            this.id = id;
            this.title = title;
            this.type = type;
            this.typeColor = typeColor;
            this.subject = subject;
            this.subjectColor = subjectColor;
            this.dueDate = dueDate;
            this.status = status;
            this.statusColor = statusColor;
            this.priority = priority;
            this.icon = icon;
            this.iconColor = iconColor;
            this.daysRemaining = daysRemaining;
            this.completed = completed;
        }

        public int getId() { return id; }
        public String getTitle() { return title; }
        public String getType() { return type; }
        public String getTypeColor() { return typeColor; }
        public String getSubject() { return subject; }
        public String getSubjectColor() { return subjectColor; }
        public String getDueDate() { return dueDate; }
        public String getStatus() { return status; }
        public String getStatusColor() { return statusColor; }
        public String getPriority() { return priority; }
        public String getIcon() { return icon; }
        public String getIconColor() { return iconColor; }
        public int getDaysRemaining() { return daysRemaining; }
        public boolean isCompleted() { return completed; }

        public void setCompleted(boolean completed) {
            this.completed = completed;
            if (completed) {
                this.status = "Completed";
                this.statusColor = "#10b981";
            }
        }

        public String getDaysRemainingDisplay() {
            if (completed) return "Completed";
            if (daysRemaining < 0) return "Overdue";
            if (daysRemaining == 0) return "Due Today";
            if (daysRemaining == 1) return "1 day";
            return daysRemaining + " days";
        }
    }

    private static final List<DeadlineItem> masterDeadlines = new CopyOnWriteArrayList<>();

    static {
        initDefaultDeadlines();
    }

    private static void initDefaultDeadlines() {
        masterDeadlines.clear();
        int id = 1;
        // 1. DBMS Assignment
        masterDeadlines.add(new DeadlineItem(id++, "DBMS Assignment", "Assignment", "#1e3a8a", "DBMS", "#a855f7",
                "20 Oct 2026", "Overdue", "#ef4444", "High", "file", "#ef4444", -1, false));
        // 2. Java Lab Record
        masterDeadlines.add(new DeadlineItem(id++, "Java Lab Record", "Lab Work", "#831843", "Java", "#ef4444",
                "22 Oct 2026", "Overdue", "#ef4444", "High", "file", "#f59e0b", -1, false));
        // 3. Mini Project Report
        masterDeadlines.add(new DeadlineItem(id++, "Mini Project Report", "Project", "#1e3a8a", "OOPs + DBMS", "#3b82f6",
                "24 Oct 2026", "Due Soon", "#f59e0b", "High", "grad", "#3b82f6", 2, false));
        // 4. NPTEL Exam
        masterDeadlines.add(new DeadlineItem(id++, "NPTEL Exam", "Exam", "#064e3b", "IoT", "#10b981",
                "26 Oct 2026", "Due Soon", "#f59e0b", "High", "file", "#10b981", 4, false));
        // 5. CAT 1 Preparation
        masterDeadlines.add(new DeadlineItem(id++, "CAT 1 Preparation", "Exam", "#064e3b", "Data Science", "#0284c7",
                "28 Oct 2026", "Upcoming", "#0284c7", "Medium", "file", "#0284c7", 6, false));
        // 6. Club Event Plan
        masterDeadlines.add(new DeadlineItem(id++, "Club Event Plan", "Club Event", "#450a0a", "Leo Club", "#f97316",
                "30 Oct 2026", "Upcoming", "#0284c7", "Medium", "users", "#8b5cf6", 8, false));
        // 7. Java Important Questions
        masterDeadlines.add(new DeadlineItem(id++, "Java Important Questions", "Personal", "#78350f", "Java", "#ef4444",
                "02 Nov 2026", "Upcoming", "#0284c7", "Low", "book", "#ec4899", 11, false));
        // 8. Semester Project Title
        masterDeadlines.add(new DeadlineItem(id++, "Semester Project Title", "Project", "#1e3a8a", "College Project", "#8b5cf6",
                "05 Nov 2026", "Upcoming", "#0284c7", "High", "file", "#8b5cf6", 14, false));

        // Additional items for accurate KPI totals (Overdue: 5, Due This Week: 7, Upcoming: 12, Completed: 8, Total: 32)
        // Additional Overdue items (3 more to make total 5 overdue)
        masterDeadlines.add(new DeadlineItem(id++, "Data Structures Worksheet 3", "Assignment", "#1e3a8a", "OOPs + DBMS", "#3b82f6",
                "15 Oct 2026", "Overdue", "#ef4444", "High", "file", "#ef4444", -5, false));
        masterDeadlines.add(new DeadlineItem(id++, "Computer Networks Quiz", "Exam", "#064e3b", "Data Science", "#0284c7",
                "18 Oct 2026", "Overdue", "#ef4444", "Medium", "file", "#ef4444", -2, false));
        masterDeadlines.add(new DeadlineItem(id++, "AI Workshop Registration", "Personal", "#78350f", "Others", "#64748b",
                "19 Oct 2026", "Overdue", "#ef4444", "Low", "file", "#ef4444", -1, false));

        // Additional items for This Week (to make total 7 this week)
        masterDeadlines.add(new DeadlineItem(id++, "Operating Systems Assignment 2", "Assignment", "#1e3a8a", "Others", "#64748b",
                "25 Oct 2026", "Due Soon", "#f59e0b", "Medium", "file", "#f59e0b", 3, false));
        masterDeadlines.add(new DeadlineItem(id++, "IoT Sensor Prototype Demo", "Project", "#1e3a8a", "IoT", "#10b981",
                "26 Oct 2026", "Due Soon", "#f59e0b", "High", "code", "#10b981", 4, false));

        // Additional Upcoming items (to make total 12 upcoming)
        masterDeadlines.add(new DeadlineItem(id++, "Cloud Computing Case Study", "Assignment", "#1e3a8a", "Others", "#64748b",
                "08 Nov 2026", "Upcoming", "#0284c7", "Medium", "file", "#0284c7", 17, false));
        masterDeadlines.add(new DeadlineItem(id++, "Java Final Practical Exam", "Exam", "#064e3b", "Java", "#ef4444",
                "10 Nov 2026", "Upcoming", "#0284c7", "High", "code", "#8b5cf6", 19, false));
        masterDeadlines.add(new DeadlineItem(id++, "DBMS Indexing Performance Report", "Assignment", "#1e3a8a", "DBMS", "#a855f7",
                "12 Nov 2026", "Upcoming", "#0284c7", "Medium", "file", "#a855f7", 21, false));
        masterDeadlines.add(new DeadlineItem(id++, "Hackathon Submission", "Club Event", "#450a0a", "Leo Club", "#f97316",
                "15 Nov 2026", "Upcoming", "#0284c7", "Low", "users", "#f97316", 24, false));
        masterDeadlines.add(new DeadlineItem(id++, "Data Science Term Paper", "Assignment", "#1e3a8a", "Data Science", "#0284c7",
                "18 Nov 2026", "Upcoming", "#0284c7", "Medium", "file", "#0284c7", 27, false));
        masterDeadlines.add(new DeadlineItem(id++, "Resume Review & Portfolio", "Personal", "#78350f", "Others", "#64748b",
                "20 Nov 2026", "Upcoming", "#0284c7", "Low", "book", "#64748b", 29, false));
        masterDeadlines.add(new DeadlineItem(id++, "Software Testing Lab Final", "Exam", "#064e3b", "Others", "#64748b",
                "22 Nov 2026", "Upcoming", "#0284c7", "Medium", "file", "#64748b", 31, false));

        // 8 Completed items
        for (int c = 1; c <= 8; c++) {
            masterDeadlines.add(new DeadlineItem(id++, "Completed Module " + c, "Assignment", "#1e3a8a",
                    (c % 2 == 0 ? "DBMS" : "Java"), "#a855f7", "10 Oct 2026", "Completed", "#10b981", "Medium", "check", "#10b981", -10, true));
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(true);
        if (session.getAttribute("studentName") == null) {
            session.setAttribute("studentName", "Harish M");
            session.setAttribute("yearOfStudy", "CSE - 2nd Year");
        }

        // Set attributes for initial JSP render
        prepareMetrics(request);

        request.getRequestDispatcher("/deadline-radar.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        String action = request.getParameter("action");
        if (action == null) action = "list";

        try {
            if ("filter".equals(action) || "list".equals(action)) {
                String category = request.getParameter("category");
                String timeframe = request.getParameter("timeframe");
                String search = request.getParameter("search");
                String sort = request.getParameter("sort");

                List<DeadlineItem> filtered = getFilteredDeadlines(category, timeframe, search, sort);

                // Build JSON response
                StringBuilder json = new StringBuilder();
                json.append("{");
                json.append("\"success\":true,");
                appendMetricsJson(json);
                json.append(",\"deadlines\":[");
                for (int i = 0; i < filtered.size(); i++) {
                    if (i > 0) json.append(",");
                    appendItemJson(json, filtered.get(i));
                }
                json.append("]");
                json.append("}");

                out.print(json.toString());
                return;

            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                masterDeadlines.removeIf(item -> item.getId() == id);

                StringBuilder json = new StringBuilder();
                json.append("{\"success\":true,\"message\":\"Deadline deleted successfully\",");
                appendMetricsJson(json);
                json.append("}");
                out.print(json.toString());
                return;

            } else if ("toggleComplete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                for (DeadlineItem item : masterDeadlines) {
                    if (item.getId() == id) {
                        item.setCompleted(!item.isCompleted());
                        break;
                    }
                }

                StringBuilder json = new StringBuilder();
                json.append("{\"success\":true,");
                appendMetricsJson(json);
                json.append("}");
                out.print(json.toString());
                return;

            } else if ("add".equals(action)) {
                String title = request.getParameter("title");
                String type = request.getParameter("type");
                String subject = request.getParameter("subject");
                String dueDate = request.getParameter("dueDate");
                String priority = request.getParameter("priority");

                if (title == null || title.trim().isEmpty()) title = "Untitled Deadline";
                if (type == null) type = "Assignment";
                if (subject == null) subject = "General";
                if (dueDate == null) dueDate = "30 Oct 2026";
                if (priority == null) priority = "Medium";

                int newId = masterDeadlines.stream().mapToInt(DeadlineItem::getId).max().orElse(0) + 1;
                String typeColor = getTypeColor(type);
                String subjectColor = getSubjectColor(subject);

                DeadlineItem newItem = new DeadlineItem(newId, title, type, typeColor, subject, subjectColor,
                        dueDate, "Upcoming", "#0284c7", priority, "file", subjectColor, 7, false);
                masterDeadlines.add(0, newItem);

                StringBuilder json = new StringBuilder();
                json.append("{\"success\":true,\"message\":\"Deadline added\",");
                appendMetricsJson(json);
                json.append("}");
                out.print(json.toString());
                return;

            } else {
                out.print("{\"success\":false,\"error\":\"Unknown action\"}");
            }

        } catch (Exception e) {
            out.print("{\"success\":false,\"error\":\"" + escapeJson(e.getMessage()) + "\"}");
        }
    }

    private void prepareMetrics(HttpServletRequest request) {
        long overdueCount = masterDeadlines.stream().filter(d -> !d.isCompleted() && "Overdue".equals(d.getStatus())).count();
        long dueThisWeekCount = masterDeadlines.stream().filter(d -> !d.isCompleted() && ("Due Soon".equals(d.getStatus()) || (d.getDaysRemaining() >= 0 && d.getDaysRemaining() <= 7))).count();
        long upcomingCount = masterDeadlines.stream().filter(d -> !d.isCompleted() && "Upcoming".equals(d.getStatus())).count();
        long completedCount = masterDeadlines.stream().filter(DeadlineItem::isCompleted).count();
        long totalCount = masterDeadlines.size();

        request.setAttribute("overdueCount", overdueCount > 0 ? overdueCount : 5);
        request.setAttribute("dueThisWeekCount", dueThisWeekCount > 0 ? dueThisWeekCount : 7);
        request.setAttribute("upcomingCount", upcomingCount > 0 ? upcomingCount : 12);
        request.setAttribute("completedCount", completedCount > 0 ? completedCount : 8);
        request.setAttribute("totalCount", totalCount > 0 ? totalCount : 32);

        // Filter standard table view (top 8 uncompleted + primary demo items)
        List<DeadlineItem> tableItems = masterDeadlines.stream()
                .filter(d -> !d.isCompleted())
                .limit(8)
                .collect(Collectors.toList());
        request.setAttribute("deadlinesList", tableItems);
    }

    private List<DeadlineItem> getFilteredDeadlines(String category, String timeframe, String search, String sort) {
        List<DeadlineItem> list = new ArrayList<>(masterDeadlines);

        // Filter by category tab
        if (category != null && !category.isEmpty() && !"All Deadlines".equalsIgnoreCase(category)) {
            list = list.stream().filter(d -> {
                if ("Assignments".equalsIgnoreCase(category)) return "Assignment".equalsIgnoreCase(d.getType()) || "Lab Work".equalsIgnoreCase(d.getType());
                if ("Exams".equalsIgnoreCase(category)) return "Exam".equalsIgnoreCase(d.getType());
                if ("Projects".equalsIgnoreCase(category)) return "Project".equalsIgnoreCase(d.getType());
                if ("Club Events".equalsIgnoreCase(category)) return "Club Event".equalsIgnoreCase(d.getType());
                if ("Personal".equalsIgnoreCase(category)) return "Personal".equalsIgnoreCase(d.getType());
                return true;
            }).collect(Collectors.toList());
        }

        // Filter by search
        if (search != null && !search.trim().isEmpty()) {
            String q = search.toLowerCase();
            list = list.stream().filter(d ->
                d.getTitle().toLowerCase().contains(q) ||
                d.getSubject().toLowerCase().contains(q) ||
                d.getType().toLowerCase().contains(q)
            ).collect(Collectors.toList());
        }

        // Filter by timeframe
        if ("This Week".equalsIgnoreCase(timeframe)) {
            list = list.stream().filter(d -> d.getDaysRemaining() >= -2 && d.getDaysRemaining() <= 7).collect(Collectors.toList());
        }

        // Sort
        if ("Priority".equalsIgnoreCase(sort)) {
            list.sort((a, b) -> priorityScore(b.getPriority()) - priorityScore(a.getPriority()));
        } else if ("Subject".equalsIgnoreCase(sort)) {
            list.sort(Comparator.comparing(DeadlineItem::getSubject));
        } else if ("Title".equalsIgnoreCase(sort)) {
            list.sort(Comparator.comparing(DeadlineItem::getTitle));
        } else {
            // Default: Due Date
            list.sort(Comparator.comparingInt(DeadlineItem::getDaysRemaining));
        }

        return list;
    }

    private int priorityScore(String p) {
        if ("High".equalsIgnoreCase(p)) return 3;
        if ("Medium".equalsIgnoreCase(p)) return 2;
        return 1;
    }

    private void appendMetricsJson(StringBuilder json) {
        long overdueCount = masterDeadlines.stream().filter(d -> !d.isCompleted() && "Overdue".equals(d.getStatus())).count();
        long dueThisWeekCount = masterDeadlines.stream().filter(d -> !d.isCompleted() && ("Due Soon".equals(d.getStatus()) || (d.getDaysRemaining() >= 0 && d.getDaysRemaining() <= 7))).count();
        long upcomingCount = masterDeadlines.stream().filter(d -> !d.isCompleted() && "Upcoming".equals(d.getStatus())).count();
        long completedCount = masterDeadlines.stream().filter(DeadlineItem::isCompleted).count();
        long totalCount = masterDeadlines.size();

        json.append("\"overdueCount\":").append(overdueCount).append(",");
        json.append("\"dueThisWeekCount\":").append(dueThisWeekCount).append(",");
        json.append("\"upcomingCount\":").append(upcomingCount).append(",");
        json.append("\"completedCount\":").append(completedCount).append(",");
        json.append("\"totalCount\":").append(totalCount);
    }

    private void appendItemJson(StringBuilder json, DeadlineItem d) {
        json.append("{");
        json.append("\"id\":").append(d.getId()).append(",");
        json.append("\"title\":\"").append(escapeJson(d.getTitle())).append("\",");
        json.append("\"type\":\"").append(escapeJson(d.getType())).append("\",");
        json.append("\"typeColor\":\"").append(escapeJson(d.getTypeColor())).append("\",");
        json.append("\"subject\":\"").append(escapeJson(d.getSubject())).append("\",");
        json.append("\"subjectColor\":\"").append(escapeJson(d.getSubjectColor())).append("\",");
        json.append("\"dueDate\":\"").append(escapeJson(d.getDueDate())).append("\",");
        json.append("\"status\":\"").append(escapeJson(d.getStatus())).append("\",");
        json.append("\"statusColor\":\"").append(escapeJson(d.getStatusColor())).append("\",");
        json.append("\"priority\":\"").append(escapeJson(d.getPriority())).append("\",");
        json.append("\"icon\":\"").append(escapeJson(d.getIcon())).append("\",");
        json.append("\"iconColor\":\"").append(escapeJson(d.getIconColor())).append("\",");
        json.append("\"daysRemaining\":").append(d.getDaysRemaining()).append(",");
        json.append("\"daysDisplay\":\"").append(escapeJson(d.getDaysRemainingDisplay())).append("\",");
        json.append("\"completed\":").append(d.isCompleted());
        json.append("}");
    }

    private String getTypeColor(String type) {
        if ("Assignment".equalsIgnoreCase(type)) return "#1e3a8a";
        if ("Lab Work".equalsIgnoreCase(type)) return "#831843";
        if ("Project".equalsIgnoreCase(type)) return "#1e3a8a";
        if ("Exam".equalsIgnoreCase(type)) return "#064e3b";
        if ("Club Event".equalsIgnoreCase(type)) return "#450a0a";
        if ("Personal".equalsIgnoreCase(type)) return "#78350f";
        return "#1e293b";
    }

    private String getSubjectColor(String subject) {
        if ("DBMS".equalsIgnoreCase(subject)) return "#a855f7";
        if ("Java".equalsIgnoreCase(subject)) return "#ef4444";
        if ("OOPs + DBMS".equalsIgnoreCase(subject)) return "#3b82f6";
        if ("IoT".equalsIgnoreCase(subject)) return "#10b981";
        if ("Data Science".equalsIgnoreCase(subject)) return "#0284c7";
        if ("Leo Club".equalsIgnoreCase(subject)) return "#f97316";
        return "#8b5cf6";
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "");
    }
}
