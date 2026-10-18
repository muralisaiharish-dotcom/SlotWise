<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard &mdash; SlotWise</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<div class="app-layout">
    <!-- ======================================================== -->
    <!-- Sidebar Navigation                                        -->
    <!-- ======================================================== -->
    <aside class="app-sidebar">
        <a href="${pageContext.request.contextPath}/dashboard" class="sidebar-logo">
            <div class="sidebar-logo-icon">&#10024;</div>
            <span>SlotWise</span>
        </a>

        <nav class="sidebar-nav">
            <a href="${pageContext.request.contextPath}/dashboard" class="active">
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
            <a href="${pageContext.request.contextPath}/progress">
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

    <!-- ======================================================== -->
    <!-- Main Content                                             -->
    <!-- ======================================================== -->
    <main class="app-main">
        <header class="app-header">
            <div>
                <h1>Welcome back, <c:out value="${studentName != null ? studentName : sessionScope.studentName}"/>!</h1>
                <p>Today is <strong style="color: var(--purple-secondary);"><c:out value="${today}"/></strong> &bull; <c:out value="${currentDate}"/></p>
            </div>
            <div>
                <a href="${pageContext.request.contextPath}/tasks?action=add" class="btn btn-primary">
                    + Add New Task
                </a>
            </div>
        </header>

        <!-- Error Notification -->
        <c:if test="${not empty error}">
            <div class="alert alert-error">
                <span>&#9888;</span>
                <span>${error}</span>
            </div>
        </c:if>

        <!-- 4 Metric Cards Row -->
        <div class="dashboard-stats">
            <div class="stat-card">
                <div class="stat-card-header">
                    <span class="label">TODAY'S CLASSES</span>
                    <span class="icon">&#128197;</span>
                </div>
                <div class="value">${todayClassCount != null ? todayClassCount : 0}</div>
                <div class="subtext">Scheduled lectures on ${today}</div>
            </div>

            <div class="stat-card">
                <div class="stat-card-header">
                    <span class="label">PENDING TASKS</span>
                    <span class="icon">&#9200;</span>
                </div>
                <div class="value" style="color: var(--color-warning);">${pendingTaskCount != null ? pendingTaskCount : 0}</div>
                <div class="subtext">Awaiting completion or review</div>
            </div>

            <div class="stat-card">
                <div class="stat-card-header">
                    <span class="label">FREE PERIODS FOUND</span>
                    <span class="icon">&#10024;</span>
                </div>
                <div class="value" style="color: var(--color-success);">${freeSlotCount != null ? freeSlotCount : 0}</div>
                <div class="subtext">Gaps &ge; 15 min between 8AM&ndash;6PM</div>
            </div>

            <div class="stat-card">
                <div class="stat-card-header">
                    <span class="label">ACADEMIC COMPLETION</span>
                    <span class="icon">&#128200;</span>
                </div>
                <div class="value" style="color: var(--purple-secondary);">${completionPercentage != null ? completionPercentage : 0}%</div>
                <div class="progress-bar-container" style="margin-top: 10px;">
                    <div class="progress-bar-fill" style="width: ${completionPercentage != null ? completionPercentage : 0}%;"></div>
                </div>
            </div>
        </div>

        <!-- Two Column Content Grid -->
        <div class="dashboard-grid">
            <!-- Left: Today's Timetable Schedule -->
            <div class="card">
                <div class="card-header">
                    <h3>Today's Lecture Schedule (<c:out value="${today}"/>)</h3>
                    <a href="${pageContext.request.contextPath}/timetable" class="btn btn-secondary btn-sm">
                        View All Days &rarr;
                    </a>
                </div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${not empty todayClasses}">
                            <div class="timetable-grid">
                                <c:forEach var="entry" items="${todayClasses}">
                                    <div class="timetable-row">
                                        <div class="timetable-time">
                                            <fmt:formatDate value="${entry.startTime}" pattern="HH:mm" /> &ndash;
                                            <fmt:formatDate value="${entry.endTime}" pattern="HH:mm" />
                                        </div>
                                        <div class="timetable-subject">
                                            <div class="timetable-dot"></div>
                                            <div>
                                                <div class="timetable-info"><c:out value="${entry.subjectName}"/></div>
                                                <div class="timetable-room">
                                                    <c:out value="${entry.roomNumber != null ? entry.roomNumber : 'TBA'}"/>
                                                    <c:if test="${not empty entry.professorName}">
                                                        &bull; Prof. <c:out value="${entry.professorName}"/>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </div>
                                        <div>
                                            <span class="badge badge-type">Lecture</span>
                                        </div>
                                        <div class="timetable-actions">
                                            <a href="${pageContext.request.contextPath}/timetable?action=edit&id=${entry.entryId}" class="btn btn-secondary btn-sm" title="Edit">&#9998;</a>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-state">
                                <div class="empty-state-icon">&#128197;</div>
                                <h3>No Classes Scheduled for ${today}</h3>
                                <p>You have no lectures registered in the database for today. You can add entries to your timetable or work on pending tasks.</p>
                                <a href="${pageContext.request.contextPath}/timetable?action=add" class="btn btn-primary btn-sm">
                                    + Add Class for ${today}
                                </a>
                            </div>
                        </c:otherwise>
                    </c:choose>

                    <!-- Today's Detected Free Time Slots -->
                    <c:if test="${not empty freeSlots}">
                        <div style="margin-top: var(--space-xl); padding-top: var(--space-lg); border-top: 1px solid var(--border-color);">
                            <h4 style="font-size: 0.95rem; margin-bottom: var(--space-md); color: var(--color-success); display: flex; align-items: center; gap: 8px;">
                                <span>&#10004;</span> Detected Free Slots for Today
                            </h4>
                            <div style="display: flex; flex-direction: column; gap: 8px;">
                                <c:forEach var="slot" items="${freeSlots}">
                                    <div style="display: flex; justify-content: space-between; align-items: center; padding: 10px 14px; background: rgba(34, 197, 94, 0.08); border: 1px solid rgba(34, 197, 94, 0.2); border-radius: var(--radius-sm); font-size: 0.85rem;">
                                        <div style="display: flex; align-items: center; gap: 8px;">
                                            <span style="color: var(--color-success); font-weight: 700;">&#9201;</span>
                                            <span style="font-weight: 600; color: var(--text-primary);"><c:out value="${slot.timeRangeFormatted}"/></span>
                                        </div>
                                        <div>
                                            <span class="badge badge-low"><c:out value="${slot.durationMinutes}"/> min available</span>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </c:if>
                </div>
            </div>

            <!-- Right: Smart Planner Recommendations -->
            <div class="card">
                <div class="card-header">
                    <h3>Smart Study Recommendations</h3>
                    <a href="${pageContext.request.contextPath}/planner" class="btn btn-secondary btn-sm">
                        Full Planner &rarr;
                    </a>
                </div>
                <div class="card-body">
                    <p style="font-size: 0.82rem; color: var(--text-muted); margin-bottom: var(--space-md);">
                        Generated deterministically via Polymorphic Priority Scoring and gap matching.
                    </p>

                    <c:choose>
                        <c:when test="${not empty recommendations}">
                            <div style="display: flex; flex-direction: column; gap: var(--space-md);">
                                <c:forEach var="rec" items="${recommendations}">
                                    <div class="recommendation-card">
                                        <div class="rec-header">
                                            <span class="rec-title"><c:out value="${rec.taskTitle}"/></span>
                                            <c:choose>
                                                <c:when test="${rec.taskPriority == 'HIGH'}">
                                                    <span class="badge badge-high">HIGH</span>
                                                </c:when>
                                                <c:when test="${rec.taskPriority == 'MEDIUM'}">
                                                    <span class="badge badge-medium">MEDIUM</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-low">LOW</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>

                                        <div style="display: flex; gap: var(--space-sm); align-items: center; font-size: 0.8rem; color: var(--text-secondary); margin-bottom: 6px;">
                                            <span class="badge badge-type"><c:out value="${rec.taskType}"/></span>
                                            <span>&bull;</span>
                                            <span class="rec-time">&#9200; <c:out value="${rec.slotStartTime}"/> &ndash; <c:out value="${rec.slotEndTime}"/></span>
                                        </div>

                                        <div class="rec-reason">
                                            &#128161; <c:out value="${rec.reason}"/>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-state">
                                <div class="empty-state-icon">&#127919;</div>
                                <h3>No Recommendations Yet</h3>
                                <p>SlotWise matches pending tasks with free periods. Add tasks and timetable slots to generate recommendations!</p>
                                <a href="${pageContext.request.contextPath}/tasks?action=add" class="btn btn-primary btn-sm">
                                    + Add New Task
                                </a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </main>
</div>

</body>
</html>
