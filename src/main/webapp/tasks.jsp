<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Academic Tasks &mdash; SlotWise</title>
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
            <a href="${pageContext.request.contextPath}/tasks" class="active">
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
                <h1>Academic Tasks &amp; Coursework</h1>
                <p>Manage assignments, lab experiments, and exam prep with polymorphic priority scoring</p>
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
        <c:if test="${not empty success}">
            <div class="alert alert-success">
                <span>&#10004;</span>
                <span>${success}</span>
            </div>
        </c:if>

        <!-- ==================================================== -->
        <!-- MODE: DELETE CONFIRMATION                            -->
        <!-- ==================================================== -->
        <c:if test="${mode == 'delete' && not empty deleteTask}">
            <div class="confirm-card">
                <h3>&#9888; Confirm Task Deletion</h3>
                <p>
                    Are you sure you want to permanently delete:
                    <strong style="color: var(--text-primary); display: block; margin-top: 6px;">
                        &ldquo;<c:out value="${deleteTask.title}"/>&rdquo;
                    </strong>
                </p>
                <form action="${pageContext.request.contextPath}/tasks" method="POST" style="display: inline-flex; gap: var(--space-md); justify-content: center;">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="id" value="${deleteTask.taskId}">
                    <button type="submit" class="btn btn-danger">Yes, Delete Task</button>
                    <a href="${pageContext.request.contextPath}/tasks" class="btn btn-secondary">Cancel</a>
                </form>
            </div>
        </c:if>

        <!-- ==================================================== -->
        <!-- MODE: ADD NEW TASK                                   -->
        <!-- ==================================================== -->
        <c:if test="${mode == 'add' || param.mode == 'add'}">
            <div class="card" style="margin-bottom: var(--space-xl);">
                <div class="card-header">
                    <h2>+ Create New Academic Task</h2>
                    <a href="${pageContext.request.contextPath}/tasks" class="btn btn-secondary btn-sm">Cancel</a>
                </div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/tasks" method="POST" autocomplete="off">
                        <input type="hidden" name="action" value="create">

                        <div class="form-group">
                            <label for="title">Task Title *</label>
                            <input type="text" id="title" name="title" class="form-control"
                                   placeholder="e.g. Implement Binary Search Tree in Java" required autofocus>
                        </div>

                        <div class="form-group">
                            <label for="description">Detailed Description / Instructions</label>
                            <textarea id="description" name="description" class="form-control" rows="3"
                                      placeholder="Chapter readings, submission guidelines, or problem list..."></textarea>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="taskType">Task Type (OOP Subclass) *</label>
                                <select id="taskType" name="taskType" class="form-control" required>
                                    <option value="ASSIGNMENT">Assignment (AssignmentTask &bull; +10 Priority Bonus)</option>
                                    <option value="LAB">Lab Work (LabTask &bull; Duration-scaled Bonus)</option>
                                    <option value="EXAM_PREP">Exam Preparation (ExamPreparationTask &bull; Comprehensive)</option>
                                </select>
                            </div>

                            <div class="form-group">
                                <label for="priority">Urgency Level *</label>
                                <select id="priority" name="priority" class="form-control" required>
                                    <option value="HIGH">High Urgency</option>
                                    <option value="MEDIUM" selected>Medium Urgency</option>
                                    <option value="LOW">Low Urgency</option>
                                </select>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="estimatedDurationMinutes">Estimated Study Duration (Minutes) *</label>
                                <input type="number" id="estimatedDurationMinutes" name="estimatedDurationMinutes"
                                       class="form-control" min="15" max="480" step="15" value="60" required>
                            </div>

                            <div class="form-group">
                                <label for="deadline">Submission / Exam Deadline</label>
                                <input type="date" id="deadline" name="deadline" class="form-control">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="status">Initial Status</label>
                            <select id="status" name="status" class="form-control">
                                <option value="PENDING" selected>Pending</option>
                                <option value="IN_PROGRESS">In Progress</option>
                                <option value="COMPLETED">Completed</option>
                            </select>
                        </div>

                        <div class="form-actions">
                            <button type="submit" class="btn btn-primary btn-lg">Save Task</button>
                            <a href="${pageContext.request.contextPath}/tasks" class="btn btn-secondary btn-lg">Cancel</a>
                        </div>
                    </form>
                </div>
            </div>
        </c:if>

        <!-- ==================================================== -->
        <!-- MODE: EDIT TASK                                      -->
        <!-- ==================================================== -->
        <c:if test="${mode == 'edit' && not empty editTask}">
            <div class="card" style="margin-bottom: var(--space-xl);">
                <div class="card-header">
                    <h2>&#9998; Edit Task: <c:out value="${editTask.title}"/></h2>
                    <a href="${pageContext.request.contextPath}/tasks" class="btn btn-secondary btn-sm">Cancel</a>
                </div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/tasks" method="POST" autocomplete="off">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="id" value="${editTask.taskId}">

                        <div class="form-group">
                            <label for="edit_title">Task Title *</label>
                            <input type="text" id="edit_title" name="title" class="form-control"
                                   value="<c:out value="${editTask.title}"/>" required>
                        </div>

                        <div class="form-group">
                            <label for="edit_description">Detailed Description / Instructions</label>
                            <textarea id="edit_description" name="description" class="form-control" rows="3"><c:out value="${editTask.description}"/></textarea>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="edit_taskType">Task Type (OOP Subclass) *</label>
                                <select id="edit_taskType" name="taskType" class="form-control" required>
                                    <option value="ASSIGNMENT" ${editTask.taskType == 'ASSIGNMENT' ? 'selected' : ''}>Assignment (AssignmentTask)</option>
                                    <option value="LAB" ${editTask.taskType == 'LAB' ? 'selected' : ''}>Lab Work (LabTask)</option>
                                    <option value="EXAM_PREP" ${editTask.taskType == 'EXAM_PREP' ? 'selected' : ''}>Exam Preparation (ExamPreparationTask)</option>
                                </select>
                            </div>

                            <div class="form-group">
                                <label for="edit_priority">Urgency Level *</label>
                                <select id="edit_priority" name="priority" class="form-control" required>
                                    <option value="HIGH" ${editTask.priority == 'HIGH' ? 'selected' : ''}>High Urgency</option>
                                    <option value="MEDIUM" ${editTask.priority == 'MEDIUM' ? 'selected' : ''}>Medium Urgency</option>
                                    <option value="LOW" ${editTask.priority == 'LOW' ? 'selected' : ''}>Low Urgency</option>
                                </select>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="edit_estimatedDurationMinutes">Estimated Duration (Minutes) *</label>
                                <input type="number" id="edit_estimatedDurationMinutes" name="estimatedDurationMinutes"
                                       class="form-control" min="15" max="480" step="15"
                                       value="${editTask.estimatedDurationMinutes}" required>
                            </div>

                            <div class="form-group">
                                <label for="edit_deadline">Submission / Exam Deadline</label>
                                <input type="date" id="edit_deadline" name="deadline" class="form-control"
                                       value="<fmt:formatDate value="${editTask.deadline}" pattern="yyyy-MM-dd" />">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit_status">Current Status</label>
                            <select id="edit_status" name="status" class="form-control">
                                <option value="PENDING" ${editTask.status == 'PENDING' ? 'selected' : ''}>Pending</option>
                                <option value="IN_PROGRESS" ${editTask.status == 'IN_PROGRESS' ? 'selected' : ''}>In Progress</option>
                                <option value="COMPLETED" ${editTask.status == 'COMPLETED' ? 'selected' : ''}>Completed</option>
                            </select>
                        </div>

                        <div class="form-actions">
                            <button type="submit" class="btn btn-primary btn-lg">Update Task</button>
                            <a href="${pageContext.request.contextPath}/tasks" class="btn btn-secondary btn-lg">Cancel</a>
                        </div>
                    </form>
                </div>
            </div>
        </c:if>

        <!-- ==================================================== -->
        <!-- FILTER BAR                                           -->
        <!-- ==================================================== -->
        <div class="filter-bar">
            <label>Filter by Status:</label>
            <a href="${pageContext.request.contextPath}/tasks"
               class="filter-link ${empty statusFilter && empty priorityFilter ? 'active' : ''}">All Tasks</a>
            <a href="${pageContext.request.contextPath}/tasks?status=PENDING"
               class="filter-link ${statusFilter == 'PENDING' ? 'active' : ''}">Pending</a>
            <a href="${pageContext.request.contextPath}/tasks?status=IN_PROGRESS"
               class="filter-link ${statusFilter == 'IN_PROGRESS' ? 'active' : ''}">In Progress</a>
            <a href="${pageContext.request.contextPath}/tasks?status=COMPLETED"
               class="filter-link ${statusFilter == 'COMPLETED' ? 'active' : ''}">Completed</a>

            <div style="width: 1px; height: 24px; background: var(--border-color); margin: 0 8px;"></div>

            <label>Priority:</label>
            <a href="${pageContext.request.contextPath}/tasks?priority=HIGH"
               class="filter-link ${priorityFilter == 'HIGH' ? 'active' : ''}">High</a>
            <a href="${pageContext.request.contextPath}/tasks?priority=MEDIUM"
               class="filter-link ${priorityFilter == 'MEDIUM' ? 'active' : ''}">Medium</a>
            <a href="${pageContext.request.contextPath}/tasks?priority=LOW"
               class="filter-link ${priorityFilter == 'LOW' ? 'active' : ''}">Low</a>
        </div>

        <!-- ==================================================== -->
        <!-- TASK LIST CARDS                                      -->
        <!-- ==================================================== -->
        <div class="task-list">
            <c:choose>
                <c:when test="${not empty tasks}">
                    <c:forEach var="task" items="${tasks}">
                        <div class="task-card">
                            <div class="task-card-content">
                                <h3><c:out value="${task.title}"/></h3>
                                <c:if test="${not empty task.description}">
                                    <p><c:out value="${task.description}"/></p>
                                </c:if>

                                <div class="task-card-meta">
                                    <!-- Type Badge -->
                                    <span class="badge badge-type"><c:out value="${task.taskTypeLabel}"/></span>

                                    <!-- Priority Badge -->
                                    <c:choose>
                                        <c:when test="${task.priority == 'HIGH'}">
                                            <span class="badge badge-high">&#9888; HIGH</span>
                                        </c:when>
                                        <c:when test="${task.priority == 'MEDIUM'}">
                                            <span class="badge badge-medium">MEDIUM</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge badge-low">LOW</span>
                                        </c:otherwise>
                                    </c:choose>

                                    <!-- Status Badge -->
                                    <c:choose>
                                        <c:when test="${task.status == 'COMPLETED'}">
                                            <span class="badge badge-completed">&#10004; COMPLETED</span>
                                        </c:when>
                                        <c:when test="${task.status == 'IN_PROGRESS'}">
                                            <span class="badge badge-in-progress">&#9654; IN PROGRESS</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge badge-pending">&#9200; PENDING</span>
                                        </c:otherwise>
                                    </c:choose>

                                    <!-- Duration -->
                                    <span>&#9201; <c:out value="${task.estimatedDurationMinutes}"/> mins</span>

                                    <!-- Deadline -->
                                    <c:choose>
                                        <c:when test="${not empty task.deadline}">
                                            <span>&#128197; Due <fmt:formatDate value="${task.deadline}" pattern="MMM dd, yyyy" /></span>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: var(--text-muted);">&#128197; No deadline</span>
                                        </c:otherwise>
                                    </c:choose>

                                    <!-- OOP Polymorphic Score -->
                                    <span style="color: var(--purple-secondary); font-family: var(--font-mono); font-size: 0.75rem;">
                                        Score: ${task.calculatePriorityScore()}
                                    </span>
                                </div>
                            </div>

                            <div class="task-card-actions">
                                <!-- Status Toggle Form -->
                                <form action="${pageContext.request.contextPath}/tasks" method="POST" style="display: inline;">
                                    <input type="hidden" name="action" value="toggleStatus">
                                    <input type="hidden" name="id" value="${task.taskId}">
                                    <c:choose>
                                        <c:when test="${task.status == 'COMPLETED'}">
                                            <button type="submit" class="btn btn-secondary btn-sm" title="Mark as Pending">
                                                &#8634; Reopen
                                            </button>
                                        </c:when>
                                        <c:otherwise>
                                            <button type="submit" class="btn btn-success btn-sm" title="Mark as Completed">
                                                &#10004; Complete
                                            </button>
                                        </c:otherwise>
                                    </c:choose>
                                </form>

                                <a href="${pageContext.request.contextPath}/tasks?action=edit&id=${task.taskId}"
                                   class="btn btn-secondary btn-sm" title="Edit">&#9998; Edit</a>
                                <a href="${pageContext.request.contextPath}/tasks?action=delete&id=${task.taskId}"
                                   class="btn btn-danger btn-sm" title="Delete">&#128465;</a>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="card">
                        <div class="empty-state">
                            <div class="empty-state-icon">&#9776;</div>
                            <h3>No Tasks Found</h3>
                            <p>No academic tasks match your current criteria. Create assignments, lab reports, or exam study sessions.</p>
                            <a href="${pageContext.request.contextPath}/tasks?action=add" class="btn btn-primary btn-sm">
                                + Add First Task
                            </a>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </main>
</div>

</body>
</html>
