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
 * StudyPlannerServlet — Complete backend servlet for Study Planner.
 * Manages study sessions, real-time timer tracking, goals, recommendations,
 * streak, subject progress, and overview metrics.
 */
public class StudyPlannerServlet extends HttpServlet {

    public static class StudySession {
        private int id;
        private String timeRange;       // e.g. "08:00 AM - 09:00 AM"
        private String accentColor;     // border/dot color e.g. "#f97316"
        private String subject;         // e.g. "Data Structures"
        private String topic;           // e.g. "Trees - Introduction"
        private String type;            // Lecture, Notes, Practice, Revision, Project
        private String typeBg;          // pill background
        private String typeColor;       // pill text color
        private String duration;        // e.g. "1h", "30m"
        private int durationMinutes;    // 60, 30
        private boolean completed;
        private String date;            // e.g. "20 Oct 2026"
        private String timeframe;       // "Daily", "Weekly", "Monthly"

        public StudySession(int id, String timeRange, String accentColor, String subject,
                            String topic, String type, String typeBg, String typeColor,
                            String duration, int durationMinutes, boolean completed, String date, String timeframe) {
            this.id = id;
            this.timeRange = timeRange;
            this.accentColor = accentColor;
            this.subject = subject;
            this.topic = topic;
            this.type = type;
            this.typeBg = typeBg;
            this.typeColor = typeColor;
            this.duration = duration;
            this.durationMinutes = durationMinutes;
            this.completed = completed;
            this.date = date;
            this.timeframe = timeframe;
        }

        public int getId() { return id; }
        public String getTimeRange() { return timeRange; }
        public String getAccentColor() { return accentColor; }
        public String getSubject() { return subject; }
        public String getTopic() { return topic; }
        public String getType() { return type; }
        public String getTypeBg() { return typeBg; }
        public String getTypeColor() { return typeColor; }
        public String getDuration() { return duration; }
        public int getDurationMinutes() { return durationMinutes; }
        public boolean isCompleted() { return completed; }
        public String getDate() { return date; }
        public String getTimeframe() { return timeframe; }

        public void setCompleted(boolean completed) { this.completed = completed; }
        public void setTimeRange(String timeRange) { this.timeRange = timeRange; }
        public void setSubject(String subject) { this.subject = subject; }
        public void setTopic(String topic) { this.topic = topic; }
        public void setType(String type) { this.type = type; }
        public void setDuration(String duration) { this.duration = duration; }
        public void setDurationMinutes(int durationMinutes) { this.durationMinutes = durationMinutes; }
        public void setAccentColor(String accentColor) { this.accentColor = accentColor; }
        public void setTypeBg(String typeBg) { this.typeBg = typeBg; }
        public void setTypeColor(String typeColor) { this.typeColor = typeColor; }
    }

    public static class StudyGoal {
        private int id;
        private String title;
        private int progress;
        private String barColor;
        private boolean completed;

        public StudyGoal(int id, String title, int progress, String barColor, boolean completed) {
            this.id = id;
            this.title = title;
            this.progress = progress;
            this.barColor = barColor;
            this.completed = completed;
        }

        public int getId() { return id; }
        public String getTitle() { return title; }
        public int getProgress() { return progress; }
        public String getBarColor() { return barColor; }
        public boolean isCompleted() { return completed; }

        public void setCompleted(boolean completed) {
            this.completed = completed;
            if (completed) this.progress = 100;
        }
        public void setProgress(int progress) {
            this.progress = progress;
            if (progress >= 100) this.completed = true;
        }
    }

    public static class Recommendation {
        private int id;
        private String title;
        private String subject;
        private String duration;
        private int durationMinutes;
        private String icon;
        private String iconBg;
        private String iconColor;

        public Recommendation(int id, String title, String subject, String duration, int durationMinutes,
                              String icon, String iconBg, String iconColor) {
            this.id = id;
            this.title = title;
            this.subject = subject;
            this.duration = duration;
            this.durationMinutes = durationMinutes;
            this.icon = icon;
            this.iconBg = iconBg;
            this.iconColor = iconColor;
        }

