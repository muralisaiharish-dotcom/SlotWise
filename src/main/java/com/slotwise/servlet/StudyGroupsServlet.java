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
 * StudyGroupsServlet — Complete backend servlet for Study Groups.
 * Supports group creation, joining/leaving groups, search, category filtering,
 * upcoming study session RSVPs, real-time activity stream, and group chats.
 */
public class StudyGroupsServlet extends HttpServlet {

    public static class StudyGroup {
        private int id;
        private String name;
        private String category;      // "Academic", "Exam", "Project", "Others"
        private String categoryColor; // pill color
        private String subject;       // "DBMS", "Java", "DSA", "IoT", "CSE", "Others"
        private String description;
        private int memberCount;
        private String department;    // "CSE"
        private int additionalAvatars;
        private boolean joined;
        private String iconType;      // "database", "java", "network", "broadcast", "document", "bulb", "code", "math"
        private String iconBg;
        private String iconColor;
        private List<String> chatMessages;

        public StudyGroup(int id, String name, String category, String categoryColor,
                          String subject, String description, int memberCount,
                          String department, int additionalAvatars, boolean joined,
                          String iconType, String iconBg, String iconColor) {
            this.id = id;
            this.name = name;
            this.category = category;
            this.categoryColor = categoryColor;
            this.subject = subject;
            this.description = description;
            this.memberCount = memberCount;
            this.department = department;
            this.additionalAvatars = additionalAvatars;
            this.joined = joined;
            this.iconType = iconType;
            this.iconBg = iconBg;
            this.iconColor = iconColor;
            this.chatMessages = new CopyOnWriteArrayList<>();
        }

        public int getId() { return id; }
        public String getName() { return name; }
        public String getCategory() { return category; }
        public String getCategoryColor() { return categoryColor; }
        public String getSubject() { return subject; }
        public String getDescription() { return description; }
        public int getMemberCount() { return memberCount; }
        public String getDepartment() { return department; }
        public int getAdditionalAvatars() { return additionalAvatars; }
        public boolean isJoined() { return joined; }
        public String getIconType() { return iconType; }
        public String getIconBg() { return iconBg; }
        public String getIconColor() { return iconColor; }
        public List<String> getChatMessages() { return chatMessages; }

        public void setJoined(boolean joined) {
            this.joined = joined;
            if (joined) {
                this.memberCount++;
                this.additionalAvatars++;
            } else {
                if (this.memberCount > 1) this.memberCount--;
                if (this.additionalAvatars > 0) this.additionalAvatars--;
            }
        }

        public void addChatMessage(String message) {
            this.chatMessages.add(message);
        }
    }

    public static class StudySessionItem {
        private int id;
        private String month;
        private String day;
        private String title;
        private String timeRange;
        private boolean joined;
        private String subject;

        public StudySessionItem(int id, String month, String day, String title, String timeRange, boolean joined, String subject) {
            this.id = id;
            this.month = month;
            this.day = day;
            this.title = title;
            this.timeRange = timeRange;
            this.joined = joined;
            this.subject = subject;
        }

        public int getId() { return id; }
        public String getMonth() { return month; }
        public String getDay() { return day; }
        public String getTitle() { return title; }
        public String getTimeRange() { return timeRange; }
        public boolean isJoined() { return joined; }
        public String getSubject() { return subject; }

        public void setJoined(boolean joined) { this.joined = joined; }
    }

    public static class RecommendedGroup {
        private int id;
        private String name;
        private String membersText;
        private int memberCount;
        private String iconSymbol;    // "Σ", "grad", "code", "chart"
        private String iconBg;
        private String iconColor;
        private boolean joined;

        public RecommendedGroup(int id, String name, String membersText, int memberCount,
                                String iconSymbol, String iconBg, String iconColor, boolean joined) {
            this.id = id;
            this.name = name;
            this.membersText = membersText;
            this.memberCount = memberCount;
            this.iconSymbol = iconSymbol;
            this.iconBg = iconBg;
            this.iconColor = iconColor;
            this.joined = joined;
        }

        public int getId() { return id; }
        public String getName() { return name; }
        public String getMembersText() { return membersText; }
        public int getMemberCount() { return memberCount; }
        public String getIconSymbol() { return iconSymbol; }
        public String getIconBg() { return iconBg; }
        public String getIconColor() { return iconColor; }
        public boolean isJoined() { return joined; }

