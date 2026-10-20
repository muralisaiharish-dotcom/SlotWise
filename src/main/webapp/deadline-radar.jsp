<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
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
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Deadline Radar &mdash; SlotWise</title>
    <meta name="description" content="Track all your important academic, assignment, project, and exam deadlines in one place.">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg-body: #060814;
            --bg-sidebar: #070a18;
            --bg-card: #090e22;
            --bg-card-inner: #0e152e;
            --border-card: rgba(255, 255, 255, 0.06);
            --border-subtle: rgba(255, 255, 255, 0.08);
            --primary-purple: #6d5dfc;
            --accent-glow: rgba(99, 102, 241, 0.35);
            --text-main: #f8fafc;
            --text-muted: #8492a6;
            --text-dim: #475569;
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

        /* ===== LAYOUT ===== */
        .sw-layout {
            display: flex;
            min-height: 100vh;
            background: #060814;
        }

        /* ===== SIDEBAR ===== */
        .sw-sidebar {
            width: 240px;
            min-width: 240px;
            background: var(--bg-sidebar);
            border-right: 1px solid var(--border-card);
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            padding: 22px 16px 20px;
            position: sticky;
            top: 0;
            height: 100vh;
            z-index: 40;
            flex-shrink: 0;
        }

        .sw-logo {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 2px 8px 24px;
        }

        .sw-logo-icon {
            width: 36px;
            height: 36px;
            background: linear-gradient(135deg, #6366f1, #8b5cf6);
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            box-shadow: 0 4px 14px var(--accent-glow);
        }

        .sw-logo-text {
            font-size: 1.25rem;
            font-weight: 700;
            color: #fff;
            letter-spacing: -0.02em;
        }
        .sw-logo-text span { color: #8b5cf6; }

        .sw-nav {
            display: flex;
            flex-direction: column;
            gap: 4px;
            flex: 1;
            overflow-y: auto;
        }
        .sw-nav::-webkit-scrollbar { width: 3px; }
        .sw-nav::-webkit-scrollbar-thumb { background: rgba(255,255,255,0.1); border-radius: 4px; }

        .sw-nav-item {
            display: flex;
            align-items: center;
            gap: 14px;
            padding: 10px 14px;
            border-radius: 10px;
            color: var(--text-muted);
            font-size: 0.88rem;
            font-weight: 500;
            transition: all 0.2s ease;
        }

        .sw-nav-item:hover {
            color: #fff;
            background: rgba(255, 255, 255, 0.04);
        }

        .sw-nav-item.active {
            background: linear-gradient(135deg, #5b46f6, #7c3aed);
            color: #fff;
            font-weight: 600;
            box-shadow: 0 4px 18px rgba(99, 102, 241, 0.45);
        }

        .sw-nav-item svg { width: 19px; height: 19px; flex-shrink: 0; }

        .sw-sidebar-bottom {
            padding-top: 14px;
            border-top: 1px solid var(--border-card);
        }

        .sw-nav-item.logout:hover {
            color: #f87171;
            background: rgba(239, 68, 68, 0.1);
        }

        /* ===== MAIN VIEW ===== */
        .sw-main {
            flex: 1;
            display: flex;
            flex-direction: column;
            min-width: 0;
            background: #060814;
        }

        /* TOPBAR */
        .sw-topbar {
            height: 70px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 32px;
            border-bottom: 1px solid var(--border-card);
            background: #060814;
            position: sticky;
            top: 0;
            z-index: 30;
        }

        .sw-search-box {
            position: relative;
            width: 440px;
            max-width: 100%;
        }

        .sw-search-box svg {
            position: absolute;
            left: 16px;
            top: 50%;
            transform: translateY(-50%);
            color: #64748b;
            pointer-events: none;
        }

        .sw-search-input {
            width: 100%;
            height: 42px;
            background: #0b1124;
            border: 1px solid var(--border-card);
            border-radius: 22px;
            padding: 0 16px 0 44px;
            color: #fff;
            font-size: 0.88rem;
            outline: none;
            transition: all 0.25s ease;
        }

        .sw-search-input:focus {
            border-color: #6366f1;
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.2);
        }

        .sw-search-input::placeholder { color: #475569; }

        .sw-user-area {
            display: flex;
            align-items: center;
            gap: 18px;
        }

        .sw-bell-btn {
            position: relative;
            width: 38px;
            height: 38px;
            border-radius: 50%;
            background: #0b1124;
            border: 1px solid var(--border-card);
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--text-muted);
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .sw-bell-btn:hover {
            color: #fff;
            background: rgba(255, 255, 255, 0.08);
        }

        .sw-bell-dot {
            position: absolute;
            top: 7px;
            right: 7px;
            width: 7px;
            height: 7px;
            background: #ef4444;
            border-radius: 50%;
            border: 1px solid #060814;
        }

        .sw-profile-pill {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 4px 12px 4px 4px;
            border-radius: 26px;
            background: #0b1124;
            border: 1px solid var(--border-card);
            transition: all 0.2s ease;
        }

        .sw-profile-pill:hover {
            background: rgba(255, 255, 255, 0.06);
            border-color: rgba(255, 255, 255, 0.15);
        }

        .sw-avatar {
            width: 34px;
            height: 34px;
            border-radius: 50%;
            overflow: hidden;
            background: linear-gradient(135deg, #6366f1, #a855f7);
            display: flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            font-size: 0.78rem;
            font-weight: 700;
        }
        .sw-avatar img { width: 100%; height: 100%; object-fit: cover; }

        .sw-profile-info {
            display: flex;
            flex-direction: column;
            line-height: 1.25;
            text-align: left;
        }

        .sw-profile-name { font-size: 0.84rem; font-weight: 600; color: #fff; }
        .sw-profile-role { font-size: 0.72rem; color: var(--text-muted); }

        /* ===== CONTENT WRAPPER ===== */
        .sw-content {
            padding: 24px 32px 48px;
            display: flex;
            flex-direction: column;
            gap: 20px;
            max-width: 100%;
        }

        /* ===== HEADER BANNER ===== */
        .dr-banner {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 20px;
        }

        .dr-banner-left h1 {
            font-size: 2.15rem;
            font-weight: 800;
            letter-spacing: -0.025em;
            color: #ffffff;
        }

        .dr-banner-left h1 span {
            color: #7952f5;
        }

        .dr-banner-left p {
            font-size: 0.9rem;
            color: #8492a6;
            margin-top: 4px;
        }

        .dr-banner-right {
            display: flex;
            align-items: center;
            gap: 24px;
        }

        /* 3D Stylized Equalizer Bar Graphic */
        .dr-radar-wave {
            display: flex;
            align-items: flex-end;
            gap: 7px;
            height: 52px;
            padding-right: 8px;
        }

        .dr-wave-bar {
            width: 12px;
            border-radius: 6px;
            background: linear-gradient(180deg, #7c3aed 0%, #4338ca 100%);
            box-shadow: 0 0 14px rgba(124, 58, 237, 0.4);
            transition: height 0.4s ease;
        }

        .dr-timeframe-dropdown {
            background: #0d142c;
            border: 1px solid var(--border-card);
            border-radius: 10px;
            padding: 8px 16px;
            color: #cbd5e1;
            font-size: 0.86rem;
            font-weight: 600;
            outline: none;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        .dr-timeframe-dropdown:focus { border-color: #6366f1; }

        /* ===== CATEGORY FILTER TABS ===== */
        .dr-tabs-row {
            display: flex;
            gap: 10px;
            overflow-x: auto;
            padding-bottom: 2px;
        }
        .dr-tabs-row::-webkit-scrollbar { display: none; }

        .dr-tab-btn {
            background: #0e152e;
            border: 1px solid var(--border-card);
            border-radius: 10px;
            padding: 8px 18px;
            color: #94a3b8;
            font-size: 0.84rem;
            font-weight: 600;
            cursor: pointer;
            white-space: nowrap;
            transition: all 0.2s ease;
        }

        .dr-tab-btn:hover {
            color: #fff;
            background: rgba(255, 255, 255, 0.06);
        }

        .dr-tab-btn.active {
            background: #5b46f6;
            border-color: #5b46f6;
            color: #ffffff;
            box-shadow: 0 4px 14px rgba(91, 70, 246, 0.45);
        }

        /* ===== TOP 4 KPI CARDS ===== */
        .dr-kpi-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 18px;
        }

        @media (max-width: 1000px) {
            .dr-kpi-grid { grid-template-columns: repeat(2, 1fr); }
        }

        .dr-kpi-card {
            background: #090e22;
            border: 1px solid var(--border-card);
            border-radius: 14px;
            padding: 16px 18px;
            display: flex;
            align-items: center;
            gap: 16px;
            transition: transform 0.2s ease, border-color 0.2s ease;
        }

        .dr-kpi-card:hover {
            transform: translateY(-2px);
            border-color: rgba(255, 255, 255, 0.12);
        }

        .dr-kpi-icon-box {
            width: 44px;
            height: 44px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        .dr-kpi-info {
            display: flex;
            flex-direction: column;
        }

        .dr-kpi-number {
            font-size: 1.45rem;
            font-weight: 800;
            color: #ffffff;
            line-height: 1.1;
        }

        .dr-kpi-label {
            font-size: 0.78rem;
            color: #8492a6;
            font-weight: 500;
            margin-top: 2px;
        }

        /* ===== MAIN TWO-COLUMN SECTION ===== */
        .dr-main-grid {
            display: grid;
            grid-template-columns: 1.8fr 1fr;
            gap: 20px;
            align-items: stretch;
        }

        @media (max-width: 1200px) {
            .dr-main-grid { grid-template-columns: 1fr; }
        }

        /* CARD GENERAL */
        .dr-card {
            background: #090e22;
            border: 1px solid var(--border-card);
            border-radius: 16px;
            padding: 20px 22px;
            display: flex;
            flex-direction: column;
        }

        .dr-card-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 16px;
        }

        .dr-card-title {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 1rem;
            font-weight: 700;
            color: #ffffff;
        }

        .dr-card-title-icon {
            width: 28px;
            height: 28px;
            border-radius: 8px;
            background: rgba(99, 102, 241, 0.15);
            display: flex;
            align-items: center;
            justify-content: center;
            color: #818cf8;
        }

        .dr-header-actions {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .dr-select-sm {
            background: #0e152e;
            border: 1px solid var(--border-card);
            border-radius: 8px;
            padding: 5px 12px;
            color: #cbd5e1;
            font-size: 0.78rem;
            font-weight: 600;
            outline: none;
            cursor: pointer;
        }

        .dr-btn-icon {
            width: 32px;
            height: 32px;
            background: #0e152e;
            border: 1px solid var(--border-card);
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #94a3b8;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        .dr-btn-icon:hover { color: #fff; background: rgba(255,255,255,0.06); }

        .dr-view-all-link {
            font-size: 0.78rem;
            font-weight: 600;
            color: #818cf8;
            display: flex;
            align-items: center;
            gap: 4px;
            transition: color 0.2s ease;
        }
        .dr-view-all-link:hover { color: #a78bfa; }

        /* ===== UPCOMING DEADLINES TABLE ===== */
        .dr-table-wrapper {
            width: 100%;
            overflow-x: auto;
        }

        .dr-table {
            width: 100%;
            border-collapse: collapse;
            text-align: left;
        }

        .dr-table th {
            padding: 8px 12px 14px;
            font-size: 0.72rem;
            font-weight: 600;
            color: #64748b;
            border-bottom: 1px solid var(--border-card);
            letter-spacing: 0.02em;
        }

        .dr-table td {
            padding: 12px 12px;
            font-size: 0.84rem;
            border-bottom: 1px solid rgba(255, 255, 255, 0.03);
            vertical-align: middle;
        }

        .dr-table tr:hover td {
            background: rgba(255, 255, 255, 0.015);
        }

        .dr-table-title-cell {
            display: flex;
            align-items: center;
            gap: 12px;
            position: relative;
        }

        .dr-table-accent {
            width: 3px;
            height: 28px;
            border-radius: 2px;
            flex-shrink: 0;
        }

        .dr-table-icon-box {
            width: 30px;
            height: 30px;
            border-radius: 7px;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
            color: #fff;
        }

        .dr-table-title-text {
            font-weight: 600;
            color: #f1f5f9;
            white-space: nowrap;
        }

        /* BADGES */
        .dr-pill {
            display: inline-flex;
            align-items: center;
            padding: 3px 10px;
            border-radius: 12px;
            font-size: 0.72rem;
            font-weight: 600;
            white-space: nowrap;
        }

        .dr-pill-assignment { background: #172554; color: #60a5fa; }
        .dr-pill-lab { background: #4c0519; color: #f472b6; }
        .dr-pill-project { background: #1e1b4b; color: #818cf8; }
        .dr-pill-exam { background: #064e3b; color: #34d399; }
        .dr-pill-clubevent { background: #450a0a; color: #fb923c; }
        .dr-pill-personal { background: #451a03; color: #fbbf24; }

        /* STATUS BADGES */
        .dr-status-overdue { background: #3c1518; color: #f87171; border: 1px solid rgba(239,68,68,0.25); }
        .dr-status-duesoon { background: #3d2311; color: #fb923c; border: 1px solid rgba(251,146,60,0.25); }
        .dr-status-upcoming { background: #0c2d48; color: #38bdf8; border: 1px solid rgba(56,189,248,0.25); }
        .dr-status-completed { background: #064e3b; color: #34d399; border: 1px solid rgba(16,185,129,0.25); }

        /* SUBJECT CELL */
        .dr-subject-cell {
            display: inline-flex;
            align-items: center;
            gap: 7px;
            color: #cbd5e1;
            font-size: 0.82rem;
            font-weight: 500;
            white-space: nowrap;
        }

        .dr-subject-dot {
            width: 7px;
            height: 7px;
            border-radius: 50%;
            flex-shrink: 0;
        }

        /* ACTIONS */
        .dr-actions-cell {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .dr-action-btn {
            background: transparent;
            border: none;
            color: #64748b;
            cursor: pointer;
            padding: 4px;
            border-radius: 6px;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.2s ease;
        }

        .dr-action-btn:hover { color: #f1f5f9; background: rgba(255,255,255,0.06); }
        .dr-action-btn.delete:hover { color: #ef4444; background: rgba(239,68,68,0.1); }

        /* ===== RIGHT COLUMN: OVERVIEW & NEXT 7 DAYS ===== */
        .dr-right-col {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        /* DONUT CHART OVERVIEW */
        .dr-donut-container {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            padding: 6px 0;
        }

        .dr-donut-visual {
            position: relative;
            width: 120px;
            height: 120px;
            flex-shrink: 0;
        }

        .dr-donut-center {
            position: absolute;
            inset: 0;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            text-align: center;
            pointer-events: none;
        }

        .dr-donut-center-num {
            font-size: 1.35rem;
            font-weight: 800;
            color: #ffffff;
            line-height: 1;
        }

        .dr-donut-center-lbl {
            font-size: 0.68rem;
            color: #8492a6;
            margin-top: 2px;
        }

        .dr-donut-legend {
            display: flex;
            flex-direction: column;
            gap: 8px;
            flex: 1;
        }

        .dr-legend-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            font-size: 0.8rem;
        }

        .dr-legend-left {
            display: flex;
            align-items: center;
            gap: 8px;
            color: #cbd5e1;
        }

        .dr-legend-dot {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            flex-shrink: 0;
        }

        .dr-legend-val {
            font-weight: 600;
            color: #94a3b8;
            font-size: 0.78rem;
        }

        /* NEXT 7 DAYS LIST */
        .dr-mini-list {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .dr-mini-row {
            display: flex;
            align-items: center;
            gap: 12px;
            background: #0d142c;
            border-radius: 10px;
            padding: 9px 12px;
            border: 1px solid var(--border-card);
            position: relative;
            overflow: hidden;
            transition: all 0.2s ease;
        }

        .dr-mini-row:hover {
            background: #111a38;
            border-color: rgba(255, 255, 255, 0.1);
        }

        .dr-mini-accent {
            position: absolute;
            left: 0;
            top: 0;
            bottom: 0;
            width: 3px;
        }

        .dr-mini-info {
            flex: 1;
            min-width: 0;
        }

        .dr-mini-title {
            font-size: 0.82rem;
            font-weight: 600;
            color: #ffffff;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .dr-mini-sub {
            font-size: 0.72rem;
            color: #8492a6;
            margin-top: 1px;
        }

        .dr-mini-tag {
            padding: 3px 8px;
            border-radius: 10px;
            font-size: 0.7rem;
            font-weight: 600;
            white-space: nowrap;
        }

        /* ===== BOTTOM ROW: 3 CARDS ===== */
        .dr-bottom-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
        }

        @media (max-width: 1050px) {
            .dr-bottom-grid { grid-template-columns: 1fr; }
        }

        /* SUBJECT BARS */
        .dr-subject-bars {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        .dr-subj-item {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .dr-subj-name {
            width: 90px;
            font-size: 0.8rem;
            color: #cbd5e1;
            font-weight: 500;
            white-space: nowrap;
        }

        .dr-subj-track {
            flex: 1;
            height: 8px;
            background: #0e152e;
            border-radius: 4px;
            overflow: hidden;
        }

        .dr-subj-fill {
            height: 100%;
            border-radius: 4px;
            transition: width 0.6s ease;
        }

        .dr-subj-count {
            width: 18px;
            text-align: right;
            font-size: 0.78rem;
            color: #94a3b8;
            font-weight: 600;
        }

        /* PRIORITY ROWS */
        .dr-prio-list {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .dr-prio-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 10px 14px;
            border-radius: 10px;
            background: #0d142c;
            border: 1px solid var(--border-card);
        }

        .dr-prio-left {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 0.82rem;
            font-weight: 600;
            color: #ffffff;
        }

        .dr-prio-icon {
            width: 24px;
            height: 24px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.75rem;
            font-weight: 800;
        }

        .dr-prio-val {
            font-size: 0.84rem;
            font-weight: 700;
            color: #cbd5e1;
        }

        /* MODAL */
        .dr-modal-overlay {
            position: fixed;
            inset: 0;
            background: rgba(0, 0, 0, 0.75);
            backdrop-filter: blur(6px);
            z-index: 100;
            display: none;
            align-items: center;
            justify-content: center;
        }

        .dr-modal-overlay.open { display: flex; }

        .dr-modal {
            background: #0b1124;
            border: 1px solid rgba(255, 255, 255, 0.12);
            border-radius: 16px;
            width: 440px;
            max-width: 90vw;
            padding: 24px;
            display: flex;
            flex-direction: column;
            gap: 16px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.8), 0 0 30px rgba(99, 102, 241, 0.25);
        }

        .dr-modal-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .dr-modal-header h3 { font-size: 1.1rem; color: #fff; }

        .dr-modal-close {
            background: none;
            border: none;
            color: #64748b;
            font-size: 1.4rem;
            cursor: pointer;
        }
        .dr-modal-close:hover { color: #fff; }

        .dr-form-group {
            display: flex;
            flex-direction: column;
            gap: 6px;
        }

        .dr-form-group label {
            font-size: 0.78rem;
            color: #94a3b8;
            font-weight: 600;
        }

        .dr-form-control {
            height: 40px;
            background: #0e152e;
            border: 1px solid var(--border-card);
            border-radius: 8px;
            padding: 0 12px;
            color: #fff;
            font-size: 0.86rem;
            outline: none;
        }
        .dr-form-control:focus { border-color: #6366f1; }

        .dr-modal-btn {
            height: 42px;
            background: linear-gradient(135deg, #5b46f6, #7c3aed);
            border: none;
            border-radius: 10px;
            color: #fff;
            font-weight: 700;
            font-size: 0.9rem;
            cursor: pointer;
            margin-top: 8px;
            transition: all 0.2s ease;
        }
        .dr-modal-btn:hover { opacity: 0.95; box-shadow: 0 4px 16px rgba(99, 102, 241, 0.5); }

        /* TOAST */
        .dr-toast {
            position: fixed;
            bottom: 28px;
            right: 32px;
            background: #0f172a;
            border: 1px solid #6366f1;
            padding: 12px 20px;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.6), 0 0 20px rgba(99,102,241,0.3);
            display: flex;
            align-items: center;
            gap: 10px;
            color: #fff;
            font-size: 0.88rem;
            font-weight: 500;
            z-index: 200;
            opacity: 0;
            transform: translateY(20px);
            pointer-events: none;
            transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
        }

        .dr-toast.show {
            opacity: 1;
            transform: translateY(0);
            pointer-events: auto;
        }
    </style>
</head>
<body>

<div class="sw-layout">

    <!-- ===== LEFT SIDEBAR ===== -->
    <aside class="sw-sidebar">
        <div>
            <a href="${pageContext.request.contextPath}/dashboard" class="sw-logo">
                <div class="sw-logo-icon">
                    <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M22 10v6M2 10l10-5 10 5-10 5z"></path>
                        <path d="M6 12v5c3 3 9 3 12 0v-5"></path>
                    </svg>
                </div>
                <div class="sw-logo-text">Slot<span>Wise</span></div>
            </a>

            <nav class="sw-nav">
                <!-- Dashboard -->
                <a href="${pageContext.request.contextPath}/dashboard" class="sw-nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path>
                        <polyline points="9 22 9 12 15 12 15 22"></polyline>
                    </svg>
                    <span>Dashboard</span>
                </a>

                <!-- Timetable -->
                <a href="${pageContext.request.contextPath}/timetable" class="sw-nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                        <line x1="16" y1="2" x2="16" y2="6"></line>
                        <line x1="8" y1="2" x2="8" y2="6"></line>
                        <line x1="3" y1="10" x2="21" y2="10"></line>
                    </svg>
                    <span>Timetable</span>
                </a>

                <!-- My Tasks -->
                <a href="${pageContext.request.contextPath}/tasks" class="sw-nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M9 11l3 3L22 4"></path>
                        <path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"></path>
                    </svg>
                    <span>My Tasks</span>
                </a>

                <!-- Study Planner -->
                <a href="${pageContext.request.contextPath}/study-planner" class="sw-nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="12" cy="12" r="10"></circle>
                        <line x1="12" y1="2" x2="12" y2="22"></line>
                        <path d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z"></path>
                        <path d="M2 12h20"></path>
                    </svg>
                    <span>Study Planner</span>
                </a>

                <!-- Progress -->
                <a href="${pageContext.request.contextPath}/progress" class="sw-nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <line x1="18" y1="20" x2="18" y2="10"></line>
                        <line x1="12" y1="20" x2="12" y2="4"></line>
                        <line x1="6" y1="20" x2="6" y2="14"></line>
                    </svg>
                    <span>Progress</span>
                </a>

                <!-- Materials -->
                <a href="${pageContext.request.contextPath}/materials" class="sw-nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path>
                        <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path>
                    </svg>
                    <span>Materials</span>
                </a>

                <!-- Study Groups -->
                <a href="javascript:void(0)" onclick="showToast('Study Groups: 3 active rooms available')" class="sw-nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                        <circle cx="9" cy="7" r="4"></circle>
                        <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                        <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                    </svg>
                    <span>Study Groups</span>
                </a>

                <!-- Smart Rescheduler -->
                <a href="${pageContext.request.contextPath}/rescheduler" class="sw-nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                        <polyline points="23 4 23 10 17 10"></polyline>
                        <polyline points="1 20 1 14 7 14"></polyline>
                        <path d="M3.51 9a9 9 0 0 1 14.85-3.36L23 10M1 14l4.64 4.36A9 9 0 0 0 20.49 15"></path>
                    </svg>
                    <span>Smart Rescheduler</span>
                </a>

                <!-- Deadline Radar (Active) -->
                <a href="${pageContext.request.contextPath}/deadlines" class="sw-nav-item active">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="12" cy="12" r="2"></circle>
                        <path d="M16.24 7.76a6 6 0 0 1 0 8.49m-8.48-.01a6 6 0 0 1 0-8.49m11.31-2.82a10 10 0 0 1 0 14.14m-14.14 0a10 10 0 0 1 0-14.14"></path>
                    </svg>
                    <span>Deadline Radar</span>
                </a>

                <!-- Goals -->
                <a href="${pageContext.request.contextPath}/progress" class="sw-nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
                    </svg>
                    <span>Goals</span>
                </a>

                <!-- Settings -->
                <a href="${pageContext.request.contextPath}/settings" class="sw-nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="12" cy="12" r="3"></circle>
                        <path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-4 0v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 1 1-2.83-2.83l.06-.06A1.65 1.65 0 0 0 4.6 15a1.65 1.65 0 0 0-1.51-1H3a2 2 0 1 1 0-4h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 1 1 2.83-2.83l.06.06A1.65 1.65 0 0 0 9 4.6a1.65 1.65 0 0 0 1-1.51V3a2 2 0 1 1 4 0v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 1 1 2.83 2.83l-.06.06A1.65 1.65 0 0 0 19.4 9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 1 1 0 4h-.09a1.65 1.65 0 0 0-1.51 1z"></path>
                    </svg>
                    <span>Settings</span>
                </a>
            </nav>
        </div>

        <div class="sw-sidebar-bottom">
            <a href="${pageContext.request.contextPath}/logout" class="sw-nav-item logout">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path>
                    <polyline points="16 17 21 12 16 7"></polyline>
                    <line x1="21" y1="12" x2="9" y2="12"></line>
                </svg>
                <span>Logout</span>
            </a>
        </div>
    </aside>

    <!-- ===== MAIN CONTENT ===== -->
    <main class="sw-main">

        <!-- TOPBAR -->
        <header class="sw-topbar">
            <div class="sw-search-box">
                <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2">
                    <circle cx="11" cy="11" r="8"></circle>
                    <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                </svg>
                <input type="text" class="sw-search-input" id="globalSearchInput" placeholder="Search tasks, subjects, deadlines..." oninput="handleSearch(this.value)">
            </div>

            <div class="sw-user-area">
                <div class="sw-bell-btn" onclick="showToast('Deadline Alert: 5 assignments are overdue!')">
                    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"></path>
                        <path d="M13.73 21a2 2 0 0 1-3.46 0"></path>
                    </svg>
                    <span class="sw-bell-dot"></span>
                </div>

                <a href="${pageContext.request.contextPath}/settings" class="sw-profile-pill">
                    <div class="sw-avatar">
                        <img src="${pageContext.request.contextPath}/images/harish_profile.jpg" alt="Profile" onerror="this.style.display='none'; this.parentNode.innerHTML='HM';">
                    </div>
                    <div class="sw-profile-info">
                        <span class="sw-profile-name"><c:out value="${sessionScope.studentName != null ? sessionScope.studentName : 'Harish M'}"/></span>
                        <span class="sw-profile-role"><c:out value="${sessionScope.yearOfStudy != null ? sessionScope.yearOfStudy : 'CSE - 2nd Year'}"/></span>
                    </div>
                </a>
            </div>
        </header>

        <!-- PAGE CONTENT -->
        <div class="sw-content">

            <!-- BANNER -->
            <div class="dr-banner">
                <div class="dr-banner-left">
                    <h1>Deadline <span>Radar</span></h1>
                    <p>Track all your important deadlines in one place.</p>
                </div>
                <div class="dr-banner-right">
                    <!-- Stylized 3D Wave Bars -->
                    <div class="dr-radar-wave">
                        <div class="dr-wave-bar" style="height: 18px;"></div>
                        <div class="dr-wave-bar" style="height: 34px;"></div>
                        <div class="dr-wave-bar" style="height: 24px;"></div>
                        <div class="dr-wave-bar" style="height: 52px;"></div>
                        <div class="dr-wave-bar" style="height: 38px;"></div>
                        <div class="dr-wave-bar" style="height: 46px;"></div>
                        <div class="dr-wave-bar" style="height: 22px;"></div>
                    </div>

                    <!-- Timeframe Dropdown -->
                    <select class="dr-timeframe-dropdown" id="timeframeSelect" onchange="handleTimeframeChange(this.value)">
                        <option value="This Month" selected>This Month &nbsp;&#9662;</option>
                        <option value="This Week">This Week</option>
                        <option value="Next 30 Days">Next 30 Days</option>
                        <option value="All Time">All Time</option>
                    </select>
                </div>
            </div>

            <!-- CATEGORY FILTER TABS -->
            <div class="dr-tabs-row" id="categoryTabs">
                <button type="button" class="dr-tab-btn active" onclick="selectCategoryTab(this, 'All Deadlines')">All Deadlines</button>
                <button type="button" class="dr-tab-btn" onclick="selectCategoryTab(this, 'Assignments')">Assignments</button>
                <button type="button" class="dr-tab-btn" onclick="selectCategoryTab(this, 'Exams')">Exams</button>
                <button type="button" class="dr-tab-btn" onclick="selectCategoryTab(this, 'Projects')">Projects</button>
                <button type="button" class="dr-tab-btn" onclick="selectCategoryTab(this, 'Club Events')">Club Events</button>
                <button type="button" class="dr-tab-btn" onclick="selectCategoryTab(this, 'Personal')">Personal</button>
                <button type="button" class="dr-tab-btn" onclick="selectCategoryTab(this, 'Others')">Others</button>
            </div>

            <!-- TOP 4 KPI METRIC CARDS -->
            <div class="dr-kpi-grid">
                <!-- Overdue -->
                <div class="dr-kpi-card">
                    <div class="dr-kpi-icon-box" style="background: rgba(239, 68, 68, 0.2); color: #f87171;">
                        <svg viewBox="0 0 24 24" width="22" height="22" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round">
                            <circle cx="12" cy="12" r="10"></circle>
                            <polyline points="12 6 12 12 16 14"></polyline>
                        </svg>
                    </div>
                    <div class="dr-kpi-info">
                        <span class="dr-kpi-number" id="kpiOverdue">${overdueCount != null ? overdueCount : 5}</span>
                        <span class="dr-kpi-label">Overdue</span>
                    </div>
                </div>

                <!-- Due This Week -->
                <div class="dr-kpi-card">
                    <div class="dr-kpi-icon-box" style="background: rgba(245, 158, 11, 0.2); color: #fbbf24;">
                        <svg viewBox="0 0 24 24" width="22" height="22" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round">
                            <circle cx="12" cy="12" r="10"></circle>
                            <polyline points="12 6 12 12 16 14"></polyline>
                        </svg>
                    </div>
                    <div class="dr-kpi-info">
                        <span class="dr-kpi-number" id="kpiThisWeek">${dueThisWeekCount != null ? dueThisWeekCount : 7}</span>
                        <span class="dr-kpi-label">Due This Week</span>
                    </div>
                </div>

                <!-- Upcoming -->
                <div class="dr-kpi-card">
                    <div class="dr-kpi-icon-box" style="background: rgba(124, 58, 237, 0.2); color: #a78bfa;">
                        <svg viewBox="0 0 24 24" width="22" height="22" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round">
                            <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                            <line x1="16" y1="2" x2="16" y2="6"></line>
                            <line x1="8" y1="2" x2="8" y2="6"></line>
                            <line x1="3" y1="10" x2="21" y2="10"></line>
                        </svg>
                    </div>
                    <div class="dr-kpi-info">
                        <span class="dr-kpi-number" id="kpiUpcoming">${upcomingCount != null ? upcomingCount : 12}</span>
                        <span class="dr-kpi-label">Upcoming</span>
                    </div>
                </div>

                <!-- Completed -->
                <div class="dr-kpi-card">
                    <div class="dr-kpi-icon-box" style="background: rgba(16, 185, 129, 0.2); color: #34d399;">
                        <svg viewBox="0 0 24 24" width="22" height="22" fill="none" stroke="currentColor" stroke-width="2.8" stroke-linecap="round" stroke-linejoin="round">
                            <polyline points="20 6 9 17 4 12"></polyline>
                        </svg>
                    </div>
                    <div class="dr-kpi-info">
                        <span class="dr-kpi-number" id="kpiCompleted">${completedCount != null ? completedCount : 8}</span>
                        <span class="dr-kpi-label">Completed</span>
                    </div>
                </div>
            </div>

            <!-- MAIN TWO-COLUMN SECTION -->
            <div class="dr-main-grid">

                <!-- LEFT: UPCOMING DEADLINES TABLE -->
                <div class="dr-card">
                    <div class="dr-card-header">
                        <div class="dr-card-title">
                            <div class="dr-card-title-icon">
                                <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2">
                                    <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                    <line x1="16" y1="2" x2="16" y2="6"></line>
                                    <line x1="8" y1="2" x2="8" y2="6"></line>
                                    <line x1="3" y1="10" x2="21" y2="10"></line>
                                </svg>
                            </div>
                            <span>Upcoming Deadlines</span>
                        </div>

                        <div class="dr-header-actions">
                            <select class="dr-select-sm" id="sortSelect" onchange="handleSortChange(this.value)">
                                <option value="Due Date" selected>Sort by: Due Date &nbsp;&#9662;</option>
                                <option value="Priority">Sort by: Priority</option>
                                <option value="Subject">Sort by: Subject</option>
                                <option value="Title">Sort by: Title</option>
                            </select>

                            <button type="button" class="dr-btn-icon" title="Add New Deadline" onclick="openAddModal()">
                                <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2.2">
                                    <line x1="12" y1="5" x2="12" y2="19"></line>
                                    <line x1="5" y1="12" x2="19" y2="12"></line>
                                </svg>
                            </button>
                        </div>
                    </div>

                    <div class="dr-table-wrapper">
                        <table class="dr-table">
                            <thead>
                                <tr>
                                    <th>Title</th>
                                    <th>Type</th>
                                    <th>Subject/Category</th>
                                    <th>Due Date</th>
                                    <th>Status</th>
                                    <th style="text-align: right;">Actions</th>
                                </tr>
                            </thead>
                            <tbody id="deadlinesTableBody">
                                <!-- Row 1: DBMS Assignment -->
                                <tr>
                                    <td>
                                        <div class="dr-table-title-cell">
                                            <div class="dr-table-accent" style="background:#ef4444;"></div>
                                            <div class="dr-table-icon-box" style="background:#dc2626;">
                                                <svg viewBox="0 0 24 24" width="15" height="15" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline></svg>
                                            </div>
                                            <span class="dr-table-title-text">DBMS Assignment</span>
                                        </div>
                                    </td>
                                    <td><span class="dr-pill dr-pill-assignment">Assignment</span></td>
                                    <td><span class="dr-subject-cell"><span class="dr-subject-dot" style="background:#a855f7;"></span>DBMS</span></td>
                                    <td style="color:#cbd5e1; font-family:'JetBrains Mono',monospace; font-size:0.8rem;">20 Oct 2026</td>
                                    <td><span class="dr-pill dr-status-overdue">Overdue</span></td>
                                    <td style="text-align: right;">
                                        <div class="dr-actions-cell" style="justify-content: flex-end;">
                                            <button class="dr-action-btn" title="Edit" onclick="editDeadline(1)"><svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 20h9"></path><path d="M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4L16.5 3.5z"></path></svg></button>
                                            <button class="dr-action-btn delete" title="Delete" onclick="deleteDeadline(1)"><svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2"><polyline points="3 6 5 6 21 6"></polyline><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path></svg></button>
                                        </div>
                                    </td>
                                </tr>

                                <!-- Row 2: Java Lab Record -->
                                <tr>
                                    <td>
                                        <div class="dr-table-title-cell">
                                            <div class="dr-table-accent" style="background:#ea580c;"></div>
                                            <div class="dr-table-icon-box" style="background:#ea580c;">
                                                <svg viewBox="0 0 24 24" width="15" height="15" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline></svg>
                                            </div>
                                            <span class="dr-table-title-text">Java Lab Record</span>
                                        </div>
                                    </td>
                                    <td><span class="dr-pill dr-pill-lab">Lab Work</span></td>
                                    <td><span class="dr-subject-cell"><span class="dr-subject-dot" style="background:#ef4444;"></span>Java</span></td>
                                    <td style="color:#cbd5e1; font-family:'JetBrains Mono',monospace; font-size:0.8rem;">22 Oct 2026</td>
                                    <td><span class="dr-pill dr-status-overdue">Overdue</span></td>
                                    <td style="text-align: right;">
                                        <div class="dr-actions-cell" style="justify-content: flex-end;">
                                            <button class="dr-action-btn" title="Edit" onclick="editDeadline(2)"><svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 20h9"></path><path d="M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4L16.5 3.5z"></path></svg></button>
                                            <button class="dr-action-btn delete" title="Delete" onclick="deleteDeadline(2)"><svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2"><polyline points="3 6 5 6 21 6"></polyline><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path></svg></button>
                                        </div>
                                    </td>
                                </tr>

                                <!-- Row 3: Mini Project Report -->
                                <tr>
                                    <td>
                                        <div class="dr-table-title-cell">
                                            <div class="dr-table-accent" style="background:#2563eb;"></div>
                                            <div class="dr-table-icon-box" style="background:#2563eb;">
                                                <svg viewBox="0 0 24 24" width="15" height="15" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 10v6M2 10l10-5 10 5-10 5z"></path><path d="M6 12v5c3 3 9 3 12 0v-5"></path></svg>
                                            </div>
                                            <span class="dr-table-title-text">Mini Project Report</span>
                                        </div>
                                    </td>
                                    <td><span class="dr-pill dr-pill-project">Project</span></td>
                                    <td><span class="dr-subject-cell"><span class="dr-subject-dot" style="background:#3b82f6;"></span>OOPs + DBMS</span></td>
                                    <td style="color:#cbd5e1; font-family:'JetBrains Mono',monospace; font-size:0.8rem;">24 Oct 2026</td>
                                    <td><span class="dr-pill dr-status-duesoon">Due Soon</span></td>
                                    <td style="text-align: right;">
                                        <div class="dr-actions-cell" style="justify-content: flex-end;">
                                            <button class="dr-action-btn" title="Edit" onclick="editDeadline(3)"><svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 20h9"></path><path d="M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4L16.5 3.5z"></path></svg></button>
                                            <button class="dr-action-btn delete" title="Delete" onclick="deleteDeadline(3)"><svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2"><polyline points="3 6 5 6 21 6"></polyline><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path></svg></button>
                                        </div>
                                    </td>
                                </tr>

                                <!-- Row 4: NPTEL Exam -->
                                <tr>
                                    <td>
                                        <div class="dr-table-title-cell">
                                            <div class="dr-table-accent" style="background:#059669;"></div>
                                            <div class="dr-table-icon-box" style="background:#059669;">
                                                <svg viewBox="0 0 24 24" width="15" height="15" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline></svg>
                                            </div>
                                            <span class="dr-table-title-text">NPTEL Exam</span>
                                        </div>
                                    </td>
                                    <td><span class="dr-pill dr-pill-exam">Exam</span></td>
                                    <td><span class="dr-subject-cell"><span class="dr-subject-dot" style="background:#10b981;"></span>IoT</span></td>
                                    <td style="color:#cbd5e1; font-family:'JetBrains Mono',monospace; font-size:0.8rem;">26 Oct 2026</td>
                                    <td><span class="dr-pill dr-status-duesoon">Due Soon</span></td>
                                    <td style="text-align: right;">
                                        <div class="dr-actions-cell" style="justify-content: flex-end;">
                                            <button class="dr-action-btn" title="Edit" onclick="editDeadline(4)"><svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 20h9"></path><path d="M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4L16.5 3.5z"></path></svg></button>
                                            <button class="dr-action-btn delete" title="Delete" onclick="deleteDeadline(4)"><svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2"><polyline points="3 6 5 6 21 6"></polyline><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path></svg></button>
                                        </div>
                                    </td>
                                </tr>

                                <!-- Row 5: CAT 1 Preparation -->
                                <tr>
                                    <td>
                                        <div class="dr-table-title-cell">
                                            <div class="dr-table-accent" style="background:#0284c7;"></div>
                                            <div class="dr-table-icon-box" style="background:#0284c7;">
                                                <svg viewBox="0 0 24 24" width="15" height="15" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline></svg>
                                            </div>
                                            <span class="dr-table-title-text">CAT 1 Preparation</span>
                                        </div>
                                    </td>
                                    <td><span class="dr-pill dr-pill-exam">Exam</span></td>
                                    <td><span class="dr-subject-cell"><span class="dr-subject-dot" style="background:#0284c7;"></span>Data Science</span></td>
                                    <td style="color:#cbd5e1; font-family:'JetBrains Mono',monospace; font-size:0.8rem;">28 Oct 2026</td>
                                    <td><span class="dr-pill dr-status-upcoming">Upcoming</span></td>
                                    <td style="text-align: right;">
                                        <div class="dr-actions-cell" style="justify-content: flex-end;">
                                            <button class="dr-action-btn" title="Edit" onclick="editDeadline(5)"><svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 20h9"></path><path d="M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4L16.5 3.5z"></path></svg></button>
                                            <button class="dr-action-btn delete" title="Delete" onclick="deleteDeadline(5)"><svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2"><polyline points="3 6 5 6 21 6"></polyline><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path></svg></button>
                                        </div>
                                    </td>
                                </tr>

                                <!-- Row 6: Club Event Plan -->
                                <tr>
                                    <td>
                                        <div class="dr-table-title-cell">
                                            <div class="dr-table-accent" style="background:#7c3aed;"></div>
                                            <div class="dr-table-icon-box" style="background:#7c3aed;">
                                                <svg viewBox="0 0 24 24" width="15" height="15" fill="none" stroke="currentColor" stroke-width="2"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg>
                                            </div>
                                            <span class="dr-table-title-text">Club Event Plan</span>
                                        </div>
                                    </td>
                                    <td><span class="dr-pill dr-pill-clubevent">Club Event</span></td>
                                    <td><span class="dr-subject-cell"><span class="dr-subject-dot" style="background:#f97316;"></span>Leo Club</span></td>
                                    <td style="color:#cbd5e1; font-family:'JetBrains Mono',monospace; font-size:0.8rem;">30 Oct 2026</td>
                                    <td><span class="dr-pill dr-status-upcoming">Upcoming</span></td>
                                    <td style="text-align: right;">
                                        <div class="dr-actions-cell" style="justify-content: flex-end;">
                                            <button class="dr-action-btn" title="Edit" onclick="editDeadline(6)"><svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 20h9"></path><path d="M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4L16.5 3.5z"></path></svg></button>
                                            <button class="dr-action-btn delete" title="Delete" onclick="deleteDeadline(6)"><svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2"><polyline points="3 6 5 6 21 6"></polyline><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path></svg></button>
                                        </div>
                                    </td>
                                </tr>

                                <!-- Row 7: Java Important Questions -->
                                <tr>
                                    <td>
                                        <div class="dr-table-title-cell">
                                            <div class="dr-table-accent" style="background:#db2777;"></div>
                                            <div class="dr-table-icon-box" style="background:#db2777;">
                                                <svg viewBox="0 0 24 24" width="15" height="15" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path><path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path></svg>
                                            </div>
                                            <span class="dr-table-title-text">Java Important Questions</span>
                                        </div>
                                    </td>
                                    <td><span class="dr-pill dr-pill-personal">Personal</span></td>
                                    <td><span class="dr-subject-cell"><span class="dr-subject-dot" style="background:#ef4444;"></span>Java</span></td>
                                    <td style="color:#cbd5e1; font-family:'JetBrains Mono',monospace; font-size:0.8rem;">02 Nov 2026</td>
                                    <td><span class="dr-pill dr-status-upcoming">Upcoming</span></td>
                                    <td style="text-align: right;">
                                        <div class="dr-actions-cell" style="justify-content: flex-end;">
                                            <button class="dr-action-btn" title="Edit" onclick="editDeadline(7)"><svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 20h9"></path><path d="M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4L16.5 3.5z"></path></svg></button>
                                            <button class="dr-action-btn delete" title="Delete" onclick="deleteDeadline(7)"><svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2"><polyline points="3 6 5 6 21 6"></polyline><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path></svg></button>
                                        </div>
                                    </td>
                                </tr>

                                <!-- Row 8: Semester Project Title -->
                                <tr>
                                    <td>
                                        <div class="dr-table-title-cell">
                                            <div class="dr-table-accent" style="background:#6366f1;"></div>
                                            <div class="dr-table-icon-box" style="background:#6366f1;">
                                                <svg viewBox="0 0 24 24" width="15" height="15" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline></svg>
                                            </div>
                                            <span class="dr-table-title-text">Semester Project Title</span>
                                        </div>
                                    </td>
                                    <td><span class="dr-pill dr-pill-project">Project</span></td>
                                    <td><span class="dr-subject-cell"><span class="dr-subject-dot" style="background:#8b5cf6;"></span>College Project</span></td>
                                    <td style="color:#cbd5e1; font-family:'JetBrains Mono',monospace; font-size:0.8rem;">05 Nov 2026</td>
                                    <td><span class="dr-pill dr-status-upcoming">Upcoming</span></td>
                                    <td style="text-align: right;">
                                        <div class="dr-actions-cell" style="justify-content: flex-end;">
                                            <button class="dr-action-btn" title="Edit" onclick="editDeadline(8)"><svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 20h9"></path><path d="M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4L16.5 3.5z"></path></svg></button>
                                            <button class="dr-action-btn delete" title="Delete" onclick="deleteDeadline(8)"><svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2"><polyline points="3 6 5 6 21 6"></polyline><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path></svg></button>
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- RIGHT COLUMN: OVERVIEW & NEXT 7 DAYS -->
                <div class="dr-right-col">

                    <!-- DEADLINE OVERVIEW (DONUT CHART) -->
                    <div class="dr-card">
                        <div class="dr-card-header">
                            <div class="dr-card-title">
                                <div class="dr-card-title-icon">
                                    <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2"><path d="M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2"></path><rect x="8" y="2" width="8" height="4" rx="1" ry="1"></rect></svg>
                                </div>
                                <span>Deadline Overview</span>
                            </div>
                        </div>

                        <div class="dr-donut-container">
                            <div class="dr-donut-visual">
                                <svg width="120" height="120" viewBox="0 0 42 42">
                                    <circle cx="21" cy="21" r="15.91549430918954" fill="transparent" stroke="#0e152e" stroke-width="4.5"></circle>
                                    <!-- Overdue: 16% (red) -->
                                    <circle cx="21" cy="21" r="15.91549430918954" fill="transparent" stroke="#ef4444" stroke-width="4.8" stroke-dasharray="16 84" stroke-dashoffset="25"></circle>
                                    <!-- This Week: 22% (amber) -->
                                    <circle cx="21" cy="21" r="15.91549430918954" fill="transparent" stroke="#f59e0b" stroke-width="4.8" stroke-dasharray="22 78" stroke-dashoffset="9"></circle>
                                    <!-- Upcoming: 37% (cyan) -->
                                    <circle cx="21" cy="21" r="15.91549430918954" fill="transparent" stroke="#0284c7" stroke-width="4.8" stroke-dasharray="37 63" stroke-dashoffset="87"></circle>
                                    <!-- Completed: 25% (emerald) -->
                                    <circle cx="21" cy="21" r="15.91549430918954" fill="transparent" stroke="#10b981" stroke-width="4.8" stroke-dasharray="25 75" stroke-dashoffset="50"></circle>
                                </svg>
                                <div class="dr-donut-center">
                                    <span class="dr-donut-center-num" id="overviewTotalNum">32</span>
                                    <span class="dr-donut-center-lbl">Total</span>
                                </div>
                            </div>

                            <div class="dr-donut-legend">
                                <div class="dr-legend-item">
                                    <div class="dr-legend-left">
                                        <div class="dr-legend-dot" style="background:#ef4444;"></div>
                                        <span>Overdue</span>
                                    </div>
                                    <span class="dr-legend-val" id="legOverdue">5 (16%)</span>
                                </div>
                                <div class="dr-legend-item">
                                    <div class="dr-legend-left">
                                        <div class="dr-legend-dot" style="background:#f59e0b;"></div>
                                        <span>This Week</span>
                                    </div>
                                    <span class="dr-legend-val" id="legThisWeek">7 (22%)</span>
                                </div>
                                <div class="dr-legend-item">
                                    <div class="dr-legend-left">
                                        <div class="dr-legend-dot" style="background:#0284c7;"></div>
                                        <span>Upcoming</span>
                                    </div>
                                    <span class="dr-legend-val" id="legUpcoming">12 (37%)</span>
                                </div>
                                <div class="dr-legend-item">
                                    <div class="dr-legend-left">
                                        <div class="dr-legend-dot" style="background:#10b981;"></div>
                                        <span>Completed</span>
                                    </div>
                                    <span class="dr-legend-val" id="legCompleted">8 (25%)</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- NEXT 7 DAYS -->
                    <div class="dr-card">
                        <div class="dr-card-header">
                            <div class="dr-card-title">
                                <div class="dr-card-title-icon">
                                    <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                                </div>
                                <span>Next 7 Days</span>
                            </div>
                            <a href="javascript:void(0)" class="dr-view-all-link" onclick="filterNext7Days()">View All &rarr;</a>
                        </div>

                        <div class="dr-mini-list">
                            <!-- 1. Java Lab Record -->
                            <div class="dr-mini-row">
                                <div class="dr-mini-accent" style="background:#ef4444;"></div>
                                <div class="dr-table-icon-box" style="background:#dc2626; width:28px; height:28px;">
                                    <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path></svg>
                                </div>
                                <div class="dr-mini-info">
                                    <div class="dr-mini-title">Java Lab Record</div>
                                    <div class="dr-mini-sub">22 Oct 2026</div>
                                </div>
                                <span class="dr-mini-tag dr-status-overdue">Overdue</span>
                            </div>

                            <!-- 2. Mini Project Report -->
                            <div class="dr-mini-row">
                                <div class="dr-mini-accent" style="background:#ea580c;"></div>
                                <div class="dr-table-icon-box" style="background:#ea580c; width:28px; height:28px;">
                                    <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 10v6M2 10l10-5 10 5-10 5z"></path></svg>
                                </div>
                                <div class="dr-mini-info">
                                    <div class="dr-mini-title">Mini Project Report</div>
                                    <div class="dr-mini-sub">24 Oct 2026</div>
                                </div>
                                <span class="dr-mini-tag dr-status-duesoon">2 days</span>
                            </div>

                            <!-- 3. NPTEL Exam -->
                            <div class="dr-mini-row">
                                <div class="dr-mini-accent" style="background:#10b981;"></div>
                                <div class="dr-table-icon-box" style="background:#059669; width:28px; height:28px;">
                                    <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path></svg>
                                </div>
                                <div class="dr-mini-info">
                                    <div class="dr-mini-title">NPTEL Exam</div>
                                    <div class="dr-mini-sub">26 Oct 2026</div>
                                </div>
                                <span class="dr-mini-tag dr-status-duesoon">4 days</span>
                            </div>

                            <!-- 4. CAT 1 Preparation -->
                            <div class="dr-mini-row">
                                <div class="dr-mini-accent" style="background:#0284c7;"></div>
                                <div class="dr-table-icon-box" style="background:#0284c7; width:28px; height:28px;">
                                    <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path></svg>
                                </div>
                                <div class="dr-mini-info">
                                    <div class="dr-mini-title">CAT 1 Preparation</div>
                                    <div class="dr-mini-sub">28 Oct 2026</div>
                                </div>
                                <span class="dr-mini-tag dr-status-upcoming">6 days</span>
                            </div>

                            <!-- 5. Club Event Plan -->
                            <div class="dr-mini-row">
                                <div class="dr-mini-accent" style="background:#8b5cf6;"></div>
                                <div class="dr-table-icon-box" style="background:#7c3aed; width:28px; height:28px;">
                                    <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path></svg>
                                </div>
                                <div class="dr-mini-info">
                                    <div class="dr-mini-title">Club Event Plan</div>
                                    <div class="dr-mini-sub">30 Oct 2026</div>
                                </div>
                                <span class="dr-mini-tag dr-status-upcoming">8 days</span>
                            </div>
                        </div>
                    </div>

                </div>

            </div>

            <!-- BOTTOM ROW: 3 CARDS -->
            <div class="dr-bottom-grid">

                <!-- 1. SUBJECT-WISE DEADLINES -->
                <div class="dr-card">
                    <div class="dr-card-header">
                        <div class="dr-card-title">
                            <div class="dr-card-title-icon">
                                <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline></svg>
                            </div>
                            <span>Subject-wise Deadlines</span>
                        </div>
                    </div>

                    <div class="dr-subject-bars">
                        <!-- DBMS -->
                        <div class="dr-subj-item">
                            <span class="dr-subj-name">DBMS</span>
                            <div class="dr-subj-track">
                                <div class="dr-subj-fill" style="width: 85%; background: #8b5cf6;"></div>
                            </div>
                            <span class="dr-subj-count">6</span>
                        </div>
                        <!-- Java -->
                        <div class="dr-subj-item">
                            <span class="dr-subj-name">Java</span>
                            <div class="dr-subj-track">
                                <div class="dr-subj-fill" style="width: 72%; background: #f43f5e;"></div>
                            </div>
                            <span class="dr-subj-count">5</span>
                        </div>
                        <!-- OOPs + DBMS -->
                        <div class="dr-subj-item">
                            <span class="dr-subj-name">OOPs + DBMS</span>
                            <div class="dr-subj-track">
                                <div class="dr-subj-fill" style="width: 60%; background: #3b82f6;"></div>
                            </div>
                            <span class="dr-subj-count">4</span>
                        </div>
                        <!-- Data Science -->
                        <div class="dr-subj-item">
                            <span class="dr-subj-name">Data Science</span>
                            <div class="dr-subj-track">
                                <div class="dr-subj-fill" style="width: 60%; background: #06b6d4;"></div>
                            </div>
                            <span class="dr-subj-count">4</span>
                        </div>
                        <!-- Others -->
                        <div class="dr-subj-item">
                            <span class="dr-subj-name">Others</span>
                            <div class="dr-subj-track">
                                <div class="dr-subj-fill" style="width: 72%; background: #64748b;"></div>
                            </div>
                            <span class="dr-subj-count">5</span>
                        </div>
                    </div>
                </div>

                <!-- 2. PRIORITY BREAKDOWN -->
                <div class="dr-card">
                    <div class="dr-card-header">
                        <div class="dr-card-title">
                            <div class="dr-card-title-icon" style="color:#f59e0b;">
                                <svg viewBox="0 0 24 24" width="16" height="16" fill="currentColor"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg>
                            </div>
                            <span>Priority Breakdown</span>
                        </div>
                    </div>

                    <div class="dr-prio-list">
                        <!-- High Priority -->
                        <div class="dr-prio-row">
                            <div class="dr-prio-left">
                                <div class="dr-prio-icon" style="background:#3c1518; color:#f87171;">!</div>
                                <span>High Priority</span>
                            </div>
                            <span class="dr-prio-val">10</span>
                        </div>

                        <!-- Medium Priority -->
                        <div class="dr-prio-row">
                            <div class="dr-prio-left">
                                <div class="dr-prio-icon" style="background:#3d2311; color:#fb923c;">&minus;</div>
                                <span>Medium Priority</span>
                            </div>
                            <span class="dr-prio-val">12</span>
                        </div>

                        <!-- Low Priority -->
                        <div class="dr-prio-row">
                            <div class="dr-prio-left">
                                <div class="dr-prio-icon" style="background:#0c2d48; color:#38bdf8;">&darr;</div>
                                <span>Low Priority</span>
                            </div>
                            <span class="dr-prio-val">6</span>
                        </div>
                    </div>
                </div>

                <!-- 3. UPCOMING EXAMS & MAJOR DEADLINES -->
                <div class="dr-card">
                    <div class="dr-card-header">
                        <div class="dr-card-title">
                            <div class="dr-card-title-icon" style="color:#a78bfa;">
                                <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line></svg>
                            </div>
                            <span>Upcoming Exams &amp; Major Deadlines</span>
                        </div>
                        <a href="javascript:void(0)" class="dr-view-all-link" onclick="selectCategoryTab(null, 'Exams')">View All &rarr;</a>
                    </div>

                    <div class="dr-mini-list">
                        <!-- NPTEL Exam -->
                        <div class="dr-mini-row">
                            <div class="dr-mini-accent" style="background:#10b981;"></div>
                            <div class="dr-table-icon-box" style="background:#064e3b; width:28px; height:28px; color:#34d399;">
                                <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path></svg>
                            </div>
                            <div class="dr-mini-info">
                                <div class="dr-mini-title">NPTEL Exam (IoT)</div>
                                <div class="dr-mini-sub">26 Oct 2026</div>
                            </div>
                            <span class="dr-mini-tag" style="background:#064e3b; color:#34d399;">4 days</span>
                        </div>

                        <!-- CAT 1 Exam -->
                        <div class="dr-mini-row">
                            <div class="dr-mini-accent" style="background:#0284c7;"></div>
                            <div class="dr-table-icon-box" style="background:#0c2d48; width:28px; height:28px; color:#38bdf8;">
                                <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line></svg>
                            </div>
                            <div class="dr-mini-info">
                                <div class="dr-mini-title">CAT 1 Exam</div>
                                <div class="dr-mini-sub">28 Oct 2026</div>
                            </div>
                            <span class="dr-mini-tag" style="background:#0c2d48; color:#38bdf8;">6 days</span>
                        </div>

                        <!-- Project Title Submission -->
                        <div class="dr-mini-row">
                            <div class="dr-mini-accent" style="background:#e11d48;"></div>
                            <div class="dr-table-icon-box" style="background:#4c0519; width:28px; height:28px; color:#fb7185;">
                                <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 10v6M2 10l10-5 10 5-10 5z"></path></svg>
                            </div>
                            <div class="dr-mini-info">
                                <div class="dr-mini-title">Project Title Submission</div>
                                <div class="dr-mini-sub">05 Nov 2026</div>
                            </div>
                            <span class="dr-mini-tag" style="background:#3b0764; color:#c084fc;">14 days</span>
                        </div>

                        <!-- Java Exam -->
                        <div class="dr-mini-row">
                            <div class="dr-mini-accent" style="background:#6366f1;"></div>
                            <div class="dr-table-icon-box" style="background:#1e1b4b; width:28px; height:28px; color:#818cf8;">
                                <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2"><polyline points="16 18 22 12 16 6"></polyline><polyline points="8 6 2 12 8 18"></polyline></svg>
                            </div>
                            <div class="dr-mini-info">
                                <div class="dr-mini-title">Java Exam</div>
                                <div class="dr-mini-sub">10 Nov 2026</div>
                            </div>
                            <span class="dr-mini-tag" style="background:#3b0764; color:#c084fc;">19 days</span>
                        </div>
                    </div>
                </div>

            </div>

        </div>
    </main>
</div>

<!-- ADD / EDIT DEADLINE MODAL -->
<div class="dr-modal-overlay" id="addDeadlineModal">
    <div class="dr-modal">
        <div class="dr-modal-header">
            <h3 id="modalTitle">Add New Deadline</h3>
            <button type="button" class="dr-modal-close" onclick="closeModal()">&times;</button>
        </div>

        <form id="deadlineForm" onsubmit="handleSaveDeadline(event)">
            <input type="hidden" id="editDeadlineId" value="">

            <div class="dr-form-group">
                <label>Title</label>
                <input type="text" class="dr-form-control" id="modalTitleInput" required placeholder="e.g. DBMS Assignment 3">
            </div>

            <div class="dr-form-group">
                <label>Type</label>
                <select class="dr-form-control" id="modalTypeInput">
                    <option value="Assignment">Assignment</option>
                    <option value="Lab Work">Lab Work</option>
                    <option value="Project">Project</option>
                    <option value="Exam">Exam</option>
                    <option value="Club Event">Club Event</option>
                    <option value="Personal">Personal</option>
                    <option value="Other">Other</option>
                </select>
            </div>

            <div class="dr-form-group">
                <label>Subject / Category</label>
                <input type="text" class="dr-form-control" id="modalSubjectInput" placeholder="e.g. DBMS / Java / IoT">
            </div>

            <div class="dr-form-group">
                <label>Due Date</label>
                <input type="text" class="dr-form-control" id="modalDateInput" placeholder="e.g. 28 Oct 2026">
            </div>

            <div class="dr-form-group">
                <label>Priority</label>
                <select class="dr-form-control" id="modalPriorityInput">
                    <option value="High">High Priority</option>
                    <option value="Medium" selected>Medium Priority</option>
                    <option value="Low">Low Priority</option>
                </select>
            </div>

            <button type="submit" class="dr-modal-btn" id="modalSubmitBtn">Save Deadline</button>
        </form>
    </div>
</div>

<!-- TOAST -->
<div class="dr-toast" id="drToast">
    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="#a78bfa" stroke-width="2.2"><polyline points="20 6 9 17 4 12"></polyline></svg>
    <span id="drToastText">Action completed</span>
</div>

<!-- ===== SCRIPT & BACKEND AJAX INTEGRATION ===== -->
<script>
    var currentCategory = 'All Deadlines';
    var currentTimeframe = 'This Month';
    var currentSort = 'Due Date';
    var currentSearch = '';

    function showToast(msg) {
        var t = document.getElementById('drToast');
        document.getElementById('drToastText').textContent = msg;
        t.classList.add('show');
        setTimeout(function() { t.classList.remove('show'); }, 3200);
    }

    function selectCategoryTab(btn, cat) {
        currentCategory = cat;
        document.querySelectorAll('.dr-tab-btn').forEach(function(b) {
            b.classList.remove('active');
        });
        if (btn) {
            btn.classList.add('active');
        } else {
            // Find tab by text
            document.querySelectorAll('.dr-tab-btn').forEach(function(b) {
                if (b.textContent.trim().toLowerCase() === cat.toLowerCase()) {
                    b.classList.add('active');
                }
            });
        }
        fetchFilteredDeadlines();
        showToast('Filtering: ' + cat);
    }

    function handleTimeframeChange(val) {
        currentTimeframe = val;
        fetchFilteredDeadlines();
        showToast('Timeframe set to ' + val);
    }

    function handleSortChange(val) {
        currentSort = val;
        fetchFilteredDeadlines();
        showToast('Sorted by ' + val);
    }

    function handleSearch(query) {
        currentSearch = query;
        fetchFilteredDeadlines();
    }

    function filterNext7Days() {
        document.getElementById('timeframeSelect').value = 'This Week';
        currentTimeframe = 'This Week';
        fetchFilteredDeadlines();
        showToast('Viewing Next 7 Days deadlines');
    }

    function fetchFilteredDeadlines() {
        var params = new URLSearchParams();
        params.append('action', 'filter');
        params.append('category', currentCategory);
        params.append('timeframe', currentTimeframe);
        params.append('sort', currentSort);
        params.append('search', currentSearch);

        fetch('${pageContext.request.contextPath}/deadlines', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: params.toString()
        })
        .then(function(res) { return res.json(); })
        .then(function(data) {
            if (data.success) {
                renderTable(data.deadlines);
                updateKpis(data);
            }
        })
        .catch(function(err) {
            console.error('Fetch error:', err);
        });
    }

    function renderTable(list) {
        var tbody = document.getElementById('deadlinesTableBody');
        tbody.innerHTML = '';

        if (!list || list.length === 0) {
            tbody.innerHTML = '<tr><td colspan="6" style="text-align:center;padding:36px;color:#64748b;">No deadlines found matching criteria.</td></tr>';
            return;
        }

        list.forEach(function(d) {
            var tr = document.createElement('tr');

            // Icon SVG based on icon string
            var iconSvg = '<svg viewBox="0 0 24 24" width="15" height="15" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline></svg>';
            if (d.icon === 'grad') {
                iconSvg = '<svg viewBox="0 0 24 24" width="15" height="15" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 10v6M2 10l10-5 10 5-10 5z"></path></svg>';
            } else if (d.icon === 'users') {
                iconSvg = '<svg viewBox="0 0 24 24" width="15" height="15" fill="none" stroke="currentColor" stroke-width="2"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path></svg>';
            } else if (d.icon === 'book') {
                iconSvg = '<svg viewBox="0 0 24 24" width="15" height="15" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path></svg>';
            } else if (d.icon === 'code') {
                iconSvg = '<svg viewBox="0 0 24 24" width="15" height="15" fill="none" stroke="currentColor" stroke-width="2"><polyline points="16 18 22 12 16 6"></polyline><polyline points="8 6 2 12 8 18"></polyline></svg>';
            }

            var typePillClass = 'dr-pill-assignment';
            if (d.type === 'Lab Work') typePillClass = 'dr-pill-lab';
            else if (d.type === 'Project') typePillClass = 'dr-pill-project';
            else if (d.type === 'Exam') typePillClass = 'dr-pill-exam';
            else if (d.type === 'Club Event') typePillClass = 'dr-pill-clubevent';
            else if (d.type === 'Personal') typePillClass = 'dr-pill-personal';

            var statusClass = 'dr-status-upcoming';
            if (d.status === 'Overdue') statusClass = 'dr-status-overdue';
            else if (d.status === 'Due Soon') statusClass = 'dr-status-duesoon';
            else if (d.status === 'Completed') statusClass = 'dr-status-completed';

            tr.innerHTML = 
                '<td>' +
                    '<div class="dr-table-title-cell">' +
                        '<div class="dr-table-accent" style="background:' + escapeHtml(d.iconColor) + ';"></div>' +
                        '<div class="dr-table-icon-box" style="background:' + escapeHtml(d.iconColor) + ';">' + iconSvg + '</div>' +
                        '<span class="dr-table-title-text">' + escapeHtml(d.title) + '</span>' +
                    '</div>' +
                '</td>' +
                '<td><span class="dr-pill ' + typePillClass + '">' + escapeHtml(d.type) + '</span></td>' +
                '<td><span class="dr-subject-cell"><span class="dr-subject-dot" style="background:' + escapeHtml(d.subjectColor) + ';"></span>' + escapeHtml(d.subject) + '</span></td>' +
                '<td style="color:#cbd5e1; font-family:\'JetBrains Mono\',monospace; font-size:0.8rem;">' + escapeHtml(d.dueDate) + '</td>' +
                '<td><span class="dr-pill ' + statusClass + '">' + escapeHtml(d.status) + '</span></td>' +
                '<td style="text-align: right;">' +
                    '<div class="dr-actions-cell" style="justify-content: flex-end;">' +
                        '<button class="dr-action-btn" title="Edit" onclick="editDeadline(' + d.id + ')"><svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 20h9"></path><path d="M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4L16.5 3.5z"></path></svg></button>' +
                        '<button class="dr-action-btn delete" title="Delete" onclick="deleteDeadline(' + d.id + ')"><svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2"><polyline points="3 6 5 6 21 6"></polyline><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path></svg></button>' +
                    '</div>' +
                '</td>';
            tbody.appendChild(tr);
        });
    }

    function updateKpis(data) {
        if (data.overdueCount !== undefined) document.getElementById('kpiOverdue').textContent = data.overdueCount;
        if (data.dueThisWeekCount !== undefined) document.getElementById('kpiThisWeek').textContent = data.dueThisWeekCount;
        if (data.upcomingCount !== undefined) document.getElementById('kpiUpcoming').textContent = data.upcomingCount;
        if (data.completedCount !== undefined) document.getElementById('kpiCompleted').textContent = data.completedCount;
        if (data.totalCount !== undefined) document.getElementById('overviewTotalNum').textContent = data.totalCount;
    }

    function deleteDeadline(id) {
        if (!confirm('Are you sure you want to delete this deadline?')) return;

        fetch('${pageContext.request.contextPath}/deadlines', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'action=delete&id=' + encodeURIComponent(id)
        })
        .then(function(res) { return res.json(); })
        .then(function(data) {
            if (data.success) {
                fetchFilteredDeadlines();
                showToast('Deadline removed successfully');
            }
        });
    }

    function openAddModal() {
        document.getElementById('modalTitle').textContent = 'Add New Deadline';
        document.getElementById('editDeadlineId').value = '';
        document.getElementById('modalTitleInput').value = '';
        document.getElementById('modalSubjectInput').value = 'DBMS';
        document.getElementById('modalDateInput').value = '28 Oct 2026';
        document.getElementById('addDeadlineModal').classList.add('open');
    }

    function editDeadline(id) {
        document.getElementById('modalTitle').textContent = 'Edit Deadline #' + id;
        document.getElementById('editDeadlineId').value = id;
        document.getElementById('modalTitleInput').value = 'Updated Task #' + id;
        document.getElementById('addDeadlineModal').classList.add('open');
    }

    function closeModal() {
        document.getElementById('addDeadlineModal').classList.remove('open');
    }

    function handleSaveDeadline(e) {
        e.preventDefault();

        var params = new URLSearchParams();
        params.append('action', 'add');
        params.append('title', document.getElementById('modalTitleInput').value);
        params.append('type', document.getElementById('modalTypeInput').value);
        params.append('subject', document.getElementById('modalSubjectInput').value);
        params.append('dueDate', document.getElementById('modalDateInput').value);
        params.append('priority', document.getElementById('modalPriorityInput').value);

        fetch('${pageContext.request.contextPath}/deadlines', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: params.toString()
        })
        .then(function(res) { return res.json(); })
        .then(function(data) {
            closeModal();
            fetchFilteredDeadlines();
            showToast('Deadline added successfully!');
        });
    }

    function escapeHtml(str) {
        if (!str) return '';
        return String(str).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
    }
</script>

</body>
</html>
