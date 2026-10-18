package com.slotwise.servlet;

import com.slotwise.dao.StudentDAO;
import com.slotwise.model.Student;
import org.mindrot.jbcrypt.BCrypt;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.regex.Pattern;

/**
 * SettingsServlet — Student Profile, Security & Preferences Controller
 * ======================================================================
 * Handles all settings actions according to the SlotWise specification:
 * 1. Profile information editing (Name, Email, Roll Number, Department)
 * 2. Password change with multi-criteria complexity verification
 * 3. Notification preferences toggles (Task reminders, Timetable updates, Weekly summary)
 * 4. Appearance theme preference selection (Dark / Light)
 * 5. Data & Privacy overview
 */
public class SettingsServlet extends HttpServlet {

    private final StudentDAO studentDAO = new StudentDAO();

    // Password validation patterns
    private static final Pattern UPPERCASE_PATTERN = Pattern.compile("[A-Z]");
    private static final Pattern LOWERCASE_PATTERN = Pattern.compile("[a-z]");
    private static final Pattern DIGIT_PATTERN = Pattern.compile("[0-9]");
    private static final Pattern SPECIAL_PATTERN = Pattern.compile("[!@#$%^&*(),.?\":{}|<>]");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("studentId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int studentId = (int) session.getAttribute("studentId");
        String section = request.getParameter("section");
        if (section == null || section.trim().isEmpty()) {
            section = "profile";
        }
        request.setAttribute("activeSection", section);

        String mode = request.getParameter("mode");
        request.setAttribute("mode", mode);

        try {
            Student student = studentDAO.findById(studentId);
            if (student != null) {
                request.setAttribute("student", student);
                // Keep session updated
                session.setAttribute("studentName", student.getFullName());
                session.setAttribute("studentEmail", student.getEmail());
                session.setAttribute("studentDepartment", student.getDepartment());
                session.setAttribute("studentYear", student.getYearOfStudy());
                session.setAttribute("themePreference", student.getThemePreference());
            } else {
                request.setAttribute("error", "Student account not found.");
            }
        } catch (Exception e) {
            System.err.println("[SettingsServlet] Error loading student profile: " + e.getMessage());
            request.setAttribute("error", "Could not load settings data. Please try again.");
        }

        request.getRequestDispatcher("/settings.jsp").forward(request, response);
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
        String section = request.getParameter("section");
        if (section == null || section.trim().isEmpty()) {
            section = "profile";
        }
        request.setAttribute("activeSection", section);

        try {
            if ("updateProfile".equals(action)) {
                handleUpdateProfile(request, session, studentId);
            } else if ("changePassword".equals(action)) {
                handleChangePassword(request, studentId);
            } else if ("updateNotifications".equals(action)) {
                handleUpdateNotifications(request, studentId);
            } else if ("updateTheme".equals(action)) {
                handleUpdateTheme(request, session, studentId);
            }

            // Reload fresh student record
            Student student = studentDAO.findById(studentId);
            request.setAttribute("student", student);

        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            try {
                request.setAttribute("student", studentDAO.findById(studentId));
            } catch (Exception ignored) {}
        } catch (Exception e) {
            System.err.println("[SettingsServlet] Exception during action [" + action + "]: " + e.getMessage());
            request.setAttribute("error", "An unexpected error occurred while processing your request.");
            try {
                request.setAttribute("student", studentDAO.findById(studentId));
            } catch (Exception ignored) {}
        }

        request.getRequestDispatcher("/settings.jsp").forward(request, response);
    }

    /**
     * Handles updating full name, email, roll number, and department.
     */
    private void handleUpdateProfile(HttpServletRequest request, HttpSession session, int studentId)
            throws Exception {
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String rollNumber = request.getParameter("rollNumber");
        String department = request.getParameter("department");
        String yearOfStudy = request.getParameter("yearOfStudy");

        if (fullName == null || fullName.trim().isEmpty()) {
            throw new IllegalArgumentException("Full name is required.");
        }
        if (email == null || !email.contains("@")) {
            throw new IllegalArgumentException("A valid email address is required.");
        }

        // Check if email changed and if already taken by another student
        Student existing = studentDAO.findById(studentId);
        if (existing != null && !existing.getEmail().equalsIgnoreCase(email.trim())) {
            if (studentDAO.emailExists(email.trim())) {
                throw new IllegalArgumentException("Email address is already in use by another account.");
            }
        }

        Student student = new Student();
        student.setStudentId(studentId);
        student.setFullName(fullName.trim());
        student.setEmail(email.trim().toLowerCase());
        student.setRollNumber(rollNumber != null && !rollNumber.trim().isEmpty() ? rollNumber.trim() : "250701626");
        student.setDepartment(department != null && !department.trim().isEmpty() ? department.trim() : "Computer Science and Engineering");
        student.setYearOfStudy(yearOfStudy != null && !yearOfStudy.trim().isEmpty() ? yearOfStudy.trim() : "CSE - 2nd Year");

        if (studentDAO.updateStudent(student)) {
            session.setAttribute("studentName", student.getFullName());
            session.setAttribute("studentEmail", student.getEmail());
            session.setAttribute("studentDepartment", student.getDepartment());
            session.setAttribute("studentYear", student.getYearOfStudy());
            request.setAttribute("success", "Profile details updated successfully!");
        } else {
            request.setAttribute("error", "Failed to update profile details. Please try again.");
        }
    }

