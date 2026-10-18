<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Smart Free-Time Planner &mdash; SlotWise</title>
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
            <a href="${pageContext.request.contextPath}/planner" class="active">
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

    <!-- Main Content -->
    <main class="app-main">
        <header class="app-header">
            <div>
                <h1>Smart Free-Time Planner</h1>
                <p>Rule-based algorithmic optimization matching free periods with academic priorities</p>
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

        <!-- Academic Algorithm Banner -->
        <div style="background: var(--bg-card); border: 1px solid var(--border-color); border-radius: var(--radius-lg); padding: var(--space-lg); margin-bottom: var(--space-xl); display: flex; align-items: center; justify-content: space-between; gap: var(--space-lg); flex-wrap: wrap;">
            <div style="display: flex; align-items: flex-start; gap: var(--space-md); max-width: 800px;">
                <div style="width: 40px; height: 40px; background: var(--purple-subtle); border-radius: var(--radius-md); display: flex; align-items: center; justify-content: center; font-size: 1.2rem; color: var(--purple-primary); flex-shrink: 0;">
                    &#9881;
                </div>
                <div>
                    <h4 style="font-size: 0.95rem; margin-bottom: 4px;">Smart Scheduling Strategy</h4>
                    <p style="font-size: 0.85rem; color: var(--text-secondary); line-height: 1.5;">
                        Analyzes <strong>8:00 AM &ndash; 6:00 PM</strong> campus operating hours, extracts open periods (&ge; 15 mins), and matches pending tasks ranked by polymorphic Java priority scoring.
                    </p>
                </div>
            </div>
            <div>
                <span class="badge badge-type" style="padding: 6px 14px; font-family: var(--font-mono); font-size: 0.8rem;">
                    TaskSchedulingStrategy
                </span>
            </div>
        </div>

        <!-- Day Selector Tabs -->
        <div class="day-tabs">
            <a href="${pageContext.request.contextPath}/planner?day=Monday"
               class="day-tab ${selectedDay == 'Monday' ? 'active' : ''}">Monday</a>
            <a href="${pageContext.request.contextPath}/planner?day=Tuesday"
               class="day-tab ${selectedDay == 'Tuesday' ? 'active' : ''}">Tuesday</a>
            <a href="${pageContext.request.contextPath}/planner?day=Wednesday"
               class="day-tab ${selectedDay == 'Wednesday' ? 'active' : ''}">Wednesday</a>
            <a href="${pageContext.request.contextPath}/planner?day=Thursday"
               class="day-tab ${selectedDay == 'Thursday' ? 'active' : ''}">Thursday</a>
            <a href="${pageContext.request.contextPath}/planner?day=Friday"
               class="day-tab ${selectedDay == 'Friday' ? 'active' : ''}">Friday</a>
            <a href="${pageContext.request.contextPath}/planner?day=Saturday"
               class="day-tab ${selectedDay == 'Saturday' ? 'active' : ''}">Saturday</a>
        </div>

        <!-- Planner Two-Column Grid -->
        <div class="planner-content">
            <!-- Left: Free Slots -->
            <div class="card">
                <div class="card-header">
                    <h2>Available Free Slots (<c:out value="${selectedDay}"/>)</h2>
                    <span class="badge badge-low">${freeSlots != null ? freeSlots.size() : 0} Periods Open</span>
                </div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${not empty freeSlots}">
                            <div style="display: flex; flex-direction: column; gap: var(--space-md);">
                                <c:forEach var="slot" items="${freeSlots}">
                                    <div class="free-slot-card">
                                        <div class="free-slot-icon">&#9201;</div>
                                        <div class="free-slot-info">
                                            <h4><c:out value="${slot.timeRangeFormatted}"/></h4>
                                            <p>
                                                <strong style="color: var(--color-success);"><c:out value="${slot.durationMinutes}"/> minutes</strong> of uninterrupted free time
                                            </p>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-state">
                                <div class="empty-state-icon">&#9201;</div>
                                <h3>No Free Gaps Detected</h3>
                                <p>Either your timetable is packed from 8:00 AM to 6:00 PM on ${selectedDay}, or no classes are recorded for this day.</p>
                                <a href="${pageContext.request.contextPath}/timetable?day=${selectedDay}" class="btn btn-secondary btn-sm">
                                    Check ${selectedDay} Timetable
                                </a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Right: Recommended Tasks -->
            <div class="card">
                <div class="card-header">
                    <h2>Scheduled Academic Recommendations</h2>
                    <span class="badge badge-type">${recommendations != null ? recommendations.size() : 0} Tasks Assigned</span>
                </div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${not empty recommendations}">
                            <div style="display: flex; flex-direction: column; gap: var(--space-md);">
                                <c:forEach var="rec" items="${recommendations}">
                                    <div class="recommendation-card">
                                        <div class="rec-header">
                                            <span class="rec-title"><c:out value="${rec.taskTitle}"/></span>
                                            <c:choose>
                                                <c:when test="${rec.taskPriority == 'HIGH'}">
                                                    <span class="badge badge-high">&#9888; HIGH</span>
                                                </c:when>
                                                <c:when test="${rec.taskPriority == 'MEDIUM'}">
                                                    <span class="badge badge-medium">MEDIUM</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-low">LOW</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>

                                        <div style="display: flex; align-items: center; gap: var(--space-sm); font-size: 0.82rem; color: var(--text-secondary); margin-bottom: var(--space-sm);">
                                            <span class="badge badge-type"><c:out value="${rec.taskType}"/></span>
                                            <span>&bull;</span>
                                            <span class="rec-time">&#9200; <c:out value="${rec.slotStartTime}"/> &ndash; <c:out value="${rec.slotEndTime}"/></span>
                                        </div>

                                        <div class="rec-reason">
                                            <strong>Why this slot:</strong> <c:out value="${rec.reason}"/>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-state">
                                <div class="empty-state-icon">&#127919;</div>
                                <h3>No Tasks Scheduled</h3>
                                <p>To generate recommendations, ensure you have pending tasks in your task list that can fit into the free gaps of ${selectedDay}.</p>
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
