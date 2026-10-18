<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Academic Progress &mdash; SlotWise</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<div class="app-layout">
    <!-- Sidebar Navigation -->
    <aside class="app-sidebar">
        <a href="${pageContext.request.contextPath}/dashboard" class="sidebar-logo">
            <div class="sidebar-logo-icon">&#10024;</div>
            <span>SlotWise</span>
        </a>

        <nav class="sidebar-nav">
            <a href="${pageContext.request.contextPath}/dashboard">
                <span class="sidebar-nav-icon">&#9638;</span>
                <span>Dashboard</span>
            </a>
            <a href="${pageContext.request.contextPath}/timetable">
                <span class="sidebar-nav-icon">&#128197;</span>
                <span>Timetable</span>
            </a>
            <a href="${pageContext.request.contextPath}/tasks">
                <span class="sidebar-nav-icon">&#9776;</span>
                <span>Tasks</span>
            </a>
            <a href="${pageContext.request.contextPath}/planner">
                <span class="sidebar-nav-icon">&#127919;</span>
                <span>Smart Planner</span>
            </a>
            <a href="${pageContext.request.contextPath}/progress" class="active">
                <span class="sidebar-nav-icon">&#128200;</span>
                <span>Progress</span>
            </a>
            <a href="${pageContext.request.contextPath}/settings">
                <span class="sidebar-nav-icon">&#9881;</span>
                <span>Settings</span>
            </a>

            <div class="sidebar-divider"></div>

            <a href="${pageContext.request.contextPath}/logout" style="color: var(--color-danger);">
                <span class="sidebar-nav-icon">&#128682;</span>
                <span>Sign Out</span>
            </a>
        </nav>
    </aside>

    <!-- Main Content -->
    <main class="app-main">
        <header class="app-header">
            <div>
                <h1>Academic Progress &amp; Analytics</h1>
                <p>Track your submission completion rate, task velocity, and overdue coursework</p>
            </div>
            <div>
                <a href="${pageContext.request.contextPath}/tasks?action=add" class="btn btn-primary">
                    + Add New Task
                </a>
            </div>
        </header>

        <!-- Alerts -->
        <c:if test="${not empty error}">
            <div class="alert alert-error">
                <span>&#9888;</span>
                <span>${error}</span>
            </div>
        </c:if>

        <!-- 5 Statistical Metric Cards -->
        <div class="progress-stats">
            <div class="progress-stat-card">
                <div class="stat-value"><c:out value="${totalTasks != null ? totalTasks : 0}"/></div>
                <div class="stat-label">Total Tasks</div>
            </div>

            <div class="progress-stat-card">
                <div class="stat-value" style="color: var(--color-info);"><c:out value="${pendingTasks != null ? pendingTasks : 0}"/></div>
                <div class="stat-label">Pending</div>
            </div>

            <div class="progress-stat-card">
                <div class="stat-value" style="color: var(--color-warning);"><c:out value="${inProgressTasks != null ? inProgressTasks : 0}"/></div>
                <div class="stat-label">In Progress</div>
            </div>

            <div class="progress-stat-card">
                <div class="stat-value" style="color: var(--color-success);"><c:out value="${completedTasks != null ? completedTasks : 0}"/></div>
                <div class="stat-label">Completed</div>
            </div>

            <div class="progress-stat-card">
                <div class="stat-value" style="color: var(--color-danger);"><c:out value="${overdueTasks != null ? overdueTasks : 0}"/></div>
                <div class="stat-label">Overdue</div>
            </div>
        </div>

        <!-- Overall Progress Completion Bar Card -->
        <div class="card" style="margin-bottom: var(--space-xl);">
            <div class="card-header">
                <h2>Overall Coursework Completion Rate</h2>
                <span class="badge badge-type" style="font-size: 0.95rem; font-weight: 700;">
                    ${completionPercentageInt != null ? completionPercentageInt : 0}% Complete
                </span>
            </div>
            <div class="card-body">
                <div class="progress-large" style="margin-bottom: var(--space-md);">
                    <div class="progress-bar-container">
                        <div class="progress-bar-fill" style="width: ${completionPercentageInt != null ? completionPercentageInt : 0}%;"></div>
                    </div>
                </div>

                <div style="display: flex; justify-content: space-between; align-items: center; color: var(--text-secondary); font-size: 0.88rem;">
                    <span>
                        <strong style="color: var(--color-success);">${completedTasks != null ? completedTasks : 0}</strong> completed out of 
                        <strong style="color: var(--text-primary);">${totalTasks != null ? totalTasks : 0}</strong> academic tasks
                    </span>
                    <span>
                        <c:choose>
                            <c:when test="${completionPercentageInt >= 75}">
                                &#127942; Excellent academic momentum! Keep it up.
                            </c:when>
                            <c:when test="${completionPercentageInt >= 50}">
                                &#9989; Good progress! Use your free periods to finish remaining tasks.
                            </c:when>
                            <c:otherwise>
                                &#9200; Plan upcoming study sessions to boost your rate.
                            </c:otherwise>
                        </c:choose>
                    </span>
                </div>
            </div>
        </div>

        <!-- Coursework Breakdown Table -->
        <div class="card">
            <div class="card-header">
                <h2>All Coursework &amp; Academic Tasks Breakdown</h2>
                <a href="${pageContext.request.contextPath}/tasks" class="btn btn-secondary btn-sm">
                    Manage Tasks &rarr;
                </a>
            </div>
            <div class="card-body" style="padding: 0;">
                <c:choose>
                    <c:when test="${not empty allTasks}">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Task Title</th>
                                    <th>Type</th>
                                    <th>Priority</th>
                                    <th>Score</th>
                                    <th>Duration</th>
                                    <th>Deadline</th>
                                    <th>Status</th>
                                    <th style="text-align: right;">Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="task" items="${allTasks}">
                                    <tr>
                                        <td>
                                            <strong style="color: var(--text-primary);"><c:out value="${task.title}"/></strong>
                                        </td>
                                        <td>
                                            <span class="badge badge-type"><c:out value="${task.taskTypeLabel}"/></span>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${task.priority == 'HIGH'}">
                                                    <span class="badge badge-high">HIGH</span>
                                                </c:when>
                                                <c:when test="${task.priority == 'MEDIUM'}">
                                                    <span class="badge badge-medium">MED</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-low">LOW</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <code style="color: var(--purple-secondary); font-family: var(--font-mono); font-weight: 600;">
                                                ${task.calculatePriorityScore()}
                                            </code>
                                        </td>
                                        <td>
                                            <c:out value="${task.estimatedDurationMinutes}"/> min
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty task.deadline}">
                                                    <fmt:formatDate value="${task.deadline}" pattern="MMM dd, yyyy" />
                                                </c:when>
                                                <c:otherwise>
                                                    <span style="color: var(--text-muted);">&mdash;</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${task.status == 'COMPLETED'}">
                                                    <span class="badge badge-completed">COMPLETED</span>
                                                </c:when>
                                                <c:when test="${task.status == 'IN_PROGRESS'}">
                                                    <span class="badge badge-in-progress">IN PROGRESS</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-pending">PENDING</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td style="text-align: right;">
                                            <a href="${pageContext.request.contextPath}/tasks?action=edit&id=${task.taskId}"
                                               class="btn btn-secondary btn-sm" title="Edit">&#9998;</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <div class="empty-state-icon">&#128200;</div>
                            <h3>No Tasks Logged</h3>
                            <p>Once you add assignments and study goals, detailed progress analytics will populate here.</p>
                            <a href="${pageContext.request.contextPath}/tasks?action=add" class="btn btn-primary btn-sm">
                                + Add Task
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </main>
</div>

</body>
</html>
