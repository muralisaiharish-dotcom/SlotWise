<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
    // Ensure default demo values if session is fresh or attributes not set
    if (session.getAttribute("studentName") == null) {
        session.setAttribute("studentName", "Harish M");
    }
    if (session.getAttribute("yearOfStudy") == null) {
        session.setAttribute("yearOfStudy", "CSE - 2nd Year");
    }
    String displayName = (String) request.getAttribute("studentName");
    if (displayName == null || displayName.trim().isEmpty()) {
        displayName = (String) session.getAttribute("studentName");
    }
    if (displayName == null || displayName.trim().isEmpty()) {
        displayName = "Harish";
    } else if (displayName.contains(" ")) {
        displayName = displayName.split(" ")[0]; // Just first name for greeting "Good Morning, Harish!"
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard &mdash; SlotWise</title>
    <meta name="description" content="SlotWise Academic Dashboard & Task Planning Overview">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        :root {
            --db-bg-app: #080c18;
            --db-bg-sidebar: #090e1d;
            --db-bg-card: #0d1326;
            --db-bg-card-hover: #121933;
            --db-bg-card-inner: #11182e;
            --db-border: rgba(255, 255, 255, 0.07);
            --db-border-hover: rgba(255, 255, 255, 0.15);
            --db-purple: #7952f5;
            --db-purple-glow: rgba(121, 82, 245, 0.35);
            --db-purple-light: #9d7bfc;
            --db-blue: #38bdf8;
            --db-green: #10b981;
            --db-red: #f43f5e;
            --db-orange: #f97316;
            --db-yellow: #f59e0b;
            --db-text-white: #ffffff;
            --db-text-primary: #f1f5f9;
            --db-text-muted: #8492a6;
            --db-text-dim: #4d5b75;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            background-color: var(--db-bg-app) !important;
            color: var(--db-text-primary);
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            margin: 0;
            padding: 0;
            overflow-x: hidden;
            -webkit-font-smoothing: antialiased;
        }

        .db-layout {
            display: flex;
            min-height: 100vh;
            background-color: var(--db-bg-app);
            position: relative;
        }

        /* Ambient background glow */
        .db-layout::before {
            content: '';
            position: fixed;
            bottom: -150px;
            left: -150px;
            width: 500px;
            height: 500px;
            background: radial-gradient(circle, rgba(121, 82, 245, 0.12) 0%, rgba(56, 189, 248, 0.05) 50%, transparent 70%);
            pointer-events: none;
            z-index: 0;
        }

        /* ------------------ SIDEBAR (ALWAYS VISIBLE, NO HIDING) ------------------ */
        .db-sidebar {
            width: 240px;
            min-width: 240px;
            background-color: var(--db-bg-sidebar);
            border-right: 1px solid var(--db-border);
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            padding: 24px 16px 20px;
            box-sizing: border-box;
            position: sticky;
            top: 0;
            height: 100vh;
            z-index: 20;
            flex-shrink: 0;
        }

        .db-logo {
            display: flex;
            align-items: center;
            gap: 12px;
            text-decoration: none;
            padding: 0 8px 24px;
        }

        .db-logo-icon {
            width: 36px;
            height: 36px;
            background: linear-gradient(135deg, #7952f5 0%, #a855f7 100%);
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #ffffff;
            box-shadow: 0 4px 14px var(--db-purple-glow);
        }

        .db-logo-text {
            font-size: 1.28rem;
            font-weight: 700;
            color: #ffffff;
            letter-spacing: -0.02em;
        }
        .db-logo-text span {
            color: var(--db-purple-light);
        }

        .db-nav {
            display: flex;
            flex-direction: column;
            gap: 6px;
            flex: 1;
        }

        .db-nav-item {
            display: flex;
            align-items: center;
            gap: 14px;
            padding: 11px 14px;
            border-radius: 10px;
            color: var(--db-text-muted);
            text-decoration: none;
            font-size: 0.88rem;
            font-weight: 500;
            transition: all 0.2s ease;
        }

        .db-nav-item:hover {
            color: var(--db-text-white);
            background-color: rgba(255, 255, 255, 0.04);
        }

        .db-nav-item.active {
            background: linear-gradient(135deg, #4f46e5 0%, #6366f1 100%);
            color: #ffffff;
            font-weight: 600;
            box-shadow: 0 4px 18px rgba(79, 70, 229, 0.4);
        }

        .db-nav-item svg {
            width: 18px;
            height: 18px;
            stroke-width: 1.9;
            flex-shrink: 0;
        }

        .db-sidebar-bottom {
            padding-top: 16px;
            border-top: 1px solid var(--db-border);
        }

        .db-nav-item.logout {
            color: #94a3b8;
        }
        .db-nav-item.logout:hover {
            color: #ef4444;
            background-color: rgba(239, 68, 68, 0.08);
        }

        /* ------------------ MAIN CONTENT ------------------ */
        .db-main {
            flex: 1;
            display: flex;
            flex-direction: column;
            min-width: 0;
            background-color: var(--db-bg-app);
            position: relative;
            z-index: 1;
        }

        /* Top Bar */
        .db-topbar {
            height: 70px;
            padding: 0 32px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 20px;
            border-bottom: 1px solid var(--db-border);
            background-color: var(--db-bg-app);
            position: sticky;
            top: 0;
            z-index: 15;
        }

        .db-search-box {
            position: relative;
            width: 380px;
            max-width: 100%;
        }

        .db-search-box input {
            width: 100%;
            height: 40px;
            background-color: rgba(255, 255, 255, 0.035);
            border: 1px solid var(--db-border);
            border-radius: 999px;
            padding: 0 65px 0 42px;
            color: var(--db-text-primary);
            font-size: 0.85rem;
            outline: none;
            box-sizing: border-box;
            transition: all 0.2s ease;
        }

        .db-search-box input:focus {
            border-color: #6366f1;
            background-color: rgba(255, 255, 255, 0.06);
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.2);
        }

        .db-search-box svg {
            position: absolute;
            left: 14px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--db-text-dim);
            width: 16px;
            height: 16px;
        }

        .db-search-kbd {
            position: absolute;
            right: 14px;
            top: 50%;
            transform: translateY(-50%);
            font-family: 'JetBrains Mono', monospace;
            font-size: 0.72rem;
            background: rgba(255, 255, 255, 0.06);
            color: var(--db-text-muted);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 6px;
            padding: 2px 7px;
            pointer-events: none;
        }

        .db-topbar-right {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .db-notif-btn {
            position: relative;
            background: rgba(255, 255, 255, 0.035);
            border: 1px solid var(--db-border);
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--db-text-muted);
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .db-notif-btn:hover {
            color: #ffffff;
            background-color: rgba(255, 255, 255, 0.07);
        }

        .db-notif-dot {
            position: absolute;
            top: 9px;
            right: 10px;
            width: 8px;
            height: 8px;
            background-color: #f43f5e;
            border-radius: 50%;
            border: 2px solid var(--db-bg-app);
        }

        .db-profile-badge {
            display: flex;
            align-items: center;
            gap: 12px;
            cursor: pointer;
            text-decoration: none;
        }

        .db-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: linear-gradient(135deg, #6366f1, #a855f7);
            display: flex;
            align-items: center;
            justify-content: center;
            color: #ffffff;
            font-weight: 700;
            font-size: 0.95rem;
            border: 2px solid rgba(255, 255, 255, 0.15);
            overflow: hidden;
        }

        .db-avatar img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .db-profile-info {
            display: flex;
            flex-direction: column;
            line-height: 1.25;
        }

        .db-profile-name {
            font-size: 0.9rem;
            font-weight: 600;
            color: #ffffff;
        }

        .db-profile-sub {
            font-size: 0.75rem;
            color: var(--db-text-muted);
        }

        /* ------------------ DASHBOARD CONTAINER (ORDERLY & BALANCED) ------------------ */
        .db-container {
            padding: 24px 30px 40px;
            max-width: 1680px;
            margin: 0 auto;
            width: 100%;
            box-sizing: border-box;
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        /* ------------------ GREETING BANNER ------------------ */
        .db-greeting-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            flex-wrap: wrap;
        }

        .db-greeting-left h1 {
            font-size: 1.85rem;
            font-weight: 800;
            color: #ffffff;
            letter-spacing: -0.02em;
            margin-bottom: 4px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .db-greeting-left p {
            font-size: 0.92rem;
            color: var(--db-text-muted);
        }

        .db-greeting-right {
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .db-date-text {
            font-size: 0.88rem;
            color: var(--db-text-muted);
            font-weight: 500;
        }

        .db-quote-badge {
            background: rgba(121, 82, 245, 0.12);
            border: 1px solid rgba(121, 82, 245, 0.3);
            border-radius: 999px;
            padding: 8px 18px;
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 0.85rem;
            color: #c4b5fd;
            font-style: italic;
            white-space: nowrap;
        }

        .db-quote-badge svg {
            color: var(--db-purple-light);
            width: 16px;
            height: 16px;
            flex-shrink: 0;
        }

        /* ------------------ ROW 1: 4 EQUAL QUICK STATS KPI CARDS ------------------ */
        .db-kpi-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 18px;
            align-items: stretch;
        }

        .db-kpi-card {
            background-color: var(--db-bg-card);
            border: 1px solid var(--db-border);
            border-radius: 14px;
            padding: 18px 20px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            height: 100%;
            min-height: 136px;
            box-sizing: border-box;
            position: relative;
            transition: all 0.25s ease;
            text-decoration: none;
            color: inherit;
        }

        .db-kpi-card:hover {
            transform: translateY(-2px);
            border-color: var(--db-border-hover);
            box-shadow: 0 10px 24px rgba(0, 0, 0, 0.35);
        }

        .db-kpi-top {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 12px;
        }

        .db-kpi-icon-wrap {
            width: 42px;
            height: 42px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        .db-kpi-icon-wrap.purple {
            background: rgba(121, 82, 245, 0.18);
            color: #a855f7;
        }
        .db-kpi-icon-wrap.green {
            background: rgba(16, 185, 129, 0.18);
            color: #10b981;
        }
        .db-kpi-icon-wrap.blue {
            background: rgba(56, 189, 248, 0.18);
            color: #38bdf8;
        }
        .db-kpi-icon-wrap.orange {
            background: rgba(249, 115, 22, 0.18);
            color: #f97316;
        }

        .db-kpi-arrow {
            color: var(--db-text-dim);
            font-size: 1.1rem;
            transition: transform 0.2s ease, color 0.2s ease;
        }

        .db-kpi-card:hover .db-kpi-arrow {
            color: #ffffff;
            transform: translateX(4px);
        }

        .db-kpi-title {
            font-size: 0.82rem;
            color: var(--db-text-muted);
            font-weight: 500;
            margin-bottom: 4px;
        }

        .db-kpi-value {
            font-size: 1.85rem;
            font-weight: 800;
            color: #ffffff;
            line-height: 1.1;
            margin-bottom: 6px;
            letter-spacing: -0.02em;
        }

        .db-kpi-sub {
            font-size: 0.78rem;
            color: var(--db-text-muted);
            display: flex;
            align-items: center;
            gap: 4px;
        }

        .db-kpi-sub.red-highlight {
            color: #f43f5e;
            font-weight: 600;
        }

        .db-kpi-sub.green-highlight {
            color: #10b981;
            font-weight: 600;
        }

        /* ------------------ MAIN TWO-COLUMN DASHBOARD GRID ------------------ */
        .db-main-grid {
            display: grid;
            grid-template-columns: minmax(0, 1fr) 340px;
            gap: 20px;
            align-items: stretch;
        }

        .db-left-col {
            display: flex;
            flex-direction: column;
            gap: 20px;
            min-width: 0;
        }

        .db-right-col {
            display: flex;
            flex-direction: column;
            gap: 20px;
            min-width: 0;
        }

        /* Generic Card Styles (Equal Baseline & Padding) */
        .db-card {
            background-color: var(--db-bg-card);
            border: 1px solid var(--db-border);
            border-radius: 14px;
            padding: 20px;
            position: relative;
            box-sizing: border-box;
            transition: border-color 0.2s ease;
        }

        .db-card:hover {
            border-color: var(--db-border-hover);
        }

        .db-card-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 16px;
            flex-shrink: 0;
        }

        .db-card-title-group {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .db-card-title-group svg {
            color: var(--db-purple-light);
            width: 19px;
            height: 19px;
            flex-shrink: 0;
        }

        .db-card-title {
            font-size: 1.02rem;
            font-weight: 700;
            color: #ffffff;
            white-space: nowrap;
        }

        .db-card-link {
            font-size: 0.8rem;
            color: var(--db-purple-light);
            text-decoration: none;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 4px;
            transition: color 0.2s ease;
            white-space: nowrap;
        }

        .db-card-link:hover {
            color: #c4b5fd;
        }

        /* Dropdown button */
        .db-dropdown-btn {
            background: rgba(255, 255, 255, 0.04);
            border: 1px solid var(--db-border);
            border-radius: 8px;
            color: var(--db-text-muted);
            padding: 6px 12px;
            font-size: 0.78rem;
            font-weight: 500;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 6px;
            transition: all 0.2s ease;
            white-space: nowrap;
        }

        .db-dropdown-btn:hover {
            color: #ffffff;
            border-color: rgba(255, 255, 255, 0.15);
            background: rgba(255, 255, 255, 0.07);
        }

        /* ------------------ ROW 2: TODAY'S SCHEDULE + UPCOMING TASKS (EQUAL HEIGHT) ------------------ */
        .db-row-schedule-tasks {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            align-items: stretch;
        }

        .db-row-schedule-tasks > .db-card {
            height: 100%;
            display: flex;
            flex-direction: column;
        }

        /* Schedule Timeline */
        .db-schedule-list {
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            gap: 8px;
            position: relative;
        }

        .db-schedule-item {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 8px 12px;
            border-radius: 12px;
            background: rgba(255, 255, 255, 0.02);
            border: 1px solid transparent;
            transition: all 0.2s ease;
            position: relative;
            min-height: 50px;
            box-sizing: border-box;
        }

        .db-schedule-item:hover {
            background: rgba(255, 255, 255, 0.04);
            border-color: rgba(255, 255, 255, 0.05);
        }

        .db-schedule-time {
            font-size: 0.8rem;
            font-weight: 600;
            color: var(--db-text-muted);
            min-width: 68px;
            font-family: 'JetBrains Mono', monospace;
            flex-shrink: 0;
        }

        .db-timeline-connector {
            position: relative;
            display: flex;
            align-items: center;
            justify-content: center;
            width: 14px;
            flex-shrink: 0;
        }

        .db-timeline-dot {
            width: 10px;
            height: 10px;
            border-radius: 50%;
            z-index: 2;
        }
        .db-timeline-dot.cyan { background-color: #38bdf8; box-shadow: 0 0 8px rgba(56, 189, 248, 0.5); }
        .db-timeline-dot.blue { background-color: #6366f1; box-shadow: 0 0 8px rgba(99, 102, 241, 0.5); }
        .db-timeline-dot.purple { background-color: #a855f7; box-shadow: 0 0 8px rgba(168, 85, 247, 0.5); }
        .db-timeline-dot.pink { background-color: #ec4899; box-shadow: 0 0 8px rgba(236, 72, 153, 0.5); }

        .db-schedule-icon {
            width: 34px;
            height: 34px;
            border-radius: 9px;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }
        .db-schedule-icon.purple { background: rgba(121, 82, 245, 0.2); color: #c4b5fd; }
        .db-schedule-icon.blue { background: rgba(56, 189, 248, 0.2); color: #7dd3fc; }
        .db-schedule-icon.indigo { background: rgba(99, 102, 241, 0.2); color: #a5b4fc; }
        .db-schedule-icon.pink { background: rgba(236, 72, 153, 0.2); color: #f472b6; }

        .db-schedule-info {
            flex: 1;
            min-width: 0;
        }

        .db-schedule-name {
            font-size: 0.86rem;
            font-weight: 600;
            color: #ffffff;
            line-height: 1.25;
            white-space: normal;
            word-break: break-word;
        }

        .db-schedule-room {
            font-size: 0.73rem;
            color: var(--db-text-muted);
            margin-top: 2px;
            white-space: normal;
        }

        .db-status-pill {
            font-size: 0.72rem;
            font-weight: 600;
            padding: 3px 9px;
            border-radius: 999px;
            flex-shrink: 0;
            white-space: nowrap;
        }

        .db-status-pill.ongoing {
            background: rgba(16, 185, 129, 0.18);
            color: #34d399;
            border: 1px solid rgba(16, 185, 129, 0.3);
        }

        .db-status-pill.next {
            background: rgba(121, 82, 245, 0.25);
            color: #c4b5fd;
            border: 1px solid rgba(121, 82, 245, 0.4);
        }

        .db-status-pill.upcoming {
            background: rgba(255, 255, 255, 0.06);
            color: var(--db-text-muted);
            border: 1px solid rgba(255, 255, 255, 0.08);
        }

        .db-schedule-chevron {
            color: var(--db-text-dim);
            font-size: 0.8rem;
            margin-left: 2px;
            flex-shrink: 0;
        }

        /* Upcoming Tasks List */
        .db-tasks-list {
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            gap: 8px;
        }

        .db-task-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            padding: 8px 12px;
            border-radius: 12px;
            background: rgba(255, 255, 255, 0.02);
            border: 1px solid transparent;
            transition: all 0.2s ease;
            min-height: 50px;
            box-sizing: border-box;
        }

        .db-task-item:hover {
            background: rgba(255, 255, 255, 0.04);
            border-color: rgba(255, 255, 255, 0.05);
        }

        .db-task-left {
            display: flex;
            align-items: center;
            gap: 12px;
            flex: 1;
            min-width: 0;
        }

        .db-task-checkbox {
            width: 18px;
            height: 18px;
            border-radius: 50%;
            border: 2px solid var(--db-text-dim);
            cursor: pointer;
            transition: all 0.2s ease;
            flex-shrink: 0;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .db-task-checkbox:hover {
            border-color: var(--db-purple-light);
        }

        .db-task-checkbox.checked {
            background-color: var(--db-green);
            border-color: var(--db-green);
            color: #ffffff;
        }

        .db-task-title {
            font-size: 0.85rem;
            color: var(--db-text-primary);
            font-weight: 500;
            line-height: 1.25;
            white-space: normal;
            word-break: break-word;
            transition: all 0.2s ease;
        }

        .db-task-title.completed {
            text-decoration: line-through;
            color: var(--db-text-dim);
        }

        .db-task-right {
            display: flex;
            align-items: center;
            gap: 10px;
            flex-shrink: 0;
        }

        .db-priority-badge {
            font-size: 0.72rem;
            font-weight: 600;
            padding: 3px 9px;
            border-radius: 6px;
            white-space: nowrap;
        }

        .db-priority-badge.high {
            background: rgba(244, 63, 94, 0.16);
            color: #fb7185;
            border: 1px solid rgba(244, 63, 94, 0.3);
        }

        .db-priority-badge.medium {
            background: rgba(245, 158, 11, 0.16);
            color: #fcd34d;
            border: 1px solid rgba(245, 158, 11, 0.3);
        }

        .db-priority-badge.low {
            background: rgba(56, 189, 248, 0.16);
            color: #7dd3fc;
            border: 1px solid rgba(56, 189, 248, 0.3);
        }

        .db-task-due {
            font-size: 0.74rem;
            color: var(--db-text-muted);
            white-space: nowrap;
        }

        .db-task-kebab {
            background: transparent;
            border: none;
            color: var(--db-text-dim);
            cursor: pointer;
            padding: 2px 4px;
            font-size: 1.1rem;
            line-height: 1;
            transition: color 0.2s ease;
            flex-shrink: 0;
        }

        .db-task-kebab:hover {
            color: #ffffff;
        }

        /* ------------------ ROW 3: SUBJECT OVERVIEW + STUDY STREAK (EQUAL HEIGHT) ------------------ */
        .db-row-subjects-streak {
            display: grid;
            grid-template-columns: 1.85fr 1fr;
            gap: 20px;
            align-items: stretch;
        }

        .db-row-subjects-streak > .db-card {
            height: 100%;
            display: flex;
            flex-direction: column;
        }

        .db-subjects-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 12px;
            flex: 1;
            align-items: stretch;
        }

        .db-subject-card {
            background: var(--db-bg-card-inner);
            border: 1px solid rgba(255, 255, 255, 0.05);
            border-radius: 12px;
            padding: 12px 14px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            gap: 8px;
            height: 100%;
            min-height: 92px;
            box-sizing: border-box;
            transition: all 0.2s ease;
        }

        .db-subject-card:hover {
            background: rgba(255, 255, 255, 0.04);
            border-color: rgba(255, 255, 255, 0.1);
            transform: translateY(-2px);
        }

        .db-subject-top {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .db-subject-icon {
            width: 32px;
            height: 32px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }
        .db-subject-icon.purple { background: rgba(121, 82, 245, 0.2); color: #c4b5fd; }
        .db-subject-icon.blue { background: rgba(56, 189, 248, 0.2); color: #7dd3fc; }
        .db-subject-icon.green { background: rgba(16, 185, 129, 0.2); color: #6ee7b7; }
        .db-subject-icon.orange { background: rgba(249, 115, 22, 0.2); color: #fdba74; }
        .db-subject-icon.red { background: rgba(244, 63, 94, 0.2); color: #fca5a5; }
        .db-subject-icon.violet { background: rgba(168, 85, 247, 0.2); color: #d8b4fe; }

        .db-subject-title-wrap {
            flex: 1;
            min-width: 0;
        }

        .db-subject-title {
            font-size: 0.82rem;
            font-weight: 600;
            color: #ffffff;
            display: flex;
            align-items: center;
            justify-content: space-between;
            line-height: 1.25;
            white-space: normal;
        }

        .db-subject-topics {
            font-size: 0.72rem;
            color: var(--db-text-muted);
            margin-top: 2px;
            white-space: normal;
        }

        .db-subject-bar-wrap {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .db-subject-bar-track {
            flex: 1;
            height: 5px;
            background: rgba(255, 255, 255, 0.08);
            border-radius: 999px;
            overflow: hidden;
        }

        .db-subject-bar-fill {
            height: 100%;
            border-radius: 999px;
            background: #6366f1;
        }
        .db-subject-bar-fill.purple { background: #7952f5; }
        .db-subject-bar-fill.blue { background: #38bdf8; }
        .db-subject-bar-fill.green { background: #10b981; }
        .db-subject-bar-fill.orange { background: #f97316; }
        .db-subject-bar-fill.red { background: #f43f5e; }
        .db-subject-bar-fill.violet { background: #a855f7; }

        .db-subject-pct {
            font-size: 0.74rem;
            font-weight: 700;
            color: #ffffff;
            min-width: 28px;
            text-align: right;
            font-family: 'JetBrains Mono', monospace;
            flex-shrink: 0;
        }

        /* Study Streak Card */
        .db-streak-card {
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            height: 100%;
            box-sizing: border-box;
        }

        .db-streak-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .db-streak-header-left {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .db-streak-flame {
            color: #f97316;
            width: 22px;
            height: 22px;
            flex-shrink: 0;
        }

        .db-streak-count {
            font-size: 1.85rem;
            font-weight: 800;
            color: #ffffff;
            margin: 10px 0 16px;
            letter-spacing: -0.02em;
        }

        .db-streak-days-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 6px;
        }

        .db-streak-day {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 6px;
            flex: 1;
        }

        .db-streak-circle {
            width: 28px;
            height: 28px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.72rem;
            font-weight: 700;
            flex-shrink: 0;
        }

        .db-streak-circle.checked {
            background: linear-gradient(135deg, #7952f5, #6366f1);
            color: #ffffff;
            box-shadow: 0 2px 8px rgba(99, 102, 241, 0.4);
        }

        .db-streak-circle.empty {
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.08);
            color: var(--db-text-dim);
        }

        .db-streak-day-label {
            font-size: 0.72rem;
            color: var(--db-text-muted);
            font-weight: 500;
        }

        /* ------------------ ROW 4: TODAY'S PROGRESS + TASK COMPLETION (EQUAL HEIGHT) ------------------ */
        .db-row-chart-donut {
            display: grid;
            grid-template-columns: 1.15fr 1fr;
            gap: 20px;
            align-items: stretch;
        }

        .db-row-chart-donut > .db-card {
            height: 100%;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            box-sizing: border-box;
        }

        /* Today's Progress Spline Area Chart */
        .db-chart-container {
            position: relative;
            width: 100%;
            height: 180px;
            min-height: 180px;
            margin-top: 6px;
            flex: 1;
            display: flex;
            align-items: center;
        }

        .db-chart-svg {
            width: 100%;
            height: 100%;
            overflow: visible;
        }

        .db-chart-grid line {
            stroke: rgba(255, 255, 255, 0.05);
            stroke-dasharray: 3 3;
        }

        .db-chart-axis-label {
            font-size: 0.7rem;
            fill: var(--db-text-dim);
            font-family: 'Inter', sans-serif;
        }

        /* Task Completion Donut */
        .db-donut-card-content {
            display: flex;
            align-items: center;
            justify-content: space-around;
            gap: 18px;
            flex: 1;
            padding: 8px 0;
            box-sizing: border-box;
        }

        .db-donut-wrapper {
            position: relative;
            width: 130px;
            height: 130px;
            flex-shrink: 0;
        }

        .db-donut-svg {
            width: 100%;
            height: 100%;
            transform: rotate(-90deg);
        }

        .db-donut-center {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            text-align: center;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
        }

        .db-donut-pct {
            font-size: 1.35rem;
            font-weight: 800;
            color: #ffffff;
            line-height: 1;
        }

        .db-donut-sub {
            font-size: 0.7rem;
            color: var(--db-text-muted);
            margin-top: 3px;
        }

        .db-donut-legend {
            display: flex;
            flex-direction: column;
            gap: 12px;
            flex: 1;
        }

        .db-donut-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            font-size: 0.82rem;
        }

        .db-donut-item-left {
            display: flex;
            align-items: center;
            gap: 8px;
            color: var(--db-text-primary);
            white-space: nowrap;
        }

        .db-legend-dot {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            flex-shrink: 0;
        }
        .db-legend-dot.green { background-color: #10b981; }
        .db-legend-dot.purple { background-color: #a855f7; }
        .db-legend-dot.red { background-color: #f43f5e; }

        .db-donut-item-val {
            color: var(--db-text-muted);
            font-weight: 500;
            font-family: 'JetBrains Mono', monospace;
            font-size: 0.8rem;
            white-space: nowrap;
        }

        /* ------------------ RIGHT COLUMN WIDGETS (EQUAL GAPS & FULL DISPLAY) ------------------ */
        .db-right-col > .db-card {
            display: flex;
            flex-direction: column;
        }

        /* Widget 1: Calendar */
        .db-cal-header-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 12px;
            flex-shrink: 0;
        }

        .db-cal-month-nav {
            font-size: 0.85rem;
            font-weight: 600;
            color: #ffffff;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .db-cal-arrows {
            display: flex;
            gap: 6px;
        }

        .db-cal-arrow-btn {
            background: rgba(255, 255, 255, 0.04);
            border: 1px solid var(--db-border);
            border-radius: 6px;
            width: 26px;
            height: 26px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--db-text-muted);
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .db-cal-arrow-btn:hover {
            color: #ffffff;
            background: rgba(255, 255, 255, 0.08);
        }

        .db-cal-grid {
            display: grid;
            grid-template-columns: repeat(7, 1fr);
            gap: 4px;
            text-align: center;
        }

        .db-cal-weekday {
            font-size: 0.72rem;
            font-weight: 600;
            color: var(--db-text-dim);
            padding-bottom: 6px;
        }

        .db-cal-day {
            aspect-ratio: 1;
            min-height: 28px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            font-size: 0.78rem;
            font-weight: 500;
            color: var(--db-text-primary);
            border-radius: 8px;
            position: relative;
            cursor: pointer;
            transition: all 0.15s ease;
        }

        .db-cal-day:hover:not(.muted) {
            background: rgba(255, 255, 255, 0.06);
        }

        .db-cal-day.muted {
            color: var(--db-text-dim);
            opacity: 0.4;
        }

        .db-cal-day.active {
            background: #6366f1;
            color: #ffffff;
            font-weight: 700;
            box-shadow: 0 4px 12px rgba(99, 102, 241, 0.45);
        }

        .db-cal-dots {
            display: flex;
            gap: 2px;
            position: absolute;
            bottom: 3px;
        }

        .db-cal-dot {
            width: 3px;
            height: 3px;
            border-radius: 50%;
            background-color: #38bdf8;
        }

        /* Widget 2: Quick Actions */
        .db-actions-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 10px;
        }

        .db-action-btn {
            background: var(--db-bg-card-inner);
            border: 1px solid rgba(255, 255, 255, 0.05);
            border-radius: 12px;
            padding: 12px 14px;
            display: flex;
            align-items: center;
            gap: 10px;
            color: var(--db-text-primary);
            text-decoration: none;
            font-size: 0.82rem;
            font-weight: 600;
            min-height: 48px;
            box-sizing: border-box;
            transition: all 0.2s ease;
            white-space: nowrap;
        }

        .db-action-btn:hover {
            background: rgba(255, 255, 255, 0.06);
            border-color: rgba(255, 255, 255, 0.12);
            transform: translateY(-2px);
            color: #ffffff;
        }

        .db-action-btn svg {
            color: var(--db-purple-light);
            width: 17px;
            height: 17px;
            flex-shrink: 0;
        }

        /* Widget 3: Recent Activity */
        .db-act-list {
            display: flex;
            flex-direction: column;
            gap: 8px;
            flex: 1;
        }

        .db-act-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            padding: 6px 4px;
            border-radius: 10px;
            min-height: 44px;
            box-sizing: border-box;
            transition: background 0.2s ease;
        }

        .db-act-item:hover {
            background: rgba(255, 255, 255, 0.02);
        }

        .db-act-left {
            display: flex;
            align-items: center;
            gap: 12px;
            flex: 1;
            min-width: 0;
        }

        .db-act-icon {
            width: 32px;
            height: 32px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }
        .db-act-icon.green { background: rgba(16, 185, 129, 0.2); color: #34d399; }
        .db-act-icon.blue { background: rgba(56, 189, 248, 0.2); color: #7dd3fc; }
        .db-act-icon.purple { background: rgba(121, 82, 245, 0.2); color: #c4b5fd; }
        .db-act-icon.orange { background: rgba(249, 115, 22, 0.2); color: #fb923c; }

        .db-act-text {
            flex: 1;
            min-width: 0;
        }

        .db-act-title {
            font-size: 0.82rem;
            font-weight: 500;
            color: #ffffff;
            line-height: 1.25;
            white-space: normal;
            word-break: break-word;
        }

        .db-act-time {
            font-size: 0.72rem;
            color: var(--db-text-muted);
            margin-top: 2px;
            white-space: nowrap;
        }

        .db-act-kebab {
            background: transparent;
            border: none;
            color: var(--db-text-dim);
            cursor: pointer;
            padding: 2px 4px;
            font-size: 1rem;
            line-height: 1;
            transition: color 0.2s ease;
            flex-shrink: 0;
        }

        .db-act-kebab:hover {
            color: #ffffff;
        }

        /* Responsive Breakpoints - Orderly & Graceful without Hiding Elements */
        @media (max-width: 1380px) {
            .db-main-grid {
                grid-template-columns: minmax(0, 1fr) 310px;
                gap: 16px;
            }
            .db-kpi-grid {
                gap: 14px;
            }
            .db-container {
                padding: 20px 20px 32px;
            }
        }

        @media (max-width: 1100px) {
            .db-main-grid {
                grid-template-columns: 1fr;
            }
            .db-right-col {
                display: grid;
                grid-template-columns: repeat(2, 1fr);
                gap: 16px;
            }
            .db-right-col > .db-card:nth-child(3) {
                grid-column: span 2;
            }
        }
    </style>
</head>
<body>

<div class="db-layout">
    <!-- ======================================================== -->
    <!-- LEFT SIDEBAR                                             -->
    <!-- ======================================================== -->
    <aside class="db-sidebar">
        <div>
            <!-- Brand Logo -->
            <a href="${pageContext.request.contextPath}/dashboard" class="db-logo">
                <div class="db-logo-icon">
                    <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                        <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                        <line x1="16" y1="2" x2="16" y2="6"></line>
                        <line x1="8" y1="2" x2="8" y2="6"></line>
                        <line x1="3" y1="10" x2="21" y2="10"></line>
                        <path d="M8 14h.01M12 14h.01M16 14h.01M8 18h.01M12 18h.01M16 18h.01"></path>
                    </svg>
                </div>
                <div class="db-logo-text">Slot<span>Wise</span></div>
            </a>

            <!-- Navigation Links -->
            <nav class="db-nav">
                <!-- Dashboard (ACTIVE) -->
                <a href="${pageContext.request.contextPath}/dashboard" class="db-nav-item active">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path>
                        <polyline points="9 22 9 12 15 12 15 22"></polyline>
                    </svg>
                    <span>Dashboard</span>
                </a>

                <!-- Timetable -->
                <a href="${pageContext.request.contextPath}/today-timetable.jsp" class="db-nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                        <line x1="16" y1="2" x2="16" y2="6"></line>
                        <line x1="8" y1="2" x2="8" y2="6"></line>
                        <line x1="3" y1="10" x2="21" y2="10"></line>
                    </svg>
                    <span>Timetable</span>
                </a>

                <!-- My Tasks -->
                <a href="${pageContext.request.contextPath}/my-tasks.jsp" class="db-nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M9 11l3 3L22 4"></path>
                        <path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"></path>
                    </svg>
                    <span>My Tasks</span>
                </a>

                <!-- Smart Planner -->
                <a href="${pageContext.request.contextPath}/planner" class="db-nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="12" cy="12" r="2"></circle>
                        <path d="M16.24 7.76a6 6 0 0 1 0 8.49m-8.48-.01a6 6 0 0 1 0-8.49m11.31-2.82a10 10 0 0 1 0 14.14m-14.14 0a10 10 0 0 1 0-14.14"></path>
                    </svg>
                    <span>Smart Planner</span>
                </a>

                <!-- Progress -->
                <a href="${pageContext.request.contextPath}/progress" class="db-nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <line x1="18" y1="20" x2="18" y2="10"></line>
                        <line x1="12" y1="20" x2="12" y2="4"></line>
                        <line x1="6" y1="20" x2="6" y2="14"></line>
                    </svg>
                    <span>Progress</span>
                </a>

                <!-- Study Groups -->
                <a href="${pageContext.request.contextPath}/study-groups.jsp" class="db-nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                        <circle cx="9" cy="7" r="4"></circle>
                        <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                        <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                    </svg>
                    <span>Study Groups</span>
                </a>

                <!-- Smart Rescheduler -->
                <a href="${pageContext.request.contextPath}/smart-rescheduler.jsp" class="db-nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M21.5 2v6h-6"></path>
                        <path d="M2.5 12A10 10 0 0 1 20.5 6.3L21.5 8"></path>
                        <path d="M2.5 22v-6h6"></path>
                        <path d="M21.5 12A10 10 0 0 1 3.5 17.7L2.5 16"></path>
                    </svg>
                    <span>Smart Rescheduler</span>
                </a>

                <!-- Deadline Radar -->
                <a href="${pageContext.request.contextPath}/deadline-radar.jsp" class="db-nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="12" cy="12" r="2"></circle>
                        <path d="M16.24 7.76a6 6 0 0 1 0 8.49m-8.48-.01a6 6 0 0 1 0-8.49m11.31-2.82a10 10 0 0 1 0 14.14m-14.14 0a10 10 0 0 1 0-14.14"></path>
                    </svg>
                    <span>Deadline Radar</span>
                </a>

                <!-- Goals -->
                <a href="${pageContext.request.contextPath}/goals.jsp" class="db-nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
                    </svg>
                    <span>Goals</span>
                </a>

                <!-- Settings -->
                <a href="${pageContext.request.contextPath}/settings" class="db-nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="12" cy="12" r="3"></circle>
                        <path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z"></path>
                    </svg>
                    <span>Settings</span>
                </a>
            </nav>
        </div>

        <!-- Sidebar Bottom Logout -->
        <div class="db-sidebar-bottom">
            <a href="${pageContext.request.contextPath}/logout" class="db-nav-item logout">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path>
                    <polyline points="16 17 21 12 16 7"></polyline>
                    <line x1="21" y1="12" x2="9" y2="12"></line>
                </svg>
                <span>Logout</span>
            </a>
        </div>
    </aside>

    <!-- ======================================================== -->
    <!-- MAIN CONTENT AREA                                        -->
    <!-- ======================================================== -->
    <main class="db-main">
        <!-- Top Navigation Bar -->
        <header class="db-topbar">
            <!-- Search Box -->
            <div class="db-search-box">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                    <circle cx="11" cy="11" r="8"></circle>
                    <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                </svg>
                <input type="text" id="dbSearchInput" placeholder="Search for classes, tasks, subjects..." autocomplete="off">
                <span class="db-search-kbd">Ctrl K</span>
            </div>

            <!-- Right Controls: Notification & User Profile -->
            <div class="db-topbar-right">
                <button class="db-notif-btn" title="Notifications" aria-label="Notifications">
                    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"></path>
                        <path d="M13.73 21a2 2 0 0 1-3.46 0"></path>
                    </svg>
                    <span class="db-notif-dot"></span>
                </button>

                <a href="${pageContext.request.contextPath}/settings" class="db-profile-badge">
                    <div class="db-avatar">
                        <img src="https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100&auto=format&fit=crop&q=80" alt="Harish M" onerror="this.style.display='none'; this.parentNode.innerHTML='H';">
                    </div>
                    <div class="db-profile-info">
                        <span class="db-profile-name"><c:out value="${sessionScope.studentName != null ? sessionScope.studentName : 'Harish M'}"/></span>
                        <span class="db-profile-sub"><c:out value="${sessionScope.yearOfStudy != null ? sessionScope.yearOfStudy : 'CSE - 2nd Year'}"/></span>
                    </div>
                </a>
            </div>
        </header>

        <!-- Dashboard Content Body -->
        <div class="db-container">

            <!-- ==================================================== -->
            <!-- GREETING BANNER                                      -->
            <!-- ==================================================== -->
            <div class="db-greeting-row">
                <div class="db-greeting-left">
                    <h1>Good Morning, <%= displayName %>! &#9728;&#65039;</h1>
                    <p>Here's your overview for today. Stay consistent and make progress!</p>
                </div>
                <div class="db-greeting-right">
                    <span class="db-date-text">Sunday, 12 October 2026</span>
                    <div class="db-quote-badge">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                            <line x1="16" y1="2" x2="16" y2="6"></line>
                            <line x1="8" y1="2" x2="8" y2="6"></line>
                            <line x1="3" y1="10" x2="21" y2="10"></line>
                        </svg>
                        <span>&ldquo;Let's make today productive!&rdquo;</span>
                    </div>
                </div>
            </div>

            <!-- ==================================================== -->
            <!-- ROW 1: 4 QUICK STATS KPI CARDS                       -->
            <!-- ==================================================== -->
            <div class="db-kpi-grid">
                <!-- Card 1: Today's Classes -->
                <a href="${pageContext.request.contextPath}/today-timetable.jsp" class="db-kpi-card">
                    <div class="db-kpi-top">
                        <div class="db-kpi-icon-wrap purple">
                            <svg viewBox="0 0 24 24" width="22" height="22" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path>
                                <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path>
                            </svg>
                        </div>
                        <span class="db-kpi-arrow">&rarr;</span>
                    </div>
                    <div>
                        <div class="db-kpi-title">Today's Classes</div>
                        <div class="db-kpi-value"><c:out value="${todayClassCount != null && todayClassCount > 0 ? todayClassCount : 4}"/></div>
                        <div class="db-kpi-sub">Next: DBMS at 10:10 AM</div>
                    </div>
                </a>

                <!-- Card 2: Pending Tasks -->
                <a href="${pageContext.request.contextPath}/tasks" class="db-kpi-card">
                    <div class="db-kpi-top">
                        <div class="db-kpi-icon-wrap green">
                            <svg viewBox="0 0 24 24" width="22" height="22" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                                <polyline points="9 11 12 14 22 4"></polyline>
                                <path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"></path>
                            </svg>
                        </div>
                        <span class="db-kpi-arrow">&rarr;</span>
                    </div>
                    <div>
                        <div class="db-kpi-title">Pending Tasks</div>
                        <div class="db-kpi-value"><c:out value="${pendingTaskCount != null && pendingTaskCount > 0 ? pendingTaskCount : 6}"/></div>
                        <div class="db-kpi-sub red-highlight">2 High Priority</div>
                    </div>
                </a>

                <!-- Card 3: Study Hours -->
                <a href="${pageContext.request.contextPath}/progress" class="db-kpi-card">
                    <div class="db-kpi-top">
                        <div class="db-kpi-icon-wrap blue">
                            <svg viewBox="0 0 24 24" width="22" height="22" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <circle cx="12" cy="12" r="10"></circle>
                                <polyline points="12 6 12 12 16 14"></polyline>
                            </svg>
                        </div>
                        <span class="db-kpi-arrow">&rarr;</span>
                    </div>
                    <div>
                        <div class="db-kpi-title">Study Hours</div>
                        <div class="db-kpi-value">5.2<span style="font-size: 1.3rem; font-weight: 600; margin-left: 4px;">h</span></div>
                        <div class="db-kpi-sub green-highlight">
                            <span>&uarr;</span> 12% from yesterday
                        </div>
                    </div>
                </a>

                <!-- Card 4: Goals Progress -->
                <a href="${pageContext.request.contextPath}/goals.jsp" class="db-kpi-card">
                    <div class="db-kpi-top">
                        <div class="db-kpi-icon-wrap orange">
                            <svg viewBox="0 0 24 24" width="22" height="22" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <circle cx="12" cy="12" r="10"></circle>
                                <circle cx="12" cy="12" r="6"></circle>
                                <circle cx="12" cy="12" r="2"></circle>
                            </svg>
                        </div>
                        <span class="db-kpi-arrow">&rarr;</span>
                    </div>
                    <div>
                        <div class="db-kpi-title">Goals Progress</div>
                        <div class="db-kpi-value">3 <span style="font-size: 1.2rem; color: var(--db-text-dim); font-weight: 500;">/ 5</span></div>
                        <div class="db-kpi-sub">Keep going!</div>
                    </div>
                </a>
            </div>

            <!-- ==================================================== -->
            <!-- MAIN TWO-COLUMN DASHBOARD GRID                       -->
            <!-- ==================================================== -->
            <div class="db-main-grid">

                <!-- ---------------- LEFT COLUMN (70-75%) ---------------- -->
                <div class="db-left-col">

                    <!-- ROW 2: Today's Schedule & Upcoming Tasks -->
                    <div class="db-row-schedule-tasks">

                        <!-- Today's Schedule -->
                        <div class="db-card">
                            <div class="db-card-header">
                                <div class="db-card-title-group">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                        <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                        <line x1="16" y1="2" x2="16" y2="6"></line>
                                        <line x1="8" y1="2" x2="8" y2="6"></line>
                                        <line x1="3" y1="10" x2="21" y2="10"></line>
                                    </svg>
                                    <h3 class="db-card-title">Today's Schedule</h3>
                                </div>
                                <a href="${pageContext.request.contextPath}/today-timetable.jsp" class="db-card-link" id="todayScheduleViewTimetableBtn">
                                    <span>View Timetable</span>
                                    <span>&rarr;</span>
                                </a>
                            </div>

                            <div class="db-schedule-list">
                                <!-- Class 1: Data Structures -->
                                <div class="db-schedule-item">
                                    <div class="db-schedule-time">09:00 AM</div>
                                    <div class="db-timeline-connector">
                                        <div class="db-timeline-dot cyan"></div>
                                    </div>
                                    <div class="db-schedule-icon purple">
                                        <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                            <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path>
                                            <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path>
                                        </svg>
                                    </div>
                                    <div class="db-schedule-info">
                                        <div class="db-schedule-name">Data Structures</div>
                                        <div class="db-schedule-room">CS201 &bull; Main Block</div>
                                    </div>
                                    <span class="db-status-pill ongoing">Ongoing</span>
                                    <span class="db-schedule-chevron">&rsaquo;</span>
                                </div>

                                <!-- Class 2: Database Systems -->
                                <div class="db-schedule-item">
                                    <div class="db-schedule-time">10:10 AM</div>
                                    <div class="db-timeline-connector">
                                        <div class="db-timeline-dot blue"></div>
                                    </div>
                                    <div class="db-schedule-icon blue">
                                        <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                            <path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"></path>
                                            <polyline points="3.27 6.96 12 12.01 20.73 6.96"></polyline>
                                            <line x1="12" y1="22.08" x2="12" y2="12"></line>
                                        </svg>
                                    </div>
                                    <div class="db-schedule-info">
                                        <div class="db-schedule-name">Database Systems</div>
                                        <div class="db-schedule-room">CS203 &bull; Lab Block</div>
                                    </div>
                                    <span class="db-status-pill next">Next</span>
                                    <span class="db-schedule-chevron">&rsaquo;</span>
                                </div>

                                <!-- Class 3: Operating Systems -->
                                <div class="db-schedule-item">
                                    <div class="db-schedule-time">11:10 AM</div>
                                    <div class="db-timeline-connector">
                                        <div class="db-timeline-dot purple"></div>
                                    </div>
                                    <div class="db-schedule-icon indigo">
                                        <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                            <rect x="2" y="3" width="20" height="14" rx="2" ry="2"></rect>
                                            <line x1="8" y1="21" x2="16" y2="21"></line>
                                            <line x1="12" y1="17" x2="12" y2="21"></line>
                                        </svg>
                                    </div>
                                    <div class="db-schedule-info">
                                        <div class="db-schedule-name">Operating Systems</div>
                                        <div class="db-schedule-room">CS205 &bull; Main Block</div>
                                    </div>
                                    <span class="db-status-pill upcoming">Upcoming</span>
                                    <span class="db-schedule-chevron">&rsaquo;</span>
                                </div>

                                <!-- Class 4: Engineering Mathematics -->
                                <div class="db-schedule-item">
                                    <div class="db-schedule-time">02:00 PM</div>
                                    <div class="db-timeline-connector">
                                        <div class="db-timeline-dot pink"></div>
                                    </div>
                                    <div class="db-schedule-icon pink">
                                        <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                            <line x1="18" y1="20" x2="18" y2="10"></line>
                                            <line x1="12" y1="20" x2="12" y2="4"></line>
                                            <line x1="6" y1="20" x2="6" y2="14"></line>
                                        </svg>
                                    </div>
                                    <div class="db-schedule-info">
                                        <div class="db-schedule-name">Engineering Mathematics</div>
                                        <div class="db-schedule-room">MA201 &bull; Main Block</div>
                                    </div>
                                    <span class="db-status-pill upcoming">Upcoming</span>
                                    <span class="db-schedule-chevron">&rsaquo;</span>
                                </div>
                            </div>
                        </div>

                        <!-- Upcoming Tasks -->
                        <div class="db-card">
                            <div class="db-card-header">
                                <div class="db-card-title-group">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                        <polyline points="9 11 12 14 22 4"></polyline>
                                        <path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"></path>
                                    </svg>
                                    <h3 class="db-card-title">Upcoming Tasks</h3>
                                </div>
                                <a href="${pageContext.request.contextPath}/upcoming-tasks.jsp" class="db-card-link" id="upcomingTasksViewAllBtn">
                                    <span>View All</span>
                                    <span>&rarr;</span>
                                </a>
                            </div>

                            <div class="db-tasks-list">
                                <!-- Task 1: Complete DBMS Assignment -->
                                <div class="db-task-item">
                                    <div class="db-task-left">
                                        <div class="db-task-checkbox" onclick="toggleTaskCheckbox(this)"></div>
                                        <span class="db-task-title">Complete DBMS Assignment</span>
                                    </div>
                                    <div class="db-task-right">
                                        <span class="db-priority-badge high">High</span>
                                        <span class="db-task-due">Today</span>
                                        <button class="db-task-kebab" title="Actions" onclick="handleKebab(this)">&bull;&bull;&bull;</button>
                                    </div>
                                </div>

                                <!-- Task 2: Revise Java Notes -->
                                <div class="db-task-item">
                                    <div class="db-task-left">
                                        <div class="db-task-checkbox" onclick="toggleTaskCheckbox(this)"></div>
                                        <span class="db-task-title">Revise Java Notes</span>
                                    </div>
                                    <div class="db-task-right">
                                        <span class="db-priority-badge medium">Medium</span>
                                        <span class="db-task-due">Today</span>
                                        <button class="db-task-kebab" title="Actions" onclick="handleKebab(this)">&bull;&bull;&bull;</button>
                                    </div>
                                </div>

                                <!-- Task 3: Prepare Lab Record -->
                                <div class="db-task-item">
                                    <div class="db-task-left">
                                        <div class="db-task-checkbox" onclick="toggleTaskCheckbox(this)"></div>
                                        <span class="db-task-title">Prepare Lab Record</span>
                                    </div>
                                    <div class="db-task-right">
                                        <span class="db-priority-badge medium">Medium</span>
                                        <span class="db-task-due">Today</span>
                                        <button class="db-task-kebab" title="Actions" onclick="handleKebab(this)">&bull;&bull;&bull;</button>
                                    </div>
                                </div>

                                <!-- Task 4: Study OS Unit 3 -->
                                <div class="db-task-item">
                                    <div class="db-task-left">
                                        <div class="db-task-checkbox" onclick="toggleTaskCheckbox(this)"></div>
                                        <span class="db-task-title">Study OS Unit 3</span>
                                    </div>
                                    <div class="db-task-right">
                                        <span class="db-priority-badge low">Low</span>
                                        <span class="db-task-due">Today</span>
                                        <button class="db-task-kebab" title="Actions" onclick="handleKebab(this)">&bull;&bull;&bull;</button>
                                    </div>
                                </div>

                                <!-- Task 5: Plan next week timetable -->
                                <div class="db-task-item">
                                    <div class="db-task-left">
                                        <div class="db-task-checkbox" onclick="toggleTaskCheckbox(this)"></div>
                                        <span class="db-task-title">Plan next week timetable</span>
                                    </div>
                                    <div class="db-task-right">
                                        <span class="db-priority-badge low">Low</span>
                                        <span class="db-task-due">Today</span>
                                        <button class="db-task-kebab" title="Actions" onclick="handleKebab(this)">&bull;&bull;&bull;</button>
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div><!-- end db-row-schedule-tasks -->

                    <!-- ROW 3: Subject Overview + Study Streak -->
                    <div class="db-row-subjects-streak">

                        <!-- Subject Overview -->
                        <div class="db-card">
                            <div class="db-card-header">
                                <div class="db-card-title-group">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                        <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path>
                                        <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path>
                                    </svg>
                                    <h3 class="db-card-title">Subject Overview</h3>
                                </div>
                                <button class="db-dropdown-btn">
                                    <span>This Semester</span>
                                    <span>&blacktriangledown;</span>
                                </button>
                            </div>

                            <div class="db-subjects-grid">
                                <!-- Subject 1: Data Structures -->
                                <div class="db-subject-card">
                                    <div class="db-subject-top">
                                        <div class="db-subject-icon purple">
                                            <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                                <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path>
                                                <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path>
                                            </svg>
                                        </div>
                                        <div class="db-subject-title-wrap">
                                            <div class="db-subject-title">
                                                <span>Data Structures</span>
                                                <span style="color: var(--db-text-dim);">&rsaquo;</span>
                                            </div>
                                            <div class="db-subject-topics">12/14 topics</div>
                                        </div>
                                    </div>
                                    <div class="db-subject-bar-wrap">
                                        <div class="db-subject-bar-track">
                                            <div class="db-subject-bar-fill purple" style="width: 85%;"></div>
                                        </div>
                                        <span class="db-subject-pct">85%</span>
                                    </div>
                                </div>

                                <!-- Subject 2: Database Systems -->
                                <div class="db-subject-card">
                                    <div class="db-subject-top">
                                        <div class="db-subject-icon blue">
                                            <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                                <path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"></path>
                                            </svg>
                                        </div>
                                        <div class="db-subject-title-wrap">
                                            <div class="db-subject-title">
                                                <span>Database Systems</span>
                                                <span style="color: var(--db-text-dim);">&rsaquo;</span>
                                            </div>
                                            <div class="db-subject-topics">10/14 topics</div>
                                        </div>
                                    </div>
                                    <div class="db-subject-bar-wrap">
                                        <div class="db-subject-bar-track">
                                            <div class="db-subject-bar-fill blue" style="width: 70%;"></div>
                                        </div>
                                        <span class="db-subject-pct">70%</span>
                                    </div>
                                </div>

                                <!-- Subject 3: Operating Systems -->
                                <div class="db-subject-card">
                                    <div class="db-subject-top">
                                        <div class="db-subject-icon green">
                                            <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                                <rect x="2" y="3" width="20" height="14" rx="2" ry="2"></rect>
                                                <line x1="8" y1="21" x2="16" y2="21"></line>
                                                <line x1="12" y1="17" x2="12" y2="21"></line>
                                            </svg>
                                        </div>
                                        <div class="db-subject-title-wrap">
                                            <div class="db-subject-title">
                                                <span>Operating Systems</span>
                                                <span style="color: var(--db-text-dim);">&rsaquo;</span>
                                            </div>
                                            <div class="db-subject-topics">9/15 topics</div>
                                        </div>
                                    </div>
                                    <div class="db-subject-bar-wrap">
                                        <div class="db-subject-bar-track">
                                            <div class="db-subject-bar-fill green" style="width: 60%;"></div>
                                        </div>
                                        <span class="db-subject-pct">60%</span>
                                    </div>
                                </div>

                                <!-- Subject 4: Computer Networks -->
                                <div class="db-subject-card">
                                    <div class="db-subject-top">
                                        <div class="db-subject-icon orange">
                                            <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                                <rect x="2" y="2" width="6" height="6" rx="1"></rect>
                                                <rect x="16" y="2" width="6" height="6" rx="1"></rect>
                                                <rect x="9" y="16" width="6" height="6" rx="1"></rect>
                                                <path d="M5 8v3a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V8"></path>
                                                <line x1="12" y1="13" x2="12" y2="16"></line>
                                            </svg>
                                        </div>
                                        <div class="db-subject-title-wrap">
                                            <div class="db-subject-title">
                                                <span>Computer Networks</span>
                                                <span style="color: var(--db-text-dim);">&rsaquo;</span>
                                            </div>
                                            <div class="db-subject-topics">9/12 topics</div>
                                        </div>
                                    </div>
                                    <div class="db-subject-bar-wrap">
                                        <div class="db-subject-bar-track">
                                            <div class="db-subject-bar-fill orange" style="width: 75%;"></div>
                                        </div>
                                        <span class="db-subject-pct">75%</span>
                                    </div>
                                </div>

                                <!-- Subject 5: Software Engineering -->
                                <div class="db-subject-card">
                                    <div class="db-subject-top">
                                        <div class="db-subject-icon red">
                                            <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                                <polyline points="16 18 22 12 16 6"></polyline>
                                                <polyline points="8 6 2 12 8 18"></polyline>
                                            </svg>
                                        </div>
                                        <div class="db-subject-title-wrap">
                                            <div class="db-subject-title">
                                                <span>Software Engineering</span>
                                                <span style="color: var(--db-text-dim);">&rsaquo;</span>
                                            </div>
                                            <div class="db-subject-topics">6/12 topics</div>
                                        </div>
                                    </div>
                                    <div class="db-subject-bar-wrap">
                                        <div class="db-subject-bar-track">
                                            <div class="db-subject-bar-fill red" style="width: 50%;"></div>
                                        </div>
                                        <span class="db-subject-pct">50%</span>
                                    </div>
                                </div>

                                <!-- Subject 6: Mathematics -->
                                <div class="db-subject-card">
                                    <div class="db-subject-top">
                                        <div class="db-subject-icon violet">
                                            <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                                <line x1="18" y1="20" x2="18" y2="10"></line>
                                                <line x1="12" y1="20" x2="12" y2="4"></line>
                                                <line x1="6" y1="20" x2="6" y2="14"></line>
                                            </svg>
                                        </div>
                                        <div class="db-subject-title-wrap">
                                            <div class="db-subject-title">
                                                <span>Mathematics</span>
                                                <span style="color: var(--db-text-dim);">&rsaquo;</span>
                                            </div>
                                            <div class="db-subject-topics">11/17 topics</div>
                                        </div>
                                    </div>
                                    <div class="db-subject-bar-wrap">
                                        <div class="db-subject-bar-track">
                                            <div class="db-subject-bar-fill violet" style="width: 65%;"></div>
                                        </div>
                                        <span class="db-subject-pct">65%</span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Study Streak -->
                        <div class="db-card db-streak-card">
                            <div>
                                <div class="db-streak-header">
                                    <div class="db-streak-header-left">
                                        <svg class="db-streak-flame" viewBox="0 0 24 24" fill="currentColor">
                                            <path d="M12 2c-.3 0-.6.1-.9.3C9.7 3.5 8 6 8 8.5c0 1.2.4 2.3 1 3.2-.2-.5-.3-1.1-.3-1.7 0-1.7.9-3.2 2-4.1-.2 1.3.1 2.7.9 3.8.7.9 1.4 1.8 1.4 3.1 0 1.1-.7 2-1.7 2.4 1.2.2 2.3-.4 2.9-1.4.7-1.1.8-2.5.4-3.8 1.4 1.1 2.4 2.9 2.4 4.9 0 3.3-2.7 6-6 6s-6-2.7-6-6c0-3.6 2.5-6.8 5.7-8.3-.5.4-.8.9-1 1.4z"></path>
                                        </svg>
                                        <h3 class="db-card-title">Study Streak</h3>
                                    </div>
                                    <span class="db-kpi-arrow">&rarr;</span>
                                </div>

                                <div class="db-streak-count">7 Days</div>
                            </div>

                            <div class="db-streak-days-row">
                                <!-- Mon -->
                                <div class="db-streak-day">
                                    <div class="db-streak-circle checked">&#10003;</div>
                                    <span class="db-streak-day-label">Mon</span>
                                </div>
                                <!-- Tue -->
                                <div class="db-streak-day">
                                    <div class="db-streak-circle checked">&#10003;</div>
                                    <span class="db-streak-day-label">Tue</span>
                                </div>
                                <!-- Wed -->
                                <div class="db-streak-day">
                                    <div class="db-streak-circle checked">&#10003;</div>
                                    <span class="db-streak-day-label">Wed</span>
                                </div>
                                <!-- Thu -->
                                <div class="db-streak-day">
                                    <div class="db-streak-circle checked">&#10003;</div>
                                    <span class="db-streak-day-label">Thu</span>
                                </div>
                                <!-- Fri -->
                                <div class="db-streak-day">
                                    <div class="db-streak-circle checked">&#10003;</div>
                                    <span class="db-streak-day-label">Fri</span>
                                </div>
                                <!-- Sat -->
                                <div class="db-streak-day">
                                    <div class="db-streak-circle empty"></div>
                                    <span class="db-streak-day-label">Sat</span>
                                </div>
                                <!-- Sun -->
                                <div class="db-streak-day">
                                    <div class="db-streak-circle empty"></div>
                                    <span class="db-streak-day-label">Sun</span>
                                </div>
                            </div>
                        </div>

                    </div><!-- end db-row-subjects-streak -->

                    <!-- ROW 4: Today's Progress + Task Completion -->
                    <div class="db-row-chart-donut">

                        <!-- Today's Progress Spline Area Chart -->
                        <div class="db-card">
                            <div class="db-card-header">
                                <div class="db-card-title-group">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                        <circle cx="12" cy="12" r="10"></circle>
                                        <polyline points="12 6 12 12 16 14"></polyline>
                                    </svg>
                                    <h3 class="db-card-title">Today's Progress</h3>
                                </div>
                                <button class="db-dropdown-btn">
                                    <span>Study Hours</span>
                                    <span>&blacktriangledown;</span>
                                </button>
                            </div>

                            <div class="db-chart-container">
                                <svg class="db-chart-svg" viewBox="0 0 440 180" preserveAspectRatio="none">
                                    <defs>
                                        <linearGradient id="chartFillGrad" x1="0%" y1="0%" x2="0%" y2="100%">
                                            <stop offset="0%" stop-color="#7952f5" stop-opacity="0.45" />
                                            <stop offset="60%" stop-color="#6366f1" stop-opacity="0.15" />
                                            <stop offset="100%" stop-color="#4f46e5" stop-opacity="0.0" />
                                        </linearGradient>
                                        <filter id="chartPointGlow" x="-50%" y="-50%" width="200%" height="200%">
                                            <feDropShadow dx="0" dy="0" stdDeviation="4" flood-color="#a855f7" flood-opacity="0.9" />
                                        </filter>
                                    </defs>

                                    <!-- Grid dashed lines -->
                                    <g class="db-chart-grid">
                                        <line x1="30" y1="20" x2="430" y2="20" />
                                        <line x1="30" y1="55" x2="430" y2="55" />
                                        <line x1="30" y1="90" x2="430" y2="90" />
                                        <line x1="30" y1="125" x2="430" y2="125" />
                                        <line x1="30" y1="160" x2="430" y2="160" />
                                    </g>

                                    <!-- Y Axis Labels -->
                                    <text x="10" y="24" class="db-chart-axis-label">8h</text>
                                    <text x="10" y="59" class="db-chart-axis-label">6h</text>
                                    <text x="10" y="94" class="db-chart-axis-label">4h</text>
                                    <text x="10" y="129" class="db-chart-axis-label">2h</text>
                                    <text x="10" y="164" class="db-chart-axis-label">0h</text>

                                    <!-- Area Fill Under Curve -->
                                    <path d="M 40 160 
                                             C 70 155, 95 145, 115 130 
                                             C 135 115, 160 135, 185 130 
                                             C 210 125, 235 105, 260 115 
                                             C 285 125, 310 80, 335 75 
                                             C 360 70, 385 120, 420 135 
                                             L 420 160 Z"
                                          fill="url(#chartFillGrad)" />

                                    <!-- Spline Curve Line -->
                                    <path d="M 40 160 
                                             C 70 155, 95 145, 115 130 
                                             C 135 115, 160 135, 185 130 
                                             C 210 125, 235 105, 260 115 
                                             C 285 125, 310 80, 335 75 
                                             C 360 70, 385 120, 420 135" 
                                          fill="none" 
                                          stroke="#8b5cf6" 
                                          stroke-width="3" 
                                          stroke-linecap="round" />

                                    <!-- Active Peak Point (at 6 PM: 5.2h) -->
                                    <circle cx="335" cy="75" r="5" fill="#ffffff" stroke="#7952f5" stroke-width="3" filter="url(#chartPointGlow)" />

                                    <!-- Tooltip badge at 6 PM -->
                                    <g transform="translate(315, 38)">
                                        <rect width="40" height="22" rx="6" fill="#312e81" stroke="#6366f1" stroke-width="1.2" />
                                        <text x="20" y="15" fill="#ffffff" font-size="11" font-weight="700" text-anchor="middle" font-family="'JetBrains Mono', monospace">5.2h</text>
                                    </g>

                                    <!-- X Axis Labels -->
                                    <text x="40" y="176" class="db-chart-axis-label" text-anchor="middle">6 AM</text>
                                    <text x="115" y="176" class="db-chart-axis-label" text-anchor="middle">9 AM</text>
                                    <text x="185" y="176" class="db-chart-axis-label" text-anchor="middle">12 PM</text>
                                    <text x="260" y="176" class="db-chart-axis-label" text-anchor="middle">3 PM</text>
                                    <text x="335" y="176" class="db-chart-axis-label" text-anchor="middle">6 PM</text>
                                    <text x="410" y="176" class="db-chart-axis-label" text-anchor="middle">9 PM</text>
                                </svg>
                            </div>
                        </div>

                        <!-- Task Completion Donut -->
                        <div class="db-card">
                            <div class="db-card-header">
                                <div class="db-card-title-group">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                        <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                        <line x1="16" y1="2" x2="16" y2="6"></line>
                                        <line x1="8" y1="2" x2="8" y2="6"></line>
                                        <polyline points="9 13 11 15 15 11"></polyline>
                                    </svg>
                                    <h3 class="db-card-title">Task Completion</h3>
                                </div>
                                <span class="db-kpi-arrow">&rarr;</span>
                            </div>

                            <div class="db-donut-card-content">
                                <!-- Donut Ring SVG -->
                                <div class="db-donut-wrapper">
                                    <svg class="db-donut-svg" viewBox="0 0 100 100">
                                        <!-- Background circle -->
                                        <circle cx="50" cy="50" r="38" fill="none" stroke="rgba(255, 255, 255, 0.05)" stroke-width="12"></circle>
                                        <!-- Completed: 75% Green (circumference ~ 238.76, 75% = 179.07) -->
                                        <circle cx="50" cy="50" r="38" fill="none" stroke="#10b981" stroke-width="12"
                                                stroke-dasharray="179.07 238.76" stroke-dashoffset="0" stroke-linecap="round"></circle>
                                        <!-- Pending: 18% Purple (18% = 42.98, offset = -185) -->
                                        <circle cx="50" cy="50" r="38" fill="none" stroke="#a855f7" stroke-width="12"
                                                stroke-dasharray="42.98 238.76" stroke-dashoffset="-185" stroke-linecap="round"></circle>
                                        <!-- Overdue: 7% Red (7% = 16.71, offset = -230) -->
                                        <circle cx="50" cy="50" r="38" fill="none" stroke="#f43f5e" stroke-width="12"
                                                stroke-dasharray="16.71 238.76" stroke-dashoffset="-230" stroke-linecap="round"></circle>
                                    </svg>
                                    <div class="db-donut-center">
                                        <span class="db-donut-pct">75%</span>
                                        <span class="db-donut-sub">Completed</span>
                                    </div>
                                </div>

                                <!-- Donut Legend -->
                                <div class="db-donut-legend">
                                    <div class="db-donut-item">
                                        <div class="db-donut-item-left">
                                            <div class="db-legend-dot green"></div>
                                            <span>Completed</span>
                                        </div>
                                        <span class="db-donut-item-val">24 (75%)</span>
                                    </div>

                                    <div class="db-donut-item">
                                        <div class="db-donut-item-left">
                                            <div class="db-legend-dot purple"></div>
                                            <span>Pending</span>
                                        </div>
                                        <span class="db-donut-item-val">6 (18%)</span>
                                    </div>

                                    <div class="db-donut-item">
                                        <div class="db-donut-item-left">
                                            <div class="db-legend-dot red"></div>
                                            <span>Overdue</span>
                                        </div>
                                        <span class="db-donut-item-val">2 (7%)</span>
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div><!-- end db-row-chart-donut -->

                </div><!-- end db-left-col -->

                <!-- ---------------- RIGHT COLUMN (25-30%) ---------------- -->
                <div class="db-right-col">

                    <!-- Widget 1: Calendar -->
                    <div class="db-card">
                        <div class="db-card-header">
                            <div class="db-card-title-group">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                    <line x1="16" y1="2" x2="16" y2="6"></line>
                                    <line x1="8" y1="2" x2="8" y2="6"></line>
                                    <line x1="3" y1="10" x2="21" y2="10"></line>
                                </svg>
                                <h3 class="db-card-title">Calendar</h3>
                            </div>
                            <div class="db-cal-arrows">
                                <button class="db-cal-arrow-btn" title="Previous Month">&lsaquo;</button>
                                <button class="db-cal-arrow-btn" title="Next Month">&rsaquo;</button>
                            </div>
                        </div>

                        <div class="db-cal-header-row">
                            <div class="db-cal-month-nav">
                                <span>&larr;</span>
                                <span>October 2026</span>
                            </div>
                        </div>

                        <div class="db-cal-grid">
                            <!-- Weekdays Header -->
                            <div class="db-cal-weekday">Mon</div>
                            <div class="db-cal-weekday">Tue</div>
                            <div class="db-cal-weekday">Wed</div>
                            <div class="db-cal-weekday">Thu</div>
                            <div class="db-cal-weekday">Fri</div>
                            <div class="db-cal-weekday">Sat</div>
                            <div class="db-cal-weekday">Sun</div>

                            <!-- Row 1 -->
                            <div class="db-cal-day muted">28</div>
                            <div class="db-cal-day muted">29</div>
                            <div class="db-cal-day muted">30</div>
                            <div class="db-cal-day">1</div>
                            <div class="db-cal-day">2</div>
                            <div class="db-cal-day">3</div>
                            <div class="db-cal-day">4</div>

                            <!-- Row 2 -->
                            <div class="db-cal-day">5</div>
                            <div class="db-cal-day">6<div class="db-cal-dots"><div class="db-cal-dot"></div><div class="db-cal-dot"></div></div></div>
                            <div class="db-cal-day">7<div class="db-cal-dots"><div class="db-cal-dot"></div><div class="db-cal-dot"></div></div></div>
                            <div class="db-cal-day">8</div>
                            <div class="db-cal-day">9</div>
                            <div class="db-cal-day">10</div>
                            <div class="db-cal-day">11<div class="db-cal-dots"><div class="db-cal-dot"></div><div class="db-cal-dot"></div></div></div>

                            <!-- Row 3: Day 12 is Active -->
                            <div class="db-cal-day active">12</div>
                            <div class="db-cal-day">13</div>
                            <div class="db-cal-day">14</div>
                            <div class="db-cal-day">15<div class="db-cal-dots"><div class="db-cal-dot"></div><div class="db-cal-dot"></div></div></div>
                            <div class="db-cal-day">16</div>
                            <div class="db-cal-day">17</div>
                            <div class="db-cal-day">18<div class="db-cal-dots"><div class="db-cal-dot"></div><div class="db-cal-dot"></div></div></div>

                            <!-- Row 4 -->
                            <div class="db-cal-day">19</div>
                            <div class="db-cal-day">20</div>
                            <div class="db-cal-day">21</div>
                            <div class="db-cal-day">22<div class="db-cal-dots"><div class="db-cal-dot"></div><div class="db-cal-dot"></div></div></div>
                            <div class="db-cal-day">23<div class="db-cal-dots"><div class="db-cal-dot"></div><div class="db-cal-dot"></div></div></div>
                            <div class="db-cal-day">24</div>
                            <div class="db-cal-day">25</div>

                            <!-- Row 5 -->
                            <div class="db-cal-day">26</div>
                            <div class="db-cal-day">27<div class="db-cal-dots"><div class="db-cal-dot"></div><div class="db-cal-dot"></div></div></div>
                            <div class="db-cal-day">28<div class="db-cal-dots"><div class="db-cal-dot"></div><div class="db-cal-dot"></div></div></div>
                            <div class="db-cal-day">29</div>
                            <div class="db-cal-day">30</div>
                            <div class="db-cal-day">31</div>
                            <div class="db-cal-day muted">1</div>
                        </div>
                    </div>

                    <!-- Widget 2: Quick Actions -->
                    <div class="db-card">
                        <div class="db-card-header">
                            <div class="db-card-title-group">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                                    <polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"></polygon>
                                </svg>
                                <h3 class="db-card-title">Quick Actions</h3>
                            </div>
                            <span class="db-kpi-arrow">&rarr;</span>
                        </div>

                        <div class="db-actions-grid">
                            <!-- Action 1: Add Task -->
                            <a href="${pageContext.request.contextPath}/tasks?action=add" class="db-action-btn">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                                    <line x1="12" y1="5" x2="12" y2="19"></line>
                                    <line x1="5" y1="12" x2="19" y2="12"></line>
                                </svg>
                                <span>Add Task</span>
                            </a>

                            <!-- Action 2: View Timetable -->
                            <a href="${pageContext.request.contextPath}/today-timetable.jsp" class="db-action-btn">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                    <line x1="16" y1="2" x2="16" y2="6"></line>
                                    <line x1="8" y1="2" x2="8" y2="6"></line>
                                    <line x1="3" y1="10" x2="21" y2="10"></line>
                                </svg>
                                <span>View Timetable</span>
                            </a>

                            <!-- Action 3: Set Goal -->
                            <a href="${pageContext.request.contextPath}/goals.jsp" class="db-action-btn">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <circle cx="12" cy="12" r="10"></circle>
                                    <circle cx="12" cy="12" r="6"></circle>
                                    <circle cx="12" cy="12" r="2"></circle>
                                </svg>
                                <span>Set Goal</span>
                            </a>

                            <!-- Action 4: Join Study Group -->
                            <a href="${pageContext.request.contextPath}/study-groups.jsp" class="db-action-btn">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                                    <circle cx="9" cy="7" r="4"></circle>
                                    <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                                    <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                                </svg>
                                <span>Join Study Group</span>
                            </a>
                        </div>
                    </div>

                    <!-- Widget 3: Recent Activity -->
                    <div class="db-card">
                        <div class="db-card-header">
                            <div class="db-card-title-group">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <polyline points="20 6 9 17 4 12"></polyline>
                                </svg>
                                <h3 class="db-card-title">Recent Activity</h3>
                            </div>
                            <a href="${pageContext.request.contextPath}/recent-activity.jsp" class="db-card-link">
                                <span>View All</span>
                                <span>&rarr;</span>
                            </a>
                        </div>

                        <div class="db-act-list">
                            <!-- Item 1: Completed OS Lab Record -->
                            <div class="db-act-item">
                                <div class="db-act-left">
                                    <div class="db-act-icon green">
                                        <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                                            <polyline points="20 6 9 17 4 12"></polyline>
                                        </svg>
                                    </div>
                                    <div class="db-act-text">
                                        <div class="db-act-title">Completed OS Lab Record</div>
                                        <div class="db-act-time">2 hours ago</div>
                                    </div>
                                </div>
                                <button class="db-act-kebab" title="Options" onclick="handleKebab(this)">&bull;&bull;&bull;</button>
                            </div>

                            <!-- Item 2: Added Java Notes -->
                            <div class="db-act-item">
                                <div class="db-act-left">
                                    <div class="db-act-icon blue">
                                        <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                            <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                                            <polyline points="14 2 14 8 20 8"></polyline>
                                        </svg>
                                    </div>
                                    <div class="db-act-text">
                                        <div class="db-act-title">Added Java Notes</div>
                                        <div class="db-act-time">4 hours ago</div>
                                    </div>
                                </div>
                                <button class="db-act-kebab" title="Options" onclick="handleKebab(this)">&bull;&bull;&bull;</button>
                            </div>

                            <!-- Item 3: Updated next week timetable -->
                            <div class="db-act-item">
                                <div class="db-act-left">
                                    <div class="db-act-icon purple">
                                        <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                            <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                            <line x1="16" y1="2" x2="16" y2="6"></line>
                                            <line x1="8" y1="2" x2="8" y2="6"></line>
                                        </svg>
                                    </div>
                                    <div class="db-act-text">
                                        <div class="db-act-title">Updated next week timetable</div>
                                        <div class="db-act-time">6 hours ago</div>
                                    </div>
                                </div>
                                <button class="db-act-kebab" title="Options" onclick="handleKebab(this)">&bull;&bull;&bull;</button>
                            </div>

                            <!-- Item 4: Achieved 7-day streak! -->
                            <div class="db-act-item">
                                <div class="db-act-left">
                                    <div class="db-act-icon orange">
                                        <svg viewBox="0 0 24 24" width="16" height="16" fill="currentColor">
                                            <path d="M12 2c-.3 0-.6.1-.9.3C9.7 3.5 8 6 8 8.5c0 1.2.4 2.3 1 3.2-.2-.5-.3-1.1-.3-1.7 0-1.7.9-3.2 2-4.1-.2 1.3.1 2.7.9 3.8.7.9 1.4 1.8 1.4 3.1 0 1.1-.7 2-1.7 2.4 1.2.2 2.3-.4 2.9-1.4.7-1.1.8-2.5.4-3.8 1.4 1.1 2.4 2.9 2.4 4.9 0 3.3-2.7 6-6 6s-6-2.7-6-6c0-3.6 2.5-6.8 5.7-8.3-.5.4-.8.9-1 1.4z"></path>
                                        </svg>
                                    </div>
                                    <div class="db-act-text">
                                        <div class="db-act-title">Achieved 7-day streak!</div>
                                        <div class="db-act-time">1 day ago</div>
                                    </div>
                                </div>
                                <button class="db-act-kebab" title="Options" onclick="handleKebab(this)">&bull;&bull;&bull;</button>
                            </div>
                        </div>
                    </div>

                </div><!-- end db-right-col -->

            </div><!-- end db-main-grid -->

        </div><!-- end db-container -->
    </main>
</div><!-- end db-layout -->

<script>
// Interactive Task Completion Toggle
function toggleTaskCheckbox(box) {
    box.classList.toggle('checked');
    var row = box.closest('.db-task-item');
    if (row) {
        var title = row.querySelector('.db-task-title');
        if (title) {
            title.classList.toggle('completed');
        }
    }
    if (box.classList.contains('checked')) {
        box.innerHTML = '<span style="font-size: 11px;">&#10003;</span>';
    } else {
        box.innerHTML = '';
    }
}

// Kebab Menu Click Micro-interaction
function handleKebab(btn) {
    btn.style.transform = 'scale(1.25)';
    setTimeout(function() { btn.style.transform = ''; }, 150);
}

// Global Search (Ctrl + K) shortcut
document.addEventListener('keydown', function(e) {
    if ((e.ctrlKey || e.metaKey) && (e.key === 'k' || e.key === 'K')) {
        e.preventDefault();
        var searchInput = document.getElementById('dbSearchInput');
        if (searchInput) {
            searchInput.focus();
            searchInput.select();
        }
    }
});

// Live in-page filter for schedule & tasks
var searchInput = document.getElementById('dbSearchInput');
if (searchInput) {
    searchInput.addEventListener('input', function(e) {
        var q = (e.target.value || '').toLowerCase().trim();
        
        // Filter schedule items
        var schedItems = document.querySelectorAll('.db-schedule-item');
        schedItems.forEach(function(item) {
            var txt = item.textContent.toLowerCase();
            item.style.display = (!q || txt.indexOf(q) !== -1) ? 'flex' : 'none';
        });

        // Filter task items
        var taskItems = document.querySelectorAll('.db-task-item');
        taskItems.forEach(function(item) {
            var txt = item.textContent.toLowerCase();
            item.style.display = (!q || txt.indexOf(q) !== -1) ? 'flex' : 'none';
        });

        // Filter subject cards
        var subjCards = document.querySelectorAll('.db-subject-card');
        subjCards.forEach(function(card) {
            var txt = card.textContent.toLowerCase();
            card.style.display = (!q || txt.indexOf(q) !== -1) ? 'flex' : 'none';
        });
    });
}
</script>

</body>
</html>