        public void setJoined(boolean joined) {
            this.joined = joined;
            if (joined) {
                this.memberCount++;
                this.membersText = this.memberCount + " members";
            } else {
                if (this.memberCount > 1) {
                    this.memberCount--;
                    this.membersText = this.memberCount + " members";
                }
            }
        }
    }

    public static class ActivityItem {
        private int id;
        private String type;         // "join", "file", "chat", "calendar"
        private String text;
        private String timeAgo;
        private String iconBg;
        private String iconColor;

        public ActivityItem(int id, String type, String text, String timeAgo, String iconBg, String iconColor) {
            this.id = id;
            this.type = type;
            this.text = text;
            this.timeAgo = timeAgo;
            this.iconBg = iconBg;
            this.iconColor = iconColor;
        }

        public int getId() { return id; }
        public String getType() { return type; }
        public String getText() { return text; }
        public String getTimeAgo() { return timeAgo; }
        public String getIconBg() { return iconBg; }
        public String getIconColor() { return iconColor; }
    }

    // In-memory master thread-safe collections
    public static final List<StudyGroup> masterGroups = new CopyOnWriteArrayList<>();
    public static final List<RecommendedGroup> masterRecommended = new CopyOnWriteArrayList<>();
    public static final List<StudySessionItem> masterSessions = new CopyOnWriteArrayList<>();
    public static final List<ActivityItem> masterActivities = new CopyOnWriteArrayList<>();

    private static int totalStudySessionsCount = 18;
    private static int activeParticipationRate = 92;

    static {
        initDefaultData();
    }

