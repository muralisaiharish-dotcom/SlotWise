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
    <title>Study Planner &mdash; SlotWise</title>
    <meta name="description" content="Plan your study, stay consistent, and achieve more with SlotWise Study Planner.">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg-body: #060814;
            --bg-sidebar: #070a18;
            --bg-card: #090e22;
            --bg-card-hover: #0c1430;
            --bg-card-inner: #0d132b;
            --border-card: rgba(255, 255, 255, 0.06);
            --border-subtle: rgba(255, 255, 255, 0.08);
            --primary-purple: #6d5dfc;
            --primary-gradient: linear-gradient(135deg, #6366f1 0%, #8b5cf6 100%);
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
            background-color: var(--bg-sidebar);
            border-right: 1px solid var(--border-card);
            display: flex;
            flex-direction: column;
            flex-shrink: 0;
            padding: 24px 16px;
            position: sticky;
            top: 0;
            height: 100vh;
            overflow-y: auto;
            z-index: 50;
        }

        .sw-sidebar::-webkit-scrollbar { width: 4px; }
        .sw-sidebar::-webkit-scrollbar-thumb { background: rgba(255,255,255,0.1); border-radius: 4px; }

        .sw-logo {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 0 10px 24px 10px;
            font-size: 1.25rem;
            font-weight: 800;
            color: #ffffff;
            letter-spacing: -0.02em;
        }

        .sw-logo-icon {
            width: 32px;
            height: 32px;
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
            gap: 4px;
            list-style: none;
            margin-top: 8px;
        }

        .sw-nav-item {
            display: flex;
            align-items: center;
            gap: 14px;
            padding: 10px 14px;
            border-radius: 10px;
            font-size: 0.88rem;
            font-weight: 500;
            color: var(--text-muted);
            transition: all 0.2s ease;
            position: relative;
        }

        .sw-nav-item svg {
            width: 18px;
            height: 18px;
            stroke-width: 2;
            flex-shrink: 0;
            transition: transform 0.2s ease, stroke 0.2s ease;
        }

        .sw-nav-item:hover {
            color: #ffffff;
            background: rgba(255, 255, 255, 0.04);
        }

        .sw-nav-item:hover svg {
            transform: scale(1.08);
            stroke: #a78bfa;
        }

        .sw-nav-item.active {
            background: linear-gradient(135deg, #4f46e5 0%, #7c3aed 100%);
            color: #ffffff;
            font-weight: 600;
            box-shadow: 0 4px 18px rgba(124, 58, 237, 0.4);
        }

        .sw-nav-item.active svg {
            stroke: #ffffff;
        }

        .sw-sidebar-footer {
            margin-top: auto;
            padding-top: 16px;
            border-top: 1px solid var(--border-card);
            position: relative;
        }

        /* Decorative squares in sidebar bottom */
        .sw-sidebar-deco {
            position: absolute;
            bottom: 4px;
            left: 10px;
            width: 80px;
            height: 80px;
            pointer-events: none;
            opacity: 0.12;
            background: radial-gradient(circle, #8b5cf6 20%, transparent 70%);
        }

        /* ===== MAIN CONTENT WRAPPER ===== */
        .sw-main {
            flex: 1;
            display: flex;
            flex-direction: column;
            min-width: 0;
            background: #060814;
        }

        /* ===== TOP NAVBAR ===== */
        .sw-topbar {
            height: 68px;
            padding: 0 32px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            border-bottom: 1px solid var(--border-card);
            background: rgba(6, 8, 20, 0.85);
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
            width: 17px;
            height: 17px;
            stroke: var(--text-muted);
            pointer-events: none;
        }

        .sw-search-input {
            width: 100%;
            height: 40px;
            padding: 0 16px 0 42px;
            background: #090e22;
            border: 1px solid var(--border-subtle);
            border-radius: 10px;
            color: #ffffff;
            font-size: 0.86rem;
            outline: none;
            transition: all 0.2s ease;
        }

        .sw-search-input::placeholder { color: #526079; }
        .sw-search-input:focus {
            border-color: #6366f1;
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.2);
            background: #0d1430;
        }

        .sw-topbar-actions {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .sw-bell-btn {
            position: relative;
            background: #090e22;
            border: 1px solid var(--border-subtle);
            width: 38px;
            height: 38px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--text-muted);
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .sw-bell-btn:hover {
            color: #ffffff;
            border-color: rgba(255,255,255,0.2);
        }

        .sw-bell-dot {
            position: absolute;
            top: 9px;
            right: 9px;
            width: 7px;
            height: 7px;
            background: #ef4444;
            border-radius: 50%;
            border: 1.5px solid #060814;
        }

        .sw-profile-pill {
            display: flex;
            align-items: center;
            gap: 11px;
            padding: 4px 14px 4px 4px;
            background: #090e22;
            border: 1px solid var(--border-subtle);
            border-radius: 28px;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .sw-profile-pill:hover {
            border-color: rgba(99, 102, 241, 0.4);
            background: #0d1430;
        }

        .sw-avatar-circle {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            background: linear-gradient(135deg, #f59e0b 0%, #ef4444 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: #ffffff;
            font-weight: 700;
            font-size: 0.82rem;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(245, 158, 11, 0.35);
        }

        .sw-profile-info {
            display: flex;
            flex-direction: column;
            line-height: 1.25;
        }

        .sw-profile-name {
            font-size: 0.85rem;
            font-weight: 600;
            color: #ffffff;
        }

        .sw-profile-role {
            font-size: 0.72rem;
            color: var(--text-muted);
        }

        /* ===== PAGE CONTENT ===== */
        .sw-content {
            padding: 28px 32px 50px 32px;
            display: flex;
            flex-direction: column;
            gap: 24px;
            max-width: 1440px;
            margin: 0 auto;
            width: 100%;
        }

        /* ===== HEADER BANNER ===== */
        .sp-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 20px;
            flex-wrap: wrap;
        }

        .sp-header-left h1 {
            font-size: 2rem;
            font-weight: 800;
            letter-spacing: -0.03em;
            color: #ffffff;
            line-height: 1.2;
        }

        .sp-header-left h1 span {
            background: linear-gradient(135deg, #a855f7 0%, #c084fc 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .sp-header-left p {
            color: var(--text-muted);
            font-size: 0.92rem;
            margin-top: 4px;
        }

        .sp-header-right {
            display: flex;
            align-items: center;
            gap: 14px;
        }

        .sp-toggle-group {
            display: flex;
            background: #090e22;
            border: 1px solid var(--border-subtle);
            border-radius: 12px;
            padding: 4px;
            gap: 4px;
        }

        .sp-toggle-btn {
            background: transparent;
            border: none;
            color: var(--text-muted);
            font-size: 0.84rem;
            font-weight: 600;
            padding: 7px 18px;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .sp-toggle-btn:hover {
            color: #ffffff;
        }

        .sp-toggle-btn.active {
            background: #4f46e5;
            color: #ffffff;
            box-shadow: 0 2px 10px rgba(79, 70, 229, 0.4);
        }

        .sp-btn-primary {
            display: flex;
            align-items: center;
            gap: 8px;
            background: linear-gradient(135deg, #6366f1 0%, #7c3aed 100%);
            color: #ffffff;
            border: none;
            font-size: 0.88rem;
            font-weight: 700;
            padding: 10px 20px;
            border-radius: 12px;
            cursor: pointer;
            transition: all 0.25s ease;
            box-shadow: 0 4px 18px rgba(99, 102, 241, 0.4);
        }

        .sp-btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 24px rgba(99, 102, 241, 0.55);
        }

        /* ===== TOP 4 KPI CARDS ===== */
        .sp-kpi-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 18px;
        }

        .sp-kpi-card {
            background: var(--bg-card);
            border: 1px solid var(--border-card);
            border-radius: 16px;
            padding: 20px 22px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            position: relative;
            overflow: hidden;
            transition: all 0.25s ease;
        }

        .sp-kpi-card:hover {
            transform: translateY(-3px);
            border-color: rgba(255, 255, 255, 0.12);
            background: var(--bg-card-hover);
        }

        .sp-kpi-main {
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .sp-kpi-icon-box {
            width: 48px;
            height: 48px;
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        .sp-kpi-icon-box svg {
            width: 24px;
            height: 24px;
        }

        .sp-kpi-text {
            display: flex;
            flex-direction: column;
            gap: 2px;
        }

        .sp-kpi-val {
            font-size: 1.65rem;
            font-weight: 800;
            color: #ffffff;
            letter-spacing: -0.02em;
        }

        .sp-kpi-label {
            font-size: 0.8rem;
            color: var(--text-muted);
            font-weight: 500;
        }

        .sp-sparkline {
            display: flex;
            align-items: flex-end;
            gap: 3px;
            height: 26px;
        }

        .sp-spark-bar {
            width: 4px;
            border-radius: 2px;
            opacity: 0.8;
            transition: height 0.3s ease;
        }

        /* ===== MAIN TWO-COLUMN SECTION ===== */
        .sp-main-grid {
            display: grid;
            grid-template-columns: 1.65fr 1fr;
            gap: 22px;
        }

        .sp-card {
            background: var(--bg-card);
            border: 1px solid var(--border-card);
            border-radius: 16px;
            padding: 24px;
            display: flex;
            flex-direction: column;
            position: relative;
        }

        .sp-card-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 20px;
        }

        .sp-card-title {
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 1.05rem;
            font-weight: 700;
            color: #ffffff;
        }

        .sp-card-title-icon {
            width: 32px;
            height: 32px;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 9px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #a78bfa;
        }

        .sp-date-badge {
            font-size: 0.82rem;
            font-weight: 500;
            color: var(--text-muted);
            margin-left: 4px;
        }

        .sp-card-actions {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .sp-btn-sm {
            display: flex;
            align-items: center;
            gap: 6px;
            background: rgba(16, 185, 129, 0.12);
            color: #10b981;
            border: 1px solid rgba(16, 185, 129, 0.25);
            padding: 6px 14px;
            border-radius: 8px;
            font-size: 0.78rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .sp-btn-sm:hover {
            background: rgba(16, 185, 129, 0.22);
            border-color: rgba(16, 185, 129, 0.45);
        }

        .sp-icon-btn {
            background: rgba(255, 255, 255, 0.04);
            border: 1px solid var(--border-subtle);
            width: 32px;
            height: 32px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--text-muted);
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .sp-icon-btn:hover {
            color: #ffffff;
            border-color: rgba(255, 255, 255, 0.2);
            background: rgba(255, 255, 255, 0.08);
        }

        /* ===== STUDY SESSION ROWS ===== */
        .sp-session-list {
            display: flex;
            flex-direction: column;
            gap: 11px;
        }

        .sp-session-row {
            display: flex;
            align-items: center;
            background: #090e24;
            border: 1px solid rgba(255, 255, 255, 0.05);
            border-radius: 12px;
            padding: 12px 16px;
            gap: 14px;
            transition: all 0.2s ease;
        }

        .sp-session-row:hover {
            border-color: rgba(255, 255, 255, 0.12);
            background: #0d1532;
        }

        .sp-session-row.completed {
            opacity: 0.6;
        }

        .sp-session-row.completed .sp-session-subj,
        .sp-session-row.completed .sp-session-topic {
            text-decoration: line-through;
            color: var(--text-dim);
        }

        /* Checkbox circle */
        .sp-checkbox {
            width: 18px;
            height: 18px;
            border-radius: 50%;
            border: 2px solid #6366f1;
            background: transparent;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
            transition: all 0.2s ease;
        }

        .sp-checkbox:hover {
            border-color: #a78bfa;
            transform: scale(1.1);
        }

        .sp-checkbox.checked {
            background: #10b981;
            border-color: #10b981;
        }

        .sp-checkbox.checked svg {
            display: block;
        }

        .sp-checkbox svg {
            display: none;
            width: 10px;
            height: 10px;
            stroke: #ffffff;
            stroke-width: 3;
        }

        /* Time pill with left accent bar */
        .sp-time-pill {
            display: flex;
            align-items: center;
            background: rgba(255, 255, 255, 0.03);
            border: 1px solid rgba(255, 255, 255, 0.06);
            border-radius: 6px;
            padding: 5px 10px;
            font-size: 0.76rem;
            color: #cbd5e1;
            font-family: 'JetBrains Mono', monospace;
            position: relative;
            white-space: nowrap;
            overflow: hidden;
            flex-shrink: 0;
        }

        .sp-time-accent {
            width: 3px;
            height: 14px;
            border-radius: 2px;
            margin-right: 8px;
            flex-shrink: 0;
        }

        /* Info columns */
        .sp-session-subj {
            font-size: 0.88rem;
            font-weight: 600;
            color: #ffffff;
            width: 130px;
            flex-shrink: 0;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .sp-session-topic {
            font-size: 0.82rem;
            color: var(--text-muted);
            flex: 1;
            min-width: 100px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        /* Type pills */
        .sp-pill {
            padding: 4px 11px;
            border-radius: 20px;
            font-size: 0.72rem;
            font-weight: 600;
            flex-shrink: 0;
            text-align: center;
        }

        .sp-duration {
            font-size: 0.78rem;
            font-family: 'JetBrains Mono', monospace;
            color: #cbd5e1;
            width: 38px;
            text-align: center;
            flex-shrink: 0;
        }

        /* Actions: Play, Edit, Delete */
        .sp-actions-box {
            display: flex;
            align-items: center;
            gap: 8px;
            flex-shrink: 0;
        }

        .sp-play-btn {
            width: 28px;
            height: 28px;
            border-radius: 50%;
            border: 1.5px solid #10b981;
            background: rgba(16, 185, 129, 0.08);
            color: #10b981;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .sp-play-btn:hover {
            background: #10b981;
            color: #ffffff;
            transform: scale(1.1);
            box-shadow: 0 0 12px rgba(16, 185, 129, 0.4);
        }

        .sp-play-btn svg {
            width: 12px;
            height: 12px;
            fill: currentColor;
            margin-left: 2px;
        }

        .sp-edit-btn, .sp-del-btn {
            background: transparent;
            border: none;
            color: var(--text-muted);
            cursor: pointer;
            padding: 4px;
            border-radius: 4px;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.2s ease;
        }

        .sp-edit-btn:hover { color: #60a5fa; transform: scale(1.15); }
        .sp-del-btn:hover { color: #f87171; transform: scale(1.15); }

        .sp-edit-btn svg, .sp-del-btn svg { width: 14px; height: 14px; }

        /* Today's study plan footer */
        .sp-plan-footer {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-top: 18px;
            padding-top: 14px;
            border-top: 1px solid rgba(255, 255, 255, 0.05);
        }

        .sp-add-session-btn {
            display: flex;
            align-items: center;
            gap: 8px;
            background: transparent;
            border: none;
            color: #818cf8;
            font-size: 0.85rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .sp-add-session-btn:hover {
            color: #a78bfa;
            transform: translateX(3px);
        }

        .sp-circle-arrow-btn {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            background: rgba(99, 102, 241, 0.15);
            border: 1px solid rgba(99, 102, 241, 0.3);
            color: #818cf8;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .sp-circle-arrow-btn:hover {
            background: #6366f1;
            color: #ffffff;
            transform: scale(1.08);
        }

        /* ===== RIGHT COLUMN CARDS ===== */
        .sp-right-col {
            display: flex;
            flex-direction: column;
            gap: 22px;
        }

        /* Study Overview Donut */
        .sp-donut-wrapper {
            display: flex;
            align-items: center;
            gap: 24px;
        }

        .sp-donut-chart {
            position: relative;
            width: 140px;
            height: 140px;
            flex-shrink: 0;
        }

        .sp-donut-svg {
            transform: rotate(-90deg);
            width: 140px;
            height: 140px;
        }

        .sp-donut-center {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            pointer-events: none;
        }

        .sp-donut-val {
            font-size: 1.45rem;
            font-weight: 800;
            color: #ffffff;
            line-height: 1.1;
        }

        .sp-donut-sub {
            font-size: 0.72rem;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .sp-legend-list {
            display: flex;
            flex-direction: column;
            gap: 8px;
            flex: 1;
        }

        .sp-legend-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            font-size: 0.8rem;
        }

        .sp-legend-left {
            display: flex;
            align-items: center;
            gap: 8px;
            color: #cbd5e1;
        }

        .sp-legend-dot {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            flex-shrink: 0;
        }

        .sp-legend-stat {
            color: var(--text-muted);
            font-family: 'JetBrains Mono', monospace;
            font-size: 0.76rem;
        }

        /* Subject Progress Bars */
        .sp-subj-list {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        .sp-subj-row {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .sp-subj-icon-box {
            width: 28px;
            height: 28px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #ffffff;
            flex-shrink: 0;
        }

        .sp-subj-icon-box svg { width: 14px; height: 14px; }

        .sp-subj-name {
            font-size: 0.82rem;
            font-weight: 600;
            color: #cbd5e1;
            width: 105px;
            flex-shrink: 0;
        }

        .sp-progress-track {
            flex: 1;
            height: 8px;
            background: rgba(255, 255, 255, 0.06);
            border-radius: 6px;
            overflow: hidden;
            position: relative;
        }

        .sp-progress-fill {
            height: 100%;
            border-radius: 6px;
            transition: width 0.6s cubic-bezier(0.4, 0, 0.2, 1);
        }

        .sp-subj-pct {
            font-size: 0.78rem;
            font-family: 'JetBrains Mono', monospace;
            color: var(--text-muted);
            width: 32px;
            text-align: right;
            flex-shrink: 0;
        }

        /* ===== BOTTOM 3 CARDS ROW ===== */
        .sp-bottom-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 22px;
        }

        /* 1. Study Goals */
        .sp-goal-list {
            display: flex;
            flex-direction: column;
            gap: 14px;
        }

        .sp-goal-item {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .sp-goal-title {
            font-size: 0.82rem;
            color: #e2e8f0;
            font-weight: 500;
            width: 145px;
            flex-shrink: 0;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        /* 2. Recommended for You */
        .sp-rec-list {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        .sp-rec-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            background: rgba(255, 255, 255, 0.02);
            border: 1px solid rgba(255, 255, 255, 0.05);
            border-radius: 12px;
            padding: 10px 14px;
            gap: 10px;
        }

        .sp-rec-left {
            display: flex;
            align-items: center;
            gap: 12px;
            min-width: 0;
        }

        .sp-rec-icon-box {
            width: 34px;
            height: 34px;
            border-radius: 9px;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        .sp-rec-info {
            display: flex;
            flex-direction: column;
            gap: 2px;
            min-width: 0;
        }

        .sp-rec-title {
            font-size: 0.82rem;
            font-weight: 600;
            color: #ffffff;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .sp-rec-sub {
            font-size: 0.72rem;
            color: var(--text-muted);
        }

        .sp-rec-btn {
            background: rgba(99, 102, 241, 0.15);
            border: 1px solid rgba(99, 102, 241, 0.35);
            color: #a78bfa;
            padding: 5px 14px;
            border-radius: 8px;
            font-size: 0.76rem;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.2s ease;
            flex-shrink: 0;
        }

        .sp-rec-btn:hover {
            background: #6366f1;
            color: #ffffff;
            border-color: #6366f1;
        }

        /* 3. Study Streak */
        .sp-streak-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 20px;
        }

        .sp-streak-badge {
            display: flex;
            align-items: center;
            gap: 6px;
            font-size: 0.88rem;
            font-weight: 700;
            color: #fb923c;
        }

        .sp-week-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin: 10px 0 24px 0;
        }

        .sp-day-col {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 8px;
        }

        .sp-day-circle {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.75rem;
            transition: all 0.2s ease;
        }

        .sp-day-circle.checked {
            background: #6366f1;
            box-shadow: 0 2px 10px rgba(99, 102, 241, 0.4);
            color: #ffffff;
        }

        .sp-day-circle.unchecked {
            border: 1.5px solid rgba(255, 255, 255, 0.15);
            background: transparent;
            color: transparent;
        }

        .sp-day-label {
            font-size: 0.72rem;
            color: var(--text-muted);
            font-weight: 500;
        }

        .sp-streak-footer {
            display: flex;
            align-items: center;
            justify-content: space-between;
            background: rgba(255, 255, 255, 0.02);
            border: 1px solid rgba(255, 255, 255, 0.05);
            border-radius: 10px;
            padding: 10px 14px;
            font-size: 0.78rem;
            color: #94a3b8;
        }

        /* ===== MODALS ===== */
        .sp-modal-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100vw;
            height: 100vh;
            background: rgba(6, 8, 20, 0.8);
            backdrop-filter: blur(10px);
            display: none;
            align-items: center;
            justify-content: center;
            z-index: 1000;
        }

        .sp-modal-overlay.open { display: flex; }

        .sp-modal {
            background: #0d1430;
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 20px;
            width: 480px;
            max-width: 90vw;
            padding: 28px;
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.7);
            animation: modalPop 0.25s ease-out;
        }

        @keyframes modalPop {
            0% { transform: scale(0.92); opacity: 0; }
            100% { transform: scale(1); opacity: 1; }
        }

        .sp-modal-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 22px;
        }

        .sp-modal-header h3 {
            font-size: 1.2rem;
            font-weight: 700;
            color: #ffffff;
        }

        .sp-modal-close {
            background: transparent;
            border: none;
            color: var(--text-muted);
            font-size: 1.4rem;
            cursor: pointer;
            line-height: 1;
        }

        .sp-modal-close:hover { color: #ffffff; }

        .sp-form-group {
            display: flex;
            flex-direction: column;
            gap: 6px;
            margin-bottom: 16px;
        }

        .sp-form-group label {
            font-size: 0.8rem;
            font-weight: 600;
            color: var(--text-muted);
        }

        .sp-form-control {
            background: #090e22;
            border: 1px solid var(--border-subtle);
            border-radius: 10px;
            height: 42px;
            padding: 0 14px;
            color: #ffffff;
            font-size: 0.88rem;
            outline: none;
            transition: all 0.2s ease;
        }

        .sp-form-control:focus {
            border-color: #6366f1;
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.2);
        }

        .sp-modal-submit {
            width: 100%;
            height: 44px;
            background: linear-gradient(135deg, #6366f1 0%, #7c3aed 100%);
            border: none;
            border-radius: 10px;
            color: #ffffff;
            font-weight: 700;
            font-size: 0.92rem;
            cursor: pointer;
            margin-top: 8px;
            transition: all 0.2s ease;
        }

        .sp-modal-submit:hover {
            box-shadow: 0 6px 20px rgba(99, 102, 241, 0.45);
            transform: translateY(-1px);
        }

        /* ===== STUDY TIMER MODAL ===== */
        .sp-timer-box {
            display: flex;
            flex-direction: column;
            align-items: center;
            text-align: center;
            padding: 10px 0;
        }

        .sp-timer-title {
            font-size: 1.15rem;
            font-weight: 700;
            color: #ffffff;
        }

        .sp-timer-sub {
            font-size: 0.85rem;
            color: var(--text-muted);
            margin-top: 4px;
            margin-bottom: 24px;
        }

        .sp-timer-clock-ring {
            position: relative;
            width: 190px;
            height: 190px;
            margin-bottom: 24px;
        }

        .sp-timer-clock-ring svg {
            width: 190px;
            height: 190px;
            transform: rotate(-90deg);
        }

        .sp-timer-clock-text {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            font-size: 2.2rem;
            font-weight: 800;
            color: #ffffff;
            font-family: 'JetBrains Mono', monospace;
        }

        .sp-timer-ctrls {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .sp-timer-btn {
            padding: 10px 22px;
            border-radius: 10px;
            font-size: 0.88rem;
            font-weight: 700;
            border: none;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .sp-timer-btn.play {
            background: #10b981;
            color: #ffffff;
        }

        .sp-timer-btn.pause {
            background: #f59e0b;
            color: #ffffff;
        }

        .sp-timer-btn.reset {
            background: rgba(255, 255, 255, 0.08);
            color: #cbd5e1;
        }

        .sp-timer-btn.complete {
            background: #6366f1;
            color: #ffffff;
        }

        /* ===== TOAST ===== */
        .sp-toast {
            position: fixed;
            bottom: 24px;
            right: 24px;
            background: #0d1532;
            border: 1px solid rgba(99, 102, 241, 0.4);
            border-radius: 12px;
            padding: 12px 20px;
            color: #ffffff;
            font-size: 0.88rem;
            display: flex;
            align-items: center;
            gap: 10px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.6);
            transform: translateY(80px);
            opacity: 0;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            z-index: 2000;
        }

        .sp-toast.show {
            transform: translateY(0);
            opacity: 1;
        }

        @media (max-width: 1200px) {
            .sp-main-grid { grid-template-columns: 1fr; }
            .sp-bottom-grid { grid-template-columns: 1fr; }
            .sp-kpi-grid { grid-template-columns: repeat(2, 1fr); }
        }
    </style>
</head>
<body>

<div class="sw-layout">

    <!-- ===== LEFT SIDEBAR ===== -->
    <aside class="sw-sidebar">
        <a href="${pageContext.request.contextPath}/dashboard" class="sw-logo">
            <div class="sw-logo-icon">
                <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
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
                <a href="${pageContext.request.contextPath}/today-timetable.jsp" class="sw-nav-item">
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

            <!-- Study Planner (ACTIVE) -->
            <li>
                <a href="${pageContext.request.contextPath}/study-planner" class="sw-nav-item active">
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

            <!-- Study Groups -->
            <li>
                <a href="${pageContext.request.contextPath}/study-groups.jsp" class="sw-nav-item">
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
                        <circle cx="12" cy="12" r="6"></circle>
                        <circle cx="12" cy="12" r="2"></circle>
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
            <div class="sw-sidebar-deco"></div>
            <a href="${pageContext.request.contextPath}/logout" class="sw-nav-item">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round">
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

        <!-- ===== TOPBAR ===== -->
        <header class="sw-topbar">
            <div class="sw-search-wrapper">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <circle cx="11" cy="11" r="8"></circle>
                    <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                </svg>
                <input type="text" class="sw-search-input" id="studySearchInput"
                       placeholder="Search subjects, topics, or study plans..."
                       onkeyup="handleSearch(this.value)">
            </div>

            <div class="sw-topbar-actions">
                <button type="button" class="sw-bell-btn" title="Notifications" onclick="showToast('You have 2 study sessions coming up today.')">
                    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"></path>
                        <path d="M13.73 21a2 2 0 0 1-3.46 0"></path>
                    </svg>
                    <span class="sw-bell-dot"></span>
                </button>

                <a href="${pageContext.request.contextPath}/settings" class="sw-profile-pill">
                    <div class="sw-avatar-circle">
                        <span><%= displayName.substring(0, 1).toUpperCase() %></span>
                    </div>
                    <div class="sw-profile-info">
                        <span class="sw-profile-name"><%= displayName %></span>
                        <span class="sw-profile-role"><%= yearRole %></span>
                    </div>
                </a>
            </div>
        </header>

        <!-- ===== PAGE CONTENT CONTAINER ===== -->
        <div class="sw-content">

            <!-- PAGE HEADER & CONTROLS -->
            <div class="sp-header">
                <div class="sp-header-left">
                    <h1>Study <span>Planner</span></h1>
                    <p>Plan your study. Stay consistent. Achieve more.</p>
                </div>
                <div class="sp-header-right">
                    <div class="sp-toggle-group" id="timeframeToggles">
                        <button type="button" class="sp-toggle-btn active" onclick="switchTimeframe(this, 'Daily')">Daily</button>
                        <button type="button" class="sp-toggle-btn" onclick="switchTimeframe(this, 'Weekly')">Weekly</button>
                        <button type="button" class="sp-toggle-btn" onclick="switchTimeframe(this, 'Monthly')">Monthly</button>
                    </div>

                    <button type="button" class="sp-btn-primary" onclick="openAddSessionModal()">
                        <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round">
                            <line x1="12" y1="5" x2="12" y2="19"></line>
                            <line x1="5" y1="12" x2="19" y2="12"></line>
                        </svg>
                        <span>Create Study Plan</span>
                    </button>
                </div>
            </div>

            <!-- TOP 4 KPI CARDS -->
            <div class="sp-kpi-grid">
                <!-- 1. Subjects Planned -->
                <div class="sp-kpi-card">
                    <div class="sp-kpi-main">
                        <div class="sp-kpi-icon-box" style="background: rgba(124, 58, 237, 0.2); color: #a78bfa;">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round">
                                <circle cx="12" cy="12" r="10"></circle>
                                <circle cx="12" cy="12" r="6"></circle>
                                <circle cx="12" cy="12" r="2"></circle>
                            </svg>
                        </div>
                        <div class="sp-kpi-text">
                            <span class="sp-kpi-val" id="kpiSubjects">${subjectsPlannedCount != null ? subjectsPlannedCount : 5}</span>
                            <span class="sp-kpi-label">Subjects Planned</span>
                        </div>
                    </div>
                    <div class="sp-sparkline">
                        <div class="sp-spark-bar" style="height: 10px; background: #a78bfa;"></div>
                        <div class="sp-spark-bar" style="height: 18px; background: #a78bfa;"></div>
                        <div class="sp-spark-bar" style="height: 14px; background: #a78bfa;"></div>
                        <div class="sp-spark-bar" style="height: 24px; background: #a78bfa;"></div>
                    </div>
                </div>

                <!-- 2. Tasks Completed -->
                <div class="sp-kpi-card">
                    <div class="sp-kpi-main">
                        <div class="sp-kpi-icon-box" style="background: rgba(16, 185, 129, 0.2); color: #34d399;">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                                <polyline points="22 4 12 14.01 9 11.01"></polyline>
                            </svg>
                        </div>
                        <div class="sp-kpi-text">
                            <span class="sp-kpi-val" id="kpiTasks">${tasksCompletedCount != null ? tasksCompletedCount : 8}</span>
                            <span class="sp-kpi-label">Tasks Completed</span>
                        </div>
                    </div>
                    <div class="sp-sparkline">
                        <div class="sp-spark-bar" style="height: 8px; background: #34d399;"></div>
                        <div class="sp-spark-bar" style="height: 14px; background: #34d399;"></div>
                        <div class="sp-spark-bar" style="height: 20px; background: #34d399;"></div>
                        <div class="sp-spark-bar" style="height: 26px; background: #34d399;"></div>
                    </div>
                </div>

                <!-- 3. Planned Study Time -->
                <div class="sp-kpi-card">
                    <div class="sp-kpi-main">
                        <div class="sp-kpi-icon-box" style="background: rgba(245, 158, 11, 0.2); color: #fbbf24;">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round">
                                <circle cx="12" cy="12" r="10"></circle>
                                <polyline points="12 6 12 12 16 14"></polyline>
                            </svg>
                        </div>
                        <div class="sp-kpi-text">
                            <span class="sp-kpi-val" id="kpiPlanned">${plannedStudyTime != null ? plannedStudyTime : '12h 30m'}</span>
                            <span class="sp-kpi-label">Planned Study Time</span>
                        </div>
                    </div>
                    <div class="sp-sparkline">
                        <div class="sp-spark-bar" style="height: 14px; background: #fbbf24;"></div>
                        <div class="sp-spark-bar" style="height: 22px; background: #fbbf24;"></div>
                        <div class="sp-spark-bar" style="height: 16px; background: #fbbf24;"></div>
                        <div class="sp-spark-bar" style="height: 25px; background: #fbbf24;"></div>
                    </div>
                </div>

                <!-- 4. Actual Study Time -->
                <div class="sp-kpi-card">
                    <div class="sp-kpi-main">
                        <div class="sp-kpi-icon-box" style="background: rgba(147, 51, 234, 0.2); color: #c084fc;">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round">
                                <line x1="18" y1="20" x2="18" y2="10"></line>
                                <line x1="12" y1="20" x2="12" y2="4"></line>
                                <line x1="6" y1="20" x2="6" y2="14"></line>
                            </svg>
                        </div>
                        <div class="sp-kpi-text">
                            <span class="sp-kpi-val" id="kpiActual">${actualStudyTime != null ? actualStudyTime : '9h 15m'}</span>
                            <span class="sp-kpi-label">Actual Study Time</span>
                        </div>
                    </div>
                    <div class="sp-sparkline">
                        <div class="sp-spark-bar" style="height: 12px; background: #c084fc;"></div>
                        <div class="sp-spark-bar" style="height: 19px; background: #c084fc;"></div>
                        <div class="sp-spark-bar" style="height: 15px; background: #c084fc;"></div>
                        <div class="sp-spark-bar" style="height: 24px; background: #c084fc;"></div>
                    </div>
                </div>
            </div>

            <!-- MAIN TWO-COLUMN SECTION -->
            <div class="sp-main-grid">

                <!-- LEFT COLUMN: TODAY'S STUDY PLAN -->
                <div class="sp-card">
                    <div class="sp-card-header">
                        <div class="sp-card-title">
                            <div class="sp-card-title-icon">
                                <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2">
                                    <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                    <line x1="16" y1="2" x2="16" y2="6"></line>
                                    <line x1="8" y1="2" x2="8" y2="6"></line>
                                    <line x1="3" y1="10" x2="21" y2="10"></line>
                                </svg>
                            </div>
                            <span>Today's Study Plan</span>
                            <span class="sp-date-badge">20 Oct 2026</span>
                        </div>

                        <div class="sp-card-actions">
                            <button type="button" class="sp-btn-sm" onclick="markAllComplete()">
                                <svg viewBox="0 0 24 24" width="13" height="13" fill="none" stroke="currentColor" stroke-width="3"><polyline points="20 6 9 17 4 12"></polyline></svg>
                                <span>Mark All Complete</span>
                            </button>
                            <button type="button" class="sp-icon-btn" title="Options" onclick="showToast('Options: Auto-Reschedule active for conflicts.')">
                                <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2">
                                    <circle cx="12" cy="12" r="1.5"></circle>
                                    <circle cx="12" cy="5" r="1.5"></circle>
                                    <circle cx="12" cy="19" r="1.5"></circle>
                                </svg>
                            </button>
                        </div>
                    </div>

                    <!-- STUDY SESSIONS LIST CONTAINER -->
                    <div class="sp-session-list" id="sessionListContainer">
                        <!-- 1. Data Structures -->
                        <div class="sp-session-row" id="sessionRow-1">
                            <div class="sp-checkbox" onclick="toggleComplete(1, this)"><svg viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"></polyline></svg></div>
                            <div class="sp-time-pill"><div class="sp-time-accent" style="background:#f97316;"></div>08:00 AM – 09:00 AM</div>
                            <span class="sp-session-subj">Data Structures</span>
                            <span class="sp-session-topic">Trees - Introduction</span>
                            <span class="sp-pill" style="background:#1e1b4b; color:#818cf8;">Lecture</span>
                            <span class="sp-duration">1h</span>
                            <div class="sp-actions-box">
                                <button type="button" class="sp-play-btn" title="Start Timer" onclick="startTimer('Data Structures', 'Trees - Introduction', 60)"><svg viewBox="0 0 24 24"><polygon points="5 3 19 12 5 21 5 3"></polygon></svg></button>
                                <button type="button" class="sp-edit-btn" title="Edit" onclick="openEditModal(1, '08:00 AM - 09:00 AM', 'Data Structures', 'Trees - Introduction', 'Lecture', '1h')"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 20h9"></path><path d="M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4L16.5 3.5z"></path></svg></button>
                                <button type="button" class="sp-del-btn" title="Delete" onclick="deleteSession(1)"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="3 6 5 6 21 6"></polyline><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path></svg></button>
                            </div>
                        </div>

                        <!-- 2. DBMS -->
                        <div class="sp-session-row" id="sessionRow-2">
                            <div class="sp-checkbox" onclick="toggleComplete(2, this)"><svg viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"></polyline></svg></div>
                            <div class="sp-time-pill"><div class="sp-time-accent" style="background:#06b6d4;"></div>09:15 AM – 10:15 AM</div>
                            <span class="sp-session-subj">DBMS</span>
                            <span class="sp-session-topic">Normalization</span>
                            <span class="sp-pill" style="background:#082f49; color:#38bdf8;">Notes</span>
                            <span class="sp-duration">1h</span>
                            <div class="sp-actions-box">
                                <button type="button" class="sp-play-btn" title="Start Timer" onclick="startTimer('DBMS', 'Normalization', 60)"><svg viewBox="0 0 24 24"><polygon points="5 3 19 12 5 21 5 3"></polygon></svg></button>
                                <button type="button" class="sp-edit-btn" title="Edit" onclick="openEditModal(2, '09:15 AM - 10:15 AM', 'DBMS', 'Normalization', 'Notes', '1h')"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 20h9"></path><path d="M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4L16.5 3.5z"></path></svg></button>
                                <button type="button" class="sp-del-btn" title="Delete" onclick="deleteSession(2)"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="3 6 5 6 21 6"></polyline><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path></svg></button>
                            </div>
                        </div>

                        <!-- 3. Java -->
                        <div class="sp-session-row" id="sessionRow-3">
                            <div class="sp-checkbox" onclick="toggleComplete(3, this)"><svg viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"></polyline></svg></div>
                            <div class="sp-time-pill"><div class="sp-time-accent" style="background:#3b82f6;"></div>10:30 AM – 11:30 AM</div>
                            <span class="sp-session-subj">Java</span>
                            <span class="sp-session-topic">Exception Handling</span>
                            <span class="sp-pill" style="background:#064e3b; color:#34d399;">Practice</span>
                            <span class="sp-duration">1h</span>
                            <div class="sp-actions-box">
                                <button type="button" class="sp-play-btn" title="Start Timer" onclick="startTimer('Java', 'Exception Handling', 60)"><svg viewBox="0 0 24 24"><polygon points="5 3 19 12 5 21 5 3"></polygon></svg></button>
                                <button type="button" class="sp-edit-btn" title="Edit" onclick="openEditModal(3, '10:30 AM - 11:30 AM', 'Java', 'Exception Handling', 'Practice', '1h')"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 20h9"></path><path d="M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4L16.5 3.5z"></path></svg></button>
                                <button type="button" class="sp-del-btn" title="Delete" onclick="deleteSession(3)"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="3 6 5 6 21 6"></polyline><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path></svg></button>
                            </div>
                        </div>

                        <!-- 4. Mathematics -->
                        <div class="sp-session-row" id="sessionRow-4">
                            <div class="sp-checkbox" onclick="toggleComplete(4, this)"><svg viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"></polyline></svg></div>
                            <div class="sp-time-pill"><div class="sp-time-accent" style="background:#10b981;"></div>12:00 PM – 01:00 PM</div>
                            <span class="sp-session-subj">Mathematics</span>
                            <span class="sp-session-topic">Probability</span>
                            <span class="sp-pill" style="background:#451a03; color:#fbbf24;">Revision</span>
                            <span class="sp-duration">1h</span>
                            <div class="sp-actions-box">
                                <button type="button" class="sp-play-btn" title="Start Timer" onclick="startTimer('Mathematics', 'Probability', 60)"><svg viewBox="0 0 24 24"><polygon points="5 3 19 12 5 21 5 3"></polygon></svg></button>
                                <button type="button" class="sp-edit-btn" title="Edit" onclick="openEditModal(4, '12:00 PM - 01:00 PM', 'Mathematics', 'Probability', 'Revision', '1h')"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 20h9"></path><path d="M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4L16.5 3.5z"></path></svg></button>
                                <button type="button" class="sp-del-btn" title="Delete" onclick="deleteSession(4)"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="3 6 5 6 21 6"></polyline><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path></svg></button>
                            </div>
                        </div>

                        <!-- 5. Internet of Things -->
                        <div class="sp-session-row" id="sessionRow-5">
                            <div class="sp-checkbox" onclick="toggleComplete(5, this)"><svg viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"></polyline></svg></div>
                            <div class="sp-time-pill"><div class="sp-time-accent" style="background:#14b8a6;"></div>02:00 PM – 03:00 PM</div>
                            <span class="sp-session-subj">Internet of Things</span>
                            <span class="sp-session-topic">Sensors and Actuators</span>
                            <span class="sp-pill" style="background:#082f49; color:#38bdf8;">Notes</span>
                            <span class="sp-duration">1h</span>
                            <div class="sp-actions-box">
                                <button type="button" class="sp-play-btn" title="Start Timer" onclick="startTimer('Internet of Things', 'Sensors and Actuators', 60)"><svg viewBox="0 0 24 24"><polygon points="5 3 19 12 5 21 5 3"></polygon></svg></button>
                                <button type="button" class="sp-edit-btn" title="Edit" onclick="openEditModal(5, '02:00 PM - 03:00 PM', 'Internet of Things', 'Sensors and Actuators', 'Notes', '1h')"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 20h9"></path><path d="M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4L16.5 3.5z"></path></svg></button>
                                <button type="button" class="sp-del-btn" title="Delete" onclick="deleteSession(5)"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="3 6 5 6 21 6"></polyline><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path></svg></button>
                            </div>
                        </div>

                        <!-- 6. DSA -->
                        <div class="sp-session-row" id="sessionRow-6">
                            <div class="sp-checkbox" onclick="toggleComplete(6, this)"><svg viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"></polyline></svg></div>
                            <div class="sp-time-pill"><div class="sp-time-accent" style="background:#ef4444;"></div>03:15 PM – 04:15 PM</div>
                            <span class="sp-session-subj">DSA</span>
                            <span class="sp-session-topic">Graph Algorithms</span>
                            <span class="sp-pill" style="background:#064e3b; color:#34d399;">Practice</span>
                            <span class="sp-duration">1h</span>
                            <div class="sp-actions-box">
                                <button type="button" class="sp-play-btn" title="Start Timer" onclick="startTimer('DSA', 'Graph Algorithms', 60)"><svg viewBox="0 0 24 24"><polygon points="5 3 19 12 5 21 5 3"></polygon></svg></button>
                                <button type="button" class="sp-edit-btn" title="Edit" onclick="openEditModal(6, '03:15 PM - 04:15 PM', 'DSA', 'Graph Algorithms', 'Practice', '1h')"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 20h9"></path><path d="M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4L16.5 3.5z"></path></svg></button>
                                <button type="button" class="sp-del-btn" title="Delete" onclick="deleteSession(6)"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="3 6 5 6 21 6"></polyline><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path></svg></button>
                            </div>
                        </div>

                        <!-- 7. Project Work -->
                        <div class="sp-session-row" id="sessionRow-7">
                            <div class="sp-checkbox" onclick="toggleComplete(7, this)"><svg viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"></polyline></svg></div>
                            <div class="sp-time-pill"><div class="sp-time-accent" style="background:#8b5cf6;"></div>04:30 PM – 05:00 PM</div>
                            <span class="sp-session-subj">Project Work</span>
                            <span class="sp-session-topic">SlotWise - Module</span>
                            <span class="sp-pill" style="background:#4a044e; color:#f472b6;">Project</span>
                            <span class="sp-duration">30m</span>
                            <div class="sp-actions-box">
                                <button type="button" class="sp-play-btn" title="Start Timer" onclick="startTimer('Project Work', 'SlotWise - Module', 30)"><svg viewBox="0 0 24 24"><polygon points="5 3 19 12 5 21 5 3"></polygon></svg></button>
                                <button type="button" class="sp-edit-btn" title="Edit" onclick="openEditModal(7, '04:30 PM - 05:00 PM', 'Project Work', 'SlotWise - Module', 'Project', '30m')"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 20h9"></path><path d="M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4L16.5 3.5z"></path></svg></button>
                                <button type="button" class="sp-del-btn" title="Delete" onclick="deleteSession(7)"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="3 6 5 6 21 6"></polyline><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path></svg></button>
                            </div>
                        </div>
                    </div>

                    <!-- BOTTOM ACTIONS -->
                    <div class="sp-plan-footer">
                        <button type="button" class="sp-add-session-btn" onclick="openAddSessionModal()">
                            <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2.5"><line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line></svg>
                            <span>Add a study session</span>
                        </button>
                        <button type="button" class="sp-circle-arrow-btn" title="Next Day Plan" onclick="showToast('Viewing tomorrow\'s scheduled plan')">
                            <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2.2"><line x1="5" y1="12" x2="19" y2="12"></line><polyline points="12 5 19 12 12 19"></polyline></svg>
                        </button>
                    </div>
                </div>

                <!-- RIGHT COLUMN: STUDY OVERVIEW & SUBJECT PROGRESS -->
                <div class="sp-right-col">

                    <!-- 1. Study Overview Donut -->
                    <div class="sp-card">
                        <div class="sp-card-header">
                            <div class="sp-card-title">
                                <div class="sp-card-title-icon" style="color:#60a5fa;">
                                    <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path><path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path></svg>
                                </div>
                                <span>Study Overview</span>
                            </div>
                            <select class="sp-icon-btn" style="width: auto; padding: 4px 10px; font-size: 0.76rem; background: #090e24;" onchange="showToast('Showing overview for ' + this.value)">
                                <option value="This Week" selected>This Week &nbsp;&#9662;</option>
                                <option value="This Month">This Month</option>
                                <option value="All Time">All Time</option>
                            </select>
                        </div>

                        <div class="sp-donut-wrapper">
                            <!-- SVG Donut Chart -->
                            <div class="sp-donut-chart">
                                <svg class="sp-donut-svg" viewBox="0 0 36 36">
                                    <!-- Background ring -->
                                    <path fill="none" stroke="#131b38" stroke-width="4.2" d="M18 2.0845 a 15.9155 15.9155 0 0 1 0 31.831 a 15.9155 15.9155 0 0 1 0 -31.831"/>
                                    <!-- Segment 1: Data Structures 33% (#3b82f6) -->
                                    <path fill="none" stroke="#3b82f6" stroke-width="4.5" stroke-dasharray="33, 100" stroke-dashoffset="0" d="M18 2.0845 a 15.9155 15.9155 0 0 1 0 31.831 a 15.9155 15.9155 0 0 1 0 -31.831"/>
                                    <!-- Segment 2: DBMS 22% (#06b6d4) -->
                                    <path fill="none" stroke="#06b6d4" stroke-width="4.5" stroke-dasharray="22, 100" stroke-dashoffset="-33" d="M18 2.0845 a 15.9155 15.9155 0 0 1 0 31.831 a 15.9155 15.9155 0 0 1 0 -31.831"/>
                                    <!-- Segment 3: Java 17% (#f43f5e) -->
                                    <path fill="none" stroke="#f43f5e" stroke-width="4.5" stroke-dasharray="17, 100" stroke-dashoffset="-55" d="M18 2.0845 a 15.9155 15.9155 0 0 1 0 31.831 a 15.9155 15.9155 0 0 1 0 -31.831"/>
                                    <!-- Segment 4: Mathematics 11% (#10b981) -->
                                    <path fill="none" stroke="#10b981" stroke-width="4.5" stroke-dasharray="11, 100" stroke-dashoffset="-72" d="M18 2.0845 a 15.9155 15.9155 0 0 1 0 31.831 a 15.9155 15.9155 0 0 1 0 -31.831"/>
                                    <!-- Segment 5: IoT 11% (#f59e0b) -->
                                    <path fill="none" stroke="#f59e0b" stroke-width="4.5" stroke-dasharray="11, 100" stroke-dashoffset="-83" d="M18 2.0845 a 15.9155 15.9155 0 0 1 0 31.831 a 15.9155 15.9155 0 0 1 0 -31.831"/>
                                    <!-- Segment 6: Others 6% (#a855f7) -->
                                    <path fill="none" stroke="#a855f7" stroke-width="4.5" stroke-dasharray="6, 100" stroke-dashoffset="-94" d="M18 2.0845 a 15.9155 15.9155 0 0 1 0 31.831 a 15.9155 15.9155 0 0 1 0 -31.831"/>
                                </svg>
                                <div class="sp-donut-center">
                                    <span class="sp-donut-val">18h</span>
                                    <span class="sp-donut-sub">Total</span>
                                </div>
                            </div>

                            <!-- Legend -->
                            <div class="sp-legend-list">
                                <div class="sp-legend-item">
                                    <div class="sp-legend-left"><div class="sp-legend-dot" style="background:#3b82f6;"></div><span>Data Structures</span></div>
                                    <span class="sp-legend-stat">6h (33%)</span>
                                </div>
                                <div class="sp-legend-item">
                                    <div class="sp-legend-left"><div class="sp-legend-dot" style="background:#06b6d4;"></div><span>DBMS</span></div>
                                    <span class="sp-legend-stat">4h (22%)</span>
                                </div>
                                <div class="sp-legend-item">
                                    <div class="sp-legend-left"><div class="sp-legend-dot" style="background:#f43f5e;"></div><span>Java</span></div>
                                    <span class="sp-legend-stat">3h (17%)</span>
                                </div>
                                <div class="sp-legend-item">
                                    <div class="sp-legend-left"><div class="sp-legend-dot" style="background:#10b981;"></div><span>Mathematics</span></div>
                                    <span class="sp-legend-stat">2h (11%)</span>
                                </div>
                                <div class="sp-legend-item">
                                    <div class="sp-legend-left"><div class="sp-legend-dot" style="background:#f59e0b;"></div><span>IoT</span></div>
                                    <span class="sp-legend-stat">2h (11%)</span>
                                </div>
                                <div class="sp-legend-item">
                                    <div class="sp-legend-left"><div class="sp-legend-dot" style="background:#a855f7;"></div><span>Others</span></div>
                                    <span class="sp-legend-stat">1h (6%)</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- 2. Subject Progress -->
                    <div class="sp-card">
                        <div class="sp-card-header">
                            <div class="sp-card-title">
                                <div class="sp-card-title-icon" style="color:#a855f7;">
                                    <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2.2"><path d="M21.21 15.89A10 10 0 1 1 8 2.83"></path><path d="M22 12A10 10 0 0 0 12 2v10z"></path></svg>
                                </div>
                                <span>Subject Progress</span>
                            </div>
                            <a href="${pageContext.request.contextPath}/progress" style="font-size:0.78rem; font-weight:600; color:#818cf8;">View All &rarr;</a>
                        </div>

                        <div class="sp-subj-list">
                            <!-- Data Structures -->
                            <div class="sp-subj-row">
                                <div class="sp-subj-icon-box" style="background:#312e81;"><svg viewBox="0 0 24 24" fill="none" stroke="#818cf8" stroke-width="2"><polyline points="16 18 22 12 16 6"></polyline><polyline points="8 6 2 12 8 18"></polyline></svg></div>
                                <span class="sp-subj-name">Data Structures</span>
                                <div class="sp-progress-track"><div class="sp-progress-fill" style="width:75%; background:#6366f1;"></div></div>
                                <span class="sp-subj-pct">75%</span>
                            </div>

                            <!-- DBMS -->
                            <div class="sp-subj-row">
                                <div class="sp-subj-icon-box" style="background:#0c4a6e;"><svg viewBox="0 0 24 24" fill="none" stroke="#38bdf8" stroke-width="2"><ellipse cx="12" cy="5" rx="9" ry="3"></ellipse><path d="M21 12c0 1.66-4 3-9 3s-9-1.34-9-3"></path><path d="M3 5v14c0 1.66 4 3 9 3s9-1.34 9-3V5"></path></svg></div>
                                <span class="sp-subj-name">DBMS</span>
                                <div class="sp-progress-track"><div class="sp-progress-fill" style="width:60%; background:#0284c7;"></div></div>
                                <span class="sp-subj-pct">60%</span>
                            </div>

                            <!-- Java -->
                            <div class="sp-subj-row">
                                <div class="sp-subj-icon-box" style="background:#4c0519;"><svg viewBox="0 0 24 24" fill="none" stroke="#fb7185" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path></svg></div>
                                <span class="sp-subj-name">Java</span>
                                <div class="sp-progress-track"><div class="sp-progress-fill" style="width:45%; background:#f43f5e;"></div></div>
                                <span class="sp-subj-pct">45%</span>
                            </div>

                            <!-- Mathematics -->
                            <div class="sp-subj-row">
                                <div class="sp-subj-icon-box" style="background:#064e3b;"><svg viewBox="0 0 24 24" fill="none" stroke="#34d399" stroke-width="2"><line x1="4" y1="12" x2="20" y2="12"></line><line x1="12" y1="4" x2="12" y2="20"></line></svg></div>
                                <span class="sp-subj-name">Mathematics</span>
                                <div class="sp-progress-track"><div class="sp-progress-fill" style="width:40%; background:#10b981;"></div></div>
                                <span class="sp-subj-pct">40%</span>
                            </div>

                            <!-- IoT -->
                            <div class="sp-subj-row">
                                <div class="sp-subj-icon-box" style="background:#451a03;"><svg viewBox="0 0 24 24" fill="none" stroke="#fbbf24" stroke-width="2"><circle cx="12" cy="12" r="4"></circle><line x1="1.05" y1="12" x2="7" y2="12"></line><line x1="17.01" y1="12" x2="22.96" y2="12"></line></svg></div>
                                <span class="sp-subj-name">IoT</span>
                                <div class="sp-progress-track"><div class="sp-progress-fill" style="width:30%; background:#f59e0b;"></div></div>
                                <span class="sp-subj-pct">30%</span>
                            </div>

                            <!-- OOPs -->
                            <div class="sp-subj-row">
                                <div class="sp-subj-icon-box" style="background:#3b0764;"><svg viewBox="0 0 24 24" fill="none" stroke="#c084fc" stroke-width="2"><rect x="3" y="3" width="18" height="18" rx="2" ry="2"></rect><line x1="3" y1="9" x2="21" y2="9"></line><line x1="9" y1="21" x2="9" y2="9"></line></svg></div>
                                <span class="sp-subj-name">OOPs</span>
                                <div class="sp-progress-track"><div class="sp-progress-fill" style="width:25%; background:#8b5cf6;"></div></div>
                                <span class="sp-subj-pct">25%</span>
                            </div>
                        </div>
                    </div>

                </div>

            </div>

            <!-- BOTTOM THREE-COLUMN SECTION -->
            <div class="sp-bottom-grid">

                <!-- 1. Study Goals -->
                <div class="sp-card">
                    <div class="sp-card-header">
                        <div class="sp-card-title">
                            <div class="sp-card-title-icon" style="color:#a78bfa;">
                                <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><circle cx="12" cy="12" r="6"></circle><circle cx="12" cy="12" r="2"></circle></svg>
                            </div>
                            <span>Study Goals</span>
                        </div>
                        <a href="${pageContext.request.contextPath}/goals.jsp" style="font-size:0.78rem; font-weight:600; color:#818cf8;">View All &rarr;</a>
                    </div>

                    <div class="sp-goal-list">
                        <!-- Goal 1 -->
                        <div class="sp-goal-item">
                            <div class="sp-checkbox" onclick="toggleGoal(1, this)"><svg viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"></polyline></svg></div>
                            <span class="sp-goal-title">Complete DBMS Unit 3</span>
                            <div class="sp-progress-track"><div class="sp-progress-fill" style="width:60%; background:#8b5cf6;"></div></div>
                            <span class="sp-subj-pct">60%</span>
                        </div>

                        <!-- Goal 2 -->
                        <div class="sp-goal-item">
                            <div class="sp-checkbox" onclick="toggleGoal(2, this)"><svg viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"></polyline></svg></div>
                            <span class="sp-goal-title">Revise Java for CAT 1</span>
                            <div class="sp-progress-track"><div class="sp-progress-fill" style="width:40%; background:#3b82f6;"></div></div>
                            <span class="sp-subj-pct">40%</span>
                        </div>

                        <!-- Goal 3 -->
                        <div class="sp-goal-item">
                            <div class="sp-checkbox" onclick="toggleGoal(3, this)"><svg viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"></polyline></svg></div>
                            <span class="sp-goal-title">Finish IoT Notes</span>
                            <div class="sp-progress-track"><div class="sp-progress-fill" style="width:80%; background:#10b981;"></div></div>
                            <span class="sp-subj-pct">80%</span>
                        </div>

                        <!-- Goal 4 -->
                        <div class="sp-goal-item">
                            <div class="sp-checkbox" onclick="toggleGoal(4, this)"><svg viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"></polyline></svg></div>
                            <span class="sp-goal-title">Solve 50 DSA Problems</span>
                            <div class="sp-progress-track"><div class="sp-progress-fill" style="width:30%; background:#6366f1;"></div></div>
                            <span class="sp-subj-pct">30%</span>
                        </div>
                    </div>
                </div>

                <!-- 2. Recommended for You -->
                <div class="sp-card">
                    <div class="sp-card-header">
                        <div>
                            <div class="sp-card-title">
                                <div class="sp-card-title-icon" style="color:#fbbf24;">
                                    <svg viewBox="0 0 24 24" width="16" height="16" fill="currentColor"><path d="M9 21h6v-1H9v1zm3-19C8.14 2 5 5.14 5 9c0 2.38 1.19 4.47 3 5.74V17c0 .55.45 1 1 1h6c.55 0 1-.45 1-1v-2.26c1.81-1.27 3-3.36 3-5.74 0-3.86-3.14-7-7-7z"></path></svg>
                                </div>
                                <span>Recommended for You</span>
                            </div>
                            <div style="font-size:0.75rem; color:var(--text-muted); margin-top:3px; margin-left:44px;">Based on your subjects and schedule</div>
                        </div>
                    </div>

                    <div class="sp-rec-list">
                        <!-- Rec 1 -->
                        <div class="sp-rec-item">
                            <div class="sp-rec-left">
                                <div class="sp-rec-icon-box" style="background:#1e3a8a; color:#60a5fa;">
                                    <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline></svg>
                                </div>
                                <div class="sp-rec-info">
                                    <div class="sp-rec-title">Revise Previous Year Questions</div>
                                    <div class="sp-rec-sub">DBMS &bull; 30 mins</div>
                                </div>
                            </div>
                            <button type="button" class="sp-rec-btn" onclick="startRecommendation(1, 'Revise Previous Year Questions', 'DBMS', 30)">Start</button>
                        </div>

                        <!-- Rec 2 -->
                        <div class="sp-rec-item">
                            <div class="sp-rec-left">
                                <div class="sp-rec-icon-box" style="background:#831843; color:#f43f5e;">
                                    <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2"><line x1="18" y1="20" x2="18" y2="10"></line><line x1="12" y1="20" x2="12" y2="4"></line><line x1="6" y1="20" x2="6" y2="14"></line></svg>
                                </div>
                                <div class="sp-rec-info">
                                    <div class="sp-rec-title">Practice Graph Problems</div>
                                    <div class="sp-rec-sub">DSA &bull; 45 mins</div>
                                </div>
                            </div>
                            <button type="button" class="sp-rec-btn" onclick="startRecommendation(2, 'Practice Graph Problems', 'DSA', 45)">Start</button>
                        </div>

                        <!-- Rec 3 -->
                        <div class="sp-rec-item">
                            <div class="sp-rec-left">
                                <div class="sp-rec-icon-box" style="background:#78350f; color:#f59e0b;">
                                    <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path><path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path></svg>
                                </div>
                                <div class="sp-rec-info">
                                    <div class="sp-rec-title">Read IoT Summary Notes</div>
                                    <div class="sp-rec-sub">IoT &bull; 20 mins</div>
                                </div>
                            </div>
                            <button type="button" class="sp-rec-btn" onclick="startRecommendation(3, 'Read IoT Summary Notes', 'IoT', 20)">Start</button>
                        </div>
                    </div>
                </div>

                <!-- 3. Study Streak -->
                <div class="sp-card">
                    <div class="sp-streak-header">
                        <div class="sp-card-title">
                            <div class="sp-card-title-icon" style="color:#f97316;">
                                <svg viewBox="0 0 24 24" width="16" height="16" fill="currentColor"><path d="M12 23c-4.97 0-9-4.03-9-9 0-4.14 3.03-7.58 7.02-8.68.32-.09.64.12.64.45v1.27c0 .24-.16.45-.39.51-2.27.56-3.95 2.61-3.95 5.06 0 2.89 2.34 5.23 5.23 5.23 2.12 0 3.93-1.26 4.75-3.07.1-.22.34-.34.58-.29l1.19.26c.32.07.49.39.38.69-1.22 3.32-4.4 5.67-8.03 5.67zM17.66 11.2c-.2-.04-.39-.14-.52-.3-1.07-1.32-1.72-2.99-1.72-4.8 0-1.85.83-3.5 2.15-4.63.22-.19.54-.15.71.09.91 1.25 1.45 2.78 1.45 4.44 0 2.15-.92 4.09-2.39 5.43-.17.15-.43.19-.68.17z"/></svg>
                            </div>
                            <span>Study Streak</span>
                        </div>
                        <div class="sp-streak-badge" id="streakBadge">5 days 🔥</div>
                    </div>

                    <!-- 7-Day Checklist -->
                    <div class="sp-week-row">
                        <div class="sp-day-col">
                            <div class="sp-day-circle checked"><svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="#fff" stroke-width="3"><polyline points="20 6 9 17 4 12"></polyline></svg></div>
                            <span class="sp-day-label">Mon</span>
                        </div>
                        <div class="sp-day-col">
                            <div class="sp-day-circle checked"><svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="#fff" stroke-width="3"><polyline points="20 6 9 17 4 12"></polyline></svg></div>
                            <span class="sp-day-label">Tue</span>
                        </div>
                        <div class="sp-day-col">
                            <div class="sp-day-circle checked"><svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="#fff" stroke-width="3"><polyline points="20 6 9 17 4 12"></polyline></svg></div>
                            <span class="sp-day-label">Wed</span>
                        </div>
                        <div class="sp-day-col">
                            <div class="sp-day-circle checked"><svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="#fff" stroke-width="3"><polyline points="20 6 9 17 4 12"></polyline></svg></div>
                            <span class="sp-day-label">Thu</span>
                        </div>
                        <div class="sp-day-col">
                            <div class="sp-day-circle checked"><svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="#fff" stroke-width="3"><polyline points="20 6 9 17 4 12"></polyline></svg></div>
                            <span class="sp-day-label">Fri</span>
                        </div>
                        <div class="sp-day-col">
                            <div class="sp-day-circle unchecked"></div>
                            <span class="sp-day-label">Sat</span>
                        </div>
                        <div class="sp-day-col">
                            <div class="sp-day-circle unchecked"></div>
                            <span class="sp-day-label">Sun</span>
                        </div>
                    </div>

                    <!-- Footer message -->
                    <div class="sp-streak-footer">
                        <span>Keep going! Consistency builds success.</span>
                        <div class="sp-sparkline">
                            <div class="sp-spark-bar" style="height: 10px; background: #8b5cf6;"></div>
                            <div class="sp-spark-bar" style="height: 15px; background: #8b5cf6;"></div>
                            <div class="sp-spark-bar" style="height: 22px; background: #8b5cf6;"></div>
                        </div>
                    </div>
                </div>

            </div>

        </div>
    </main>

</div>

<!-- ===== ADD / EDIT SESSION MODAL ===== -->
<div class="sp-modal-overlay" id="sessionModal">
    <div class="sp-modal">
        <div class="sp-modal-header">
            <h3 id="modalSessionTitle">Create Study Session</h3>
            <button type="button" class="sp-modal-close" onclick="closeSessionModal()">&times;</button>
        </div>

        <form id="sessionForm" onsubmit="handleSaveSession(event)">
            <input type="hidden" id="modalSessionId" value="">

            <div class="sp-form-group">
                <label>Time Range</label>
                <input type="text" class="sp-form-control" id="modalTimeRange" required placeholder="e.g. 05:15 PM – 06:15 PM">
            </div>

            <div class="sp-form-group">
                <label>Subject</label>
                <input type="text" class="sp-form-control" id="modalSubject" required placeholder="e.g. Data Structures, DBMS, Java, etc.">
            </div>

            <div class="sp-form-group">
                <label>Topic</label>
                <input type="text" class="sp-form-control" id="modalTopic" required placeholder="e.g. Binary Search Trees">
            </div>

            <div style="display: flex; gap: 12px;">
                <div class="sp-form-group" style="flex:1;">
                    <label>Type</label>
                    <select class="sp-form-control" id="modalType">
                        <option value="Lecture">Lecture</option>
                        <option value="Notes">Notes</option>
                        <option value="Practice" selected>Practice</option>
                        <option value="Revision">Revision</option>
                        <option value="Project">Project</option>
                    </select>
                </div>

                <div class="sp-form-group" style="flex:1;">
                    <label>Duration</label>
                    <select class="sp-form-control" id="modalDuration">
                        <option value="30m">30 mins</option>
                        <option value="45m">45 mins</option>
                        <option value="1h" selected>1 hour</option>
                        <option value="1h 30m">1.5 hours</option>
                        <option value="2h">2 hours</option>
                    </select>
                </div>
            </div>

            <button type="submit" class="sp-modal-submit" id="modalSubmitBtn">Save Session</button>
        </form>
    </div>
</div>

<!-- ===== LIVE STUDY TIMER MODAL ===== -->
<div class="sp-modal-overlay" id="timerModal">
    <div class="sp-modal" style="width: 420px;">
        <div class="sp-modal-header">
            <h3>Live Study Timer</h3>
            <button type="button" class="sp-modal-close" onclick="closeTimerModal()">&times;</button>
        </div>

        <div class="sp-timer-box">
            <div class="sp-timer-title" id="timerSubjectDisplay">Data Structures</div>
            <div class="sp-timer-sub" id="timerTopicDisplay">Trees - Introduction</div>

            <div class="sp-timer-clock-ring">
                <svg viewBox="0 0 100 100">
                    <circle cx="50" cy="50" r="44" stroke="rgba(255,255,255,0.08)" stroke-width="7" fill="none"/>
                    <circle id="timerProgressCircle" cx="50" cy="50" r="44" stroke="#10b981" stroke-width="7" stroke-dasharray="276.46" stroke-dashoffset="0" stroke-linecap="round" fill="none"/>
                </svg>
                <div class="sp-timer-clock-text" id="timerClockDigits">25:00</div>
            </div>

            <div class="sp-timer-ctrls">
                <button type="button" class="sp-timer-btn play" id="timerPlayBtn" onclick="toggleTimer()">▶ Start</button>
                <button type="button" class="sp-timer-btn reset" onclick="resetTimer()">Reset</button>
                <button type="button" class="sp-timer-btn complete" onclick="completeTimerEarly()">✓ Complete</button>
            </div>
        </div>
    </div>
</div>

<!-- ===== FLOATING TOAST NOTIFICATION ===== -->
<div class="sp-toast" id="spToast">
    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="#a78bfa" stroke-width="2.2"><polyline points="20 6 9 17 4 12"></polyline></svg>
    <span id="spToastMsg">Action completed successfully</span>
</div>

<!-- ===== JAVASCRIPT & AJAX INTEGRATION ===== -->
<script>
    var currentTimeframe = 'Daily';
    var timerInterval = null;
    var timerRemainingSeconds = 25 * 60;
    var timerTotalSeconds = 25 * 60;
    var isTimerRunning = false;
    var currentTimerSessionSubject = '';

    function showToast(msg) {
        var t = document.getElementById('spToast');
        document.getElementById('spToastMsg').textContent = msg;
        t.classList.add('show');
        setTimeout(function() { t.classList.remove('show'); }, 3000);
    }

    function switchTimeframe(btn, tf) {
        currentTimeframe = tf;
        document.querySelectorAll('.sp-toggle-btn').forEach(function(b) { b.classList.remove('active'); });
        btn.classList.add('active');
        fetchSessions();
        showToast('Viewing ' + tf + ' Study Schedule');
    }

    function handleSearch(val) {
        fetchSessions(val);
    }

    function fetchSessions(query) {
        var params = new URLSearchParams();
        params.append('action', 'filter');
        params.append('timeframe', currentTimeframe);
        if (query) params.append('search', query);

        fetch('${pageContext.request.contextPath}/study-planner', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: params.toString()
        })
        .then(function(res) { return res.json(); })
        .then(function(data) {
            if (data.success) {
                renderSessions(data.sessions);
                updateKpiStats(data);
            }
        })
        .catch(function(err) { console.error(err); });
    }

    function renderSessions(list) {
        var container = document.getElementById('sessionListContainer');
        container.innerHTML = '';

        if (!list || list.length === 0) {
            container.innerHTML = '<div style="text-align:center; padding:32px; color:#64748b;">No study sessions found for this timeframe.</div>';
            return;
        }

        list.forEach(function(s) {
            var row = document.createElement('div');
            row.className = 'sp-session-row' + (s.completed ? ' completed' : '');
            row.id = 'sessionRow-' + s.id;

            var checkClass = s.completed ? 'sp-checkbox checked' : 'sp-checkbox';

            row.innerHTML =
                '<div class="' + checkClass + '" onclick="toggleComplete(' + s.id + ', this)"><svg viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"></polyline></svg></div>' +
                '<div class="sp-time-pill"><div class="sp-time-accent" style="background:' + escapeHtml(s.accentColor) + ';"></div>' + escapeHtml(s.timeRange) + '</div>' +
                '<span class="sp-session-subj">' + escapeHtml(s.subject) + '</span>' +
                '<span class="sp-session-topic">' + escapeHtml(s.topic) + '</span>' +
                '<span class="sp-pill" style="background:' + escapeHtml(s.typeBg) + '; color:' + escapeHtml(s.typeColor) + ';">' + escapeHtml(s.type) + '</span>' +
                '<span class="sp-duration">' + escapeHtml(s.duration) + '</span>' +
                '<div class="sp-actions-box">' +
                    '<button type="button" class="sp-play-btn" title="Start Timer" onclick="startTimer(\'' + escapeJs(s.subject) + '\', \'' + escapeJs(s.topic) + '\', ' + s.durationMinutes + ')"><svg viewBox="0 0 24 24"><polygon points="5 3 19 12 5 21 5 3"></polygon></svg></button>' +
                    '<button type="button" class="sp-edit-btn" title="Edit" onclick="openEditModal(' + s.id + ', \'' + escapeJs(s.timeRange) + '\', \'' + escapeJs(s.subject) + '\', \'' + escapeJs(s.topic) + '\', \'' + escapeJs(s.type) + '\', \'' + escapeJs(s.duration) + '\')"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 20h9"></path><path d="M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4L16.5 3.5z"></path></svg></button>' +
                    '<button type="button" class="sp-del-btn" title="Delete" onclick="deleteSession(' + s.id + ')"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="3 6 5 6 21 6"></polyline><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path></svg></button>' +
                '</div>';

            container.appendChild(row);
        });
    }

    function updateKpiStats(data) {
        if (data.subjectsPlanned !== undefined) document.getElementById('kpiSubjects').textContent = data.subjectsPlanned;
        if (data.tasksCompleted !== undefined) document.getElementById('kpiTasks').textContent = data.tasksCompleted;
        if (data.plannedStudyTime !== undefined) document.getElementById('kpiPlanned').textContent = data.plannedStudyTime;
        if (data.actualStudyTime !== undefined) document.getElementById('kpiActual').textContent = data.actualStudyTime;
    }

    function toggleComplete(id, el) {
        fetch('${pageContext.request.contextPath}/study-planner', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'action=toggleComplete&id=' + encodeURIComponent(id)
        })
        .then(function(res) { return res.json(); })
        .then(function(data) {
            if (data.success) {
                var row = document.getElementById('sessionRow-' + id);
                if (data.completed) {
                    el.classList.add('checked');
                    if (row) row.classList.add('completed');
                    showToast('Session marked as completed! (+tasks count)');
                } else {
                    el.classList.remove('checked');
                    if (row) row.classList.remove('completed');
                    showToast('Session uncompleted');
                }
                updateKpiStats(data);
            }
        });
    }

    function markAllComplete() {
        fetch('${pageContext.request.contextPath}/study-planner', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'action=markAllComplete'
        })
        .then(function(res) { return res.json(); })
        .then(function(data) {
            if (data.success) {
                document.querySelectorAll('.sp-session-row').forEach(function(row) {
                    row.classList.add('completed');
                    var cb = row.querySelector('.sp-checkbox');
                    if (cb) cb.classList.add('checked');
                });
                updateKpiStats(data);
                showToast('All study sessions marked as complete!');
            }
        });
    }

    function deleteSession(id) {
        if (!confirm('Are you sure you want to delete this study session?')) return;
        fetch('${pageContext.request.contextPath}/study-planner', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'action=delete&id=' + encodeURIComponent(id)
        })
        .then(function(res) { return res.json(); })
        .then(function(data) {
            if (data.success) {
                var row = document.getElementById('sessionRow-' + id);
                if (row) row.remove();
                updateKpiStats(data);
                showToast('Study session deleted');
            }
        });
    }

    function toggleGoal(id, el) {
        fetch('${pageContext.request.contextPath}/study-planner', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'action=toggleGoal&id=' + encodeURIComponent(id)
        })
        .then(function(res) { return res.json(); })
        .then(function(data) {
            el.classList.toggle('checked');
            showToast('Study goal progress updated');
        });
    }

    function startRecommendation(id, title, subject, mins) {
        fetch('${pageContext.request.contextPath}/study-planner', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'action=startRecommendation&id=' + encodeURIComponent(id)
        })
        .then(function(res) { return res.json(); })
        .then(function(data) {
            if (data.success) {
                fetchSessions();
                startTimer(subject, title, mins);
                showToast('Added recommended session to schedule & launched timer!');
            }
        });
    }

    /* ===== MODAL LOGIC ===== */
    function openAddSessionModal() {
        document.getElementById('modalSessionTitle').textContent = 'Create Study Session';
        document.getElementById('modalSessionId').value = '';
        document.getElementById('modalTimeRange').value = '05:15 PM – 06:15 PM';
        document.getElementById('modalSubject').value = '';
        document.getElementById('modalTopic').value = '';
        document.getElementById('modalType').value = 'Practice';
        document.getElementById('modalDuration').value = '1h';
        document.getElementById('sessionModal').classList.add('open');
    }

    function openEditModal(id, timeRange, subject, topic, type, duration) {
        document.getElementById('modalSessionTitle').textContent = 'Edit Study Session';
        document.getElementById('modalSessionId').value = id;
        document.getElementById('modalTimeRange').value = timeRange;
        document.getElementById('modalSubject').value = subject;
        document.getElementById('modalTopic').value = topic;
        document.getElementById('modalType').value = type;
        document.getElementById('modalDuration').value = duration;
        document.getElementById('sessionModal').classList.add('open');
    }

    function closeSessionModal() {
        document.getElementById('sessionModal').classList.remove('open');
    }

    function handleSaveSession(e) {
        e.preventDefault();
        var id = document.getElementById('modalSessionId').value;
        var action = id ? 'edit' : 'add';

        var params = new URLSearchParams();
        params.append('action', action);
        if (id) params.append('id', id);
        params.append('timeRange', document.getElementById('modalTimeRange').value);
        params.append('subject', document.getElementById('modalSubject').value);
        params.append('topic', document.getElementById('modalTopic').value);
        params.append('type', document.getElementById('modalType').value);
        params.append('duration', document.getElementById('modalDuration').value);

        fetch('${pageContext.request.contextPath}/study-planner', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: params.toString()
        })
        .then(function(res) { return res.json(); })
        .then(function(data) {
            if (data.success) {
                closeSessionModal();
                fetchSessions();
                showToast(data.message || 'Study session saved successfully!');
            }
        });
    }

    /* ===== LIVE TIMER LOGIC ===== */
    function startTimer(subject, topic, durationMins) {
        currentTimerSessionSubject = subject;
        document.getElementById('timerSubjectDisplay').textContent = subject;
        document.getElementById('timerTopicDisplay').textContent = topic;

        var mins = durationMins || 25;
        timerTotalSeconds = mins * 60;
        timerRemainingSeconds = timerTotalSeconds;

        updateTimerDisplay();
        document.getElementById('timerModal').classList.add('open');

        // Autoplay
        isTimerRunning = true;
        document.getElementById('timerPlayBtn').textContent = '⏸ Pause';
        document.getElementById('timerPlayBtn').className = 'sp-timer-btn pause';

        clearInterval(timerInterval);
        timerInterval = setInterval(runTimerTick, 1000);
    }

    function closeTimerModal() {
        clearInterval(timerInterval);
        isTimerRunning = false;
        document.getElementById('timerModal').classList.remove('open');
    }

    function toggleTimer() {
        var btn = document.getElementById('timerPlayBtn');
        if (isTimerRunning) {
            clearInterval(timerInterval);
            isTimerRunning = false;
            btn.textContent = '▶ Resume';
            btn.className = 'sp-timer-btn play';
        } else {
            isTimerRunning = true;
            btn.textContent = '⏸ Pause';
            btn.className = 'sp-timer-btn pause';
            timerInterval = setInterval(runTimerTick, 1000);
        }
    }

    function runTimerTick() {
        if (timerRemainingSeconds > 0) {
            timerRemainingSeconds--;
            updateTimerDisplay();
        } else {
            clearInterval(timerInterval);
            isTimerRunning = false;
            showToast('🎉 Study Session Complete! Great focus!');
            logTimerCompleted();
        }
    }

    function resetTimer() {
        clearInterval(timerInterval);
        isTimerRunning = false;
        timerRemainingSeconds = timerTotalSeconds;
        var btn = document.getElementById('timerPlayBtn');
        btn.textContent = '▶ Start';
        btn.className = 'sp-timer-btn play';
        updateTimerDisplay();
    }

    function completeTimerEarly() {
        clearInterval(timerInterval);
        isTimerRunning = false;
        logTimerCompleted();
        closeTimerModal();
    }

    function updateTimerDisplay() {
        var m = Math.floor(timerRemainingSeconds / 60);
        var s = timerRemainingSeconds % 60;
        document.getElementById('timerClockDigits').textContent =
            (m < 10 ? '0' + m : m) + ':' + (s < 10 ? '0' + s : s);

        // SVG circle offset calculation (circumference = 2 * PI * 44 ≈ 276.46)
        var circle = document.getElementById('timerProgressCircle');
        var progressRatio = timerRemainingSeconds / timerTotalSeconds;
        var offset = 276.46 * (1 - progressRatio);
        circle.style.strokeDashoffset = offset;
    }

    function logTimerCompleted() {
        var elapsedMins = Math.round((timerTotalSeconds - timerRemainingSeconds) / 60);
        if (elapsedMins <= 0) elapsedMins = Math.round(timerTotalSeconds / 60);

        fetch('${pageContext.request.contextPath}/study-planner', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'action=logTimerCompleted&minutes=' + elapsedMins
        })
        .then(function(res) { return res.json(); })
        .then(function(data) {
            if (data.success) {
                updateKpiStats(data);
                showToast('Logged ' + elapsedMins + ' mins to Actual Study Time!');
            }
        });
    }

    function escapeHtml(str) {
        if (!str) return '';
        return String(str).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
    }

    function escapeJs(str) {
        if (!str) return '';
        return String(str).replace(/\\/g, '\\\\').replace(/'/g, "\\'").replace(/"/g, '\\"');
    }
</script>

</body>
</html>
