<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Progress &mdash; SlotWise</title>
    <meta name="description" content="Track your learning journey, analyze your productivity, and achieve your academic goals with SlotWise Progress.">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        /* ============================================================
           SLOTWISE PROGRESS — PIXEL-PERFECT EXACT REPLICA
           ============================================================ */
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
        .pw-avatar img {
            width: 100%;
            height: 100%;
            object-fit: cover;
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
        .pw-chevron {
            color: var(--pw-text-dim);
            width: 14px;
            height: 14px;
        }

        /* ------------------ BODY CONTAINER ------------------ */
        .pw-container {
            padding: 28px 32px 50px;
            overflow-y: auto;
        }

        .pw-header {
            margin-bottom: 24px;
        }
        .pw-header h1 {
            font-size: 1.85rem;
            font-weight: 800;
            color: #ffffff;
            margin: 0 0 6px 0;
            letter-spacing: -0.02em;
        }
        .pw-header p {
            color: var(--pw-text-muted);
            font-size: 0.88rem;
            margin: 0;
        }

        /* ------------------ ROW 1: 4 KPI CARDS ------------------ */
        .pw-kpi-row {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 16px;
            margin-bottom: 20px;
        }

        .pw-kpi-card {
            background-color: var(--pw-bg-card);
            border: 1px solid var(--pw-border);
            border-radius: 14px;
            padding: 18px 20px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            position: relative;
            transition: transform 0.2s, border-color 0.2s;
        }
        .pw-kpi-card:hover {
            border-color: rgba(121, 82, 245, 0.35);
        }

        .pw-kpi-left {
            display: flex;
            align-items: center;
            gap: 14px;
        }

        .pw-kpi-icon-box {
            width: 44px;
            height: 44px;
            border-radius: 11px;
            background-color: rgba(121, 82, 245, 0.12);
            color: #a855f7;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .pw-kpi-icon-box.clock {
            color: #818cf8;
            background-color: rgba(99, 102, 241, 0.12);
        }
        .pw-kpi-icon-box.target {
            color: #a855f7;
            background-color: rgba(168, 85, 247, 0.12);
        }
        .pw-kpi-icon-box.flame {
            color: #f97316;
            background-color: rgba(249, 115, 22, 0.12);
        }

        .pw-kpi-data {
            display: flex;
            flex-direction: column;
        }
        .pw-kpi-title {
            font-size: 0.76rem;
            color: var(--pw-text-muted);
            font-weight: 500;
            margin-bottom: 3px;
        }
        .pw-kpi-val {
            font-size: 1.65rem;
            font-weight: 800;
            color: #ffffff;
            line-height: 1.1;
        }
        .pw-kpi-val span {
            font-size: 0.95rem;
            font-weight: 500;
            color: var(--pw-text-muted);
            margin-left: 2px;
        }
        .pw-kpi-sub {
            font-size: 0.74rem;
            color: var(--pw-text-dim);
            margin-top: 3px;
        }

        /* Circular Gauge */
        .pw-gauge {
            width: 52px;
            height: 52px;
            position: relative;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .pw-gauge svg {
            width: 52px;
            height: 52px;
            transform: rotate(-90deg);
        }
        .pw-gauge-bg {
            fill: none;
            stroke: rgba(255, 255, 255, 0.06);
            stroke-width: 4.5;
        }
        .pw-gauge-fill {
            fill: none;
            stroke: #6366f1;
            stroke-width: 4.5;
            stroke-linecap: round;
            stroke-dasharray: 125.6;
            transition: stroke-dashoffset 0.8s ease;
        }
        .pw-gauge-text {
            position: absolute;
            font-size: 0.7rem;
            font-weight: 700;
            color: #ffffff;
        }

        .pw-trend-badge {
            display: flex;
            flex-direction: column;
            align-items: flex-end;
            gap: 2px;
        }
        .pw-trend-val {
            display: flex;
            align-items: center;
            gap: 3px;
            color: #10b981;
            font-size: 0.8rem;
            font-weight: 700;
        }
        .pw-trend-sub {
            font-size: 0.68rem;
            color: #10b981;
            opacity: 0.85;
        }

        .pw-flame-badge {
            font-size: 1.8rem;
            filter: drop-shadow(0 0 10px rgba(249, 115, 22, 0.5));
        }

        /* ------------------ COMMON CARD ------------------ */
        .pw-card {
            background-color: var(--pw-bg-card);
            border: 1px solid var(--pw-border);
            border-radius: 14px;
            padding: 20px 22px;
            box-sizing: border-box;
        }

        .pw-card-header {
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            margin-bottom: 20px;
        }

        .pw-card-title-group {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .pw-card-header-icon {
            width: 32px;
            height: 32px;
            border-radius: 8px;
            background-color: rgba(99, 102, 241, 0.12);
            color: #818cf8;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        .pw-card-title {
            font-size: 0.95rem;
            font-weight: 700;
            color: #ffffff;
            margin: 0;
        }
        .pw-card-subtitle {
            font-size: 0.74rem;
            color: var(--pw-text-muted);
            margin-top: 2px;
        }

        .pw-dropdown-btn {
            background-color: rgba(255, 255, 255, 0.04);
            border: 1px solid var(--pw-border);
            border-radius: 8px;
            color: var(--pw-text-muted);
            font-size: 0.76rem;
            font-weight: 500;
            padding: 6px 12px;
            display: flex;
            align-items: center;
            gap: 6px;
            cursor: pointer;
            transition: all 0.2s;
        }
        .pw-dropdown-btn:hover {
            background-color: rgba(255, 255, 255, 0.08);
            color: #ffffff;
        }

        .pw-dropdown-wrapper {
            position: relative;
            display: inline-block;
        }

        .pw-dropdown-menu {
            display: none;
            position: absolute;
            right: 0;
            top: calc(100% + 6px);
            background-color: #0f1527;
            border: 1px solid rgba(121, 82, 245, 0.35);
            border-radius: 10px;
            padding: 6px;
            min-width: 145px;
            box-shadow: 0 10px 28px rgba(0, 0, 0, 0.65), 0 0 15px rgba(121, 82, 245, 0.15);
            z-index: 100;
            animation: pwDropdownFadeIn 0.18s ease-out;
        }

        .pw-dropdown-menu.open {
            display: flex;
            flex-direction: column;
            gap: 2px;
        }

        @keyframes pwDropdownFadeIn {
            from { opacity: 0; transform: translateY(-4px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .pw-dropdown-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 8px 12px;
            border-radius: 7px;
            color: var(--pw-text-muted);
            font-size: 0.78rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.15s ease;
            user-select: none;
        }

        .pw-dropdown-item:hover {
            background-color: rgba(255, 255, 255, 0.06);
            color: #ffffff;
        }

        .pw-dropdown-item.active {
            color: #a855f7;
            font-weight: 600;
            background-color: rgba(121, 82, 245, 0.12);
        }

        .pw-dropdown-item .pw-check-icon {
            width: 13px;
            height: 13px;
            stroke: currentColor;
            stroke-width: 2.5;
            fill: none;
            opacity: 0;
        }

        .pw-dropdown-item.active .pw-check-icon {
            opacity: 1;
        }

        .pw-link-btn {
            color: #a855f7;
            text-decoration: none;
            font-size: 0.78rem;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 4px;
            transition: color 0.2s;
        }
        .pw-link-btn:hover {
            color: #c084fc;
        }

        /* ------------------ ROW 2: CHARTS ------------------ */
        .pw-grid-row-2 {
            display: grid;
            grid-template-columns: 1.45fr 1fr;
            gap: 16px;
            margin-bottom: 20px;
        }

        /* Bar Chart */
        .pw-barchart-container {
            display: flex;
            gap: 12px;
            height: 190px;
            align-items: stretch;
            padding-top: 10px;
            position: relative;
        }

        .pw-barchart-yaxis {
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            color: var(--pw-text-dim);
            font-size: 0.7rem;
            padding-bottom: 24px;
            text-align: right;
            width: 20px;
            flex-shrink: 0;
        }

        .pw-barchart-grid {
            flex: 1;
            display: flex;
            flex-direction: column;
            position: relative;
        }

        .pw-gridlines {
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 24px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            pointer-events: none;
        }
        .pw-gridline {
            border-bottom: 1px dashed rgba(255, 255, 255, 0.05);
            width: 100%;
        }

        .pw-bars {
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            display: flex;
            justify-content: space-around;
            align-items: flex-end;
            padding-bottom: 24px;
            box-sizing: border-box;
        }

        .pw-bar-col {
            display: flex;
            flex-direction: column;
            align-items: center;
            width: 38px;
            height: 100%;
            justify-content: flex-end;
            position: relative;
        }

        .pw-bar-val {
            font-size: 0.68rem;
            font-weight: 600;
            color: var(--pw-text-white);
            margin-bottom: 6px;
        }

        .pw-bar-body {
            width: 28px;
            background: linear-gradient(180deg, #6366f1 0%, #4338ca 100%);
            border-radius: 6px 6px 0 0;
            transition: height 0.6s cubic-bezier(0.4, 0, 0.2, 1);
            box-shadow: 0 4px 12px rgba(99, 102, 241, 0.25);
        }
        .pw-bar-col:hover .pw-bar-body {
            background: linear-gradient(180deg, #818cf8 0%, #4f46e5 100%);
            box-shadow: 0 6px 16px rgba(99, 102, 241, 0.45);
        }

        .pw-bar-day {
            position: absolute;
            bottom: -22px;
            font-size: 0.72rem;
            color: var(--pw-text-muted);
        }

        /* Donut Chart Rate */
        .pw-donut-layout {
            display: flex;
            align-items: center;
            justify-content: space-around;
            height: 190px;
        }

        .pw-donut-visual {
            position: relative;
            width: 140px;
            height: 140px;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .pw-donut-visual svg {
            width: 140px;
            height: 140px;
            transform: rotate(-90deg);
        }
        .pw-donut-bg {
            fill: none;
            stroke: rgba(255, 255, 255, 0.05);
            stroke-width: 15;
        }
        .pw-donut-fill {
            fill: none;
            stroke: #6366f1;
            stroke-width: 15;
            stroke-linecap: round;
            stroke-dasharray: 377;
            transition: stroke-dashoffset 1s ease;
        }
        .pw-donut-inner-text {
            position: absolute;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            text-align: center;
        }
        .pw-donut-inner-pct {
            font-size: 1.45rem;
            font-weight: 800;
            color: #ffffff;
            line-height: 1;
        }
        .pw-donut-inner-lbl {
            font-size: 0.68rem;
            color: var(--pw-text-muted);
            margin-top: 4px;
        }

        .pw-donut-legend {
            display: flex;
            flex-direction: column;
            gap: 14px;
            min-width: 140px;
        }
        .pw-legend-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            font-size: 0.78rem;
        }
        .pw-legend-left {
            display: flex;
            align-items: center;
            gap: 8px;
            color: var(--pw-text-primary);
        }
        .pw-legend-dot {
            width: 8px;
            height: 8px;
            border-radius: 50%;
        }
        .pw-legend-dot.purple { background-color: #6366f1; }
        .pw-legend-dot.blue { background-color: #38bdf8; }
        .pw-legend-dot.red { background-color: #f43f5e; }
        .pw-legend-val {
            font-weight: 600;
            color: var(--pw-text-muted);
        }

        /* ------------------ ROW 3: SUBJECTS & GOALS ------------------ */
        .pw-grid-row-3 {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
            margin-bottom: 20px;
        }

        /* Subject Progress */
        .pw-subject-list {
            display: flex;
            flex-direction: column;
            gap: 14px;
        }
        .pw-subject-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 14px;
        }
        .pw-subject-name {
            width: 160px;
            font-size: 0.82rem;
            color: var(--pw-text-primary);
            font-weight: 500;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        .pw-subject-bar-wrap {
            flex: 1;
            height: 8px;
            background-color: rgba(255, 255, 255, 0.05);
            border-radius: 999px;
            overflow: hidden;
            position: relative;
        }
        .pw-subject-bar-fill {
            height: 100%;
            background: linear-gradient(90deg, #4f46e5 0%, #6366f1 100%);
            border-radius: 999px;
            transition: width 0.8s ease;
        }
        .pw-subject-pct {
            width: 36px;
            text-align: right;
            font-size: 0.78rem;
            font-weight: 600;
            color: var(--pw-text-muted);
        }

        /* Goals Progress */
        .pw-goals-list {
            display: flex;
            flex-direction: column;
            gap: 14px;
        }
        .pw-goal-item {
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .pw-goal-icon {
            width: 32px;
            height: 32px;
            border-radius: 8px;
            background-color: rgba(56, 189, 248, 0.1);
            color: #38bdf8;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }
        .pw-goal-icon.green {
            background-color: rgba(16, 185, 129, 0.1);
            color: #10b981;
        }
        .pw-goal-icon.code {
            background-color: rgba(16, 185, 129, 0.1);
            color: #10b981;
        }
        .pw-goal-center {
            flex: 1;
            min-width: 0;
        }
        .pw-goal-title {
            font-size: 0.82rem;
            font-weight: 600;
            color: var(--pw-text-primary);
            margin-bottom: 5px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        .pw-goal-bar-wrap {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .pw-goal-bar {
            flex: 1;
            height: 6px;
            background-color: rgba(255, 255, 255, 0.05);
            border-radius: 999px;
            overflow: hidden;
        }
        .pw-goal-bar-fill {
            height: 100%;
            background: linear-gradient(90deg, #4f46e5 0%, #6366f1 100%);
            border-radius: 999px;
            transition: width 0.8s ease;
        }
        .pw-goal-pct-text {
            font-size: 0.72rem;
            font-weight: 600;
            color: var(--pw-text-muted);
            width: 28px;
            text-align: right;
        }
        .pw-goal-badge {
            font-size: 0.68rem;
            font-weight: 600;
            padding: 4px 10px;
            border-radius: 999px;
            white-space: nowrap;
        }
        .pw-goal-badge.in-progress {
            background-color: rgba(56, 189, 248, 0.12);
            color: #38bdf8;
            border: 1px solid rgba(56, 189, 248, 0.25);
        }
        .pw-goal-badge.on-track {
            background-color: rgba(16, 185, 129, 0.12);
            color: #10b981;
            border: 1px solid rgba(16, 185, 129, 0.25);
        }
        .pw-goal-badge.at-risk {
            background-color: rgba(244, 63, 94, 0.12);
            color: #f43f5e;
            border: 1px solid rgba(244, 63, 94, 0.25);
        }

        /* ------------------ ROW 4: RECENT ACTIVITY & INSIGHTS ------------------ */
        .pw-grid-row-4 {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
        }

        /* Activity Timeline */
        .pw-timeline {
            display: flex;
            flex-direction: column;
            position: relative;
            padding-left: 28px;
            gap: 18px;
        }
        .pw-timeline::before {
            content: '';
            position: absolute;
            left: 10px;
            top: 10px;
            bottom: 10px;
            width: 2px;
            background-color: rgba(255, 255, 255, 0.08);
        }

        .pw-timeline-item {
            position: relative;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
        }

        .pw-timeline-dot {
            position: absolute;
            left: -28px;
            width: 22px;
            height: 22px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 2;
        }
        .pw-timeline-dot.green {
            background-color: #10b981;
            color: #ffffff;
            box-shadow: 0 0 10px rgba(16, 185, 129, 0.4);
        }
        .pw-timeline-dot.blue {
            background-color: #38bdf8;
            color: #080c18;
            box-shadow: 0 0 10px rgba(56, 189, 248, 0.4);
        }
        .pw-timeline-dot.orange {
            background-color: #f97316;
            color: #ffffff;
            box-shadow: 0 0 10px rgba(249, 115, 22, 0.4);
        }
        .pw-timeline-dot.purple {
            background-color: #8b5cf6;
            color: #ffffff;
            box-shadow: 0 0 10px rgba(139, 92, 246, 0.4);
        }

        .pw-timeline-body {
            display: flex;
            flex-direction: column;
        }
        .pw-timeline-title {
            font-size: 0.82rem;
            font-weight: 600;
            color: var(--pw-text-primary);
        }
        .pw-timeline-time {
            font-size: 0.72rem;
            color: var(--pw-text-dim);
            margin-top: 2px;
        }

        .pw-timeline-pill {
            font-size: 0.68rem;
            font-weight: 600;
            padding: 3px 10px;
            border-radius: 999px;
        }
        .pw-timeline-pill.task {
            background-color: rgba(16, 185, 129, 0.15);
            color: #34d399;
        }
        .pw-timeline-pill.study {
            background-color: rgba(56, 189, 248, 0.15);
            color: #60a5fa;
        }
        .pw-timeline-pill.milestone {
            background-color: rgba(139, 92, 246, 0.18);
            color: #c084fc;
        }
        .pw-timeline-pill.timetable {
            background-color: rgba(99, 102, 241, 0.18);
            color: #818cf8;
        }

        /* Productivity Insights */
        .pw-insights-list {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .pw-insight-row {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 10px 12px;
            border-radius: 10px;
            background-color: rgba(255, 255, 255, 0.02);
            border: 1px solid rgba(255, 255, 255, 0.03);
            cursor: pointer;
            transition: all 0.2s;
        }
        .pw-insight-row:hover {
            background-color: rgba(255, 255, 255, 0.04);
            border-color: rgba(121, 82, 245, 0.25);
        }

        .pw-insight-icon {
            width: 32px;
            height: 32px;
            border-radius: 8px;
            background-color: rgba(99, 102, 241, 0.15);
            color: #818cf8;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        .pw-insight-content {
            flex: 1;
            min-width: 0;
        }
        .pw-insight-title {
            font-size: 0.8rem;
            font-weight: 600;
            color: var(--pw-text-primary);
        }
        .pw-insight-sub {
            font-size: 0.72rem;
            color: var(--pw-text-muted);
            margin-top: 2px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        .pw-insight-arrow {
            color: var(--pw-text-dim);
            font-size: 1rem;
        }

        /* ------------------ MODALS ------------------ */
        .pw-modal-overlay {
            display: none;
            position: fixed;
            top: 0; left: 0; right: 0; bottom: 0;
            background-color: rgba(0, 0, 0, 0.75);
            backdrop-filter: blur(5px);
            z-index: 999;
            align-items: center;
            justify-content: center;
        }
        .pw-modal-overlay.open { display: flex; }
        .pw-modal {
            background-color: #0f1629;
            border: 1px solid rgba(121, 82, 245, 0.35);
            border-radius: 14px;
            width: 440px;
            max-width: 90vw;
            padding: 24px;
            box-shadow: 0 12px 40px rgba(0, 0, 0, 0.6);
        }
        .pw-modal h3 {
            margin: 0 0 18px 0;
            color: #ffffff;
            font-size: 1.15rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .pw-modal-close {
            background: none;
            border: none;
            color: var(--pw-text-muted);
            cursor: pointer;
            font-size: 1.2rem;
        }
        .pw-form-group {
            margin-bottom: 14px;
        }
        .pw-form-group label {
            display: block;
            font-size: 0.76rem;
            font-weight: 600;
            color: var(--pw-text-muted);
            margin-bottom: 6px;
        }
        .pw-form-group input, .pw-form-group select, .pw-form-group textarea {
            width: 100%;
            background-color: rgba(255, 255, 255, 0.04);
            border: 1px solid var(--pw-border);
            border-radius: 8px;
            padding: 10px 12px;
            color: #ffffff;
            font-size: 0.85rem;
            box-sizing: border-box;
            outline: none;
        }
        .pw-form-group input:focus, .pw-form-group select:focus, .pw-form-group textarea:focus {
            border-color: #6366f1;
        }
        .pw-modal-actions {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 20px;
        }

        /* ------------------ RECENT ACTIVITY DETAILED VIEW (REFERENCE REPLICA) ------------------ */
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
                        <circle cx="8" cy="14" r="1"></circle>
                        <circle cx="12" cy="14" r="1"></circle>
                        <circle cx="16" cy="14" r="1"></circle>
                    </svg>
                </div>
                <div class="pw-logo-text">Slot<span>Wise</span></div>
            </a>

            <!-- Navigation Links -->
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

                <!-- Smart Rescheduler -->
                <a href="${pageContext.request.contextPath}/smart-rescheduler.jsp" class="pw-nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M21.5 2v6h-6"></path>
                        <path d="M2.5 12A10 10 0 0 1 20.5 6.3L21.5 8"></path>
                        <path d="M2.5 22v-6h6"></path>
                        <path d="M21.5 12A10 10 0 0 1 3.5 17.7L2.5 16"></path>
                    </svg>
                    <span>Smart Rescheduler</span>
                </a>

                <!-- Deadline Radar -->
                <a href="${pageContext.request.contextPath}/deadline-radar.jsp" class="pw-nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="12" cy="12" r="2"></circle>
                        <path d="M16.24 7.76a6 6 0 0 1 0 8.49m-8.48-.01a6 6 0 0 1 0-8.49m11.31-2.82a10 10 0 0 1 0 14.14m-14.14 0a10 10 0 0 1 0-14.14"></path>
                    </svg>
                    <span>Deadline Radar</span>
                </a>

                <a href="#" onclick="openGoalModal(); return false;" class="pw-nav-item">
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
                    <svg class="pw-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <polyline points="6 9 12 15 18 9"></polyline>
                    </svg>
                </a>
            </div>
        </header>

        <!-- Main Container -->
        <div class="pw-container">

            <!-- DASHBOARD FULL VIEW -->
            <div id="pwDashboardView">

                <!-- Title Header -->
                <div class="pw-header">
                    <h1>Progress</h1>
                    <p>Track your learning journey, analyze your productivity, and achieve your goals.</p>
                </div>

            <!-- ==================================================== -->
            <!-- ROW 1: 4 SUMMARY KPI CARDS                           -->
            <!-- ==================================================== -->
            <div class="pw-kpi-row">

                <!-- 1. Tasks Completed -->
                <div class="pw-kpi-card">
                    <div class="pw-kpi-left">
                        <div class="pw-kpi-icon-box">
                            <svg viewBox="0 0 24 24" width="22" height="22" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2"></path>
                                <rect x="8" y="2" width="8" height="4" rx="1" ry="1"></rect>
                                <polyline points="9 14 11 16 15 11"></polyline>
                            </svg>
                        </div>
                        <div class="pw-kpi-data">
                            <span class="pw-kpi-title">Tasks Completed</span>
                            <span class="pw-kpi-val"><c:out value="${completedTasks != null && completedTasks > 0 ? completedTasks : 24}"/></span>
                            <span class="pw-kpi-sub">out of <c:out value="${totalTasks != null && totalTasks > 0 ? totalTasks : 32}"/> tasks</span>
                        </div>
                    </div>
                    <div class="pw-gauge">
                        <svg viewBox="0 0 44 44">
                            <circle class="pw-gauge-bg" cx="22" cy="22" r="20"></circle>
                            <circle class="pw-gauge-fill" cx="22" cy="22" r="20"
                                    style="stroke-dashoffset: 31.4;"></circle>
                        </svg>
                        <span class="pw-gauge-text">75%</span>
                    </div>
                </div>

                <!-- 2. Study Hours -->
                <div class="pw-kpi-card">
                    <div class="pw-kpi-left">
                        <div class="pw-kpi-icon-box clock">
                            <svg viewBox="0 0 24 24" width="22" height="22" fill="none" stroke="currentColor" stroke-width="2">
                                <circle cx="12" cy="12" r="10"></circle>
                                <polyline points="12 6 12 12 16 14"></polyline>
                            </svg>
                        </div>
                        <div class="pw-kpi-data">
                            <span class="pw-kpi-title">Study Hours</span>
                            <span class="pw-kpi-val"><c:out value="${thisWeekHours != null && thisWeekHours > 0 ? thisWeekHours : '18.5'}"/> <span>h</span></span>
                            <span class="pw-kpi-sub">this week</span>
                        </div>
                    </div>
                    <div class="pw-trend-badge">
                        <div class="pw-trend-val">
                            <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2.5">
                                <polyline points="18 15 12 9 6 15"></polyline>
                            </svg>
                            <span>12%</span>
                        </div>
                        <span class="pw-trend-sub">vs last week</span>
                    </div>
                </div>

                <!-- 3. Goals Achieved -->
                <div class="pw-kpi-card">
                    <div class="pw-kpi-left">
                        <div class="pw-kpi-icon-box target">
                            <svg viewBox="0 0 24 24" width="22" height="22" fill="none" stroke="currentColor" stroke-width="2">
                                <circle cx="12" cy="12" r="10"></circle>
                                <circle cx="12" cy="12" r="6"></circle>
                                <circle cx="12" cy="12" r="2"></circle>
                            </svg>
                        </div>
                        <div class="pw-kpi-data">
                            <span class="pw-kpi-title">Goals Achieved</span>
                            <span class="pw-kpi-val"><c:out value="${completedGoals != null && completedGoals > 0 ? completedGoals : 4}"/></span>
                            <span class="pw-kpi-sub">out of <c:out value="${totalGoals != null && totalGoals > 0 ? totalGoals : 6}"/> goals</span>
                        </div>
                    </div>
                    <div class="pw-gauge">
                        <svg viewBox="0 0 44 44">
                            <circle class="pw-gauge-bg" cx="22" cy="22" r="20"></circle>
                            <circle class="pw-gauge-fill" cx="22" cy="22" r="20"
                                    style="stroke-dashoffset: 41.4;"></circle>
                        </svg>
                        <span class="pw-gauge-text">67%</span>
                    </div>
                </div>

                <!-- 4. Current Streak -->
                <div class="pw-kpi-card">
                    <div class="pw-kpi-left">
                        <div class="pw-kpi-icon-box flame">
                            <svg viewBox="0 0 24 24" width="22" height="22" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M8.5 14.5A2.5 2.5 0 0 0 11 12c0-1.38-.5-2-1-3-1.072-2.143-.224-4.054 2-6 .5 2.5 2 4.9 4 6.5 2 1.6 3 3.5 3 5.5a7 7 0 1 1-14 0c0-1.153.433-2.294 1-3a2.5 2.5 0 0 0 2.5 2.5z"></path>
                            </svg>
                        </div>
                        <div class="pw-kpi-data">
                            <span class="pw-kpi-title">Current Streak</span>
                            <span class="pw-kpi-val"><c:out value="${studyStreak != null && studyStreak > 0 ? studyStreak : 7}"/> <span>Days</span></span>
                            <span class="pw-kpi-sub">Keep it going!</span>
                        </div>
                    </div>
                    <div class="pw-flame-badge">&#128293;</div>
                </div>

            </div>

            <!-- ==================================================== -->
            <!-- ROW 2: STUDY HOURS OVERVIEW + TASK COMPLETION RATE   -->
            <!-- ==================================================== -->
            <div class="pw-grid-row-2">

                <!-- Study Hours Overview Bar Chart -->
                <div class="pw-card">
                    <div class="pw-card-header">
                        <div class="pw-card-title-group">
                            <div class="pw-card-header-icon">
                                <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2">
                                    <line x1="18" y1="20" x2="18" y2="10"></line>
                                    <line x1="12" y1="20" x2="12" y2="4"></line>
                                    <line x1="6" y1="20" x2="6" y2="14"></line>
                                </svg>
                            </div>
                            <div>
                                <h3 class="pw-card-title">Study Hours Overview</h3>
                                <div class="pw-card-subtitle" id="studyHoursSubtitle">Your daily study time for the past week</div>
                            </div>
                        </div>
                        <div class="pw-dropdown-wrapper">
                            <button class="pw-dropdown-btn" onclick="toggleDropdown('studyHoursDropdown', event)">
                                <span id="studyHoursSelected">This Week</span>
                                <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2">
                                    <polyline points="6 9 12 15 18 9"></polyline>
                                </svg>
                            </button>
                            <div class="pw-dropdown-menu" id="studyHoursDropdown">
                                <div class="pw-dropdown-item active" data-period="this_week" onclick="setStudyHoursPeriod('this_week', 'This Week')">
                                    <span>This Week</span>
                                    <svg class="pw-check-icon" viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"></polyline></svg>
                                </div>
                                <div class="pw-dropdown-item" data-period="last_week" onclick="setStudyHoursPeriod('last_week', 'Last Week')">
                                    <span>Last Week</span>
                                    <svg class="pw-check-icon" viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"></polyline></svg>
                                </div>
                                <div class="pw-dropdown-item" data-period="month" onclick="setStudyHoursPeriod('month', 'Last 30 Days')">
                                    <span>Last 30 Days</span>
                                    <svg class="pw-check-icon" viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"></polyline></svg>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="pw-barchart-container">
                        <!-- Y-axis scale -->
                        <div class="pw-barchart-yaxis" id="studyHoursYAxis">
                            <span>8h</span>
                            <span>6h</span>
                            <span>4h</span>
                            <span>2h</span>
                            <span>0h</span>
                        </div>

                        <!-- Bar chart grid & bars -->
                        <div class="pw-barchart-grid">
                            <div class="pw-gridlines">
                                <div class="pw-gridline"></div>
                                <div class="pw-gridline"></div>
                                <div class="pw-gridline"></div>
                                <div class="pw-gridline"></div>
                                <div class="pw-gridline"></div>
                            </div>

                            <div class="pw-bars" id="studyHoursBars">
                                <!-- Mon: 4.5h -->
                                <div class="pw-bar-col">
                                    <span class="pw-bar-val">4.5h</span>
                                    <div class="pw-bar-body" style="height: 56.25%;"></div>
                                    <span class="pw-bar-day">Mon</span>
                                </div>
                                <!-- Tue: 3.0h -->
                                <div class="pw-bar-col">
                                    <span class="pw-bar-val">3.0h</span>
                                    <div class="pw-bar-body" style="height: 37.5%;"></div>
                                    <span class="pw-bar-day">Tue</span>
                                </div>
                                <!-- Wed: 5.0h -->
                                <div class="pw-bar-col">
                                    <span class="pw-bar-val">5.0h</span>
                                    <div class="pw-bar-body" style="height: 62.5%;"></div>
                                    <span class="pw-bar-day">Wed</span>
                                </div>
                                <!-- Thu: 2.5h -->
                                <div class="pw-bar-col">
                                    <span class="pw-bar-val">2.5h</span>
                                    <div class="pw-bar-body" style="height: 31.25%;"></div>
                                    <span class="pw-bar-day">Thu</span>
                                </div>
                                <!-- Fri: 6.0h -->
                                <div class="pw-bar-col">
                                    <span class="pw-bar-val">6.0h</span>
                                    <div class="pw-bar-body" style="height: 75%;"></div>
                                    <span class="pw-bar-day">Fri</span>
                                </div>
                                <!-- Sat: 4.0h -->
                                <div class="pw-bar-col">
                                    <span class="pw-bar-val">4.0h</span>
                                    <div class="pw-bar-body" style="height: 50%;"></div>
                                    <span class="pw-bar-day">Sat</span>
                                </div>
                                <!-- Sun: 3.5h -->
                                <div class="pw-bar-col">
                                    <span class="pw-bar-val">3.5h</span>
                                    <div class="pw-bar-body" style="height: 43.75%;"></div>
                                    <span class="pw-bar-day">Sun</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Task Completion Rate -->
                <div class="pw-card">
                    <div class="pw-card-header">
                        <div class="pw-card-title-group">
                            <div class="pw-card-header-icon">
                                <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M9 11l3 3L22 4"></path>
                                    <path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"></path>
                                </svg>
                            </div>
                            <div>
                                <h3 class="pw-card-title">Task Completion Rate</h3>
                                <div class="pw-card-subtitle" id="taskRateSubtitle">Overview of your task status</div>
                            </div>
                        </div>
                        <div class="pw-dropdown-wrapper">
                            <button class="pw-dropdown-btn" onclick="toggleDropdown('taskRateDropdown', event)">
                                <span id="taskRateSelected">This Month</span>
                                <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2">
                                    <polyline points="6 9 12 15 18 9"></polyline>
                                </svg>
                            </button>
                            <div class="pw-dropdown-menu" id="taskRateDropdown">
                                <div class="pw-dropdown-item active" data-period="month" onclick="setTaskRatePeriod('month', 'This Month')">
                                    <span>This Month</span>
                                    <svg class="pw-check-icon" viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"></polyline></svg>
                                </div>
                                <div class="pw-dropdown-item" data-period="week" onclick="setTaskRatePeriod('week', 'This Week')">
                                    <span>This Week</span>
                                    <svg class="pw-check-icon" viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"></polyline></svg>
                                </div>
                                <div class="pw-dropdown-item" data-period="semester" onclick="setTaskRatePeriod('semester', 'This Semester')">
                                    <span>This Semester</span>
                                    <svg class="pw-check-icon" viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"></polyline></svg>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="pw-donut-layout">
                        <div class="pw-donut-visual">
                            <svg viewBox="0 0 140 140">
                                <circle class="pw-donut-bg" cx="70" cy="70" r="55"></circle>
                                <circle class="pw-donut-fill" id="taskRateDonutCircle" cx="70" cy="70" r="55"
                                        style="stroke-dashoffset: 94.25;"></circle>
                            </svg>
                            <div class="pw-donut-inner-text">
                                <span class="pw-donut-inner-pct" id="taskRatePctText">75%</span>
                                <span class="pw-donut-inner-lbl">Completed</span>
                            </div>
                        </div>

                        <div class="pw-donut-legend">
                            <div class="pw-legend-item">
                                <div class="pw-legend-left">
                                    <span class="pw-legend-dot purple"></span>
                                    <span>Completed</span>
                                </div>
                                <span class="pw-legend-val" id="taskRateLegendCompleted">24 (75%)</span>
                            </div>
                            <div class="pw-legend-item">
                                <div class="pw-legend-left">
                                    <span class="pw-legend-dot blue"></span>
                                    <span>Pending</span>
                                </div>
                                <span class="pw-legend-val" id="taskRateLegendPending">6 (18%)</span>
                            </div>
                            <div class="pw-legend-item">
                                <div class="pw-legend-left">
                                    <span class="pw-legend-dot red"></span>
                                    <span>Overdue</span>
                                </div>
                                <span class="pw-legend-val" id="taskRateLegendOverdue">2 (7%)</span>
                            </div>
                        </div>
                    </div>
                </div>

            </div>

            <!-- ==================================================== -->
            <!-- ROW 3: SUBJECT-WISE PROGRESS + GOAL PROGRESS         -->
            <!-- ==================================================== -->
            <div class="pw-grid-row-3">

                <!-- Subject-wise Progress -->
                <div class="pw-card">
                    <div class="pw-card-header">
                        <div class="pw-card-title-group">
                            <div class="pw-card-header-icon">
                                <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2">
                                    <polygon points="12 2 2 7 12 12 22 7 12 2"></polygon>
                                    <polyline points="2 17 12 22 22 17"></polyline>
                                    <polyline points="2 12 12 17 22 12"></polyline>
                                </svg>
                            </div>
                            <div>
                                <h3 class="pw-card-title">Subject-wise Progress</h3>
                                <div class="pw-card-subtitle" id="subjectProgressSubtitle">Your progress in each subject</div>
                            </div>
                        </div>
                        <div class="pw-dropdown-wrapper">
                            <button class="pw-dropdown-btn" onclick="toggleDropdown('subjectProgressDropdown', event)">
                                <span id="subjectProgressSelected">This Semester</span>
                                <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2">
                                    <polyline points="6 9 12 15 18 9"></polyline>
                                </svg>
                            </button>
                            <div class="pw-dropdown-menu" id="subjectProgressDropdown">
                                <div class="pw-dropdown-item active" data-period="semester" onclick="setSubjectPeriod('semester', 'This Semester')">
                                    <span>This Semester</span>
                                    <svg class="pw-check-icon" viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"></polyline></svg>
                                </div>
                                <div class="pw-dropdown-item" data-period="month" onclick="setSubjectPeriod('month', 'This Month')">
                                    <span>This Month</span>
                                    <svg class="pw-check-icon" viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"></polyline></svg>
                                </div>
                                <div class="pw-dropdown-item" data-period="all_time" onclick="setSubjectPeriod('all_time', 'All Time')">
                                    <span>All Time</span>
                                    <svg class="pw-check-icon" viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"></polyline></svg>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="pw-subject-list">
                        <!-- Data Structures -->
                        <div class="pw-subject-item">
                            <span class="pw-subject-name">Data Structures</span>
                            <div class="pw-subject-bar-wrap">
                                <div class="pw-subject-bar-fill" id="subBarDS" style="width: 85%;"></div>
                            </div>
                            <span class="pw-subject-pct" id="subPctDS">85%</span>
                        </div>
                        <!-- Database Systems -->
                        <div class="pw-subject-item">
                            <span class="pw-subject-name">Database Systems</span>
                            <div class="pw-subject-bar-wrap">
                                <div class="pw-subject-bar-fill" id="subBarDB" style="width: 70%;"></div>
                            </div>
                            <span class="pw-subject-pct" id="subPctDB">70%</span>
                        </div>
                        <!-- Operating Systems -->
                        <div class="pw-subject-item">
                            <span class="pw-subject-name">Operating Systems</span>
                            <div class="pw-subject-bar-wrap">
                                <div class="pw-subject-bar-fill" id="subBarOS" style="width: 60%;"></div>
                            </div>
                            <span class="pw-subject-pct" id="subPctOS">60%</span>
                        </div>
                        <!-- Computer Networks -->
                        <div class="pw-subject-item">
                            <span class="pw-subject-name">Computer Networks</span>
                            <div class="pw-subject-bar-wrap">
                                <div class="pw-subject-bar-fill" id="subBarCN" style="width: 50%;"></div>
                            </div>
                            <span class="pw-subject-pct" id="subPctCN">50%</span>
                        </div>
                        <!-- Software Engineering -->
                        <div class="pw-subject-item">
                            <span class="pw-subject-name">Software Engineering</span>
                            <div class="pw-subject-bar-wrap">
                                <div class="pw-subject-bar-fill" id="subBarSE" style="width: 65%;"></div>
                            </div>
                            <span class="pw-subject-pct" id="subPctSE">65%</span>
                        </div>
                        <!-- Mathematics -->
                        <div class="pw-subject-item">
                            <span class="pw-subject-name">Mathematics</span>
                            <div class="pw-subject-bar-wrap">
                                <div class="pw-subject-bar-fill" id="subBarMath" style="width: 75%;"></div>
                            </div>
                            <span class="pw-subject-pct" id="subPctMath">75%</span>
                        </div>
                    </div>
                </div>

                <!-- Goal Progress -->
                <div class="pw-card">
                    <div class="pw-card-header">
                        <div class="pw-card-title-group">
                            <div class="pw-card-header-icon">
                                <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2">
                                    <circle cx="12" cy="12" r="10"></circle>
                                    <circle cx="12" cy="12" r="6"></circle>
                                    <circle cx="12" cy="12" r="2"></circle>
                                </svg>
                            </div>
                            <div>
                                <h3 class="pw-card-title">Goal Progress</h3>
                                <div class="pw-card-subtitle">Track your academic and personal goals</div>
                            </div>
                        </div>
                        <a href="#" onclick="openGoalModal(); return false;" class="pw-link-btn">
                            <span>View All</span>
                            <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2">
                                <line x1="5" y1="12" x2="19" y2="12"></line>
                                <polyline points="12 5 19 12 12 19"></polyline>
                            </svg>
                        </a>
                    </div>

                    <div class="pw-goals-list">
                        <!-- Goal 1 -->
                        <div class="pw-goal-item">
                            <div class="pw-goal-icon">
                                <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2">
                                    <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                    <line x1="16" y1="2" x2="16" y2="6"></line>
                                    <line x1="8" y1="2" x2="8" y2="6"></line>
                                    <line x1="3" y1="10" x2="21" y2="10"></line>
                                </svg>
                            </div>
                            <div class="pw-goal-center">
                                <div class="pw-goal-title">Complete DBMS Assignment</div>
                                <div class="pw-goal-bar-wrap">
                                    <div class="pw-goal-bar">
                                        <div class="pw-goal-bar-fill" style="width: 70%;"></div>
                                    </div>
                                    <span class="pw-goal-pct-text">70%</span>
                                </div>
                            </div>
                            <span class="pw-goal-badge in-progress">In Progress</span>
                        </div>

                        <!-- Goal 2 -->
                        <div class="pw-goal-item">
                            <div class="pw-goal-icon green">
                                <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2">
                                    <circle cx="12" cy="12" r="10"></circle>
                                    <polyline points="12 6 12 12 16 14"></polyline>
                                </svg>
                            </div>
                            <div class="pw-goal-center">
                                <div class="pw-goal-title">Maintain 20 study hours this week</div>
                                <div class="pw-goal-bar-wrap">
                                    <div class="pw-goal-bar">
                                        <div class="pw-goal-bar-fill" style="width: 92%;"></div>
                                    </div>
                                    <span class="pw-goal-pct-text">92%</span>
                                </div>
                            </div>
                            <span class="pw-goal-badge on-track">On Track</span>
                        </div>

                        <!-- Goal 3 -->
                        <div class="pw-goal-item">
                            <div class="pw-goal-icon">
                                <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                                    <polyline points="14 2 14 8 20 8"></polyline>
                                    <line x1="16" y1="13" x2="8" y2="13"></line>
                                    <line x1="16" y1="17" x2="8" y2="17"></line>
                                </svg>
                            </div>
                            <div class="pw-goal-center">
                                <div class="pw-goal-title">Complete all pending lab records</div>
                                <div class="pw-goal-bar-wrap">
                                    <div class="pw-goal-bar">
                                        <div class="pw-goal-bar-fill" style="width: 67%;"></div>
                                    </div>
                                    <span class="pw-goal-pct-text">67%</span>
                                </div>
                            </div>
                            <span class="pw-goal-badge in-progress">In Progress</span>
                        </div>

                        <!-- Goal 4 -->
                        <div class="pw-goal-item">
                            <div class="pw-goal-icon code">
                                <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2">
                                    <polyline points="16 18 22 12 16 6"></polyline>
                                    <polyline points="8 6 2 12 8 18"></polyline>
                                </svg>
                            </div>
                            <div class="pw-goal-center">
                                <div class="pw-goal-title">Revise Java &amp; DSA</div>
                                <div class="pw-goal-bar-wrap">
                                    <div class="pw-goal-bar">
                                        <div class="pw-goal-bar-fill" style="width: 40%;"></div>
                                    </div>
                                    <span class="pw-goal-pct-text">40%</span>
                                </div>
                            </div>
                            <span class="pw-goal-badge at-risk">At Risk</span>
                        </div>
                    </div>
                </div>

            </div>

            <!-- ==================================================== -->
            <!-- ROW 4: RECENT ACTIVITY & PRODUCTIVITY INSIGHTS       -->
            <!-- ==================================================== -->
            <div class="pw-grid-row-4">

                <!-- Recent Activity -->
                <div class="pw-card">
                    <div class="pw-card-header">
                        <div class="pw-card-title-group">
                            <div class="pw-card-header-icon">
                                <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2">
                                    <circle cx="12" cy="12" r="10"></circle>
                                    <polyline points="12 6 12 12 16 14"></polyline>
                                </svg>
                            </div>
                            <div>
                                <h3 class="pw-card-title">Recent Activity</h3>
                                <div class="pw-card-subtitle">Your latest progress and achievements</div>
                            </div>
                        </div>
                        <a href="${pageContext.request.contextPath}/recent-activity.jsp" class="pw-link-btn" id="recentActivityViewAllBtn">
                            <span>View All</span>
                            <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2">
                                <line x1="5" y1="12" x2="19" y2="12"></line>
                                <polyline points="12 5 19 12 12 19"></polyline>
                            </svg>
                        </a>
                    </div>

                    <div class="pw-timeline">
                        <!-- Activity 1 -->
                        <div class="pw-timeline-item">
                            <div class="pw-timeline-dot green">
                                <svg viewBox="0 0 24 24" width="12" height="12" fill="none" stroke="currentColor" stroke-width="3">
                                    <polyline points="20 6 9 17 4 12"></polyline>
                                </svg>
                            </div>
                            <div class="pw-timeline-body">
                                <span class="pw-timeline-title">Completed DBMS Assignment</span>
                                <span class="pw-timeline-time">2 hours ago</span>
                            </div>
                            <span class="pw-timeline-pill task">Task</span>
                        </div>

                        <!-- Activity 2 -->
                        <div class="pw-timeline-item">
                            <div class="pw-timeline-dot blue">
                                <svg viewBox="0 0 24 24" width="12" height="12" fill="none" stroke="currentColor" stroke-width="2.5">
                                    <circle cx="12" cy="12" r="10"></circle>
                                    <polyline points="12 6 12 12 16 14"></polyline>
                                </svg>
                            </div>
                            <div class="pw-timeline-body">
                                <span class="pw-timeline-title">Studied Operating Systems for 2 hours</span>
                                <span class="pw-timeline-time">4 hours ago</span>
                            </div>
                            <span class="pw-timeline-pill study">Study</span>
                        </div>

                        <!-- Activity 3 -->
                        <div class="pw-timeline-item">
                            <div class="pw-timeline-dot orange">
                                <svg viewBox="0 0 24 24" width="12" height="12" fill="none" stroke="currentColor" stroke-width="2.5">
                                    <path d="M8.5 14.5A2.5 2.5 0 0 0 11 12c0-1.38-.5-2-1-3-1.072-2.143-.224-4.054 2-6 .5 2.5 2 4.9 4 6.5 2 1.6 3 3.5 3 5.5a7 7 0 1 1-14 0c0-1.153.433-2.294 1-3a2.5 2.5 0 0 0 2.5 2.5z"></path>
                                </svg>
                            </div>
                            <div class="pw-timeline-body">
                                <span class="pw-timeline-title">Achieved 7-day streak!</span>
                                <span class="pw-timeline-time">1 day ago</span>
                            </div>
                            <span class="pw-timeline-pill milestone">Milestone</span>
                        </div>

                        <!-- Activity 4 -->
                        <div class="pw-timeline-item">
                            <div class="pw-timeline-dot purple">
                                <svg viewBox="0 0 24 24" width="12" height="12" fill="none" stroke="currentColor" stroke-width="2.5">
                                    <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                    <line x1="16" y1="2" x2="16" y2="6"></line>
                                    <line x1="8" y1="2" x2="8" y2="6"></line>
                                    <line x1="3" y1="10" x2="21" y2="10"></line>
                                </svg>
                            </div>
                            <div class="pw-timeline-body">
                                <span class="pw-timeline-title">Updated timetable for next week</span>
                                <span class="pw-timeline-time">2 days ago</span>
                            </div>
                            <span class="pw-timeline-pill timetable">Timetable</span>
                        </div>
                    </div>
                </div>

                <!-- Productivity Insights -->
                <div class="pw-card">
                    <div class="pw-card-header">
                        <div class="pw-card-title-group">
                            <div class="pw-card-header-icon">
                                <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2">
                                    <line x1="9" y1="18" x2="15" y2="18"></line>
                                    <line x1="10" y1="22" x2="14" y2="22"></line>
                                    <path d="M15.09 14c.18-.98.65-1.74 1.41-2.5A4.65 4.65 0 0 0 18 8 6 6 0 0 0 6 8c0 1 .23 2.23 1.5 3.5A4.61 4.61 0 0 1 8.91 14"></path>
                                </svg>
                            </div>
                            <div>
                                <h3 class="pw-card-title">Productivity Insights</h3>
                                <div class="pw-card-subtitle">AI-like insights based on your activity</div>
                            </div>
                        </div>
                    </div>

                    <div class="pw-insights-list">
                        <!-- Insight 1 -->
                        <div class="pw-insight-row">
                            <div class="pw-insight-icon">
                                <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2">
                                    <line x1="18" y1="20" x2="18" y2="10"></line>
                                    <line x1="12" y1="20" x2="12" y2="4"></line>
                                    <line x1="6" y1="20" x2="6" y2="14"></line>
                                </svg>
                            </div>
                            <div class="pw-insight-content">
                                <div class="pw-insight-title">Your study time increased by 12%</div>
                                <div class="pw-insight-sub">You studied 18.5 hours this week compared to 16.5 hours last week.</div>
                            </div>
                            <span class="pw-insight-arrow">&#8250;</span>
                        </div>

                        <!-- Insight 2 -->
                        <div class="pw-insight-row">
                            <div class="pw-insight-icon">
                                <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2">
                                    <circle cx="12" cy="12" r="10"></circle>
                                    <polyline points="12 6 12 12 16 14"></polyline>
                                </svg>
                            </div>
                            <div class="pw-insight-content">
                                <div class="pw-insight-title">Focus more on Operating Systems</div>
                                <div class="pw-insight-sub">You spent 30% less time on OS this week.</div>
                            </div>
                            <span class="pw-insight-arrow">&#8250;</span>
                        </div>

                        <!-- Insight 3 -->
                        <div class="pw-insight-row">
                            <div class="pw-insight-icon">
                                <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2">
                                    <circle cx="12" cy="12" r="10"></circle>
                                    <circle cx="12" cy="12" r="6"></circle>
                                    <circle cx="12" cy="12" r="2"></circle>
                                </svg>
                            </div>
                            <div class="pw-insight-content">
                                <div class="pw-insight-title">You're close to your goal!</div>
                                <div class="pw-insight-sub">Only 2 more tasks to complete this goal.</div>
                            </div>
                            <span class="pw-insight-arrow">&#8250;</span>
                        </div>

                        <!-- Insight 4 -->
                        <div class="pw-insight-row">
                            <div class="pw-insight-icon">
                                <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path>
                                    <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path>
                                </svg>
                            </div>
                            <div class="pw-insight-content">
                                <div class="pw-insight-title">Maintain your 7-day streak</div>
                                <div class="pw-insight-sub">You've been consistent for 7 days. Keep it up!</div>
                            </div>
                            <span class="pw-insight-arrow">&#8250;</span>
                        </div>
                    </div>
                </div>

            </div><!-- end pwDashboardView -->

            <!-- ==================================================== -->
            <!-- DEDICATED RECENT ACTIVITIES VIEW (REFERENCE REPLICA) -->
            <!-- ==================================================== -->
            <div id="pwActivitiesOnlyView" style="display: none;">

                <!-- Breadcrumb & Top Right Action -->
                <div class="pw-act-breadcrumb-bar">
                    <div class="pw-breadcrumb">
                        <a href="javascript:void(0)" onclick="showDashboardView()" class="pw-breadcrumb-link">Progress</a>
                        <span class="pw-breadcrumb-sep">&gt;</span>
                        <span class="pw-breadcrumb-current">Recent Activity</span>
                    </div>
                    <button type="button" class="pw-back-to-progress-btn" onclick="showDashboardView()">
                        <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2.5">
                            <line x1="19" y1="12" x2="5" y2="12"></line>
                            <polyline points="12 19 5 12 12 5"></polyline>
                        </svg>
                        <span>Back to Progress</span>
                    </button>
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
                                <button type="button" class="pw-act-kebab-btn" title="Options">&#8942;</button>
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
                                <button type="button" class="pw-act-kebab-btn" title="Options">&#8942;</button>
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
                                <button type="button" class="pw-act-kebab-btn" title="Options">&#8942;</button>
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
                                <button type="button" class="pw-act-kebab-btn" title="Options">&#8942;</button>
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
                                <button type="button" class="pw-act-kebab-btn" title="Options">&#8942;</button>
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
                                <button type="button" class="pw-act-kebab-btn" title="Options">&#8942;</button>
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
                                <button type="button" class="pw-act-kebab-btn" title="Options">&#8942;</button>
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
                                <button type="button" class="pw-act-kebab-btn" title="Options">&#8942;</button>
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
                                <button type="button" class="pw-act-kebab-btn" title="Options">&#8942;</button>
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
                                <button type="button" class="pw-act-kebab-btn" title="Options">&#8942;</button>
                            </div>

                            <!-- Additional rows for Page 2 & 3 (initially hidden, shown on page change or filter) -->
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
                                <button type="button" class="pw-act-kebab-btn" title="Options">&#8942;</button>
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
                                <button type="button" class="pw-act-kebab-btn" title="Options">&#8942;</button>
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
                                <button type="button" class="pw-act-kebab-btn" title="Options">&#8942;</button>
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
                                <button type="button" class="pw-act-kebab-btn" title="Options">&#8942;</button>
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
                                <button type="button" class="pw-act-kebab-btn" title="Options">&#8942;</button>
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
                                <button type="button" class="pw-act-kebab-btn" title="Options">&#8942;</button>
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
                                <button type="button" class="pw-act-kebab-btn" title="Options">&#8942;</button>
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

            </div><!-- end pwActivitiesOnlyView -->

        </div><!-- end pw-container -->
    </main>
</div><!-- end pw-layout -->

<!-- ============================================================ -->
<!-- MODAL: Add Academic Goal                                      -->
<!-- ============================================================ -->
<div class="pw-modal-overlay" id="goalModalOverlay">
    <div class="pw-modal">
        <h3>
            <span>&#127919; Add Academic Goal</span>
            <button class="pw-modal-close" onclick="closeGoalModal()">&#10005;</button>
        </h3>
        <form method="post" action="${pageContext.request.contextPath}/progress">
            <input type="hidden" name="action" value="addGoal">
            <div class="pw-form-group">
                <label for="goalTitle">Goal Title *</label>
                <input type="text" id="goalTitle" name="goalTitle" placeholder="e.g. Complete DBMS Assignment" required maxlength="200">
            </div>
            <div class="pw-form-group">
                <label for="goalType">Goal Type</label>
                <select id="goalType" name="goalType">
                    <option value="TASK_COMPLETION">Task Completion</option>
                    <option value="STUDY_HOURS">Study Hours</option>
                    <option value="SUBJECT_MASTERY">Subject Mastery</option>
                    <option value="STREAK">Study Streak</option>
                </select>
            </div>
            <div class="pw-form-group">
                <label for="targetValue">Target Value * (hours/tasks)</label>
                <input type="number" id="targetValue" name="targetValue" placeholder="e.g. 20" min="1" required>
            </div>
            <div class="pw-modal-actions">
                <button type="button" class="btn btn-secondary" onclick="closeGoalModal()">Cancel</button>
                <button type="submit" class="btn btn-primary">&#10003; Save Goal</button>
            </div>
        </form>
    </div>
</div>

<script>
// Modal toggle functions
function openGoalModal() {
    document.getElementById('goalModalOverlay').classList.add('open');
}
function closeGoalModal() {
    document.getElementById('goalModalOverlay').classList.remove('open');
}
document.getElementById('goalModalOverlay').addEventListener('click', function(e) {
    if (e.target === this) closeGoalModal();
});

// Dropdown toggle function
function toggleDropdown(id, event) {
    if (event) {
        event.stopPropagation();
    }
    var all = document.querySelectorAll('.pw-dropdown-menu');
    all.forEach(function(m) {
        if (m.id !== id) m.classList.remove('open');
    });
    var menu = document.getElementById(id);
    if (menu) {
        menu.classList.toggle('open');
    }
}

// Close dropdowns on outside click or Esc
document.addEventListener('click', function(e) {
    if (!e.target.closest('.pw-dropdown-wrapper')) {
        document.querySelectorAll('.pw-dropdown-menu').forEach(function(m) {
            m.classList.remove('open');
        });
    }
});

document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') {
        document.querySelectorAll('.pw-dropdown-menu').forEach(function(m) {
            m.classList.remove('open');
        });
        closeGoalModal();
    }
});

// ============================================================
// 1. Study Hours Period Filter (This Week / Last Week / Month)
// ============================================================
var studyHoursData = {
    'this_week': {
        subtitle: 'Your daily study time for the past week',
        yaxis: ['8h', '6h', '4h', '2h', '0h'],
        bars: [
            { day: 'Mon', val: '4.5h', pct: 56.25 },
            { day: 'Tue', val: '3.0h', pct: 37.5 },
            { day: 'Wed', val: '5.0h', pct: 62.5 },
            { day: 'Thu', val: '2.5h', pct: 31.25 },
            { day: 'Fri', val: '6.0h', pct: 75.0 },
            { day: 'Sat', val: '4.0h', pct: 50.0 },
            { day: 'Sun', val: '3.5h', pct: 43.75 }
        ]
    },
    'last_week': {
        subtitle: 'Your daily study time for the previous week',
        yaxis: ['8h', '6h', '4h', '2h', '0h'],
        bars: [
            { day: 'Mon', val: '3.5h', pct: 43.75 },
            { day: 'Tue', val: '4.0h', pct: 50.0 },
            { day: 'Wed', val: '3.0h', pct: 37.5 },
            { day: 'Thu', val: '4.5h', pct: 56.25 },
            { day: 'Fri', val: '5.0h', pct: 62.5 },
            { day: 'Sat', val: '3.0h', pct: 37.5 },
            { day: 'Sun', val: '2.0h', pct: 25.0 }
        ]
    },
    'month': {
        subtitle: 'Weekly study time over the last 30 days',
        yaxis: ['25h', '20h', '15h', '10h', '0h'],
        bars: [
            { day: 'W1', val: '16.5h', pct: 66.0 },
            { day: 'W2', val: '19.0h', pct: 76.0 },
            { day: 'W3', val: '15.5h', pct: 62.0 },
            { day: 'W4', val: '22.0h', pct: 88.0 },
            { day: 'W5', val: '18.5h', pct: 74.0 }
        ]
    }
};

function setStudyHoursPeriod(key, label) {
    document.getElementById('studyHoursSelected').textContent = label;
    var d = studyHoursData[key];
    if (!d) return;

    document.getElementById('studyHoursSubtitle').textContent = d.subtitle;

    // Update Y-axis scale
    var yaxis = document.getElementById('studyHoursYAxis');
    if (yaxis) {
        yaxis.innerHTML = d.yaxis.map(function(y) { return '<span>' + y + '</span>'; }).join('');
    }

    // Update Bars
    var barsContainer = document.getElementById('studyHoursBars');
    if (barsContainer) {
        barsContainer.innerHTML = d.bars.map(function(b) {
            return '<div class="pw-bar-col">' +
                   '  <span class="pw-bar-val">' + b.val + '</span>' +
                   '  <div class="pw-bar-body" style="height: ' + b.pct + '%;"></div>' +
                   '  <span class="pw-bar-day">' + b.day + '</span>' +
                   '</div>';
        }).join('');
    }

    // Mark active in dropdown
    var items = document.querySelectorAll('#studyHoursDropdown .pw-dropdown-item');
    items.forEach(function(item) {
        if (item.getAttribute('data-period') === key) {
            item.classList.add('active');
        } else {
            item.classList.remove('active');
        }
    });

    document.getElementById('studyHoursDropdown').classList.remove('open');
}

// ============================================================
// 2. Task Completion Rate Filter (This Month / Week / Semester)
// ============================================================
var taskRateData = {
    'month': {
        subtitle: 'Overview of your task status this month',
        pct: '75%',
        offset: 94.25,
        completed: '24 (75%)',
        pending: '6 (18%)',
        overdue: '2 (7%)'
    },
    'week': {
        subtitle: 'Overview of your task status this week',
        pct: '83%',
        offset: 64.09,
        completed: '10 (83%)',
        pending: '2 (17%)',
        overdue: '0 (0%)'
    },
    'semester': {
        subtitle: 'Overview of all semester tasks',
        pct: '88%',
        offset: 45.24,
        completed: '62 (88%)',
        pending: '6 (9%)',
        overdue: '2 (3%)'
    }
};

function setTaskRatePeriod(key, label) {
    document.getElementById('taskRateSelected').textContent = label;
    var d = taskRateData[key];
    if (!d) return;

    document.getElementById('taskRateSubtitle').textContent = d.subtitle;
    document.getElementById('taskRatePctText').textContent = d.pct;
    var circle = document.getElementById('taskRateDonutCircle');
    if (circle) circle.style.strokeDashoffset = d.offset;

    document.getElementById('taskRateLegendCompleted').textContent = d.completed;
    document.getElementById('taskRateLegendPending').textContent = d.pending;
    document.getElementById('taskRateLegendOverdue').textContent = d.overdue;

    var items = document.querySelectorAll('#taskRateDropdown .pw-dropdown-item');
    items.forEach(function(item) {
        if (item.getAttribute('data-period') === key) {
            item.classList.add('active');
        } else {
            item.classList.remove('active');
        }
    });

    document.getElementById('taskRateDropdown').classList.remove('open');
}

// ============================================================
// 3. Subject-wise Progress Filter (This Semester / Month / All)
// ============================================================
var subjectData = {
    'semester': {
        subtitle: 'Your progress in each subject this semester',
        subjects: {
            DS: { pct: '85%' },
            DB: { pct: '70%' },
            OS: { pct: '60%' },
            CN: { pct: '50%' },
            SE: { pct: '65%' },
            Math: { pct: '75%' }
        }
    },
    'month': {
        subtitle: 'Your progress in each subject this month',
        subjects: {
            DS: { pct: '92%' },
            DB: { pct: '80%' },
            OS: { pct: '68%' },
            CN: { pct: '58%' },
            SE: { pct: '74%' },
            Math: { pct: '84%' }
        }
    },
    'all_time': {
        subtitle: 'Your cumulative progress across all terms',
        subjects: {
            DS: { pct: '80%' },
            DB: { pct: '75%' },
            OS: { pct: '64%' },
            CN: { pct: '54%' },
            SE: { pct: '62%' },
            Math: { pct: '72%' }
        }
    }
};

function setSubjectPeriod(key, label) {
    document.getElementById('subjectProgressSelected').textContent = label;
    var d = subjectData[key];
    if (!d) return;

    document.getElementById('subjectProgressSubtitle').textContent = d.subtitle;

    for (var code in d.subjects) {
        var bar = document.getElementById('subBar' + code);
        var txt = document.getElementById('subPct' + code);
        if (bar) bar.style.width = d.subjects[code].pct;
        if (txt) txt.textContent = d.subjects[code].pct;
    }

    var items = document.querySelectorAll('#subjectProgressDropdown .pw-dropdown-item');
    items.forEach(function(item) {
        if (item.getAttribute('data-period') === key) {
            item.classList.add('active');
        } else {
            item.classList.remove('active');
        }
    });

    document.getElementById('subjectProgressDropdown').classList.remove('open');
}

// ============================================================
// ============================================================
// 4. Dedicated Recent Activities View (Toggle, Tabs, Pagination, Search)
// ============================================================
var currentActFilter = 'all';
var currentActPage = 1;
var totalActPages = 3;
var currentActSearch = '';

function showOnlyRecentActivities() {
    var dash = document.getElementById('pwDashboardView');
    var actView = document.getElementById('pwActivitiesOnlyView');
    if (dash && actView) {
        dash.style.display = 'none';
        actView.style.display = 'block';
        window.scrollTo({ top: 0, behavior: 'smooth' });
        history.replaceState(null, null, '#recent-activities');
    }
}

function showDashboardView() {
    var dash = document.getElementById('pwDashboardView');
    var actView = document.getElementById('pwActivitiesOnlyView');
    if (dash && actView) {
        actView.style.display = 'none';
        dash.style.display = 'block';
        window.scrollTo({ top: 0, behavior: 'smooth' });
        history.replaceState(null, null, window.location.pathname);
    }
}

window.addEventListener('DOMContentLoaded', function() {
    if (window.location.hash === '#recent-activities') {
        showOnlyRecentActivities();
    }
});

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
    var actView = document.getElementById('pwActivitiesOnlyView');
    if (actView && actView.style.display !== 'none') {
        applyActivityFilters();
    }
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
</script>

</body>
</html>
