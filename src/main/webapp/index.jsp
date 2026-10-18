<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SlotWise — Smart Academic Free-Time Utilization and Task Planning</title>
    <meta name="description" content="Intelligent timetable management and task prioritization system designed for college students. Turn free periods into productive study sessions.">
    <!-- Google Fonts Inter -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

    <!-- ======================================================== -->
    <!-- Navigation Bar                                            -->
    <!-- ======================================================== -->
    <header class="navbar">
        <div class="navbar-inner">
            <a href="${pageContext.request.contextPath}/" class="navbar-logo">
                <div class="navbar-logo-icon">&#10024;</div>
                <span>SlotWise</span>
            </a>

            <nav class="navbar-links">
                <a href="#features">Features</a>
                <a href="#how-it-works">How It Works</a>
                <a href="#stats">Impact</a>
            </nav>

            <div class="navbar-actions">
                <c:choose>
                    <c:when test="${not empty sessionScope.studentId}">
                        <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-primary">
                            Dashboard &rarr;
                        </a>
                        <a href="${pageContext.request.contextPath}/logout" class="btn btn-secondary">
                            Logout
                        </a>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/login" class="btn btn-secondary">
                            Sign In
                        </a>
                        <a href="${pageContext.request.contextPath}/register" class="btn btn-primary">
                            Get Started Free
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </header>

    <!-- ======================================================== -->
    <!-- Hero Section                                             -->
    <!-- ======================================================== -->
    <section class="hero">
        <div class="hero-inner">
            <div class="hero-content">
                <div class="hero-badge">Smart Academic Scheduling</div>
                <h1 class="hero-title">
                    Turn Free Periods Into
                    <span>Productive Study Hours</span>
                </h1>
                <p class="hero-description">
                    SlotWise automatically analyzes your weekly college timetable, detects free lecture gaps, and schedules the highest-priority academic tasks with zero guesswork.
                </p>

                <div class="hero-buttons">
                    <c:choose>
                        <c:when test="${not empty sessionScope.studentId}">
                            <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-primary btn-lg">
                                Open Dashboard &rarr;
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/register" class="btn btn-primary btn-lg">
                                Start Free Today &rarr;
                            </a>
                            <a href="${pageContext.request.contextPath}/login" class="btn btn-secondary btn-lg">
                                Live Demo Login
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="hero-social">
                    <div class="hero-avatars">
                        <span>SW</span>
                        <span>CS</span>
                        <span>IT</span>
                        <span>AI</span>
                    </div>
                    <div class="hero-social-text">
                        <strong>Designed for University Students</strong>
                        <span>Demonstrating OOP, Relational DBMS &amp; Pure MVC Architecture</span>
                    </div>
                </div>
            </div>

            <!-- Dashboard Preview (CSS-Only Mockup matching Reference Image) -->
            <div class="dashboard-preview">
                <!-- Preview Header -->
                <div class="preview-header">
                    <div class="preview-logo">
                        <span class="preview-logo-dot"></span>
                        SlotWise Academic Console
                    </div>
                    <div class="preview-search">&#128269; Search classes or tasks...</div>
                    <div class="preview-date">Mon, Oct 19 &bull; Semester 5</div>
                    <div class="preview-avatar">AH</div>
                </div>

                <!-- Preview Body -->
                <div class="preview-body">
                    <!-- Left Mini Sidebar -->
                    <div class="preview-sidebar">
                        <div class="preview-sidebar-item active">
                            <span class="preview-sidebar-icon">&#9638;</span> Overview
                        </div>
                        <div class="preview-sidebar-item">
                            <span class="preview-sidebar-icon">&#128197;</span> Schedule
                        </div>
                        <div class="preview-sidebar-item">
                            <span class="preview-sidebar-icon">&#9776;</span> Tasks
                        </div>
                        <div class="preview-sidebar-item">
                            <span class="preview-sidebar-icon">&#9881;</span> Planner
                        </div>
                    </div>

                    <!-- Right Mini Main -->
                    <div class="preview-main">
                        <div class="preview-greeting">
                            Welcome back, Alex!
                            <span>B.Tech Computer Science &bull; 3rd Year</span>
                        </div>

                        <!-- 4 Stat Cards -->
                        <div class="preview-stats">
                            <div class="preview-stat-card">
                                <div class="stat-label">TODAY'S CLASSES</div>
                                <div class="stat-value">3</div>
                                <div class="stat-sub">4.5 hrs total</div>
                            </div>
                            <div class="preview-stat-card">
                                <div class="stat-label">PENDING TASKS</div>
                                <div class="stat-value" style="color: var(--color-warning);">5</div>
                                <div class="stat-sub">2 due this week</div>
                            </div>
                            <div class="preview-stat-card">
                                <div class="stat-label">FREE SLOTS</div>
                                <div class="stat-value" style="color: var(--color-success);">2</div>
                                <div class="stat-sub">135 min open</div>
                            </div>
                            <div class="preview-stat-card progress-card">
                                <div class="progress-circle-preview"></div>
                            </div>
                        </div>

                        <!-- Timetable Preview Table -->
                        <div class="preview-timetable">
                            <div class="preview-timetable-header">
                                <h4>Today's Timeline (Monday)</h4>
                                <span class="preview-timetable-link">Live Slot Analysis</span>
                            </div>

                            <div class="preview-timetable-row">
                                <span class="preview-time">09:00 - 10:30</span>
                                <span class="preview-dot"></span>
                                <span class="preview-subject">Data Structures &amp; Algorithms</span>
                                <span class="preview-room">Room LH-101</span>
                            </div>

                            <div class="preview-timetable-row" style="background: rgba(34, 197, 94, 0.08); border-radius: 4px; padding-left: 6px;">
                                <span class="preview-time" style="color: var(--color-success); font-weight: 700;">10:30 - 11:30</span>
                                <span class="preview-dot free"></span>
                                <span class="preview-subject" style="color: var(--color-success); font-weight: 600;">Free Period Available (60 min)</span>
                                <span class="preview-room" style="color: var(--color-success);">Library / Study Hall</span>
                            </div>

                            <div class="preview-timetable-row">
                                <span class="preview-time">11:30 - 13:00</span>
                                <span class="preview-dot"></span>
                                <span class="preview-subject">Database Management Systems</span>
                                <span class="preview-room">CS Lab 2</span>
                            </div>
                        </div>

                        <!-- Smart Recommendation Mini-Card -->
                        <div class="preview-recommendations">
                            <div class="preview-rec-card">
                                <div class="rec-title">
                                    &#128204; Recommended: Finish DBMS SQL Normalization
                                    <span class="rec-priority high">HIGH PRIORITY</span>
                                </div>
                                <div class="rec-meta">
                                    Fits in: 10:30 - 11:30 (60 min slot) &bull; Assignment due in 2 days
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Floating Accent Pill Badges -->
                <div class="preview-tooltip">
                    <h5>NEXT FREE PERIOD</h5>
                    <p>10:30 AM &ndash; 11:30 AM</p>
                    <div class="tooltip-desc">Optimal time for 45-min DSA Problem Set</div>
                </div>

                <div class="preview-motivation">
                    <h5>Keep Going!</h5>
                    <p>68% of weekly academic goals completed</p>
                </div>

                <div class="preview-steps">
                    <p>Focus Metric<br><strong>+3.5 hrs/wk</strong></p>
                </div>
            </div>
        </div>
    </section>

    <!-- ======================================================== -->
    <!-- Features Section (5 Cards)                                -->
    <!-- ======================================================== -->
    <section class="features" id="features">
        <div class="container-wide">
            <div class="text-center">
                <div class="section-label">Core Capabilities</div>
                <h2 class="section-title">Engineered for Academic Excellence</h2>
                <p class="section-subtitle">
                    Designed to bridge class timetables with homework commitments through intelligent algorithmic scheduling.
                </p>
            </div>

            <div class="features-grid">
                <!-- Feature 1 -->
                <div class="feature-card">
                    <div class="feature-icon">&#128197;</div>
                    <h3>Timetable Management</h3>
                    <p>Comprehensive weekly schedule tracking with automatic collision detection and classroom allocation.</p>
                </div>

                <!-- Feature 2 -->
                <div class="feature-card">
                    <div class="feature-icon">&#128269;</div>
                    <h3>Free Slot Detection</h3>
                    <p>Real-time calculation of unoccupied gaps between 8:00 AM and 6:00 PM for focused revision blocks.</p>
                </div>

                <!-- Feature 3 -->
                <div class="feature-card">
                    <div class="feature-icon">&#127919;</div>
                    <h3>Smart Prioritization</h3>
                    <p>Deterministic OOP polymorphic scoring algorithm weighting urgency, category, and task duration.</p>
                </div>

                <!-- Feature 4 -->
                <div class="feature-card">
                    <div class="feature-icon">&#128221;</div>
                    <h3>Academic Task Tracking</h3>
                    <p>Manage assignments, lab experiments, and exam prep with status transitions and deadline alerts.</p>
                </div>

                <!-- Feature 5 -->
                <div class="feature-card">
                    <div class="feature-icon">&#128200;</div>
                    <h3>Progress Analytics</h3>
                    <p>Dynamic completion percentages, workload distributions, and overdue indicators rendered via pure CSS.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- ======================================================== -->
    <!-- How It Works & Stats Section                              -->
    <!-- ======================================================== -->
    <section class="how-it-works" id="how-it-works">
        <div class="container-wide">
            <div class="how-it-works-inner">
                <!-- Left: 3 Steps -->
                <div class="how-it-works-content">
                    <div class="section-label">Workflow</div>
                    <h2>Three Steps to <span>Academic Mastery</span></h2>
                    <p>Eliminate idle campus hours between classes and stay ahead of every university deadline.</p>

                    <div class="steps">
                        <div class="step">
                            <div class="step-number">1</div>
                            <div class="step-content">
                                <h4>Input Your Weekly Schedule</h4>
                                <p>Add your lectures, lab hours, and faculty sessions once. SlotWise organizes your entire Monday through Friday timeline.</p>
                            </div>
                        </div>

                        <div class="step">
                            <div class="step-number">2</div>
                            <div class="step-content">
                                <h4>Log Your Assignments &amp; Exams</h4>
                                <p>Enter upcoming coursework, expected durations, and deadlines. Tasks inherit specialized scoring rules based on type.</p>
                            </div>
                        </div>

                        <div class="step">
                            <div class="step-number">3</div>
                            <div class="step-content">
                                <h4>Receive Tailored Study Plans</h4>
                                <p>Our scheduling engine pairs open periods with pending work, telling you exactly what to study and when.</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Right: Stats Panel -->
                <div class="stats-section" id="stats">
                    <div class="section-badge">Academic Project Highlights</div>
                    <h3>Technical &amp; Functional Benchmarks</h3>

                    <div class="stats-grid">
                        <div class="stat-item">
                            <div class="stat-icon">&#9200;</div>
                            <div class="stat-number">3.5+</div>
                            <div class="stat-label">Hours Saved / Week</div>
                        </div>

                        <div class="stat-item">
                            <div class="stat-icon">&#10004;</div>
                            <div class="stat-number">94%</div>
                            <div class="stat-label">On-Time Submissions</div>
                        </div>

                        <div class="stat-item">
                            <div class="stat-icon">&#9889;</div>
                            <div class="stat-number">100%</div>
                            <div class="stat-label">Pure Java MVC</div>
                        </div>

                        <div class="stat-item">
                            <div class="stat-icon">&#128274;</div>
                            <div class="stat-number">0%</div>
                            <div class="stat-label">JavaScript Reliance</div>
                        </div>
                    </div>

                    <div class="stats-tagline">
                        &ldquo;Master Your Schedule, Ace Your Semesters.&rdquo;
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- ======================================================== -->
    <!-- Footer                                                   -->
    <!-- ======================================================== -->
    <footer class="footer">
        <div class="footer-inner">
            <div class="footer-text">
                &copy; 2026 SlotWise. Academic Free-Time Utilization &amp; Task Planning System.
                <br>
                <small style="color: var(--text-muted);">Built with Java Servlets, JSP, JSTL, MySQL, and Vanilla CSS.</small>
            </div>
            <div class="footer-links">
                <a href="#features">Features</a>
                <a href="#how-it-works">How It Works</a>
                <a href="${pageContext.request.contextPath}/login">Sign In</a>
                <a href="${pageContext.request.contextPath}/register">Create Account</a>
            </div>
        </div>
    </footer>

</body>
</html>
