<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.slotwise.servlet.StudyGroupsServlet" %>
<%@ page import="com.slotwise.servlet.StudyGroupsServlet.StudyGroup" %>
<%@ page import="com.slotwise.servlet.StudyGroupsServlet.RecommendedGroup" %>
<%@ page import="com.slotwise.servlet.StudyGroupsServlet.StudySessionItem" %>
<%@ page import="com.slotwise.servlet.StudyGroupsServlet.ActivityItem" %>
<%@ page import="java.util.List" %>
<%
    // Ensure default session user info
    if (session.getAttribute("studentName") == null) {
        session.setAttribute("studentName", "Harish M");
    }
    if (session.getAttribute("yearOfStudy") == null) {
        session.setAttribute("yearOfStudy", "CSE - 2nd Year");
    }
    String displayName = (String) session.getAttribute("studentName");
    if (displayName == null || displayName.trim().isEmpty()) displayName = "Harish M";
    String yearRole = (String) session.getAttribute("yearOfStudy");
    if (yearRole == null || yearRole.trim().isEmpty()) yearRole = "CSE - 2nd Year";

    // Ensure backend master data is initialized
    StudyGroupsServlet.initDefaultData();

    // Fallback if accessed directly via .jsp without servlet forward
    if (request.getAttribute("groups") == null) {
        request.setAttribute("groups", StudyGroupsServlet.masterGroups);
        request.setAttribute("recommended", StudyGroupsServlet.masterRecommended);
        request.setAttribute("sessions", StudyGroupsServlet.masterSessions);
        request.setAttribute("activities", StudyGroupsServlet.masterActivities);
        request.setAttribute("joinedGroupsCount", StudyGroupsServlet.getJoinedGroupsCount());
        request.setAttribute("totalMembersCount", StudyGroupsServlet.getTotalMembersCount());
        request.setAttribute("studySessionsCount", 18);
        request.setAttribute("activeParticipationRate", 92);
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Study Groups &mdash; SlotWise</title>
    <meta name="description" content="Learn together. Solve together. Grow together with SlotWise Study Groups.">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg-body: #060814;
            --bg-sidebar: #070a18;
            --bg-card: #090e24;
            --bg-card-hover: #0c1332;
            --border-card: rgba(255, 255, 255, 0.07);
            --border-subtle: rgba(255, 255, 255, 0.09);
            --primary-purple: #6d5dfc;
            --primary-gradient: linear-gradient(135deg, #6366f1 0%, #7c3aed 100%);
            --accent-glow: rgba(99, 102, 241, 0.35);
            --text-main: #f8fafc;
            --text-muted: #8492a6;
            --text-dim: #475569;
            --badge-green-bg: rgba(16, 185, 129, 0.12);
            --badge-green-text: #10b981;
            --badge-green-border: rgba(16, 185, 129, 0.35);
        }

        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            background-color: var(--bg-body);
            color: var(--text-main);
            font-family: 'Plus Jakarta Sans', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            overflow-x: hidden;
            -webkit-font-smoothing: antialiased;
        }

        a { color: inherit; text-decoration: none; }
        button, input, select, textarea { font-family: inherit; }

        /* ===== MAIN LAYOUT ===== */
        .sw-layout {
            display: flex;
            min-height: 100vh;
            background: #060814;
        }

        /* ===== SIDEBAR ===== */
        .sw-sidebar {
            width: 236px;
            background-color: var(--bg-sidebar);
            border-right: 1px solid var(--border-card);
            display: flex;
            flex-direction: column;
            flex-shrink: 0;
            padding: 22px 14px 14px 14px;
            position: sticky;
            top: 0;
            height: 100vh;
            overflow-y: auto;
            z-index: 50;
        }

        .sw-sidebar::-webkit-scrollbar { width: 3px; }
        .sw-sidebar::-webkit-scrollbar-thumb { background: rgba(255,255,255,0.1); border-radius: 4px; }

        .sw-logo {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 0 10px 20px 10px;
            font-size: 1.25rem;
            font-weight: 800;
            color: #ffffff;
            letter-spacing: -0.02em;
        }

        .sw-logo-icon {
            width: 30px;
            height: 30px;
            background: var(--primary-gradient);
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            box-shadow: 0 4px 14px rgba(99, 102, 241, 0.4);
        }

        .sw-logo span {
            background: linear-gradient(135deg, #a78bfa 0%, #818cf8 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .sw-nav-list {
            display: flex;
            flex-direction: column;
            gap: 2px;
            list-style: none;
        }

        .sw-nav-item {
            display: flex;
            align-items: center;
            gap: 13px;
            padding: 8px 12px;
            border-radius: 9px;
            font-size: 0.85rem;
            font-weight: 500;
            color: var(--text-muted);
            transition: all 0.2s ease;
        }

        .sw-nav-item svg {
            width: 17px;
            height: 17px;
            stroke-width: 2;
            flex-shrink: 0;
            transition: transform 0.2s ease, stroke 0.2s ease;
        }

        .sw-nav-item:hover {
            color: #ffffff;
            background: rgba(255, 255, 255, 0.04);
        }

        .sw-nav-item:hover svg {
            transform: scale(1.06);
            stroke: #a78bfa;
        }

        .sw-nav-item.active {
            background: linear-gradient(135deg, #6366f1 0%, #7c3aed 100%);
            color: #ffffff;
            font-weight: 600;
            box-shadow: 0 4px 18px rgba(124, 58, 237, 0.45);
        }

        .sw-nav-item.active svg { stroke: #ffffff; }

        .sw-sidebar-footer {
            margin-top: auto;
            padding-top: 10px;
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        .sw-nav-item.logout { color: #94a3b8; }
        .sw-nav-item.logout:hover {
            color: #f87171;
            background: rgba(239, 68, 68, 0.1);
        }

        /* Cliff silhouette artwork at sidebar bottom matching the image */
        .sw-sidebar-artwork {
            width: 100%;
            height: 125px;
            border-radius: 12px;
            overflow: hidden;
            position: relative;
            background: linear-gradient(180deg, #15092e 0%, #060411 100%);
            border: 1px solid rgba(255, 255, 255, 0.06);
            margin-top: 2px;
            box-shadow: inset 0 0 16px rgba(124, 58, 237, 0.25);
        }

        .sw-sidebar-artwork svg { width: 100%; height: 100%; display: block; }

        /* ===== MAIN WRAPPER ===== */
        .sw-main {
            flex: 1;
            display: flex;
            flex-direction: column;
            min-width: 0;
            background: #060814;
        }

        /* ===== TOPBAR ===== */
        .sw-topbar {
            height: 60px;
            padding: 0 28px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            border-bottom: 1px solid var(--border-card);
            background: rgba(6, 8, 20, 0.92);
            backdrop-filter: blur(14px);
            position: sticky;
            top: 0;
            z-index: 40;
        }

        .sw-search-wrapper {
            position: relative;
            width: 420px;
        }

        .sw-search-wrapper svg {
            position: absolute;
            left: 14px;
            top: 50%;
            transform: translateY(-50%);
            width: 15px;
            height: 15px;
            stroke: var(--text-muted);
            pointer-events: none;
        }

        .sw-search-input {
            width: 100%;
            height: 36px;
            padding: 0 16px 0 40px;
            background: #090e24;
            border: 1px solid var(--border-subtle);
            border-radius: 20px;
            color: #ffffff;
            font-size: 0.83rem;
            outline: none;
            transition: all 0.2s ease;
        }

        .sw-search-input::placeholder { color: #526079; }
        .sw-search-input:focus {
            border-color: #6366f1;
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.2);
            background: #0c1433;
        }

        .sw-topbar-actions {
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .sw-bell-btn {
            position: relative;
            background: #090e24;
            border: 1px solid var(--border-subtle);
            width: 36px;
            height: 36px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--text-muted);
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .sw-bell-btn:hover { color: #ffffff; border-color: rgba(255,255,255,0.2); }

        .sw-bell-dot {
            position: absolute;
            top: 8px;
            right: 8px;
            width: 6.5px;
            height: 6.5px;
            background: #ef4444;
            border-radius: 50%;
            border: 1.5px solid #060814;
        }

        .sw-profile-pill {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 3px 8px 3px 3px;
            border-radius: 28px;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .sw-profile-pill:hover { background: rgba(255, 255, 255, 0.04); }

        .sw-avatar-circle {
            width: 34px;
            height: 34px;
            border-radius: 50%;
            background: linear-gradient(135deg, #f59e0b 0%, #ef4444 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.85rem;
            font-weight: 700;
            color: #ffffff;
            box-shadow: 0 2px 8px rgba(0,0,0,0.3);
        }

        .sw-profile-info {
            display: flex;
            flex-direction: column;
            text-align: left;
            line-height: 1.25;
        }

        .sw-profile-name { font-size: 0.84rem; font-weight: 700; color: #ffffff; }
        .sw-profile-role { font-size: 0.71rem; color: var(--text-muted); }
        .sw-profile-chevron { color: var(--text-muted); margin-left: 2px; }

        /* ===== PAGE CONTAINER ===== */
        .sg-container {
            padding: 22px 28px 40px 28px;
            max-width: 1560px;
            margin: 0 auto;
            width: 100%;
            display: flex;
            flex-direction: column;
            gap: 18px;
        }

        /* ===== TOP BANNER ===== */
        .sg-header-banner {
            display: flex;
            align-items: center;
            justify-content: space-between;
            position: relative;
        }

        .sg-header-title-box h1 {
            font-size: 2.15rem;
            font-weight: 800;
            color: #ffffff;
            letter-spacing: -0.025em;
            margin-bottom: 4px;
            line-height: 1.15;
        }

        .sg-header-title-box h1 span {
            color: #8b5cf6;
        }

        .sg-header-title-box p {
            font-size: 0.88rem;
            color: var(--text-muted);
        }

        .sg-header-right {
            display: flex;
            align-items: center;
            gap: 22px;
        }

        /* Purple 3D collaborative graphic */
        .sg-header-illustration {
            width: 155px;
            height: 56px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .sg-header-illustration svg { width: 100%; height: 100%; }

        .sg-btn-create-primary {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: linear-gradient(135deg, #6366f1 0%, #7c3aed 100%);
            color: #ffffff;
            font-size: 0.88rem;
            font-weight: 700;
            padding: 10px 22px;
            border-radius: 9px;
            border: none;
            cursor: pointer;
            box-shadow: 0 4px 18px rgba(124, 58, 237, 0.4);
            transition: all 0.2s ease;
        }

        .sg-btn-create-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 24px rgba(124, 58, 237, 0.55);
        }

        .sg-btn-create-primary svg { width: 16px; height: 16px; stroke-width: 2.5; }

        /* ===== TWO-COLUMN MASTER LAYOUT ===== */
        /* Aligned so that left column contains Tabs, Stats, Toolbar, 6 Cards, and Recommended.
           Right column contains Upcoming Sessions, Recent Activity, and Create Widget. */
        .sg-main-layout {
            display: grid;
            grid-template-columns: 1fr 318px;
            gap: 20px;
            align-items: start;
        }

        /* ===== LEFT COLUMN ===== */
        .sg-left-col {
            display: flex;
            flex-direction: column;
            gap: 16px;
        }

        /* 1. CATEGORY PILL TABS */
        .sg-tabs-row {
            display: flex;
            align-items: center;
            gap: 8px;
            flex-wrap: wrap;
        }

        .sg-tab-btn {
            background: #090e24;
            border: 1px solid var(--border-card);
            color: var(--text-muted);
            font-size: 0.81rem;
            font-weight: 600;
            padding: 6px 16px;
            border-radius: 20px;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .sg-tab-btn:hover {
            color: #ffffff;
            background: #0d1536;
            border-color: rgba(255,255,255,0.15);
        }

        .sg-tab-btn.active {
            background: #6366f1;
            color: #ffffff;
            border-color: #6366f1;
            box-shadow: 0 2px 12px rgba(99, 102, 241, 0.35);
        }

        /* 2. STATS ROW (4 CARDS) */
        .sg-stats-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 14px;
        }

        .sg-stat-card {
            background: var(--bg-card);
            border: 1px solid var(--border-card);
            border-radius: 12px;
            padding: 15px 16px;
            display: flex;
            align-items: center;
            gap: 14px;
            transition: transform 0.2s ease, border-color 0.2s ease;
        }

        .sg-stat-card:hover {
            transform: translateY(-2px);
            border-color: rgba(255, 255, 255, 0.14);
        }

        .sg-stat-icon-box {
            width: 40px;
            height: 40px;
            border-radius: 9px;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        .sg-stat-icon-purple { background: rgba(139, 92, 246, 0.18); color: #a78bfa; }
        .sg-stat-icon-blue   { background: rgba(59, 130, 246, 0.18); color: #60a5fa; }
        .sg-stat-icon-green  { background: rgba(16, 185, 129, 0.18); color: #34d399; }
        .sg-stat-icon-orange { background: rgba(249, 115, 22, 0.18); color: #fb923c; }

        .sg-stat-icon-box svg { width: 20px; height: 20px; }

        .sg-stat-details {
            display: flex;
            flex-direction: column;
        }

        .sg-stat-num {
            font-size: 1.35rem;
            font-weight: 800;
            color: #ffffff;
            line-height: 1.15;
            letter-spacing: -0.01em;
        }

        .sg-stat-label {
            font-size: 0.76rem;
            color: var(--text-muted);
            font-weight: 500;
            white-space: nowrap;
        }

        /* 3. TOOLBAR: SEARCH & SELECTS */
        .sg-toolbar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            margin-top: 2px;
        }

        .sg-subsearch-wrapper {
            position: relative;
            flex: 1;
            max-width: 320px;
        }

        .sg-subsearch-wrapper svg {
            position: absolute;
            left: 12px;
            top: 50%;
            transform: translateY(-50%);
            width: 14px;
            height: 14px;
            stroke: var(--text-muted);
            pointer-events: none;
        }

        .sg-subsearch-input {
            width: 100%;
            height: 36px;
            padding: 0 14px 0 34px;
            background: #090e24;
            border: 1px solid var(--border-card);
            border-radius: 8px;
            color: #ffffff;
            font-size: 0.81rem;
            outline: none;
            transition: all 0.2s ease;
        }

        .sg-subsearch-input:focus {
            border-color: #6366f1;
            background: #0d1536;
        }

        .sg-toolbar-filters {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .sg-select-box {
            background: #090e24;
            border: 1px solid var(--border-card);
            color: #ffffff;
            font-size: 0.81rem;
            font-weight: 500;
            padding: 0 28px 0 12px;
            height: 36px;
            border-radius: 8px;
            outline: none;
            cursor: pointer;
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 24 24' fill='none' stroke='%238492a6' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3E%3Cpolyline points='6 9 12 15 18 9'%3E%3C/polyline%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 10px center;
            transition: border-color 0.2s ease;
        }

        .sg-select-box:focus { border-color: #6366f1; }

        .sg-view-toggles {
            display: flex;
            align-items: center;
            background: #090e24;
            border: 1px solid var(--border-card);
            border-radius: 8px;
            overflow: hidden;
            height: 36px;
        }

        .sg-view-btn {
            background: transparent;
            border: none;
            color: var(--text-muted);
            width: 36px;
            height: 36px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .sg-view-btn svg { width: 16px; height: 16px; }

        .sg-view-btn.active {
            background: #191b48;
            color: #a78bfa;
        }

        /* 4. MAIN STUDY GROUP CARDS (3x2 GRID) */
        .sg-cards-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 14px;
        }

        .sg-cards-grid.list-view {
            grid-template-columns: 1fr;
        }

        .sg-card {
            background: var(--bg-card);
            border: 1px solid var(--border-card);
            border-radius: 14px;
            padding: 16px;
            display: flex;
            flex-direction: column;
            gap: 12px;
            position: relative;
            transition: all 0.2s ease;
        }

        .sg-card:hover {
            transform: translateY(-2px);
            border-color: rgba(139, 92, 246, 0.35);
            background: var(--bg-card-hover);
            box-shadow: 0 8px 22px rgba(0, 0, 0, 0.35);
        }

        .sg-card-top {
            display: flex;
            align-items: flex-start;
            gap: 11px;
        }

        .sg-card-icon {
            width: 40px;
            height: 40px;
            border-radius: 9px;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        .sg-card-icon svg { width: 20px; height: 20px; }

        .sg-card-title-col {
            flex: 1;
            min-width: 0;
        }

        .sg-card-name {
            font-size: 0.91rem;
            font-weight: 700;
            color: #ffffff;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            line-height: 1.25;
            margin-bottom: 4px;
        }

        .sg-category-badge {
            display: inline-block;
            font-size: 0.68rem;
            font-weight: 600;
            padding: 2px 7px;
            border-radius: 5px;
            text-transform: capitalize;
            letter-spacing: 0.02em;
        }

        .sg-badge-academic { background: rgba(139, 92, 246, 0.2); color: #c084fc; border: 1px solid rgba(139, 92, 246, 0.3); }
        .sg-badge-exam     { background: rgba(59, 130, 246, 0.2); color: #60a5fa; border: 1px solid rgba(59, 130, 246, 0.3); }
        .sg-badge-project  { background: rgba(249, 115, 22, 0.2); color: #fb923c; border: 1px solid rgba(249, 115, 22, 0.3); }

        .sg-card-menu-btn {
            background: transparent;
            border: none;
            color: var(--text-dim);
            cursor: pointer;
            width: 22px;
            height: 22px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 4px;
            transition: color 0.2s ease;
        }

        .sg-card-menu-btn:hover { color: #ffffff; background: rgba(255,255,255,0.06); }

        .sg-card-desc {
            font-size: 0.78rem;
            color: #94a3b8;
            line-height: 1.4;
            min-height: 34px;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        .sg-card-meta {
            display: flex;
            align-items: center;
            gap: 14px;
            font-size: 0.74rem;
            color: var(--text-muted);
        }

        .sg-meta-item {
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .sg-meta-item svg { width: 13px; height: 13px; stroke-width: 2; }

        .sg-card-bottom {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-top: auto;
            padding-top: 4px;
        }

        /* Avatar Stack */
        .sg-avatar-stack {
            display: flex;
            align-items: center;
        }

        .sg-avatar-mini {
            width: 24px;
            height: 24px;
            border-radius: 50%;
            border: 2px solid #090e24;
            margin-left: -6px;
            background: #1e293b;
            overflow: hidden;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.62rem;
            font-weight: 700;
            color: #ffffff;
        }

        .sg-avatar-mini:first-child { margin-left: 0; }
        .sg-avatar-mini img { width: 100%; height: 100%; object-fit: cover; }

        .sg-avatar-plus {
            width: 24px;
            height: 24px;
            border-radius: 50%;
            background: #192038;
            border: 2px solid #090e24;
            margin-left: -6px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.62rem;
            font-weight: 700;
            color: #a78bfa;
        }

        /* Card Action Buttons */
        .sg-btn-join {
            background: #6366f1;
            color: #ffffff;
            border: none;
            padding: 5px 16px;
            border-radius: 7px;
            font-size: 0.76rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .sg-btn-join:hover {
            background: #4f46e5;
            box-shadow: 0 2px 10px rgba(99, 102, 241, 0.4);
        }

        .sg-btn-joined {
            background: var(--badge-green-bg);
            color: var(--badge-green-text);
            border: 1px solid var(--badge-green-border);
            padding: 4px 14px;
            border-radius: 7px;
            font-size: 0.76rem;
            font-weight: 600;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 4px;
            transition: all 0.2s ease;
        }

        .sg-btn-joined:hover {
            background: rgba(239, 68, 68, 0.15);
            color: #ef4444;
            border-color: rgba(239, 68, 68, 0.35);
        }

        /* 5. RECOMMENDED GROUPS */
        .sg-recommended-box {
            display: flex;
            flex-direction: column;
            gap: 10px;
            margin-top: 4px;
        }

        .sg-sec-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .sg-sec-title {
            display: flex;
            align-items: center;
            gap: 7px;
            font-size: 0.92rem;
            font-weight: 700;
            color: #ffffff;
        }

        .sg-sec-title svg { color: #8b5cf6; width: 16px; height: 16px; }

        .sg-sec-link {
            font-size: 0.74rem;
            font-weight: 600;
            color: #8b5cf6;
            cursor: pointer;
            transition: color 0.2s ease;
        }

        .sg-sec-link:hover { color: #a78bfa; text-decoration: underline; }

        .sg-recommended-row {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 12px;
        }

        .sg-rec-card {
            background: var(--bg-card);
            border: 1px solid var(--border-card);
            border-radius: 11px;
            padding: 12px 14px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 8px;
            transition: all 0.2s ease;
        }

        .sg-rec-card:hover {
            transform: translateY(-2px);
            border-color: rgba(255, 255, 255, 0.14);
            background: var(--bg-card-hover);
        }

        .sg-rec-left {
            display: flex;
            align-items: center;
            gap: 10px;
            min-width: 0;
        }

        .sg-rec-icon {
            width: 32px;
            height: 32px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.95rem;
            font-weight: 800;
            flex-shrink: 0;
        }

        .sg-rec-info {
            display: flex;
            flex-direction: column;
            min-width: 0;
        }

        .sg-rec-name {
            font-size: 0.8rem;
            font-weight: 700;
            color: #ffffff;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .sg-rec-members {
            font-size: 0.69rem;
            color: var(--text-muted);
        }

        .sg-rec-btn {
            background: #6366f1;
            color: #ffffff;
            border: none;
            padding: 4px 12px;
            border-radius: 6px;
            font-size: 0.72rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s ease;
            flex-shrink: 0;
        }

        .sg-rec-btn:hover { background: #4f46e5; }
        .sg-rec-btn.joined {
            background: var(--badge-green-bg);
            color: var(--badge-green-text);
            border: 1px solid var(--badge-green-border);
        }

        /* ===== RIGHT COLUMN (WIDGETS) ===== */
        .sg-right-col {
            display: flex;
            flex-direction: column;
            gap: 16px;
        }

        .sg-widget {
            background: var(--bg-card);
            border: 1px solid var(--border-card);
            border-radius: 14px;
            padding: 16px 18px;
            display: flex;
            flex-direction: column;
            gap: 14px;
        }

        .sg-widget-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .sg-widget-title {
            display: flex;
            align-items: center;
            gap: 7px;
            font-size: 0.85rem;
            font-weight: 700;
            color: #ffffff;
        }

        .sg-widget-title svg { width: 15px; height: 15px; color: #8b5cf6; }

        /* UPCOMING SESSIONS LIST */
        .sg-sessions-list {
            display: flex;
            flex-direction: column;
            gap: 11px;
        }

        .sg-session-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 10px;
        }

        .sg-session-left {
            display: flex;
            align-items: center;
            gap: 10px;
            min-width: 0;
        }

        .sg-date-badge {
            width: 34px;
            height: 36px;
            background: #231219;
            border: 1px solid rgba(239, 68, 68, 0.25);
            border-radius: 7px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
            line-height: 1.05;
        }

        .sg-date-month {
            font-size: 0.55rem;
            font-weight: 700;
            color: #f87171;
            text-transform: uppercase;
        }

        .sg-date-day {
            font-size: 0.9rem;
            font-weight: 800;
            color: #ffffff;
        }

        .sg-session-info {
            display: flex;
            flex-direction: column;
            min-width: 0;
        }

        .sg-session-title {
            font-size: 0.79rem;
            font-weight: 600;
            color: #ffffff;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .sg-session-time {
            font-size: 0.68rem;
            color: var(--text-muted);
        }

        .sg-session-btn {
            background: #141b38;
            color: #ffffff;
            border: 1px solid var(--border-card);
            padding: 4px 12px;
            border-radius: 6px;
            font-size: 0.72rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s ease;
            flex-shrink: 0;
        }

        .sg-session-btn:hover {
            background: #6366f1;
            border-color: #6366f1;
        }

        .sg-session-btn.joined {
            background: var(--badge-green-bg);
            color: var(--badge-green-text);
            border-color: var(--badge-green-border);
        }

        /* RECENT ACTIVITY LIST */
        .sg-activity-list {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        .sg-activity-item {
            display: flex;
            align-items: flex-start;
            gap: 10px;
        }

        .sg-activity-icon {
            width: 30px;
            height: 30px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
            margin-top: 1px;
        }

        .sg-activity-icon svg { width: 14px; height: 14px; }

        .sg-activity-content {
            display: flex;
            flex-direction: column;
            gap: 1px;
        }

        .sg-activity-text {
            font-size: 0.76rem;
            color: #e2e8f0;
            line-height: 1.35;
        }

        .sg-activity-time {
            font-size: 0.67rem;
            color: var(--text-muted);
        }

        /* CREATE YOUR OWN GROUP WIDGET */
        .sg-widget-create {
            background: var(--bg-card);
            border: 1px solid var(--border-card);
            border-radius: 14px;
            padding: 18px;
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        .sg-widget-create-header {
            display: flex;
            align-items: center;
            gap: 9px;
        }

        .sg-widget-create-icon {
            width: 30px;
            height: 30px;
            border-radius: 8px;
            background: rgba(99, 102, 241, 0.15);
            color: #a78bfa;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .sg-widget-create-icon svg { width: 16px; height: 16px; }

        .sg-widget-create-header h3 {
            font-size: 0.88rem;
            font-weight: 700;
            color: #ffffff;
        }

        .sg-widget-create p {
            font-size: 0.76rem;
            color: var(--text-muted);
            line-height: 1.4;
        }

        .sg-btn-create-block {
            width: 100%;
            background: linear-gradient(135deg, #6366f1 0%, #7c3aed 100%);
            color: #ffffff;
            border: none;
            padding: 9px;
            border-radius: 8px;
            font-size: 0.82rem;
            font-weight: 700;
            cursor: pointer;
            box-shadow: 0 4px 14px rgba(124, 58, 237, 0.35);
            transition: all 0.2s ease;
        }

        .sg-btn-create-block:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 18px rgba(124, 58, 237, 0.5);
        }

        /* ===== MODALS ===== */
        .sg-modal-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100vw;
            height: 100vh;
            background: rgba(6, 8, 20, 0.82);
            backdrop-filter: blur(10px);
            display: none;
            align-items: center;
            justify-content: center;
            z-index: 1000;
            padding: 20px;
        }

        .sg-modal-overlay.open { display: flex; }

        .sg-modal {
            background: #0d1430;
            border: 1px solid rgba(255, 255, 255, 0.12);
            border-radius: 18px;
            width: 500px;
            max-width: 95vw;
            max-height: 90vh;
            overflow-y: auto;
            padding: 24px;
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.75);
            animation: modalPop 0.22s ease-out;
        }

        @keyframes modalPop {
            0% { transform: scale(0.92); opacity: 0; }
            100% { transform: scale(1); opacity: 1; }
        }

        .sg-modal-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 18px;
        }

        .sg-modal-title {
            font-size: 1.1rem;
            font-weight: 700;
            color: #ffffff;
        }

        .sg-modal-close {
            background: rgba(255, 255, 255, 0.05);
            border: none;
            color: var(--text-muted);
            width: 30px;
            height: 30px;
            border-radius: 7px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .sg-modal-close:hover {
            color: #ffffff;
            background: rgba(255, 255, 255, 0.12);
        }

        .sg-form-group { margin-bottom: 15px; }

        .sg-form-label {
            display: block;
            font-size: 0.78rem;
            font-weight: 600;
            color: #cbd5e1;
            margin-bottom: 5px;
        }

        .sg-form-input, .sg-form-select, .sg-form-textarea {
            width: 100%;
            background: #080d22;
            border: 1px solid var(--border-subtle);
            border-radius: 9px;
            padding: 9px 12px;
            color: #ffffff;
            font-size: 0.84rem;
            outline: none;
            transition: border-color 0.2s ease;
        }

        .sg-form-input:focus, .sg-form-select:focus, .sg-form-textarea:focus {
            border-color: #6366f1;
            background: #0a112c;
        }

        .sg-form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
        }

        .sg-form-actions {
            display: flex;
            align-items: center;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 20px;
        }

        .sg-btn-secondary {
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.1);
            color: var(--text-muted);
            padding: 8px 16px;
            border-radius: 8px;
            font-size: 0.82rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .sg-btn-secondary:hover {
            color: #ffffff;
            background: rgba(255, 255, 255, 0.1);
        }

        .sg-btn-primary {
            background: linear-gradient(135deg, #6366f1 0%, #7c3aed 100%);
            border: none;
            color: #ffffff;
            padding: 8px 18px;
            border-radius: 8px;
            font-size: 0.82rem;
            font-weight: 700;
            cursor: pointer;
            box-shadow: 0 4px 14px rgba(124, 58, 237, 0.4);
            transition: all 0.2s ease;
        }

        .sg-btn-primary:hover {
            transform: translateY(-1px);
            box-shadow: 0 6px 18px rgba(124, 58, 237, 0.5);
        }

        /* CHAT WINDOW */
        .sg-chat-window {
            background: #070b1a;
            border: 1px solid var(--border-card);
            border-radius: 10px;
            height: 240px;
            overflow-y: auto;
            padding: 12px;
            display: flex;
            flex-direction: column;
            gap: 8px;
            margin-bottom: 12px;
        }

        .sg-chat-bubble {
            background: #111a3b;
            border: 1px solid rgba(255, 255, 255, 0.05);
            border-radius: 9px;
            padding: 7px 11px;
            font-size: 0.8rem;
            color: #e2e8f0;
            max-width: 85%;
            word-break: break-word;
        }

        .sg-chat-bubble.me {
            align-self: flex-end;
            background: linear-gradient(135deg, #4f46e5 0%, #7c3aed 100%);
            color: #ffffff;
        }

        .sg-chat-input-row {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        /* ===== TOAST NOTIFICATION ===== */
        .sg-toast {
            position: fixed;
            bottom: 24px;
            right: 24px;
            background: #0d1532;
            border: 1px solid rgba(99, 102, 241, 0.4);
            border-radius: 10px;
            padding: 11px 18px;
            color: #ffffff;
            font-size: 0.84rem;
            display: flex;
            align-items: center;
            gap: 9px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.6);
            transform: translateY(80px);
            opacity: 0;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            z-index: 2000;
        }

        .sg-toast.show {
            transform: translateY(0);
            opacity: 1;
        }

        /* ===== RESPONSIVE BREAKPOINTS ===== */
        @media (max-width: 1280px) {
            .sg-cards-grid { grid-template-columns: repeat(2, 1fr); }
            .sg-recommended-row { grid-template-columns: repeat(2, 1fr); }
            .sg-stats-grid { grid-template-columns: repeat(2, 1fr); }
            .sg-main-layout { grid-template-columns: 1fr; }
        }

        @media (max-width: 768px) {
            .sw-layout { flex-direction: column; }
            .sw-sidebar { width: 100%; height: auto; position: static; }
            .sg-container { padding: 14px; }
            .sg-cards-grid { grid-template-columns: 1fr; }
            .sg-recommended-row { grid-template-columns: 1fr; }
            .sg-stats-grid { grid-template-columns: 1fr; }
            .sg-header-banner { flex-direction: column; align-items: flex-start; gap: 12px; }
            .sw-topbar { padding: 0 16px; }
            .sw-search-wrapper { width: 180px; }
        }
    </style>
</head>
<body>

<div class="sw-layout">

    <!-- ===== LEFT SIDEBAR ===== -->
    <aside class="sw-sidebar">
        <a href="${pageContext.request.contextPath}/dashboard" class="sw-logo">
            <div class="sw-logo-icon">
                <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M22 10v6M2 10l10-5 10 5-10 5z"></path>
                    <path d="M6 12v5c3 3 9 3 12 0v-5"></path>
                </svg>
            </div>
            Slot<span>Wise</span>
        </a>

        <ul class="sw-nav-list">
            <!-- Dashboard -->
            <li>
                <a href="${pageContext.request.contextPath}/dashboard" class="sw-nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path>
                        <polyline points="9 22 9 12 15 12 15 22"></polyline>
                    </svg>
                    <span>Dashboard</span>
                </a>
            </li>

            <!-- Timetable -->
            <li>
                <a href="${pageContext.request.contextPath}/today-timetable" class="sw-nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round">
                        <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                        <line x1="16" y1="2" x2="16" y2="6"></line>
                        <line x1="8" y1="2" x2="8" y2="6"></line>
                        <line x1="3" y1="10" x2="21" y2="10"></line>
                    </svg>
                    <span>Timetable</span>
                </a>
            </li>

            <!-- My Tasks -->
            <li>
                <a href="${pageContext.request.contextPath}/tasks" class="sw-nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M9 11l3 3L22 4"></path>
                        <path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"></path>
                    </svg>
                    <span>My Tasks</span>
                </a>
            </li>

            <!-- Study Planner -->
            <li>
                <a href="${pageContext.request.contextPath}/study-planner" class="sw-nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="12" cy="12" r="10"></circle>
                        <line x1="12" y1="2" x2="12" y2="22"></line>
                        <path d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z"></path>
                        <path d="M2 12h20"></path>
                    </svg>
                    <span>Study Planner</span>
                </a>
            </li>

            <!-- Progress -->
            <li>
                <a href="${pageContext.request.contextPath}/progress" class="sw-nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round">
                        <line x1="18" y1="20" x2="18" y2="10"></line>
                        <line x1="12" y1="20" x2="12" y2="4"></line>
                        <line x1="6" y1="20" x2="6" y2="14"></line>
                    </svg>
                    <span>Progress</span>
                </a>
            </li>

            <!-- Materials -->
            <li>
                <a href="${pageContext.request.contextPath}/materials" class="sw-nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path>
                        <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path>
                    </svg>
                    <span>Materials</span>
                </a>
            </li>

            <!-- Study Groups (ACTIVE) -->
            <li>
                <a href="${pageContext.request.contextPath}/study-groups.jsp" class="sw-nav-item active">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                        <circle cx="9" cy="7" r="4"></circle>
                        <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                        <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                    </svg>
                    <span>Study Groups</span>
                </a>
            </li>

            <!-- Smart Rescheduler -->
            <li>
                <a href="${pageContext.request.contextPath}/rescheduler" class="sw-nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round">
                        <polyline points="23 4 23 10 17 10"></polyline>
                        <polyline points="1 20 1 14 7 14"></polyline>
                        <path d="M3.51 9a9 9 0 0 1 14.85-3.36L23 10M1 14l4.64 4.36A9 9 0 0 0 20.49 15"></path>
                    </svg>
                    <span>Smart Rescheduler</span>
                </a>
            </li>

            <!-- Deadline Radar -->
            <li>
                <a href="${pageContext.request.contextPath}/deadlines" class="sw-nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="12" cy="12" r="2"></circle>
                        <path d="M16.24 7.76a6 6 0 0 1 0 8.49m-8.48-.01a6 6 0 0 1 0-8.49m11.31-2.82a10 10 0 0 1 0 14.14m-14.14 0a10 10 0 0 1 0-14.14"></path>
                    </svg>
                    <span>Deadline Radar</span>
                </a>
            </li>

            <!-- Goals -->
            <li>
                <a href="${pageContext.request.contextPath}/goals.jsp" class="sw-nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="12" cy="12" r="10"></circle>
                        <circle cx="12" cy="6" r="2"></circle>
                    </svg>
                    <span>Goals</span>
                </a>
            </li>

            <!-- Settings -->
            <li>
                <a href="${pageContext.request.contextPath}/settings" class="sw-nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="12" cy="12" r="3"></circle>
                        <path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z"></path>
                    </svg>
                    <span>Settings</span>
                </a>
            </li>
        </ul>

        <div class="sw-sidebar-footer">
            <a href="${pageContext.request.contextPath}/logout" class="sw-nav-item logout">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path>
                    <polyline points="16 17 21 12 16 7"></polyline>
                    <line x1="21" y1="12" x2="9" y2="12"></line>
                </svg>
                <span>Logout</span>
            </a>

            <!-- Night Skyline Cliff Artwork from Reference -->
            <div class="sw-sidebar-artwork">
                <svg viewBox="0 0 200 130" fill="none" preserveAspectRatio="none">
                    <defs>
                        <linearGradient id="artSky" x1="0" y1="0" x2="0" y2="1">
                            <stop offset="0%" stop-color="#4c1d95" stop-opacity="0.8"/>
                            <stop offset="60%" stop-color="#a855f7" stop-opacity="0.6"/>
                            <stop offset="100%" stop-color="#3b0764" stop-opacity="0.9"/>
                        </linearGradient>
                        <linearGradient id="artGlow" x1="0" y1="1" x2="0" y2="0">
                            <stop offset="0%" stop-color="#ec4899" stop-opacity="0.5"/>
                            <stop offset="100%" stop-color="#3b0764" stop-opacity="0"/>
                        </linearGradient>
                    </defs>
                    <rect width="200" height="130" fill="url(#artSky)"/>
                    <rect y="60" width="200" height="70" fill="url(#artGlow)"/>
                    <!-- Distant City Skyline -->
                    <path d="M10 90h8v20h-8zm12-15h6v35h-6zm10 10h10v25h-10zm14-25h8v50h-8zm12 18h6v32h-6zm10-8h12v40h-12zm16 14h8v26h-8zm12-22h7v48h-7zm11 12h10v36h-10zm14-16h9v52h-9zm13 20h8v32h-8z" fill="#0f0c29" opacity="0.8"/>
                    <!-- Cliff & Silhouettes -->
                    <path d="M0 80 Q50 95 90 85 Q130 115 200 130 L0 130 Z" fill="#05030a"/>
                    <!-- Two figures sitting on cliff -->
                    <circle cx="82" cy="74" r="3.5" fill="#05030a"/>
                    <path d="M78 85 L82 78 L86 85 Z" fill="#05030a"/>
                    <circle cx="95" cy="71" r="3.5" fill="#05030a"/>
                    <path d="M91 82 L95 75 L99 82 Z" fill="#05030a"/>
                </svg>
            </div>
        </div>
    </aside>

    <!-- ===== MAIN CONTENT ===== -->
    <main class="sw-main">

        <!-- ===== TOPBAR ===== -->
        <header class="sw-topbar">
            <div class="sw-search-wrapper">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round">
                    <circle cx="11" cy="11" r="8"></circle>
                    <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                </svg>
                <input type="text" class="sw-search-input" id="globalSearchInput"
                       placeholder="Search groups, subjects, or members..."
                       oninput="handleGlobalSearch(this.value)">
            </div>

            <div class="sw-topbar-actions">
                <button type="button" class="sw-bell-btn" title="Notifications" onclick="showToast('You have 3 active study group discussions today.')">
                    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"></path>
                        <path d="M13.73 21a2 2 0 0 1-3.46 0"></path>
                    </svg>
                    <span class="sw-bell-dot"></span>
                </button>

                <div class="sw-profile-pill" onclick="showToast('Signed in as <%= displayName %> (<%= yearRole %>)')">
                    <div class="sw-avatar-circle">
                        <span><%= displayName.substring(0, 1).toUpperCase() %></span>
                    </div>
                    <div class="sw-profile-info">
                        <span class="sw-profile-name"><%= displayName %></span>
                        <span class="sw-profile-role"><%= yearRole %></span>
                    </div>
                    <svg class="sw-profile-chevron" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <polyline points="6 9 12 15 18 9"></polyline>
                    </svg>
                </div>
            </div>
        </header>

        <!-- ===== CONTAINER ===== -->
        <div class="sg-container">

            <!-- PAGE HEADER BANNER -->
            <div class="sg-header-banner">
                <div class="sg-header-title-box">
                    <h1>Study <span>Groups</span></h1>
                    <p>Learn together. Solve together. Grow together.</p>
                </div>

                <div class="sg-header-right">
                    <!-- Purple 3D Group & Chat Illustration -->
                    <div class="sg-header-illustration" title="Collaborative Study Network">
                        <svg viewBox="0 0 160 60" fill="none">
                            <defs>
                                <linearGradient id="bubbleGrad" x1="0" y1="0" x2="1" y2="1">
                                    <stop offset="0%" stop-color="#818cf8"/>
                                    <stop offset="100%" stop-color="#4f46e5"/>
                                </linearGradient>
                                <linearGradient id="headGrad" x1="0" y1="0" x2="0" y2="1">
                                    <stop offset="0%" stop-color="#7c3aed"/>
                                    <stop offset="100%" stop-color="#4338ca"/>
                                </linearGradient>
                            </defs>
                            <!-- Chat Bubble 1 Left -->
                            <rect x="10" y="8" width="38" height="24" rx="7" fill="url(#bubbleGrad)" opacity="0.85"/>
                            <line x1="18" y1="17" x2="38" y2="17" stroke="#ffffff" stroke-width="2.5" stroke-linecap="round"/>
                            <line x1="18" y1="23" x2="30" y2="23" stroke="#ffffff" stroke-width="2.5" stroke-linecap="round"/>

                            <!-- Avatar Group Cluster -->
                            <circle cx="68" cy="22" r="12" fill="url(#headGrad)" opacity="0.6"/>
                            <path d="M50 56 Q68 34 86 56 Z" fill="url(#headGrad)" opacity="0.6"/>

                            <circle cx="92" cy="16" r="14" fill="url(#headGrad)" opacity="0.9"/>
                            <path d="M72 56 Q92 30 112 56 Z" fill="url(#headGrad)" opacity="0.9"/>

                            <circle cx="116" cy="24" r="11" fill="url(#headGrad)" opacity="0.65"/>
                            <path d="M100 56 Q116 36 132 56 Z" fill="url(#headGrad)" opacity="0.65"/>

                            <!-- Chat Bubble 2 Right -->
                            <rect x="110" y="4" width="36" height="22" rx="6" fill="url(#bubbleGrad)" opacity="0.9"/>
                            <line x1="118" y1="12" x2="136" y2="12" stroke="#ffffff" stroke-width="2" stroke-linecap="round"/>
                            <line x1="118" y1="18" x2="128" y2="18" stroke="#ffffff" stroke-width="2" stroke-linecap="round"/>

                            <!-- User Plus Badge -->
                            <rect x="135" y="24" width="24" height="24" rx="7" fill="#6366f1"/>
                            <path d="M143 36 h8 M147 32 v8" stroke="#ffffff" stroke-width="2.2" stroke-linecap="round"/>
                        </svg>
                    </div>

                    <button class="sg-btn-create-primary" onclick="openCreateGroupModal()">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round">
                            <line x1="12" y1="5" x2="12" y2="19"></line>
                            <line x1="5" y1="12" x2="19" y2="12"></line>
                        </svg>
                        <span>Create Group</span>
                    </button>
                </div>
            </div>

            <!-- ===== TWO-COLUMN MASTER LAYOUT ===== -->
            <div class="sg-main-layout">

                <!-- ===== LEFT COLUMN ===== -->
                <div class="sg-left-col">

                    <!-- 1. CATEGORY PILL TABS -->
                    <div class="sg-tabs-row" id="categoryTabs">
                        <button class="sg-tab-btn active" data-tab="All Groups" onclick="selectTab(this, 'All Groups')">All Groups</button>
                        <button class="sg-tab-btn" data-tab="My Groups" onclick="selectTab(this, 'My Groups')">My Groups</button>
                        <button class="sg-tab-btn" data-tab="CSE" onclick="selectTab(this, 'CSE')">CSE</button>
                        <button class="sg-tab-btn" data-tab="DSA" onclick="selectTab(this, 'DSA')">DSA</button>
                        <button class="sg-tab-btn" data-tab="DBMS" onclick="selectTab(this, 'DBMS')">DBMS</button>
                        <button class="sg-tab-btn" data-tab="Java" onclick="selectTab(this, 'Java')">Java</button>
                        <button class="sg-tab-btn" data-tab="IoT" onclick="selectTab(this, 'IoT')">IoT</button>
                        <button class="sg-tab-btn" data-tab="Others" onclick="selectTab(this, 'Others')">Others</button>
                    </div>

                    <!-- 2. FOUR STATS CARDS -->
                    <div class="sg-stats-grid">
                        <div class="sg-stat-card">
                            <div class="sg-stat-icon-box sg-stat-icon-purple">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                                    <circle cx="9" cy="7" r="4"></circle>
                                    <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                                    <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                                </svg>
                            </div>
                            <div class="sg-stat-details">
                                <span class="sg-stat-num" id="statJoinedGroups"><%= request.getAttribute("joinedGroupsCount") %></span>
                                <span class="sg-stat-label">Joined Groups</span>
                            </div>
                        </div>

                        <div class="sg-stat-card">
                            <div class="sg-stat-icon-box sg-stat-icon-blue">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                                    <circle cx="12" cy="7" r="4"></circle>
                                </svg>
                            </div>
                            <div class="sg-stat-details">
                                <span class="sg-stat-num" id="statTotalMembers"><%= request.getAttribute("totalMembersCount") %></span>
                                <span class="sg-stat-label">Total Members</span>
                            </div>
                        </div>

                        <div class="sg-stat-card">
                            <div class="sg-stat-icon-box sg-stat-icon-green">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path>
                                    <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path>
                                </svg>
                            </div>
                            <div class="sg-stat-details">
                                <span class="sg-stat-num" id="statStudySessions"><%= request.getAttribute("studySessionsCount") %></span>
                                <span class="sg-stat-label">Study Sessions</span>
                            </div>
                        </div>

                        <div class="sg-stat-card">
                            <div class="sg-stat-icon-box sg-stat-icon-orange">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <polyline points="23 6 13.5 15.5 8.5 10.5 1 18"></polyline>
                                    <polyline points="17 6 23 6 23 12"></polyline>
                                </svg>
                            </div>
                            <div class="sg-stat-details">
                                <span class="sg-stat-num" id="statActivePart"><%= request.getAttribute("activeParticipationRate") %>%</span>
                                <span class="sg-stat-label">Active Participation</span>
                            </div>
                        </div>
                    </div>

                    <!-- 3. TOOLBAR: SEARCH & SELECTS -->
                    <div class="sg-toolbar">
                        <div class="sg-subsearch-wrapper">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round">
                                <circle cx="11" cy="11" r="8"></circle>
                                <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                            </svg>
                            <input type="text" class="sg-subsearch-input" id="groupSearchInput"
                                   placeholder="Search study groups..."
                                   oninput="handleGroupSearch(this.value)">
                        </div>

                        <div class="sg-toolbar-filters">
                            <select class="sg-select-box" id="subjectFilter" onchange="triggerFilter()">
                                <option value="All Subjects">All Subjects</option>
                                <option value="DBMS">DBMS</option>
                                <option value="Java">Java</option>
                                <option value="DSA">DSA</option>
                                <option value="IoT">IoT</option>
                                <option value="CSE">CSE</option>
                                <option value="Mathematics">Mathematics</option>
                            </select>

                            <select class="sg-select-box" id="sortFilter" onchange="triggerFilter()">
                                <option value="Latest">Sort by: Latest</option>
                                <option value="Popular">Sort by: Popular</option>
                                <option value="Members">Sort by: Members</option>
                                <option value="Name">Sort by: Name</option>
                            </select>

                            <div class="sg-view-toggles">
                                <button class="sg-view-btn active" id="btnGridView" title="Grid View" onclick="setViewMode('grid')">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <rect x="3" y="3" width="7" height="7"></rect>
                                        <rect x="14" y="3" width="7" height="7"></rect>
                                        <rect x="14" y="14" width="7" height="7"></rect>
                                        <rect x="3" y="14" width="7" height="7"></rect>
                                    </svg>
                                </button>
                                <button class="sg-view-btn" id="btnListView" title="List View" onclick="setViewMode('list')">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <line x1="8" y1="6" x2="21" y2="6"></line>
                                        <line x1="8" y1="12" x2="21" y2="12"></line>
                                        <line x1="8" y1="18" x2="21" y2="18"></line>
                                        <line x1="3" y1="6" x2="3.01" y2="6"></line>
                                        <line x1="3" y1="12" x2="3.01" y2="12"></line>
                                        <line x1="3" y1="18" x2="3.01" y2="18"></line>
                                    </svg>
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- 4. MAIN STUDY GROUP CARDS (3x2 GRID) -->
                    <div class="sg-cards-grid" id="groupsGrid">
                        <c:forEach var="g" items="${groups}">
                            <div class="sg-card" id="group-card-${g.id}" onclick="openGroupDetailsModal(${g.id})">
                                <div class="sg-card-top">
                                    <div class="sg-card-icon" style="background: ${g.iconBg}; color: ${g.iconColor};">
                                        <c:choose>
                                            <c:when test="${g.iconType == 'database'}">
                                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                                    <ellipse cx="12" cy="5" rx="9" ry="3"></ellipse>
                                                    <path d="M21 12c0 1.66-4 3-9 3s-9-1.34-9-3"></path>
                                                    <path d="M3 5v14c0 1.66 4 3 9 3s9-1.34 9-3V5"></path>
                                                </svg>
                                            </c:when>
                                            <c:when test="${g.iconType == 'java'}">
                                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                                    <path d="M18 8h1a4 4 0 0 1 0 8h-1"></path>
                                                    <path d="M2 8h16v9a4 4 0 0 1-4 4H6a4 4 0 0 1-4-4V8z"></path>
                                                    <line x1="6" y1="1" x2="6" y2="4"></line>
                                                    <line x1="10" y1="1" x2="10" y2="4"></line>
                                                    <line x1="14" y1="1" x2="14" y2="4"></line>
                                                </svg>
                                            </c:when>
                                            <c:when test="${g.iconType == 'network'}">
                                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                                    <circle cx="12" cy="5" r="3"></circle>
                                                    <circle cx="6" cy="18" r="3"></circle>
                                                    <circle cx="18" cy="18" r="3"></circle>
                                                    <line x1="12" y1="8" x2="6" y2="15"></line>
                                                    <line x1="12" y1="8" x2="18" y2="15"></line>
                                                </svg>
                                            </c:when>
                                            <c:when test="${g.iconType == 'broadcast'}">
                                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                                    <path d="M4.93 4.93a10 10 0 0 1 14.14 0"></path>
                                                    <path d="M7.76 7.76a6 6 0 0 1 8.48 0"></path>
                                                    <circle cx="12" cy="12" r="2"></circle>
                                                    <path d="M12 14v8"></path>
                                                </svg>
                                            </c:when>
                                            <c:when test="${g.iconType == 'document'}">
                                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                                    <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                                                    <polyline points="14 2 14 8 20 8"></polyline>
                                                    <line x1="16" y1="13" x2="8" y2="13"></line>
                                                    <line x1="16" y1="17" x2="8" y2="17"></line>
                                                </svg>
                                            </c:when>
                                            <c:otherwise>
                                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                                    <path d="M9 18h6"></path>
                                                    <path d="M10 22h4"></path>
                                                    <path d="M12 2a7 7 0 0 0-7 7c0 2.5 1.5 4.5 3 6h8c1.5-1.5 3-3.5 3-6a7 7 0 0 0-7-7z"></path>
                                                </svg>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                    <div class="sg-card-title-col">
                                        <div class="sg-card-name" title="${g.name}">${g.name}</div>
                                        <span class="sg-category-badge ${g.category == 'Exam' ? 'sg-badge-exam' : (g.category == 'Project' ? 'sg-badge-project' : 'sg-badge-academic')}">
                                            ${g.category}
                                        </span>
                                    </div>

                                    <button class="sg-card-menu-btn" title="Options" onclick="event.stopPropagation(); openGroupMenu(${g.id})">
                                        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                            <circle cx="12" cy="12" r="1.5"></circle>
                                            <circle cx="12" cy="5" r="1.5"></circle>
                                            <circle cx="12" cy="19" r="1.5"></circle>
                                        </svg>
                                    </button>
                                </div>

                                <p class="sg-card-desc">${g.description}</p>

                                <div class="sg-card-meta">
                                    <div class="sg-meta-item">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor">
                                            <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                                            <circle cx="9" cy="7" r="4"></circle>
                                        </svg>
                                        <span id="member-count-${g.id}">${g.memberCount} members</span>
                                    </div>
                                    <div class="sg-meta-item">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor">
                                            <path d="M20.59 13.41l-7.17 7.17a2 2 0 0 1-2.83 0L2 12V2h10l8.59 8.59a2 2 0 0 1 0 2.82z"></path>
                                            <line x1="7" y1="7" x2="7.01" y2="7"></line>
                                        </svg>
                                        <span>${g.department}</span>
                                    </div>
                                </div>

                                <div class="sg-card-bottom">
                                    <div class="sg-avatar-stack">
                                        <div class="sg-avatar-mini" title="Arjun"><img src="https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=60&auto=format&fit=crop" alt="avatar"></div>
                                        <div class="sg-avatar-mini" title="Sneha"><img src="https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=60&auto=format&fit=crop" alt="avatar"></div>
                                        <div class="sg-avatar-mini" title="Karthik"><img src="https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=60&auto=format&fit=crop" alt="avatar"></div>
                                        <div class="sg-avatar-mini" title="Priya"><img src="https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=60&auto=format&fit=crop" alt="avatar"></div>
                                        <div class="sg-avatar-plus" id="avatar-plus-${g.id}">+${g.additionalAvatars}</div>
                                    </div>

                                    <div id="join-btn-container-${g.id}">
                                        <c:choose>
                                            <c:when test="${g.joined}">
                                                <button class="sg-btn-joined" onclick="event.stopPropagation(); toggleJoinGroup(${g.id})">
                                                    <svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3">
                                                        <polyline points="20 6 9 17 4 12"></polyline>
                                                    </svg>
                                                    <span>Joined</span>
                                                </button>
                                            </c:when>
                                            <c:otherwise>
                                                <button class="sg-btn-join" onclick="event.stopPropagation(); toggleJoinGroup(${g.id})">Join</button>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>

                    <!-- 5. RECOMMENDED GROUPS -->
                    <div class="sg-recommended-box">
                        <div class="sg-sec-header">
                            <div class="sg-sec-title">
                                <svg viewBox="0 0 24 24" fill="currentColor">
                                    <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon>
                                </svg>
                                <span>Recommended Groups</span>
                            </div>
                            <span class="sg-sec-link" onclick="showToast('Browsing all 14 curated recommended student circles.')">View All &rarr;</span>
                        </div>

                        <div class="sg-recommended-row">
                            <c:forEach var="rec" items="${recommended}">
                                <div class="sg-rec-card" id="rec-card-${rec.id}">
                                    <div class="sg-rec-left">
                                        <div class="sg-rec-icon" style="background: ${rec.iconBg}; color: ${rec.iconColor};">
                                            <c:choose>
                                                <c:when test="${rec.iconSymbol == 'sigma'}">&Sigma;</c:when>
                                                <c:when test="${rec.iconSymbol == 'grad'}">
                                                    <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                        <path d="M22 10v6M2 10l10-5 10 5-10 5z"></path>
                                                        <path d="M6 12v5c3 3 9 3 12 0v-5"></path>
                                                    </svg>
                                                </c:when>
                                                <c:when test="${rec.iconSymbol == 'code'}">&lt;/&gt;</c:when>
                                                <c:otherwise>
                                                    <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                        <line x1="18" y1="20" x2="18" y2="10"></line>
                                                        <line x1="12" y1="20" x2="12" y2="4"></line>
                                                        <line x1="6" y1="20" x2="6" y2="14"></line>
                                                    </svg>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="sg-rec-info">
                                            <span class="sg-rec-name" title="${rec.name}">${rec.name}</span>
                                            <span class="sg-rec-members" id="rec-members-${rec.id}">${rec.membersText}</span>
                                        </div>
                                    </div>
                                    <button class="sg-rec-btn ${rec.joined ? 'joined' : ''}"
                                            id="rec-btn-${rec.id}"
                                            onclick="toggleJoinRecommended(${rec.id})">
                                        ${rec.joined ? 'Joined' : 'Join'}
                                    </button>
                                </div>
                            </c:forEach>
                        </div>
                    </div>

                </div>

                <!-- ===== RIGHT COLUMN (WIDGETS) ===== -->
                <div class="sg-right-col">

                    <!-- WIDGET 1: UPCOMING STUDY SESSIONS -->
                    <div class="sg-widget">
                        <div class="sg-widget-header">
                            <div class="sg-widget-title">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                    <line x1="16" y1="2" x2="16" y2="6"></line>
                                    <line x1="8" y1="2" x2="8" y2="6"></line>
                                    <line x1="3" y1="10" x2="21" y2="10"></line>
                                </svg>
                                <span>Upcoming Study Sessions</span>
                            </div>
                            <span class="sg-sec-link" onclick="openScheduleSessionModal()">View All &rarr;</span>
                        </div>

                        <div class="sg-sessions-list">
                            <c:forEach var="s" items="${sessions}">
                                <div class="sg-session-item">
                                    <div class="sg-session-left">
                                        <div class="sg-date-badge">
                                            <span class="sg-date-month">${s.month}</span>
                                            <span class="sg-date-day">${s.day}</span>
                                        </div>
                                        <div class="sg-session-info">
                                            <span class="sg-session-title" title="${s.title}">${s.title}</span>
                                            <span class="sg-session-time">${s.timeRange}</span>
                                        </div>
                                    </div>
                                    <button class="sg-session-btn ${s.joined ? 'joined' : ''}"
                                            id="session-btn-${s.id}"
                                            onclick="toggleJoinSession(${s.id})">
                                        ${s.joined ? 'Joined' : 'Join'}
                                    </button>
                                </div>
                            </c:forEach>
                        </div>
                    </div>

                    <!-- WIDGET 2: RECENT ACTIVITY -->
                    <div class="sg-widget">
                        <div class="sg-widget-header">
                            <div class="sg-widget-title">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon>
                                </svg>
                                <span>Recent Activity</span>
                            </div>
                            <span class="sg-sec-link" onclick="showToast('Displaying full live study group activity feed.')">View All &rarr;</span>
                        </div>

                        <div class="sg-activity-list" id="activityFeed">
                            <c:forEach var="act" items="${activities}">
                                <div class="sg-activity-item">
                                    <div class="sg-activity-icon" style="background: ${act.iconBg}; color: ${act.iconColor};">
                                        <c:choose>
                                            <c:when test="${act.type == 'join'}">
                                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                    <path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                                                    <circle cx="8.5" cy="7" r="4"></circle>
                                                    <line x1="20" y1="8" x2="20" y2="14"></line>
                                                    <line x1="23" y1="11" x2="17" y2="11"></line>
                                                </svg>
                                            </c:when>
                                            <c:when test="${act.type == 'file'}">
                                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                    <path d="M13 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V9z"></path>
                                                    <polyline points="13 2 13 9 20 9"></polyline>
                                                </svg>
                                            </c:when>
                                            <c:when test="${act.type == 'chat'}">
                                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                    <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"></path>
                                                </svg>
                                            </c:when>
                                            <c:otherwise>
                                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                    <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                                    <line x1="16" y1="2" x2="16" y2="6"></line>
                                                    <line x1="8" y1="2" x2="8" y2="6"></line>
                                                    <line x1="3" y1="10" x2="21" y2="10"></line>
                                                </svg>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="sg-activity-content">
                                        <span class="sg-activity-text">${act.text}</span>
                                        <span class="sg-activity-time">${act.timeAgo}</span>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>

                    <!-- WIDGET 3: CREATE YOUR OWN GROUP -->
                    <div class="sg-widget-create">
                        <div class="sg-widget-create-header">
                            <div class="sg-widget-create-icon">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                                    <circle cx="9" cy="7" r="4"></circle>
                                    <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                                    <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                                </svg>
                            </div>
                            <h3>Create Your Own Group</h3>
                        </div>
                        <p>Start a new study group and invite your friends.</p>
                        <button class="sg-btn-create-block" onclick="openCreateGroupModal()">
                            + Create Group
                        </button>
                    </div>

                </div>

            </div>

        </div>

    </main>

</div>

<!-- ===== MODAL: CREATE STUDY GROUP ===== -->
<div class="sg-modal-overlay" id="createGroupModal">
    <div class="sg-modal">
        <div class="sg-modal-header">
            <h3 class="sg-modal-title">Create New Study Group</h3>
            <button class="sg-modal-close" onclick="closeCreateGroupModal()">&times;</button>
        </div>
        <form id="createGroupForm" onsubmit="handleCreateGroupSubmit(event)">
            <div class="sg-form-group">
                <label class="sg-form-label">Group Name *</label>
                <input type="text" class="sg-form-input" id="newGroupName" placeholder="e.g. Operating Systems Lab Squad" required>
            </div>

            <div class="sg-form-row">
                <div class="sg-form-group">
                    <label class="sg-form-label">Category</label>
                    <select class="sg-form-select" id="newGroupCategory">
                        <option value="Academic">Academic</option>
                        <option value="Exam">Exam Prep</option>
                        <option value="Project">Project Collaboration</option>
                        <option value="Others">Others</option>
                    </select>
                </div>
                <div class="sg-form-group">
                    <label class="sg-form-label">Subject</label>
                    <select class="sg-form-select" id="newGroupSubject">
                        <option value="DBMS">DBMS</option>
                        <option value="Java">Java</option>
                        <option value="DSA">DSA</option>
                        <option value="IoT">IoT</option>
                        <option value="CSE">CSE</option>
                        <option value="Mathematics">Mathematics</option>
                        <option value="Others">Others</option>
                    </select>
                </div>
            </div>

            <div class="sg-form-group">
                <label class="sg-form-label">Description</label>
                <textarea class="sg-form-textarea" id="newGroupDesc" rows="3" placeholder="Explain the focus, goals, or meeting frequency for this group..."></textarea>
            </div>

            <div class="sg-form-row">
                <div class="sg-form-group">
                    <label class="sg-form-label">Department</label>
                    <input type="text" class="sg-form-input" id="newGroupDept" value="CSE">
                </div>
                <div class="sg-form-group">
                    <label class="sg-form-label">Privacy</label>
                    <select class="sg-form-select" id="newGroupPrivacy">
                        <option value="Public">Public (Any Student Can Join)</option>
                        <option value="Invite">Invite Only</option>
                    </select>
                </div>
            </div>

            <div class="sg-form-actions">
                <button type="button" class="sg-btn-secondary" onclick="closeCreateGroupModal()">Cancel</button>
                <button type="submit" class="sg-btn-primary">+ Create Group</button>
            </div>
        </form>
    </div>
</div>

<!-- ===== MODAL: GROUP DETAILS & CHAT ===== -->
<div class="sg-modal-overlay" id="groupDetailsModal">
    <div class="sg-modal" style="width: 560px;">
        <div class="sg-modal-header">
            <div>
                <h3 class="sg-modal-title" id="modalGroupName">DBMS Core Group</h3>
                <span style="font-size: 0.74rem; color: var(--text-muted);" id="modalGroupMeta">Academic &bull; CSE &bull; 12 members</span>
            </div>
            <button class="sg-modal-close" onclick="closeGroupDetailsModal()">&times;</button>
        </div>

        <p style="font-size: 0.81rem; color: #cbd5e1; margin-bottom: 14px;" id="modalGroupDesc">
            For DBMS notes, doubt solving and previous year questions.
        </p>

        <h4 style="font-size: 0.82rem; font-weight: 700; color: #ffffff; margin-bottom: 8px;">Peer Discussion Stream</h4>
        <div class="sg-chat-window" id="groupChatWindow">
            <div class="sg-chat-bubble">Arjun: Hey everyone, who has the notes for B-Trees and B+ Trees?</div>
            <div class="sg-chat-bubble">Sneha: I uploaded the handwritten PDF in unit 3 folder!</div>
            <div class="sg-chat-bubble me">Harish: Thanks! Working on the SQL transaction assignment now.</div>
        </div>

        <div class="sg-chat-input-row">
            <input type="text" class="sg-form-input" id="groupChatMessageInput" placeholder="Share a doubt, note, or message..." onkeydown="if(event.key==='Enter') sendGroupMessage()">
            <button type="button" class="sg-btn-primary" onclick="sendGroupMessage()">Send</button>
        </div>

        <div class="sg-form-actions" style="margin-top: 16px;">
            <button type="button" class="sg-btn-secondary" onclick="copyInviteLink()">Copy Invite Link</button>
            <button type="button" class="sg-btn-primary" id="modalToggleJoinBtn" onclick="modalToggleJoin()">Join Group</button>
        </div>
    </div>
</div>

<!-- ===== MODAL: SCHEDULE SESSION ===== -->
<div class="sg-modal-overlay" id="scheduleSessionModal">
    <div class="sg-modal">
        <div class="sg-modal-header">
            <h3 class="sg-modal-title">Schedule Study Session</h3>
            <button class="sg-modal-close" onclick="closeScheduleSessionModal()">&times;</button>
        </div>
        <form onsubmit="handleScheduleSession(event)">
            <div class="sg-form-group">
                <label class="sg-form-label">Session Title *</label>
                <input type="text" class="sg-form-input" id="sessionTitle" placeholder="e.g. CAT 1 Mock Exam Sprint" required>
            </div>
            <div class="sg-form-row">
                <div class="sg-form-group">
                    <label class="sg-form-label">Subject</label>
                    <input type="text" class="sg-form-input" id="sessionSubject" value="DBMS">
                </div>
                <div class="sg-form-group">
                    <label class="sg-form-label">Day & Month</label>
                    <input type="text" class="sg-form-input" id="sessionDate" value="25 OCT">
                </div>
            </div>
            <div class="sg-form-group">
                <label class="sg-form-label">Time Range</label>
                <input type="text" class="sg-form-input" id="sessionTimeRange" value="06:00 PM - 07:30 PM">
            </div>
            <div class="sg-form-actions">
                <button type="button" class="sg-btn-secondary" onclick="closeScheduleSessionModal()">Cancel</button>
                <button type="submit" class="sg-btn-primary">Schedule Session</button>
            </div>
        </form>
    </div>
</div>

<!-- ===== TOAST ===== -->
<div class="sg-toast" id="toast">
    <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="#a78bfa" stroke-width="2.5">
        <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
        <polyline points="22 4 12 14.01 9 11.01"></polyline>
    </svg>
    <span id="toastMsg">Action completed successfully</span>
</div>

<!-- ===== JAVASCRIPT LOGIC ===== -->
<script>
    const CONTEXT_PATH = "${pageContext.request.contextPath}";
    let currentTab = "All Groups";
    let activeGroupIdForModal = 1;

    // Toast Notification helper
    function showToast(msg) {
        const toast = document.getElementById('toast');
        const text = document.getElementById('toastMsg');
        text.innerText = msg;
        toast.classList.add('show');
        setTimeout(() => toast.classList.remove('show'), 3200);
    }

    // Tab Selection
    function selectTab(btn, tabName) {
        document.querySelectorAll('#categoryTabs .sg-tab-btn').forEach(b => b.classList.remove('active'));
        btn.classList.add('active');
        currentTab = tabName;
        triggerFilter();
    }

    // Grid vs List view toggle
    function setViewMode(mode) {
        const grid = document.getElementById('groupsGrid');
        const btnGrid = document.getElementById('btnGridView');
        const btnList = document.getElementById('btnListView');

        if (mode === 'list') {
            grid.classList.add('list-view');
            btnList.classList.add('active');
            btnGrid.classList.remove('active');
        } else {
            grid.classList.remove('list-view');
            btnGrid.classList.add('active');
            btnList.classList.remove('active');
        }
    }

    // Search filters
    function handleGlobalSearch(val) {
        document.getElementById('groupSearchInput').value = val;
        triggerFilter();
    }

    function handleGroupSearch(val) {
        triggerFilter();
    }

    // Server AJAX Filter Request
    function triggerFilter() {
        const search = document.getElementById('groupSearchInput').value;
        const subject = document.getElementById('subjectFilter').value;
        const sort = document.getElementById('sortFilter').value;

        const params = new URLSearchParams();
        params.append('action', 'filter');
        params.append('tab', currentTab);
        params.append('search', search);
        params.append('subject', subject);
        params.append('sort', sort);

        fetch(CONTEXT_PATH + '/study-groups', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: params.toString()
        })
        .then(res => res.json())
        .then(data => {
            if (data.success) {
                renderGroups(data.groups);
                if (data.joinedCount !== undefined) {
                    document.getElementById('statJoinedGroups').innerText = data.joinedCount;
                    document.getElementById('statTotalMembers').innerText = data.totalMembers;
                }
            }
        })
        .catch(err => {
            console.error('Filter error:', err);
            clientSideFilter(currentTab, search, subject, sort);
        });
    }

    // Client-side fallback filter
    function clientSideFilter(tab, search, subject, sort) {
        const cards = document.querySelectorAll('#groupsGrid .sg-card');
        const q = (search || '').toLowerCase().trim();

        cards.forEach(card => {
            const text = card.innerText.toLowerCase();
            let matchesTab = true;
            if (tab === 'My Groups') {
                matchesTab = card.querySelector('.sg-btn-joined') !== null;
            } else if (tab !== 'All Groups' && tab !== 'Others') {
                matchesTab = text.includes(tab.toLowerCase());
            }

            let matchesSub = true;
            if (subject !== 'All Subjects') {
                matchesSub = text.includes(subject.toLowerCase());
            }

            let matchesQuery = !q || text.includes(q);

            if (matchesTab && matchesSub && matchesQuery) {
                card.style.display = 'flex';
            } else {
                card.style.display = 'none';
            }
        });
    }

    // Render group cards dynamically
    function renderGroups(groups) {
        const container = document.getElementById('groupsGrid');
        if (!groups || groups.length === 0) {
            container.innerHTML = `
                <div style="grid-column: 1 / -1; padding: 36px; text-align: center; color: var(--text-muted); background: var(--bg-card); border: 1px dashed var(--border-card); border-radius: 14px;">
                    <svg width="36" height="36" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" style="margin-bottom: 10px; color: #a78bfa;">
                        <circle cx="11" cy="11" r="8"></circle>
                        <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                    </svg>
                    <h4 style="color: #fff; font-size: 0.95rem; margin-bottom: 4px;">No study groups found</h4>
                    <p style="font-size: 0.8rem;">Try adjusting your filters or create a new study group!</p>
                </div>
            `;
            return;
        }

        container.innerHTML = groups.map(g => {
            const badgeClass = g.category === 'Exam' ? 'sg-badge-exam' : (g.category === 'Project' ? 'sg-badge-project' : 'sg-badge-academic');
            let iconSvg = '';
            if (g.iconType === 'database') {
                iconSvg = `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><ellipse cx="12" cy="5" rx="9" ry="3"></ellipse><path d="M21 12c0 1.66-4 3-9 3s-9-1.34-9-3"></path><path d="M3 5v14c0 1.66 4 3 9 3s9-1.34 9-3V5"></path></svg>`;
            } else if (g.iconType === 'java') {
                iconSvg = `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M18 8h1a4 4 0 0 1 0 8h-1"></path><path d="M2 8h16v9a4 4 0 0 1-4 4H6a4 4 0 0 1-4-4V8z"></path><line x1="6" y1="1" x2="6" y2="4"></line><line x1="10" y1="1" x2="10" y2="4"></line><line x1="14" y1="1" x2="14" y2="4"></line></svg>`;
            } else if (g.iconType === 'network') {
                iconSvg = `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="5" r="3"></circle><circle cx="6" cy="18" r="3"></circle><circle cx="18" cy="18" r="3"></circle><line x1="12" y1="8" x2="6" y2="15"></line><line x1="12" y1="8" x2="18" y2="15"></line></svg>`;
            } else if (g.iconType === 'broadcast') {
                iconSvg = `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M4.93 4.93a10 10 0 0 1 14.14 0"></path><path d="M7.76 7.76a6 6 0 0 1 8.48 0"></path><circle cx="12" cy="12" r="2"></circle><path d="M12 14v8"></path></svg>`;
            } else if (g.iconType === 'document') {
                iconSvg = `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line></svg>`;
            } else {
                iconSvg = `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M9 18h6"></path><path d="M10 22h4"></path><path d="M12 2a7 7 0 0 0-7 7c0 2.5 1.5 4.5 3 6h8c1.5-1.5 3-3.5 3-6a7 7 0 0 0-7-7z"></path></svg>`;
            }

            const btnHtml = g.joined ? `
                <button class="sg-btn-joined" onclick="event.stopPropagation(); toggleJoinGroup(${g.id})">
                    <svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3">
                        <polyline points="20 6 9 17 4 12"></polyline>
                    </svg>
                    <span>Joined</span>
                </button>
            ` : `
                <button class="sg-btn-join" onclick="event.stopPropagation(); toggleJoinGroup(${g.id})">Join</button>
            `;

            return `
                <div class="sg-card" id="group-card-${g.id}" onclick="openGroupDetailsModal(${g.id})">
                    <div class="sg-card-top">
                        <div class="sg-card-icon" style="background: ${g.iconBg}; color: ${g.iconColor};">
                            ${iconSvg}
                        </div>
                        <div class="sg-card-title-col">
                            <div class="sg-card-name" title="${g.name}">${g.name}</div>
                            <span class="sg-category-badge ${badgeClass}">${g.category}</span>
                        </div>
                        <button class="sg-card-menu-btn" title="Options" onclick="event.stopPropagation(); openGroupMenu(${g.id})">
                            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                <circle cx="12" cy="12" r="1.5"></circle>
                                <circle cx="12" cy="5" r="1.5"></circle>
                                <circle cx="12" cy="19" r="1.5"></circle>
                            </svg>
                        </button>
                    </div>

                    <p class="sg-card-desc">${g.description}</p>

                    <div class="sg-card-meta">
                        <div class="sg-meta-item">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor">
                                <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                                <circle cx="9" cy="7" r="4"></circle>
                            </svg>
                            <span id="member-count-${g.id}">${g.memberCount} members</span>
                        </div>
                        <div class="sg-meta-item">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor">
                                <path d="M20.59 13.41l-7.17 7.17a2 2 0 0 1-2.83 0L2 12V2h10l8.59 8.59a2 2 0 0 1 0 2.82z"></path>
                                <line x1="7" y1="7" x2="7.01" y2="7"></line>
                            </svg>
                            <span>${g.department}</span>
                        </div>
                    </div>

                    <div class="sg-card-bottom">
                        <div class="sg-avatar-stack">
                            <div class="sg-avatar-mini" title="Member"><img src="https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=60&auto=format&fit=crop" alt="avatar"></div>
                            <div class="sg-avatar-mini" title="Member"><img src="https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=60&auto=format&fit=crop" alt="avatar"></div>
                            <div class="sg-avatar-mini" title="Member"><img src="https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=60&auto=format&fit=crop" alt="avatar"></div>
                            <div class="sg-avatar-mini" title="Member"><img src="https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=60&auto=format&fit=crop" alt="avatar"></div>
                            <div class="sg-avatar-plus" id="avatar-plus-${g.id}">+${g.additionalAvatars}</div>
                        </div>

                        <div id="join-btn-container-${g.id}">
                            ${btnHtml}
                        </div>
                    </div>
                </div>
            `;
        }).join('');
    }

    // Toggle Join/Leave on Group Card
    function toggleJoinGroup(groupId) {
        const params = new URLSearchParams();
        params.append('action', 'toggleJoinGroup');
        params.append('id', groupId);

        fetch(CONTEXT_PATH + '/study-groups', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: params.toString()
        })
        .then(res => res.json())
        .then(data => {
            if (data.success) {
                const btnContainer = document.getElementById('join-btn-container-' + groupId);
                const memberCountEl = document.getElementById('member-count-' + groupId);
                const plusEl = document.getElementById('avatar-plus-' + groupId);

                if (data.joined) {
                    btnContainer.innerHTML = `
                        <button class="sg-btn-joined" onclick="event.stopPropagation(); toggleJoinGroup(${groupId})">
                            <svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3">
                                <polyline points="20 6 9 17 4 12"></polyline>
                            </svg>
                            <span>Joined</span>
                        </button>
                    `;
                    showToast('Joined group successfully!');
                } else {
                    btnContainer.innerHTML = `
                        <button class="sg-btn-join" onclick="event.stopPropagation(); toggleJoinGroup(${groupId})">Join</button>
                    `;
                    showToast('Left group.');
                }

                if (memberCountEl) memberCountEl.innerText = data.memberCount + ' members';
                if (plusEl) plusEl.innerText = '+' + data.additionalAvatars;
                if (data.joinedCount) document.getElementById('statJoinedGroups').innerText = data.joinedCount;
                if (data.totalMembers) document.getElementById('statTotalMembers').innerText = data.totalMembers;

                addActivityFeedItem('You ' + (data.joined ? 'joined' : 'left') + ' the group', 'Just now');
            }
        })
        .catch(err => {
            console.error('Error toggling group:', err);
            showToast('Updated group status!');
        });
    }

    // Toggle Join on Recommended Group
    function toggleJoinRecommended(id) {
        const params = new URLSearchParams();
        params.append('action', 'toggleJoinRecommended');
        params.append('id', id);

        fetch(CONTEXT_PATH + '/study-groups', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: params.toString()
        })
        .then(res => res.json())
        .then(data => {
            if (data.success) {
                const btn = document.getElementById('rec-btn-' + id);
                const count = document.getElementById('rec-members-' + id);
                if (data.joined) {
                    btn.classList.add('joined');
                    btn.innerText = 'Joined';
                    showToast('Joined recommended circle!');
                } else {
                    btn.classList.remove('joined');
                    btn.innerText = 'Join';
                    showToast('Left recommended circle.');
                }
                if (count && data.membersText) count.innerText = data.membersText;
                if (data.joinedCount) document.getElementById('statJoinedGroups').innerText = data.joinedCount;
                if (data.totalMembers) document.getElementById('statTotalMembers').innerText = data.totalMembers;
            }
        })
        .catch(() => showToast('Group status updated!'));
    }

    // Toggle Join on Upcoming Session
    function toggleJoinSession(id) {
        const params = new URLSearchParams();
        params.append('action', 'toggleJoinSession');
        params.append('id', id);

        fetch(CONTEXT_PATH + '/study-groups', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: params.toString()
        })
        .then(res => res.json())
        .then(data => {
            if (data.success) {
                const btn = document.getElementById('session-btn-' + id);
                if (data.joined) {
                    btn.classList.add('joined');
                    btn.innerText = 'Joined';
                    showToast('RSVP confirmed! Added to your SlotWise calendar.');
                } else {
                    btn.classList.remove('joined');
                    btn.innerText = 'Join';
                    showToast('Removed RSVP.');
                }
                if (data.sessionsCount) document.getElementById('statStudySessions').innerText = data.sessionsCount;
            }
        })
        .catch(() => showToast('Session RSVP updated!'));
    }

    // Add activity feed item to UI
    function addActivityFeedItem(text, time) {
        const feed = document.getElementById('activityFeed');
        if (!feed) return;
        const item = document.createElement('div');
        item.className = 'sg-activity-item';
        item.innerHTML = `
            <div class="sg-activity-icon" style="background: rgba(59, 130, 246, 0.2); color: #60a5fa;">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                    <circle cx="8.5" cy="7" r="4"></circle>
                </svg>
            </div>
            <div class="sg-activity-content">
                <span class="sg-activity-text">${text}</span>
                <span class="sg-activity-time">${time}</span>
            </div>
        `;
        feed.insertBefore(item, feed.firstChild);
    }

    // Modal controls: Create Group
    function openCreateGroupModal() {
        document.getElementById('createGroupModal').classList.add('open');
    }

    function closeCreateGroupModal() {
        document.getElementById('createGroupModal').classList.remove('open');
    }

    function handleCreateGroupSubmit(e) {
        e.preventDefault();
        const name = document.getElementById('newGroupName').value;
        const category = document.getElementById('newGroupCategory').value;
        const subject = document.getElementById('newGroupSubject').value;
        const desc = document.getElementById('newGroupDesc').value;
        const dept = document.getElementById('newGroupDept').value;

        const params = new URLSearchParams();
        params.append('action', 'createGroup');
        params.append('name', name);
        params.append('category', category);
        params.append('subject', subject);
        params.append('description', desc);
        params.append('department', dept);

        fetch(CONTEXT_PATH + '/study-groups', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: params.toString()
        })
        .then(res => res.json())
        .then(data => {
            if (data.success) {
                closeCreateGroupModal();
                document.getElementById('createGroupForm').reset();
                showToast('Study Group "' + name + '" created successfully!');
                triggerFilter();
            }
        })
        .catch(err => {
            closeCreateGroupModal();
            showToast('Study Group created!');
        });
    }

    // Modal controls: Group Details & Chat
    function openGroupDetailsModal(groupId) {
        activeGroupIdForModal = groupId;
        const card = document.getElementById('group-card-' + groupId);
        if (card) {
            const name = card.querySelector('.sg-card-name').innerText;
            const desc = card.querySelector('.sg-card-desc').innerText;
            const meta = card.querySelector('.sg-card-meta').innerText;
            document.getElementById('modalGroupName').innerText = name;
            document.getElementById('modalGroupDesc').innerText = desc;
            document.getElementById('modalGroupMeta').innerText = meta;
        }
        document.getElementById('groupDetailsModal').classList.add('open');
    }

    function closeGroupDetailsModal() {
        document.getElementById('groupDetailsModal').classList.remove('open');
    }

    function sendGroupMessage() {
        const input = document.getElementById('groupChatMessageInput');
        const msg = input.value.trim();
        if (!msg) return;

        const chatWin = document.getElementById('groupChatWindow');
        const bubble = document.createElement('div');
        bubble.className = 'sg-chat-bubble me';
        bubble.innerText = 'Harish: ' + msg;
        chatWin.appendChild(bubble);
        chatWin.scrollTop = chatWin.scrollHeight;

        input.value = '';

        const params = new URLSearchParams();
        params.append('action', 'postChatMessage');
        params.append('groupId', activeGroupIdForModal);
        params.append('message', msg);
        fetch(CONTEXT_PATH + '/study-groups', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: params.toString()
        });
    }

    function modalToggleJoin() {
        toggleJoinGroup(activeGroupIdForModal);
        closeGroupDetailsModal();
    }

    function copyInviteLink() {
        const link = window.location.origin + CONTEXT_PATH + '/study-groups.jsp?join=' + activeGroupIdForModal;
        navigator.clipboard.writeText(link).then(() => {
            showToast('Invite link copied to clipboard!');
        }).catch(() => {
            showToast('Invite link: ' + link);
        });
    }

    function openGroupMenu(id) {
        openGroupDetailsModal(id);
    }

    // Modal controls: Schedule Session
    function openScheduleSessionModal() {
        document.getElementById('scheduleSessionModal').classList.add('open');
    }

    function closeScheduleSessionModal() {
        document.getElementById('scheduleSessionModal').classList.remove('open');
    }

    function handleScheduleSession(e) {
        e.preventDefault();
        const title = document.getElementById('sessionTitle').value;
        const subject = document.getElementById('sessionSubject').value;
        const date = document.getElementById('sessionDate').value;
        const timeRange = document.getElementById('sessionTimeRange').value;

        const parts = date.split(' ');
        const day = parts[0] || '25';
        const month = parts[1] || 'OCT';

        const params = new URLSearchParams();
        params.append('action', 'scheduleSession');
        params.append('title', title);
        params.append('subject', subject);
        params.append('day', day);
        params.append('month', month);
        params.append('timeRange', timeRange);

        fetch(CONTEXT_PATH + '/study-groups', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: params.toString()
        })
        .then(res => res.json())
        .then(data => {
            closeScheduleSessionModal();
            showToast('Study session "' + title + '" scheduled!');
            if (data.sessionsCount) document.getElementById('statStudySessions').innerText = data.sessionsCount;
            setTimeout(() => window.location.reload(), 1000);
        })
        .catch(() => {
            closeScheduleSessionModal();
            showToast('Study session scheduled!');
        });
    }
</script>

</body>
</html>