    /**
     * Handles password change with strict criteria validation.
     */
    private void handleChangePassword(HttpServletRequest request, int studentId) throws Exception {
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (currentPassword == null || currentPassword.isEmpty()) {
            throw new IllegalArgumentException("Please enter your current password.");
        }
        if (newPassword == null || newPassword.isEmpty()) {
            throw new IllegalArgumentException("Please enter a new password.");
        }
        if (!newPassword.equals(confirmPassword)) {
            throw new IllegalArgumentException("New password and confirmation do not match.");
        }

        // Validate password complexity criteria per UI reference:
        // 1. At least 8 characters
        if (newPassword.length() < 8) {
            throw new IllegalArgumentException("Password must be at least 8 characters long.");
        }
        // 2. Include uppercase letter (A-Z)
        if (!UPPERCASE_PATTERN.matcher(newPassword).find()) {
            throw new IllegalArgumentException("Password must contain at least one uppercase letter (A-Z).");
        }
        // 3. Include lowercase letter (a-z)
        if (!LOWERCASE_PATTERN.matcher(newPassword).find()) {
            throw new IllegalArgumentException("Password must contain at least one lowercase letter (a-z).");
        }
        // 4. Include a number (0-9)
        if (!DIGIT_PATTERN.matcher(newPassword).find()) {
            throw new IllegalArgumentException("Password must contain at least one number (0-9).");
        }
        // 5. Include a special character (!@#)
        if (!SPECIAL_PATTERN.matcher(newPassword).find()) {
            throw new IllegalArgumentException("Password must contain at least one special character (!@#$%^&* etc.).");
        }

        // Verify current password against database hash
        Student student = studentDAO.findById(studentId);
        if (student == null || !BCrypt.checkpw(currentPassword, student.getPasswordHash())) {
            throw new IllegalArgumentException("Current password is incorrect.");
        }

        // Prevent reusing same password
        if (BCrypt.checkpw(newPassword, student.getPasswordHash())) {
            throw new IllegalArgumentException("New password cannot be the same as your current password.");
        }

        // Generate salted BCrypt hash (10 rounds)
        String newHash = BCrypt.hashpw(newPassword, BCrypt.gensalt(10));
        if (studentDAO.updatePassword(studentId, newHash)) {
            request.setAttribute("success", "Password updated successfully! Your account is secure.");
        } else {
            request.setAttribute("error", "Failed to update password in database.");
        }
    }

    /**
     * Handles notification preference toggles.
     */
    private void handleUpdateNotifications(HttpServletRequest request, int studentId) throws Exception {
        boolean taskReminders = "on".equalsIgnoreCase(request.getParameter("taskReminders"))
                || "true".equalsIgnoreCase(request.getParameter("taskReminders"));
        boolean timetableUpdates = "on".equalsIgnoreCase(request.getParameter("timetableUpdates"))
                || "true".equalsIgnoreCase(request.getParameter("timetableUpdates"));
        boolean weeklySummary = "on".equalsIgnoreCase(request.getParameter("weeklySummary"))
                || "true".equalsIgnoreCase(request.getParameter("weeklySummary"));

        if (studentDAO.updateNotificationPreferences(studentId, taskReminders, timetableUpdates, weeklySummary)) {
            request.setAttribute("success", "Notification preferences saved successfully!");
        } else {
            request.setAttribute("error", "Could not save notification preferences.");
        }
    }

    /**
     * Handles theme selection (Dark / Light Mode).
     */
    private void handleUpdateTheme(HttpServletRequest request, HttpSession session, int studentId) throws Exception {
        String theme = request.getParameter("theme");
        if (theme == null || (!theme.equalsIgnoreCase("light") && !theme.equalsIgnoreCase("dark"))) {
            theme = "dark";
        }
        theme = theme.toLowerCase();

        if (studentDAO.updateThemePreference(studentId, theme)) {
            session.setAttribute("themePreference", theme);
            request.setAttribute("success", "Appearance preference saved: " + theme.toUpperCase() + " Mode.");
        } else {
            request.setAttribute("error", "Could not save theme preference.");
        }
    }
}
