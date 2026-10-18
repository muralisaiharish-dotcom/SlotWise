package com.slotwise.service;

import com.slotwise.dao.StudentDAO;
import com.slotwise.model.Student;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.SQLException;

/**
 * AuthService — Authentication Business Logic
 * ==============================================
 * Handles registration and login logic with secure password hashing.
 *
 * SECURITY:
 * - Passwords are hashed using BCrypt before storage.
 * - Plaintext passwords are never stored or logged.
 * - Email uniqueness is enforced.
 */
public class AuthService {

    private final StudentDAO studentDAO = new StudentDAO();

    /**
     * Registers a new student account.
     *
     * @param fullName The student's full name
     * @param email    The student's email
     * @param password The plaintext password (will be hashed)
     * @return The created Student object, or null on failure
     * @throws IllegalArgumentException if validation fails
     */
    public Student register(String fullName, String email, String password)
            throws SQLException {

        // Server-side validation
        if (fullName == null || fullName.trim().isEmpty()) {
            throw new IllegalArgumentException("Full name is required.");
        }
        if (email == null || !email.contains("@") || !email.contains(".")) {
            throw new IllegalArgumentException("Please enter a valid email address.");
        }
        if (password == null || password.length() < 6) {
            throw new IllegalArgumentException("Password must be at least 6 characters.");
        }

        // Check for duplicate email
        if (studentDAO.emailExists(email)) {
            throw new IllegalArgumentException("An account with this email already exists.");
        }

        // Hash the password using BCrypt
        String passwordHash = BCrypt.hashpw(password, BCrypt.gensalt(10));

        // Create the student
        Student student = new Student(fullName.trim(), email.trim().toLowerCase(), passwordHash);
        int id = studentDAO.createStudent(student);

        if (id > 0) {
            student.setStudentId(id);
            return student;
        }
        return null;
    }

    /**
     * Authenticates a student by email and password.
     *
     * @param email    The student's email
     * @param password The plaintext password to verify
     * @return The authenticated Student object, or null if credentials are invalid
     */
    public Student login(String email, String password) throws SQLException {
        if (email == null || email.trim().isEmpty()) {
            throw new IllegalArgumentException("Email is required.");
        }
        if (password == null || password.isEmpty()) {
            throw new IllegalArgumentException("Password is required.");
        }

        Student student = studentDAO.findByEmail(email.trim().toLowerCase());

        if (student == null) {
            return null; // Student not found
        }

        // Verify password against stored hash
        if (BCrypt.checkpw(password, student.getPasswordHash())) {
            return student; // Credentials match
        }

        return null; // Password mismatch
    }

    /**
     * Gets a student by ID (for session validation).
     */
    public Student getStudentById(int studentId) throws SQLException {
        return studentDAO.findById(studentId);
    }
}
