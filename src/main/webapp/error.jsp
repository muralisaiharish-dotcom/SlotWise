<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error &mdash; SlotWise</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<div class="error-page">
    <div>
        <h1>
            <c:choose>
                <c:when test="${not empty pageContext.errorData.statusCode}">
                    ${pageContext.errorData.statusCode}
                </c:when>
                <c:otherwise>
                    404
                </c:otherwise>
            </c:choose>
        </h1>
        <h2>Oops! Something went wrong</h2>
        <p>
            <c:choose>
                <c:when test="${pageContext.errorData.statusCode == 404}">
                    The page or resource you requested could not be located.
                </c:when>
                <c:when test="${pageContext.errorData.statusCode == 500}">
                    An internal server error occurred while processing your academic request.
                </c:when>
                <c:otherwise>
                    An unexpected issue occurred. Please return to your academic dashboard.
                </c:otherwise>
            </c:choose>
        </p>

        <div style="display: flex; gap: var(--space-md); justify-content: center;">
            <c:choose>
                <c:when test="${not empty sessionScope.studentId}">
                    <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-primary btn-lg">
                        &larr; Return to Dashboard
                    </a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/" class="btn btn-primary btn-lg">
                        &larr; Go to Home Page
                    </a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

</body>
</html>
