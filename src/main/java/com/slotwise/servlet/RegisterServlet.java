package com.slotwise.servlet;

import com.slotwise.model.Student;
import com.slotwise.service.AuthService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * RegisterServlet — Handles student registration
 * =================================================
 * GET:  Displays the registration form (register.jsp)
 * POST: Validates input and creates a new student account
 */
public class RegisterServlet extends HttpServlet {

    private final AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // If already logged in, redirect to dashboard
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("studentId") != null) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        try {
            // Validate password confirmation
            if (password == null || !password.equals(confirmPassword)) {
                throw new IllegalArgumentException("Passwords do not match.");
            }

            Student student = authService.register(fullName, email, password);

            if (student != null) {
                // Auto-login after registration
                HttpSession session = request.getSession(true);
                session.setAttribute("studentId", student.getStudentId());
                session.setAttribute("studentName", student.getFullName());
                session.setAttribute("studentEmail", student.getEmail());

                response.sendRedirect(request.getContextPath() + "/dashboard");
            } else {
                request.setAttribute("error", "Registration failed. Please try again.");
                preserveFormData(request, fullName, email);
                request.getRequestDispatcher("/register.jsp").forward(request, response);
            }
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            preserveFormData(request, fullName, email);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "An error occurred. Please try again later.");
            preserveFormData(request, fullName, email);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }

    private void preserveFormData(HttpServletRequest request, String fullName, String email) {
        request.setAttribute("fullName", fullName);
        request.setAttribute("email", email);
    }
}