    public static synchronized void initDefaultData() {
        if (!masterGroups.isEmpty()) return;

        // 6 Main study groups from reference image
        int id = 1;
        StudyGroup g1 = new StudyGroup(id++, "DBMS Core Group", "Academic", "rgba(139, 92, 246, 0.25)",
                "DBMS", "For DBMS notes, doubt solving and previous year questions.", 12, "CSE", 8, false,
                "database", "rgba(139, 92, 246, 0.18)", "#a78bfa");
        g1.addChatMessage("Arjun: Hey everyone, who has the notes for B-Trees and B+ Trees?");
        g1.addChatMessage("Sneha: I uploaded the handwritten PDF in unit 3 folder!");
        masterGroups.add(g1);

        StudyGroup g2 = new StudyGroup(id++, "Java Learners", "Academic", "rgba(16, 185, 129, 0.22)",
                "Java", "Practice programs, mini projects and concept discussions.", 15, "CSE", 11, true,
                "java", "rgba(245, 158, 11, 0.18)", "#fbbf24");
        g2.addChatMessage("Priya: Don't forget tomorrow's lab on Multi-threading and ExecutorService.");
        g2.addChatMessage("Harish: Thanks! Just tested the deadlock scenario code.");
        masterGroups.add(g2);

        StudyGroup g3 = new StudyGroup(id++, "DSA Problem Solvers", "Academic", "rgba(139, 92, 246, 0.25)",
                "DSA", "Daily problem solving, contests and solutions discussion.", 20, "CSE", 16, true,
                "network", "rgba(16, 185, 129, 0.18)", "#34d399");
        g3.addChatMessage("Karthik: Daily Leetcode challenge is today's binary search on answer!");
        masterGroups.add(g3);

        StudyGroup g4 = new StudyGroup(id++, "IoT Explorers", "Academic", "rgba(6, 182, 212, 0.22)",
                "IoT", "For IoT concepts, NPTEL preparation and hands-on learning.", 10, "CSE", 6, false,
                "broadcast", "rgba(6, 182, 212, 0.18)", "#38bdf8");
        g4.addChatMessage("Rahul: The ESP32 circuit simulation on Wokwi is working smoothly.");
        masterGroups.add(g4);

        StudyGroup g5 = new StudyGroup(id++, "CAT 1 Prep Group", "Exam", "rgba(59, 130, 246, 0.25)",
                "CSE", "Unit-wise discussions and important questions.", 14, "CSE", 10, true,
                "document", "rgba(59, 130, 246, 0.18)", "#60a5fa");
        g5.addChatMessage("Sneha: CAT 1 syllabus for Math and DBMS is fully locked now.");
        masterGroups.add(g5);

        StudyGroup g6 = new StudyGroup(id++, "Project Collaborators", "Project", "rgba(249, 115, 22, 0.25)",
                "CSE", "Find teammates, share ideas and build together.", 8, "CSE", 4, false,
                "bulb", "rgba(249, 115, 22, 0.18)", "#fb923c");
        g6.addChatMessage("Dev: Anyone looking for a frontend developer for the SlotWise hackathon project?");
        masterGroups.add(g6);

        // Recommended groups
        int rid = 1;
        masterRecommended.add(new RecommendedGroup(rid++, "Mathematics Circle", "9 members", 9, "sigma", "rgba(139, 92, 246, 0.18)", "#c084fc", false));
        masterRecommended.add(new RecommendedGroup(rid++, "NPTEL Buddies", "18 members", 18, "grad", "rgba(59, 130, 246, 0.18)", "#60a5fa", false));
        masterRecommended.add(new RecommendedGroup(rid++, "OOPs Discussion", "11 members", 11, "code", "rgba(139, 92, 246, 0.18)", "#a78bfa", false));
        masterRecommended.add(new RecommendedGroup(rid++, "Placement Prep", "25 members", 25, "chart", "rgba(99, 102, 241, 0.18)", "#818cf8", false));

        // Upcoming sessions
        int sid = 1;
        masterSessions.add(new StudySessionItem(sid++, "OCT", "20", "DBMS Discussion", "06:00 PM - 07:00 PM", false, "DBMS"));
        masterSessions.add(new StudySessionItem(sid++, "OCT", "21", "DSA Problem Solving", "05:00 PM - 06:00 PM", false, "DSA"));
        masterSessions.add(new StudySessionItem(sid++, "OCT", "22", "Java Doubt Session", "07:00 PM - 08:00 PM", false, "Java"));
        masterSessions.add(new StudySessionItem(sid++, "OCT", "24", "IoT Revision", "06:00 PM - 07:00 PM", false, "IoT"));

        // Recent activity
        int aid = 1;
        masterActivities.add(new ActivityItem(aid++, "join", "Arjun joined DBMS Core Group", "2 hours ago", "rgba(59, 130, 246, 0.2)", "#60a5fa"));
        masterActivities.add(new ActivityItem(aid++, "file", "Priya shared a file in Java Learners", "3 hours ago", "rgba(139, 92, 246, 0.2)", "#c084fc"));
        masterActivities.add(new ActivityItem(aid++, "chat", "Karthik started a discussion in DSA Problem Solvers", "5 hours ago", "rgba(245, 158, 11, 0.2)", "#fbbf24"));
        masterActivities.add(new ActivityItem(aid++, "calendar", "Sneha scheduled a session in CAT 1 Prep Group", "7 hours ago", "rgba(59, 130, 246, 0.2)", "#38bdf8"));
    }

    public static int getJoinedGroupsCount() {
        int count = 0;
        for (StudyGroup g : masterGroups) {
            if (g.isJoined()) count++;
        }
        for (RecommendedGroup r : masterRecommended) {
            if (r.isJoined()) count++;
        }
        return Math.max(count, 6);
    }

    public static int getTotalMembersCount() {
        int total = 0;
        for (StudyGroup g : masterGroups) {
            total += g.getMemberCount();
        }
        return Math.max(total, 42);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(true);
        if (session.getAttribute("studentName") == null) {
            session.setAttribute("studentName", "Harish M");
            session.setAttribute("yearOfStudy", "CSE - 2nd Year");
        }

        populateAttributes(request);
        request.getRequestDispatcher("/study-groups.jsp").forward(request, response);
    }

