<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Class Timetable &mdash; SlotWise</title>
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
            <a href="${pageContext.request.contextPath}/timetable" class="active">
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

    <!-- Main Content -->
    <main class="app-main">
        <header class="app-header">
            <div>
                <h1>Weekly Class Timetable</h1>
                <p>Manage college lectures and lab sessions to discover open free periods</p>
            </div>
            <div>
                <a href="${pageContext.request.contextPath}/timetable?action=add${not empty dayFilter ? '&day='.concat(dayFilter) : ''}" class="btn btn-primary">
                    + Add Class Session
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
        <c:if test="${not empty success}">
            <div class="alert alert-success">
                <span>&#10004;</span>
                <span>${success}</span>
            </div>
        </c:if>

        <!-- ==================================================== -->
        <!-- MODE: DELETE CONFIRMATION                            -->
        <!-- ==================================================== -->
        <c:if test="${mode == 'delete' && not empty deleteEntry}">
            <div class="confirm-card">
                <h3>&#9888; Confirm Session Deletion</h3>
                <p>
                    Are you sure you want to remove this class from your timetable?
                    <strong style="color: var(--text-primary); display: block; margin-top: 6px;">
                        &ldquo;<c:out value="${deleteEntry.subjectName}"/>&rdquo; on <c:out value="${deleteEntry.dayOfWeek}"/>
                        (<fmt:formatDate value="${deleteEntry.startTime}" pattern="HH:mm" /> &ndash;
                        <fmt:formatDate value="${deleteEntry.endTime}" pattern="HH:mm" />)
                    </strong>
                </p>
                <form action="${pageContext.request.contextPath}/timetable" method="POST" style="display: inline-flex; gap: var(--space-md); justify-content: center;">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="id" value="${deleteEntry.entryId}">
                    <c:if test="${not empty dayFilter}">
                        <input type="hidden" name="day" value="${dayFilter}">
                    </c:if>
                    <button type="submit" class="btn btn-danger">Yes, Remove Class</button>
                    <a href="${pageContext.request.contextPath}/timetable${not empty dayFilter ? '?day='.concat(dayFilter) : ''}" class="btn btn-secondary">Cancel</a>
                </form>
            </div>
        </c:if>

        <!-- ==================================================== -->
        <!-- MODE: ADD NEW ENTRY                                  -->
        <!-- ==================================================== -->
        <c:if test="${mode == 'add' || param.mode == 'add'}">
            <div class="card" style="margin-bottom: var(--space-xl);">
                <div class="card-header">
                    <h2>+ Add New Class Session</h2>
                    <a href="${pageContext.request.contextPath}/timetable" class="btn btn-secondary btn-sm">Cancel</a>
                </div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/timetable" method="POST" autocomplete="off">
                        <input type="hidden" name="action" value="create">

                        <div class="form-row">
                            <div class="form-group">
                                <label for="dayOfWeek">Day of the Week *</label>
                                <select id="dayOfWeek" name="dayOfWeek" class="form-control" required>
                                    <option value="Monday" ${dayFilter == 'Monday' ? 'selected' : ''}>Monday</option>
                                    <option value="Tuesday" ${dayFilter == 'Tuesday' ? 'selected' : ''}>Tuesday</option>
                                    <option value="Wednesday" ${dayFilter == 'Wednesday' ? 'selected' : ''}>Wednesday</option>
                                    <option value="Thursday" ${dayFilter == 'Thursday' ? 'selected' : ''}>Thursday</option>
                                    <option value="Friday" ${dayFilter == 'Friday' ? 'selected' : ''}>Friday</option>
                                    <option value="Saturday" ${dayFilter == 'Saturday' ? 'selected' : ''}>Saturday</option>
                                </select>
                            </div>

                            <div class="form-group">
                                <label for="subjectName">Subject / Course Name *</label>
                                <input type="text" id="subjectName" name="subjectName" class="form-control"
                                       placeholder="e.g. Operating Systems &amp; Concurrency" required autofocus>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="startTime">Start Time *</label>
                                <input type="time" id="startTime" name="startTime" class="form-control" required>
                            </div>

                            <div class="form-group">
                                <label for="endTime">End Time *</label>
                                <input type="time" id="endTime" name="endTime" class="form-control" required>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="roomNumber">Room / Laboratory / Hall</label>
                                <input type="text" id="roomNumber" name="roomNumber" class="form-control"
                                       placeholder="e.g. LH-301 or Lab 4">
                            </div>

                            <div class="form-group">
                                <label for="professorName">Faculty / Professor Name</label>
                                <input type="text" id="professorName" name="professorName" class="form-control"
                                       placeholder="e.g. Dr. Alan Turing">
                            </div>
                        </div>

                        <div class="form-actions">
                            <button type="submit" class="btn btn-primary btn-lg">Add to Timetable</button>
                            <a href="${pageContext.request.contextPath}/timetable${not empty dayFilter ? '?day='.concat(dayFilter) : ''}" class="btn btn-secondary btn-lg">Cancel</a>
                        </div>
                    </form>
                </div>
            </div>
        </c:if>

        <!-- ==================================================== -->
        <!-- MODE: EDIT ENTRY                                     -->
        <!-- ==================================================== -->
        <c:if test="${mode == 'edit' && not empty editEntry}">
            <div class="card" style="margin-bottom: var(--space-xl);">
                <div class="card-header">
                    <h2>&#9998; Edit Class: <c:out value="${editEntry.subjectName}"/></h2>
                    <a href="${pageContext.request.contextPath}/timetable" class="btn btn-secondary btn-sm">Cancel</a>
                </div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/timetable" method="POST" autocomplete="off">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="id" value="${editEntry.entryId}">

                        <div class="form-row">
                            <div class="form-group">
                                <label for="edit_dayOfWeek">Day of the Week *</label>
                                <select id="edit_dayOfWeek" name="dayOfWeek" class="form-control" required>
                                    <option value="Monday" ${editEntry.dayOfWeek == 'Monday' ? 'selected' : ''}>Monday</option>
                                    <option value="Tuesday" ${editEntry.dayOfWeek == 'Tuesday' ? 'selected' : ''}>Tuesday</option>
                                    <option value="Wednesday" ${editEntry.dayOfWeek == 'Wednesday' ? 'selected' : ''}>Wednesday</option>
                                    <option value="Thursday" ${editEntry.dayOfWeek == 'Thursday' ? 'selected' : ''}>Thursday</option>
                                    <option value="Friday" ${editEntry.dayOfWeek == 'Friday' ? 'selected' : ''}>Friday</option>
                                    <option value="Saturday" ${editEntry.dayOfWeek == 'Saturday' ? 'selected' : ''}>Saturday</option>
                                </select>
                            </div>

                            <div class="form-group">
                                <label for="edit_subjectName">Subject / Course Name *</label>
                                <input type="text" id="edit_subjectName" name="subjectName" class="form-control"
                                       value="<c:out value="${editEntry.subjectName}"/>" required>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="edit_startTime">Start Time *</label>
                                <input type="time" id="edit_startTime" name="startTime" class="form-control"
                                       value="<fmt:formatDate value="${editEntry.startTime}" pattern="HH:mm" />" required>
                            </div>

                            <div class="form-group">
                                <label for="edit_endTime">End Time *</label>
                                <input type="time" id="edit_endTime" name="endTime" class="form-control"
                                       value="<fmt:formatDate value="${editEntry.endTime}" pattern="HH:mm" />" required>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="edit_roomNumber">Room / Laboratory / Hall</label>
                                <input type="text" id="edit_roomNumber" name="roomNumber" class="form-control"
                                       value="<c:out value="${editEntry.roomNumber}"/>">
                            </div>

                            <div class="form-group">
                                <label for="edit_professorName">Faculty / Professor Name</label>
                                <input type="text" id="edit_professorName" name="professorName" class="form-control"
                                       value="<c:out value="${editEntry.professorName}"/>">
                            </div>
                        </div>

                        <div class="form-actions">
                            <button type="submit" class="btn btn-primary btn-lg">Update Class</button>
                            <a href="${pageContext.request.contextPath}/timetable${not empty dayFilter ? '?day='.concat(dayFilter) : ''}" class="btn btn-secondary btn-lg">Cancel</a>
                        </div>
                    </form>
                </div>
            </div>
        </c:if>

        <!-- ==================================================== -->
        <!-- DAY FILTER TABS                                      -->
        <!-- ==================================================== -->
        <div class="day-tabs">
            <a href="${pageContext.request.contextPath}/timetable"
               class="day-tab ${empty dayFilter ? 'active' : ''}">All Days</a>
            <a href="${pageContext.request.contextPath}/timetable?day=Monday"
               class="day-tab ${dayFilter == 'Monday' ? 'active' : ''}">Monday</a>
            <a href="${pageContext.request.contextPath}/timetable?day=Tuesday"
               class="day-tab ${dayFilter == 'Tuesday' ? 'active' : ''}">Tuesday</a>
            <a href="${pageContext.request.contextPath}/timetable?day=Wednesday"
               class="day-tab ${dayFilter == 'Wednesday' ? 'active' : ''}">Wednesday</a>
            <a href="${pageContext.request.contextPath}/timetable?day=Thursday"
               class="day-tab ${dayFilter == 'Thursday' ? 'active' : ''}">Thursday</a>
            <a href="${pageContext.request.contextPath}/timetable?day=Friday"
               class="day-tab ${dayFilter == 'Friday' ? 'active' : ''}">Friday</a>
            <a href="${pageContext.request.contextPath}/timetable?day=Saturday"
               class="day-tab ${dayFilter == 'Saturday' ? 'active' : ''}">Saturday</a>
        </div>

        <!-- ==================================================== -->
        <!-- TIMETABLE LIST                                       -->
        <!-- ==================================================== -->
        <div class="card">
            <div class="card-header">
                <h2>
                    <c:choose>
                        <c:when test="${not empty dayFilter}">
                            Schedule for <c:out value="${dayFilter}"/>
                        </c:when>
                        <c:otherwise>
                            Complete Weekly Schedule
                        </c:otherwise>
                    </c:choose>
                </h2>
                <a href="${pageContext.request.contextPath}/planner${not empty dayFilter ? '?day='.concat(dayFilter) : ''}" class="btn btn-secondary btn-sm">
                    View Free Gaps in Planner &rarr;
                </a>
            </div>

            <div class="card-body">
                <c:choose>
                    <c:when test="${not empty entries}">
                        <div class="timetable-grid">
                            <c:forEach var="entry" items="${entries}">
                                <div class="timetable-row">
                                    <div class="timetable-time">
                                        <fmt:formatDate value="${entry.startTime}" pattern="HH:mm" /> &ndash;
                                        <fmt:formatDate value="${entry.endTime}" pattern="HH:mm" />
                                        <c:if test="${empty dayFilter}">
                                            <div style="font-size: 0.72rem; color: var(--purple-secondary); font-weight: 600; text-transform: uppercase;">
                                                <c:out value="${entry.dayOfWeek}"/>
                                            </div>
                                        </c:if>
                                    </div>

                                    <div class="timetable-subject">
                                        <div class="timetable-dot"></div>
                                        <div>
                                            <div class="timetable-info"><c:out value="${entry.subjectName}"/></div>
                                            <div class="timetable-room">
                                                <span>&#127979; <c:out value="${not empty entry.roomNumber ? entry.roomNumber : 'Room TBA'}"/></span>
                                                <c:if test="${not empty entry.professorName}">
                                                    &bull; <span>&#128100; Prof. <c:out value="${entry.professorName}"/></span>
                                                </c:if>
                                            </div>
                                        </div>
                                    </div>

                                    <div>
                                        <span class="badge badge-type">
                                            <c:out value="${entry.dayOfWeek}"/>
                                        </span>
                                    </div>

                                    <div class="timetable-actions">
                                        <a href="${pageContext.request.contextPath}/timetable?action=edit&id=${entry.entryId}${not empty dayFilter ? '&day='.concat(dayFilter) : ''}"
                                           class="btn btn-secondary btn-sm" title="Edit">&#9998; Edit</a>
                                        <a href="${pageContext.request.contextPath}/timetable?action=delete&id=${entry.entryId}${not empty dayFilter ? '&day='.concat(dayFilter) : ''}"
                                           class="btn btn-danger btn-sm" title="Delete">&#128465;</a>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <div class="empty-state-icon">&#128197;</div>
                            <h3>No Classes Found</h3>
                            <p>
                                <c:choose>
                                    <c:when test="${not empty dayFilter}">
                                        There are no classes scheduled for ${dayFilter}. Add your lectures to map your day.
                                    </c:when>
                                    <c:otherwise>
                                        Your timetable is currently empty. Add your weekly class schedule to get started.
                                    </c:otherwise>
                                </c:choose>
                            </p>
                            <a href="${pageContext.request.contextPath}/timetable?action=add${not empty dayFilter ? '&day='.concat(dayFilter) : ''}" class="btn btn-primary btn-sm">
                                + Add First Class
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