        public int getId() { return id; }
        public String getTitle() { return title; }
        public String getSubject() { return subject; }
        public String getDuration() { return duration; }
        public int getDurationMinutes() { return durationMinutes; }
        public String getIcon() { return icon; }
        public String getIconBg() { return iconBg; }
        public String getIconColor() { return iconColor; }
    }

    private static final List<StudySession> masterSessions = new CopyOnWriteArrayList<>();
    private static final List<StudyGoal> masterGoals = new CopyOnWriteArrayList<>();
    private static final List<Recommendation> masterRecommendations = new CopyOnWriteArrayList<>();

    private static int streakDays = 5;
    private static int totalTasksCompleted = 8;
    private static int actualStudyMinutes = 555; // 9h 15m
    private static int plannedStudyMinutes = 750; // 12h 30m

    static {
        initDefaultData();
    }

    private static void initDefaultData() {
        masterSessions.clear();
        int id = 1;

        // 7 initial sessions from the reference design
        masterSessions.add(new StudySession(id++, "08:00 AM - 09:00 AM", "#f97316", "Data Structures",
                "Trees - Introduction", "Lecture", "#1e1b4b", "#818cf8", "1h", 60, false, "20 Oct 2026", "Daily"));

        masterSessions.add(new StudySession(id++, "09:15 AM - 10:15 AM", "#06b6d4", "DBMS",
                "Normalization", "Notes", "#082f49", "#38bdf8", "1h", 60, false, "20 Oct 2026", "Daily"));

        masterSessions.add(new StudySession(id++, "10:30 AM - 11:30 AM", "#3b82f6", "Java",
                "Exception Handling", "Practice", "#064e3b", "#34d399", "1h", 60, false, "20 Oct 2026", "Daily"));

        masterSessions.add(new StudySession(id++, "12:00 PM - 01:00 PM", "#10b981", "Mathematics",
                "Probability", "Revision", "#451a03", "#fbbf24", "1h", 60, false, "20 Oct 2026", "Daily"));

        masterSessions.add(new StudySession(id++, "02:00 PM - 03:00 PM", "#14b8a6", "Internet of Things",
                "Sensors and Actuators", "Notes", "#082f49", "#38bdf8", "1h", 60, false, "20 Oct 2026", "Daily"));

        masterSessions.add(new StudySession(id++, "03:15 PM - 04:15 PM", "#ef4444", "DSA",
                "Graph Algorithms", "Practice", "#064e3b", "#34d399", "1h", 60, false, "20 Oct 2026", "Daily"));

        masterSessions.add(new StudySession(id++, "04:30 PM - 05:00 PM", "#8b5cf6", "Project Work",
                "SlotWise - Module", "Project", "#4a044e", "#f472b6", "30m", 30, false, "20 Oct 2026", "Daily"));

        // Goals
        masterGoals.clear();
        int gid = 1;
        masterGoals.add(new StudyGoal(gid++, "Complete DBMS Unit 3", 60, "#8b5cf6", false));
        masterGoals.add(new StudyGoal(gid++, "Revise Java for CAT 1", 40, "#3b82f6", false));
        masterGoals.add(new StudyGoal(gid++, "Finish IoT Notes", 80, "#10b981", false));
        masterGoals.add(new StudyGoal(gid++, "Solve 50 DSA Problems", 30, "#6366f1", false));

        // Recommendations
        masterRecommendations.clear();
        int rid = 1;
        masterRecommendations.add(new Recommendation(rid++, "Revise Previous Year Questions", "DBMS", "30 mins", 30, "file", "#1e3a8a", "#60a5fa"));
        masterRecommendations.add(new Recommendation(rid++, "Practice Graph Problems", "DSA", "45 mins", 45, "chart", "#831843", "#f43f5e"));
        masterRecommendations.add(new Recommendation(rid++, "Read IoT Summary Notes", "IoT", "20 mins", 20, "book", "#78350f", "#f59e0b"));
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(true);
        if (session.getAttribute("studentName") == null) {
            session.setAttribute("studentName", "Harish M");
            session.setAttribute("yearOfStudy", "CSE - 2nd Year");
        }

        prepareRequestAttributes(request);
        request.getRequestDispatcher("/study-planner.jsp").forward(request, response);
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
                String timeframe = request.getParameter("timeframe");
                String search = request.getParameter("search");
                List<StudySession> filtered = getFilteredSessions(timeframe, search);

                StringBuilder json = new StringBuilder();
                json.append("{\"success\":true,");
                appendMetricsJson(json);
                json.append(",\"sessions\":[");
                for (int i = 0; i < filtered.size(); i++) {
                    if (i > 0) json.append(",");
                    appendSessionJson(json, filtered.get(i));
                }
                json.append("]}");
                out.print(json.toString());
                return;

            } else if ("toggleComplete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                boolean nowCompleted = false;
                for (StudySession s : masterSessions) {
                    if (s.getId() == id) {
                        s.setCompleted(!s.isCompleted());
                        nowCompleted = s.isCompleted();
                        if (nowCompleted) {
                            totalTasksCompleted++;
                            actualStudyMinutes += s.getDurationMinutes();
                        } else {
                            if (totalTasksCompleted > 0) totalTasksCompleted--;
                            if (actualStudyMinutes >= s.getDurationMinutes()) actualStudyMinutes -= s.getDurationMinutes();
                        }
                        break;
                    }
                }

                StringBuilder json = new StringBuilder();
                json.append("{\"success\":true,\"completed\":").append(nowCompleted).append(",");
                appendMetricsJson(json);
                json.append("}");
                out.print(json.toString());
                return;

            } else if ("markAllComplete".equals(action)) {
                for (StudySession s : masterSessions) {
                    if (!s.isCompleted()) {
                        s.setCompleted(true);
                        totalTasksCompleted++;
                        actualStudyMinutes += s.getDurationMinutes();
                    }
                }
                StringBuilder json = new StringBuilder();
                json.append("{\"success\":true,\"message\":\"All sessions marked as complete\",");
                appendMetricsJson(json);
                json.append("}");
                out.print(json.toString());
                return;

            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                masterSessions.removeIf(s -> s.getId() == id);

                StringBuilder json = new StringBuilder();
                json.append("{\"success\":true,\"message\":\"Session deleted\",");
                appendMetricsJson(json);
                json.append("}");
                out.print(json.toString());
                return;

            } else if ("add".equals(action)) {
                String timeRange = request.getParameter("timeRange");
                String subject = request.getParameter("subject");
                String topic = request.getParameter("topic");
                String type = request.getParameter("type");
                String duration = request.getParameter("duration");

                if (timeRange == null || timeRange.trim().isEmpty()) timeRange = "05:15 PM - 06:15 PM";
                if (subject == null || subject.trim().isEmpty()) subject = "General Study";
                if (topic == null || topic.trim().isEmpty()) topic = "Self Review";
                if (type == null || type.trim().isEmpty()) type = "Practice";
                if (duration == null || duration.trim().isEmpty()) duration = "1h";

                int durMins = parseDurationMinutes(duration);
                plannedStudyMinutes += durMins;

                int newId = masterSessions.stream().mapToInt(StudySession::getId).max().orElse(0) + 1;
                String accent = getAccentColor(subject);
                String[] typeColors = getTypeColors(type);

                StudySession newSession = new StudySession(newId, timeRange, accent, subject, topic,
                        type, typeColors[0], typeColors[1], duration, durMins, false, "20 Oct 2026", "Daily");
                masterSessions.add(newSession);

                StringBuilder json = new StringBuilder();
                json.append("{\"success\":true,\"message\":\"Session added successfully!\",");
                appendMetricsJson(json);
                json.append("}");
                out.print(json.toString());
                return;

            } else if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                String timeRange = request.getParameter("timeRange");
                String subject = request.getParameter("subject");
                String topic = request.getParameter("topic");
                String type = request.getParameter("type");
                String duration = request.getParameter("duration");