    private void populateAttributes(HttpServletRequest request) {
        request.setAttribute("groups", masterGroups);
        request.setAttribute("recommended", masterRecommended);
        request.setAttribute("sessions", masterSessions);
        request.setAttribute("activities", masterActivities);
        request.setAttribute("joinedGroupsCount", getJoinedGroupsCount());
        request.setAttribute("totalMembersCount", getTotalMembersCount());
        request.setAttribute("studySessionsCount", totalStudySessionsCount);
        request.setAttribute("activeParticipationRate", activeParticipationRate);
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
            if ("toggleJoinGroup".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                StudyGroup target = null;
                for (StudyGroup g : masterGroups) {
                    if (g.getId() == id) {
                        target = g;
                        break;
                    }
                }
                if (target != null) {
                    target.setJoined(!target.isJoined());
                    String userName = "Harish";
                    if (target.isJoined()) {
                        masterActivities.add(0, new ActivityItem(
                                (int) System.currentTimeMillis(),
                                "join",
                                userName + " joined " + target.getName(),
                                "Just now",
                                "rgba(59, 130, 246, 0.2)",
                                "#60a5fa"
                        ));
                    }
                    sendJsonResponse(out, true, "Group status updated", target);
                } else {
                    out.print("{\"success\":false,\"message\":\"Group not found\"}");
                }
                return;

            } else if ("toggleJoinRecommended".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                RecommendedGroup target = null;
                for (RecommendedGroup r : masterRecommended) {
                    if (r.getId() == id) {
                        target = r;
                        break;
                    }
                }
                if (target != null) {
                    target.setJoined(!target.isJoined());
                    if (target.isJoined()) {
                        masterActivities.add(0, new ActivityItem(
                                (int) System.currentTimeMillis(),
                                "join",
                                "You joined " + target.getName(),
                                "Just now",
                                "rgba(139, 92, 246, 0.2)",
                                "#c084fc"
                        ));
                    }
                    StringBuilder json = new StringBuilder();
                    json.append("{\"success\":true,\"joined\":").append(target.isJoined())
                        .append(",\"membersText\":\"").append(target.getMembersText()).append("\"")
                        .append(",\"joinedCount\":").append(getJoinedGroupsCount())
                        .append(",\"totalMembers\":").append(getTotalMembersCount())
                        .append("}");
                    out.print(json.toString());
                } else {
                    out.print("{\"success\":false,\"message\":\"Recommended group not found\"}");
                }
                return;

            } else if ("toggleJoinSession".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                StudySessionItem target = null;
                for (StudySessionItem s : masterSessions) {
                    if (s.getId() == id) {
                        target = s;
                        break;
                    }
                }
                if (target != null) {
                    target.setJoined(!target.isJoined());
                    if (target.isJoined()) {
                        totalStudySessionsCount++;
                        masterActivities.add(0, new ActivityItem(
                                (int) System.currentTimeMillis(),
                                "calendar",
                                "You RSVP'd for " + target.getTitle(),
                                "Just now",
                                "rgba(59, 130, 246, 0.2)",
                                "#38bdf8"
                        ));
                    } else {
                        if (totalStudySessionsCount > 18) totalStudySessionsCount--;
                    }
                    out.print("{\"success\":true,\"joined\":" + target.isJoined() + ",\"sessionsCount\":" + totalStudySessionsCount + "}");
                } else {
                    out.print("{\"success\":false,\"message\":\"Session not found\"}");
                }
                return;

            } else if ("createGroup".equals(action)) {
                String name = request.getParameter("name");
                String category = request.getParameter("category");
                String subject = request.getParameter("subject");
                String description = request.getParameter("description");
                String dept = request.getParameter("department");

                if (name == null || name.trim().isEmpty()) name = "New Study Circle";
                if (category == null || category.trim().isEmpty()) category = "Academic";
                if (subject == null || subject.trim().isEmpty()) subject = "CSE";
                if (description == null || description.trim().isEmpty()) description = "Collaborative peer learning and study session group.";
                if (dept == null || dept.trim().isEmpty()) dept = "CSE";

                String catColor = "rgba(139, 92, 246, 0.25)";
                if ("Exam".equalsIgnoreCase(category)) catColor = "rgba(59, 130, 246, 0.25)";
                else if ("Project".equalsIgnoreCase(category)) catColor = "rgba(249, 115, 22, 0.25)";

                String iconType = "network";
                String iconBg = "rgba(99, 102, 241, 0.18)";
                String iconColor = "#818cf8";

                if (subject.toLowerCase().contains("dbms")) {
                    iconType = "database";
                    iconBg = "rgba(139, 92, 246, 0.18)";
                    iconColor = "#a78bfa";
                } else if (subject.toLowerCase().contains("java")) {
                    iconType = "java";
                    iconBg = "rgba(245, 158, 11, 0.18)";
                    iconColor = "#fbbf24";
                } else if (subject.toLowerCase().contains("iot")) {
                    iconType = "broadcast";
                    iconBg = "rgba(6, 182, 212, 0.18)";
                    iconColor = "#38bdf8";
                } else if (category.equalsIgnoreCase("Project")) {
                    iconType = "bulb";
                    iconBg = "rgba(249, 115, 22, 0.18)";
                    iconColor = "#fb923c";
                }

                int newId = masterGroups.size() + 1;
                StudyGroup newGroup = new StudyGroup(newId, name, category, catColor, subject, description,
                        1, dept, 0, true, iconType, iconBg, iconColor);
                newGroup.addChatMessage("Harish created this study group.");
                masterGroups.add(newGroup);

                masterActivities.add(0, new ActivityItem(
                        (int) System.currentTimeMillis(),
                        "chat",
                        "Harish created " + name,
                        "Just now",
                        "rgba(139, 92, 246, 0.2)",
                        "#c084fc"
                ));

                sendJsonResponse(out, true, "Group successfully created!", newGroup);
                return;

            } else if ("postChatMessage".equals(action)) {
                int groupId = Integer.parseInt(request.getParameter("groupId"));
                String message = request.getParameter("message");
                if (message != null && !message.trim().isEmpty()) {
                    for (StudyGroup g : masterGroups) {
                        if (g.getId() == groupId) {
                            g.addChatMessage("Harish: " + message.trim());
                            break;
                        }
                    }
                }
                out.print("{\"success\":true}");
                return;

            } else if ("scheduleSession".equals(action)) {
                String title = request.getParameter("title");
                String timeRange = request.getParameter("timeRange");
                String subject = request.getParameter("subject");
                String day = request.getParameter("day");
                String month = request.getParameter("month");

                if (title == null || title.trim().isEmpty()) title = "Group Study Sync";
                if (timeRange == null || timeRange.trim().isEmpty()) timeRange = "06:00 PM - 07:00 PM";
                if (subject == null || subject.trim().isEmpty()) subject = "General";
                if (day == null || day.trim().isEmpty()) day = "25";
                if (month == null || month.trim().isEmpty()) month = "OCT";

                int sid = masterSessions.size() + 1;
                StudySessionItem newSession = new StudySessionItem(sid, month, day, title, timeRange, true, subject);
                masterSessions.add(newSession);
                totalStudySessionsCount++;

                masterActivities.add(0, new ActivityItem(
                        (int) System.currentTimeMillis(),
                        "calendar",
                        "Harish scheduled " + title,
                        "Just now",
                        "rgba(59, 130, 246, 0.2)",
                        "#38bdf8"
                ));

                out.print("{\"success\":true,\"message\":\"Session scheduled!\",\"sessionsCount\":" + totalStudySessionsCount + "}");
                return;

            } else if ("filter".equals(action)) {
                String tab = request.getParameter("tab");
                String search = request.getParameter("search");
                String subject = request.getParameter("subject");
                String sort = request.getParameter("sort");

                List<StudyGroup> filtered = filterGroups(tab, search, subject, sort);

                StringBuilder json = new StringBuilder();
                json.append("{\"success\":true,");
                json.append("\"joinedCount\":").append(getJoinedGroupsCount()).append(",");
                json.append("\"totalMembers\":").append(getTotalMembersCount()).append(",");
                json.append("\"sessionsCount\":").append(totalStudySessionsCount()).append(",");
                json.append("\"participation\":").append(activeParticipationRate).append(",");
                json.append("\"groups\":[");
                for (int i = 0; i < filtered.size(); i++) {
                    if (i > 0) json.append(",");
                    appendGroupJson(json, filtered.get(i));
                }
                json.append("]}");
                out.print(json.toString());
                return;
            }

            // Default list response
            StringBuilder json = new StringBuilder();
            json.append("{\"success\":true,\"groups\":[");
            for (int i = 0; i < masterGroups.size(); i++) {
                if (i > 0) json.append(",");
                appendGroupJson(json, masterGroups.get(i));
            }
            json.append("]}");
            out.print(json.toString());

        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\":false,\"message\":\"" + e.getMessage() + "\"}");
        }
    }

    private static int totalStudySessionsCount() {
        return totalStudySessionsCount;
    }

    private List<StudyGroup> filterGroups(String tab, String search, String subject, String sort) {
        List<StudyGroup> list = new ArrayList<>(masterGroups);

        // Tab filtering
        if (tab != null && !tab.isEmpty() && !"All Groups".equalsIgnoreCase(tab)) {
            if ("My Groups".equalsIgnoreCase(tab)) {
                list = list.stream().filter(StudyGroup::isJoined).collect(Collectors.toList());
            } else if ("Others".equalsIgnoreCase(tab)) {
                list = list.stream().filter(g -> !"CSE".equalsIgnoreCase(g.getSubject())
                        && !"DSA".equalsIgnoreCase(g.getSubject())
                        && !"DBMS".equalsIgnoreCase(g.getSubject())
                        && !"Java".equalsIgnoreCase(g.getSubject())
                        && !"IoT".equalsIgnoreCase(g.getSubject())).collect(Collectors.toList());
            } else {
                list = list.stream().filter(g -> g.getSubject().equalsIgnoreCase(tab)
                        || g.getName().toLowerCase().contains(tab.toLowerCase())
                        || g.getDepartment().equalsIgnoreCase(tab)).collect(Collectors.toList());
            }
        }

        // Subject dropdown filtering
        if (subject != null && !subject.isEmpty() && !"All Subjects".equalsIgnoreCase(subject)) {
            list = list.stream().filter(g -> g.getSubject().equalsIgnoreCase(subject)
                    || g.getName().toLowerCase().contains(subject.toLowerCase())).collect(Collectors.toList());
        }

        // Search filtering
        if (search != null && !search.trim().isEmpty()) {
            String q = search.trim().toLowerCase();
            list = list.stream().filter(g -> g.getName().toLowerCase().contains(q)
                    || g.getDescription().toLowerCase().contains(q)
                    || g.getSubject().toLowerCase().contains(q)
                    || g.getCategory().toLowerCase().contains(q)
                    || g.getDepartment().toLowerCase().contains(q)).collect(Collectors.toList());
        }

        // Sorting
        if ("Members".equalsIgnoreCase(sort) || "Popular".equalsIgnoreCase(sort)) {
            list.sort((a, b) -> Integer.compare(b.getMemberCount(), a.getMemberCount()));
        } else if ("Name".equalsIgnoreCase(sort)) {
            list.sort(Comparator.comparing(StudyGroup::getName));
        } else {
            // Latest (by ID descending or natural order)
            list.sort((a, b) -> Integer.compare(a.getId(), b.getId()));
        }

        return list;
    }

    private void appendGroupJson(StringBuilder sb, StudyGroup g) {
        sb.append("{")
          .append("\"id\":").append(g.getId()).append(",")
          .append("\"name\":\"").append(escapeJson(g.getName())).append("\",")
          .append("\"category\":\"").append(escapeJson(g.getCategory())).append("\",")
          .append("\"categoryColor\":\"").append(escapeJson(g.getCategoryColor())).append("\",")
          .append("\"subject\":\"").append(escapeJson(g.getSubject())).append("\",")
          .append("\"description\":\"").append(escapeJson(g.getDescription())).append("\",")
          .append("\"memberCount\":").append(g.getMemberCount()).append(",")
          .append("\"department\":\"").append(escapeJson(g.getDepartment())).append("\",")
          .append("\"additionalAvatars\":").append(g.getAdditionalAvatars()).append(",")
          .append("\"joined\":").append(g.isJoined()).append(",")
          .append("\"iconType\":\"").append(escapeJson(g.getIconType())).append("\",")
          .append("\"iconBg\":\"").append(escapeJson(g.getIconBg())).append("\",")
          .append("\"iconColor\":\"").append(escapeJson(g.getIconColor())).append("\"")
          .append("}");
    }

    private void sendJsonResponse(PrintWriter out, boolean success, String message, StudyGroup g) {
        StringBuilder json = new StringBuilder();
        json.append("{\"success\":").append(success).append(",");
        json.append("\"message\":\"").append(escapeJson(message)).append("\",");
        json.append("\"joined\":").append(g.isJoined()).append(",");
        json.append("\"memberCount\":").append(g.getMemberCount()).append(",");
        json.append("\"additionalAvatars\":").append(g.getAdditionalAvatars()).append(",");
        json.append("\"joinedCount\":").append(getJoinedGroupsCount()).append(",");
        json.append("\"totalMembers\":").append(getTotalMembersCount());
        json.append("}");
        out.print(json.toString());
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r");
    }
}
