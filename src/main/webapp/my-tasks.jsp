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
    <title>My Tasks &mdash; SlotWise</title>
    <meta name="description" content="Manage all academic tasks, assignments, lab work, and exam prep with SlotWise.">
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
            --border-hover: rgba(255, 255, 255, 0.14);
            --primary-purple: #6366f1;
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

        .mt-layout {
            display: flex;
            min-height: 100vh;
            background-color: var(--bg-app);
            position: relative;
        }

        /* Ambient bottom glow */
        .mt-layout::before {
            content: '';
            position: fixed;
            bottom: -150px;
            left: -150px;
            width: 500px;
            height: 500px;
            background: radial-gradient(circle, rgba(99, 102, 241, 0.14) 0%, rgba(139, 92, 246, 0.06) 40%, transparent 70%);
            pointer-events: none;
            z-index: 0;
        }

        /* ======================================================== */
        /* SIDEBAR NAVIGATION                                       */
        /* ======================================================== */
        .mt-sidebar {
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
            overflow-y: auto;
        }

        .mt-sidebar::-webkit-scrollbar {
            width: 4px;
        }
        .mt-sidebar::-webkit-scrollbar-thumb {
            background: rgba(255, 255, 255, 0.08);
            border-radius: 4px;
        }

        .mt-logo {
            display: flex;
            align-items: center;
            gap: 12px;
            text-decoration: none;
            padding: 0 8px 24px;
        }

        .mt-logo-icon {
            width: 36px;
            height: 36px;
            background: linear-gradient(135deg, #6366f1 0%, #a855f7 100%);
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #ffffff;
            box-shadow: 0 4px 14px var(--primary-purple-glow);
        }

        .mt-logo-text {
            font-size: 1.25rem;
            font-weight: 700;
            color: #ffffff;
            letter-spacing: -0.02em;
        }
        .mt-logo-text span {
            color: #a78bfa;
        }

        .mt-nav {
            display: flex;
            flex-direction: column;
            gap: 4px;
            flex: 1;
        }

        .mt-nav-item {
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

        .mt-nav-item:hover {
            color: var(--text-white);
            background-color: rgba(255, 255, 255, 0.04);
        }

        .mt-nav-item.active {
            background: linear-gradient(135deg, #4f46e5 0%, #6366f1 100%);
            color: #ffffff;
            font-weight: 600;
            box-shadow: 0 4px 18px rgba(79, 70, 229, 0.4);
        }

        .mt-nav-item svg {
            width: 18px;
            height: 18px;
            stroke-width: 1.9;
            flex-shrink: 0;
        }

        /* Sidebar Astronaut Card at Bottom */
        .mt-sidebar-illustration {
            margin: 16px 0 12px;
            background: linear-gradient(180deg, rgba(30, 27, 75, 0.5) 0%, rgba(15, 23, 42, 0.8) 100%);
            border: 1px solid rgba(99, 102, 241, 0.2);
            border-radius: 14px;
            padding: 10px;
            overflow: hidden;
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
        }

        .mt-sidebar-illustration img {
            width: 100%;
            height: 110px;
            object-fit: cover;
            border-radius: 10px;
        }

        .mt-sidebar-bottom {
            padding-top: 14px;
            border-top: 1px solid var(--border-subtle);
        }

        .mt-nav-item.logout {
            color: #94a3b8;
        }
        .mt-nav-item.logout:hover {
            color: #f43f5e;
            background-color: rgba(244, 63, 94, 0.08);
        }

        /* ======================================================== */
        /* MAIN CONTENT AREA                                        */
        /* ======================================================== */
        .mt-main {
            flex: 1;
            display: flex;
            flex-direction: column;
            min-width: 0;
            background-color: var(--bg-app);
            position: relative;
            z-index: 1;
        }

        /* Topbar */
        .mt-topbar {
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

        .mt-search-box {
            position: relative;
            width: 440px;
            max-width: 100%;
        }

        .mt-search-box input {
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

        .mt-search-box input:focus {
            border-color: #6366f1;
            background-color: rgba(255, 255, 255, 0.06);
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.2);
        }

        .mt-search-box svg {
            position: absolute;
            left: 14px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-dim);
            width: 16px;
            height: 16px;
        }

        .mt-user-area {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .mt-bell-btn {
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

        .mt-bell-btn:hover {
            color: var(--text-white);
            background-color: rgba(255, 255, 255, 0.08);
        }

        .mt-bell-dot {
            position: absolute;
            top: 8px;
            right: 9px;
            width: 7px;
            height: 7px;
            background-color: #f43f5e;
            border-radius: 50%;
            box-shadow: 0 0 6px #f43f5e;
        }

        .mt-profile-pill {
            display: flex;
            align-items: center;
            gap: 12px;
            text-decoration: none;
        }

        .mt-avatar {
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

        .mt-profile-info {
            display: flex;
            flex-direction: column;
            line-height: 1.25;
        }

        .mt-profile-name {
            font-size: 0.88rem;
            font-weight: 600;
            color: var(--text-white);
        }

        .mt-profile-role {
            font-size: 0.74rem;
            color: var(--text-muted);
        }

        /* Container */
        .mt-content-wrap {
            padding: 24px 32px 40px;
            display: flex;
            flex-direction: column;
            gap: 22px;
        }

        /* Header Row with Astronaut Banner & Add Task */
        .mt-header-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 20px;
            position: relative;
        }

        .mt-title-grp h1 {
            font-size: 2.1rem;
            font-weight: 800;
            color: #ffffff;
            letter-spacing: -0.02em;
        }

        .mt-title-gradient {
            background: linear-gradient(135deg, #a855f7 0%, #c084fc 40%, #ec4899 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .mt-header-center-art {
            position: absolute;
            left: 50%;
            top: 50%;
            transform: translate(-50%, -50%);
            display: flex;
            align-items: center;
            gap: 12px;
            pointer-events: none;
        }

        .mt-header-art-thumb {
            width: 140px;
            height: 70px;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 20px rgba(99, 102, 241, 0.25);
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        .mt-header-art-thumb img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        @media (max-width: 1100px) {
            .mt-header-center-art {
                display: none;
            }
        }

        .mt-add-task-btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: linear-gradient(135deg, #4f46e5 0%, #6366f1 100%);
            color: #ffffff;
            font-size: 0.88rem;
            font-weight: 600;
            padding: 10px 22px;
            border-radius: 10px;
            border: none;
            cursor: pointer;
            box-shadow: 0 4px 16px var(--primary-purple-glow);
            transition: all 0.2s ease;
        }

        .mt-add-task-btn:hover {
            transform: translateY(-1px);
            box-shadow: 0 6px 22px rgba(99, 102, 241, 0.5);
        }

        /* Filter Tabs */
        .mt-filter-tabs {
            display: flex;
            align-items: center;
            gap: 8px;
            overflow-x: auto;
            padding-bottom: 2px;
        }

        .mt-tab-pill {
            background: rgba(255, 255, 255, 0.035);
            border: 1px solid var(--border-subtle);
            border-radius: 999px;
            color: var(--text-muted);
            font-size: 0.82rem;
            font-weight: 600;
            padding: 7px 18px;
            cursor: pointer;
            transition: all 0.2s ease;
            white-space: nowrap;
        }

        .mt-tab-pill:hover {
            color: #ffffff;
            background: rgba(255, 255, 255, 0.06);
        }

        .mt-tab-pill.active {
            background: #4f46e5;
            color: #ffffff;
            border-color: #4f46e5;
            box-shadow: 0 2px 10px rgba(79, 70, 229, 0.4);
        }

        /* KPI Cards Grid (4 tiles) */
        .mt-kpi-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 16px;
        }

        @media (max-width: 900px) {
            .mt-kpi-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        .mt-kpi-card {
            background: var(--bg-card);
            border: 1px solid var(--border-subtle);
            border-radius: 14px;
            padding: 16px 18px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 14px;
            transition: all 0.2s ease;
        }

        .mt-kpi-card:hover {
            border-color: var(--border-hover);
            transform: translateY(-2px);
        }

        .mt-kpi-left {
            display: flex;
            align-items: center;
            gap: 14px;
        }

        .mt-kpi-icon {
            width: 42px;
            height: 42px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }
        .mt-kpi-icon.purple { background: rgba(99, 102, 241, 0.15); color: #818cf8; }
        .mt-kpi-icon.amber { background: rgba(245, 158, 11, 0.15); color: #f59e0b; }
        .mt-kpi-icon.green { background: rgba(16, 185, 129, 0.15); color: #10b981; }
        .mt-kpi-icon.red { background: rgba(244, 63, 94, 0.15); color: #f43f5e; }

        .mt-kpi-num {
            font-size: 1.55rem;
            font-weight: 800;
            color: #ffffff;
            line-height: 1.1;
        }

        .mt-kpi-label {
            font-size: 0.76rem;
            color: var(--text-muted);
            margin-top: 2px;
        }

        .mt-sparkline {
            display: flex;
            align-items: flex-end;
            gap: 3px;
            height: 22px;
        }

        .mt-spark-bar {
            width: 3px;
            border-radius: 2px;
        }
        .mt-spark-bar.purple { background: #818cf8; }
        .mt-spark-bar.amber { background: #f59e0b; }
        .mt-spark-bar.green { background: #10b981; }
        .mt-spark-bar.red { background: #f43f5e; }

        /* ======================================================== */
        /* TWO COLUMN MAIN WORKSPACE                                */
        /* ======================================================== */
        .mt-workspace-grid {
            display: grid;
            grid-template-columns: 1fr 340px;
            gap: 22px;
            align-items: start;
        }

        @media (max-width: 1200px) {
            .mt-workspace-grid {
                grid-template-columns: 1fr;
            }
        }

        /* LEFT: TASK LIST CARD */
        .mt-tasklist-card {
            background: var(--bg-card);
            border: 1px solid var(--border-subtle);
            border-radius: 16px;
            padding: 18px 20px;
            display: flex;
            flex-direction: column;
            gap: 14px;
        }

        .mt-tl-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding-bottom: 8px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.04);
        }

        .mt-tl-title-grp {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 1rem;
            font-weight: 700;
            color: #ffffff;
        }

        .mt-tl-tools {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .mt-sort-select {
            background: rgba(255, 255, 255, 0.04);
            border: 1px solid var(--border-subtle);
            border-radius: 8px;
            color: var(--text-muted);
            font-size: 0.78rem;
            font-weight: 500;
            padding: 6px 12px;
            outline: none;
            cursor: pointer;
        }

        .mt-icon-tool-btn {
            background: rgba(255, 255, 255, 0.04);
            border: 1px solid var(--border-subtle);
            border-radius: 8px;
            color: var(--text-muted);
            width: 32px;
            height: 32px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .mt-icon-tool-btn:hover {
            color: #ffffff;
            background: rgba(255, 255, 255, 0.08);
        }

        /* Task Rows */
        .mt-rows-container {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .mt-task-row {
            display: flex;
            align-items: center;
            gap: 14px;
            padding: 10px 14px;
            border-radius: 12px;
            background: var(--bg-card-inner);
            border: 1px solid var(--border-subtle);
            position: relative;
            transition: all 0.2s ease;
        }

        .mt-task-row:hover {
            border-color: var(--border-hover);
            background: rgba(255, 255, 255, 0.035);
            transform: translateY(-1px);
        }

        .mt-task-row.checked-row {
            opacity: 0.65;
        }

        /* Left Accent Stripe */
        .mt-accent-bar {
            position: absolute;
            left: 0;
            top: 10px;
            bottom: 10px;
            width: 3.5px;
            border-radius: 0 3px 3px 0;
        }
        .mt-accent-bar.red { background: #f43f5e; }
        .mt-accent-bar.amber { background: #f59e0b; }
        .mt-accent-bar.teal { background: #10b981; }
        .mt-accent-bar.blue { background: #38bdf8; }

        /* Square Checkbox */
        .mt-checkbox-sq {
            width: 19px;
            height: 19px;
            border-radius: 6px;
            border: 2px solid #64748b;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            flex-shrink: 0;
            transition: all 0.2s ease;
            margin-left: 4px;
        }

        .mt-checkbox-sq:hover {
            border-color: #818cf8;
        }

        .mt-checkbox-sq.checked {
            background: #6366f1;
            border-color: #6366f1;
            color: #ffffff;
        }

        /* Subject / Category Icon */
        .mt-task-icon-box {
            width: 36px;
            height: 36px;
            border-radius: 9px;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }
        .mt-task-icon-box.purple { background: rgba(99, 102, 241, 0.15); color: #818cf8; }
        .mt-task-icon-box.orange { background: rgba(249, 115, 22, 0.15); color: #fb923c; }
        .mt-task-icon-box.cyan { background: rgba(56, 189, 248, 0.15); color: #38bdf8; }
        .mt-task-icon-box.teal { background: rgba(16, 185, 129, 0.15); color: #10b981; }
        .mt-task-icon-box.pink { background: rgba(244, 63, 94, 0.15); color: #f43f5e; }

        .mt-task-details {
            flex: 1;
            min-width: 0;
        }

        .mt-task-title {
            font-size: 0.9rem;
            font-weight: 600;
            color: #ffffff;
            margin-bottom: 2px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            transition: all 0.2s ease;
        }

        .mt-task-title.done {
            text-decoration: line-through;
            color: var(--text-dim);
        }

        .mt-task-sub {
            font-size: 0.74rem;
            color: var(--text-muted);
            display: flex;
            align-items: center;
            gap: 12px;
            flex-wrap: wrap;
        }

        .mt-task-sub-item {
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }

        /* Priority Tag */
        .mt-tag {
            font-size: 0.72rem;
            font-weight: 700;
            padding: 3px 10px;
            border-radius: 6px;
            white-space: nowrap;
        }
        .mt-tag.high { background: rgba(244, 63, 94, 0.15); color: #f43f5e; }
        .mt-tag.medium { background: rgba(245, 158, 11, 0.15); color: #f59e0b; }
        .mt-tag.low { background: rgba(56, 189, 248, 0.15); color: #38bdf8; }
        .mt-tag.completed { background: rgba(16, 185, 129, 0.15); color: #10b981; }

        /* Actions: Edit & Trash */
        .mt-row-actions {
            display: flex;
            align-items: center;
            gap: 6px;
            flex-shrink: 0;
        }

        .mt-act-btn {
            background: transparent;
            border: none;
            width: 30px;
            height: 30px;
            border-radius: 6px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--text-muted);
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .mt-act-btn:hover {
            color: #ffffff;
            background: rgba(255, 255, 255, 0.06);
        }

        .mt-act-btn.delete:hover {
            color: #f43f5e;
            background: rgba(244, 63, 94, 0.1);
        }

        /* ======================================================== */
        /* RIGHT COLUMN: WIDGETS                                    */
        /* ======================================================== */
        .mt-sidebar-widgets {
            display: flex;
            flex-direction: column;
            gap: 18px;
        }

        .mt-widget-box {
            background: var(--bg-card);
            border: 1px solid var(--border-subtle);
            border-radius: 16px;
            padding: 18px 20px;
        }

        /* ---------------- Widget 1: Filters ---------------- */
        .mt-widget-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 14px;
        }

        .mt-w-title-grp {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 0.95rem;
            font-weight: 700;
            color: #ffffff;
        }

        .mt-reset-link {
            color: #a78bfa;
            font-size: 0.78rem;
            font-weight: 600;
            cursor: pointer;
            transition: color 0.2s ease;
        }

        .mt-reset-link:hover {
            color: #c4b5fd;
        }

        .mt-filter-fields {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        .mt-filter-field {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 10px;
        }

        .mt-field-label {
            font-size: 0.82rem;
            color: var(--text-muted);
            font-weight: 500;
        }

        .mt-field-select {
            background: var(--bg-card-inner);
            border: 1px solid var(--border-subtle);
            border-radius: 8px;
            color: #ffffff;
            font-size: 0.8rem;
            padding: 6px 12px;
            outline: none;
            cursor: pointer;
            width: 150px;
        }

        /* ---------------- Widget 2: Quick Add ---------------- */
        .mt-quick-add-list {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .mt-quick-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 9px 12px;
            background: var(--bg-card-inner);
            border: 1px solid var(--border-subtle);
            border-radius: 10px;
            color: #f1f5f9;
            font-size: 0.84rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .mt-quick-item:hover {
            border-color: var(--primary-purple);
            background: rgba(99, 102, 241, 0.08);
            transform: translateX(2px);
        }

        .mt-quick-left {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .mt-quick-left svg {
            color: #a78bfa;
            width: 16px;
            height: 16px;
        }

        .mt-quick-arrow {
            color: var(--text-dim);
            font-size: 0.9rem;
            transition: color 0.2s ease;
        }

        .mt-quick-item:hover .mt-quick-arrow {
            color: #ffffff;
        }

        /* ---------------- Widget 3: Task Insights ---------------- */
        .mt-donut-section {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 14px;
            margin: 10px 0 16px;
        }

        .mt-donut-wrap {
            position: relative;
            width: 100px;
            height: 100px;
            flex-shrink: 0;
        }

        .mt-donut-wrap svg {
            transform: rotate(-90deg);
        }

        .mt-donut-center {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            text-align: center;
        }

        .mt-donut-total {
            font-size: 1.25rem;
            font-weight: 800;
            color: #ffffff;
            line-height: 1.1;
        }

        .mt-donut-lbl {
            font-size: 0.68rem;
            color: var(--text-muted);
        }

        .mt-donut-legend {
            display: flex;
            flex-direction: column;
            gap: 6px;
            flex: 1;
        }

        .mt-legend-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            font-size: 0.76rem;
            color: var(--text-muted);
        }

        .mt-legend-left {
            display: flex;
            align-items: center;
            gap: 6px;
            color: #cbd5e1;
        }

        .mt-legend-dot {
            width: 8px;
            height: 8px;
            border-radius: 50%;
        }
        .mt-legend-dot.green { background: #10b981; }
        .mt-legend-dot.amber { background: #f59e0b; }
        .mt-legend-dot.red { background: #f43f5e; }

        /* Bottom Progress bar */
        .mt-insights-progress {
            padding-top: 12px;
            border-top: 1px solid rgba(255, 255, 255, 0.05);
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .mt-progress-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            font-size: 0.78rem;
        }

        .mt-prog-label {
            display: flex;
            align-items: center;
            gap: 6px;
            color: #cbd5e1;
            font-weight: 500;
        }

        .mt-prog-label svg {
            color: #818cf8;
            width: 14px;
            height: 14px;
        }

        .mt-prog-val {
            font-weight: 700;
            color: #ffffff;
            font-family: 'JetBrains Mono', monospace;
        }

        .mt-progress-track {
            height: 7px;
            background: rgba(255, 255, 255, 0.06);
            border-radius: 999px;
            overflow: hidden;
        }

        .mt-progress-fill {
            height: 100%;
            background: linear-gradient(90deg, #6366f1 0%, #8b5cf6 100%);
            border-radius: 999px;
            transition: width 0.3s ease;
        }

        /* Modal Styles */
        .mt-modal-backdrop {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100vw;
            height: 100vh;
            background: rgba(0, 0, 0, 0.7);
            backdrop-filter: blur(5px);
            z-index: 999;
            align-items: center;
            justify-content: center;
        }

        .mt-modal-box {
            background: #0d1424;
            border: 1px solid rgba(255, 255, 255, 0.12);
            border-radius: 16px;
            width: 460px;
            max-width: 90vw;
            padding: 24px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.8);
        }

        .mt-toast {
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

        .mt-toast.show {
            transform: translateY(0);
            opacity: 1;
        }
    </style>
</head>
<body>

<div class="mt-layout">
    <!-- ======================================================== -->
    <!-- SIDEBAR NAVIGATION                                       -->
    <!-- ======================================================== -->
    <aside class="mt-sidebar">
        <div>
            <!-- Logo -->
            <a href="${pageContext.request.contextPath}/dashboard.jsp" class="mt-logo">
                <div class="mt-logo-icon">
                    <!-- Graduation Cap Icon -->
                    <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M22 10v6M2 10l10-5 10 5-10 5z"></path>
                        <path d="M6 12v5c3 3 9 3 12 0v-5"></path>
                    </svg>
                </div>
                <div class="mt-logo-text">Slot<span>Wise</span></div>
            </a>

            <!-- Navigation Links -->
            <nav class="mt-nav">
                <!-- Dashboard -->
                <a href="${pageContext.request.contextPath}/dashboard.jsp" class="mt-nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path>
                        <polyline points="9 22 9 12 15 12 15 22"></polyline>
                    </svg>
                    <span>Dashboard</span>
                </a>

                <!-- Timetable -->
                <a href="${pageContext.request.contextPath}/today-timetable.jsp" class="mt-nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round">
                        <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                        <line x1="16" y1="2" x2="16" y2="6"></line>
                        <line x1="8" y1="2" x2="8" y2="6"></line>
                        <line x1="3" y1="10" x2="21" y2="10"></line>
                    </svg>
                    <span>Timetable</span>
                </a>

                <!-- My Tasks (ACTIVE) -->
                <a href="${pageContext.request.contextPath}/my-tasks.jsp" class="mt-nav-item active">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M9 11l3 3L22 4"></path>
                        <path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"></path>
                    </svg>
                    <span>My Tasks</span>
                </a>

                <!-- Study Planner -->
                <a href="${pageContext.request.contextPath}/planner" class="mt-nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="12" cy="12" r="2"></circle>
                        <path d="M16.24 7.76a6 6 0 0 1 0 8.49m-8.48-.01a6 6 0 0 1 0-8.49m11.31-2.82a10 10 0 0 1 0 14.14m-14.14 0a10 10 0 0 1 0-14.14"></path>
                    </svg>
                    <span>Study Planner</span>
                </a>

                <!-- Progress -->
                <a href="${pageContext.request.contextPath}/progress.jsp" class="mt-nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round">
                        <line x1="18" y1="20" x2="18" y2="10"></line>
                        <line x1="12" y1="20" x2="12" y2="4"></line>
                        <line x1="6" y1="20" x2="6" y2="14"></line>
                    </svg>
                    <span>Progress</span>
                </a>

                <!-- Materials -->
                <a href="${pageContext.request.contextPath}/materials.jsp" class="mt-nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M2 3h6a4 4 0 0 1 4 4v14a3 3 0 0 0-3-3H2z"></path>
                        <path d="M22 3h-6a4 4 0 0 0-4 4v14a3 3 0 0 1 3-3h7z"></path>
                    </svg>
                    <span>Materials</span>
                </a>

                <!-- Study Groups -->
                <a href="${pageContext.request.contextPath}/study-groups.jsp" class="mt-nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                        <circle cx="9" cy="7" r="4"></circle>
                        <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                        <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                    </svg>
                    <span>Study Groups</span>
                </a>

                <!-- Smart Rescheduler -->
                <a href="${pageContext.request.contextPath}/smart-rescheduler.jsp" class="mt-nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M21.5 2v6h-6"></path>
                        <path d="M2.5 12A10 10 0 0 1 20.5 6.3L21.5 8"></path>
                        <path d="M2.5 22v-6h6"></path>
                        <path d="M21.5 12A10 10 0 0 1 3.5 17.7L2.5 16"></path>
                    </svg>
                    <span>Smart Rescheduler</span>
                </a>

                <!-- Deadline Radar -->
                <a href="${pageContext.request.contextPath}/deadline-radar.jsp" class="mt-nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="12" cy="12" r="2"></circle>
                        <path d="M16.24 7.76a6 6 0 0 1 0 8.49m-8.48-.01a6 6 0 0 1 0-8.49m11.31-2.82a10 10 0 0 1 0 14.14m-14.14 0a10 10 0 0 1 0-14.14"></path>
                    </svg>
                    <span>Deadline Radar</span>
                </a>

                <!-- Goals -->
                <a href="${pageContext.request.contextPath}/goals.jsp" class="mt-nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
                    </svg>
                    <span>Goals</span>
                </a>

                <!-- Settings -->
                <a href="${pageContext.request.contextPath}/settings" class="mt-nav-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="12" cy="12" r="3"></circle>
                        <path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z"></path>
                    </svg>
                    <span>Settings</span>
                </a>
            </nav>

            <!-- Bottom Astronaut Illustration in Sidebar -->
            <div class="mt-sidebar-illustration">
                <img src="${pageContext.request.contextPath}/images/astronaut-tasks.jpg" alt="Study Buddy" onerror="this.style.display='none'">
            </div>
        </div>

        <!-- Sidebar Bottom Logout -->
        <div class="mt-sidebar-bottom">
            <a href="${pageContext.request.contextPath}/logout" class="mt-nav-item logout">
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
    <!-- MAIN WORKSPACE                                           -->
    <!-- ======================================================== -->
    <main class="mt-main">
        <!-- Top Bar -->
        <header class="mt-topbar">
            <!-- Search -->
            <div class="mt-search-box">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                    <circle cx="11" cy="11" r="8"></circle>
                    <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                </svg>
                <input type="text" placeholder="Search your tasks, subjects, or keywords..." id="taskSearchInput">
            </div>

            <!-- Profile & Notifications -->
            <div class="mt-user-area">
                <div class="mt-bell-btn" title="Notifications" onclick="showToast('You have 2 upcoming deadlines today!')">
                    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"></path>
                        <path d="M13.73 21a2 2 0 0 1-3.46 0"></path>
                    </svg>
                    <span class="mt-bell-dot"></span>
                </div>

                <a href="${pageContext.request.contextPath}/settings" class="mt-profile-pill">
                    <div class="mt-avatar">HM</div>
                    <div class="mt-profile-info">
                        <span class="mt-profile-name">Harish M</span>
                        <span class="mt-profile-role">CSE - 2nd Year</span>
                    </div>
                </a>
            </div>
        </header>

        <!-- Content Container -->
        <div class="mt-content-wrap">
            <!-- Header Row -->
            <div class="mt-header-row">
                <div class="mt-title-grp">
                    <h1>My <span class="mt-title-gradient">Tasks</span></h1>
                </div>

                <!-- Center Astronaut Banner Thumbnail -->
                <div class="mt-header-center-art">
                    <div class="mt-header-art-thumb">
                        <img src="${pageContext.request.contextPath}/images/astronaut-tasks.jpg" alt="Astronaut studying">
                    </div>
                </div>

                <button class="mt-add-task-btn" onclick="openAddTaskModal()">
                    <span>+</span>
                    <span>Add Task</span>
                </button>
            </div>

            <!-- Filter Tabs Row -->
            <div class="mt-filter-tabs">
                <button class="mt-tab-pill active" onclick="filterByTab('all', this)">All Tasks</button>
                <button class="mt-tab-pill" onclick="filterByTab('pending', this)">Pending</button>
                <button class="mt-tab-pill" onclick="filterByTab('completed', this)">Completed</button>
                <button class="mt-tab-pill" onclick="filterByTab('overdue', this)">Overdue</button>
                <button class="mt-tab-pill" onclick="filterByTab('today', this)">Today</button>
                <button class="mt-tab-pill" onclick="filterByTab('upcoming', this)">Upcoming</button>
            </div>

            <!-- 4 KPI Stat Cards -->
            <div class="mt-kpi-grid">
                <!-- KPI 1: Total Tasks -->
                <div class="mt-kpi-card">
                    <div class="mt-kpi-left">
                        <div class="mt-kpi-icon purple">
                            <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2.2">
                                <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                <line x1="16" y1="2" x2="16" y2="6"></line>
                                <line x1="8" y1="2" x2="8" y2="6"></line>
                                <polyline points="9 13 11 15 15 11"></polyline>
                            </svg>
                        </div>
                        <div>
                            <div class="mt-kpi-num" id="kpiTotal">12</div>
                            <div class="mt-kpi-label">Total Tasks</div>
                        </div>
                    </div>
                    <div class="mt-sparkline">
                        <div class="mt-spark-bar purple" style="height: 40%;"></div>
                        <div class="mt-spark-bar purple" style="height: 70%;"></div>
                        <div class="mt-spark-bar purple" style="height: 50%;"></div>
                        <div class="mt-spark-bar purple" style="height: 90%;"></div>
                    </div>
                </div>

                <!-- KPI 2: Pending -->
                <div class="mt-kpi-card">
                    <div class="mt-kpi-left">
                        <div class="mt-kpi-icon amber">
                            <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2.2">
                                <circle cx="12" cy="12" r="10"></circle>
                                <polyline points="12 6 12 12 16 14"></polyline>
                            </svg>
                        </div>
                        <div>
                            <div class="mt-kpi-num" id="kpiPending">6</div>
                            <div class="mt-kpi-label">Pending</div>
                        </div>
                    </div>
                    <div class="mt-sparkline">
                        <div class="mt-spark-bar amber" style="height: 60%;"></div>
                        <div class="mt-spark-bar amber" style="height: 35%;"></div>
                        <div class="mt-spark-bar amber" style="height: 80%;"></div>
                        <div class="mt-spark-bar amber" style="height: 55%;"></div>
                    </div>
                </div>

                <!-- KPI 3: Completed -->
                <div class="mt-kpi-card">
                    <div class="mt-kpi-left">
                        <div class="mt-kpi-icon green">
                            <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2.2">
                                <circle cx="12" cy="12" r="10"></circle>
                                <polyline points="9 12 11 14 15 10"></polyline>
                            </svg>
                        </div>
                        <div>
                            <div class="mt-kpi-num" id="kpiCompleted">4</div>
                            <div class="mt-kpi-label">Completed</div>
                        </div>
                    </div>
                    <div class="mt-sparkline">
                        <div class="mt-spark-bar green" style="height: 30%;"></div>
                        <div class="mt-spark-bar green" style="height: 65%;"></div>
                        <div class="mt-spark-bar green" style="height: 85%;"></div>
                        <div class="mt-spark-bar green" style="height: 70%;"></div>
                    </div>
                </div>

                <!-- KPI 4: Overdue -->
                <div class="mt-kpi-card">
                    <div class="mt-kpi-left">
                        <div class="mt-kpi-icon red">
                            <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2.2">
                                <circle cx="12" cy="12" r="10"></circle>
                                <line x1="12" y1="8" x2="12" y2="12"></line>
                                <line x1="12" y1="16" x2="12.01" y2="16"></line>
                            </svg>
                        </div>
                        <div>
                            <div class="mt-kpi-num" id="kpiOverdue" style="color: #f43f5e;">2</div>
                            <div class="mt-kpi-label">Overdue</div>
                        </div>
                    </div>
                    <div class="mt-sparkline">
                        <div class="mt-spark-bar red" style="height: 75%;"></div>
                        <div class="mt-spark-bar red" style="height: 40%;"></div>
                        <div class="mt-spark-bar red" style="height: 90%;"></div>
                        <div class="mt-spark-bar red" style="height: 30%;"></div>
                    </div>
                </div>
            </div>

            <!-- Two-Column Workspace -->
            <div class="mt-workspace-grid">

                <!-- ---------------- LEFT: TASK LIST ---------------- -->
                <div class="mt-tasklist-card">
                    <div class="mt-tl-header">
                        <div class="mt-tl-title-grp">
                            <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="#818cf8" stroke-width="2.2">
                                <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                <line x1="16" y1="2" x2="16" y2="6"></line>
                                <line x1="8" y1="2" x2="8" y2="6"></line>
                                <polyline points="9 13 11 15 15 11"></polyline>
                            </svg>
                            <span>Task List</span>
                        </div>

                        <div class="mt-tl-tools">
                            <select class="mt-sort-select" id="sortSelect" onchange="applySorting()">
                                <option value="due">Sort by: Due Time</option>
                                <option value="priority">Sort by: Priority</option>
                                <option value="name">Sort by: Name</option>
                            </select>

                            <button class="mt-icon-tool-btn" title="Toggle Filters" onclick="showToast('Filters are available in the right panel')">
                                <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2">
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
                            </button>
                        </div>
                    </div>

                    <!-- 8 Task Items -->
                    <div class="mt-rows-container" id="tasksListContainer">

                        <!-- Task 1: Complete DBMS Assignment -->
                        <div class="mt-task-row" data-id="1" data-status="pending" data-priority="high" data-subject="DBMS" data-due="today">
                            <div class="mt-accent-bar red"></div>
                            <div class="mt-checkbox-sq" onclick="toggleTaskRow(this)"></div>
                            <div class="mt-task-icon-box purple">
                                <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path>
                                    <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path>
                                </svg>
                            </div>
                            <div class="mt-task-details">
                                <div class="mt-task-title">Complete DBMS Assignment</div>
                                <div class="mt-task-sub">
                                    <span class="mt-task-sub-item">&#128100; DBMS</span>
                                    <span class="mt-task-sub-item">&#9719; Today, 04:00 PM</span>
                                </div>
                            </div>
                            <span class="mt-tag high">High</span>
                            <div class="mt-row-actions">
                                <button class="mt-act-btn" title="Edit" onclick="editTask(1)">&#9998;</button>
                                <button class="mt-act-btn delete" title="Delete" onclick="deleteTask(1)">&#128465;</button>
                            </div>
                        </div>

                        <!-- Task 2: Revise Java Notes -->
                        <div class="mt-task-row" data-id="2" data-status="pending" data-priority="medium" data-subject="OOP" data-due="today">
                            <div class="mt-accent-bar amber"></div>
                            <div class="mt-checkbox-sq" onclick="toggleTaskRow(this)"></div>
                            <div class="mt-task-icon-box orange">
                                <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                                    <polyline points="14 2 14 8 20 8"></polyline>
                                </svg>
                            </div>
                            <div class="mt-task-details">
                                <div class="mt-task-title">Revise Java Notes</div>
                                <div class="mt-task-sub">
                                    <span class="mt-task-sub-item">&#128100; OOP</span>
                                    <span class="mt-task-sub-item">&#9719; Today, 06:00 PM</span>
                                </div>
                            </div>
                            <span class="mt-tag medium">Medium</span>
                            <div class="mt-row-actions">
                                <button class="mt-act-btn" title="Edit" onclick="editTask(2)">&#9998;</button>
                                <button class="mt-act-btn delete" title="Delete" onclick="deleteTask(2)">&#128465;</button>
                            </div>
                        </div>

                        <!-- Task 3: Prepare Lab Record (Checked in Image) -->
                        <div class="mt-task-row checked-row" data-id="3" data-status="completed" data-priority="completed" data-subject="Operating Systems" data-due="today">
                            <div class="mt-accent-bar teal"></div>
                            <div class="mt-checkbox-sq checked" onclick="toggleTaskRow(this)">&#10003;</div>
                            <div class="mt-task-icon-box cyan">
                                <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M10 2v7.31L4.69 18.2A2 2 0 0 0 6.4 21h11.2a2 2 0 0 0 1.71-2.8L14 9.31V2"></path>
                                    <line x1="8.5" y1="2" x2="15.5" y2="2"></line>
                                </svg>
                            </div>
                            <div class="mt-task-details">
                                <div class="mt-task-title done">Prepare Lab Record</div>
                                <div class="mt-task-sub">
                                    <span class="mt-task-sub-item">&#128100; Operating Systems</span>
                                    <span class="mt-task-sub-item">&#9719; Today, 08:00 PM</span>
                                </div>
                            </div>
                            <span class="mt-tag completed">Completed</span>
                            <div class="mt-row-actions">
                                <button class="mt-act-btn" title="Edit" onclick="editTask(3)">&#9998;</button>
                                <button class="mt-act-btn delete" title="Delete" onclick="deleteTask(3)">&#128465;</button>
                            </div>
                        </div>

                        <!-- Task 4: Read Research Paper -->
                        <div class="mt-task-row" data-id="4" data-status="pending" data-priority="low" data-subject="AI & ML" data-due="today">
                            <div class="mt-accent-bar blue"></div>
                            <div class="mt-checkbox-sq" onclick="toggleTaskRow(this)"></div>
                            <div class="mt-task-icon-box cyan">
                                <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                                    <line x1="16" y1="13" x2="8" y2="13"></line>
                                    <line x1="16" y1="17" x2="8" y2="17"></line>
                                </svg>
                            </div>
                            <div class="mt-task-details">
                                <div class="mt-task-title">Read Research Paper</div>
                                <div class="mt-task-sub">
                                    <span class="mt-task-sub-item">&#128100; AI &amp; ML</span>
                                    <span class="mt-task-sub-item">&#9719; Today, 09:30 PM</span>
                                </div>
                            </div>
                            <span class="mt-tag low">Low</span>
                            <div class="mt-row-actions">
                                <button class="mt-act-btn" title="Edit" onclick="editTask(4)">&#9998;</button>
                                <button class="mt-act-btn delete" title="Delete" onclick="deleteTask(4)">&#128465;</button>
                            </div>
                        </div>

                        <!-- Task 5: Prepare for CAT 1 Exam -->
                        <div class="mt-task-row" data-id="5" data-status="pending" data-priority="high" data-subject="Data Science" data-due="upcoming">
                            <div class="mt-accent-bar red"></div>
                            <div class="mt-checkbox-sq" onclick="toggleTaskRow(this)"></div>
                            <div class="mt-task-icon-box pink">
                                <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M22 10v6M2 10l10-5 10 5-10 5z"></path>
                                    <path d="M6 12v5c3 3 9 3 12 0v-5"></path>
                                </svg>
                            </div>
                            <div class="mt-task-details">
                                <div class="mt-task-title">Prepare for CAT 1 Exam</div>
                                <div class="mt-task-sub">
                                    <span class="mt-task-sub-item">&#128187; Data Science</span>
                                    <span class="mt-task-sub-item">&#9719; Tomorrow, 10:00 AM</span>
                                </div>
                            </div>
                            <span class="mt-tag high">High</span>
                            <div class="mt-row-actions">
                                <button class="mt-act-btn" title="Edit" onclick="editTask(5)">&#9998;</button>
                                <button class="mt-act-btn delete" title="Delete" onclick="deleteTask(5)">&#128465;</button>
                            </div>
                        </div>

                        <!-- Task 6: Study Linear Regression -->
                        <div class="mt-task-row" data-id="6" data-status="pending" data-priority="medium" data-subject="Mathematics" data-due="upcoming">
                            <div class="mt-accent-bar amber"></div>
                            <div class="mt-checkbox-sq" onclick="toggleTaskRow(this)"></div>
                            <div class="mt-task-icon-box purple">
                                <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2">
                                    <polyline points="23 6 13.5 15.5 8.5 10.5 1 18"></polyline>
                                    <polyline points="17 6 23 6 23 12"></polyline>
                                </svg>
                            </div>
                            <div class="mt-task-details">
                                <div class="mt-task-title">Study Linear Regression</div>
                                <div class="mt-task-sub">
                                    <span class="mt-task-sub-item">&#128187; Mathematics</span>
                                    <span class="mt-task-sub-item">&#9719; Tomorrow, 03:00 PM</span>
                                </div>
                            </div>
                            <span class="mt-tag medium">Medium</span>
                            <div class="mt-row-actions">
                                <button class="mt-act-btn" title="Edit" onclick="editTask(6)">&#9998;</button>
                                <button class="mt-act-btn delete" title="Delete" onclick="deleteTask(6)">&#128465;</button>
                            </div>
                        </div>

                        <!-- Task 7: Update Project Documentation -->
                        <div class="mt-task-row" data-id="7" data-status="pending" data-priority="low" data-subject="OOPs + DBMS" data-due="upcoming">
                            <div class="mt-accent-bar blue"></div>
                            <div class="mt-checkbox-sq" onclick="toggleTaskRow(this)"></div>
                            <div class="mt-task-icon-box cyan">
                                <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2">
                                    <polyline points="16 18 22 12 16 6"></polyline>
                                    <polyline points="8 6 2 12 8 18"></polyline>
                                </svg>
                            </div>
                            <div class="mt-task-details">
                                <div class="mt-task-title">Update Project Documentation</div>
                                <div class="mt-task-sub">
                                    <span class="mt-task-sub-item">&#128187; OOPs + DBMS</span>
                                    <span class="mt-task-sub-item">&#128197; 16 Oct 2026</span>
                                </div>
                            </div>
                            <span class="mt-tag low">Low</span>
                            <div class="mt-row-actions">
                                <button class="mt-act-btn" title="Edit" onclick="editTask(7)">&#9998;</button>
                                <button class="mt-act-btn delete" title="Delete" onclick="deleteTask(7)">&#128465;</button>
                            </div>
                        </div>

                        <!-- Task 8: Practice NPTEL Questions -->
                        <div class="mt-task-row" data-id="8" data-status="pending" data-priority="medium" data-subject="Internet of Things" data-due="upcoming">
                            <div class="mt-accent-bar amber"></div>
                            <div class="mt-checkbox-sq" onclick="toggleTaskRow(this)"></div>
                            <div class="mt-task-icon-box purple">
                                <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2">
                                    <circle cx="12" cy="12" r="10"></circle>
                                    <line x1="2" y1="12" x2="22" y2="12"></line>
                                    <path d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z"></path>
                                </svg>
                            </div>
                            <div class="mt-task-details">
                                <div class="mt-task-title">Practice NPTEL Questions</div>
                                <div class="mt-task-sub">
                                    <span class="mt-task-sub-item">&#128187; Internet of Things</span>
                                    <span class="mt-task-sub-item">&#128260; 17 Oct 2026</span>
                                </div>
                            </div>
                            <span class="mt-tag medium">Medium</span>
                            <div class="mt-row-actions">
                                <button class="mt-act-btn" title="Edit" onclick="editTask(8)">&#9998;</button>
                                <button class="mt-act-btn delete" title="Delete" onclick="deleteTask(8)">&#128465;</button>
                            </div>
                        </div>

                    </div>
                </div>

                <!-- ---------------- RIGHT: WIDGETS ---------------- -->
                <div class="mt-sidebar-widgets">

                    <!-- Widget 1: Filters -->
                    <div class="mt-widget-box">
                        <div class="mt-widget-header">
                            <div class="mt-w-title-grp">
                                <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="#818cf8" stroke-width="2.2">
                                    <polygon points="22 3 2 3 10 12.46 10 19 14 21 14 12.46 22 3"></polygon>
                                </svg>
                                <span>Filters</span>
                            </div>
                            <span class="mt-reset-link" onclick="resetFilters()">Reset</span>
                        </div>

                        <div class="mt-filter-fields">
                            <div class="mt-filter-field">
                                <span class="mt-field-label">Subject</span>
                                <select class="mt-field-select" id="filterSubject" onchange="applyFilters()">
                                    <option value="all">All Subjects</option>
                                    <option value="DBMS">DBMS</option>
                                    <option value="OOP">OOP</option>
                                    <option value="Operating Systems">Operating Systems</option>
                                    <option value="AI & ML">AI &amp; ML</option>
                                    <option value="Data Science">Data Science</option>
                                    <option value="Mathematics">Mathematics</option>
                                    <option value="Internet of Things">Internet of Things</option>
                                </select>
                            </div>

                            <div class="mt-filter-field">
                                <span class="mt-field-label">Priority</span>
                                <select class="mt-field-select" id="filterPriority" onchange="applyFilters()">
                                    <option value="all">All Priorities</option>
                                    <option value="high">High</option>
                                    <option value="medium">Medium</option>
                                    <option value="low">Low</option>
                                </select>
                            </div>

                            <div class="mt-filter-field">
                                <span class="mt-field-label">Status</span>
                                <select class="mt-field-select" id="filterStatus" onchange="applyFilters()">
                                    <option value="all">All Tasks</option>
                                    <option value="pending">Pending</option>
                                    <option value="completed">Completed</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <!-- Widget 2: Quick Add -->
                    <div class="mt-widget-box">
                        <div class="mt-widget-header">
                            <div class="mt-w-title-grp">
                                <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="#f59e0b" stroke-width="2.2">
                                    <polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"></polygon>
                                </svg>
                                <span>Quick Add</span>
                            </div>
                        </div>

                        <div class="mt-quick-add-list">
                            <div class="mt-quick-item" onclick="openAddTaskModal('Study Task')">
                                <div class="mt-quick-left">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path>
                                        <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path>
                                    </svg>
                                    <span>Add Study Task</span>
                                </div>
                                <span class="mt-quick-arrow">&rarr;</span>
                            </div>

                            <div class="mt-quick-item" onclick="openAddTaskModal('Assignment')">
                                <div class="mt-quick-left">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                                        <polyline points="14 2 14 8 20 8"></polyline>
                                    </svg>
                                    <span>Add Assignment</span>
                                </div>
                                <span class="mt-quick-arrow">&rarr;</span>
                            </div>

                            <div class="mt-quick-item" onclick="openAddTaskModal('Personal Task')">
                                <div class="mt-quick-left">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                                        <circle cx="12" cy="7" r="4"></circle>
                                    </svg>
                                    <span>Add Personal Task</span>
                                </div>
                                <span class="mt-quick-arrow">&rarr;</span>
                            </div>

                            <div class="mt-quick-item" onclick="openAddTaskModal('Exam Preparation')">
                                <div class="mt-quick-left">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M22 10v6M2 10l10-5 10 5-10 5z"></path>
                                        <path d="M6 12v5c3 3 9 3 12 0v-5"></path>
                                    </svg>
                                    <span>Add Exam Preparation</span>
                                </div>
                                <span class="mt-quick-arrow">&rarr;</span>
                            </div>
                        </div>
                    </div>

                    <!-- Widget 3: Task Insights -->
                    <div class="mt-widget-box">
                        <div class="mt-widget-header">
                            <div class="mt-w-title-grp">
                                <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="#38bdf8" stroke-width="2.2">
                                    <line x1="18" y1="20" x2="18" y2="10"></line>
                                    <line x1="12" y1="20" x2="12" y2="4"></line>
                                    <line x1="6" y1="20" x2="6" y2="14"></line>
                                </svg>
                                <span>Task Insights</span>
                            </div>
                            <select class="mt-sort-select" style="padding: 3px 8px; font-size: 0.72rem;">
                                <option>This Week</option>
                                <option>Today</option>
                                <option>This Month</option>
                            </select>
                        </div>

                        <!-- Donut Chart & Legend -->
                        <div class="mt-donut-section">
                            <div class="mt-donut-wrap">
                                <svg width="100" height="100" viewBox="0 0 100 100">
                                    <!-- Background circle -->
                                    <circle cx="50" cy="50" r="38" fill="none" stroke="rgba(255,255,255,0.06)" stroke-width="11" />
                                    <!-- Completed: 33% = 78.8 of 238.76 circumference -->
                                    <circle cx="50" cy="50" r="38" fill="none" stroke="#10b981" stroke-width="11"
                                            stroke-dasharray="78.8 238.76" stroke-dashoffset="0" />
                                    <!-- Pending: 50% = 119.38 of 238.76 -->
                                    <circle cx="50" cy="50" r="38" fill="none" stroke="#f59e0b" stroke-width="11"
                                            stroke-dasharray="119.38 238.76" stroke-dashoffset="-78.8" />
                                    <!-- Overdue: 17% = 40.58 of 238.76 -->
                                    <circle cx="50" cy="50" r="38" fill="none" stroke="#f43f5e" stroke-width="11"
                                            stroke-dasharray="40.58 238.76" stroke-dashoffset="-198.18" />
                                </svg>
                                <div class="mt-donut-center">
                                    <div class="mt-donut-total" id="insightTotal">12</div>
                                    <div class="mt-donut-lbl">Total</div>
                                </div>
                            </div>

                            <div class="mt-donut-legend">
                                <div class="mt-legend-item">
                                    <div class="mt-legend-left">
                                        <span class="mt-legend-dot green"></span>
                                        <span>Completed</span>
                                    </div>
                                    <span id="legCompleted">4 (33%)</span>
                                </div>
                                <div class="mt-legend-item">
                                    <div class="mt-legend-left">
                                        <span class="mt-legend-dot amber"></span>
                                        <span>Pending</span>
                                    </div>
                                    <span id="legPending">6 (50%)</span>
                                </div>
                                <div class="mt-legend-item">
                                    <div class="mt-legend-left">
                                        <span class="mt-legend-dot red"></span>
                                        <span>Overdue</span>
                                    </div>
                                    <span id="legOverdue">2 (17%)</span>
                                </div>
                            </div>
                        </div>

                        <!-- Progress Bar -->
                        <div class="mt-insights-progress">
                            <div class="mt-progress-header">
                                <span class="mt-prog-label">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <circle cx="12" cy="12" r="10"></circle>
                                        <polyline points="12 6 12 12 14 14"></polyline>
                                    </svg>
                                    <span>Tasks Completed</span>
                                </span>
                                <span class="mt-prog-val" id="progPercent">33%</span>
                            </div>
                            <div class="mt-progress-track">
                                <div class="mt-progress-fill" id="progFill" style="width: 33%;"></div>
                            </div>
                        </div>

                    </div>

                </div>

            </div>
        </div>
    </main>
</div>

<!-- ======================================================== -->
<!-- MODAL: ADD / EDIT TASK                                    -->
<!-- ======================================================== -->
<div class="mt-modal-backdrop" id="taskModalBackdrop">
    <div class="mt-modal-box">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 14px;">
            <h3 id="taskModalTitle" style="color: #ffffff; font-size: 1.15rem; font-weight: 700;">Add New Task</h3>
            <button onclick="closeTaskModal()" style="background: transparent; border: none; color: #94a3b8; font-size: 1.4rem; cursor: pointer;">&times;</button>
        </div>
        <p style="color: #94a3b8; font-size: 0.82rem; margin-bottom: 18px;">Fill in the task details below:</p>

        <form id="taskForm" onsubmit="handleTaskSubmit(event)">
            <input type="hidden" id="editTaskId" value="">
            <div style="display: flex; flex-direction: column; gap: 14px;">
                <div>
                    <label style="display: block; font-size: 0.78rem; font-weight: 600; color: #cbd5e1; margin-bottom: 6px;">Task Title *</label>
                    <input type="text" id="taskInputTitle" required style="width: 100%; height: 38px; background: rgba(255,255,255,0.05); border: 1px solid rgba(255,255,255,0.12); border-radius: 8px; padding: 0 12px; color: #fff; font-size: 0.86rem; outline: none;" placeholder="e.g. Operating Systems Lab Assignment 3">
                </div>

                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 12px;">
                    <div>
                        <label style="display: block; font-size: 0.78rem; font-weight: 600; color: #cbd5e1; margin-bottom: 6px;">Subject / Course *</label>
                        <input type="text" id="taskInputSubject" required style="width: 100%; height: 38px; background: rgba(255,255,255,0.05); border: 1px solid rgba(255,255,255,0.12); border-radius: 8px; padding: 0 12px; color: #fff; font-size: 0.86rem; outline: none;" placeholder="e.g. DBMS, OOP, AI">
                    </div>
                    <div>
                        <label style="display: block; font-size: 0.78rem; font-weight: 600; color: #cbd5e1; margin-bottom: 6px;">Priority *</label>
                        <select id="taskInputPriority" style="width: 100%; height: 38px; background: #0f172a; border: 1px solid rgba(255,255,255,0.12); border-radius: 8px; padding: 0 10px; color: #fff; font-size: 0.86rem; outline: none;">
                            <option value="high">High</option>
                            <option value="medium" selected>Medium</option>
                            <option value="low">Low</option>
                        </select>
                    </div>
                </div>

                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 12px;">
                    <div>
                        <label style="display: block; font-size: 0.78rem; font-weight: 600; color: #cbd5e1; margin-bottom: 6px;">Due Date *</label>
                        <input type="date" id="taskInputDate" value="2026-10-12" style="width: 100%; height: 38px; background: rgba(255,255,255,0.05); border: 1px solid rgba(255,255,255,0.12); border-radius: 8px; padding: 0 10px; color: #fff; font-size: 0.86rem; outline: none;">
                    </div>
                    <div>
                        <label style="display: block; font-size: 0.78rem; font-weight: 600; color: #cbd5e1; margin-bottom: 6px;">Due Time *</label>
                        <input type="time" id="taskInputTime" value="18:00" style="width: 100%; height: 38px; background: rgba(255,255,255,0.05); border: 1px solid rgba(255,255,255,0.12); border-radius: 8px; padding: 0 10px; color: #fff; font-size: 0.86rem; outline: none;">
                    </div>
                </div>

                <div style="display: flex; justify-content: flex-end; gap: 10px; margin-top: 10px;">
                    <button type="button" onclick="closeTaskModal()" style="background: rgba(255,255,255,0.06); border: 1px solid rgba(255,255,255,0.1); color: #cbd5e1; padding: 8px 16px; border-radius: 8px; cursor: pointer;">Cancel</button>
                    <button type="submit" style="background: #4f46e5; border: none; color: #fff; font-weight: 600; padding: 8px 22px; border-radius: 8px; cursor: pointer;">Save Task</button>
                </div>
            </div>
        </form>
    </div>
</div>

<!-- Toast Box -->
<div class="mt-toast" id="toastBox">
    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="#a78bfa" stroke-width="2.2">
        <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
        <polyline points="22 4 12 14.01 9 11.01"></polyline>
    </svg>
    <span id="toastMsg">Operation successful</span>
</div>

<script>
    // Toast notification
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
    function openAddTaskModal(category) {
        document.getElementById('editTaskId').value = '';
        document.getElementById('taskModalTitle').textContent = category ? 'Add ' + category : 'Add New Task';
        document.getElementById('taskForm').reset();
        if (category) {
            document.getElementById('taskInputTitle').placeholder = 'e.g. New ' + category;
        }
        document.getElementById('taskModalBackdrop').style.display = 'flex';
        document.getElementById('taskInputTitle').focus();
    }

    function closeTaskModal() {
        document.getElementById('taskModalBackdrop').style.display = 'none';
        document.getElementById('taskForm').reset();
    }

    // Interactive Checkbox Toggle
    function toggleTaskRow(checkbox) {
        var row = checkbox.closest('.mt-task-row');
        var title = row.querySelector('.mt-task-title');
        var tag = row.querySelector('.mt-tag');
        var isChecked = checkbox.classList.contains('checked');

        if (isChecked) {
            checkbox.classList.remove('checked');
            checkbox.innerHTML = '';
            row.classList.remove('checked-row');
            title.classList.remove('done');
            row.setAttribute('data-status', 'pending');
            tag.className = 'mt-tag ' + row.getAttribute('data-priority');
            tag.textContent = row.getAttribute('data-priority').charAt(0).toUpperCase() + row.getAttribute('data-priority').slice(1);
            showToast('Task marked as pending');
        } else {
            checkbox.classList.add('checked');
            checkbox.innerHTML = '&#10003;';
            row.classList.add('checked-row');
            title.classList.add('done');
            row.setAttribute('data-status', 'completed');
            tag.className = 'mt-tag completed';
            tag.textContent = 'Completed';
            showToast('Task marked as completed!');
        }
        recalculateStats();
    }

    // Recalculate stats & donut chart
    function recalculateStats() {
        var rows = document.querySelectorAll('.mt-task-row');
        var total = rows.length;
        var completed = document.querySelectorAll('.mt-task-row[data-status="completed"]').length;
        var pending = total - completed;
        var overdue = 2; // Baseline overdue items

        document.getElementById('kpiTotal').textContent = total;
        document.getElementById('kpiPending').textContent = pending;
        document.getElementById('kpiCompleted').textContent = completed;
        document.getElementById('kpiOverdue').textContent = overdue;
        document.getElementById('insightTotal').textContent = total;

        var compPct = Math.round((completed / total) * 100);
        var pendPct = Math.round((pending / total) * 100);
        var overPct = 17;

        document.getElementById('legCompleted').textContent = completed + ' (' + compPct + '%)';
        document.getElementById('legPending').textContent = pending + ' (' + pendPct + '%)';
        document.getElementById('progPercent').textContent = compPct + '%';
        document.getElementById('progFill').style.width = compPct + '%';
    }

    // Tab Filters
    var currentTab = 'all';
    function filterByTab(tab, btn) {
        currentTab = tab;
        var tabs = document.querySelectorAll('.mt-tab-pill');
        tabs.forEach(function(t) { t.classList.remove('active'); });
        btn.classList.add('active');

        applyFilters();
    }

    // Multi-criteria filters
    function applyFilters() {
        var subject = document.getElementById('filterSubject').value;
        var priority = document.getElementById('filterPriority').value;
        var status = document.getElementById('filterStatus').value;
        var searchTerm = document.getElementById('taskSearchInput').value.toLowerCase();

        var rows = document.querySelectorAll('.mt-task-row');
        rows.forEach(function(row) {
            var rowSubject = row.getAttribute('data-subject') || '';
            var rowPriority = row.getAttribute('data-priority') || '';
            var rowStatus = row.getAttribute('data-status') || '';
            var rowDue = row.getAttribute('data-due') || '';
            var rowText = row.textContent.toLowerCase();

            var matchTab = true;
            if (currentTab === 'pending') matchTab = (rowStatus === 'pending');
            else if (currentTab === 'completed') matchTab = (rowStatus === 'completed');
            else if (currentTab === 'overdue') matchTab = (rowDue === 'overdue' || rowPriority === 'high');
            else if (currentTab === 'today') matchTab = (rowDue === 'today');
            else if (currentTab === 'upcoming') matchTab = (rowDue === 'upcoming');

            var matchSubject = (subject === 'all' || rowSubject.toLowerCase().includes(subject.toLowerCase()));
            var matchPriority = (priority === 'all' || rowPriority === priority);
            var matchStatus = (status === 'all' || rowStatus === status);
            var matchSearch = (searchTerm === '' || rowText.includes(searchTerm));

            if (matchTab && matchSubject && matchPriority && matchStatus && matchSearch) {
                row.style.display = 'flex';
            } else {
                row.style.display = 'none';
            }
        });
    }

    function resetFilters() {
        document.getElementById('filterSubject').value = 'all';
        document.getElementById('filterPriority').value = 'all';
        document.getElementById('filterStatus').value = 'all';
        document.getElementById('taskSearchInput').value = '';
        currentTab = 'all';
        var tabs = document.querySelectorAll('.mt-tab-pill');
        tabs.forEach(function(t, idx) {
            if (idx === 0) t.classList.add('active');
            else t.classList.remove('active');
        });
        applyFilters();
        showToast('All filters have been reset');
    }

    // Live Search
    document.getElementById('taskSearchInput').addEventListener('input', applyFilters);

    // Sorting
    function applySorting() {
        var sortVal = document.getElementById('sortSelect').value;
        var container = document.getElementById('tasksListContainer');
        var rows = Array.from(container.children);

        if (sortVal === 'name') {
            rows.sort(function(a, b) {
                return a.querySelector('.mt-task-title').textContent.localeCompare(b.querySelector('.mt-task-title').textContent);
            });
        } else if (sortVal === 'priority') {
            var pWeight = { 'high': 3, 'medium': 2, 'low': 1, 'completed': 0 };
            rows.sort(function(a, b) {
                return (pWeight[b.getAttribute('data-priority')] || 0) - (pWeight[a.getAttribute('data-priority')] || 0);
            });
        } else {
            // Default due
            rows.sort(function(a, b) {
                return parseInt(a.getAttribute('data-id')) - parseInt(b.getAttribute('data-id'));
            });
        }

        rows.forEach(function(row) { container.appendChild(row); });
        showToast('Sorted tasks list');
    }

    // Add / Edit submission
    function handleTaskSubmit(e) {
        e.preventDefault();
        var id = document.getElementById('editTaskId').value;
        var title = document.getElementById('taskInputTitle').value;
        var subject = document.getElementById('taskInputSubject').value;
        var priority = document.getElementById('taskInputPriority').value;
        var date = document.getElementById('taskInputDate').value;
        var time = document.getElementById('taskInputTime').value;

        if (id) {
            var row = document.querySelector('.mt-task-row[data-id="' + id + '"]');
            if (row) {
                row.querySelector('.mt-task-title').textContent = title;
                row.setAttribute('data-subject', subject);
                row.setAttribute('data-priority', priority);
                var tag = row.querySelector('.mt-tag');
                tag.className = 'mt-tag ' + priority;
                tag.textContent = priority.charAt(0).toUpperCase() + priority.slice(1);
            }
            showToast('Updated task: "' + title + '"');
        } else {
            showToast('New task "' + title + '" added successfully!');
        }
        closeTaskModal();
        recalculateStats();
    }

    function editTask(id) {
        var row = document.querySelector('.mt-task-row[data-id="' + id + '"]');
        if (!row) return;
        document.getElementById('editTaskId').value = id;
        document.getElementById('taskModalTitle').textContent = 'Edit Task';
        document.getElementById('taskInputTitle').value = row.querySelector('.mt-task-title').textContent.trim();
        document.getElementById('taskInputSubject').value = row.getAttribute('data-subject') || 'General';
        document.getElementById('taskInputPriority').value = row.getAttribute('data-priority') || 'medium';
        document.getElementById('taskModalBackdrop').style.display = 'flex';
    }

    function deleteTask(id) {
        var row = document.querySelector('.mt-task-row[data-id="' + id + '"]');
        if (row && confirm('Are you sure you want to delete this task?')) {
            row.style.transition = 'all 0.3s ease';
            row.style.opacity = '0';
            row.style.transform = 'translateX(20px)';
            setTimeout(function() {
                row.remove();
                recalculateStats();
                showToast('Task removed from your schedule');
            }, 300);
        }
    }
</script>

</body>
</html>
