<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
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
    <title>Today's Timetable &mdash; SlotWise</title>
    <meta name="description" content="Your complete schedule, tasks and free time for today. Stay on track with SlotWise.">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg-app: #060913;
            --bg-sidebar: #080d1a;
            --bg-card: #0b1120;
            --bg-card-inner: #0f172a;
            --border-subtle: rgba(255, 255, 255, 0.06);
            --border-hover: rgba(255, 255, 255, 0.12);
            --primary-purple: #6366f1;
            --primary-purple-hover: #4f46e5;
            --primary-purple-glow: rgba(99, 102, 241, 0.35);
            --accent-pink: #ec4899;
            --accent-cyan: #38bdf8;
            --accent-emerald: #10b981;
            --accent-amber: #f59e0b;
            --accent-rose: #f43f5e;
            --text-white: #ffffff;
            --text-primary: #f1f5f9;
            --text-muted: #8492a6;
            --text-dim: #475569;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            background-color: var(--bg-app);
            color: var(--text-primary);
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            margin: 0;
            padding: 0;
            overflow-x: hidden;
            -webkit-font-smoothing: antialiased;
        }

        .sw-layout {
            display: flex;
            min-height: 100vh;
            background-color: var(--bg-app);
            position: relative;
        }

        /* Ambient subtle wave glow at bottom left */
        .sw-layout::before {
            content: '';
            position: fixed;
            bottom: -160px;
            left: -160px;
            width: 550px;
            height: 550px;
            background: radial-gradient(circle, rgba(99, 102, 241, 0.15) 0%, rgba(139, 92, 246, 0.08) 40%, transparent 70%);
            pointer-events: none;
            z-index: 0;
        }

        /* ======================================================== */
        /* SIDEBAR NAVIGATION                                       */
        /* ======================================================== */
        .sw-sidebar {
            width: 240px;
            min-width: 240px;
            background-color: var(--bg-sidebar);
            border-right: 1px solid var(--border-subtle);
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

        .sw-logo {
            display: flex;
            align-items: center;
            gap: 12px;
            text-decoration: none;
            padding: 0 8px 24px;
        }

        .sw-logo-icon {
            width: 36px;
            height: 36px;
            background: linear-gradient(135deg, #6366f1 0%, #8b5cf6 100%);
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #ffffff;
            box-shadow: 0 4px 14px var(--primary-purple-glow);
        }

        .sw-logo-text {
            font-size: 1.25rem;
            font-weight: 700;
            color: #ffffff;
            letter-spacing: -0.02em;
        }
        .sw-logo-text span {
            color: #a78bfa;
        }

        .sw-nav {
            display: flex;
            flex-direction: column;
            gap: 5px;
            flex: 1;
            overflow-y: auto;
        }

        .sw-nav::-webkit-scrollbar {
            width: 4px;
        }
        .sw-nav::-webkit-scrollbar-thumb {
            background: rgba(255, 255, 255, 0.1);
            border-radius: 4px;
        }

        .sw-nav-item {
            display: flex;
            align-items: center;
            gap: 13px;
            padding: 10px 14px;
            border-radius: 10px;
            color: var(--text-muted);
            text-decoration: none;
            font-size: 0.88rem;
            font-weight: 500;
            transition: all 0.2s ease;
        }

        .sw-nav-item:hover {
            color: var(--text-white);
            background-color: rgba(255, 255, 255, 0.04);
        }

        .sw-nav-item.active {
            background: linear-gradient(135deg, #4f46e5 0%, #6366f1 100%);
            color: #ffffff;
            font-weight: 600;
            box-shadow: 0 4px 18px rgba(79, 70, 229, 0.4);
        }

        .sw-nav-item svg {
            width: 18px;
            height: 18px;
            stroke-width: 1.9;
            flex-shrink: 0;
        }

        .sw-sidebar-bottom {
            padding-top: 16px;
            border-top: 1px solid var(--border-subtle);
        }

        .sw-nav-item.logout {
            color: #94a3b8;
        }
        .sw-nav-item.logout:hover {
            color: #f43f5e;
            background-color: rgba(244, 63, 94, 0.08);
        }

        /* ======================================================== */
        /* MAIN VIEWPORT                                            */
        /* ======================================================== */
        .sw-main {
            flex: 1;
            display: flex;
            flex-direction: column;
            min-width: 0;
            background-color: var(--bg-app);
            position: relative;
            z-index: 1;
        }

        /* Top Bar */
        .sw-topbar {
            height: 70px;
            padding: 0 32px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 20px;
            border-bottom: 1px solid var(--border-subtle);
            background-color: var(--bg-app);
            position: sticky;
            top: 0;
            z-index: 15;
        }

        .sw-search-box {
            position: relative;
            width: 420px;
            max-width: 100%;
        }

        .sw-search-box input {
            width: 100%;
            height: 40px;
            background-color: rgba(255, 255, 255, 0.035);
            border: 1px solid var(--border-subtle);
            border-radius: 999px;
            padding: 0 20px 0 42px;
            color: var(--text-primary);
            font-size: 0.85rem;
            outline: none;
            transition: all 0.2s ease;
        }

        .sw-search-box input:focus {
            border-color: #6366f1;
            background-color: rgba(255, 255, 255, 0.06);
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.2);
        }

        .sw-search-box svg {
            position: absolute;
            left: 14px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-dim);
            width: 16px;
            height: 16px;
        }

        .sw-user-area {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .sw-bell-btn {
            position: relative;
            width: 38px;
            height: 38px;
            border-radius: 50%;
            background-color: rgba(255, 255, 255, 0.035);
            border: 1px solid var(--border-subtle);
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--text-muted);
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .sw-bell-btn:hover {
            color: var(--text-white);
            background-color: rgba(255, 255, 255, 0.08);
        }

        .sw-bell-dot {
            position: absolute;
            top: 8px;
            right: 9px;
            width: 7px;
            height: 7px;
            background-color: #f43f5e;
            border-radius: 50%;
            box-shadow: 0 0 6px #f43f5e;
        }

        .sw-profile-pill {
            display: flex;
            align-items: center;
            gap: 12px;
            text-decoration: none;
        }

        .sw-avatar {
            width: 38px;
            height: 38px;
            border-radius: 50%;
            background: linear-gradient(135deg, #f59e0b 0%, #ec4899 50%, #6366f1 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            color: #ffffff;
            font-size: 0.85rem;
            border: 2px solid rgba(255, 255, 255, 0.15);
        }

        .sw-profile-info {
            display: flex;
            flex-direction: column;
            line-height: 1.25;
        }

        .sw-profile-name {
            font-size: 0.88rem;
            font-weight: 600;
            color: var(--text-white);
        }

        .sw-profile-role {
            font-size: 0.74rem;
            color: var(--text-muted);
        }

        /* Container */
        .sw-content-wrap {
            padding: 24px 32px 40px;
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        /* Header Row */
        .sw-page-header {
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            gap: 20px;
            flex-wrap: wrap;
        }

        .sw-back-link {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            color: var(--text-muted);
            text-decoration: none;
            font-size: 0.82rem;
            margin-bottom: 8px;
            transition: color 0.2s ease;
        }

        .sw-back-link:hover {
            color: var(--text-white);
        }

        .sw-page-title {
            font-size: 1.85rem;
            font-weight: 800;
            color: #ffffff;
            letter-spacing: -0.02em;
            margin-bottom: 4px;
        }

        .sw-title-gradient {
            background: linear-gradient(135deg, #a855f7 0%, #c084fc 40%, #ec4899 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .sw-page-subtitle {
            font-size: 0.88rem;
            color: var(--text-muted);
        }

        .sw-header-actions {
            display: flex;
            align-items: center;
            gap: 14px;
            flex-wrap: wrap;
        }

        .sw-date-card {
            display: flex;
            align-items: center;
            gap: 12px;
            background-color: rgba(255, 255, 255, 0.03);
            border: 1px solid var(--border-subtle);
            border-radius: 12px;
            padding: 8px 16px;
        }

        .sw-date-icon {
            width: 32px;
            height: 32px;
            border-radius: 8px;
            background: rgba(99, 102, 241, 0.15);
            color: #818cf8;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .sw-date-day {
            font-size: 0.84rem;
            font-weight: 600;
            color: var(--text-white);
        }

        .sw-date-full {
            font-size: 0.74rem;
            color: var(--text-muted);
        }

        .sw-btn-todo {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: linear-gradient(135deg, #4f46e5 0%, #6366f1 100%);
            color: #ffffff;
            font-size: 0.85rem;
            font-weight: 600;
            padding: 9px 18px;
            border-radius: 10px;
            border: none;
            cursor: pointer;
            box-shadow: 0 4px 14px var(--primary-purple-glow);
            transition: all 0.2s ease;
        }

        .sw-btn-todo:hover {
            transform: translateY(-1px);
            box-shadow: 0 6px 20px rgba(99, 102, 241, 0.5);
        }

        .sw-btn-class {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: rgba(255, 255, 255, 0.035);
            border: 1px solid var(--border-subtle);
            color: var(--text-white);
            font-size: 0.85rem;
            font-weight: 500;
            padding: 9px 18px;
            border-radius: 10px;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .sw-btn-class:hover {
            background-color: rgba(255, 255, 255, 0.08);
            border-color: var(--border-hover);
        }

        /* View Switcher & Export Row */
        .sw-view-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
        }

        .sw-segmented-tabs {
            display: inline-flex;
            align-items: center;
            background: rgba(255, 255, 255, 0.03);
            border: 1px solid var(--border-subtle);
            border-radius: 10px;
            padding: 4px;
            gap: 4px;
        }

        .sw-seg-btn {
            background: transparent;
            border: none;
            color: var(--text-muted);
            font-size: 0.82rem;
            font-weight: 500;
            padding: 7px 18px;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .sw-seg-btn:hover {
            color: var(--text-white);
        }

        .sw-seg-btn.active {
            background: #4f46e5;
            color: #ffffff;
            font-weight: 600;
            box-shadow: 0 2px 10px rgba(79, 70, 229, 0.4);
        }

        .sw-export-btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: transparent;
            border: none;
            color: var(--text-muted);
            font-size: 0.84rem;
            font-weight: 500;
            cursor: pointer;
            padding: 6px 12px;
            border-radius: 8px;
            transition: all 0.2s ease;
        }

        .sw-export-btn:hover {
            color: var(--text-white);
            background: rgba(255, 255, 255, 0.04);
        }

        /* Two-Column Grid Layout */
        .sw-two-col-grid {
            display: grid;
            grid-template-columns: 1fr 340px;
            gap: 24px;
            align-items: start;
        }

        @media (max-width: 1200px) {
            .sw-two-col-grid {
                grid-template-columns: 1fr;
            }
        }

        /* ======================================================== */
        /* LEFT COLUMN: TIMELINE & FREE TIME INSIGHTS               */
        /* ======================================================== */
        .sw-left-col {
            display: flex;
            flex-direction: column;
            gap: 24px;
        }

        .sw-timeline-container {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        .sw-timeline-row {
            display: flex;
            align-items: center;
            gap: 16px;
            position: relative;
        }

        .sw-tl-time {
            width: 72px;
            font-size: 0.74rem;
            font-weight: 600;
            color: var(--text-muted);
            text-align: right;
            font-family: 'JetBrains Mono', monospace;
            flex-shrink: 0;
        }

        .sw-tl-node-col {
            position: relative;
            display: flex;
            flex-direction: column;
            align-items: center;
            width: 16px;
            flex-shrink: 0;
            align-self: stretch;
            justify-content: center;
        }

        .sw-tl-node-col::before {
            content: '';
            position: absolute;
            top: 0;
            bottom: 0;
            width: 2px;
            background: rgba(255, 255, 255, 0.07);
            z-index: 1;
        }

        .sw-tl-dot {
            width: 9px;
            height: 9px;
            border-radius: 50%;
            z-index: 2;
            background: #475569;
            box-shadow: 0 0 0 3px var(--bg-app);
            flex-shrink: 0;
        }

        .sw-tl-dot.blue { background: #38bdf8; box-shadow: 0 0 8px #38bdf8; }
        .sw-tl-dot.cyan { background: #06b6d4; box-shadow: 0 0 8px #06b6d4; }
        .sw-tl-dot.purple { background: #818cf8; }
        .sw-tl-dot.green { background: #10b981; box-shadow: 0 0 8px #10b981; }
        .sw-tl-dot.orange { background: #f97316; box-shadow: 0 0 8px #f97316; }

        /* The Event Card */
        .sw-tl-card {
            flex: 1;
            background: var(--bg-card);
            border: 1px solid var(--border-subtle);
            border-radius: 12px;
            padding: 10px 16px;
            display: flex;
            align-items: center;
            gap: 16px;
            transition: all 0.2s ease;
        }

        .sw-tl-card:hover {
            border-color: var(--border-hover);
            background: rgba(255, 255, 255, 0.035);
            transform: translateY(-1px);
        }

        .sw-tl-card.free-slot {
            border: 1px dashed rgba(16, 185, 129, 0.35);
            background: rgba(16, 185, 129, 0.025);
        }

        .sw-tl-card.task-slot {
            border: 1px dashed rgba(249, 115, 22, 0.35);
            background: rgba(249, 115, 22, 0.025);
        }

        .sw-card-timepill {
            font-size: 0.75rem;
            font-weight: 600;
            color: #94a3b8;
            background: rgba(255, 255, 255, 0.035);
            padding: 6px 12px;
            border-radius: 8px;
            white-space: nowrap;
            font-family: 'JetBrains Mono', monospace;
            border: 1px solid rgba(255, 255, 255, 0.04);
        }

        .sw-card-timepill.ongoing {
            background: rgba(56, 189, 248, 0.15);
            color: #38bdf8;
            border-color: rgba(56, 189, 248, 0.3);
            font-weight: 700;
        }

        .sw-card-icon {
            width: 38px;
            height: 38px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
            background: rgba(255, 255, 255, 0.04);
            color: #cbd5e1;
        }

        .sw-card-icon.blue-bg { background: rgba(56, 189, 248, 0.12); color: #38bdf8; }
        .sw-card-icon.purple-bg { background: rgba(99, 102, 241, 0.15); color: #818cf8; }
        .sw-card-icon.green-bg { background: rgba(16, 185, 129, 0.15); color: #10b981; }
        .sw-card-icon.orange-bg { background: rgba(249, 115, 22, 0.15); color: #fb923c; }

        .sw-card-info {
            flex: 1;
            min-width: 0;
        }

        .sw-card-title {
            font-size: 0.92rem;
            font-weight: 600;
            color: #ffffff;
            margin-bottom: 2px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .sw-card-sub {
            font-size: 0.76rem;
            color: var(--text-muted);
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        /* Status Badges */
        .sw-status-badge {
            font-size: 0.72rem;
            font-weight: 600;
            padding: 4px 10px;
            border-radius: 999px;
            white-space: nowrap;
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }

        .sw-status-badge.completed {
            background: rgba(16, 185, 129, 0.1);
            color: #10b981;
            border: 1px solid rgba(16, 185, 129, 0.25);
        }

        .sw-status-badge.ongoing {
            background: rgba(56, 189, 248, 0.12);
            color: #38bdf8;
            border: 1px solid rgba(56, 189, 248, 0.3);
        }

        .sw-status-badge.upcoming {
            background: rgba(139, 92, 246, 0.12);
            color: #a78bfa;
            border: 1px solid rgba(139, 92, 246, 0.25);
        }

        .sw-status-badge.break {
            background: rgba(148, 163, 184, 0.08);
            color: #94a3b8;
            border: 1px solid rgba(148, 163, 184, 0.15);
        }

        .sw-status-badge.free {
            background: rgba(16, 185, 129, 0.15);
            color: #34d399;
            border: 1px solid rgba(16, 185, 129, 0.3);
        }

        .sw-status-badge.pending {
            background: rgba(249, 115, 22, 0.12);
            color: #fb923c;
            border: 1px solid rgba(249, 115, 22, 0.25);
        }

        .sw-status-badge.personal {
            background: rgba(148, 163, 184, 0.08);
            color: #94a3b8;
            border: 1px solid rgba(148, 163, 184, 0.15);
        }

        .sw-kebab-btn {
            background: transparent;
            border: none;
            color: var(--text-dim);
            cursor: pointer;
            padding: 4px 6px;
            border-radius: 6px;
            font-size: 1.1rem;
            transition: all 0.2s ease;
        }

        .sw-kebab-btn:hover {
            color: var(--text-white);
            background: rgba(255, 255, 255, 0.05);
        }

        /* ---------------- Free Time Insights Card ---------------- */
        .sw-insights-card {
            background: var(--bg-card);
            border: 1px solid var(--border-subtle);
            border-radius: 16px;
            padding: 20px 22px;
            display: flex;
            flex-direction: column;
            gap: 18px;
        }

        .sw-insights-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
        }

        .sw-insights-title-grp {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .sw-insights-icon {
            width: 36px;
            height: 36px;
            border-radius: 10px;
            background: rgba(99, 102, 241, 0.15);
            color: #818cf8;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .sw-insights-title {
            font-size: 0.98rem;
            font-weight: 700;
            color: #ffffff;
        }

        .sw-insights-sub {
            font-size: 0.78rem;
            color: var(--text-muted);
            margin-top: 1px;
        }

        .sw-find-slot-btn {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: linear-gradient(135deg, #4f46e5 0%, #6366f1 100%);
            color: #ffffff;
            font-size: 0.82rem;
            font-weight: 600;
            padding: 8px 16px;
            border-radius: 999px;
            border: none;
            cursor: pointer;
            box-shadow: 0 3px 12px var(--primary-purple-glow);
            transition: all 0.2s ease;
        }

        .sw-find-slot-btn:hover {
            transform: translateY(-1px);
            box-shadow: 0 5px 18px rgba(99, 102, 241, 0.5);
        }

        .sw-slots-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 14px;
        }

        @media (max-width: 768px) {
            .sw-slots-grid {
                grid-template-columns: 1fr;
            }
        }

        .sw-slot-box {
            background: var(--bg-card-inner);
            border: 1px solid var(--border-subtle);
            border-radius: 12px;
            padding: 14px 16px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            transition: all 0.2s ease;
        }

        .sw-slot-box:hover {
            border-color: var(--border-hover);
            transform: translateY(-2px);
        }

        .sw-slot-left {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .sw-slot-icon {
            width: 20px;
            height: 20px;
            flex-shrink: 0;
        }
        .sw-slot-icon.purple { color: #a78bfa; }
        .sw-slot-icon.teal { color: #2dd4bf; }
        .sw-slot-icon.blue { color: #38bdf8; }

        .sw-slot-range {
            font-size: 0.8rem;
            font-weight: 600;
            color: #ffffff;
            font-family: 'JetBrains Mono', monospace;
        }

        .sw-slot-duration {
            font-size: 0.72rem;
            color: var(--text-muted);
            margin-top: 2px;
        }

        .sw-slot-btn {
            background: rgba(99, 102, 241, 0.2);
            color: #c7d2fe;
            border: 1px solid rgba(99, 102, 241, 0.35);
            font-size: 0.74rem;
            font-weight: 600;
            padding: 5px 12px;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.2s ease;
            white-space: nowrap;
        }

        .sw-slot-btn:hover {
            background: #4f46e5;
            color: #ffffff;
            border-color: #4f46e5;
        }

        /* ======================================================== */
        /* RIGHT COLUMN: CALENDAR, TO-DO LIST & DAILY SUMMARY       */
        /* ======================================================== */
        .sw-right-col {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .sw-widget-card {
            background: var(--bg-card);
            border: 1px solid var(--border-subtle);
            border-radius: 16px;
            padding: 18px 20px;
        }

        /* ---------------- 1. Calendar Widget ---------------- */
        .sw-cal-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 16px;
        }

        .sw-cal-month {
            font-size: 0.95rem;
            font-weight: 700;
            color: #ffffff;
        }

        .sw-cal-nav {
            display: flex;
            gap: 6px;
        }

        .sw-cal-nav-btn {
            width: 28px;
            height: 28px;
            border-radius: 6px;
            background: rgba(255, 255, 255, 0.04);
            border: 1px solid var(--border-subtle);
            color: var(--text-muted);
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .sw-cal-nav-btn:hover {
            color: #ffffff;
            background: rgba(255, 255, 255, 0.08);
        }

        .sw-cal-weekdays {
            display: grid;
            grid-template-columns: repeat(7, 1fr);
            text-align: center;
            margin-bottom: 8px;
        }

        .sw-cal-weekday {
            font-size: 0.72rem;
            font-weight: 600;
            color: var(--text-muted);
            padding: 4px 0;
        }

        .sw-cal-grid {
            display: grid;
            grid-template-columns: repeat(7, 1fr);
            row-gap: 6px;
            text-align: center;
        }

        .sw-cal-day {
            position: relative;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            height: 32px;
            font-size: 0.78rem;
            color: #cbd5e1;
            border-radius: 50%;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .sw-cal-day:hover:not(.empty):not(.selected) {
            background: rgba(255, 255, 255, 0.06);
            color: #ffffff;
        }

        .sw-cal-day.muted {
            color: #475569;
        }

        .sw-cal-day.selected {
            background: #6366f1;
            color: #ffffff;
            font-weight: 700;
            box-shadow: 0 2px 10px rgba(99, 102, 241, 0.45);
        }

        .sw-cal-dot-container {
            display: flex;
            gap: 2px;
            position: absolute;
            bottom: 2px;
        }

        .sw-cal-marker {
            width: 4px;
            height: 4px;
            border-radius: 50%;
        }
        .sw-cal-marker.cyan { background: #38bdf8; }
        .sw-cal-marker.pink { background: #f43f5e; }

        /* ---------------- 2. Today's To-Do List Widget ---------------- */
        .sw-todo-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 14px;
        }

        .sw-todo-title-grp {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 0.95rem;
            font-weight: 700;
            color: #ffffff;
        }

        .sw-todo-add-link {
            color: #a78bfa;
            text-decoration: none;
            font-size: 0.8rem;
            font-weight: 600;
            cursor: pointer;
            transition: color 0.2s ease;
        }

        .sw-todo-add-link:hover {
            color: #c4b5fd;
        }

        .sw-todo-tabs {
            display: flex;
            align-items: center;
            gap: 6px;
            margin-bottom: 14px;
        }

        .sw-todo-tab {
            background: rgba(255, 255, 255, 0.035);
            border: 1px solid var(--border-subtle);
            border-radius: 999px;
            color: var(--text-muted);
            font-size: 0.74rem;
            font-weight: 600;
            padding: 5px 12px;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .sw-todo-tab:hover {
            color: #ffffff;
            background: rgba(255, 255, 255, 0.06);
        }

        .sw-todo-tab.active {
            background: #4f46e5;
            color: #ffffff;
            border-color: #4f46e5;
            box-shadow: 0 2px 8px rgba(79, 70, 229, 0.35);
        }

        .sw-todo-list {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .sw-todo-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 10px;
            padding: 8px 10px;
            border-radius: 10px;
            background: rgba(255, 255, 255, 0.02);
            transition: all 0.2s ease;
        }

        .sw-todo-item:hover {
            background: rgba(255, 255, 255, 0.04);
        }

        .sw-todo-left {
            display: flex;
            align-items: center;
            gap: 10px;
            flex: 1;
            min-width: 0;
        }

        .sw-todo-check {
            width: 17px;
            height: 17px;
            border-radius: 50%;
            border: 2px solid #64748b;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
            transition: all 0.2s ease;
        }

        .sw-todo-check:hover {
            border-color: #a78bfa;
        }

        .sw-todo-check.checked {
            background: #10b981;
            border-color: #10b981;
            color: #ffffff;
        }

        .sw-todo-name {
            font-size: 0.82rem;
            font-weight: 500;
            color: #f1f5f9;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            transition: all 0.2s ease;
        }

        .sw-todo-name.done {
            text-decoration: line-through;
            color: var(--text-dim);
        }

        .sw-todo-right {
            display: flex;
            align-items: center;
            gap: 8px;
            flex-shrink: 0;
        }

        .sw-priority-pill {
            font-size: 0.68rem;
            font-weight: 700;
            padding: 2px 7px;
            border-radius: 4px;
        }
        .sw-priority-pill.high { background: rgba(244, 63, 94, 0.15); color: #f43f5e; }
        .sw-priority-pill.medium { background: rgba(245, 158, 11, 0.15); color: #f59e0b; }
        .sw-priority-pill.low { background: rgba(56, 189, 248, 0.15); color: #38bdf8; }

        .sw-todo-due {
            font-size: 0.72rem;
            color: var(--text-muted);
            font-family: 'JetBrains Mono', monospace;
        }

        /* ---------------- 3. Daily Summary Widget ---------------- */
        .sw-summary-header {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 14px;
            font-size: 0.95rem;
            font-weight: 700;
            color: #ffffff;
        }

        .sw-summary-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
        }

        .sw-summary-tile {
            background: var(--bg-card-inner);
            border: 1px solid var(--border-subtle);
            border-radius: 12px;
            padding: 14px;
            display: flex;
            align-items: center;
            gap: 12px;
            transition: all 0.2s ease;
        }

        .sw-summary-tile:hover {
            border-color: var(--border-hover);
            transform: translateY(-1px);
        }

        .sw-sum-icon {
            width: 36px;
            height: 36px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }
        .sw-sum-icon.blue { background: rgba(56, 189, 248, 0.15); color: #38bdf8; }
        .sw-sum-icon.green { background: rgba(16, 185, 129, 0.15); color: #10b981; }
        .sw-sum-icon.orange { background: rgba(245, 158, 11, 0.15); color: #f59e0b; }
        .sw-sum-icon.red { background: rgba(244, 63, 94, 0.15); color: #f43f5e; }

        .sw-sum-num {
            font-size: 1.15rem;
            font-weight: 800;
            color: #ffffff;
            line-height: 1.1;
        }

        .sw-sum-lbl {
            font-size: 0.74rem;
            color: var(--text-muted);
            margin-top: 1px;
        }

        /* Modal / Toast Styles */
        .sw-modal-backdrop {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100vw;
            height: 100vh;
            background: rgba(0, 0, 0, 0.65);
            backdrop-filter: blur(4px);
            z-index: 999;
            align-items: center;
            justify-content: center;
        }

        .sw-modal-box {
            background: #0d1424;
            border: 1px solid rgba(255, 255, 255, 0.12);
            border-radius: 16px;
            width: 440px;
            max-width: 90vw;
            padding: 24px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.8);
        }

        .sw-toast {
            position: fixed;
            bottom: 24px;
            right: 24px;
            background: #1e1b4b;
            color: #ffffff;
            border: 1px solid #6366f1;
            padding: 12px 20px;
            border-radius: 10px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.5);
            font-size: 0.86rem;
            display: flex;
            align-items: center;
            gap: 10px;
            transform: translateY(100px);
            opacity: 0;
            transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
            z-index: 1000;
        }

        .sw-toast.show {
            transform: translateY(0);
            opacity: 1;
        }
    </style>
</head>
<body>

<div class="sw-layout">
    <!-- ======================================================== -->
    <!-- SIDEBAR NAVIGATION                                       -->
    <!-- ======================================================== -->
    <aside class="sw-sidebar">
        <div>
            <!-- Logo -->
            <a href="${pageContext.request.contextPath}/dashboard" class="sw-logo">
                <div class="sw-logo-icon">
                    <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                        <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                        <line x1="16" y1="2" x2="16" y2="6"></line>
                        <line x1="8" y1="2" x2="8" y2="6"></line>
                        <line x1="3" y1="10" x2="21" y2="10"></line>
                        <path d="M8 14h.01M12 14h.01M16 14h.01M8 18h.01M12 18h.01M16 18h.01"></path>
                    </svg>
                </div>
                <div class="sw-logo-text">Slot<span>Wise</span></div>
            </a>

            <!-- Navigation Links -->
            <nav class="sw-nav">
                <!-- Dashboard -->
                <a href="${pageContext.request.contextPath}/dashboard" class="sw-nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path>
                        <polyline points="9 22 9 12 15 12 15 22"></polyline>
                    </svg>
                    <span>Dashboard</span>
                </a>

                <!-- Timetable (ACTIVE) -->
                <a href="${pageContext.request.contextPath}/timetable" class="sw-nav-item active">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round">
                        <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                        <line x1="16" y1="2" x2="16" y2="6"></line>
                        <line x1="8" y1="2" x2="8" y2="6"></line>
                        <line x1="3" y1="10" x2="21" y2="10"></line>
                    </svg>
                    <span>Timetable</span>
                </a>

                <!-- My Tasks -->
                <a href="${pageContext.request.contextPath}/my-tasks.jsp" class="sw-nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round">
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
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round">
                        <line x1="18" y1="20" x2="18" y2="10"></line>
                        <line x1="12" y1="20" x2="12" y2="4"></line>
                        <line x1="6" y1="20" x2="6" y2="14"></line>
                    </svg>
                    <span>Progress</span>
                </a>

                <!-- Materials -->
                <a href="${pageContext.request.contextPath}/materials" class="sw-nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path>
                        <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path>
                    </svg>
                    <span>Materials</span>
                </a>

                <!-- Study Groups -->
                <a href="${pageContext.request.contextPath}/study-groups.jsp" class="sw-nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                        <circle cx="9" cy="7" r="4"></circle>
                        <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                        <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                    </svg>
                    <span>Study Groups</span>
                </a>

                <!-- Smart Rescheduler -->
                <a href="${pageContext.request.contextPath}/rescheduler" class="sw-nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M21.5 2v6h-6"></path>
                        <path d="M2.5 12A10 10 0 0 1 20.5 6.3L21.5 8"></path>
                        <path d="M2.5 22v-6h6"></path>
                        <path d="M21.5 12A10 10 0 0 1 3.5 17.7L2.5 16"></path>
                    </svg>
                    <span>Smart Rescheduler</span>
                </a>

                <!-- Deadline Radar -->
                <a href="${pageContext.request.contextPath}/deadlines" class="sw-nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="12" cy="12" r="2"></circle>
                        <path d="M16.24 7.76a6 6 0 0 1 0 8.49m-8.48-.01a6 6 0 0 1 0-8.49m11.31-2.82a10 10 0 0 1 0 14.14m-14.14 0a10 10 0 0 1 0-14.14"></path>
                    </svg>
                    <span>Deadline Radar</span>
                </a>

                <!-- Goals -->
                <a href="${pageContext.request.contextPath}/goals.jsp" class="sw-nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
                    </svg>
                    <span>Goals</span>
                </a>

                <!-- Settings -->
                <a href="${pageContext.request.contextPath}/settings" class="sw-nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="12" cy="12" r="3"></circle>
                        <path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z"></path>
                    </svg>
                    <span>Settings</span>
                </a>
            </nav>
        </div>

        <!-- Sidebar Bottom Logout -->
        <div class="sw-sidebar-bottom">
            <a href="${pageContext.request.contextPath}/logout" class="sw-nav-item logout">
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
    <!-- MAIN CONTENT VIEWPORT                                    -->
    <!-- ======================================================== -->
    <main class="sw-main">
        <!-- Topbar -->
        <header class="sw-topbar">
            <!-- Search -->
            <div class="sw-search-box">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                    <circle cx="11" cy="11" r="8"></circle>
                    <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                </svg>
                <input type="text" placeholder="Search classes, tasks, subjects..." id="globalSearch">
            </div>

            <!-- Profile & Notifications -->
            <div class="sw-user-area">
                <div class="sw-bell-btn" title="Notifications" onclick="showToast('No new unread notifications')">
                    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"></path>
                        <path d="M13.73 21a2 2 0 0 1-3.46 0"></path>
                    </svg>
                    <span class="sw-bell-dot"></span>
                </div>

                <a href="${pageContext.request.contextPath}/settings" class="sw-profile-pill">
                    <div class="sw-avatar">HM</div>
                    <div class="sw-profile-info">
                        <span class="sw-profile-name">Harish M</span>
                        <span class="sw-profile-role">CSE - 2nd Year</span>
                    </div>
                </a>
            </div>
        </header>

        <!-- Main Body Wrapper -->
        <div class="sw-content-wrap">
            <!-- Header Section -->
            <div class="sw-page-header">
                <div>
                    <a href="${pageContext.request.contextPath}/dashboard" class="sw-back-link">
                        <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <line x1="19" y1="12" x2="5" y2="12"></line>
                            <polyline points="12 19 5 12 12 5"></polyline>
                        </svg>
                        <span>Back to Dashboard</span>
                    </a>
                    <h1 class="sw-page-title">Today's <span class="sw-title-gradient">Timetable</span></h1>
                    <p class="sw-page-subtitle">Your complete schedule, tasks and free time for today.</p>
                </div>

                <!-- Right Action Buttons -->
                <div class="sw-header-actions">
                    <div class="sw-date-card">
                        <div class="sw-date-icon">
                            <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                <line x1="16" y1="2" x2="16" y2="6"></line>
                                <line x1="8" y1="2" x2="8" y2="6"></line>
                                <line x1="3" y1="10" x2="21" y2="10"></line>
                            </svg>
                        </div>
                        <div>
                            <div class="sw-date-day">Sunday</div>
                            <div class="sw-date-full">12 October 2026</div>
                        </div>
                    </div>

                    <button class="sw-btn-todo" onclick="openModal('Add To-Do', 'Schedule a new study or personal task for today')">
                        <span>+</span>
                        <span>Add To-Do</span>
                    </button>

                    <button class="sw-btn-class" onclick="openModal('Add Class', 'Add a lecture, lab, or tutorial session to your timetable')">
                        <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                            <line x1="16" y1="2" x2="16" y2="6"></line>
                            <line x1="8" y1="2" x2="8" y2="6"></line>
                            <line x1="3" y1="10" x2="21" y2="10"></line>
                            <line x1="12" y1="13" x2="12" y2="17"></line>
                            <line x1="10" y1="15" x2="14" y2="15"></line>
                        </svg>
                        <span>Add Class</span>
                    </button>
                </div>
            </div>

            <!-- Segmented View Switcher & Export Row -->
            <div class="sw-view-row">
                <div class="sw-segmented-tabs">
                    <button class="sw-seg-btn active" id="tabTimeline" onclick="switchView('timeline')">Timeline View</button>
                    <button class="sw-seg-btn" id="tabList" onclick="switchView('list')">List View</button>
                    <button class="sw-seg-btn" id="tabSubject" onclick="switchView('subject')">Subject View</button>
                </div>

                <button class="sw-export-btn" onclick="exportDayPlan()">
                    <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path>
                        <polyline points="7 10 12 15 17 10"></polyline>
                        <line x1="12" y1="15" x2="12" y2="3"></line>
                    </svg>
                    <span>Export Day Plan</span>
                </button>
            </div>

            <!-- Main Two-Column Layout -->
            <div class="sw-two-col-grid">

                <!-- ---------------- LEFT COLUMN: TIMELINE & FREE TIME ---------------- -->
                <div class="sw-left-col">
                    <div class="sw-timeline-container" id="timelineListContainer">

                        <!-- Item 1: Data Structures -->
                        <div class="sw-timeline-row">
                            <div class="sw-tl-time">08:00 AM</div>
                            <div class="sw-tl-node-col"><div class="sw-tl-dot blue"></div></div>
                            <div class="sw-tl-card">
                                <div class="sw-card-timepill">08:00 AM - 09:00 AM</div>
                                <div class="sw-card-icon purple-bg">
                                    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                        <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path>
                                        <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path>
                                    </svg>
                                </div>
                                <div class="sw-card-info">
                                    <div class="sw-card-title">Data Structures</div>
                                    <div class="sw-card-sub">CS201 &bull; Main Block &bull; Room 302</div>
                                </div>
                                <span class="sw-status-badge completed">&#10003; Completed</span>
                                <button class="sw-kebab-btn" title="Options" onclick="openItemOptions('Data Structures')">&#8942;</button>
                            </div>
                        </div>

                        <!-- Item 2: Database Systems -->
                        <div class="sw-timeline-row">
                            <div class="sw-tl-time">09:00 AM</div>
                            <div class="sw-tl-node-col"><div class="sw-tl-dot cyan"></div></div>
                            <div class="sw-tl-card">
                                <div class="sw-card-timepill ongoing">09:00 AM - 10:00 AM</div>
                                <div class="sw-card-icon blue-bg">
                                    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                        <ellipse cx="12" cy="5" rx="9" ry="3"></ellipse>
                                        <path d="M21 12c0 1.66-4 3-9 3s-9-1.34-9-3"></path>
                                        <path d="M3 5v14c0 1.66 4 3 9 3s9-1.34 9-3V5"></path>
                                    </svg>
                                </div>
                                <div class="sw-card-info">
                                    <div class="sw-card-title">Database Systems</div>
                                    <div class="sw-card-sub">CS203 &bull; Lab Block &bull; Room 201</div>
                                </div>
                                <span class="sw-status-badge ongoing">&bull; Ongoing</span>
                                <button class="sw-kebab-btn" title="Options" onclick="openItemOptions('Database Systems')">&#8942;</button>
                            </div>
                        </div>

                        <!-- Item 3: Short Break -->
                        <div class="sw-timeline-row">
                            <div class="sw-tl-time">10:00 AM</div>
                            <div class="sw-tl-node-col"><div class="sw-tl-dot purple"></div></div>
                            <div class="sw-tl-card">
                                <div class="sw-card-timepill">10:00 AM - 10:15 AM</div>
                                <div class="sw-card-icon">
                                    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                        <path d="M18 8h1a4 4 0 0 1 0 8h-1"></path>
                                        <path d="M2 8h16v9a4 4 0 0 1-4 4H6a4 4 0 0 1-4-4V8z"></path>
                                        <line x1="6" y1="1" x2="6" y2="4"></line>
                                        <line x1="10" y1="1" x2="10" y2="4"></line>
                                        <line x1="14" y1="1" x2="14" y2="4"></line>
                                    </svg>
                                </div>
                                <div class="sw-card-info">
                                    <div class="sw-card-title">Short Break</div>
                                    <div class="sw-card-sub">Quick recharge & hydration</div>
                                </div>
                                <span class="sw-status-badge break">Break</span>
                                <button class="sw-kebab-btn" title="Options" onclick="openItemOptions('Short Break')">&#8942;</button>
                            </div>
                        </div>

                        <!-- Item 4: Operating Systems -->
                        <div class="sw-timeline-row">
                            <div class="sw-tl-time">01:00 PM</div>
                            <div class="sw-tl-node-col"><div class="sw-tl-dot purple"></div></div>
                            <div class="sw-tl-card">
                                <div class="sw-card-timepill">10:15 AM - 11:15 AM</div>
                                <div class="sw-card-icon purple-bg">
                                    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                        <polyline points="16 18 22 12 16 6"></polyline>
                                        <polyline points="8 6 2 12 8 18"></polyline>
                                    </svg>
                                </div>
                                <div class="sw-card-info">
                                    <div class="sw-card-title">Operating Systems</div>
                                    <div class="sw-card-sub">CS205 &bull; Main Block &bull; Room 304</div>
                                </div>
                                <span class="sw-status-badge upcoming">&#9719; Upcoming</span>
                                <button class="sw-kebab-btn" title="Options" onclick="openItemOptions('Operating Systems')">&#8942;</button>
                            </div>
                        </div>

                        <!-- Item 5: Software Engineering -->
                        <div class="sw-timeline-row">
                            <div class="sw-tl-time">11:15 PM</div>
                            <div class="sw-tl-node-col"><div class="sw-tl-dot purple"></div></div>
                            <div class="sw-tl-card">
                                <div class="sw-card-timepill">11:15 AM - 12:15 PM</div>
                                <div class="sw-card-icon purple-bg">
                                    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                        <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                                        <circle cx="9" cy="7" r="4"></circle>
                                        <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                                        <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                                    </svg>
                                </div>
                                <div class="sw-card-info">
                                    <div class="sw-card-title">Software Engineering</div>
                                    <div class="sw-card-sub">CS204 &bull; Main Block &bull; Room 305</div>
                                </div>
                                <span class="sw-status-badge upcoming">&#9719; Upcoming</span>
                                <button class="sw-kebab-btn" title="Options" onclick="openItemOptions('Software Engineering')">&#8942;</button>
                            </div>
                        </div>

                        <!-- Item 6: Lunch Break -->
                        <div class="sw-timeline-row">
                            <div class="sw-tl-time">02:00 PM</div>
                            <div class="sw-tl-node-col"><div class="sw-tl-dot purple"></div></div>
                            <div class="sw-tl-card">
                                <div class="sw-card-timepill">01:00 PM - 02:00 PM</div>
                                <div class="sw-card-icon">
                                    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                        <path d="M18 2v20M2 2v7a4 4 0 0 0 4 4h4v7"></path>
                                        <path d="M6 2v5M10 2v5"></path>
                                    </svg>
                                </div>
                                <div class="sw-card-info">
                                    <div class="sw-card-title">Lunch Break</div>
                                    <div class="sw-card-sub">Student Mess & Cafeteria</div>
                                </div>
                                <span class="sw-status-badge break">Break</span>
                                <button class="sw-kebab-btn" title="Options" onclick="openItemOptions('Lunch Break')">&#8942;</button>
                            </div>
                        </div>

                        <!-- Item 7: Mathematics for Computing -->
                        <div class="sw-timeline-row">
                            <div class="sw-tl-time">03:00 PM</div>
                            <div class="sw-tl-node-col"><div class="sw-tl-dot purple"></div></div>
                            <div class="sw-tl-card">
                                <div class="sw-card-timepill">02:00 PM - 03:00 PM</div>
                                <div class="sw-card-icon purple-bg">
                                    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                        <polyline points="23 6 13.5 15.5 8.5 10.5 1 18"></polyline>
                                        <polyline points="17 6 23 6 23 12"></polyline>
                                    </svg>
                                </div>
                                <div class="sw-card-info">
                                    <div class="sw-card-title">Mathematics for Computing</div>
                                    <div class="sw-card-sub">MA201 &bull; Main Block &bull; Room 101</div>
                                </div>
                                <span class="sw-status-badge upcoming">&#9719; Upcoming</span>
                                <button class="sw-kebab-btn" title="Options" onclick="openItemOptions('Mathematics for Computing')">&#8942;</button>
                            </div>
                        </div>

                        <!-- Item 8: Free Slot -->
                        <div class="sw-timeline-row">
                            <div class="sw-tl-time">04:00 PM</div>
                            <div class="sw-tl-node-col"><div class="sw-tl-dot green"></div></div>
                            <div class="sw-tl-card free-slot">
                                <div class="sw-card-timepill">03:00 PM - 04:00 PM</div>
                                <div class="sw-card-icon green-bg">
                                    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                        <rect x="2" y="3" width="20" height="14" rx="2" ry="2"></rect>
                                        <line x1="8" y1="21" x2="16" y2="21"></line>
                                        <line x1="12" y1="17" x2="12" y2="21"></line>
                                    </svg>
                                </div>
                                <div class="sw-card-info">
                                    <div class="sw-card-title">Free Slot</div>
                                    <div class="sw-card-sub">You can schedule a study session or take a break.</div>
                                </div>
                                <span class="sw-status-badge free">&#10022; Free</span>
                                <button class="sw-kebab-btn" title="Options" onclick="openSlotAction('03:00 PM - 04:00 PM')">&#8942;</button>
                            </div>
                        </div>

                        <!-- Item 9: Complete DBMS Assignment -->
                        <div class="sw-timeline-row">
                            <div class="sw-tl-time">04:00 PM</div>
                            <div class="sw-tl-node-col"><div class="sw-tl-dot orange"></div></div>
                            <div class="sw-tl-card task-slot">
                                <div class="sw-card-timepill">04:00 PM - 05:00 PM</div>
                                <div class="sw-card-icon orange-bg">
                                    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                        <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                                        <polyline points="14 2 14 8 20 8"></polyline>
                                        <line x1="16" y1="13" x2="8" y2="13"></line>
                                        <line x1="16" y1="17" x2="8" y2="17"></line>
                                        <polyline points="10 9 9 9 8 9"></polyline>
                                    </svg>
                                </div>
                                <div class="sw-card-info">
                                    <div class="sw-card-title">Complete DBMS Assignment</div>
                                    <div class="sw-card-sub">Task &bull; Personal</div>
                                </div>
                                <span class="sw-status-badge pending">&#9719; Pending</span>
                                <button class="sw-kebab-btn" title="Options" onclick="openItemOptions('Complete DBMS Assignment')">&#8942;</button>
                            </div>
                        </div>

                        <!-- Item 10: Self Study Session -->
                        <div class="sw-timeline-row">
                            <div class="sw-tl-time">05:00 PM</div>
                            <div class="sw-tl-node-col"><div class="sw-tl-dot purple"></div></div>
                            <div class="sw-tl-card">
                                <div class="sw-card-timepill">05:00 PM - 07:00 PM</div>
                                <div class="sw-card-icon purple-bg">
                                    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                        <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path>
                                        <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path>
                                    </svg>
                                </div>
                                <div class="sw-card-info">
                                    <div class="sw-card-title">Self Study Session</div>
                                    <div class="sw-card-sub">Focus on DSA Practice</div>
                                </div>
                                <span class="sw-status-badge upcoming">&#9719; Upcoming</span>
                                <button class="sw-kebab-btn" title="Options" onclick="openItemOptions('Self Study Session')">&#8942;</button>
                            </div>
                        </div>

                        <!-- Item 11: Gym / Personal Time -->
                        <div class="sw-timeline-row">
                            <div class="sw-tl-time">09:00 PM</div>
                            <div class="sw-tl-node-col"><div class="sw-tl-dot purple"></div></div>
                            <div class="sw-tl-card">
                                <div class="sw-card-timepill">07:00 PM - 09:00 PM</div>
                                <div class="sw-card-icon">
                                    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                        <path d="M6 7v10M18 7v10M2 10h4M18 10h4M2 14h4M18 14h4M6 12h12"></path>
                                    </svg>
                                </div>
                                <div class="sw-card-info">
                                    <div class="sw-card-title">Gym / Personal Time</div>
                                    <div class="sw-card-sub">Health & Fitness</div>
                                </div>
                                <span class="sw-status-badge personal">Personal</span>
                                <button class="sw-kebab-btn" title="Options" onclick="openItemOptions('Gym / Personal Time')">&#8942;</button>
                            </div>
                        </div>

                    </div>

                    <!-- Free Time Insights Card -->
                    <div class="sw-insights-card">
                        <div class="sw-insights-header">
                            <div class="sw-insights-title-grp">
                                <div class="sw-insights-icon">
                                    <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                        <path d="M5 22h14"></path>
                                        <path d="M5 2h14"></path>
                                        <path d="M17 22v-4.172a2 2 0 0 0-.586-1.414L12 12l-4.414 4.414A2 2 0 0 0 7 17.828V22"></path>
                                        <path d="M7 2v4.172a2 2 0 0 0 .586 1.414L12 12l4.414-4.414A2 2 0 0 0 17 6.172V2"></path>
                                    </svg>
                                </div>
                                <div>
                                    <div class="sw-insights-title">Free Time Insights</div>
                                    <div class="sw-insights-sub">Make the most of your available time slots!</div>
                                </div>
                            </div>

                            <button class="sw-find-slot-btn" onclick="openModal('Find Study Slot', 'Discover AI-recommended study periods based on your pending tasks and learning pace')">
                                <svg viewBox="0 0 24 24" width="14" height="14" fill="currentColor">
                                    <path d="M12 2l2.4 7.4H22l-6 4.6 2.3 7-6.3-4.6-6.3 4.6 2.3-7-6-4.6h7.6z"/>
                                </svg>
                                <span>Find Study Slot</span>
                            </button>
                        </div>

                        <div class="sw-slots-grid">
                            <!-- Slot 1 -->
                            <div class="sw-slot-box">
                                <div class="sw-slot-left">
                                    <svg class="sw-slot-icon purple" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <circle cx="12" cy="12" r="10"></circle>
                                        <polyline points="12 6 12 12 16 14"></polyline>
                                    </svg>
                                    <div>
                                        <div class="sw-slot-range">03:00 PM - 04:00 PM</div>
                                        <div class="sw-slot-duration">1 hour</div>
                                    </div>
                                </div>
                                <button class="sw-slot-btn" onclick="openSlotAction('03:00 PM - 04:00 PM')">Use Slot</button>
                            </div>

                            <!-- Slot 2 -->
                            <div class="sw-slot-box">
                                <div class="sw-slot-left">
                                    <svg class="sw-slot-icon teal" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <circle cx="12" cy="12" r="10"></circle>
                                        <polyline points="12 6 12 12 16 14"></polyline>
                                    </svg>
                                    <div>
                                        <div class="sw-slot-range">09:00 PM - 10:00 PM</div>
                                        <div class="sw-slot-duration">1 hour</div>
                                    </div>
                                </div>
                                <button class="sw-slot-btn" onclick="openSlotAction('09:00 PM - 10:00 PM')">Use Slot</button>
                            </div>

                            <!-- Slot 3 -->
                            <div class="sw-slot-box">
                                <div class="sw-slot-left">
                                    <svg class="sw-slot-icon blue" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <circle cx="12" cy="12" r="10"></circle>
                                        <polyline points="12 6 12 12 16 14"></polyline>
                                    </svg>
                                    <div>
                                        <div class="sw-slot-range">10:00 PM onwards</div>
                                        <div class="sw-slot-duration">Flexible</div>
                                    </div>
                                </div>
                                <button class="sw-slot-btn" onclick="openSlotAction('10:00 PM onwards')">Use Slot</button>
                            </div>
                        </div>
                    </div>

                </div>

                <!-- ---------------- RIGHT COLUMN: WIDGETS ---------------- -->
                <div class="sw-right-col">

                    <!-- 1. October 2026 Calendar Widget -->
                    <div class="sw-widget-card">
                        <div class="sw-cal-header">
                            <div class="sw-cal-month" id="calMonthTitle">October 2026</div>
                            <div class="sw-cal-nav">
                                <button class="sw-cal-nav-btn" onclick="showToast('Previous month')">&lsaquo;</button>
                                <button class="sw-cal-nav-btn" onclick="showToast('Next month')">&rsaquo;</button>
                            </div>
                        </div>

                        <div class="sw-cal-weekdays">
                            <span class="sw-cal-weekday">Mon</span>
                            <span class="sw-cal-weekday">Tue</span>
                            <span class="sw-cal-weekday">Wed</span>
                            <span class="sw-cal-weekday">Thu</span>
                            <span class="sw-cal-weekday">Fri</span>
                            <span class="sw-cal-weekday">Sat</span>
                            <span class="sw-cal-weekday">Sun</span>
                        </div>

                        <div class="sw-cal-grid" id="calendarGrid">
                            <!-- Week 1 -->
                            <div class="sw-cal-day muted">28</div>
                            <div class="sw-cal-day muted">29</div>
                            <div class="sw-cal-day muted">30</div>
                            <div class="sw-cal-day">1</div>
                            <div class="sw-cal-day">2</div>
                            <div class="sw-cal-day">3</div>
                            <div class="sw-cal-day">4</div>

                            <!-- Week 2 -->
                            <div class="sw-cal-day">5</div>
                            <div class="sw-cal-day">6</div>
                            <div class="sw-cal-day">7</div>
                            <div class="sw-cal-day">8</div>
                            <div class="sw-cal-day">9</div>
                            <div class="sw-cal-day">10</div>
                            <div class="sw-cal-day">11</div>

                            <!-- Week 3 -->
                            <div class="sw-cal-day selected" title="Today">12</div>
                            <div class="sw-cal-day">13</div>
                            <div class="sw-cal-day">14</div>
                            <div class="sw-cal-day">
                                15
                                <div class="sw-cal-dot-container"><span class="sw-cal-marker cyan"></span></div>
                            </div>
                            <div class="sw-cal-day">
                                16
                                <div class="sw-cal-dot-container"><span class="sw-cal-marker pink"></span></div>
                            </div>
                            <div class="sw-cal-day">17</div>
                            <div class="sw-cal-day">18</div>

                            <!-- Week 4 -->
                            <div class="sw-cal-day">19</div>
                            <div class="sw-cal-day">20</div>
                            <div class="sw-cal-day">21</div>
                            <div class="sw-cal-day">
                                22
                                <div class="sw-cal-dot-container">
                                    <span class="sw-cal-marker cyan"></span>
                                    <span class="sw-cal-marker pink"></span>
                                </div>
                            </div>
                            <div class="sw-cal-day">23</div>
                            <div class="sw-cal-day">
                                24
                                <div class="sw-cal-dot-container">
                                    <span class="sw-cal-marker cyan"></span>
                                    <span class="sw-cal-marker pink"></span>
                                </div>
                            </div>
                            <div class="sw-cal-day">25</div>

                            <!-- Week 5 -->
                            <div class="sw-cal-day">26</div>
                            <div class="sw-cal-day">
                                27
                                <div class="sw-cal-dot-container"><span class="sw-cal-marker cyan"></span></div>
                            </div>
                            <div class="sw-cal-day">28</div>
                            <div class="sw-cal-day">29</div>
                            <div class="sw-cal-day">30</div>
                            <div class="sw-cal-day">31</div>
                            <div class="sw-cal-day muted">1</div>
                        </div>
                    </div>

                    <!-- 2. Today's To-Do List Widget -->
                    <div class="sw-widget-card">
                        <div class="sw-todo-header">
                            <div class="sw-todo-title-grp">
                                <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="#818cf8" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M9 11l3 3L22 4"></path>
                                    <path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"></path>
                                </svg>
                                <span>Today's To-Do List</span>
                            </div>
                            <span class="sw-todo-add-link" onclick="openModal('Add Task', 'Add an urgent task or revision goal to today\'s to-do list')">+ Add Task</span>
                        </div>

                        <!-- Filter Tabs -->
                        <div class="sw-todo-tabs">
                            <button class="sw-todo-tab active" id="filterAll" onclick="filterTasks('all')">All (<span id="countAll">4</span>)</button>
                            <button class="sw-todo-tab" id="filterPending" onclick="filterTasks('pending')">Pending (<span id="countPending">3</span>)</button>
                            <button class="sw-todo-tab" id="filterDone" onclick="filterTasks('done')">Completed (<span id="countDone">1</span>)</button>
                        </div>

                        <!-- Tasks List -->
                        <div class="sw-todo-list" id="todoListItems">
                            <!-- Task 1 -->
                            <div class="sw-todo-item" data-status="pending">
                                <div class="sw-todo-left">
                                    <div class="sw-todo-check" onclick="toggleTask(this)"></div>
                                    <span class="sw-todo-name">Complete DBMS Assignment</span>
                                </div>
                                <div class="sw-todo-right">
                                    <span class="sw-priority-pill high">High</span>
                                    <span class="sw-todo-due">04:00 PM</span>
                                    <button class="sw-kebab-btn" onclick="openItemOptions('Complete DBMS Assignment')">&#8942;</button>
                                </div>
                            </div>

                            <!-- Task 2 -->
                            <div class="sw-todo-item" data-status="pending">
                                <div class="sw-todo-left">
                                    <div class="sw-todo-check" onclick="toggleTask(this)"></div>
                                    <span class="sw-todo-name">Revise Java Notes</span>
                                </div>
                                <div class="sw-todo-right">
                                    <span class="sw-priority-pill medium">Medium</span>
                                    <span class="sw-todo-due">06:00 PM</span>
                                    <button class="sw-kebab-btn" onclick="openItemOptions('Revise Java Notes')">&#8942;</button>
                                </div>
                            </div>

                            <!-- Task 3 -->
                            <div class="sw-todo-item" data-status="pending">
                                <div class="sw-todo-left">
                                    <div class="sw-todo-check" onclick="toggleTask(this)"></div>
                                    <span class="sw-todo-name">Prepare Lab Record</span>
                                </div>
                                <div class="sw-todo-right">
                                    <span class="sw-priority-pill medium">Medium</span>
                                    <span class="sw-todo-due">08:00 PM</span>
                                    <button class="sw-kebab-btn" onclick="openItemOptions('Prepare Lab Record')">&#8942;</button>
                                </div>
                            </div>

                            <!-- Task 4 -->
                            <div class="sw-todo-item" data-status="done">
                                <div class="sw-todo-left">
                                    <div class="sw-todo-check checked" onclick="toggleTask(this)">&#10003;</div>
                                    <span class="sw-todo-name done">Read Research Paper</span>
                                </div>
                                <div class="sw-todo-right">
                                    <span class="sw-priority-pill low">Low</span>
                                    <span class="sw-todo-due">09:30 PM</span>
                                    <button class="sw-kebab-btn" onclick="openItemOptions('Read Research Paper')">&#8942;</button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- 3. Daily Summary Widget -->
                    <div class="sw-widget-card">
                        <div class="sw-summary-header">
                            <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="#38bdf8" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                                <line x1="18" y1="20" x2="18" y2="10"></line>
                                <line x1="12" y1="20" x2="12" y2="4"></line>
                                <line x1="6" y1="20" x2="6" y2="14"></line>
                            </svg>
                            <span>Daily Summary</span>
                        </div>

                        <div class="sw-summary-grid">
                            <!-- Classes -->
                            <div class="sw-summary-tile">
                                <div class="sw-sum-icon blue">
                                    <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path>
                                        <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path>
                                    </svg>
                                </div>
                                <div>
                                    <div class="sw-sum-num" id="sumClasses">4</div>
                                    <div class="sw-sum-lbl">Classes</div>
                                </div>
                            </div>

                            <!-- Tasks -->
                            <div class="sw-summary-tile">
                                <div class="sw-sum-icon green">
                                    <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2.2">
                                        <polyline points="20 6 9 17 4 12"></polyline>
                                    </svg>
                                </div>
                                <div>
                                    <div class="sw-sum-num" id="sumTasks">4</div>
                                    <div class="sw-sum-lbl">Tasks</div>
                                </div>
                            </div>

                            <!-- Free Time -->
                            <div class="sw-summary-tile">
                                <div class="sw-sum-icon orange">
                                    <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2">
                                        <circle cx="12" cy="12" r="10"></circle>
                                        <polyline points="12 6 12 12 16 14"></polyline>
                                    </svg>
                                </div>
                                <div>
                                    <div class="sw-sum-num">2 h</div>
                                    <div class="sw-sum-lbl">Free Time</div>
                                </div>
                            </div>

                            <!-- Overdue -->
                            <div class="sw-summary-tile">
                                <div class="sw-sum-icon red">
                                    <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2">
                                        <circle cx="12" cy="12" r="10"></circle>
                                        <line x1="12" y1="8" x2="12" y2="12"></line>
                                        <line x1="12" y1="16" x2="12.01" y2="16"></line>
                                    </svg>
                                </div>
                                <div>
                                    <div class="sw-sum-num" style="color: #f43f5e;">0</div>
                                    <div class="sw-sum-lbl">Overdue</div>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>

            </div>
        </div>
    </main>
</div>

<!-- ======================================================== -->
<!-- INTERACTIVE MODAL                                        -->
<!-- ======================================================== -->
<div class="sw-modal-backdrop" id="modalBackdrop">
    <div class="sw-modal-box">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px;">
            <h3 id="modalTitle" style="color: #ffffff; font-size: 1.15rem; font-weight: 700;">Add Item</h3>
            <button onclick="closeModal()" style="background: transparent; border: none; color: #94a3b8; font-size: 1.4rem; cursor: pointer;">&times;</button>
        </div>
        <p id="modalDesc" style="color: #94a3b8; font-size: 0.85rem; margin-bottom: 20px;">Provide the details below:</p>

        <form id="genericModalForm" onsubmit="handleModalSubmit(event)">
            <div style="display: flex; flex-direction: column; gap: 14px;">
                <div>
                    <label style="display: block; font-size: 0.78rem; font-weight: 600; color: #cbd5e1; margin-bottom: 6px;">Title / Subject</label>
                    <input type="text" id="modalInputTitle" required style="width: 100%; height: 38px; background: rgba(255,255,255,0.05); border: 1px solid rgba(255,255,255,0.12); border-radius: 8px; padding: 0 12px; color: #fff; font-size: 0.86rem; outline: none;" placeholder="e.g. Distributed Computing Lecture">
                </div>
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 12px;">
                    <div>
                        <label style="display: block; font-size: 0.78rem; font-weight: 600; color: #cbd5e1; margin-bottom: 6px;">Start Time</label>
                        <input type="time" id="modalInputStart" value="14:00" style="width: 100%; height: 38px; background: rgba(255,255,255,0.05); border: 1px solid rgba(255,255,255,0.12); border-radius: 8px; padding: 0 10px; color: #fff; font-size: 0.86rem; outline: none;">
                    </div>
                    <div>
                        <label style="display: block; font-size: 0.78rem; font-weight: 600; color: #cbd5e1; margin-bottom: 6px;">End Time</label>
                        <input type="time" id="modalInputEnd" value="15:00" style="width: 100%; height: 38px; background: rgba(255,255,255,0.05); border: 1px solid rgba(255,255,255,0.12); border-radius: 8px; padding: 0 10px; color: #fff; font-size: 0.86rem; outline: none;">
                    </div>
                </div>
                <div style="display: flex; justify-content: flex-end; gap: 10px; margin-top: 10px;">
                    <button type="button" onclick="closeModal()" style="background: rgba(255,255,255,0.06); border: 1px solid rgba(255,255,255,0.1); color: #cbd5e1; padding: 8px 16px; border-radius: 8px; cursor: pointer;">Cancel</button>
                    <button type="submit" style="background: #4f46e5; border: none; color: #fff; font-weight: 600; padding: 8px 20px; border-radius: 8px; cursor: pointer;">Save</button>
                </div>
            </div>
        </form>
    </div>
</div>

<!-- Toast Container -->
<div class="sw-toast" id="toastBox">
    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="#a78bfa" stroke-width="2.2">
        <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
        <polyline points="22 4 12 14.01 9 11.01"></polyline>
    </svg>
    <span id="toastMsg">Operation successful</span>
</div>

<script>
    // Toast Notification helper
    function showToast(msg) {
        var toast = document.getElementById('toastBox');
        var toastMsg = document.getElementById('toastMsg');
        toastMsg.textContent = msg;
        toast.classList.add('show');
        setTimeout(function() {
            toast.classList.remove('show');
        }, 3200);
    }

    // Modal helpers
    function openModal(title, desc) {
        document.getElementById('modalTitle').textContent = title;
        document.getElementById('modalDesc').textContent = desc;
        document.getElementById('modalBackdrop').style.display = 'flex';
        document.getElementById('modalInputTitle').focus();
    }

    function closeModal() {
        document.getElementById('modalBackdrop').style.display = 'none';
        document.getElementById('genericModalForm').reset();
    }

    function handleModalSubmit(e) {
        e.preventDefault();
        var title = document.getElementById('modalInputTitle').value;
        closeModal();
        showToast('Successfully added "' + title + '" to your schedule!');
    }

    // Segmented tab switching
    function switchView(viewName) {
        document.getElementById('tabTimeline').classList.remove('active');
        document.getElementById('tabList').classList.remove('active');
        document.getElementById('tabSubject').classList.remove('active');

        if (viewName === 'timeline') {
            document.getElementById('tabTimeline').classList.add('active');
            showToast('Switched to Timeline View');
        } else if (viewName === 'list') {
            document.getElementById('tabList').classList.add('active');
            showToast('Switched to Compact List View');
        } else if (viewName === 'subject') {
            document.getElementById('tabSubject').classList.add('active');
            showToast('Switched to Grouped Subject View');
        }
    }

    // To-Do list interactive check
    function toggleTask(checkbox) {
        var item = checkbox.closest('.sw-todo-item');
        var nameSpan = item.querySelector('.sw-todo-name');
        var isChecked = checkbox.classList.contains('checked');

        if (isChecked) {
            checkbox.classList.remove('checked');
            checkbox.innerHTML = '';
            nameSpan.classList.remove('done');
            item.setAttribute('data-status', 'pending');
            showToast('Task marked as pending');
        } else {
            checkbox.classList.add('checked');
            checkbox.innerHTML = '&#10003;';
            nameSpan.classList.add('done');
            item.setAttribute('data-status', 'done');
            showToast('Task completed! Keep up the momentum!');
        }
        updateTodoCounts();
    }

    // Filter Tasks (All / Pending / Done)
    function filterTasks(filter) {
        document.getElementById('filterAll').classList.remove('active');
        document.getElementById('filterPending').classList.remove('active');
        document.getElementById('filterDone').classList.remove('active');

        var items = document.querySelectorAll('.sw-todo-item');
        if (filter === 'all') {
            document.getElementById('filterAll').classList.add('active');
            items.forEach(function(it) { it.style.display = 'flex'; });
        } else if (filter === 'pending') {
            document.getElementById('filterPending').classList.add('active');
            items.forEach(function(it) {
                it.style.display = (it.getAttribute('data-status') === 'pending') ? 'flex' : 'none';
            });
        } else if (filter === 'done') {
            document.getElementById('filterDone').classList.add('active');
            items.forEach(function(it) {
                it.style.display = (it.getAttribute('data-status') === 'done') ? 'flex' : 'none';
            });
        }
    }

    function updateTodoCounts() {
        var pending = document.querySelectorAll('.sw-todo-item[data-status="pending"]').length;
        var done = document.querySelectorAll('.sw-todo-item[data-status="done"]').length;
        var total = pending + done;

        document.getElementById('countAll').textContent = total;
        document.getElementById('countPending').textContent = pending;
        document.getElementById('countDone').textContent = done;
        document.getElementById('sumTasks').textContent = total;
    }

    // Calendar day click
    var calDays = document.querySelectorAll('.sw-cal-day:not(.muted)');
    calDays.forEach(function(day) {
        day.addEventListener('click', function() {
            calDays.forEach(function(d) { d.classList.remove('selected'); });
            this.classList.add('selected');
            showToast('Loaded schedule for ' + this.textContent.trim().replace(/\s+/g, '') + ' October 2026');
        });
    });

    // Options menu
    function openItemOptions(title) {
        showToast('Options for "' + title + '" (Edit / Reschedule / Remove)');
    }

    function openSlotAction(slotRange) {
        openModal('Schedule Study Slot (' + slotRange + ')', 'Assign a task, practice session or revision topic to this free hour.');
    }

    function exportDayPlan() {
        showToast('Exporting Today\'s Plan as PDF...');
        setTimeout(function() {
            window.print();
        }, 600);
    }

    // Search filter
    document.getElementById('globalSearch').addEventListener('input', function(e) {
        var term = e.target.value.toLowerCase();
        var rows = document.querySelectorAll('.sw-timeline-row');
        rows.forEach(function(row) {
            var text = row.textContent.toLowerCase();
            row.style.display = text.includes(term) ? 'flex' : 'none';
        });
    });
</script>

</body>
</html>
