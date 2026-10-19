<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
    // Ensure default demo values if session is fresh
    if (session.getAttribute("studentName") == null) {
        session.setAttribute("studentName", "Harish M");
    }
    if (session.getAttribute("yearOfStudy") == null) {
        session.setAttribute("yearOfStudy", "CSE - 2nd Year");
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Upcoming Tasks &mdash; SlotWise</title>
    <meta name="description" content="All your upcoming tasks in one place. Plan, track, and complete them on time with SlotWise.">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        :root {
            --ut-bg-app: #080c18;
            --ut-bg-sidebar: #090e1d;
            --ut-bg-card: #0d1326;
            --ut-bg-card-hover: #121933;
            --ut-bg-inner: #11182e;
            --ut-border: rgba(255, 255, 255, 0.07);
            --ut-border-hover: rgba(255, 255, 255, 0.15);
            --ut-purple: #7952f5;
            --ut-purple-light: #9d7bfc;
            --ut-purple-glow: rgba(121, 82, 245, 0.35);
            --ut-blue: #38bdf8;
            --ut-green: #10b981;
            --ut-red: #f43f5e;
            --ut-orange: #f97316;
            --ut-yellow: #f59e0b;
            --ut-text-white: #ffffff;
            --ut-text-primary: #f1f5f9;
            --ut-text-muted: #8492a6;
            --ut-text-dim: #4d5b75;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            background-color: var(--ut-bg-app) !important;
            color: var(--ut-text-primary);
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            margin: 0;
            padding: 0;
            overflow-x: hidden;
            -webkit-font-smoothing: antialiased;
        }

        .ut-layout {
            display: flex;
            min-height: 100vh;
            background-color: var(--ut-bg-app);
            position: relative;
        }

        /* Ambient mesh glow in bottom left */
        .ut-layout::before {
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

        /* ------------------ SIDEBAR ------------------ */
        .ut-sidebar {
            width: 240px;
            min-width: 240px;
            background-color: var(--ut-bg-sidebar);
            border-right: 1px solid var(--ut-border);
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

        .ut-logo {
            display: flex;
            align-items: center;
            gap: 12px;
            text-decoration: none;
            padding: 0 8px 24px;
        }

        .ut-logo-icon {
            width: 36px;
            height: 36px;
            background: linear-gradient(135deg, #7952f5 0%, #a855f7 100%);
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #ffffff;
            box-shadow: 0 4px 14px var(--ut-purple-glow);
        }

        .ut-logo-text {
            font-size: 1.28rem;
            font-weight: 700;
            color: #ffffff;
            letter-spacing: -0.02em;
        }
        .ut-logo-text span {
            color: var(--ut-purple-light);
        }

        .ut-nav {
            display: flex;
            flex-direction: column;
            gap: 6px;
            flex: 1;
        }

        .ut-nav-item {
            display: flex;
            align-items: center;
            gap: 14px;
            padding: 11px 14px;
            border-radius: 10px;
            color: var(--ut-text-muted);
            text-decoration: none;
            font-size: 0.88rem;
            font-weight: 500;
            transition: all 0.2s ease;
        }

        .ut-nav-item:hover {
            color: var(--ut-text-white);
            background-color: rgba(255, 255, 255, 0.04);
        }

        .ut-nav-item.active {
            background: linear-gradient(135deg, #4f46e5 0%, #6366f1 100%);
            color: #ffffff;
            font-weight: 600;
            box-shadow: 0 4px 18px rgba(79, 70, 229, 0.4);
        }

        .ut-nav-item svg {
            width: 18px;
            height: 18px;
            stroke-width: 1.9;
            flex-shrink: 0;
        }

        .ut-sidebar-bottom {
            padding-top: 16px;
            border-top: 1px solid var(--ut-border);
        }

        .ut-nav-item.logout {
            color: #94a3b8;
        }
        .ut-nav-item.logout:hover {
            color: #ef4444;
            background-color: rgba(239, 68, 68, 0.08);
        }

        /* ------------------ MAIN CONTENT ------------------ */
        .ut-main {
            flex: 1;
            display: flex;
            flex-direction: column;
            min-width: 0;
            background-color: var(--ut-bg-app);
            position: relative;
            z-index: 1;
        }

        /* Top Bar */
        .ut-topbar {
            height: 70px;
            padding: 0 32px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 20px;
            border-bottom: 1px solid var(--ut-border);
            background-color: var(--ut-bg-app);
            position: sticky;
            top: 0;
            z-index: 15;
        }

        .ut-search-box {
            position: relative;
            width: 380px;
            max-width: 100%;
        }

        .ut-search-box input {
            width: 100%;
            height: 40px;
            background-color: rgba(255, 255, 255, 0.035);
            border: 1px solid var(--ut-border);
            border-radius: 999px;
            padding: 0 65px 0 42px;
            color: var(--ut-text-primary);
            font-size: 0.85rem;
            outline: none;
            box-sizing: border-box;
            transition: all 0.2s ease;
        }

        .ut-search-box input:focus {
            border-color: #6366f1;
            background-color: rgba(255, 255, 255, 0.06);
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.2);
        }

        .ut-search-box svg {
            position: absolute;
            left: 14px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--ut-text-dim);
            width: 16px;
            height: 16px;
        }

        .ut-search-kbd {
            position: absolute;
            right: 14px;
            top: 50%;
            transform: translateY(-50%);
            font-family: 'JetBrains Mono', monospace;
            font-size: 0.72rem;
            background: rgba(255, 255, 255, 0.06);
            color: var(--ut-text-muted);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 6px;
            padding: 2px 7px;
            pointer-events: none;
        }

        .ut-topbar-right {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .ut-notif-btn {
            position: relative;
            background: rgba(255, 255, 255, 0.035);
            border: 1px solid var(--ut-border);
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--ut-text-muted);
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .ut-notif-btn:hover {
            color: #ffffff;
            background-color: rgba(255, 255, 255, 0.07);
        }

        .ut-notif-dot {
            position: absolute;
            top: 9px;
            right: 10px;
            width: 8px;
            height: 8px;
            background-color: #f43f5e;
            border-radius: 50%;
            border: 2px solid var(--ut-bg-app);
        }

        .ut-profile-badge {
            display: flex;
            align-items: center;
            gap: 12px;
            cursor: pointer;
            text-decoration: none;
        }

        .ut-avatar {
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

        .ut-avatar img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .ut-profile-info {
            display: flex;
            flex-direction: column;
            line-height: 1.25;
        }

        .ut-profile-name {
            font-size: 0.9rem;
            font-weight: 600;
            color: #ffffff;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .ut-profile-sub {
            font-size: 0.75rem;
            color: var(--ut-text-muted);
        }

        /* ------------------ BODY CONTAINER ------------------ */
        .ut-container {
            padding: 24px 30px 40px;
            max-width: 1680px;
            margin: 0 auto;
            width: 100%;
            box-sizing: border-box;
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        /* ------------------ HEADER ROW ------------------ */
        .ut-header-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            flex-wrap: wrap;
        }

        .ut-title-wrap {
            display: flex;
            align-items: center;
            gap: 14px;
        }

        .ut-title-icon {
            width: 40px;
            height: 40px;
            border-radius: 10px;
            background: rgba(121, 82, 245, 0.18);
            color: var(--ut-purple-light);
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        .ut-title-text h1 {
            font-size: 1.85rem;
            font-weight: 800;
            color: #ffffff;
            letter-spacing: -0.02em;
            line-height: 1.2;
        }

        .ut-title-text p {
            font-size: 0.92rem;
            color: var(--ut-text-muted);
            margin-top: 2px;
        }

        .ut-header-actions {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .ut-add-btn {
            background: linear-gradient(135deg, #4f46e5 0%, #6366f1 100%);
            color: #ffffff;
            font-size: 0.85rem;
            font-weight: 600;
            padding: 9px 18px;
            border-radius: 8px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.2s ease;
            box-shadow: 0 4px 14px rgba(79, 70, 229, 0.35);
        }

        .ut-add-btn:hover {
            transform: translateY(-1px);
            box-shadow: 0 6px 18px rgba(79, 70, 229, 0.5);
            color: #ffffff;
        }

        .ut-back-btn {
            background: rgba(255, 255, 255, 0.04);
            border: 1px solid var(--ut-border);
            border-radius: 8px;
            color: var(--ut-text-primary);
            padding: 9px 16px;
            font-size: 0.85rem;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: all 0.2s ease;
        }

        .ut-back-btn:hover {
            background: rgba(255, 255, 255, 0.08);
            border-color: rgba(255, 255, 255, 0.15);
        }

        /* ------------------ ROW 1: 4 KPI CARDS ------------------ */
        .ut-kpi-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 18px;
            align-items: stretch;
        }

        .ut-kpi-card {
            background-color: var(--ut-bg-card);
            border: 1px solid var(--ut-border);
            border-radius: 14px;
            padding: 18px 22px;
            display: flex;
            align-items: center;
            gap: 18px;
            box-sizing: border-box;
            transition: all 0.25s ease;
        }

        .ut-kpi-card:hover {
            transform: translateY(-2px);
            border-color: var(--ut-border-hover);
            box-shadow: 0 10px 24px rgba(0, 0, 0, 0.35);
        }

        .ut-kpi-icon-wrap {
            width: 48px;
            height: 48px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        .ut-kpi-icon-wrap.purple {
            background: rgba(121, 82, 245, 0.22);
            color: #a855f7;
        }
        .ut-kpi-icon-wrap.red {
            background: rgba(244, 63, 94, 0.22);
            color: #fb7185;
        }
        .ut-kpi-icon-wrap.amber {
            background: rgba(245, 158, 11, 0.22);
            color: #fbbf24;
        }
        .ut-kpi-icon-wrap.blue {
            background: rgba(56, 189, 248, 0.22);
            color: #38bdf8;
        }

        .ut-kpi-info {
            display: flex;
            flex-direction: column;
        }

        .ut-kpi-title {
            font-size: 0.82rem;
            color: var(--ut-text-muted);
            font-weight: 500;
        }

        .ut-kpi-value {
            font-size: 1.85rem;
            font-weight: 800;
            color: #ffffff;
            line-height: 1.15;
            margin: 2px 0;
        }

        .ut-kpi-sub {
            font-size: 0.75rem;
            color: var(--ut-text-muted);
        }

        /* ------------------ FILTER & SORT BAR ------------------ */
        .ut-filter-bar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            flex-wrap: wrap;
        }

        .ut-filter-tabs {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .ut-tab-btn {
            background: rgba(255, 255, 255, 0.035);
            border: 1px solid var(--ut-border);
            border-radius: 999px;
            color: var(--ut-text-muted);
            padding: 7px 16px;
            font-size: 0.8rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .ut-tab-btn:hover {
            color: #ffffff;
            background: rgba(255, 255, 255, 0.06);
        }

        .ut-tab-btn.active {
            background: linear-gradient(135deg, #4f46e5 0%, #6366f1 100%);
            color: #ffffff;
            border-color: transparent;
            box-shadow: 0 2px 12px rgba(79, 70, 229, 0.4);
        }

        .ut-filter-selects {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .ut-select-btn {
            background: rgba(255, 255, 255, 0.035);
            border: 1px solid var(--ut-border);
            border-radius: 8px;
            color: var(--ut-text-muted);
            padding: 7px 14px;
            font-size: 0.8rem;
            font-weight: 500;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 6px;
            transition: all 0.2s ease;
        }

        .ut-select-btn:hover {
            color: #ffffff;
            background: rgba(255, 255, 255, 0.06);
            border-color: rgba(255, 255, 255, 0.15);
        }

        /* ------------------ MAIN TWO-COLUMN GRID ------------------ */
        .ut-main-grid {
            display: grid;
            grid-template-columns: minmax(0, 1.8fr) 360px;
            gap: 20px;
            align-items: start;
        }

        .ut-left-col {
            display: flex;
            flex-direction: column;
            gap: 16px;
            min-width: 0;
        }

        .ut-right-col {
            display: flex;
            flex-direction: column;
            gap: 20px;
            min-width: 0;
        }

        /* ------------------ TASK ROWS LIST ------------------ */
        .ut-task-row {
            background-color: var(--ut-bg-card);
            border: 1px solid var(--ut-border);
            border-radius: 14px;
            padding: 16px 20px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            box-sizing: border-box;
            transition: all 0.2s ease;
        }

        .ut-task-row:hover {
            border-color: var(--ut-border-hover);
            background-color: var(--ut-bg-card-hover);
            transform: translateX(2px);
        }

        .ut-task-left {
            display: flex;
            align-items: center;
            gap: 14px;
            flex: 1;
            min-width: 0;
        }

        .ut-task-checkbox {
            width: 20px;
            height: 20px;
            border-radius: 50%;
            border: 2px solid var(--ut-text-dim);
            cursor: pointer;
            transition: all 0.2s ease;
            flex-shrink: 0;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .ut-task-checkbox:hover {
            border-color: var(--ut-purple-light);
        }

        .ut-task-checkbox.checked {
            background-color: var(--ut-green);
            border-color: var(--ut-green);
            color: #ffffff;
        }

        .ut-task-icon {
            width: 38px;
            height: 38px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }
        .ut-task-icon.purple { background: rgba(121, 82, 245, 0.2); color: #c4b5fd; }
        .ut-task-icon.green { background: rgba(16, 185, 129, 0.2); color: #6ee7b7; }
        .ut-task-icon.lilac { background: rgba(168, 85, 247, 0.2); color: #d8b4fe; }
        .ut-task-icon.violet { background: rgba(99, 102, 241, 0.2); color: #a5b4fc; }
        .ut-task-icon.coral { background: rgba(244, 63, 94, 0.2); color: #fca5a5; }
        .ut-task-icon.blue { background: rgba(56, 189, 248, 0.2); color: #7dd3fc; }

        .ut-task-text {
            flex: 1;
            min-width: 0;
        }

        .ut-task-title {
            font-size: 0.92rem;
            font-weight: 600;
            color: #ffffff;
            line-height: 1.3;
            transition: all 0.2s ease;
        }

        .ut-task-title.completed {
            text-decoration: line-through;
            color: var(--ut-text-dim);
        }

        .ut-task-sub {
            font-size: 0.76rem;
            color: var(--ut-text-muted);
            margin-top: 3px;
        }

        .ut-task-right {
            display: flex;
            align-items: center;
            gap: 14px;
            flex-shrink: 0;
        }

        .ut-priority-badge {
            font-size: 0.75rem;
            font-weight: 600;
            padding: 4px 12px;
            border-radius: 6px;
            white-space: nowrap;
        }

        .ut-priority-badge.high {
            background: rgba(244, 63, 94, 0.16);
            color: #fb7185;
            border: 1px solid rgba(244, 63, 94, 0.3);
        }

        .ut-priority-badge.medium {
            background: rgba(245, 158, 11, 0.16);
            color: #fcd34d;
            border: 1px solid rgba(245, 158, 11, 0.3);
        }

        .ut-priority-badge.low {
            background: rgba(56, 189, 248, 0.16);
            color: #7dd3fc;
            border: 1px solid rgba(56, 189, 248, 0.3);
        }

        .ut-due-pill {
            background: rgba(255, 255, 255, 0.04);
            border: 1px solid var(--ut-border);
            border-radius: 8px;
            padding: 5px 10px;
            display: flex;
            align-items: center;
            gap: 6px;
            font-size: 0.76rem;
            color: var(--ut-text-muted);
            font-weight: 500;
            white-space: nowrap;
        }

        .ut-due-pill svg {
            color: var(--ut-purple-light);
            width: 14px;
            height: 14px;
        }

        .ut-kebab-btn {
            background: transparent;
            border: none;
            color: var(--ut-text-dim);
            cursor: pointer;
            padding: 4px;
            font-size: 1.15rem;
            line-height: 1;
            transition: color 0.2s ease;
        }

        .ut-kebab-btn:hover {
            color: #ffffff;
        }

        /* ------------------ PAGINATION ------------------ */
        .ut-pagination {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 8px 4px;
            font-size: 0.82rem;
            color: var(--ut-text-muted);
        }

        .ut-page-btns {
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .ut-page-btn {
            background: rgba(255, 255, 255, 0.04);
            border: 1px solid var(--ut-border);
            border-radius: 6px;
            width: 32px;
            height: 32px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--ut-text-primary);
            font-size: 0.82rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .ut-page-btn:hover {
            background: rgba(255, 255, 255, 0.08);
            border-color: rgba(255, 255, 255, 0.15);
        }

        .ut-page-btn.active {
            background: #6366f1;
            color: #ffffff;
            border-color: transparent;
            box-shadow: 0 2px 10px rgba(99, 102, 241, 0.4);
        }

        /* ------------------ RIGHT: ADD NEW TASK FORM CARD ------------------ */
        .ut-card {
            background-color: var(--ut-bg-card);
            border: 1px solid var(--ut-border);
            border-radius: 14px;
            padding: 22px;
            box-sizing: border-box;
            position: relative;
        }

        .ut-card-header {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 18px;
        }

        .ut-card-header svg {
            color: var(--ut-purple-light);
            width: 18px;
            height: 18px;
        }

        .ut-card-title {
            font-size: 1.02rem;
            font-weight: 700;
            color: #ffffff;
        }

        .ut-form-group {
            margin-bottom: 14px;
        }

        .ut-label {
            display: block;
            font-size: 0.78rem;
            font-weight: 600;
            color: var(--ut-text-muted);
            margin-bottom: 6px;
        }

        .ut-label span.req {
            color: #f43f5e;
        }

        .ut-input, .ut-select, .ut-textarea {
            width: 100%;
            background: rgba(255, 255, 255, 0.035);
            border: 1px solid var(--ut-border);
            border-radius: 8px;
            padding: 9px 12px;
            font-size: 0.82rem;
            color: var(--ut-text-primary);
            outline: none;
            box-sizing: border-box;
            transition: all 0.2s ease;
            font-family: inherit;
        }

        .ut-input:focus, .ut-select:focus, .ut-textarea:focus {
            border-color: #6366f1;
            background: rgba(255, 255, 255, 0.06);
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.2);
        }

        .ut-input-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 10px;
        }

        .ut-input-icon-wrap {
            position: relative;
        }

        .ut-input-icon-wrap svg {
            position: absolute;
            left: 10px;
            top: 50%;
            transform: translateY(-50%);
            width: 14px;
            height: 14px;
            color: var(--ut-text-dim);
            pointer-events: none;
        }

        .ut-input-icon-wrap input {
            padding-left: 32px;
        }

        .ut-priority-select-row {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 8px;
        }

        .ut-prio-btn {
            background: rgba(255, 255, 255, 0.035);
            border: 1px solid var(--ut-border);
            border-radius: 8px;
            padding: 8px 6px;
            font-size: 0.78rem;
            font-weight: 600;
            color: var(--ut-text-muted);
            cursor: pointer;
            text-align: center;
            transition: all 0.2s ease;
        }

        .ut-prio-btn.active.high {
            background: rgba(244, 63, 94, 0.16);
            color: #fb7185;
            border-color: rgba(244, 63, 94, 0.5);
        }

        .ut-prio-btn.active.medium {
            background: rgba(245, 158, 11, 0.16);
            color: #fcd34d;
            border-color: rgba(245, 158, 11, 0.5);
        }

        .ut-prio-btn.active.low {
            background: rgba(56, 189, 248, 0.16);
            color: #7dd3fc;
            border-color: rgba(56, 189, 248, 0.5);
        }

        .ut-textarea {
            resize: vertical;
            min-height: 64px;
        }

        .ut-form-actions {
            display: flex;
            align-items: center;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 18px;
        }

        .ut-btn-cancel {
            background: transparent;
            border: 1px solid var(--ut-border);
            border-radius: 8px;
            color: var(--ut-text-primary);
            padding: 8px 16px;
            font-size: 0.82rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .ut-btn-cancel:hover {
            background: rgba(255, 255, 255, 0.05);
        }

        .ut-btn-submit {
            background: linear-gradient(135deg, #4f46e5 0%, #6366f1 100%);
            border: none;
            border-radius: 8px;
            color: #ffffff;
            padding: 8px 18px;
            font-size: 0.82rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s ease;
            box-shadow: 0 2px 10px rgba(79, 70, 229, 0.35);
        }

        .ut-btn-submit:hover {
            box-shadow: 0 4px 14px rgba(79, 70, 229, 0.5);
            transform: translateY(-1px);
        }

        /* ------------------ TASK COMPLETION DONUT CARD ------------------ */
        .ut-donut-wrap {
            display: flex;
            align-items: center;
            justify-content: space-around;
            gap: 16px;
            margin-top: 6px;
        }

        .ut-donut-svg-box {
            position: relative;
            width: 120px;
            height: 120px;
            flex-shrink: 0;
        }

        .ut-donut-svg {
            width: 100%;
            height: 100%;
            transform: rotate(-90deg);
        }

        .ut-donut-center {
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

        .ut-donut-pct {
            font-size: 1.35rem;
            font-weight: 800;
            color: #ffffff;
            line-height: 1;
        }

        .ut-donut-sub {
            font-size: 0.7rem;
            color: var(--ut-text-muted);
            margin-top: 3px;
        }

        .ut-donut-legend {
            display: flex;
            flex-direction: column;
            gap: 12px;
            flex: 1;
        }

        .ut-donut-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 10px;
            font-size: 0.82rem;
        }

        .ut-donut-left {
            display: flex;
            align-items: center;
            gap: 8px;
            color: var(--ut-text-primary);
        }

        .ut-legend-dot {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            flex-shrink: 0;
        }
        .ut-legend-dot.green { background-color: #10b981; }
        .ut-legend-dot.purple { background-color: #a855f7; }
        .ut-legend-dot.blue { background-color: #38bdf8; }

        .ut-donut-num {
            color: var(--ut-text-muted);
            font-weight: 600;
            font-family: 'JetBrains Mono', monospace;
        }

        /* Responsive Breakpoints */
        @media (max-width: 1200px) {
            .ut-main-grid {
                grid-template-columns: 1fr;
            }
            .ut-kpi-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 768px) {
            .ut-sidebar {
                display: none;
            }
            .ut-kpi-grid {
                grid-template-columns: 1fr;
            }
            .ut-container {
                padding: 16px;
            }
            .ut-topbar {
                padding: 0 16px;
            }
        }
    </style>
</head>
<body>

<div class="ut-layout">
    <!-- ======================================================== -->
    <!-- LEFT SIDEBAR                                             -->
    <!-- ======================================================== -->
    <aside class="ut-sidebar">
        <div>
            <!-- Logo -->
            <a href="${pageContext.request.contextPath}/dashboard" class="ut-logo">
                <div class="ut-logo-icon">
                    <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                        <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                        <line x1="16" y1="2" x2="16" y2="6"></line>
                        <line x1="8" y1="2" x2="8" y2="6"></line>
                        <line x1="3" y1="10" x2="21" y2="10"></line>
                        <path d="M8 14h.01M12 14h.01M16 14h.01M8 18h.01M12 18h.01M16 18h.01"></path>
                    </svg>
                </div>
                <div class="ut-logo-text">Slot<span>Wise</span></div>
            </a>

            <!-- Navigation Links -->
            <nav class="ut-nav">
                <!-- Dashboard (ACTIVE) -->
                <a href="${pageContext.request.contextPath}/dashboard" class="ut-nav-item active">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path>
                        <polyline points="9 22 9 12 15 12 15 22"></polyline>
                    </svg>
                    <span>Dashboard</span>
                </a>

                <!-- Timetable -->
                <a href="${pageContext.request.contextPath}/timetable" class="ut-nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                        <line x1="16" y1="2" x2="16" y2="6"></line>
                        <line x1="8" y1="2" x2="8" y2="6"></line>
                        <line x1="3" y1="10" x2="21" y2="10"></line>
                    </svg>
                    <span>Timetable</span>
                </a>

                <!-- My Tasks -->
                <a href="${pageContext.request.contextPath}/tasks" class="ut-nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M9 11l3 3L22 4"></path>
                        <path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"></path>
                    </svg>
                    <span>My Tasks</span>
                </a>

                <!-- Smart Planner -->
                <a href="${pageContext.request.contextPath}/planner" class="ut-nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="12" cy="12" r="2"></circle>
                        <path d="M16.24 7.76a6 6 0 0 1 0 8.49m-8.48-.01a6 6 0 0 1 0-8.49m11.31-2.82a10 10 0 0 1 0 14.14m-14.14 0a10 10 0 0 1 0-14.14"></path>
                    </svg>
                    <span>Smart Planner</span>
                </a>

                <!-- Progress -->
                <a href="${pageContext.request.contextPath}/progress" class="ut-nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <line x1="18" y1="20" x2="18" y2="10"></line>
                        <line x1="12" y1="20" x2="12" y2="4"></line>
                        <line x1="6" y1="20" x2="6" y2="14"></line>
                    </svg>
                    <span>Progress</span>
                </a>

                <!-- Materials -->
                <a href="${pageContext.request.contextPath}/materials.jsp" class="ut-nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path>
                        <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path>
                    </svg>
                    <span>Materials</span>
                </a>

                <!-- Study Groups -->
                <a href="${pageContext.request.contextPath}/study-groups.jsp" class="ut-nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                        <circle cx="9" cy="7" r="4"></circle>
                        <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                        <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                    </svg>
                    <span>Study Groups</span>
                </a>

                <!-- Goals -->
                <a href="${pageContext.request.contextPath}/goals.jsp" class="ut-nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
                    </svg>
                    <span>Goals</span>
                </a>

                <!-- Settings -->
                <a href="${pageContext.request.contextPath}/settings" class="ut-nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="12" cy="12" r="3"></circle>
                        <path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z"></path>
                    </svg>
                    <span>Settings</span>
                </a>
            </nav>
        </div>

        <!-- Logout -->
        <div class="ut-sidebar-bottom">
            <a href="${pageContext.request.contextPath}/logout" class="ut-nav-item logout">
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
    <main class="ut-main">
        <!-- Top Navigation Bar -->
        <header class="ut-topbar">
            <!-- Search Box -->
            <div class="ut-search-box">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                    <circle cx="11" cy="11" r="8"></circle>
                    <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                </svg>
                <input type="text" id="utSearchInput" placeholder="Search tasks, subjects, or keywords..." autocomplete="off">
                <span class="ut-search-kbd">Ctrl K</span>
            </div>

            <!-- Right Controls -->
            <div class="ut-topbar-right">
                <button class="ut-notif-btn" title="Notifications">
                    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"></path>
                        <path d="M13.73 21a2 2 0 0 1-3.46 0"></path>
                    </svg>
                    <span class="ut-notif-dot"></span>
                </button>

                <a href="${pageContext.request.contextPath}/settings" class="ut-profile-badge">
                    <div class="ut-avatar">
                        <img src="https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100&auto=format&fit=crop&q=80" alt="Harish M" onerror="this.style.display='none'; this.parentNode.innerHTML='H';">
                    </div>
                    <div class="ut-profile-info">
                        <span class="ut-profile-name">
                            <c:out value="${sessionScope.studentName != null ? sessionScope.studentName : 'Harish M'}"/>
                            <svg viewBox="0 0 24 24" width="12" height="12" fill="none" stroke="currentColor" stroke-width="2">
                                <polyline points="6 9 12 15 18 9"></polyline>
                            </svg>
                        </span>
                        <span class="ut-profile-sub"><c:out value="${sessionScope.yearOfStudy != null ? sessionScope.yearOfStudy : 'CSE - 2nd Year'}"/></span>
                    </div>
                </a>
            </div>
        </header>

        <!-- Body Container -->
        <div class="ut-container">

            <!-- ==================================================== -->
            <!-- HEADER ROW                                           -->
            <!-- ==================================================== -->
            <div class="ut-header-row">
                <div class="ut-title-wrap">
                    <div class="ut-title-icon">
                        <svg viewBox="0 0 24 24" width="22" height="22" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                            <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                            <line x1="16" y1="2" x2="16" y2="6"></line>
                            <line x1="8" y1="2" x2="8" y2="6"></line>
                            <polyline points="9 13 11 15 15 11"></polyline>
                        </svg>
                    </div>
                    <div class="ut-title-text">
                        <h1>Upcoming Tasks</h1>
                        <p>All your upcoming tasks in one place. Plan, track, and complete them on time.</p>
                    </div>
                </div>

                <div class="ut-header-actions">
                    <a href="${pageContext.request.contextPath}/dashboard" class="ut-back-btn">
                        <span>&larr;</span>
                        <span>Back to Dashboard</span>
                    </a>
                    <button class="ut-add-btn" onclick="document.getElementById('taskTitleInput').focus()">
                        <span>+</span>
                        <span>Add New Task</span>
                    </button>
                </div>
            </div>

            <!-- ==================================================== -->
            <!-- ROW 1: 4 KPI CARDS                                   -->
            <!-- ==================================================== -->
            <div class="ut-kpi-grid">
                <!-- Card 1: Total Upcoming -->
                <div class="ut-kpi-card">
                    <div class="ut-kpi-icon-wrap purple">
                        <svg viewBox="0 0 24 24" width="22" height="22" fill="none" stroke="currentColor" stroke-width="2.2">
                            <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                            <line x1="16" y1="2" x2="16" y2="6"></line>
                            <line x1="8" y1="2" x2="8" y2="6"></line>
                            <polyline points="9 13 11 15 15 11"></polyline>
                        </svg>
                    </div>
                    <div class="ut-kpi-info">
                        <div class="ut-kpi-title">Total Upcoming</div>
                        <div class="ut-kpi-value" id="kpiTotalUpcoming">12</div>
                        <div class="ut-kpi-sub">tasks</div>
                    </div>
                </div>

                <!-- Card 2: High Priority -->
                <div class="ut-kpi-card">
                    <div class="ut-kpi-icon-wrap red">
                        <svg viewBox="0 0 24 24" width="22" height="22" fill="none" stroke="currentColor" stroke-width="2.5">
                            <circle cx="12" cy="12" r="10"></circle>
                            <line x1="12" y1="8" x2="12" y2="12"></line>
                            <line x1="12" y1="16" x2="12.01" y2="16"></line>
                        </svg>
                    </div>
                    <div class="ut-kpi-info">
                        <div class="ut-kpi-title">High Priority</div>
                        <div class="ut-kpi-value" id="kpiHighPriority">3</div>
                        <div class="ut-kpi-sub">tasks</div>
                    </div>
                </div>

                <!-- Card 3: Medium Priority -->
                <div class="ut-kpi-card">
                    <div class="ut-kpi-icon-wrap amber">
                        <svg viewBox="0 0 24 24" width="22" height="22" fill="none" stroke="currentColor" stroke-width="2.2">
                            <path d="M4 15s1-1 4-1 5 2 8 2 4-1 4-1V3s-1 1-4 1-5-2-8-2-4 1-4 1z"></path>
                            <line x1="4" y1="22" x2="4" y2="15"></line>
                        </svg>
                    </div>
                    <div class="ut-kpi-info">
                        <div class="ut-kpi-title">Medium Priority</div>
                        <div class="ut-kpi-value" id="kpiMediumPriority">5</div>
                        <div class="ut-kpi-sub">tasks</div>
                    </div>
                </div>

                <!-- Card 4: Low Priority -->
                <div class="ut-kpi-card">
                    <div class="ut-kpi-icon-wrap blue">
                        <svg viewBox="0 0 24 24" width="22" height="22" fill="none" stroke="currentColor" stroke-width="2.2">
                            <line x1="18" y1="20" x2="18" y2="10"></line>
                            <line x1="12" y1="20" x2="12" y2="4"></line>
                            <line x1="6" y1="20" x2="6" y2="14"></line>
                        </svg>
                    </div>
                    <div class="ut-kpi-info">
                        <div class="ut-kpi-title">Low Priority</div>
                        <div class="ut-kpi-value" id="kpiLowPriority">4</div>
                        <div class="ut-kpi-sub">tasks</div>
                    </div>
                </div>
            </div>

            <!-- ==================================================== -->
            <!-- FILTER & SORT BAR                                    -->
            <!-- ==================================================== -->
            <div class="ut-filter-bar">
                <div class="ut-filter-tabs">
                    <button class="ut-tab-btn active" onclick="filterByPriority('all', this)">All Tasks (12)</button>
                    <button class="ut-tab-btn" onclick="filterByPriority('high', this)">High (3)</button>
                    <button class="ut-tab-btn" onclick="filterByPriority('medium', this)">Medium (5)</button>
                    <button class="ut-tab-btn" onclick="filterByPriority('low', this)">Low (4)</button>
                </div>

                <div class="ut-filter-selects">
                    <button class="ut-select-btn" id="sortByBtn" onclick="toggleSort()">
                        <span>Sort By: Due Date (Earliest)</span>
                        <span>&blacktriangledown;</span>
                    </button>
                    <button class="ut-select-btn" id="subjectFilterBtn" onclick="toggleSubjectFilter()">
                        <span>Subject: All Subjects</span>
                        <span>&blacktriangledown;</span>
                    </button>
                </div>
            </div>

            <!-- ==================================================== -->
            <!-- MAIN TWO-COLUMN GRID                                 -->
            <!-- ==================================================== -->
            <div class="ut-main-grid">

                <!-- ---------------- LEFT COLUMN: TASK ROWS LIST ---------------- -->
                <div class="ut-left-col">
                    <div id="utTasksContainer" style="display: flex; flex-direction: column; gap: 12px;">

                        <!-- Task 1: Complete DBMS Assignment -->
                        <div class="ut-task-row" data-priority="high" data-subject="Database Systems" data-date="2026-10-20" data-page="1">
                            <div class="ut-task-left">
                                <div class="ut-task-checkbox" onclick="toggleRowCheckbox(this)"></div>
                                <div class="ut-task-icon purple">
                                    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2">
                                        <ellipse cx="12" cy="5" rx="9" ry="3"></ellipse>
                                        <path d="M21 12c0 1.66-4 3-9 3s-9-1.34-9-3"></path>
                                        <path d="M3 5v14c0 1.66 4 3 9 3s9-1.34 9-3V5"></path>
                                    </svg>
                                </div>
                                <div class="ut-task-text">
                                    <div class="ut-task-title">Complete DBMS Assignment</div>
                                    <div class="ut-task-sub">Database Systems &bull; Submission: 20 Oct 2026, 11:59 PM</div>
                                </div>
                            </div>
                            <div class="ut-task-right">
                                <span class="ut-priority-badge high">High</span>
                                <div class="ut-due-pill">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                        <line x1="16" y1="2" x2="16" y2="6"></line>
                                        <line x1="8" y1="2" x2="8" y2="6"></line>
                                    </svg>
                                    <span>20 Oct</span>
                                </div>
                                <button class="ut-kebab-btn" title="Options" onclick="handleKebab(this)">&bull;&bull;&bull;</button>
                            </div>
                        </div>

                        <!-- Task 2: Revise Java Notes -->
                        <div class="ut-task-row" data-priority="medium" data-subject="Object Oriented Programming" data-date="2026-10-21" data-page="1">
                            <div class="ut-task-left">
                                <div class="ut-task-checkbox" onclick="toggleRowCheckbox(this)"></div>
                                <div class="ut-task-icon green">
                                    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2">
                                        <polyline points="16 18 22 12 16 6"></polyline>
                                        <polyline points="8 6 2 12 8 18"></polyline>
                                    </svg>
                                </div>
                                <div class="ut-task-text">
                                    <div class="ut-task-title">Revise Java Notes</div>
                                    <div class="ut-task-sub">Object Oriented Programming &bull; Target: 21 Oct 2026, 02:00 PM</div>
                                </div>
                            </div>
                            <div class="ut-task-right">
                                <span class="ut-priority-badge medium">Medium</span>
                                <div class="ut-due-pill">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                        <line x1="16" y1="2" x2="16" y2="6"></line>
                                        <line x1="8" y1="2" x2="8" y2="6"></line>
                                    </svg>
                                    <span>21 Oct</span>
                                </div>
                                <button class="ut-kebab-btn" title="Options" onclick="handleKebab(this)">&bull;&bull;&bull;</button>
                            </div>
                        </div>

                        <!-- Task 3: Prepare Lab Record -->
                        <div class="ut-task-row" data-priority="medium" data-subject="Operating Systems" data-date="2026-10-21" data-page="1">
                            <div class="ut-task-left">
                                <div class="ut-task-checkbox" onclick="toggleRowCheckbox(this)"></div>
                                <div class="ut-task-icon lilac">
                                    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M10 2v7.31L4.69 19.3A2 2 0 0 0 6.44 22h11.12a2 2 0 0 0 1.75-2.7L14 9.31V2"></path>
                                        <line x1="8.5" y1="2" x2="15.5" y2="2"></line>
                                    </svg>
                                </div>
                                <div class="ut-task-text">
                                    <div class="ut-task-title">Prepare Lab Record</div>
                                    <div class="ut-task-sub">Operating Systems &bull; Submission: 21 Oct 2026, 04:00 PM</div>
                                </div>
                            </div>
                            <div class="ut-task-right">
                                <span class="ut-priority-badge medium">Medium</span>
                                <div class="ut-due-pill">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                        <line x1="16" y1="2" x2="16" y2="6"></line>
                                        <line x1="8" y1="2" x2="8" y2="6"></line>
                                    </svg>
                                    <span>21 Oct</span>
                                </div>
                                <button class="ut-kebab-btn" title="Options" onclick="handleKebab(this)">&bull;&bull;&bull;</button>
                            </div>
                        </div>

                        <!-- Task 4: Read Research Paper -->
                        <div class="ut-task-row" data-priority="low" data-subject="Self Learning" data-date="2026-10-22" data-page="1">
                            <div class="ut-task-left">
                                <div class="ut-task-checkbox" onclick="toggleRowCheckbox(this)"></div>
                                <div class="ut-task-icon violet">
                                    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path>
                                        <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path>
                                    </svg>
                                </div>
                                <div class="ut-task-text">
                                    <div class="ut-task-title">Read Research Paper</div>
                                    <div class="ut-task-sub">Self Learning &bull; Target: 22 Oct 2026, 06:00 PM</div>
                                </div>
                            </div>
                            <div class="ut-task-right">
                                <span class="ut-priority-badge low">Low</span>
                                <div class="ut-due-pill">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                        <line x1="16" y1="2" x2="16" y2="6"></line>
                                        <line x1="8" y1="2" x2="8" y2="6"></line>
                                    </svg>
                                    <span>22 Oct</span>
                                </div>
                                <button class="ut-kebab-btn" title="Options" onclick="handleKebab(this)">&bull;&bull;&bull;</button>
                            </div>
                        </div>

                        <!-- Task 5: Complete DSA Practice -->
                        <div class="ut-task-row" data-priority="high" data-subject="Data Structures" data-date="2026-10-23" data-page="1">
                            <div class="ut-task-left">
                                <div class="ut-task-checkbox" onclick="toggleRowCheckbox(this)"></div>
                                <div class="ut-task-icon coral">
                                    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                                        <circle cx="9" cy="7" r="4"></circle>
                                        <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                                        <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                                    </svg>
                                </div>
                                <div class="ut-task-text">
                                    <div class="ut-task-title">Complete DSA Practice</div>
                                    <div class="ut-task-sub">Data Structures &bull; Target: 23 Oct 2026, 12:00 PM</div>
                                </div>
                            </div>
                            <div class="ut-task-right">
                                <span class="ut-priority-badge high">High</span>
                                <div class="ut-due-pill">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                        <line x1="16" y1="2" x2="16" y2="6"></line>
                                        <line x1="8" y1="2" x2="8" y2="6"></line>
                                    </svg>
                                    <span>23 Oct</span>
                                </div>
                                <button class="ut-kebab-btn" title="Options" onclick="handleKebab(this)">&bull;&bull;&bull;</button>
                            </div>
                        </div>

                        <!-- Task 6: Update Project Documentation -->
                        <div class="ut-task-row" data-priority="medium" data-subject="POPs and DBMS Project" data-date="2026-10-24" data-page="1">
                            <div class="ut-task-left">
                                <div class="ut-task-checkbox" onclick="toggleRowCheckbox(this)"></div>
                                <div class="ut-task-icon blue">
                                    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                                        <polyline points="14 2 14 8 20 8"></polyline>
                                        <line x1="16" y1="13" x2="8" y2="13"></line>
                                        <line x1="16" y1="17" x2="8" y2="17"></line>
                                    </svg>
                                </div>
                                <div class="ut-task-text">
                                    <div class="ut-task-title">Update Project Documentation</div>
                                    <div class="ut-task-sub">POPs and DBMS Project &bull; Target: 24 Oct 2026, 05:00 PM</div>
                                </div>
                            </div>
                            <div class="ut-task-right">
                                <span class="ut-priority-badge medium">Medium</span>
                                <div class="ut-due-pill">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                        <line x1="16" y1="2" x2="16" y2="6"></line>
                                        <line x1="8" y1="2" x2="8" y2="6"></line>
                                    </svg>
                                    <span>24 Oct</span>
                                </div>
                                <button class="ut-kebab-btn" title="Options" onclick="handleKebab(this)">&bull;&bull;&bull;</button>
                            </div>
                        </div>

                        <!-- Page 2 Tasks (Hidden on page 1) -->
                        <div class="ut-task-row" data-priority="high" data-subject="Software Engineering" data-date="2026-10-25" data-page="2" style="display: none;">
                            <div class="ut-task-left">
                                <div class="ut-task-checkbox" onclick="toggleRowCheckbox(this)"></div>
                                <div class="ut-task-icon coral">
                                    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2">
                                        <polyline points="16 18 22 12 16 6"></polyline>
                                        <polyline points="8 6 2 12 8 18"></polyline>
                                    </svg>
                                </div>
                                <div class="ut-task-text">
                                    <div class="ut-task-title">Design Class Diagrams</div>
                                    <div class="ut-task-sub">Software Engineering &bull; Target: 25 Oct 2026, 03:00 PM</div>
                                </div>
                            </div>
                            <div class="ut-task-right">
                                <span class="ut-priority-badge high">High</span>
                                <div class="ut-due-pill">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                        <line x1="16" y1="2" x2="16" y2="6"></line>
                                        <line x1="8" y1="2" x2="8" y2="6"></line>
                                    </svg>
                                    <span>25 Oct</span>
                                </div>
                                <button class="ut-kebab-btn" title="Options" onclick="handleKebab(this)">&bull;&bull;&bull;</button>
                            </div>
                        </div>

                        <div class="ut-task-row" data-priority="medium" data-subject="Mathematics" data-date="2026-10-26" data-page="2" style="display: none;">
                            <div class="ut-task-left">
                                <div class="ut-task-checkbox" onclick="toggleRowCheckbox(this)"></div>
                                <div class="ut-task-icon lilac">
                                    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2">
                                        <line x1="18" y1="20" x2="18" y2="10"></line>
                                        <line x1="12" y1="20" x2="12" y2="4"></line>
                                        <line x1="6" y1="20" x2="6" y2="14"></line>
                                    </svg>
                                </div>
                                <div class="ut-task-text">
                                    <div class="ut-task-title">Solve Calculus Assignment 4</div>
                                    <div class="ut-task-sub">Mathematics &bull; Target: 26 Oct 2026, 06:00 PM</div>
                                </div>
                            </div>
                            <div class="ut-task-right">
                                <span class="ut-priority-badge medium">Medium</span>
                                <div class="ut-due-pill">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                        <line x1="16" y1="2" x2="16" y2="6"></line>
                                        <line x1="8" y1="2" x2="8" y2="6"></line>
                                    </svg>
                                    <span>26 Oct</span>
                                </div>
                                <button class="ut-kebab-btn" title="Options" onclick="handleKebab(this)">&bull;&bull;&bull;</button>
                            </div>
                        </div>

                        <div class="ut-task-row" data-priority="low" data-subject="Computer Networks" data-date="2026-10-27" data-page="2" style="display: none;">
                            <div class="ut-task-left">
                                <div class="ut-task-checkbox" onclick="toggleRowCheckbox(this)"></div>
                                <div class="ut-task-icon green">
                                    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2">
                                        <rect x="2" y="2" width="6" height="6" rx="1"></rect>
                                        <rect x="16" y="2" width="6" height="6" rx="1"></rect>
                                        <rect x="9" y="16" width="6" height="6" rx="1"></rect>
                                    </svg>
                                </div>
                                <div class="ut-task-text">
                                    <div class="ut-task-title">Review Subnetting Notes</div>
                                    <div class="ut-task-sub">Computer Networks &bull; Target: 27 Oct 2026, 11:00 AM</div>
                                </div>
                            </div>
                            <div class="ut-task-right">
                                <span class="ut-priority-badge low">Low</span>
                                <div class="ut-due-pill">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                        <line x1="16" y1="2" x2="16" y2="6"></line>
                                        <line x1="8" y1="2" x2="8" y2="6"></line>
                                    </svg>
                                    <span>27 Oct</span>
                                </div>
                                <button class="ut-kebab-btn" title="Options" onclick="handleKebab(this)">&bull;&bull;&bull;</button>
                            </div>
                        </div>

                        <div class="ut-task-row" data-priority="medium" data-subject="Personal" data-date="2026-10-28" data-page="2" style="display: none;">
                            <div class="ut-task-left">
                                <div class="ut-task-checkbox" onclick="toggleRowCheckbox(this)"></div>
                                <div class="ut-task-icon blue">
                                    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2">
                                        <polyline points="9 11 12 14 22 4"></polyline>
                                        <path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"></path>
                                    </svg>
                                </div>
                                <div class="ut-task-text">
                                    <div class="ut-task-title">Organize Study Materials Folder</div>
                                    <div class="ut-task-sub">Personal &bull; Target: 28 Oct 2026, 08:00 PM</div>
                                </div>
                            </div>
                            <div class="ut-task-right">
                                <span class="ut-priority-badge medium">Medium</span>
                                <div class="ut-due-pill">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                        <line x1="16" y1="2" x2="16" y2="6"></line>
                                        <line x1="8" y1="2" x2="8" y2="6"></line>
                                    </svg>
                                    <span>28 Oct</span>
                                </div>
                                <button class="ut-kebab-btn" title="Options" onclick="handleKebab(this)">&bull;&bull;&bull;</button>
                            </div>
                        </div>

                        <div class="ut-task-row" data-priority="low" data-subject="Self Learning" data-date="2026-10-29" data-page="2" style="display: none;">
                            <div class="ut-task-left">
                                <div class="ut-task-checkbox" onclick="toggleRowCheckbox(this)"></div>
                                <div class="ut-task-icon purple">
                                    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2">
                                        <circle cx="12" cy="12" r="10"></circle>
                                        <line x1="12" y1="16" x2="12" y2="12"></line>
                                        <line x1="12" y1="8" x2="12.01" y2="8"></line>
                                    </svg>
                                </div>
                                <div class="ut-task-text">
                                    <div class="ut-task-title">Explore Web Development Tools</div>
                                    <div class="ut-task-sub">Self Learning &bull; Target: 29 Oct 2026, 05:00 PM</div>
                                </div>
                            </div>
                            <div class="ut-task-right">
                                <span class="ut-priority-badge low">Low</span>
                                <div class="ut-due-pill">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                        <line x1="16" y1="2" x2="16" y2="6"></line>
                                        <line x1="8" y1="2" x2="8" y2="6"></line>
                                    </svg>
                                    <span>29 Oct</span>
                                </div>
                                <button class="ut-kebab-btn" title="Options" onclick="handleKebab(this)">&bull;&bull;&bull;</button>
                            </div>
                        </div>

                        <div class="ut-task-row" data-priority="low" data-subject="Database Systems" data-date="2026-10-30" data-page="2" style="display: none;">
                            <div class="ut-task-left">
                                <div class="ut-task-checkbox" onclick="toggleRowCheckbox(this)"></div>
                                <div class="ut-task-icon lilac">
                                    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2">
                                        <ellipse cx="12" cy="5" rx="9" ry="3"></ellipse>
                                        <path d="M21 12c0 1.66-4 3-9 3s-9-1.34-9-3"></path>
                                    </svg>
                                </div>
                                <div class="ut-task-text">
                                    <div class="ut-task-title">Practice SQL Subqueries</div>
                                    <div class="ut-task-sub">Database Systems &bull; Target: 30 Oct 2026, 04:00 PM</div>
                                </div>
                            </div>
                            <div class="ut-task-right">
                                <span class="ut-priority-badge low">Low</span>
                                <div class="ut-due-pill">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                        <line x1="16" y1="2" x2="16" y2="6"></line>
                                        <line x1="8" y1="2" x2="8" y2="6"></line>
                                    </svg>
                                    <span>30 Oct</span>
                                </div>
                                <button class="ut-kebab-btn" title="Options" onclick="handleKebab(this)">&bull;&bull;&bull;</button>
                            </div>
                        </div>

                    </div>

                    <!-- Pagination -->
                    <div class="ut-pagination">
                        <span id="utPaginationInfo">Showing 1 to 6 of 12 tasks</span>
                        <div class="ut-page-btns">
                            <button class="ut-page-btn" onclick="prevPage()">&lsaquo;</button>
                            <button class="ut-page-btn active" id="pageBtn1" onclick="changePage(1)">1</button>
                            <button class="ut-page-btn" id="pageBtn2" onclick="changePage(2)">2</button>
                            <button class="ut-page-btn" onclick="nextPage()">&rsaquo;</button>
                        </div>
                    </div>

                </div><!-- end ut-left-col -->

                <!-- ---------------- RIGHT COLUMN ---------------- -->
                <div class="ut-right-col">

                    <!-- Widget 1: Add New Task Form -->
                    <div class="ut-card">
                        <div class="ut-card-header">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                                <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                <line x1="16" y1="2" x2="16" y2="6"></line>
                                <line x1="8" y1="2" x2="8" y2="6"></line>
                                <line x1="12" y1="11" x2="12" y2="17"></line>
                                <line x1="9" y1="14" x2="15" y2="14"></line>
                            </svg>
                            <h3 class="ut-card-title">Add New Task</h3>
                        </div>

                        <form id="addNewTaskForm" onsubmit="handleAddTaskSubmit(event)">
                            <div class="ut-form-group">
                                <label class="ut-label">Task Title <span class="req">*</span></label>
                                <input type="text" class="ut-input" id="taskTitleInput" placeholder="e.g., Complete OS Lab Record" required>
                            </div>

                            <div class="ut-form-group">
                                <label class="ut-label">Subject <span class="req">*</span></label>
                                <select class="ut-select" id="taskSubjectInput" required>
                                    <option value="" disabled selected>Select Subject</option>
                                    <option value="Database Systems">Database Systems</option>
                                    <option value="Object Oriented Programming">Object Oriented Programming</option>
                                    <option value="Operating Systems">Operating Systems</option>
                                    <option value="Data Structures">Data Structures</option>
                                    <option value="Mathematics">Mathematics</option>
                                    <option value="Software Engineering">Software Engineering</option>
                                    <option value="Computer Networks">Computer Networks</option>
                                    <option value="Self Learning">Self Learning</option>
                                    <option value="Personal">Personal</option>
                                </select>
                            </div>

                            <div class="ut-form-group">
                                <div class="ut-input-row">
                                    <div>
                                        <label class="ut-label">Due Date <span class="req">*</span></label>
                                        <div class="ut-input-icon-wrap">
                                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                                <line x1="16" y1="2" x2="16" y2="6"></line>
                                                <line x1="8" y1="2" x2="8" y2="6"></line>
                                            </svg>
                                            <input type="date" class="ut-input" id="taskDateInput" required>
                                        </div>
                                    </div>
                                    <div>
                                        <label class="ut-label">Due Time <span class="req">*</span></label>
                                        <div class="ut-input-icon-wrap">
                                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                <circle cx="12" cy="12" r="10"></circle>
                                                <polyline points="12 6 12 12 16 14"></polyline>
                                            </svg>
                                            <input type="time" class="ut-input" id="taskTimeInput" required>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="ut-form-group">
                                <label class="ut-label">Priority <span class="req">*</span></label>
                                <div class="ut-priority-select-row">
                                    <div class="ut-prio-btn active high" onclick="selectFormPriority('high', this)">High</div>
                                    <div class="ut-prio-btn medium" onclick="selectFormPriority('medium', this)">Medium</div>
                                    <div class="ut-prio-btn low" onclick="selectFormPriority('low', this)">Low</div>
                                </div>
                            </div>

                            <div class="ut-form-group">
                                <label class="ut-label">Description (Optional)</label>
                                <textarea class="ut-textarea" id="taskDescInput" placeholder="Add any notes or details..."></textarea>
                            </div>

                            <div class="ut-form-actions">
                                <button type="button" class="ut-btn-cancel" onclick="document.getElementById('addNewTaskForm').reset()">Cancel</button>
                                <button type="submit" class="ut-btn-submit">Add Task</button>
                            </div>
                        </form>
                    </div>

                    <!-- Widget 2: Task Completion (This Month) -->
                    <div class="ut-card">
                        <div class="ut-card-header">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                                <circle cx="12" cy="12" r="10"></circle>
                                <circle cx="12" cy="12" r="6"></circle>
                                <circle cx="12" cy="12" r="2"></circle>
                            </svg>
                            <h3 class="ut-card-title">Task Completion <span style="font-size: 0.82rem; color: var(--ut-text-muted); font-weight: 500;">(This Month)</span></h3>
                        </div>

                        <div class="ut-donut-wrap">
                            <!-- Donut SVG -->
                            <div class="ut-donut-svg-box">
                                <svg class="ut-donut-svg" viewBox="0 0 100 100">
                                    <circle cx="50" cy="50" r="38" fill="none" stroke="rgba(255, 255, 255, 0.05)" stroke-width="12"></circle>
                                    <!-- Completed: 65% (circumference ~ 238.76, 65% = 155.19) -->
                                    <circle cx="50" cy="50" r="38" fill="none" stroke="#10b981" stroke-width="12"
                                            stroke-dasharray="155.19 238.76" stroke-dashoffset="0" stroke-linecap="round"></circle>
                                    <!-- Upcoming: 25% (offset = -160) -->
                                    <circle cx="50" cy="50" r="38" fill="none" stroke="#a855f7" stroke-width="12"
                                            stroke-dasharray="59.69 238.76" stroke-dashoffset="-160" stroke-linecap="round"></circle>
                                    <!-- Overdue: 10% (offset = -225) -->
                                    <circle cx="50" cy="50" r="38" fill="none" stroke="#38bdf8" stroke-width="12"
                                            stroke-dasharray="23.87 238.76" stroke-dashoffset="-225" stroke-linecap="round"></circle>
                                </svg>
                                <div class="ut-donut-center">
                                    <span class="ut-donut-pct">65%</span>
                                    <span class="ut-donut-sub">Completed</span>
                                </div>
                            </div>

                            <!-- Donut Legend -->
                            <div class="ut-donut-legend">
                                <div class="ut-donut-item">
                                    <div class="ut-donut-left">
                                        <div class="ut-legend-dot green"></div>
                                        <span>Completed</span>
                                    </div>
                                    <span class="ut-donut-num">13</span>
                                </div>

                                <div class="ut-donut-item">
                                    <div class="ut-donut-left">
                                        <div class="ut-legend-dot purple"></div>
                                        <span>Upcoming</span>
                                    </div>
                                    <span class="ut-donut-num">12</span>
                                </div>

                                <div class="ut-donut-item">
                                    <div class="ut-donut-left">
                                        <div class="ut-legend-dot blue"></div>
                                        <span>Overdue</span>
                                    </div>
                                    <span class="ut-donut-num">2</span>
                                </div>
                            </div>
                        </div>
                    </div>

                </div><!-- end ut-right-col -->

            </div><!-- end ut-main-grid -->

        </div><!-- end ut-container -->
    </main>
</div><!-- end ut-layout -->

<script>
var currentPrioFilter = 'all';
var currentSubjectFilter = 'all';
var currentSort = 'earliest';
var currentPage = 1;
var selectedFormPriority = 'high';

// Toggle row checkbox
function toggleRowCheckbox(box) {
    box.classList.toggle('checked');
    var row = box.closest('.ut-task-row');
    if (row) {
        var title = row.querySelector('.ut-task-title');
        if (box.classList.contains('checked')) {
            box.innerHTML = '<span style="font-size: 11px;">&#10003;</span>';
            if (title) title.classList.add('completed');
        } else {
            box.innerHTML = '';
            if (title) title.classList.remove('completed');
        }
    }
}

// Priority filter tabs
function filterByPriority(priority, btn) {
    currentPrioFilter = priority;
    currentPage = 1;

    var tabs = document.querySelectorAll('.ut-tab-btn');
    tabs.forEach(function(t) { t.classList.remove('active'); });
    if (btn) btn.classList.add('active');

    applyAllFilters();
}

// Subject filter toggle
function toggleSubjectFilter() {
    var subjects = ['all', 'Database Systems', 'Object Oriented Programming', 'Operating Systems', 'Data Structures', 'Self Learning', 'POPs and DBMS Project'];
    var idx = subjects.indexOf(currentSubjectFilter);
    currentSubjectFilter = subjects[(idx + 1) % subjects.length];

    var btn = document.getElementById('subjectFilterBtn');
    if (btn) {
        btn.querySelector('span:first-child').textContent = 'Subject: ' + (currentSubjectFilter === 'all' ? 'All Subjects' : currentSubjectFilter);
    }

    applyAllFilters();
}

// Sort toggle
function toggleSort() {
    currentSort = (currentSort === 'earliest') ? 'latest' : 'earliest';
    var btn = document.getElementById('sortByBtn');
    if (btn) {
        btn.querySelector('span:first-child').textContent = 'Sort By: Due Date (' + (currentSort === 'earliest' ? 'Earliest' : 'Latest') + ')';
    }

    var container = document.getElementById('utTasksContainer');
    if (!container) return;
    var rows = Array.from(container.querySelectorAll('.ut-task-row'));
    rows.sort(function(a, b) {
        var dateA = new Date(a.getAttribute('data-date') || 0).getTime();
        var dateB = new Date(b.getAttribute('data-date') || 0).getTime();
        return currentSort === 'earliest' ? (dateA - dateB) : (dateB - dateA);
    });

    rows.forEach(function(r) { container.appendChild(r); });
    applyAllFilters();
}

// Apply priority, subject, and pagination filters
function applyAllFilters() {
    var rows = document.querySelectorAll('.ut-task-row');
    var visible = 0;
    var totalMatches = 0;

    var searchQ = (document.getElementById('utSearchInput')?.value || '').toLowerCase().trim();

    rows.forEach(function(row) {
        var p = row.getAttribute('data-priority');
        var s = row.getAttribute('data-subject');
        var page = parseInt(row.getAttribute('data-page') || '1', 10);
        var txt = row.textContent.toLowerCase();

        var matchPrio = (currentPrioFilter === 'all' || p === currentPrioFilter);
        var matchSub = (currentSubjectFilter === 'all' || s === currentSubjectFilter);
        var matchSearch = (!searchQ || txt.indexOf(searchQ) !== -1);

        if (matchPrio && matchSub && matchSearch) {
            totalMatches++;
            if (currentPrioFilter === 'all' && currentSubjectFilter === 'all' && !searchQ) {
                if (page === currentPage) {
                    row.style.display = 'flex';
                    visible++;
                } else {
                    row.style.display = 'none';
                }
            } else {
                row.style.display = 'flex';
                visible++;
            }
        } else {
            row.style.display = 'none';
        }
    });

    var info = document.getElementById('utPaginationInfo');
    if (info) {
        if (currentPrioFilter === 'all' && currentSubjectFilter === 'all' && !searchQ) {
            var start = (currentPage - 1) * 6 + 1;
            var end = Math.min(currentPage * 6, 12);
            info.textContent = 'Showing ' + start + ' to ' + end + ' of 12 tasks';
        } else {
            info.textContent = 'Showing ' + visible + ' of ' + totalMatches + ' matching tasks';
        }
    }

    // Update active page button
    for (var i = 1; i <= 2; i++) {
        var pBtn = document.getElementById('pageBtn' + i);
        if (pBtn) {
            if (i === currentPage && currentPrioFilter === 'all' && currentSubjectFilter === 'all') {
                pBtn.classList.add('active');
            } else {
                pBtn.classList.remove('active');
            }
        }
    }
}

function changePage(page) {
    currentPage = page;
    applyAllFilters();
}

function prevPage() {
    if (currentPage > 1) {
        currentPage--;
        applyAllFilters();
    }
}

function nextPage() {
    if (currentPage < 2) {
        currentPage++;
        applyAllFilters();
    }
}

// Form priority selection
function selectFormPriority(prio, btn) {
    selectedFormPriority = prio;
    var btns = document.querySelectorAll('.ut-prio-btn');
    btns.forEach(function(b) { b.classList.remove('active'); });
    if (btn) btn.classList.add('active');
}

// Handle Add Task Form Submission
function handleAddTaskSubmit(e) {
    e.preventDefault();
    var title = document.getElementById('taskTitleInput').value.trim();
    var subject = document.getElementById('taskSubjectInput').value;
    var date = document.getElementById('taskDateInput').value;
    var time = document.getElementById('taskTimeInput').value;

    if (!title || !subject || !date || !time) {
        alert('Please fill out all required fields.');
        return;
    }

    // Format display date
    var dObj = new Date(date + 'T' + time);
    var dateFormatted = dObj.toLocaleDateString('en-GB', { day: 'numeric', month: 'short' });
    var timeFormatted = dObj.toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit' });

    var container = document.getElementById('utTasksContainer');
    var newRow = document.createElement('div');
    newRow.className = 'ut-task-row';
    newRow.setAttribute('data-priority', selectedFormPriority);
    newRow.setAttribute('data-subject', subject);
    newRow.setAttribute('data-date', date);
    newRow.setAttribute('data-page', '1');
    newRow.style.display = 'flex';

    var prioUpper = selectedFormPriority.charAt(0).toUpperCase() + selectedFormPriority.slice(1);
    var iconClass = selectedFormPriority === 'high' ? 'coral' : (selectedFormPriority === 'medium' ? 'green' : 'blue');

    newRow.innerHTML = 
        '<div class="ut-task-left">' +
            '<div class="ut-task-checkbox" onclick="toggleRowCheckbox(this)"></div>' +
            '<div class="ut-task-icon ' + iconClass + '">' +
                '<svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2">' +
                    '<polyline points="9 11 12 14 22 4"></polyline>' +
                    '<path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"></path>' +
                '</svg>' +
            '</div>' +
            '<div class="ut-task-text">' +
                '<div class="ut-task-title">' + title + '</div>' +
                '<div class="ut-task-sub">' + subject + ' &bull; Submission: ' + dateFormatted + ', ' + timeFormatted + '</div>' +
            '</div>' +
        '</div>' +
        '<div class="ut-task-right">' +
            '<span class="ut-priority-badge ' + selectedFormPriority + '">' + prioUpper + '</span>' +
            '<div class="ut-due-pill">' +
                '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">' +
                    '<rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>' +
                    '<line x1="16" y1="2" x2="16" y2="6"></line>' +
                    '<line x1="8" y1="2" x2="8" y2="6"></line>' +
                '</svg>' +
                '<span>' + dateFormatted + '</span>' +
            '</div>' +
            '<button class="ut-kebab-btn" title="Options" onclick="handleKebab(this)">&bull;&bull;&bull;</button>' +
        '</div>';

    container.insertBefore(newRow, container.firstChild);
    document.getElementById('addNewTaskForm').reset();
    selectFormPriority('high', document.querySelector('.ut-prio-btn.high'));

    // Update KPI
    var totalElem = document.getElementById('kpiTotalUpcoming');
    if (totalElem) {
        totalElem.textContent = parseInt(totalElem.textContent, 10) + 1;
    }

    alert('Task "' + title + '" added successfully to Upcoming Tasks!');
}

function handleKebab(btn) {
    btn.style.transform = 'scale(1.25)';
    setTimeout(function() { btn.style.transform = ''; }, 150);
}

// Global search
var searchInput = document.getElementById('utSearchInput');
if (searchInput) {
    searchInput.addEventListener('input', function() {
        applyAllFilters();
    });
}

document.addEventListener('keydown', function(e) {
    if ((e.ctrlKey || e.metaKey) && (e.key === 'k' || e.key === 'K')) {
        e.preventDefault();
        var searchInput = document.getElementById('utSearchInput');
        if (searchInput) {
            searchInput.focus();
            searchInput.select();
        }
    }
});
</script>

</body>
</html>
