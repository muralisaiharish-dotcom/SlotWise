<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Settings &mdash; SlotWise</title>
    <!-- Google Fonts: Plus Jakarta Sans, Inter & Caveat (for doodle) -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Caveat:wght@600;700&family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="${sessionScope.themePreference == 'light' || student.themePreference == 'light' ? 'theme-light' : ''}">

<div class="app-layout">
    <!-- ======================================================== -->
    <!-- 1. SIDEBAR                                               -->
    <!-- ======================================================== -->
    <aside class="app-sidebar">
        <a href="${pageContext.request.contextPath}/dashboard" class="sidebar-logo">
            <div class="sidebar-logo-icon">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                    <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                    <line x1="16" y1="2" x2="16" y2="6"></line>
                    <line x1="8" y1="2" x2="8" y2="6"></line>
                    <line x1="3" y1="10" x2="21" y2="10"></line>
                </svg>
            </div>
            <span class="sidebar-brand-name">Slot<span class="gradient-text">Wise</span></span>
        </a>

        <nav class="sidebar-nav">
            <a href="${pageContext.request.contextPath}/dashboard">
                <span class="sidebar-nav-icon">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path>
                        <polyline points="9 22 9 12 15 12 15 22"></polyline>
                    </svg>
                </span>
                <span>Dashboard</span>
            </a>

            <a href="${pageContext.request.contextPath}/timetable">
                <span class="sidebar-nav-icon">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                        <line x1="16" y1="2" x2="16" y2="6"></line>
                        <line x1="8" y1="2" x2="8" y2="6"></line>
                        <line x1="3" y1="10" x2="21" y2="10"></line>
                    </svg>
                </span>
                <span>Timetable</span>
            </a>

            <a href="${pageContext.request.contextPath}/tasks">
                <span class="sidebar-nav-icon">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <polyline points="9 11 12 14 22 4"></polyline>
                        <path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"></path>
                    </svg>
                </span>
                <span>My Tasks</span>
            </a>

            <a href="${pageContext.request.contextPath}/planner">
                <span class="sidebar-nav-icon">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M9.5 2A2.5 2.5 0 0 1 12 4.5v15a2.5 2.5 0 0 1-4.96.44 2.5 2.5 0 0 1-2.96-3.08 3 3 0 0 1-.34-5.58 2.5 2.5 0 0 1 1.32-4.24 2.5 2.5 0 0 1 4.44-2.04z"></path>
                        <path d="M14.5 2A2.5 2.5 0 0 0 12 4.5v15a2.5 2.5 0 0 0 4.96.44 2.5 2.5 0 0 0 2.96-3.08 3 3 0 0 0 .34-5.58 2.5 2.5 0 0 0-1.32-4.24 2.5 2.5 0 0 0-4.44-2.04z"></path>
                    </svg>
                </span>
                <span>Smart Planner</span>
            </a>

            <a href="${pageContext.request.contextPath}/progress">
                <span class="sidebar-nav-icon">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <line x1="18" y1="20" x2="18" y2="10"></line>
                        <line x1="12" y1="20" x2="12" y2="4"></line>
                        <line x1="6" y1="20" x2="6" y2="14"></line>
                    </svg>
                </span>
                <span>Progress</span>
            </a>

            <a href="${pageContext.request.contextPath}/settings" class="active sidebar-settings-pill">
                <span class="sidebar-nav-icon">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="12" cy="12" r="3"></circle>
                        <path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z"></path>
                    </svg>
                </span>
                <span>Settings</span>
            </a>

            <div class="sidebar-divider"></div>

            <a href="${pageContext.request.contextPath}/logout" class="sidebar-logout-btn">
                <span class="sidebar-nav-icon">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path>
                        <polyline points="16 17 21 12 16 7"></polyline>
                        <line x1="21" y1="12" x2="9" y2="12"></line>
                    </svg>
                </span>
                <span>Logout</span>
            </a>
        </nav>
    </aside>

    <!-- ======================================================== -->
    <!-- MAIN CONTENT                                             -->
    <!-- ======================================================== -->
    <main class="app-main">
        <!-- ==================================================== -->
        <!-- 2. TOP BAR                                           -->
        <!-- ==================================================== -->
        <div class="app-topbar">
            <!-- Search field matching reference image -->
            <div class="topbar-search">
                <span class="topbar-search-icon">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="11" cy="11" r="8"></circle>
                        <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                    </svg>
                </span>
                <input type="text" class="topbar-search-input" placeholder="Search anything..." readonly title="Quick academic search">
            </div>

            <!-- Topbar Actions (Notification + Profile Summary) -->
            <div class="topbar-actions">
                <a href="#notifications" class="topbar-notification-btn" title="Notifications">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"></path>
                        <path d="M13.73 21a2 2 0 0 1-3.46 0"></path>
                    </svg>
                    <span class="topbar-notification-dot"></span>
                </a>

                <a href="${pageContext.request.contextPath}/settings" class="topbar-profile-chip">
                    <div class="topbar-avatar-img">
                        <img src="${pageContext.request.contextPath}/images/harish_profile.jpg"
                             alt="Harish"
                             class="topbar-avatar-photo"
                             onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                        <div class="topbar-avatar-fallback" style="display:none;">H</div>
                    </div>
                    <div class="topbar-profile-info">
                        <span class="topbar-profile-name">
                            <c:out value="${not empty student.fullName ? student.fullName.split(' ')[0] : 'Harish'}"/>
                        </span>
                        <span class="topbar-profile-dept">
                            <c:out value="${not empty student.yearOfStudy ? student.yearOfStudy : 'CSE - 2nd Year'}"/>
                        </span>
                    </div>
                    <span class="topbar-profile-arrow">
                        <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                            <polyline points="6 9 12 15 18 9"></polyline>
                        </svg>
                    </span>
                </a>
            </div>
        </div>

        <!-- ==================================================== -->
        <!-- 3. SETTINGS HEADER BANNER WITH PLAYFUL DOODLE        -->
        <!-- ==================================================== -->
        <div class="settings-header-banner">
            <div>
                <h1 class="settings-header-title">Settings</h1>
                <p class="settings-header-desc">Manage your account, preferences, and application settings.</p>
            </div>
            
            <!-- Exact playful handwritten doodle from reference image -->
            <div class="settings-doodle-container">
                <div class="settings-doodle-text">
                    <div class="doodle-top-line">
                        <span>Customize</span>
                        <!-- 3 radiant sparks from reference image -->
                        <svg class="doodle-sparks" width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#a477ff" stroke-width="2.2" stroke-linecap="round">
                            <line x1="5" y1="5" x2="2" y2="2"></line>
                            <line x1="12" y1="4" x2="12" y2="1"></line>
                            <line x1="19" y1="5" x2="22" y2="2"></line>
                        </svg>
                    </div>
                    <span>your experience</span>
                    <!-- Curved doodle arrow pointing down to the cards -->
                    <svg class="doodle-arrow" width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="#a477ff" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M4 4 C14 4, 18 10, 18 19"></path>
                        <polyline points="13 15 18 20 22 15"></polyline>
                    </svg>
                </div>
            </div>
        </div>

        <!-- Success & Error Alerts -->
        <c:if test="${not empty success}">
            <div class="alert alert-success" style="margin-bottom: var(--space-lg);">
                <span>&#10004;</span>
                <span><c:out value="${success}"/></span>
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-error" style="margin-bottom: var(--space-lg);">
                <span>&#9888;</span>
                <span><c:out value="${error}"/></span>
            </div>
        </c:if>

        <!-- ==================================================== -->
        <!-- 4. SETTINGS LAYOUT (Left Nav + Right Main Cards)     -->
        <!-- ==================================================== -->
        <div class="settings-layout-grid">
            <!-- ================================================ -->
            <!-- 4.1 LEFT NAVIGATION MENU (Matching Reference)    -->
            <!-- ================================================ -->
            <div class="settings-nav-card">
                <!-- 1. Profile (Active Glowing Pill) -->
                <a href="#profile"
                   class="settings-nav-btn ${activeSection == 'profile' || empty activeSection ? 'active' : ''}">
                    <span class="settings-nav-icon">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                            <circle cx="12" cy="7" r="4"></circle>
                        </svg>
                    </span>
                    <div class="settings-nav-text">
                        <span class="settings-nav-title">Profile</span>
                        <span class="settings-nav-sub">Personal information</span>
                    </div>
                </a>

                <!-- 2. Account -->
                <a href="#account"
                   class="settings-nav-btn ${activeSection == 'account' ? 'active' : ''}">
                    <span class="settings-nav-icon">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
                            <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                        </svg>
                    </span>
                    <div class="settings-nav-text">
                        <span class="settings-nav-title">Account</span>
                        <span class="settings-nav-sub">Security &amp; login</span>
                    </div>
                </a>

                <!-- 3. Preferences -->
                <a href="#notifications"
                   class="settings-nav-btn ${activeSection == 'preferences' ? 'active' : ''}">
                    <span class="settings-nav-icon">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <line x1="4" y1="21" x2="4" y2="14"></line>
                            <line x1="4" y1="10" x2="4" y2="3"></line>
                            <line x1="12" y1="21" x2="12" y2="12"></line>
                            <line x1="12" y1="8" x2="12" y2="3"></line>
                            <line x1="20" y1="21" x2="20" y2="16"></line>
                            <line x1="20" y1="12" x2="20" y2="3"></line>
                            <line x1="1" y1="14" x2="7" y2="14"></line>
                            <line x1="9" y1="8" x2="15" y2="8"></line>
                            <line x1="17" y1="16" x2="23" y2="16"></line>
                        </svg>
                    </span>
                    <div class="settings-nav-text">
                        <span class="settings-nav-title">Preferences</span>
                        <span class="settings-nav-sub">App settings</span>
                    </div>
                </a>

                <!-- 4. Notifications -->
                <a href="#notifications"
                   class="settings-nav-btn ${activeSection == 'notifications' ? 'active' : ''}">
                    <span class="settings-nav-icon">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"></path>
                            <path d="M13.73 21a2 2 0 0 1-3.46 0"></path>
                        </svg>
                    </span>
                    <div class="settings-nav-text">
                        <span class="settings-nav-title">Notifications</span>
                        <span class="settings-nav-sub">Alerts &amp; reminders</span>
                    </div>
                </a>

                <!-- 5. Appearance -->
                <a href="#appearance"
                   class="settings-nav-btn ${activeSection == 'appearance' ? 'active' : ''}">
                    <span class="settings-nav-icon">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"></path>
                        </svg>
                    </span>
                    <div class="settings-nav-text">
                        <span class="settings-nav-title">Appearance</span>
                        <span class="settings-nav-sub">Theme &amp; display</span>
                    </div>
                </a>

                <!-- 6. Data & Privacy -->
                <a href="#privacy"
                   class="settings-nav-btn ${activeSection == 'privacy' ? 'active' : ''}">
                    <span class="settings-nav-icon">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
                        </svg>
                    </span>
                    <div class="settings-nav-text">
                        <span class="settings-nav-title">Data &amp; Privacy</span>
                        <span class="settings-nav-sub">Manage your data</span>
                    </div>
                </a>
            </div>

            <!-- ================================================ -->
            <!-- RIGHT MAIN COLUMN (Cards)                        -->
            <!-- ================================================ -->
            <div class="settings-main-column">

                <!-- ============================================ -->
                <!-- 5. PROFILE INFORMATION CARD                  -->
                <!-- ============================================ -->
                <div class="settings-card-glass" id="profile">
                    <div class="settings-card-head">
                        <div class="settings-card-head-left">
                            <div class="settings-icon-badge">
                                <!-- Server/Cards icon matching reference image -->
                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <ellipse cx="12" cy="5" rx="9" ry="3"></ellipse>
                                    <path d="M21 12c0 1.66-4 3-9 3s-9-1.34-9-3"></path>
                                    <path d="M3 5v14c0 1.66 4 3 9 3s9-1.34 9-3V5"></path>
                                </svg>
                            </div>
                            <div>
                                <h3>Profile Information</h3>
                                <p>Update your personal details here.</p>
                            </div>
                        </div>

                        <c:choose>
                            <c:when test="${mode == 'editProfile'}">
                                <a href="${pageContext.request.contextPath}/settings#profile" class="btn-edit-profile-pill">
                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                                        <line x1="18" y1="6" x2="6" y2="18"></line>
                                        <line x1="6" y1="6" x2="18" y2="18"></line>
                                    </svg>
                                    Cancel
                                </a>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/settings?mode=editProfile#profile" class="btn-edit-profile-pill">
                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                        <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path>
                                        <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path>
                                    </svg>
                                    Edit Profile
                                </a>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <c:choose>
                        <%-- EDIT MODE FORM --%>
                        <c:when test="${mode == 'editProfile'}">
                            <form action="${pageContext.request.contextPath}/settings" method="POST" autocomplete="off">
                                <input type="hidden" name="action" value="updateProfile">
                                <input type="hidden" name="section" value="profile">

                                <div class="form-row">
                                    <div class="form-group">
                                        <label for="fullName">Full Name *</label>
                                        <input type="text" id="fullName" name="fullName" class="form-control"
                                               value="<c:out value="${student.fullName}"/>" required autofocus>
                                    </div>

                                    <div class="form-group">
                                        <label for="email">Email Address *</label>
                                        <input type="email" id="email" name="email" class="form-control"
                                               value="<c:out value="${student.email}"/>" required>
                                    </div>
                                </div>

                                <div class="form-row">
                                    <div class="form-group">
                                        <label for="rollNumber">Roll Number *</label>
                                        <input type="text" id="rollNumber" name="rollNumber" class="form-control"
                                               value="<c:out value="${student.rollNumber}"/>" placeholder="e.g. 250701626" required>
                                    </div>

                                    <div class="form-group">
                                        <label for="department">Department *</label>
                                        <input type="text" id="department" name="department" class="form-control"
                                               value="<c:out value="${student.department}"/>" placeholder="e.g. Computer Science and Engineering" required>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label for="yearOfStudy">Year / Section</label>
                                    <input type="text" id="yearOfStudy" name="yearOfStudy" class="form-control"
                                           value="<c:out value="${student.yearOfStudy}"/>" placeholder="e.g. CSE - 2nd Year">
                                </div>

                                <div class="form-actions" style="margin-top: var(--space-md);">
                                    <button type="submit" class="btn btn-primary">Save Profile Changes</button>
                                    <a href="${pageContext.request.contextPath}/settings#profile" class="btn btn-secondary">Cancel</a>
                                </div>
                            </form>
                        </c:when>

                        <%-- VIEW MODE (Matches Reference Image Exactly) --%>
                        <c:otherwise>
                            <div class="profile-view-layout">
                                <!-- Student Avatar with camera badge matching reference image -->
                                <div class="profile-avatar-container">
                                    <div class="profile-avatar-photo">
                                        <img src="${pageContext.request.contextPath}/images/harish_profile.jpg"
                                             alt="Harish M"
                                             class="profile-avatar-img"
                                             onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                                        <div class="profile-avatar-fallback" style="display:none;">H</div>
                                    </div>
                                    <div class="profile-avatar-badge" title="Change Avatar Photo">
                                        <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.3" stroke-linecap="round" stroke-linejoin="round">
                                            <path d="M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z"></path>
                                            <circle cx="12" cy="13" r="4"></circle>
                                        </svg>
                                    </div>
                                </div>

                                <!-- 4 Attribute Cards Grid Matching Reference -->
                                <div class="profile-attributes-grid">
                                    <!-- 1. Full Name -->
                                    <div class="profile-attr-card">
                                        <div class="profile-attr-icon">
                                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                                <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                                                <circle cx="12" cy="7" r="4"></circle>
                                            </svg>
                                        </div>
                                        <div class="profile-attr-content">
                                            <span class="profile-attr-label">Full Name</span>
                                            <span class="profile-attr-value">
                                                <c:out value="${not empty student.fullName ? student.fullName : 'Harish M'}"/>
                                            </span>
                                        </div>
                                    </div>

                                    <!-- 2. Email -->
                                    <div class="profile-attr-card">
                                        <div class="profile-attr-icon">
                                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                                <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"></path>
                                                <polyline points="22,6 12,13 2,6"></polyline>
                                            </svg>
                                        </div>
                                        <div class="profile-attr-content">
                                            <span class="profile-attr-label">Email</span>
                                            <span class="profile-attr-value">
                                                <c:out value="${not empty student.email ? student.email : 'harishm@example.com'}"/>
                                            </span>
                                        </div>
                                    </div>

                                    <!-- 3. Roll Number -->
                                    <div class="profile-attr-card">
                                        <div class="profile-attr-icon">
                                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                                <rect x="2" y="4" width="20" height="16" rx="2"></rect>
                                                <circle cx="8" cy="10" r="2"></circle>
                                                <line x1="14" y1="9" x2="18" y2="9"></line>
                                                <line x1="14" y1="13" x2="18" y2="13"></line>
                                                <line x1="6" y1="16" x2="18" y2="16"></line>
                                            </svg>
                                        </div>
                                        <div class="profile-attr-content">
                                            <span class="profile-attr-label">Roll Number</span>
                                            <span class="profile-attr-value">
                                                <c:out value="${not empty student.rollNumber ? student.rollNumber : '250701626'}"/>
                                            </span>
                                        </div>
                                    </div>

                                    <!-- 4. Department -->
                                    <div class="profile-attr-card">
                                        <div class="profile-attr-icon">
                                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                                <path d="M3 21h18"></path>
                                                <path d="M5 21V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2v16"></path>
                                                <line x1="9" y1="9" x2="9" y2="9.01"></line>
                                                <line x1="15" y1="9" x2="15" y2="9.01"></line>
                                                <line x1="9" y1="13" x2="9" y2="13.01"></line>
                                                <line x1="15" y1="13" x2="15" y2="13.01"></line>
                                            </svg>
                                        </div>
                                        <div class="profile-attr-content">
                                            <span class="profile-attr-label">Department</span>
                                            <span class="profile-attr-value">
                                                <c:out value="${not empty student.department ? student.department : 'Computer Science and Engineering'}"/>
                                            </span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- ============================================ -->
                <!-- 6. CHANGE PASSWORD CARD                      -->
                <!-- ============================================ -->
                <div class="settings-card-glass" id="account">
                    <div class="settings-card-head">
                        <div class="settings-card-head-left">
                            <div class="settings-icon-badge">
                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
                                    <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                                </svg>
                            </div>
                            <div>
                                <h3>Change Password</h3>
                                <p>Keep your account secure by using a strong password.</p>
                            </div>
                        </div>
                    </div>

                    <div class="password-card-grid">
                        <!-- Password Form Matching Reference Inputs -->
                        <form action="${pageContext.request.contextPath}/settings" method="POST" autocomplete="off">
                            <input type="hidden" name="action" value="changePassword">
                            <input type="hidden" name="section" value="account">

                            <div class="form-group">
                                <div class="input-with-icon-wrapper">
                                    <span class="input-lead-icon">
                                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                            <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
                                            <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                                        </svg>
                                    </span>
                                    <input type="password" name="currentPassword" class="input-with-icon"
                                           placeholder="Enter your current password" required>
                                    <span class="input-trail-icon" title="Visibility toggle">
                                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                            <path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"></path>
                                            <line x1="1" y1="1" x2="23" y2="23"></line>
                                        </svg>
                                    </span>
                                </div>
                            </div>

                            <div class="form-group">
                                <div class="input-with-icon-wrapper">
                                    <span class="input-lead-icon">
                                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                            <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
                                            <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                                        </svg>
                                    </span>
                                    <input type="password" name="newPassword" class="input-with-icon"
                                           placeholder="Enter new password" required minlength="8">
                                    <span class="input-trail-icon" title="Visibility toggle">
                                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                            <path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"></path>
                                            <line x1="1" y1="1" x2="23" y2="23"></line>
                                        </svg>
                                    </span>
                                </div>
                            </div>

                            <div class="form-group">
                                <div class="input-with-icon-wrapper">
                                    <span class="input-lead-icon">
                                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                            <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
                                            <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                                        </svg>
                                    </span>
                                    <input type="password" name="confirmPassword" class="input-with-icon"
                                           placeholder="Confirm new password" required minlength="8">
                                    <span class="input-trail-icon" title="Visibility toggle">
                                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                            <path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"></path>
                                            <line x1="1" y1="1" x2="23" y2="23"></line>
                                        </svg>
                                    </span>
                                </div>
                            </div>

                            <div style="margin-top: var(--space-lg);">
                                <button type="submit" class="btn-update-password-pill">
                                    Update Password
                                </button>
                            </div>
                        </form>

                        <!-- Password Requirements Box Matching Reference -->
                        <div class="password-requirements-card">
                            <div class="password-req-head">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#a477ff" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
                                </svg>
                                <span>Password Requirements</span>
                            </div>
                            <div class="password-req-list">
                                <div class="password-req-item">
                                    <span class="password-req-check">
                                        <svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round">
                                            <polyline points="20 6 9 17 4 12"></polyline>
                                        </svg>
                                    </span>
                                    <span>At least 8 characters</span>
                                </div>
                                <div class="password-req-item">
                                    <span class="password-req-check">
                                        <svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round">
                                            <polyline points="20 6 9 17 4 12"></polyline>
                                        </svg>
                                    </span>
                                    <span>Include uppercase letter (A-Z)</span>
                                </div>
                                <div class="password-req-item">
                                    <span class="password-req-check">
                                        <svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round">
                                            <polyline points="20 6 9 17 4 12"></polyline>
                                        </svg>
                                    </span>
                                    <span>Include lowercase letter (a-z)</span>
                                </div>
                                <div class="password-req-item">
                                    <span class="password-req-check">
                                        <svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round">
                                            <polyline points="20 6 9 17 4 12"></polyline>
                                        </svg>
                                    </span>
                                    <span>Include a number (0-9)</span>
                                </div>
                                <div class="password-req-item">
                                    <span class="password-req-check">
                                        <svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round">
                                            <polyline points="20 6 9 17 4 12"></polyline>
                                        </svg>
                                    </span>
                                    <span>Include a special character (!@#)</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- ============================================ -->
                <!-- BOTTOM ROW: Notifications & Appearance       -->
                <!-- ============================================ -->
                <div class="settings-bottom-two-col">
                    <!-- ======================================== -->
                    <!-- 7. NOTIFICATION PREFERENCES CARD         -->
                    <!-- ======================================== -->
                    <div class="settings-card-glass" id="notifications">
                        <div class="settings-card-head">
                            <div class="settings-card-head-left">
                                <div class="settings-icon-badge">
                                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                        <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"></path>
                                        <path d="M13.73 21a2 2 0 0 1-3.46 0"></path>
                                    </svg>
                                </div>
                                <div>
                                    <h3>Notification Preferences</h3>
                                    <p>Choose what notifications you want to receive.</p>
                                </div>
                            </div>
                        </div>

                        <form action="${pageContext.request.contextPath}/settings" method="POST">
                            <input type="hidden" name="action" value="updateNotifications">
                            <input type="hidden" name="section" value="notifications">

                            <div class="notif-toggles-list">
                                <!-- Task Reminders -->
                                <div class="notif-toggle-item">
                                    <div class="notif-toggle-info">
                                        <h4>Task Reminders</h4>
                                        <p>Get notified about upcoming deadlines</p>
                                    </div>
                                    <label class="switch">
                                        <input type="checkbox" name="taskReminders" ${student.taskReminders ? 'checked' : ''}>
                                        <span class="slider-round"></span>
                                    </label>
                                </div>

                                <!-- Timetable Updates -->
                                <div class="notif-toggle-item">
                                    <div class="notif-toggle-info">
                                        <h4>Timetable Updates</h4>
                                        <p>Get notified about schedule changes</p>
                                    </div>
                                    <label class="switch">
                                        <input type="checkbox" name="timetableUpdates" ${student.timetableUpdates ? 'checked' : ''}>
                                        <span class="slider-round"></span>
                                    </label>
                                </div>

                                <!-- Weekly Summary -->
                                <div class="notif-toggle-item">
                                    <div class="notif-toggle-info">
                                        <h4>Weekly Summary</h4>
                                        <p>Receive a weekly productivity report</p>
                                    </div>
                                    <label class="switch">
                                        <input type="checkbox" name="weeklySummary" ${student.weeklySummary ? 'checked' : ''}>
                                        <span class="slider-round"></span>
                                    </label>
                                </div>
                            </div>

                            <div style="margin-top: var(--space-lg); text-align: right;">
                                <button type="submit" class="btn-save-pill">
                                    Save Preferences
                                </button>
                            </div>
                        </form>
                    </div>

                    <!-- ======================================== -->
                    <!-- 8. APPEARANCE THEME CARD                 -->
                    <!-- ======================================== -->
                    <div class="settings-card-glass" id="appearance">
                        <div class="settings-card-head">
                            <div class="settings-card-head-left">
                                <div class="settings-icon-badge">
                                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                        <path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"></path>
                                    </svg>
                                </div>
                                <div>
                                    <h3>Appearance</h3>
                                    <p>Customize how SlotWise looks for you.</p>
                                </div>
                            </div>
                        </div>

                        <form action="${pageContext.request.contextPath}/settings" method="POST">
                            <input type="hidden" name="action" value="updateTheme">
                            <input type="hidden" name="section" value="appearance">

                            <div class="appearance-theme-cards">
                                <!-- Light Mode Card -->
                                <label class="theme-select-card ${student.themePreference == 'light' ? 'active' : ''}">
                                    <input type="radio" name="theme" value="light" ${student.themePreference == 'light' ? 'checked' : ''} style="position: absolute; opacity: 0; pointer-events: none;">
                                    <div class="theme-card-left">
                                        <div class="theme-card-icon">
                                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#a477ff" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                                <circle cx="12" cy="12" r="5"></circle>
                                                <line x1="12" y1="1" x2="12" y2="3"></line>
                                                <line x1="12" y1="21" x2="12" y2="23"></line>
                                                <line x1="4.22" y1="4.22" x2="5.64" y2="5.64"></line>
                                                <line x1="18.36" y1="18.36" x2="19.78" y2="19.78"></line>
                                                <line x1="1" y1="12" x2="3" y2="12"></line>
                                                <line x1="21" y1="12" x2="23" y2="12"></line>
                                                <line x1="4.22" y1="19.78" x2="5.64" y2="18.36"></line>
                                                <line x1="18.36" y1="5.64" x2="19.78" y2="4.22"></line>
                                            </svg>
                                        </div>
                                        <div class="theme-card-info">
                                            <h4>Light Mode</h4>
                                            <p>Clean and bright</p>
                                        </div>
                                    </div>
                                    <div class="theme-radio-circle"></div>
                                </label>

                                <!-- Dark Mode Card (Default & Recommended) -->
                                <label class="theme-select-card ${student.themePreference != 'light' ? 'active' : ''}">
                                    <input type="radio" name="theme" value="dark" ${student.themePreference != 'light' ? 'checked' : ''} style="position: absolute; opacity: 0; pointer-events: none;">
                                    <div class="theme-card-left">
                                        <div class="theme-card-icon">
                                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#a477ff" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                                <path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"></path>
                                            </svg>
                                        </div>
                                        <div class="theme-card-info">
                                            <h4>Dark Mode</h4>
                                            <p>Easy on the eyes</p>
                                        </div>
                                    </div>
                                    <div class="theme-radio-circle"></div>
                                </label>
                            </div>

                            <div style="margin-top: var(--space-lg); text-align: right;">
                                <button type="submit" class="btn-save-pill">
                                    Save Theme
                                </button>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- ============================================ -->
                <!-- 9. DATA & PRIVACY CARD                       -->
                <!-- ============================================ -->
                <div class="settings-card-glass" id="privacy">
                    <div class="settings-card-head">
                        <div class="settings-card-head-left">
                            <div class="settings-icon-badge">
                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
                                </svg>
                            </div>
                            <div>
                                <h3>Data &amp; Privacy</h3>
                                <p>Review stored account information and student data policies.</p>
                            </div>
                        </div>
                    </div>

                    <div class="privacy-info-block">
                        <p>
                            SlotWise stores your academic timetable entries, coursework deadlines, and generated study recommendations 
                            in a relational MySQL database. All operations are strictly bounded to your authenticated session ID 
                            (<code>student_id = ${student.studentId}</code>).
                        </p>

                        <div class="privacy-stats-row">
                            <div class="privacy-stat-box">
                                <strong>${student.studentId}</strong>
                                <span>Unique Student ID</span>
                            </div>
                            <div class="privacy-stat-box">
                                <strong>BCrypt-10</strong>
                                <span>Salted Hash Security</span>
                            </div>
                            <div class="privacy-stat-box">
                                <strong>Zero-JS</strong>
                                <span>Client Tracker Free</span>
                            </div>
                        </div>

                        <p style="font-size: 0.85rem; color: var(--text-muted);">
                            Account created on: <strong style="color: var(--text-secondary);"><fmt:formatDate value="${student.createdAt}" pattern="MMMM dd, yyyy" /> &bull; <fmt:formatDate value="${student.createdAt}" pattern="HH:mm:ss" /></strong>. 
                            Your personal academic data is never shared with third parties or external analytics providers.
                        </p>
                    </div>
                </div>

            </div>
        </div>
    </main>
</div>

</body>
</html>