                for (StudySession s : masterSessions) {
                    if (s.getId() == id) {
                        if (timeRange != null && !timeRange.trim().isEmpty()) s.setTimeRange(timeRange);
                        if (subject != null && !subject.trim().isEmpty()) {
                            s.setSubject(subject);
                            s.setAccentColor(getAccentColor(subject));
                        }
                        if (topic != null && !topic.trim().isEmpty()) s.setTopic(topic);
                        if (type != null && !type.trim().isEmpty()) {
                            s.setType(type);
                            String[] tc = getTypeColors(type);
                            s.setTypeBg(tc[0]);
                            s.setTypeColor(tc[1]);
                        }
                        if (duration != null && !duration.trim().isEmpty()) {
                            s.setDuration(duration);
                            s.setDurationMinutes(parseDurationMinutes(duration));
                        }
                        break;
                    }
                }

                StringBuilder json = new StringBuilder();
                json.append("{\"success\":true,\"message\":\"Session updated successfully!\",");
                appendMetricsJson(json);
                json.append("}");
                out.print(json.toString());
                return;

            } else if ("toggleGoal".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                for (StudyGoal g : masterGoals) {
                    if (g.getId() == id) {
                        g.setCompleted(!g.isCompleted());
                        break;
                    }
                }
                StringBuilder json = new StringBuilder();
                json.append("{\"success\":true,\"message\":\"Goal updated\"}");
                out.print(json.toString());
                return;

            } else if ("startRecommendation".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                Recommendation rec = masterRecommendations.stream().filter(r -> r.getId() == id).findFirst().orElse(null);
                if (rec != null) {
                    int newId = masterSessions.stream().mapToInt(StudySession::getId).max().orElse(0) + 1;
                    String timeRange = "05:30 PM - 06:00 PM";
                    String accent = getAccentColor(rec.getSubject());
                    String[] typeColors = getTypeColors("Practice");
                    StudySession recSession = new StudySession(newId, timeRange, accent, rec.getSubject(),
                            rec.getTitle(), "Practice", typeColors[0], typeColors[1], rec.getDuration(),
                            rec.getDurationMinutes(), false, "20 Oct 2026", "Daily");
                    masterSessions.add(recSession);
                    plannedStudyMinutes += rec.getDurationMinutes();
                }

                StringBuilder json = new StringBuilder();
                json.append("{\"success\":true,\"message\":\"Recommendation added to today's schedule!\",");
                appendMetricsJson(json);
                json.append("}");
                out.print(json.toString());
                return;

            } else if ("logTimerCompleted".equals(action)) {
                int minutes = 25;
                try {
                    minutes = Integer.parseInt(request.getParameter("minutes"));
                } catch (Exception ignored) {}
                actualStudyMinutes += minutes;

                StringBuilder json = new StringBuilder();
                json.append("{\"success\":true,\"message\":\"Study time logged successfully!\",");
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

    private void prepareRequestAttributes(HttpServletRequest request) {
        long subjectsCount = masterSessions.stream().map(StudySession::getSubject).distinct().count();
        if (subjectsCount < 5) subjectsCount = 5;

        request.setAttribute("subjectsPlannedCount", subjectsCount);
        request.setAttribute("tasksCompletedCount", totalTasksCompleted);
        request.setAttribute("plannedStudyTime", formatHoursMinutes(plannedStudyMinutes));
        request.setAttribute("actualStudyTime", formatHoursMinutes(actualStudyMinutes));
        request.setAttribute("streakDays", streakDays);

        request.setAttribute("sessionsList", new ArrayList<>(masterSessions));
        request.setAttribute("goalsList", new ArrayList<>(masterGoals));
        request.setAttribute("recommendationsList", new ArrayList<>(masterRecommendations));
    }

    private List<StudySession> getFilteredSessions(String timeframe, String search) {
        List<StudySession> list = new ArrayList<>(masterSessions);

        if (timeframe != null && !timeframe.trim().isEmpty() && !"Daily".equalsIgnoreCase(timeframe)) {
            // Can filter or adapt if needed
        }

        if (search != null && !search.trim().isEmpty()) {
            String q = search.trim().toLowerCase();
            list = list.stream().filter(s ->
                    s.getSubject().toLowerCase().contains(q) ||
                    s.getTopic().toLowerCase().contains(q) ||
                    s.getType().toLowerCase().contains(q)
            ).collect(Collectors.toList());
        }

        return list;
    }

    private void appendMetricsJson(StringBuilder json) {
        long subjectsCount = masterSessions.stream().map(StudySession::getSubject).distinct().count();
        if (subjectsCount < 5) subjectsCount = 5;

        json.append("\"subjectsPlanned\":").append(subjectsCount).append(",");
        json.append("\"tasksCompleted\":").append(totalTasksCompleted).append(",");
        json.append("\"plannedStudyTime\":\"").append(formatHoursMinutes(plannedStudyMinutes)).append("\",");
        json.append("\"actualStudyTime\":\"").append(formatHoursMinutes(actualStudyMinutes)).append("\",");
        json.append("\"streakDays\":").append(streakDays);
    }

    private void appendSessionJson(StringBuilder json, StudySession s) {
        json.append("{");
        json.append("\"id\":").append(s.getId()).append(",");
        json.append("\"timeRange\":\"").append(escapeJson(s.getTimeRange())).append("\",");
        json.append("\"accentColor\":\"").append(escapeJson(s.getAccentColor())).append("\",");
        json.append("\"subject\":\"").append(escapeJson(s.getSubject())).append("\",");
        json.append("\"topic\":\"").append(escapeJson(s.getTopic())).append("\",");
        json.append("\"type\":\"").append(escapeJson(s.getType())).append("\",");
        json.append("\"typeBg\":\"").append(escapeJson(s.getTypeBg())).append("\",");
        json.append("\"typeColor\":\"").append(escapeJson(s.getTypeColor())).append("\",");
        json.append("\"duration\":\"").append(escapeJson(s.getDuration())).append("\",");
        json.append("\"durationMinutes\":").append(s.getDurationMinutes()).append(",");
        json.append("\"completed\":").append(s.isCompleted()).append(",");
        json.append("\"date\":\"").append(escapeJson(s.getDate())).append("\"");
        json.append("}");
    }

    private String formatHoursMinutes(int totalMinutes) {
        int h = totalMinutes / 60;
        int m = totalMinutes % 60;
        if (m == 0) return h + "h";
        return h + "h " + m + "m";
    }

    private int parseDurationMinutes(String d) {
        if (d == null) return 60;
        d = d.trim().toLowerCase();
        if (d.contains("h")) {
            try {
                String[] parts = d.split("h");
                int hours = Integer.parseInt(parts[0].trim());
                int mins = 0;
                if (parts.length > 1 && parts[1].contains("m")) {
                    mins = Integer.parseInt(parts[1].replace("m", "").trim());
                }
                return hours * 60 + mins;
            } catch (Exception e) {
                return 60;
            }
        } else if (d.contains("m")) {
            try {
                return Integer.parseInt(d.replace("m", "").replace("mins", "").replace("min", "").trim());
            } catch (Exception e) {
                return 30;
            }
        }
        return 60;
    }

    private String getAccentColor(String subject) {
        if (subject == null) return "#6366f1";
        String s = subject.toLowerCase();
        if (s.contains("data structure")) return "#f97316";
        if (s.contains("dbms")) return "#06b6d4";
        if (s.contains("java")) return "#3b82f6";
        if (s.contains("math")) return "#10b981";
        if (s.contains("iot") || s.contains("internet")) return "#14b8a6";
        if (s.contains("dsa")) return "#ef4444";
        if (s.contains("project")) return "#8b5cf6";
        return "#a855f7";
    }

    private String[] getTypeColors(String type) {
        if ("Lecture".equalsIgnoreCase(type)) {
            return new String[]{"#1e1b4b", "#818cf8"};
        } else if ("Notes".equalsIgnoreCase(type)) {
            return new String[]{"#082f49", "#38bdf8"};
        } else if ("Practice".equalsIgnoreCase(type)) {
            return new String[]{"#064e3b", "#34d399"};
        } else if ("Revision".equalsIgnoreCase(type)) {
            return new String[]{"#451a03", "#fbbf24"};
        } else if ("Project".equalsIgnoreCase(type)) {
            return new String[]{"#4a044e", "#f472b6"};
        }
        return new String[]{"#1e293b", "#94a3b8"};
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "");
    }
}
