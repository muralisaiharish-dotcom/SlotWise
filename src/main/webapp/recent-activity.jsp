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
    <title>Recent Activity &mdash; SlotWise</title>
    <meta name="description" content="Track all your activities and see how you're progressing with SlotWise.">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        :root {
            --pw-bg-app: #080c18;
            --pw-bg-sidebar: #0a0f1d;
            --pw-bg-card: #0f1527;
            --pw-bg-card-hover: #141c33;
            --pw-border: rgba(255, 255, 255, 0.07);
            --pw-border-focus: #6366f1;
            --pw-purple: #7952f5;
            --pw-purple-light: #8b5cf6;
            --pw-purple-glow: rgba(121, 82, 245, 0.28);
            --pw-blue: #38bdf8;
            --pw-green: #10b981;
            --pw-red: #f43f5e;
            --pw-orange: #f97316;
            --pw-text-white: #ffffff;
            --pw-text-primary: #f1f5f9;
            --pw-text-muted: #8492a6;
            --pw-text-dim: #556277;
        }

        body {
            background-color: var(--pw-bg-app) !important;
            color: var(--pw-text-primary);
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            margin: 0;
            padding: 0;
            overflow-x: hidden;
        }

        .pw-layout {
            display: flex;
            min-height: 100vh;
            background-color: var(--pw-bg-app);
        }

        /* ------------------ SIDEBAR ------------------ */
        .pw-sidebar {
            width: 240px;
            min-width: 240px;
            background-color: var(--pw-bg-sidebar);
            border-right: 1px solid var(--pw-border);
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            padding: 24px 16px 20px;
            box-sizing: border-box;
        }

        .pw-logo {
            display: flex;
            align-items: center;
            gap: 12px;
            text-decoration: none;
            padding: 0 8px 24px;
        }

        .pw-logo-icon {
            width: 36px;
            height: 36px;
            background: linear-gradient(135deg, #7952f5 0%, #a855f7 100%);
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #ffffff;
            box-shadow: 0 4px 12px var(--pw-purple-glow);
        }

        .pw-logo-text {
            font-size: 1.25rem;
            font-weight: 700;
            color: #ffffff;
            letter-spacing: -0.02em;
        }
        .pw-logo-text span {
            color: #9d7bfc;
        }

        .pw-nav {
            display: flex;
            flex-direction: column;
            gap: 6px;
            flex: 1;
        }

        .pw-nav-item {
            display: flex;
            align-items: center;
            gap: 14px;
            padding: 11px 14px;
            border-radius: 10px;
            color: var(--pw-text-muted);
            text-decoration: none;
            font-size: 0.88rem;
            font-weight: 500;
            transition: all 0.2s ease;
        }

        .pw-nav-item:hover {
            color: var(--pw-text-white);
            background-color: rgba(255, 255, 255, 0.03);
        }

        .pw-nav-item.active {
            background: linear-gradient(135deg, #4f46e5 0%, #6366f1 100%);
            color: #ffffff;
            font-weight: 600;
            box-shadow: 0 4px 18px rgba(79, 70, 229, 0.38);
        }

        .pw-nav-item svg {
            width: 18px;
            height: 18px;
            stroke-width: 1.8;
            flex-shrink: 0;
        }

        .pw-sidebar-bottom {
            padding-top: 16px;
            border-top: 1px solid var(--pw-border);
        }

        .pw-nav-item.logout {
            color: #94a3b8;
        }
        .pw-nav-item.logout:hover {
            color: #ef4444;
            background-color: rgba(239, 68, 68, 0.08);
        }

        /* ------------------ MAIN CONTENT ------------------ */
        .pw-main {
            flex: 1;
            display: flex;
            flex-direction: column;
            min-width: 0;
            background-color: var(--pw-bg-app);
        }

        /* Top Bar */
        .pw-topbar {
            height: 70px;
            padding: 0 32px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 20px;
            border-bottom: 1px solid var(--pw-border);
            background-color: var(--pw-bg-app);
        }

        .pw-search-box {
            position: relative;
            width: 380px;
            max-width: 100%;
        }

        .pw-search-box input {
            width: 100%;
            height: 40px;
            background-color: rgba(255, 255, 255, 0.035);
            border: 1px solid var(--pw-border);
            border-radius: 999px;
            padding: 0 65px 0 42px;
            color: var(--pw-text-primary);
            font-size: 0.85rem;
            outline: none;
            box-sizing: border-box;
            transition: all 0.2s ease;
        }

        .pw-search-kbd {
            position: absolute;
            right: 14px;
            top: 50%;
            transform: translateY(-50%);
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 4px;
            padding: 2px 6px;
            font-size: 0.7rem;
            color: var(--pw-text-dim);
            font-family: inherit;
            pointer-events: none;
        }

        .pw-search-box input:focus {
            border-color: var(--pw-border-focus);
            background-color: rgba(255, 255, 255, 0.06);
        }

        .pw-search-box input::placeholder {
            color: var(--pw-text-dim);
        }

        .pw-search-icon {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--pw-text-dim);
            pointer-events: none;
            width: 16px;
            height: 16px;
        }

        .pw-user-actions {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .pw-notif-btn {
            position: relative;
            background: none;
            border: none;
            color: var(--pw-text-muted);
            cursor: pointer;
            padding: 6px;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: color 0.2s;
        }
        .pw-notif-btn:hover { color: var(--pw-text-white); }
        .pw-notif-dot {
            position: absolute;
            top: 5px;
            right: 5px;
            width: 7px;
            height: 7px;
            background-color: #f43f5e;
            border-radius: 50%;
            box-shadow: 0 0 6px rgba(244, 63, 94, 0.7);
        }

        .pw-profile-pill {
            display: flex;
            align-items: center;
            gap: 10px;
            cursor: pointer;
            text-decoration: none;
            color: inherit;
        }

        .pw-avatar {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            background: linear-gradient(135deg, #3b82f6, #8b5cf6);
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 0.85rem;
            color: #ffffff;
            overflow: hidden;
            border: 1px solid rgba(255, 255, 255, 0.15);
        }

        .pw-profile-info {
            display: flex;
            flex-direction: column;
            line-height: 1.25;
        }
        .pw-profile-name {
            font-size: 0.85rem;
            font-weight: 600;
            color: var(--pw-text-white);
        }
        .pw-profile-dept {
            font-size: 0.72rem;
            color: var(--pw-text-muted);
        }

        /* ------------------ BODY CONTAINER ------------------ */
        .pw-container {
            padding: 24px 32px 50px;
            overflow-y: auto;
        }

        /* Breadcrumb Bar */
        .pw-act-breadcrumb-bar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 8px;
        }

        .pw-breadcrumb {
            display: flex;
            align-items: center;
            font-size: 0.8rem;
            color: #64748b;
        }
        .pw-breadcrumb-link {
            color: #64748b;
            text-decoration: none;
            transition: color 0.15s;
            cursor: pointer;
        }
        .pw-breadcrumb-link:hover {
            color: #94a3b8;
        }
        .pw-breadcrumb-sep {
            margin: 0 8px;
            color: #475569;
            font-size: 0.75rem;
        }
        .pw-breadcrumb-current {
            color: #cbd5e1;
            font-weight: 500;
        }

        .pw-back-to-progress-btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: rgba(255, 255, 255, 0.04);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 8px;
            color: #e2e8f0;
            padding: 7px 14px;
            font-size: 0.82rem;
            font-weight: 500;
            cursor: pointer;
            text-decoration: none;
            transition: all 0.2s ease;
        }
        .pw-back-to-progress-btn:hover {
            background-color: rgba(99, 102, 241, 0.15);
            border-color: #6366f1;
            color: #ffffff;
            transform: translateX(-2px);
        }

        .pw-act-header-row {
            display: flex;
            align-items: flex-end;
            justify-content: space-between;
            margin-bottom: 22px;
            gap: 16px;
            flex-wrap: wrap;
        }
        .pw-act-title-wrap h1 {
            font-size: 1.85rem;
            font-weight: 700;
            color: #ffffff;
            margin: 0 0 4px 0;
            letter-spacing: -0.02em;
        }
        .pw-act-title-wrap p {
            color: #8492a6;
            font-size: 0.88rem;
            margin: 0;
        }

        .pw-act-date-dropdown-btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: rgba(255, 255, 255, 0.04);
            border: 1px solid rgba(255, 255, 255, 0.08);
            border-radius: 8px;
            padding: 8px 14px;
            color: #e2e8f0;
            font-size: 0.82rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.15s;
        }
        .pw-act-date-dropdown-btn:hover {
            background: rgba(255, 255, 255, 0.07);
            border-color: rgba(255, 255, 255, 0.16);
        }

        /* 2-Column Grid Layout */
        .pw-act-grid-container {
            display: grid;
            grid-template-columns: 1fr 340px;
            gap: 20px;
            align-items: start;
        }
        @media (max-width: 1220px) {
            .pw-act-grid-container {
                grid-template-columns: 1fr;
            }
        }

        /* 4 KPI Cards */
        .pw-act-kpi-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 14px;
            margin-bottom: 20px;
        }
        @media (max-width: 860px) {
            .pw-act-kpi-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        .pw-act-kpi-card {
            background-color: var(--pw-bg-card);
            border: 1px solid var(--pw-border);
            border-radius: 14px;
            padding: 16px 18px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            position: relative;
            box-shadow: 0 4px 16px rgba(0, 0, 0, 0.18);
            transition: transform 0.2s, border-color 0.2s;
        }
        .pw-act-kpi-card:hover {
            border-color: rgba(121, 82, 245, 0.35);
            transform: translateY(-2px);
        }
        .pw-act-kpi-left {
            display: flex;
            flex-direction: column;
        }
        .pw-act-kpi-icon {
            width: 34px;
            height: 34px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 10px;
        }
        .pw-act-kpi-icon.purple {
            background-color: rgba(121, 82, 245, 0.16);
            color: #a78bfa;
        }
        .pw-act-kpi-icon.green {
            background-color: rgba(16, 185, 129, 0.16);
            color: #34d399;
        }
        .pw-act-kpi-icon.violet {
            background-color: rgba(139, 92, 246, 0.16);
            color: #c084fc;
        }
        .pw-act-kpi-icon.orange {
            background-color: rgba(249, 115, 22, 0.16);
            color: #fb923c;
        }
        .pw-act-kpi-label {
            font-size: 0.74rem;
            color: #8492a6;
            font-weight: 500;
            margin-bottom: 3px;
        }
        .pw-act-kpi-val {
            font-size: 1.65rem;
            font-weight: 700;
            color: #ffffff;
            line-height: 1.1;
            margin-bottom: 3px;
        }
        .pw-act-kpi-sub {
            font-size: 0.7rem;
            color: #64748b;
        }

        .pw-act-kpi-bars {
            display: flex;
            align-items: flex-end;
            gap: 3px;
            height: 32px;
            margin-bottom: -6px;
        }
        .pw-act-kpi-bars span {
            width: 5px;
            background: linear-gradient(180deg, #818cf8 0%, #4f46e5 100%);
            border-radius: 2px;
        }

        /* Filter Tabs & Sort bar */
        .pw-act-filter-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 16px;
            gap: 12px;
            flex-wrap: wrap;
        }
        .pw-act-tabs-group {
            display: flex;
            align-items: center;
            gap: 8px;
            flex-wrap: wrap;
        }
        .pw-act-tab-pill {
            background-color: rgba(255, 255, 255, 0.04);
            border: 1px solid rgba(255, 255, 255, 0.08);
            border-radius: 999px;
            color: #94a3b8;
            padding: 7px 16px;
            font-size: 0.78rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.15s;
        }
        .pw-act-tab-pill:hover {
            color: #ffffff;
            background-color: rgba(255, 255, 255, 0.08);
        }
        .pw-act-tab-pill.active {
            background: #6366f1;
            color: #ffffff;
            font-weight: 600;
            border-color: transparent;
            box-shadow: 0 2px 10px rgba(99, 102, 241, 0.4);
        }

        .pw-act-sort-group {
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .pw-act-sort-label {
            color: #64748b;
            font-size: 0.78rem;
        }
        .pw-act-sort-select {
            background: rgba(255, 255, 255, 0.04);
            border: 1px solid rgba(255, 255, 255, 0.08);
            border-radius: 8px;
            padding: 6px 12px;
            color: #e2e8f0;
            font-size: 0.78rem;
            font-weight: 500;
            cursor: pointer;
            outline: none;
        }
        .pw-act-sort-select option {
            background-color: #0f1527;
            color: #ffffff;
        }

        /* Activity Rows */
        .pw-act-rows-wrap {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }
        .pw-act-row {
            background-color: var(--pw-bg-card);
            border: 1px solid var(--pw-border);
            border-radius: 12px;
            padding: 13px 18px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            transition: all 0.2s ease;
        }
        .pw-act-row:hover {
            background-color: var(--pw-bg-card-hover);
            border-color: rgba(121, 82, 245, 0.35);
            transform: translateY(-1px);
        }

        .pw-act-row-main {
            display: flex;
            align-items: center;
            gap: 14px;
            flex: 1;
            min-width: 0;
        }
        .pw-act-row-icon {
            width: 36px;
            height: 36px;
            border-radius: 9px;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }
        .pw-act-row-icon.green-check {
            background-color: rgba(16, 185, 129, 0.15);
            color: #10b981;
        }
        .pw-act-row-icon.blue-clock {
            background-color: rgba(56, 189, 248, 0.15);
            color: #38bdf8;
        }
        .pw-act-row-icon.purple-doc {
            background-color: rgba(139, 92, 246, 0.15);
            color: #a78bfa;
        }
        .pw-act-row-icon.red-goal {
            background-color: rgba(244, 63, 94, 0.15);
            color: #f43f5e;
        }
        .pw-act-row-icon.orange-edit {
            background-color: rgba(249, 115, 22, 0.15);
            color: #f97316;
        }
        .pw-act-row-icon.purple-group {
            background-color: rgba(168, 85, 247, 0.15);
            color: #c084fc;
        }
        .pw-act-row-icon.blue-upload {
            background-color: rgba(56, 189, 248, 0.15);
            color: #38bdf8;
        }
        .pw-act-row-icon.yellow-trophy {
            background-color: rgba(245, 158, 11, 0.15);
            color: #fbbf24;
        }
        .pw-act-row-icon.pink-timer {
            background-color: rgba(236, 72, 153, 0.15);
            color: #f472b6;
        }

        .pw-act-row-text {
            flex: 1;
            min-width: 0;
        }
        .pw-act-row-title {
            font-size: 0.88rem;
            font-weight: 600;
            color: #ffffff;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        .pw-act-row-desc {
            font-size: 0.74rem;
            color: #8492a6;
            margin-top: 2px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .pw-act-subject-capsule {
            background: rgba(255, 255, 255, 0.04);
            border: 1px solid rgba(255, 255, 255, 0.08);
            border-radius: 999px;
            padding: 4px 14px;
            font-size: 0.74rem;
            color: #94a3b8;
            font-weight: 500;
            text-align: center;
            min-width: 130px;
            white-space: nowrap;
        }

        .pw-act-timestamp {
            display: flex;
            align-items: center;
            gap: 6px;
            color: #94a3b8;
            font-size: 0.74rem;
            min-width: 145px;
            white-space: nowrap;
        }
        .pw-act-timestamp svg {
            color: #f59e0b;
            flex-shrink: 0;
        }

        .pw-act-status-badge {
            padding: 4px 14px;
            border-radius: 999px;
            font-size: 0.72rem;
            font-weight: 600;
            min-width: 95px;
            text-align: center;
            display: inline-block;
            white-space: nowrap;
        }
        .pw-act-status-badge.completed {
            background: rgba(16, 185, 129, 0.15);
            color: #34d399;
            border: 1px solid rgba(16, 185, 129, 0.25);
        }
        .pw-act-status-badge.study {
            background: rgba(56, 189, 248, 0.15);
            color: #38bdf8;
            border: 1px solid rgba(56, 189, 248, 0.25);
        }
        .pw-act-status-badge.update {
            background: rgba(139, 92, 246, 0.15);
            color: #a78bfa;
            border: 1px solid rgba(139, 92, 246, 0.25);
        }
        .pw-act-status-badge.goal {
            background: rgba(244, 63, 94, 0.15);
            color: #fb7185;
            border: 1px solid rgba(244, 63, 94, 0.25);
        }
        .pw-act-status-badge.group {
            background: rgba(99, 102, 241, 0.15);
            color: #818cf8;
            border: 1px solid rgba(99, 102, 241, 0.25);
        }
        .pw-act-status-badge.material {
            background: rgba(56, 189, 248, 0.15);
            color: #38bdf8;
            border: 1px solid rgba(56, 189, 248, 0.25);
        }
        .pw-act-status-badge.milestone {
            background: rgba(245, 158, 11, 0.15);
            color: #fbbf24;
            border: 1px solid rgba(245, 158, 11, 0.25);
        }
        .pw-act-status-badge.planner {
            background: rgba(217, 70, 239, 0.15);
            color: #e879f9;
            border: 1px solid rgba(217, 70, 239, 0.25);
        }

        .pw-act-kebab-btn {
            background: none;
            border: none;
            color: #64748b;
            font-size: 1.15rem;
            cursor: pointer;
            padding: 4px 6px;
            border-radius: 4px;
            transition: color 0.15s, background-color 0.15s;
        }
        .pw-act-kebab-btn:hover {
            color: #ffffff;
            background: rgba(255, 255, 255, 0.08);
        }

        /* Pagination */
        .pw-act-pagination {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-top: 18px;
            padding: 8px 4px;
        }
        .pw-act-pagination-info {
            color: #64748b;
            font-size: 0.78rem;
        }
        .pw-act-pagination-btns {
            display: flex;
            align-items: center;
            gap: 4px;
        }
        .pw-act-page-btn {
            width: 30px;
            height: 30px;
            border-radius: 6px;
            background: rgba(255, 255, 255, 0.04);
            border: 1px solid rgba(255, 255, 255, 0.08);
            color: #94a3b8;
            font-size: 0.78rem;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.15s;
        }
        .pw-act-page-btn:hover {
            color: #ffffff;
            background: rgba(255, 255, 255, 0.08);
        }
        .pw-act-page-btn.active {
            background: #6366f1;
            color: #ffffff;
            border-color: transparent;
            box-shadow: 0 2px 8px rgba(99, 102, 241, 0.4);
        }

        /* Right Column Cards */
        .pw-act-side-col {
            display: flex;
            flex-direction: column;
            gap: 16px;
        }
        .pw-act-side-card {
            background-color: var(--pw-bg-card);
            border: 1px solid var(--pw-border);
            border-radius: 14px;
            padding: 16px 18px;
            box-shadow: 0 4px 16px rgba(0, 0, 0, 0.18);
        }
        .pw-act-side-card-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 14px;
        }
        .pw-act-side-card-title {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 0.85rem;
            font-weight: 600;
            color: #ffffff;
        }
        .pw-act-side-card-title svg {
            color: #818cf8;
        }

        /* Calendar Widget */
        .pw-cal-month-nav {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 10px;
        }
        .pw-cal-month-name {
            font-size: 0.84rem;
            font-weight: 600;
            color: #ffffff;
        }
        .pw-cal-nav-arrows {
            display: flex;
            gap: 4px;
        }
        .pw-cal-arrow-btn {
            background: rgba(255, 255, 255, 0.04);
            border: 1px solid rgba(255, 255, 255, 0.08);
            border-radius: 6px;
            color: #94a3b8;
            width: 24px;
            height: 24px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            font-size: 0.74rem;
            transition: all 0.15s;
        }
        .pw-cal-arrow-btn:hover {
            color: #ffffff;
            background: rgba(255, 255, 255, 0.1);
        }
        .pw-cal-weekdays {
            display: grid;
            grid-template-columns: repeat(7, 1fr);
            text-align: center;
            font-size: 0.68rem;
            color: #64748b;
            font-weight: 600;
            margin-bottom: 6px;
        }
        .pw-cal-grid {
            display: grid;
            grid-template-columns: repeat(7, 1fr);
            gap: 3px;
            text-align: center;
        }
        .pw-cal-day {
            height: 30px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            font-size: 0.74rem;
            color: #cbd5e1;
            border-radius: 6px;
            cursor: pointer;
            transition: all 0.15s;
            position: relative;
        }
        .pw-cal-day:hover {
            background: rgba(255, 255, 255, 0.05);
        }
        .pw-cal-day.active-day {
            background: #6366f1;
            color: #ffffff;
            font-weight: 700;
            border-radius: 50%;
            box-shadow: 0 0 10px rgba(99, 102, 241, 0.5);
        }
        .pw-cal-dots {
            display: flex;
            gap: 2px;
            justify-content: center;
            margin-top: 1px;
            height: 3px;
        }
        .pw-cal-dot {
            width: 2.5px;
            height: 2.5px;
            border-radius: 50%;
            background-color: #38bdf8;
        }

        /* Distribution Donut */
        .pw-dist-wrap {
            display: flex;
            align-items: center;
            gap: 16px;
            padding: 6px 0;
        }
        .pw-dist-donut {
            width: 105px;
            height: 105px;
            flex-shrink: 0;
            position: relative;
        }
        .pw-dist-legend {
            display: flex;
            flex-direction: column;
            gap: 10px;
            flex: 1;
        }
        .pw-dist-legend-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            font-size: 0.72rem;
            color: #cbd5e1;
        }
        .pw-dist-legend-left {
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .pw-dist-legend-dot {
            width: 8px;
            height: 8px;
            border-radius: 50%;
        }
        .pw-dist-legend-dot.green { background-color: #10b981; }
        .pw-dist-legend-dot.purple { background-color: #8b5cf6; }
        .pw-dist-legend-dot.orange { background-color: #f59e0b; }
        .pw-dist-legend-val {
            color: #94a3b8;
            font-weight: 500;
        }

        /* Top Subjects */
        .pw-subj-list {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }
        .pw-subj-row {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 0.74rem;
        }
        .pw-subj-icon {
            width: 22px;
            height: 22px;
            border-radius: 5px;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }
        .pw-subj-name {
            width: 115px;
            color: #e2e8f0;
            font-weight: 500;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        .pw-subj-bar {
            flex: 1;
            height: 6px;
            background: rgba(255, 255, 255, 0.06);
            border-radius: 999px;
            overflow: hidden;
        }
        .pw-subj-fill {
            height: 100%;
            border-radius: 999px;
        }
        .pw-subj-count {
            width: 16px;
            text-align: right;
            color: #94a3b8;
            font-weight: 600;
        }

        /* Productivity Summary 2x2 */
        .pw-prod-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 10px;
        }
        .pw-prod-tile {
            background: rgba(255, 255, 255, 0.03);
            border: 1px solid rgba(255, 255, 255, 0.06);
            border-radius: 10px;
            padding: 10px 12px;
            display: flex;
            flex-direction: column;
            gap: 4px;
        }
        .pw-prod-tile-icon {
            width: 26px;
            height: 26px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 2px;
        }
        .pw-prod-tile-icon.blue { background: rgba(56, 189, 248, 0.15); color: #38bdf8; }
        .pw-prod-tile-icon.green { background: rgba(16, 185, 129, 0.15); color: #10b981; }
        .pw-prod-tile-icon.red { background: rgba(244, 63, 94, 0.15); color: #f43f5e; }
        .pw-prod-tile-icon.purple { background: rgba(168, 85, 247, 0.15); color: #c084fc; }
        .pw-prod-tile-num {
            font-size: 1.15rem;
            font-weight: 700;
            color: #ffffff;
            display: flex;
            align-items: baseline;
            gap: 4px;
        }
        .pw-prod-tile-num .trend-up {
            font-size: 0.7rem;
            color: #f59e0b;
            font-weight: 600;
        }
        .pw-prod-tile-label {
            font-size: 0.68rem;
            color: #8492a6;
            line-height: 1.2;
        }
    </style>
</head>
<body>

<div class="pw-layout">

    <!-- ======================================================== -->
    <!-- 1. SIDEBAR                                               -->
    <!-- ======================================================== -->
    <aside class="pw-sidebar">
        <div>
            <!-- Logo -->
            <a href="${pageContext.request.contextPath}/dashboard" class="pw-logo">
                <div class="pw-logo-icon">
                    <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                        <line x1="16" y1="2" x2="16" y2="6"></line>
                        <line x1="8" y1="2" x2="8" y2="6"></line>
                        <line x1="3" y1="10" x2="21" y2="10"></line>
                    </svg>
                </div>
                <div class="pw-logo-text">Slot<span>Wise</span></div>
            </a>

            <!-- Nav Items -->
            <nav class="pw-nav">
                <a href="${pageContext.request.contextPath}/dashboard" class="pw-nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path>
                        <polyline points="9 22 9 12 15 12 15 22"></polyline>
                    </svg>
                    <span>Dashboard</span>
                </a>

                <a href="${pageContext.request.contextPath}/timetable" class="pw-nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round">
                        <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                        <line x1="16" y1="2" x2="16" y2="6"></line>
                        <line x1="8" y1="2" x2="8" y2="6"></line>
                        <line x1="3" y1="10" x2="21" y2="10"></line>
                    </svg>
                    <span>Timetable</span>
                </a>

                <a href="${pageContext.request.contextPath}/tasks" class="pw-nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M9 11l3 3L22 4"></path>
                        <path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"></path>
                    </svg>
                    <span>My Tasks</span>
                </a>

                <a href="${pageContext.request.contextPath}/planner" class="pw-nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round">
                        <rect x="2" y="2" width="20" height="8" rx="2" ry="2"></rect>
                        <rect x="2" y="14" width="20" height="8" rx="2" ry="2"></rect>
                        <line x1="6" y1="6" x2="6.01" y2="6"></line>
                        <line x1="6" y1="18" x2="6.01" y2="18"></line>
                    </svg>
                    <span>Smart Planner</span>
                </a>

                <a href="${pageContext.request.contextPath}/progress" class="pw-nav-item active">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round">
                        <line x1="18" y1="20" x2="18" y2="10"></line>
                        <line x1="12" y1="20" x2="12" y2="4"></line>
                        <line x1="6" y1="20" x2="6" y2="14"></line>
                    </svg>
                    <span>Progress</span>
                </a>

                <a href="#" class="pw-nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path>
                        <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path>
                    </svg>
                    <span>Materials</span>
                </a>

                <a href="#" class="pw-nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                        <circle cx="9" cy="7" r="4"></circle>
                        <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                        <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                    </svg>
                    <span>Study Groups</span>
                </a>

                <a href="${pageContext.request.contextPath}/progress" class="pw-nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="12" cy="12" r="10"></circle>
                        <circle cx="12" cy="12" r="6"></circle>
                        <circle cx="12" cy="12" r="2"></circle>
                    </svg>
                    <span>Goals</span>
                </a>

                <a href="${pageContext.request.contextPath}/settings" class="pw-nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="12" cy="12" r="3"></circle>
                        <path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z"></path>
                    </svg>
                    <span>Settings</span>
                </a>
            </nav>
        </div>

        <div class="pw-sidebar-bottom">
            <a href="${pageContext.request.contextPath}/logout" class="pw-nav-item logout">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path>
                    <polyline points="16 17 21 12 16 7"></polyline>
                    <line x1="21" y1="12" x2="9" y2="12"></line>
                </svg>
                <span>Logout</span>
            </a>
        </div>
    </aside>

    <!-- ======================================================== -->
    <!-- 2. MAIN VIEW                                             -->
    <!-- ======================================================== -->
    <main class="pw-main">

        <!-- Top Navigation -->
        <header class="pw-topbar">
            <div class="pw-search-box">
                <svg class="pw-search-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <circle cx="11" cy="11" r="8"></circle>
                    <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                </svg>
                <input type="text" id="pwTopSearchInput" placeholder="Search tasks, subjects, or activities..." onkeyup="handleGlobalSearch(this.value)">
                <span class="pw-search-kbd">Ctrl K</span>
            </div>

            <div class="pw-user-actions">
                <button class="pw-notif-btn" title="Notifications">
                    <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"></path>
                        <path d="M13.73 21a2 2 0 0 1-3.46 0"></path>
                    </svg>
                    <span class="pw-notif-dot"></span>
                </button>

                <a href="${pageContext.request.contextPath}/settings" class="pw-profile-pill">
                    <div class="pw-avatar">
                        <c:choose>
                            <c:when test="${not empty sessionScope.studentName}">
                                ${fn:substring(sessionScope.studentName, 0, 1)}
                            </c:when>
                            <c:otherwise>H</c:otherwise>
                        </c:choose>
                    </div>
                    <div class="pw-profile-info">
                        <span class="pw-profile-name">
                            <c:out value="${sessionScope.studentName != null ? sessionScope.studentName : 'Harish M'}"/>
                        </span>
                        <span class="pw-profile-dept">
                            <c:out value="${sessionScope.yearOfStudy != null ? sessionScope.yearOfStudy : 'CSE - 2nd Year'}"/>
                        </span>
                    </div>
                </a>
            </div>
        </header>

        <!-- Container -->
        <div class="pw-container">

            <!-- Breadcrumb & Top Right Action -->
            <div class="pw-act-breadcrumb-bar">
                <div class="pw-breadcrumb">
                    <a href="${pageContext.request.contextPath}/progress" class="pw-breadcrumb-link">Progress</a>
                    <span class="pw-breadcrumb-sep">&gt;</span>
                    <span class="pw-breadcrumb-current">Recent Activity</span>
                </div>
                <a href="${pageContext.request.contextPath}/progress" class="pw-back-to-progress-btn">
                    <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2.5">
                        <line x1="19" y1="12" x2="5" y2="12"></line>
                        <polyline points="12 19 5 12 12 5"></polyline>
                    </svg>
                    <span>Back to Progress</span>
                </a>
            </div>

            <!-- Header Title & Date Range Dropdown -->
            <div class="pw-act-header-row">
                <div class="pw-act-title-wrap">
                    <h1>Recent Activity</h1>
                    <p>Track all your activities and see how you're progressing.</p>
                </div>
                <div class="pw-act-header-actions">
                    <button type="button" class="pw-act-date-dropdown-btn" id="pwActDateBtn">
                        <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2">
                            <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                            <line x1="16" y1="2" x2="16" y2="6"></line>
                            <line x1="8" y1="2" x2="8" y2="6"></line>
                            <line x1="3" y1="10" x2="21" y2="10"></line>
                        </svg>
                        <span>October 2026</span>
                        <svg viewBox="0 0 24 24" width="12" height="12" fill="none" stroke="currentColor" stroke-width="2">
                            <polyline points="6 9 12 15 18 9"></polyline>
                        </svg>
                    </button>
                </div>
            </div>

            <!-- Main 2-Column Content Grid -->
            <div class="pw-act-grid-container">

                <!-- LEFT COLUMN: KPIs, Filters, Activity Rows, Pagination -->
                <div class="pw-act-main-col">

                    <!-- 4 Summary KPI Cards -->
                    <div class="pw-act-kpi-grid">
                        <!-- Card 1: Total Activities -->
                        <div class="pw-act-kpi-card">
                            <div class="pw-act-kpi-left">
                                <div class="pw-act-kpi-icon purple">
                                    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                                        <polyline points="14 2 14 8 20 8"></polyline>
                                        <line x1="16" y1="13" x2="8" y2="13"></line>
                                        <line x1="16" y1="17" x2="8" y2="17"></line>
                                    </svg>
                                </div>
                                <span class="pw-act-kpi-label">Total Activities</span>
                                <span class="pw-act-kpi-val">24</span>
                                <span class="pw-act-kpi-sub">This month</span>
                            </div>
                            <div class="pw-act-kpi-right">
                                <div class="pw-act-kpi-bars" title="Growth trend">
                                    <span style="height: 35%;"></span>
                                    <span style="height: 55%;"></span>
                                    <span style="height: 75%;"></span>
                                    <span style="height: 100%;"></span>
                                </div>
                            </div>
                        </div>

                        <!-- Card 2: Completed -->
                        <div class="pw-act-kpi-card">
                            <div class="pw-act-kpi-left">
                                <div class="pw-act-kpi-icon green">
                                    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2.5">
                                        <polyline points="20 6 9 17 4 12"></polyline>
                                    </svg>
                                </div>
                                <span class="pw-act-kpi-label">Completed</span>
                                <span class="pw-act-kpi-val">12</span>
                                <span class="pw-act-kpi-sub">50% of total</span>
                            </div>
                            <div class="pw-act-kpi-right">
                                <svg viewBox="0 0 42 42" width="42" height="42">
                                    <circle cx="21" cy="21" r="17" fill="none" stroke="rgba(255,255,255,0.08)" stroke-width="3.5" />
                                    <circle cx="21" cy="21" r="17" fill="none" stroke="#10b981" stroke-width="3.5" stroke-linecap="round" stroke-dasharray="106.8" stroke-dashoffset="53.4" transform="rotate(-90 21 21)" />
                                </svg>
                            </div>
                        </div>

                        <!-- Card 3: In Progress -->
                        <div class="pw-act-kpi-card">
                            <div class="pw-act-kpi-left">
                                <div class="pw-act-kpi-icon violet">
                                    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2">
                                        <circle cx="12" cy="12" r="10"></circle>
                                        <polyline points="12 6 12 12 16 14"></polyline>
                                    </svg>
                                </div>
                                <span class="pw-act-kpi-label">In Progress</span>
                                <span class="pw-act-kpi-val">8</span>
                                <span class="pw-act-kpi-sub">33% of total</span>
                            </div>
                            <div class="pw-act-kpi-right">
                                <svg viewBox="0 0 42 42" width="42" height="42">
                                    <circle cx="21" cy="21" r="17" fill="none" stroke="rgba(255,255,255,0.08)" stroke-width="3.5" />
                                    <circle cx="21" cy="21" r="17" fill="none" stroke="#8b5cf6" stroke-width="3.5" stroke-linecap="round" stroke-dasharray="106.8" stroke-dashoffset="71.5" transform="rotate(-90 21 21)" />
                                </svg>
                            </div>
                        </div>

                        <!-- Card 4: Pending -->
                        <div class="pw-act-kpi-card">
                            <div class="pw-act-kpi-left">
                                <div class="pw-act-kpi-icon orange">
                                    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2">
                                        <circle cx="12" cy="12" r="10"></circle>
                                        <polyline points="12 6 12 12 15 15"></polyline>
                                    </svg>
                                </div>
                                <span class="pw-act-kpi-label">Pending</span>
                                <span class="pw-act-kpi-val">4</span>
                                <span class="pw-act-kpi-sub">17% of total</span>
                            </div>
                            <div class="pw-act-kpi-right">
                                <svg viewBox="0 0 42 42" width="42" height="42">
                                    <circle cx="21" cy="21" r="17" fill="none" stroke="rgba(255,255,255,0.08)" stroke-width="3.5" />
                                    <circle cx="21" cy="21" r="17" fill="none" stroke="#f59e0b" stroke-width="3.5" stroke-linecap="round" stroke-dasharray="106.8" stroke-dashoffset="88.6" transform="rotate(-90 21 21)" />
                                </svg>
                            </div>
                        </div>
                    </div>

                    <!-- Filter Tabs & Sort bar -->
                    <div class="pw-act-filter-row">
                        <div class="pw-act-tabs-group">
                            <button type="button" class="pw-act-tab-pill active" onclick="filterActivityTab('all', this)">All Activities (24)</button>
                            <button type="button" class="pw-act-tab-pill" onclick="filterActivityTab('completed', this)">Completed (12)</button>
                            <button type="button" class="pw-act-tab-pill" onclick="filterActivityTab('inprogress', this)">In Progress (8)</button>
                            <button type="button" class="pw-act-tab-pill" onclick="filterActivityTab('pending', this)">Pending (4)</button>
                            <button type="button" class="pw-act-tab-pill" onclick="filterActivityTab('milestone', this)">Milestones (3)</button>
                        </div>
                        <div class="pw-act-sort-group">
                            <span class="pw-act-sort-label">Sort By</span>
                            <select class="pw-act-sort-select" onchange="sortActivities(this.value)">
                                <option value="latest">Latest</option>
                                <option value="oldest">Oldest</option>
                                <option value="title">Alphabetical</option>
                            </select>
                        </div>
                    </div>

                    <!-- Activity Rows Wrap -->
                    <div class="pw-act-rows-wrap" id="pwActRowsList">

                        <!-- Row 1: Completed DBMS Assignment -->
                        <div class="pw-act-row" data-category="completed" data-timestamp="2026-10-19T10:20:00" data-page="1">
                            <div class="pw-act-row-main">
                                <div class="pw-act-row-icon green-check">
                                    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2.5">
                                        <polyline points="20 6 9 17 4 12"></polyline>
                                    </svg>
                                </div>
                                <div class="pw-act-row-text">
                                    <div class="pw-act-row-title">Completed DBMS Assignment</div>
                                    <div class="pw-act-row-desc">ER Diagram and Relational Schema</div>
                                </div>
                            </div>
                            <div class="pw-act-subject-capsule">Database Systems</div>
                            <div class="pw-act-timestamp">
                                <svg viewBox="0 0 24 24" width="13" height="13" fill="none" stroke="currentColor" stroke-width="2">
                                    <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                    <line x1="16" y1="2" x2="16" y2="6"></line>
                                    <line x1="8" y1="2" x2="8" y2="6"></line>
                                    <line x1="3" y1="10" x2="21" y2="10"></line>
                                </svg>
                                <span>Today, 10:20 AM</span>
                            </div>
                            <span class="pw-act-status-badge completed">Completed</span>
                            <button type="button" class="pw-act-kebab-btn" title="Options" onclick="handleKebabClick(this)">&#8942;</button>
                        </div>

                        <!-- Row 2: Studied Operating Systems -->
                        <div class="pw-act-row" data-category="inprogress" data-timestamp="2026-10-19T08:45:00" data-page="1">
                            <div class="pw-act-row-main">
                                <div class="pw-act-row-icon blue-clock">
                                    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2">
                                        <circle cx="12" cy="12" r="10"></circle>
                                        <polyline points="12 6 12 12 16 14"></polyline>
                                    </svg>
                                </div>
                                <div class="pw-act-row-text">
                                    <div class="pw-act-row-title">Studied Operating Systems</div>
                                    <div class="pw-act-row-desc">Focused on Process Scheduling</div>
                                </div>
                            </div>
                            <div class="pw-act-subject-capsule">Operating Systems</div>
                            <div class="pw-act-timestamp">
                                <svg viewBox="0 0 24 24" width="13" height="13" fill="none" stroke="currentColor" stroke-width="2">
                                    <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                    <line x1="16" y1="2" x2="16" y2="6"></line>
                                    <line x1="8" y1="2" x2="8" y2="6"></line>
                                    <line x1="3" y1="10" x2="21" y2="10"></line>
                                </svg>
                                <span>Today, 08:45 AM</span>
                            </div>
                            <span class="pw-act-status-badge study">Study Session</span>
                            <button type="button" class="pw-act-kebab-btn" title="Options" onclick="handleKebabClick(this)">&#8942;</button>
                        </div>

                        <!-- Row 3: Updated Timetable -->
                        <div class="pw-act-row" data-category="inprogress" data-timestamp="2026-10-18T21:15:00" data-page="1">
                            <div class="pw-act-row-main">
                                <div class="pw-act-row-icon purple-doc">
                                    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                                        <polyline points="14 2 14 8 20 8"></polyline>
                                        <line x1="16" y1="13" x2="8" y2="13"></line>
                                        <line x1="16" y1="17" x2="8" y2="17"></line>
                                    </svg>
                                </div>
                                <div class="pw-act-row-text">
                                    <div class="pw-act-row-title">Updated Timetable</div>
                                    <div class="pw-act-row-desc">Added lab timings for Tuesday</div>
                                </div>
                            </div>
                            <div class="pw-act-subject-capsule">Personal</div>
                            <div class="pw-act-timestamp">
                                <svg viewBox="0 0 24 24" width="13" height="13" fill="none" stroke="currentColor" stroke-width="2">
                                    <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                    <line x1="16" y1="2" x2="16" y2="6"></line>
                                    <line x1="8" y1="2" x2="8" y2="6"></line>
                                    <line x1="3" y1="10" x2="21" y2="10"></line>
                                </svg>
                                <span>Yesterday, 09:15 PM</span>
                            </div>
                            <span class="pw-act-status-badge update">Update</span>
                            <button type="button" class="pw-act-kebab-btn" title="Options" onclick="handleKebabClick(this)">&#8942;</button>
                        </div>

                        <!-- Row 4: Created a New Goal -->
                        <div class="pw-act-row" data-category="pending" data-timestamp="2026-10-18T16:30:00" data-page="1">
                            <div class="pw-act-row-main">
                                <div class="pw-act-row-icon red-goal">
                                    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2">
                                        <circle cx="12" cy="12" r="10"></circle>
                                        <circle cx="12" cy="12" r="6"></circle>
                                        <circle cx="12" cy="12" r="2"></circle>
                                    </svg>
                                </div>
                                <div class="pw-act-row-text">
                                    <div class="pw-act-row-title">Created a New Goal</div>
                                    <div class="pw-act-row-desc">Complete all pending lab records</div>
                                </div>
                            </div>
                            <div class="pw-act-subject-capsule">Goal</div>
                            <div class="pw-act-timestamp">
                                <svg viewBox="0 0 24 24" width="13" height="13" fill="none" stroke="currentColor" stroke-width="2">
                                    <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                    <line x1="16" y1="2" x2="16" y2="6"></line>
                                    <line x1="8" y1="2" x2="8" y2="6"></line>
                                    <line x1="3" y1="10" x2="21" y2="10"></line>
                                </svg>
                                <span>Yesterday, 04:30 PM</span>
                            </div>
                            <span class="pw-act-status-badge goal">Goal</span>
                            <button type="button" class="pw-act-kebab-btn" title="Options" onclick="handleKebabClick(this)">&#8942;</button>
                        </div>

                        <!-- Row 5: Revised Java Notes -->
                        <div class="pw-act-row" data-category="inprogress" data-timestamp="2026-10-16T19:10:00" data-page="1">
                            <div class="pw-act-row-main">
                                <div class="pw-act-row-icon orange-edit">
                                    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M12 20h9"></path>
                                        <path d="M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4L16.5 3.5z"></path>
                                    </svg>
                                </div>
                                <div class="pw-act-row-text">
                                    <div class="pw-act-row-title">Revised Java Notes</div>
                                    <div class="pw-act-row-desc">OOP Concepts - Polymorphism</div>
                                </div>
                            </div>
                            <div class="pw-act-subject-capsule">Software Engineering</div>
                            <div class="pw-act-timestamp">
                                <svg viewBox="0 0 24 24" width="13" height="13" fill="none" stroke="currentColor" stroke-width="2">
                                    <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                    <line x1="16" y1="2" x2="16" y2="6"></line>
                                    <line x1="8" y1="2" x2="8" y2="6"></line>
                                    <line x1="3" y1="10" x2="21" y2="10"></line>
                                </svg>
                                <span>16 Oct 2026, 07:10 PM</span>
                            </div>
                            <span class="pw-act-status-badge study">Study Session</span>
                            <button type="button" class="pw-act-kebab-btn" title="Options" onclick="handleKebabClick(this)">&#8942;</button>
                        </div>

                        <!-- Row 6: Joined a Study Group -->
                        <div class="pw-act-row" data-category="inprogress" data-timestamp="2026-10-15T18:45:00" data-page="1">
                            <div class="pw-act-row-main">
                                <div class="pw-act-row-icon purple-group">
                                    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                                        <circle cx="9" cy="7" r="4"></circle>
                                        <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                                        <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                                    </svg>
                                </div>
                                <div class="pw-act-row-text">
                                    <div class="pw-act-row-title">Joined a Study Group</div>
                                    <div class="pw-act-row-desc">Operating Systems Discussion</div>
                                </div>
                            </div>
                            <div class="pw-act-subject-capsule">Club Activity</div>
                            <div class="pw-act-timestamp">
                                <svg viewBox="0 0 24 24" width="13" height="13" fill="none" stroke="currentColor" stroke-width="2">
                                    <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                    <line x1="16" y1="2" x2="16" y2="6"></line>
                                    <line x1="8" y1="2" x2="8" y2="6"></line>
                                    <line x1="3" y1="10" x2="21" y2="10"></line>
                                </svg>
                                <span>15 Oct 2026, 06:45 PM</span>
                            </div>
                            <span class="pw-act-status-badge group">Group</span>
                            <button type="button" class="pw-act-kebab-btn" title="Options" onclick="handleKebabClick(this)">&#8942;</button>
                        </div>

                        <!-- Row 7: Uploaded Material -->
                        <div class="pw-act-row" data-category="completed" data-timestamp="2026-10-14T11:30:00" data-page="1">
                            <div class="pw-act-row-main">
                                <div class="pw-act-row-icon blue-upload">
                                    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path>
                                        <polyline points="17 8 12 3 7 8"></polyline>
                                        <line x1="12" y1="3" x2="12" y2="15"></line>
                                    </svg>
                                </div>
                                <div class="pw-act-row-text">
                                    <div class="pw-act-row-title">Uploaded Material</div>
                                    <div class="pw-act-row-desc">OS Lab Manual</div>
                                </div>
                            </div>
                            <div class="pw-act-subject-capsule">Operating Systems</div>
                            <div class="pw-act-timestamp">
                                <svg viewBox="0 0 24 24" width="13" height="13" fill="none" stroke="currentColor" stroke-width="2">
                                    <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                    <line x1="16" y1="2" x2="16" y2="6"></line>
                                    <line x1="8" y1="2" x2="8" y2="6"></line>
                                    <line x1="3" y1="10" x2="21" y2="10"></line>
                                </svg>
                                <span>14 Oct 2026, 11:30 AM</span>
                            </div>
                            <span class="pw-act-status-badge material">Material</span>
                            <button type="button" class="pw-act-kebab-btn" title="Options" onclick="handleKebabClick(this)">&#8942;</button>
                        </div>

                        <!-- Row 8: Completed DSA Practice -->
                        <div class="pw-act-row" data-category="completed" data-timestamp="2026-10-14T09:20:00" data-page="1">
                            <div class="pw-act-row-main">
                                <div class="pw-act-row-icon green-check">
                                    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2.5">
                                        <polyline points="20 6 9 17 4 12"></polyline>
                                    </svg>
                                </div>
                                <div class="pw-act-row-text">
                                    <div class="pw-act-row-title">Completed DSA Practice</div>
                                    <div class="pw-act-row-desc">Arrays and Searching</div>
                                </div>
                            </div>
                            <div class="pw-act-subject-capsule">Data Structures</div>
                            <div class="pw-act-timestamp">
                                <svg viewBox="0 0 24 24" width="13" height="13" fill="none" stroke="currentColor" stroke-width="2">
                                    <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                    <line x1="16" y1="2" x2="16" y2="6"></line>
                                    <line x1="8" y1="2" x2="8" y2="6"></line>
                                    <line x1="3" y1="10" x2="21" y2="10"></line>
                                </svg>
                                <span>14 Oct 2026, 09:20 AM</span>
                            </div>
                            <span class="pw-act-status-badge completed">Completed</span>
                            <button type="button" class="pw-act-kebab-btn" title="Options" onclick="handleKebabClick(this)">&#8942;</button>
                        </div>

                        <!-- Row 9: Achieved 7-day Study Streak -->
                        <div class="pw-act-row" data-category="milestone" data-timestamp="2026-10-13T22:00:00" data-page="1">
                            <div class="pw-act-row-main">
                                <div class="pw-act-row-icon yellow-trophy">
                                    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M6 9H4.5a2.5 2.5 0 0 1 0-5H6"></path>
                                        <path d="M18 9h1.5a2.5 2.5 0 0 0 0-5H18"></path>
                                        <path d="M4 22h16"></path>
                                        <path d="M10 14.66V17c0 .55-.45 1-1 1H7v4h10v-4h-2c-.55 0-1-.45-1-1v-2.34"></path>
                                        <path d="M18 4H6v7a6 6 0 0 0 12 0V4z"></path>
                                    </svg>
                                </div>
                                <div class="pw-act-row-text">
                                    <div class="pw-act-row-title">Achieved 7-day Study Streak</div>
                                    <div class="pw-act-row-desc">You studied for 7 consecutive days!</div>
                                </div>
                            </div>
                            <div class="pw-act-subject-capsule">Achievement</div>
                            <div class="pw-act-timestamp">
                                <svg viewBox="0 0 24 24" width="13" height="13" fill="none" stroke="currentColor" stroke-width="2">
                                    <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                    <line x1="16" y1="2" x2="16" y2="6"></line>
                                    <line x1="8" y1="2" x2="8" y2="6"></line>
                                    <line x1="3" y1="10" x2="21" y2="10"></line>
                                </svg>
                                <span>13 Oct 2026, 10:00 PM</span>
                            </div>
                            <span class="pw-act-status-badge milestone">Milestone</span>
                            <button type="button" class="pw-act-kebab-btn" title="Options" onclick="handleKebabClick(this)">&#8942;</button>
                        </div>

                        <!-- Row 10: Started Smart Planner Session -->
                        <div class="pw-act-row" data-category="inprogress" data-timestamp="2026-10-12T20:15:00" data-page="1">
                            <div class="pw-act-row-main">
                                <div class="pw-act-row-icon pink-timer">
                                    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2">
                                        <circle cx="12" cy="12" r="10"></circle>
                                        <polyline points="12 6 12 12 16 14"></polyline>
                                    </svg>
                                </div>
                                <div class="pw-act-row-text">
                                    <div class="pw-act-row-title">Started Smart Planner Session</div>
                                    <div class="pw-act-row-desc">Generated study plan for next week</div>
                                </div>
                            </div>
                            <div class="pw-act-subject-capsule">Smart Planner</div>
                            <div class="pw-act-timestamp">
                                <svg viewBox="0 0 24 24" width="13" height="13" fill="none" stroke="currentColor" stroke-width="2">
                                    <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                    <line x1="16" y1="2" x2="16" y2="6"></line>
                                    <line x1="8" y1="2" x2="8" y2="6"></line>
                                    <line x1="3" y1="10" x2="21" y2="10"></line>
                                </svg>
                                <span>12 Oct 2026, 08:15 PM</span>
                            </div>
                            <span class="pw-act-status-badge planner">Planner</span>
                            <button type="button" class="pw-act-kebab-btn" title="Options" onclick="handleKebabClick(this)">&#8942;</button>
                        </div>

                        <!-- Additional rows for Page 2 & 3 -->
                        <div class="pw-act-row" data-category="completed" data-timestamp="2026-10-12T14:30:00" data-page="2" style="display: none;">
                            <div class="pw-act-row-main">
                                <div class="pw-act-row-icon green-check">
                                    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="20 6 9 17 4 12"></polyline></svg>
                                </div>
                                <div class="pw-act-row-text">
                                    <div class="pw-act-row-title">Completed Java OOP Project</div>
                                    <div class="pw-act-row-desc">Inventory Management Architecture</div>
                                </div>
                            </div>
                            <div class="pw-act-subject-capsule">Software Engineering</div>
                            <div class="pw-act-timestamp">
                                <svg viewBox="0 0 24 24" width="13" height="13" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                                <span>12 Oct 2026, 02:30 PM</span>
                            </div>
                            <span class="pw-act-status-badge completed">Completed</span>
                            <button type="button" class="pw-act-kebab-btn" title="Options" onclick="handleKebabClick(this)">&#8942;</button>
                        </div>

                        <div class="pw-act-row" data-category="inprogress" data-timestamp="2026-10-11T16:00:00" data-page="2" style="display: none;">
                            <div class="pw-act-row-main">
                                <div class="pw-act-row-icon blue-clock">
                                    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                                </div>
                                <div class="pw-act-row-text">
                                    <div class="pw-act-row-title">Practiced SQL Subqueries</div>
                                    <div class="pw-act-row-desc">Complex nested queries and views</div>
                                </div>
                            </div>
                            <div class="pw-act-subject-capsule">Database Systems</div>
                            <div class="pw-act-timestamp">
                                <svg viewBox="0 0 24 24" width="13" height="13" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                                <span>11 Oct 2026, 04:00 PM</span>
                            </div>
                            <span class="pw-act-status-badge study">Study Session</span>
                            <button type="button" class="pw-act-kebab-btn" title="Options" onclick="handleKebabClick(this)">&#8942;</button>
                        </div>

                        <div class="pw-act-row" data-category="completed" data-timestamp="2026-10-10T11:20:00" data-page="2" style="display: none;">
                            <div class="pw-act-row-main">
                                <div class="pw-act-row-icon green-check">
                                    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="20 6 9 17 4 12"></polyline></svg>
                                </div>
                                <div class="pw-act-row-text">
                                    <div class="pw-act-row-title">Completed CN Subnetting Problem Set</div>
                                    <div class="pw-act-row-desc">VLSM calculation & CIDR masks</div>
                                </div>
                            </div>
                            <div class="pw-act-subject-capsule">Operating Systems</div>
                            <div class="pw-act-timestamp">
                                <svg viewBox="0 0 24 24" width="13" height="13" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                                <span>10 Oct 2026, 11:20 AM</span>
                            </div>
                            <span class="pw-act-status-badge completed">Completed</span>
                            <button type="button" class="pw-act-kebab-btn" title="Options" onclick="handleKebabClick(this)">&#8942;</button>
                        </div>

                        <div class="pw-act-row" data-category="milestone" data-timestamp="2026-10-09T18:00:00" data-page="2" style="display: none;">
                            <div class="pw-act-row-main">
                                <div class="pw-act-row-icon yellow-trophy">
                                    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2"><path d="M6 9H4.5a2.5 2.5 0 0 1 0-5H6"></path><path d="M18 9h1.5a2.5 2.5 0 0 0 0-5H18"></path><path d="M4 22h16"></path><path d="M10 14.66V17c0 .55-.45 1-1 1H7v4h10v-4h-2c-.55 0-1-.45-1-1v-2.34"></path><path d="M18 4H6v7a6 6 0 0 0 12 0V4z"></path></svg>
                                </div>
                                <div class="pw-act-row-text">
                                    <div class="pw-act-row-title">Achieved 50 Study Hours Badge</div>
                                    <div class="pw-act-row-desc">Crossed 50 hours of active focus time</div>
                                </div>
                            </div>
                            <div class="pw-act-subject-capsule">Achievement</div>
                            <div class="pw-act-timestamp">
                                <svg viewBox="0 0 24 24" width="13" height="13" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                                <span>09 Oct 2026, 06:00 PM</span>
                            </div>
                            <span class="pw-act-status-badge milestone">Milestone</span>
                            <button type="button" class="pw-act-kebab-btn" title="Options" onclick="handleKebabClick(this)">&#8942;</button>
                        </div>

                        <div class="pw-act-row" data-category="pending" data-timestamp="2026-10-08T15:00:00" data-page="2" style="display: none;">
                            <div class="pw-act-row-main">
                                <div class="pw-act-row-icon red-goal">
                                    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><circle cx="12" cy="12" r="6"></circle><circle cx="12" cy="12" r="2"></circle></svg>
                                </div>
                                <div class="pw-act-row-text">
                                    <div class="pw-act-row-title">Scheduled AI Study Session</div>
                                    <div class="pw-act-row-desc">Review Heuristic Search algorithms</div>
                                </div>
                            </div>
                            <div class="pw-act-subject-capsule">Goal</div>
                            <div class="pw-act-timestamp">
                                <svg viewBox="0 0 24 24" width="13" height="13" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                                <span>08 Oct 2026, 03:00 PM</span>
                            </div>
                            <span class="pw-act-status-badge goal">Goal</span>
                            <button type="button" class="pw-act-kebab-btn" title="Options" onclick="handleKebabClick(this)">&#8942;</button>
                        </div>

                        <div class="pw-act-row" data-category="pending" data-timestamp="2026-10-07T12:00:00" data-page="3" style="display: none;">
                            <div class="pw-act-row-main">
                                <div class="pw-act-row-icon red-goal">
                                    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><circle cx="12" cy="12" r="6"></circle><circle cx="12" cy="12" r="2"></circle></svg>
                                </div>
                                <div class="pw-act-row-text">
                                    <div class="pw-act-row-title">Submit Web Engineering Lab Record</div>
                                    <div class="pw-act-row-desc">Servlet & JSP session management</div>
                                </div>
                            </div>
                            <div class="pw-act-subject-capsule">Personal</div>
                            <div class="pw-act-timestamp">
                                <svg viewBox="0 0 24 24" width="13" height="13" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                                <span>07 Oct 2026, 12:00 PM</span>
                            </div>
                            <span class="pw-act-status-badge goal">Goal</span>
                            <button type="button" class="pw-act-kebab-btn" title="Options" onclick="handleKebabClick(this)">&#8942;</button>
                        </div>

                        <div class="pw-act-row" data-category="milestone" data-timestamp="2026-10-05T09:00:00" data-page="3" style="display: none;">
                            <div class="pw-act-row-main">
                                <div class="pw-act-row-icon yellow-trophy">
                                    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2"><path d="M6 9H4.5a2.5 2.5 0 0 1 0-5H6"></path><path d="M18 9h1.5a2.5 2.5 0 0 0 0-5H18"></path><path d="M4 22h16"></path><path d="M10 14.66V17c0 .55-.45 1-1 1H7v4h10v-4h-2c-.55 0-1-.45-1-1v-2.34"></path><path d="M18 4H6v7a6 6 0 0 0 12 0V4z"></path></svg>
                                </div>
                                <div class="pw-act-row-text">
                                    <div class="pw-act-row-title">First Monthly Assessment Ace</div>
                                    <div class="pw-act-row-desc">Scored 94% on midterm practice exam</div>
                                </div>
                            </div>
                            <div class="pw-act-subject-capsule">Achievement</div>
                            <div class="pw-act-timestamp">
                                <svg viewBox="0 0 24 24" width="13" height="13" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                                <span>05 Oct 2026, 09:00 AM</span>
                            </div>
                            <span class="pw-act-status-badge milestone">Milestone</span>
                            <button type="button" class="pw-act-kebab-btn" title="Options" onclick="handleKebabClick(this)">&#8942;</button>
                        </div>

                    </div><!-- end pw-act-rows-wrap -->

                    <!-- Pagination Footer -->
                    <div class="pw-act-pagination">
                        <span class="pw-act-pagination-info" id="pwActPaginationInfo">Showing 1 to 10 of 24 activities</span>
                        <div class="pw-act-pagination-btns">
                            <button type="button" class="pw-act-page-btn" onclick="prevActivityPage()" title="Previous Page">&lt;</button>
                            <button type="button" class="pw-act-page-btn active" id="pwPageBtn1" onclick="changeActivityPage(1)">1</button>
                            <button type="button" class="pw-act-page-btn" id="pwPageBtn2" onclick="changeActivityPage(2)">2</button>
                            <button type="button" class="pw-act-page-btn" id="pwPageBtn3" onclick="changeActivityPage(3)">3</button>
                            <button type="button" class="pw-act-page-btn" onclick="nextActivityPage()" title="Next Page">&gt;</button>
                        </div>
                    </div>

                </div><!-- end pw-act-main-col -->

                <!-- RIGHT COLUMN: Calendar, Distribution Donut, Top Subjects, Productivity Summary -->
                <div class="pw-act-side-col">

                    <!-- Widget 1: Activity Calendar -->
                    <div class="pw-act-side-card">
                        <div class="pw-act-side-card-header">
                            <div class="pw-act-side-card-title">
                                <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2">
                                    <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                    <line x1="16" y1="2" x2="16" y2="6"></line>
                                    <line x1="8" y1="2" x2="8" y2="6"></line>
                                    <line x1="3" y1="10" x2="21" y2="10"></line>
                                </svg>
                                <span>Activity Calendar</span>
                            </div>
                        </div>

                        <div class="pw-cal-month-nav">
                            <span class="pw-cal-month-name">October 2026</span>
                            <div class="pw-cal-nav-arrows">
                                <button type="button" class="pw-cal-arrow-btn" title="Previous Month">&lt;</button>
                                <button type="button" class="pw-cal-arrow-btn" title="Next Month">&gt;</button>
                            </div>
                        </div>

                        <div class="pw-cal-weekdays">
                            <span>Mon</span><span>Tue</span><span>Wed</span><span>Thu</span><span>Fri</span><span>Sat</span><span>Sun</span>
                        </div>

                        <div class="pw-cal-grid">
                            <!-- Week 1 -->
                            <div class="pw-cal-day" style="opacity: 0.3;"></div>
                            <div class="pw-cal-day" style="opacity: 0.3;"></div>
                            <div class="pw-cal-day" style="opacity: 0.3;"></div>
                            <div class="pw-cal-day">1</div>
                            <div class="pw-cal-day">2</div>
                            <div class="pw-cal-day">3</div>
                            <div class="pw-cal-day">4</div>
                            <!-- Week 2 -->
                            <div class="pw-cal-day">5<span class="pw-cal-dots"><span class="pw-cal-dot"></span><span class="pw-cal-dot"></span></span></div>
                            <div class="pw-cal-day">6</div>
                            <div class="pw-cal-day">7<span class="pw-cal-dots"><span class="pw-cal-dot"></span><span class="pw-cal-dot"></span></span></div>
                            <div class="pw-cal-day">8</div>
                            <div class="pw-cal-day">9</div>
                            <div class="pw-cal-day">10</div>
                            <div class="pw-cal-day">11</div>
                            <!-- Week 3 -->
                            <div class="pw-cal-day">12<span class="pw-cal-dots"><span class="pw-cal-dot"></span><span class="pw-cal-dot"></span></span></div>
                            <div class="pw-cal-day">13<span class="pw-cal-dots"><span class="pw-cal-dot"></span><span class="pw-cal-dot"></span></span></div>
                            <div class="pw-cal-day">14<span class="pw-cal-dots"><span class="pw-cal-dot"></span><span class="pw-cal-dot"></span></span></div>
                            <div class="pw-cal-day">15<span class="pw-cal-dots"><span class="pw-cal-dot"></span><span class="pw-cal-dot"></span></span></div>
                            <div class="pw-cal-day">16<span class="pw-cal-dots"><span class="pw-cal-dot"></span><span class="pw-cal-dot"></span></span></div>
                            <div class="pw-cal-day">17</div>
                            <div class="pw-cal-day active-day" title="Today - Oct 18">18</div>
                            <!-- Week 4 -->
                            <div class="pw-cal-day">19</div>
                            <div class="pw-cal-day">20</div>
                            <div class="pw-cal-day">21</div>
                            <div class="pw-cal-day">22</div>
                            <div class="pw-cal-day">23</div>
                            <div class="pw-cal-day">24</div>
                            <div class="pw-cal-day">25</div>
                            <!-- Week 5 -->
                            <div class="pw-cal-day">26</div>
                            <div class="pw-cal-day">27</div>
                            <div class="pw-cal-day">28</div>
                            <div class="pw-cal-day">29</div>
                            <div class="pw-cal-day">30</div>
                            <div class="pw-cal-day">31</div>
                            <div class="pw-cal-day" style="opacity: 0.3;"></div>
                        </div>
                    </div>

                    <!-- Widget 2: Activity Type Distribution -->
                    <div class="pw-act-side-card">
                        <div class="pw-act-side-card-header">
                            <div class="pw-act-side-card-title">
                                <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M21.21 15.89A10 10 0 1 1 8 2.83"></path>
                                    <path d="M22 12A10 10 0 0 0 12 2v10z"></path>
                                </svg>
                                <span>Activity Type Distribution</span>
                            </div>
                        </div>
                        <div class="pw-dist-wrap">
                            <div class="pw-dist-donut">
                                <svg viewBox="0 0 120 120" width="105" height="105">
                                    <circle cx="60" cy="60" r="44" fill="none" stroke="rgba(255,255,255,0.06)" stroke-width="14" />
                                    <!-- Completed (50% = 138.2) -->
                                    <circle cx="60" cy="60" r="44" fill="none" stroke="#10b981" stroke-width="14"
                                            stroke-dasharray="138.2 276.4" stroke-dashoffset="0" transform="rotate(-90 60 60)" />
                                    <!-- In Progress (33% = 92.1) -->
                                    <circle cx="60" cy="60" r="44" fill="none" stroke="#8b5cf6" stroke-width="14"
                                            stroke-dasharray="92.1 276.4" stroke-dashoffset="-138.2" transform="rotate(-90 60 60)" />
                                    <!-- Pending (17% = 46.1) -->
                                    <circle cx="60" cy="60" r="44" fill="none" stroke="#f59e0b" stroke-width="14"
                                            stroke-dasharray="46.1 276.4" stroke-dashoffset="-230.3" transform="rotate(-90 60 60)" />
                                    <!-- Center text -->
                                    <text x="60" y="56" text-anchor="middle" dominant-baseline="middle" fill="#ffffff" font-size="20" font-weight="700">24</text>
                                    <text x="60" y="73" text-anchor="middle" dominant-baseline="middle" fill="#8492a6" font-size="9" font-weight="500">Activities</text>
                                </svg>
                            </div>
                            <div class="pw-dist-legend">
                                <div class="pw-dist-legend-item">
                                    <div class="pw-dist-legend-left">
                                        <span class="pw-dist-legend-dot green"></span>
                                        <span>Completed</span>
                                    </div>
                                    <span class="pw-dist-legend-val">12 (50%)</span>
                                </div>
                                <div class="pw-dist-legend-item">
                                    <div class="pw-dist-legend-left">
                                        <span class="pw-dist-legend-dot purple"></span>
                                        <span>In Progress</span>
                                    </div>
                                    <span class="pw-dist-legend-val">8 (33%)</span>
                                </div>
                                <div class="pw-dist-legend-item">
                                    <div class="pw-dist-legend-left">
                                        <span class="pw-dist-legend-dot orange"></span>
                                        <span>Pending</span>
                                    </div>
                                    <span class="pw-dist-legend-val">4 (17%)</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Widget 3: Top Subjects by Activity -->
                    <div class="pw-act-side-card">
                        <div class="pw-act-side-card-header">
                            <div class="pw-act-side-card-title">
                                <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path>
                                    <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path>
                                </svg>
                                <span>Top Subjects by Activity</span>
                            </div>
                            <div style="display: flex; align-items: center; gap: 4px; font-size: 0.72rem; color: #8492a6; cursor: pointer;">
                                <span>This Month</span>
                                <svg viewBox="0 0 24 24" width="10" height="10" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                            </div>
                        </div>
                        <div class="pw-subj-list">
                            <!-- 1. Database Systems -->
                            <div class="pw-subj-row">
                                <div class="pw-subj-icon" style="background: rgba(99, 102, 241, 0.15); color: #818cf8;">
                                    <svg viewBox="0 0 24 24" width="12" height="12" fill="none" stroke="currentColor" stroke-width="2"><ellipse cx="12" cy="5" rx="9" ry="3"></ellipse><path d="M21 12c0 1.66-4 3-9 3s-9-1.34-9-3"></path><path d="M3 5v14c0 1.66 4 3 9 3s9-1.34 9-3V5"></path></svg>
                                </div>
                                <span class="pw-subj-name">Database Systems</span>
                                <div class="pw-subj-bar">
                                    <div class="pw-subj-fill" style="width: 85%; background: #6366f1;"></div>
                                </div>
                                <span class="pw-subj-count">6</span>
                            </div>
                            <!-- 2. Operating Systems -->
                            <div class="pw-subj-row">
                                <div class="pw-subj-icon" style="background: rgba(56, 189, 248, 0.15); color: #38bdf8;">
                                    <svg viewBox="0 0 24 24" width="12" height="12" fill="none" stroke="currentColor" stroke-width="2"><rect x="2" y="3" width="20" height="14" rx="2" ry="2"></rect><line x1="8" y1="21" x2="16" y2="21"></line><line x1="12" y1="17" x2="12" y2="21"></line></svg>
                                </div>
                                <span class="pw-subj-name">Operating Systems</span>
                                <div class="pw-subj-bar">
                                    <div class="pw-subj-fill" style="width: 70%; background: #38bdf8;"></div>
                                </div>
                                <span class="pw-subj-count">5</span>
                            </div>
                            <!-- 3. Data Structures -->
                            <div class="pw-subj-row">
                                <div class="pw-subj-icon" style="background: rgba(16, 185, 129, 0.15); color: #2dd4bf;">
                                    <svg viewBox="0 0 24 24" width="12" height="12" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z"></path></svg>
                                </div>
                                <span class="pw-subj-name">Data Structures</span>
                                <div class="pw-subj-bar">
                                    <div class="pw-subj-fill" style="width: 55%; background: #2dd4bf;"></div>
                                </div>
                                <span class="pw-subj-count">4</span>
                            </div>
                            <!-- 4. Software Engineering -->
                            <div class="pw-subj-row">
                                <div class="pw-subj-icon" style="background: rgba(249, 115, 22, 0.15); color: #f97316;">
                                    <svg viewBox="0 0 24 24" width="12" height="12" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path></svg>
                                </div>
                                <span class="pw-subj-name">Software Engineering</span>
                                <div class="pw-subj-bar">
                                    <div class="pw-subj-fill" style="width: 55%; background: #f97316;"></div>
                                </div>
                                <span class="pw-subj-count">4</span>
                            </div>
                            <!-- 5. Mathematics -->
                            <div class="pw-subj-row">
                                <div class="pw-subj-icon" style="background: rgba(236, 72, 153, 0.15); color: #ec4899;">
                                    <svg viewBox="0 0 24 24" width="12" height="12" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 20h4l4-16h4"></path></svg>
                                </div>
                                <span class="pw-subj-name">Mathematics</span>
                                <div class="pw-subj-bar">
                                    <div class="pw-subj-fill" style="width: 40%; background: #ec4899;"></div>
                                </div>
                                <span class="pw-subj-count">3</span>
                            </div>
                        </div>
                    </div>

                    <!-- Widget 4: Productivity Summary -->
                    <div class="pw-act-side-card">
                        <div class="pw-act-side-card-header">
                            <div class="pw-act-side-card-title">
                                <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2">
                                    <line x1="18" y1="20" x2="18" y2="10"></line>
                                    <line x1="12" y1="20" x2="12" y2="4"></line>
                                    <line x1="6" y1="20" x2="6" y2="14"></line>
                                </svg>
                                <span>Productivity Summary</span>
                            </div>
                            <div style="display: flex; align-items: center; gap: 4px; font-size: 0.72rem; color: #8492a6; cursor: pointer;">
                                <span>This Month</span>
                                <svg viewBox="0 0 24 24" width="10" height="10" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                            </div>
                        </div>
                        <div class="pw-prod-grid">
                            <!-- Tile 1: Study hours -->
                            <div class="pw-prod-tile">
                                <div class="pw-prod-tile-icon blue">
                                    <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                                </div>
                                <div class="pw-prod-tile-num">
                                    <span>18.5 h</span>
                                    <span class="trend-up">&#8679; 9</span>
                                </div>
                                <span class="pw-prod-tile-label">Total study hours</span>
                            </div>
                            <!-- Tile 2: Tasks completed -->
                            <div class="pw-prod-tile">
                                <div class="pw-prod-tile-icon green">
                                    <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><polyline points="9 15 11 17 15 13"></polyline></svg>
                                </div>
                                <div class="pw-prod-tile-num">
                                    <span>12</span>
                                </div>
                                <span class="pw-prod-tile-label">Tasks completed</span>
                            </div>
                            <!-- Tile 3: Goals updated -->
                            <div class="pw-prod-tile">
                                <div class="pw-prod-tile-icon red">
                                    <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><circle cx="12" cy="12" r="6"></circle><circle cx="12" cy="12" r="2"></circle></svg>
                                </div>
                                <div class="pw-prod-tile-num">
                                    <span>4</span>
                                    <span class="trend-up">&#8679; 0</span>
                                </div>
                                <span class="pw-prod-tile-label">Goals updated</span>
                            </div>
                            <!-- Tile 4: Club activities -->
                            <div class="pw-prod-tile">
                                <div class="pw-prod-tile-icon purple">
                                    <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg>
                                </div>
                                <div class="pw-prod-tile-num">
                                    <span>3</span>
                                </div>
                                <span class="pw-prod-tile-label">Club activities</span>
                            </div>
                        </div>
                    </div>

                </div><!-- end pw-act-side-col -->

            </div><!-- end pw-act-grid-container -->

        </div><!-- end pw-container -->
    </main>
</div><!-- end pw-layout -->

<script>
// Filter, Pagination, Search & Sorting Scripts
var currentActFilter = 'all';
var currentActPage = 1;
var totalActPages = 3;
var currentActSearch = '';

function filterActivityTab(category, btn) {
    currentActFilter = category;
    currentActPage = 1;

    var pills = document.querySelectorAll('.pw-act-tab-pill');
    pills.forEach(function(p) { p.classList.remove('active'); });
    if (btn) btn.classList.add('active');

    applyActivityFilters();
}

function handleGlobalSearch(keyword) {
    currentActSearch = (keyword || '').toLowerCase().trim();
    applyActivityFilters();
}

function applyActivityFilters() {
    var rows = document.querySelectorAll('.pw-act-row');
    var visibleCount = 0;
    var totalMatches = 0;

    rows.forEach(function(row) {
        var rowCat = row.getAttribute('data-category') || '';
        var rowPage = parseInt(row.getAttribute('data-page') || '1', 10);
        var rowText = (row.textContent || '').toLowerCase();

        var matchesCategory = (currentActFilter === 'all') || (rowCat === currentActFilter);
        var matchesSearch = !currentActSearch || (rowText.indexOf(currentActSearch) !== -1);

        if (matchesCategory && matchesSearch) {
            totalMatches++;
            if (currentActFilter === 'all' && !currentActSearch) {
                if (rowPage === currentActPage) {
                    row.style.display = 'flex';
                    visibleCount++;
                } else {
                    row.style.display = 'none';
                }
            } else {
                row.style.display = 'flex';
                visibleCount++;
            }
        } else {
            row.style.display = 'none';
        }
    });

    var info = document.getElementById('pwActPaginationInfo');
    if (info) {
        if (currentActFilter === 'all' && !currentActSearch) {
            var start = (currentActPage - 1) * 10 + 1;
            var end = Math.min(currentActPage * 10, 24);
            info.textContent = 'Showing ' + start + ' to ' + end + ' of 24 activities';
        } else {
            info.textContent = 'Showing ' + visibleCount + ' of ' + totalMatches + ' matching activities';
        }
    }

    for (var i = 1; i <= 3; i++) {
        var pBtn = document.getElementById('pwPageBtn' + i);
        if (pBtn) {
            if (i === currentActPage && currentActFilter === 'all' && !currentActSearch) {
                pBtn.classList.add('active');
            } else {
                pBtn.classList.remove('active');
            }
        }
    }
}

function changeActivityPage(page) {
    currentActPage = page;
    applyActivityFilters();
}

function prevActivityPage() {
    if (currentActPage > 1) {
        currentActPage--;
        applyActivityFilters();
    }
}

function nextActivityPage() {
    if (currentActPage < totalActPages) {
        currentActPage++;
        applyActivityFilters();
    }
}

function sortActivities(criteria) {
    var container = document.getElementById('pwActRowsList');
    if (!container) return;
    var rows = Array.from(container.querySelectorAll('.pw-act-row'));

    rows.sort(function(a, b) {
        if (criteria === 'latest') {
            var timeA = new Date(a.getAttribute('data-timestamp') || 0).getTime();
            var timeB = new Date(b.getAttribute('data-timestamp') || 0).getTime();
            return timeB - timeA;
        } else if (criteria === 'oldest') {
            var timeA = new Date(a.getAttribute('data-timestamp') || 0).getTime();
            var timeB = new Date(b.getAttribute('data-timestamp') || 0).getTime();
            return timeA - timeB;
        } else if (criteria === 'title') {
            var titleA = (a.querySelector('.pw-act-row-title') ? a.querySelector('.pw-act-row-title').textContent : '').trim();
            var titleB = (b.querySelector('.pw-act-row-title') ? b.querySelector('.pw-act-row-title').textContent : '').trim();
            return titleA.localeCompare(titleB);
        }
        return 0;
    });

    rows.forEach(function(row) {
        container.appendChild(row);
    });
}

function handleKebabClick(btn) {
    // Subtle visual indicator for action button
    btn.style.transform = 'scale(1.2)';
    setTimeout(function() { btn.style.transform = ''; }, 150);
}
</script>

</body>
</html>
