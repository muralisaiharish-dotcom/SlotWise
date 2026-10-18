<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign In &mdash; SlotWise</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<div class="auth-page">
    <div class="auth-card">
        <a href="${pageContext.request.contextPath}/" class="auth-logo">
            <div class="auth-logo-icon">&#10024;</div>
            <span>SlotWise</span>
        </a>

        <h1 class="auth-title">Welcome Back</h1>
        <p class="auth-subtitle">Sign in to manage your timetable and study plan</p>

        <!-- Error Alert -->
        <c:if test="${not empty error}">
            <div class="alert alert-error">
                <span>&#9888;</span>
                <span>${error}</span>
            </div>
        </c:if>

        <!-- Success Alert -->
        <c:if test="${not empty param.registered}">
            <div class="alert alert-success">
                <span>&#10004;</span>
                <span>Account created successfully! Please sign in.</span>
            </div>
        </c:if>

        <!-- Login Form -->
        <form action="${pageContext.request.contextPath}/login" method="POST" autocomplete="off">
            <div class="form-group">
                <label for="email">Student Email Address</label>
                <input type="email" id="email" name="email" class="form-control"
                       placeholder="student@university.edu"
                       value="${param.email}" required autofocus>
            </div>

            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" class="form-control"
                       placeholder="Enter your password" required>
            </div>

            <div class="form-actions">
                <button type="submit" class="btn btn-primary btn-lg">
                    Sign In &rarr;
                </button>
            </div>
        </form>

        <!-- Demo Account Banner for Evaluator -->
        <div style="margin-top: var(--space-lg); padding: var(--space-md); background: var(--purple-subtle); border: 1px dashed var(--purple-primary); border-radius: var(--radius-md); font-size: 0.82rem; color: var(--text-secondary);">
            <strong style="color: var(--purple-secondary); display: block; margin-bottom: 4px;">&#128064; Quick Evaluator Demo Login:</strong>
            Email: <code style="color: var(--text-primary); font-family: var(--font-mono);">demo@slotwise.com</code><br>
            Password: <code style="color: var(--text-primary); font-family: var(--font-mono);">demo123</code>
        </div>

        <div class="form-link">
            Don't have an account yet?
            <a href="${pageContext.request.contextPath}/register">Create an account</a>
        </div>
    </div>
</div>

</body>
</html>
