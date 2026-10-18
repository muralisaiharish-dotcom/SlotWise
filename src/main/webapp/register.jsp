<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Account &mdash; SlotWise</title>
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

        <h1 class="auth-title">Create Student Account</h1>
        <p class="auth-subtitle">Join SlotWise to automate your academic planning</p>

        <!-- Error Alert -->
        <c:if test="${not empty error}">
            <div class="alert alert-error">
                <span>&#9888;</span>
                <span>${error}</span>
            </div>
        </c:if>

        <!-- Registration Form -->
        <form action="${pageContext.request.contextPath}/register" method="POST" autocomplete="off">
            <div class="form-group">
                <label for="fullName">Full Name</label>
                <input type="text" id="fullName" name="fullName" class="form-control"
                       placeholder="e.g. Alex Henderson"
                       value="${param.fullName}" required autofocus minlength="2">
            </div>

            <div class="form-group">
                <label for="email">Student Email Address</label>
                <input type="email" id="email" name="email" class="form-control"
                       placeholder="student@university.edu"
                       value="${param.email}" required>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" class="form-control"
                           placeholder="At least 6 chars" required minlength="6">
                </div>

                <div class="form-group">
                    <label for="confirmPassword">Confirm Password</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" class="form-control"
                           placeholder="Re-enter password" required minlength="6">
                </div>
            </div>

            <div class="form-actions">
                <button type="submit" class="btn btn-primary btn-lg">
                    Create Account &rarr;
                </button>
            </div>
        </form>

        <div class="form-link">
            Already registered?
            <a href="${pageContext.request.contextPath}/login">Sign in here</a>
        </div>
    </div>
</div>

</body>
</html>
