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
    String displayName = (String) session.getAttribute("studentName");
    if (displayName == null || displayName.trim().isEmpty()) {
        displayName = "Harish M";
    }
    String yearRole = (String) session.getAttribute("yearOfStudy");
    if (yearRole == null || yearRole.trim().isEmpty()) {
        yearRole = "CSE - 2nd Year";
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Study Materials &mdash; SlotWise</title>
    <meta name="description" content="Organize and access all your academic resources in one place with SlotWise.">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg-app: #060913;
            --bg-sidebar: #080d1a;
            --bg-card: #0b1120;
            --bg-card-inner: #0f172a;
            --bg-card-hover: #131d35;
            --border-subtle: rgba(255, 255, 255, 0.07);
            --border-hover: rgba(255, 255, 255, 0.16);
            --primary-purple: #6366f1;
            --primary-purple-hover: #4f46e5;
            --primary-purple-glow: rgba(99, 102, 241, 0.4);
            --accent-purple: #a855f7;
            --accent-blue: #38bdf8;
            --accent-pink: #ec4899;
            --accent-emerald: #10b981;
            --accent-amber: #f59e0b;
            --accent-orange: #f97316;
            --accent-cyan: #06b6d4;
            --accent-indigo: #818cf8;
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

        a {
            color: inherit;
            text-decoration: none;
        }

        button {
            font-family: inherit;
            cursor: pointer;
        }

        /* Ambient Glow in background */
        .sw-layout {
            display: flex;
            min-height: 100vh;
            background-color: var(--bg-app);
            position: relative;
        }

        .sw-layout::before {
            content: '';
            position: fixed;
            top: -120px;
            right: -100px;
            width: 500px;
            height: 500px;
            background: radial-gradient(circle, rgba(99, 102, 241, 0.12) 0%, rgba(168, 85, 247, 0.06) 40%, transparent 70%);
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
            z-index: 30;
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
            font-size: 0.88rem;
            font-weight: 500;
            transition: all 0.2s ease;
            text-decoration: none;
        }

        .sw-nav-item:hover {
            color: #ffffff;
            background: rgba(255, 255, 255, 0.05);
        }

        .sw-nav-item.active {
            background: linear-gradient(135deg, #6366f1 0%, #7c3aed 100%);
            color: #ffffff;
            font-weight: 600;
            box-shadow: 0 4px 16px var(--primary-purple-glow);
        }

        .sw-nav-item svg {
            width: 19px;
            height: 19px;
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
            color: #f87171;
            background: rgba(239, 68, 68, 0.1);
        }

        /* ======================================================== */
        /* MAIN CONTENT AREA                                        */
        /* ======================================================== */
        .sw-main {
            flex: 1;
            display: flex;
            flex-direction: column;
            min-width: 0;
            position: relative;
            z-index: 1;
        }

        /* Top Bar */
        .sw-topbar {
            height: 70px;
            border-bottom: 1px solid var(--border-subtle);
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 32px;
            background: rgba(6, 9, 19, 0.85);
            backdrop-filter: blur(14px);
            position: sticky;
            top: 0;
            z-index: 20;
        }

        .sw-search-box {
            position: relative;
            width: 440px;
            max-width: 100%;
        }

        .sw-search-box svg {
            position: absolute;
            left: 14px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-muted);
            pointer-events: none;
        }

        .sw-search-input {
            width: 100%;
            height: 42px;
            background: rgba(255, 255, 255, 0.04);
            border: 1px solid var(--border-subtle);
            border-radius: 22px;
            padding: 0 16px 0 44px;
            color: #ffffff;
            font-size: 0.88rem;
            outline: none;
            transition: all 0.25s ease;
        }

        .sw-search-input:focus {
            background: rgba(255, 255, 255, 0.07);
            border-color: #6366f1;
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.2);
        }

        .sw-search-input::placeholder {
            color: #64748b;
        }

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
            background: rgba(255, 255, 255, 0.04);
            border: 1px solid var(--border-subtle);
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--text-muted);
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .sw-bell-btn:hover {
            color: #ffffff;
            border-color: var(--border-hover);
            background: rgba(255, 255, 255, 0.08);
        }

        .sw-bell-dot {
            position: absolute;
            top: 8px;
            right: 8px;
            width: 8px;
            height: 8px;
            background-color: #ef4444;
            border-radius: 50%;
            border: 2px solid var(--bg-app);
        }

        .sw-profile-pill {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 4px 12px 4px 4px;
            border-radius: 26px;
            background: rgba(255, 255, 255, 0.03);
            border: 1px solid var(--border-subtle);
            text-decoration: none;
            transition: all 0.2s ease;
        }

        .sw-profile-pill:hover {
            background: rgba(255, 255, 255, 0.07);
            border-color: var(--border-hover);
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
            color: #ffffff;
            font-size: 0.78rem;
            font-weight: 700;
        }

        .sw-avatar img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .sw-profile-info {
            display: flex;
            flex-direction: column;
            line-height: 1.25;
            text-align: left;
        }

        .sw-profile-name {
            font-size: 0.84rem;
            font-weight: 600;
            color: #ffffff;
        }

        .sw-profile-role {
            font-size: 0.72rem;
            color: var(--text-muted);
        }

        .sw-profile-chevron {
            color: var(--text-muted);
            margin-left: 2px;
        }

        /* Content Container */
        .sw-content-wrap {
            padding: 28px 32px 48px;
            display: flex;
            flex-direction: column;
            gap: 26px;
            max-width: 100%;
            overflow: hidden;
        }

        /* ======================================================== */
        /* PAGE HERO BANNER                                         */
        /* ======================================================== */
        .sw-hero-banner {
            display: flex;
            justify-content: space-between;
            align-items: center;
            position: relative;
            padding: 4px 0 8px;
            min-height: 64px;
        }

        .sw-hero-left h1 {
            font-size: 2.15rem;
            font-weight: 800;
            color: #ffffff;
            letter-spacing: -0.025em;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .sw-hero-left h1 .highlight {
            background: linear-gradient(135deg, #a78bfa 0%, #818cf8 50%, #6366f1 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .sw-hero-left p {
            font-size: 0.95rem;
            color: var(--text-muted);
            margin-top: 6px;
        }

        .sw-hero-right {
            display: flex;
            align-items: center;
            gap: 20px;
            position: relative;
        }

        /* Decorative 3D Glass Cubes */
        .sw-cube-decor {
            width: 70px;
            height: 70px;
            background: linear-gradient(135deg, rgba(99, 102, 241, 0.4) 0%, rgba(168, 85, 247, 0.2) 100%);
            border-radius: 18px;
            position: relative;
            box-shadow: 0 8px 32px rgba(99, 102, 241, 0.35);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.15);
        }

        .sw-cube-decor-small {
            width: 26px;
            height: 26px;
            background: linear-gradient(135deg, rgba(168, 85, 247, 0.45) 0%, rgba(99, 102, 241, 0.3) 100%);
            border-radius: 8px;
            position: absolute;
            right: 170px;
            bottom: 4px;
            border: 1px solid rgba(255, 255, 255, 0.12);
            box-shadow: 0 4px 16px rgba(168, 85, 247, 0.25);
        }

        .sw-upload-btn {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            padding: 12px 22px;
            border-radius: 12px;
            background: linear-gradient(135deg, #6366f1 0%, #7c3aed 100%);
            color: #ffffff;
            font-size: 0.9rem;
            font-weight: 600;
            border: none;
            box-shadow: 0 6px 20px rgba(99, 102, 241, 0.45);
            transition: all 0.25s ease;
        }

        .sw-upload-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 28px rgba(99, 102, 241, 0.6);
            background: linear-gradient(135deg, #4f46e5 0%, #6d28d9 100%);
        }

        .sw-upload-btn svg {
            width: 18px;
            height: 18px;
        }

        /* ======================================================== */
        /* FILTER TABS                                              */
        /* ======================================================== */
        .sw-filter-tabs {
            display: flex;
            align-items: center;
            gap: 8px;
            flex-wrap: wrap;
        }

        .sw-tab-pill {
            padding: 8px 18px;
            border-radius: 20px;
            background: rgba(255, 255, 255, 0.04);
            border: 1px solid var(--border-subtle);
            color: var(--text-muted);
            font-size: 0.85rem;
            font-weight: 500;
            transition: all 0.2s ease;
            cursor: pointer;
        }

        .sw-tab-pill:hover {
            color: #ffffff;
            border-color: var(--border-hover);
            background: rgba(255, 255, 255, 0.08);
        }

        .sw-tab-pill.active {
            background: #6366f1;
            border-color: #6366f1;
            color: #ffffff;
            font-weight: 600;
            box-shadow: 0 4px 14px rgba(99, 102, 241, 0.4);
        }

        /* ======================================================== */
        /* TOP ROW: 4 STAT CARDS + 1 STORAGE CARD                   */
        /* ======================================================== */
        .sw-stats-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr) minmax(240px, 320px);
            gap: 16px;
            align-items: stretch;
        }

        @media (max-width: 1400px) {
            .sw-stats-grid {
                grid-template-columns: repeat(3, 1fr);
            }
            .sw-stats-grid .sw-storage-card {
                grid-column: span 3;
            }
        }

        @media (max-width: 900px) {
            .sw-stats-grid {
                grid-template-columns: repeat(2, 1fr);
            }
            .sw-stats-grid .sw-storage-card {
                grid-column: span 2;
            }
        }

        @media (max-width: 600px) {
            .sw-stats-grid {
                grid-template-columns: 1fr;
            }
            .sw-stats-grid .sw-storage-card {
                grid-column: span 1;
            }
        }

        .sw-stat-card {
            background-color: var(--bg-card);
            border: 1px solid var(--border-subtle);
            border-radius: 14px;
            padding: 18px 20px;
            display: flex;
            align-items: center;
            gap: 16px;
            transition: all 0.25s ease;
            cursor: pointer;
            position: relative;
            overflow: hidden;
        }

        .sw-stat-card::after {
            content: '';
            position: absolute;
            inset: 0;
            background: radial-gradient(circle at center, rgba(99, 102, 241, 0.08) 0%, transparent 70%);
            opacity: 0;
            transition: opacity 0.3s ease;
            pointer-events: none;
        }

        .sw-stat-card:hover {
            border-color: rgba(99, 102, 241, 0.35);
            transform: translateY(-3px);
            box-shadow: 0 8px 28px rgba(0, 0, 0, 0.3), 0 0 20px rgba(99, 102, 241, 0.12);
        }

        .sw-stat-card:hover::after {
            opacity: 1;
        }

        .sw-stat-card:active {
            transform: translateY(-1px);
            transition-duration: 0.08s;
        }

        .sw-stat-icon-box {
            width: 48px;
            height: 48px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        .sw-stat-icon-box.purple {
            background: linear-gradient(135deg, #7c3aed 0%, #6366f1 100%);
            box-shadow: 0 4px 16px rgba(124, 58, 237, 0.35);
            color: #ffffff;
        }

        .sw-stat-icon-box.blue {
            background: linear-gradient(135deg, #2563eb 0%, #38bdf8 100%);
            box-shadow: 0 4px 16px rgba(37, 99, 235, 0.35);
            color: #ffffff;
        }

        .sw-stat-icon-box.cyan {
            background: linear-gradient(135deg, #0284c7 0%, #06b6d4 100%);
            box-shadow: 0 4px 16px rgba(6, 182, 212, 0.35);
            color: #ffffff;
        }

        .sw-stat-icon-box.amber {
            background: linear-gradient(135deg, #d97706 0%, #f59e0b 100%);
            box-shadow: 0 4px 16px rgba(245, 158, 11, 0.35);
            color: #ffffff;
        }

        .sw-stat-info {
            display: flex;
            flex-direction: column;
        }

        .sw-stat-value {
            font-size: 1.45rem;
            font-weight: 700;
            color: #ffffff;
            letter-spacing: -0.02em;
        }

        .sw-stat-label {
            font-size: 0.8rem;
            color: var(--text-muted);
            margin-top: 2px;
        }

        /* Storage Card */
        .sw-storage-card {
            background-color: var(--bg-card);
            border: 1px solid var(--border-subtle);
            border-radius: 14px;
            padding: 18px 20px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            gap: 12px;
        }

        .sw-storage-header {
            font-size: 0.82rem;
            color: var(--text-muted);
            font-weight: 500;
        }

        .sw-progress-track {
            width: 100%;
            height: 8px;
            background: rgba(255, 255, 255, 0.08);
            border-radius: 6px;
            overflow: hidden;
            position: relative;
        }

        .sw-progress-fill {
            height: 100%;
            width: 32%;
            background: linear-gradient(90deg, #6366f1 0%, #a855f7 100%);
            border-radius: 6px;
            box-shadow: 0 0 10px rgba(99, 102, 241, 0.5);
            transition: width 0.6s ease;
        }

        .sw-storage-bottom {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 0.78rem;
            color: var(--text-muted);
        }

        .sw-storage-pct {
            font-weight: 700;
            color: #ffffff;
        }

        /* ======================================================== */
        /* TWO COLUMN MAIN CONTENT                                  */
        /* ======================================================== */
        .sw-layout-grid {
            display: grid;
            grid-template-columns: 1fr 320px;
            gap: 24px;
            align-items: start;
        }

        @media (max-width: 1200px) {
            .sw-layout-grid {
                grid-template-columns: 1fr 280px;
                gap: 18px;
            }
        }

        @media (max-width: 1000px) {
            .sw-layout-grid {
                grid-template-columns: 1fr;
            }
        }

        /* Left Column */
        .sw-left-col {
            display: flex;
            flex-direction: column;
            gap: 24px;
            min-width: 0;
        }

        /* Subjects Section */
        .sw-section-card {
            background-color: var(--bg-card);
            border: 1px solid var(--border-subtle);
            border-radius: 16px;
            padding: 22px;
            transition: box-shadow 0.5s ease;
        }

        .sw-section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .sw-section-title {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 1.05rem;
            font-weight: 700;
            color: #ffffff;
        }

        .sw-section-title svg {
            color: #a78bfa;
            width: 20px;
            height: 20px;
        }

        .sw-view-all {
            display: flex;
            align-items: center;
            gap: 6px;
            color: #818cf8;
            font-size: 0.82rem;
            font-weight: 600;
            transition: all 0.2s ease;
        }

        .sw-view-all:hover {
            color: #a78bfa;
            transform: translateX(3px);
        }

        /* 8 Subject Cards (4x2 Grid) */
        .sw-subjects-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 14px;
        }

        @media (max-width: 1400px) {
            .sw-subjects-grid {
                grid-template-columns: repeat(3, minmax(0, 1fr));
            }
        }

        @media (max-width: 1100px) {
            .sw-subjects-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
        }

        @media (max-width: 540px) {
            .sw-subjects-grid {
                grid-template-columns: 1fr;
            }
        }

        .sw-subject-item {
            background: rgba(255, 255, 255, 0.025);
            border: 1px solid var(--border-subtle);
            border-radius: 12px;
            padding: 16px;
            display: flex;
            align-items: flex-start;
            gap: 14px;
            position: relative;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .sw-subject-item:hover {
            background: rgba(255, 255, 255, 0.05);
            border-color: var(--border-hover);
            transform: translateY(-2px);
        }

        .sw-folder-icon {
            width: 44px;
            height: 44px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        .sw-folder-icon svg {
            width: 24px;
            height: 24px;
        }

        /* Custom Folder Colors */
        .sw-folder-blue {
            background: rgba(56, 189, 248, 0.14);
            color: #38bdf8;
        }
        .sw-folder-purple {
            background: rgba(168, 85, 247, 0.14);
            color: #c084fc;
        }
        .sw-folder-pink {
            background: rgba(236, 72, 153, 0.14);
            color: #f472b6;
        }
        .sw-folder-yellow {
            background: rgba(245, 158, 11, 0.14);
            color: #fbbf24;
        }
        .sw-folder-green {
            background: rgba(16, 185, 129, 0.14);
            color: #34d399;
        }
        .sw-folder-cyan {
            background: rgba(6, 182, 212, 0.14);
            color: #22d3ee;
        }
        .sw-folder-indigo {
            background: rgba(129, 140, 248, 0.14);
            color: #a5b4fc;
        }
        .sw-folder-coral {
            background: rgba(244, 63, 94, 0.14);
            color: #fb7185;
        }

        .sw-subject-content {
            flex: 1;
            min-width: 0;
            padding-right: 18px;
        }

        .sw-subject-name {
            font-size: 0.86rem;
            font-weight: 600;
            color: #ffffff;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            line-height: 1.3;
        }

        .sw-subject-files {
            font-size: 0.74rem;
            color: var(--text-muted);
            margin-top: 4px;
        }

        .sw-card-menu-btn {
            position: absolute;
            top: 14px;
            right: 12px;
            background: transparent;
            border: none;
            color: var(--text-dim);
            padding: 2px 4px;
            border-radius: 4px;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.2s ease;
        }

        .sw-card-menu-btn:hover {
            color: #ffffff;
            background: rgba(255, 255, 255, 0.08);
        }

        /* ======================================================== */
        /* RECENT MATERIALS TABLE / LIST                            */
        /* ======================================================== */
        .sw-files-list {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .sw-file-row {
            display: flex;
            align-items: center;
            gap: 14px;
            padding: 12px 16px;
            border-radius: 12px;
            background: rgba(255, 255, 255, 0.02);
            border: 1px solid transparent;
            transition: all 0.2s ease;
            min-width: 0;
        }

        .sw-file-row:hover {
            background: rgba(255, 255, 255, 0.045);
            border-color: var(--border-subtle);
        }

        .sw-file-icon {
            width: 40px;
            height: 40px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        .sw-file-icon.pdf {
            background: rgba(239, 68, 68, 0.15);
            color: #f87171;
        }

        .sw-file-icon.docx {
            background: rgba(59, 130, 246, 0.15);
            color: #60a5fa;
        }

        .sw-file-icon.img {
            background: rgba(16, 185, 129, 0.15);
            color: #34d399;
        }

        .sw-file-icon.zip {
            background: rgba(245, 158, 11, 0.15);
            color: #fbbf24;
        }

        .sw-file-main {
            flex: 1;
            min-width: 0;
        }

        .sw-file-name {
            font-size: 0.88rem;
            font-weight: 600;
            color: #ffffff;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .sw-file-size {
            font-size: 0.74rem;
            color: var(--text-muted);
            margin-top: 3px;
        }

        /* Subject Badges */
        .sw-badge {
            padding: 4px 10px;
            border-radius: 14px;
            font-size: 0.72rem;
            font-weight: 600;
            letter-spacing: 0.02em;
            flex-shrink: 0;
        }

        .sw-badge.dbms {
            background: rgba(168, 85, 247, 0.15);
            color: #c084fc;
            border: 1px solid rgba(168, 85, 247, 0.25);
        }

        .sw-badge.oop {
            background: rgba(56, 189, 248, 0.15);
            color: #38bdf8;
            border: 1px solid rgba(56, 189, 248, 0.25);
        }

        .sw-badge.iot {
            background: rgba(20, 184, 166, 0.15);
            color: #2dd4bf;
            border: 1px solid rgba(20, 184, 166, 0.25);
        }

        .sw-badge.ds {
            background: rgba(16, 185, 129, 0.15);
            color: #34d399;
            border: 1px solid rgba(16, 185, 129, 0.25);
        }

        .sw-badge.mixed {
            background: rgba(99, 102, 241, 0.15);
            color: #a5b4fc;
            border: 1px solid rgba(99, 102, 241, 0.25);
        }

        .sw-file-date {
            font-size: 0.78rem;
            color: var(--text-muted);
            flex-shrink: 0;
            min-width: 140px;
            text-align: right;
            white-space: nowrap;
        }

        @media (max-width: 900px) {
            .sw-file-date {
                display: none;
            }
        }

        .sw-file-actions {
            display: flex;
            align-items: center;
            gap: 8px;
            flex-shrink: 0;
        }

        .sw-star-btn {
            background: transparent;
            border: none;
            color: var(--text-dim);
            font-size: 1.15rem;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            padding: 4px;
            border-radius: 6px;
            transition: all 0.2s ease;
        }

        .sw-star-btn:hover {
            color: #fbbf24;
            transform: scale(1.15);
        }

        .sw-star-btn.starred {
            color: #f59e0b;
        }

        .sw-row-menu-btn {
            background: transparent;
            border: none;
            color: var(--text-dim);
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            padding: 4px 6px;
            border-radius: 6px;
            transition: all 0.2s ease;
        }

        .sw-row-menu-btn:hover {
            color: #ffffff;
            background: rgba(255, 255, 255, 0.08);
        }

        /* ======================================================== */
        /* RIGHT COLUMN WIDGETS                                     */
        /* ======================================================== */
        .sw-right-col {
            display: flex;
            flex-direction: column;
            gap: 20px;
            position: sticky;
            top: 90px;
            align-self: start;
            max-height: calc(100vh - 110px);
            overflow-y: auto;
            scrollbar-width: thin;
            scrollbar-color: rgba(255, 255, 255, 0.1) transparent;
        }

        .sw-right-col::-webkit-scrollbar {
            width: 4px;
        }
        .sw-right-col::-webkit-scrollbar-thumb {
            background: rgba(255, 255, 255, 0.1);
            border-radius: 4px;
        }

        @media (max-width: 1000px) {
            .sw-right-col {
                position: static;
                max-height: none;
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            }
        }

        .sw-widget {
            background-color: var(--bg-card);
            border: 1px solid var(--border-subtle);
            border-radius: 16px;
            padding: 20px;
            min-width: 0;
        }

        .sw-widget-title {
            display: flex;
            align-items: center;
            justify-content: space-between;
            font-size: 0.95rem;
            font-weight: 700;
            color: #ffffff;
            margin-bottom: 16px;
        }

        .sw-widget-title-left {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .sw-widget-title-left svg {
            color: #a78bfa;
            width: 18px;
            height: 18px;
        }

        /* Quick Actions */
        .sw-action-list {
            display: flex;
            flex-direction: column;
            gap: 6px;
        }

        .sw-action-btn {
            display: flex;
            align-items: center;
            justify-content: space-between;
            width: 100%;
            padding: 11px 14px;
            border-radius: 10px;
            background: rgba(255, 255, 255, 0.025);
            border: 1px solid transparent;
            color: var(--text-primary);
            font-size: 0.85rem;
            font-weight: 500;
            transition: all 0.2s ease;
            text-align: left;
        }

        .sw-action-btn:hover {
            background: rgba(99, 102, 241, 0.1);
            border-color: rgba(99, 102, 241, 0.25);
            color: #ffffff;
            transform: translateX(2px);
        }

        .sw-action-left {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .sw-action-left svg {
            color: #818cf8;
            width: 17px;
            height: 17px;
        }

        .sw-action-arrow {
            color: var(--text-dim);
            font-size: 0.95rem;
            transition: transform 0.2s ease;
        }

        .sw-action-btn:hover .sw-action-arrow {
            color: #a78bfa;
            transform: translateX(3px);
        }

        /* Popular Resources */
        .sw-res-list {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .sw-res-item {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 8px 10px;
            border-radius: 8px;
            color: var(--text-primary);
            font-size: 0.83rem;
            font-weight: 500;
            transition: all 0.2s ease;
            cursor: pointer;
        }

        .sw-res-item:hover {
            color: #ffffff;
            background: rgba(255, 255, 255, 0.04);
            transform: translateX(3px);
        }

        .sw-res-item svg {
            color: #818cf8;
            width: 17px;
            height: 17px;
            flex-shrink: 0;
        }

        /* Tags */
        .sw-tags-wrap {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
        }

        .sw-tag-chip {
            padding: 5px 12px;
            border-radius: 14px;
            font-size: 0.74rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s ease;
            border: 1px solid transparent;
        }

        .sw-tag-chip:hover {
            transform: scale(1.05);
        }

        .sw-tag-notes {
            background: rgba(180, 83, 9, 0.22);
            color: #fbbf24;
            border-color: rgba(245, 158, 11, 0.3);
        }

        .sw-tag-pyq {
            background: rgba(190, 18, 60, 0.22);
            color: #f43f5e;
            border-color: rgba(244, 63, 94, 0.3);
        }

        .sw-tag-important {
            background: rgba(29, 78, 216, 0.22);
            color: #60a5fa;
            border-color: rgba(59, 130, 246, 0.3);
        }

        .sw-tag-unit {
            background: rgba(109, 40, 217, 0.25);
            color: #c084fc;
            border-color: rgba(168, 85, 247, 0.3);
        }

        .sw-tag-lab {
            background: rgba(113, 63, 18, 0.28);
            color: #fde047;
            border-color: rgba(234, 179, 8, 0.3);
        }

        .sw-tag-ref {
            background: rgba(15, 118, 110, 0.22);
            color: #2dd4bf;
            border-color: rgba(20, 184, 166, 0.3);
        }

        .sw-tag-summary {
            background: rgba(49, 46, 129, 0.3);
            color: #a5b4fc;
            border-color: rgba(99, 102, 241, 0.3);
        }

        /* ======================================================== */
        /* MODAL STYLES                                             */
        /* ======================================================== */
        .sw-modal-backdrop {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(3, 7, 18, 0.75);
            backdrop-filter: blur(8px);
            z-index: 100;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .sw-modal-card {
            background: #0d1527;
            border: 1px solid var(--border-hover);
            border-radius: 18px;
            width: 520px;
            max-width: 100%;
            padding: 28px;
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.6), 0 0 40px rgba(99, 102, 241, 0.15);
            position: relative;
            animation: modalFadeIn 0.25s ease-out;
        }

        @keyframes modalFadeIn {
            from {
                opacity: 0;
                transform: scale(0.96) translateY(10px);
            }
            to {
                opacity: 1;
                transform: scale(1) translateY(0);
            }
        }

        .sw-modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .sw-modal-title {
            font-size: 1.25rem;
            font-weight: 700;
            color: #ffffff;
        }

        .sw-modal-close {
            background: transparent;
            border: none;
            color: var(--text-muted);
            font-size: 1.3rem;
            cursor: pointer;
            padding: 4px 8px;
            border-radius: 6px;
        }

        .sw-modal-close:hover {
            color: #ffffff;
            background: rgba(255, 255, 255, 0.08);
        }

        .sw-form-group {
            margin-bottom: 16px;
        }

        .sw-form-label {
            display: block;
            font-size: 0.8rem;
            font-weight: 600;
            color: #cbd5e1;
            margin-bottom: 6px;
        }

        .sw-form-input, .sw-form-select {
            width: 100%;
            height: 42px;
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid var(--border-subtle);
            border-radius: 10px;
            padding: 0 14px;
            color: #ffffff;
            font-size: 0.88rem;
            outline: none;
            transition: all 0.2s ease;
        }

        .sw-form-input:focus, .sw-form-select:focus {
            border-color: #6366f1;
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.2);
            background: rgba(255, 255, 255, 0.08);
        }

        .sw-form-select option {
            background: #0f172a;
            color: #ffffff;
        }

        .sw-drop-zone {
            border: 2px dashed rgba(99, 102, 241, 0.4);
            border-radius: 12px;
            padding: 24px;
            text-align: center;
            cursor: pointer;
            background: rgba(99, 102, 241, 0.04);
            transition: all 0.2s ease;
            margin-bottom: 16px;
        }

        .sw-drop-zone:hover {
            border-color: #818cf8;
            background: rgba(99, 102, 241, 0.08);
        }

        .sw-drop-zone svg {
            width: 36px;
            height: 36px;
            color: #818cf8;
            margin-bottom: 8px;
        }

        .sw-drop-text {
            font-size: 0.86rem;
            color: #e2e8f0;
            font-weight: 600;
        }

        .sw-drop-hint {
            font-size: 0.74rem;
            color: var(--text-muted);
            margin-top: 4px;
        }

        .sw-modal-actions {
            display: flex;
            justify-content: flex-end;
            gap: 12px;
            margin-top: 22px;
        }

        .sw-btn-cancel {
            background: rgba(255, 255, 255, 0.06);
            border: 1px solid rgba(255, 255, 255, 0.1);
            color: #cbd5e1;
            padding: 10px 18px;
            border-radius: 10px;
            font-size: 0.86rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .sw-btn-cancel:hover {
            background: rgba(255, 255, 255, 0.1);
            color: #ffffff;
        }

        .sw-btn-submit {
            background: linear-gradient(135deg, #6366f1 0%, #7c3aed 100%);
            border: none;
            color: #ffffff;
            padding: 10px 24px;
            border-radius: 10px;
            font-size: 0.86rem;
            font-weight: 600;
            box-shadow: 0 4px 14px rgba(99, 102, 241, 0.4);
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .sw-btn-submit:hover {
            box-shadow: 0 6px 20px rgba(99, 102, 241, 0.55);
            transform: translateY(-1px);
        }

        /* Toast Container */
        .sw-toast {
            position: fixed;
            bottom: 30px;
            right: 32px;
            background: #0f172a;
            border: 1px solid #6366f1;
            padding: 14px 20px;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.5), 0 0 20px rgba(99, 102, 241, 0.3);
            display: flex;
            align-items: center;
            gap: 12px;
            color: #ffffff;
            font-size: 0.88rem;
            font-weight: 500;
            z-index: 200;
            opacity: 0;
            transform: translateY(20px);
            pointer-events: none;
            transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
        }

        .sw-toast.show {
            opacity: 1;
            transform: translateY(0);
            pointer-events: auto;
        }

        /* Context Dropdown */
        .sw-context-menu {
            position: absolute;
            background: #0f172a;
            border: 1px solid var(--border-hover);
            border-radius: 10px;
            padding: 6px;
            min-width: 160px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.5);
            z-index: 150;
            display: none;
        }

        .sw-context-menu.open {
            display: block;
        }

        .sw-context-item {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 8px 12px;
            border-radius: 6px;
            font-size: 0.82rem;
            color: #cbd5e1;
            cursor: pointer;
            transition: all 0.15s ease;
        }

        .sw-context-item:hover {
            background: rgba(99, 102, 241, 0.15);
            color: #ffffff;
        }

        .sw-context-item.danger:hover {
            background: rgba(239, 68, 68, 0.15);
            color: #f87171;
        }
    </style>
</head>
<body>

<div class="sw-layout">

    <!-- ======================================================== -->
    <!-- LEFT SIDEBAR                                             -->
    <!-- ======================================================== -->
    <aside class="sw-sidebar">
        <div>
            <!-- Brand Logo -->
            <a href="${pageContext.request.contextPath}/dashboard" class="sw-logo">
                <div class="sw-logo-icon">
                    <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M22 10v6M2 10l10-5 10 5-10 5z"></path>
                        <path d="M6 12v5c3 3 9 3 12 0v-5"></path>
                    </svg>
                </div>
                <div class="sw-logo-text">Slot<span>Wise</span></div>
            </a>

            <!-- Navigation Links -->
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

                <!-- Materials (ACTIVE) -->
                <a href="${pageContext.request.contextPath}/materials.jsp" class="sw-nav-item active">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path>
                        <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path>
                    </svg>
                    <span>Materials</span>
                </a>

                <!-- Study Groups -->
                <a href="javascript:void(0)" onclick="showToast('Study Groups feature coming soon!')" class="sw-nav-item">
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
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <polyline points="23 4 23 10 17 10"></polyline>
                        <polyline points="1 20 1 14 7 14"></polyline>
                        <path d="M3.51 9a9 9 0 0 1 14.85-3.36L23 10M1 14l4.64 4.36A9 9 0 0 0 20.49 15"></path>
                    </svg>
                    <span>Smart Rescheduler</span>
                </a>

                <!-- Deadline Radar -->
                <a href="${pageContext.request.contextPath}/deadlines" class="sw-nav-item">
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
                        <path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z"></path>
                    </svg>
                    <span>Settings</span>
                </a>
            </nav>
        </div>

        <!-- Sidebar Bottom Logout -->
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

    <!-- ======================================================== -->
    <!-- MAIN CONTENT                                             -->
    <!-- ======================================================== -->
    <main class="sw-main">

        <!-- Topbar -->
        <header class="sw-topbar">
            <!-- Search Box -->
            <div class="sw-search-box">
                <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <circle cx="11" cy="11" r="8"></circle>
                    <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                </svg>
                <input type="text" id="globalMaterialSearch" class="sw-search-input" placeholder="Search notes, PDFs, topics, subjects...">
            </div>

            <!-- User Notification & Profile -->
            <div class="sw-user-area">
                <div class="sw-bell-btn" title="Notifications" onclick="showToast('You have 2 new study material shares!')">
                    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
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
                    <svg class="sw-profile-chevron" viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                        <polyline points="6 9 12 15 18 9"></polyline>
                    </svg>
                </a>
            </div>
        </header>

        <!-- Main Content Wrapper -->
        <div class="sw-content-wrap">

            <!-- Hero Banner -->
            <section class="sw-hero-banner">
                <div class="sw-hero-left">
                    <h1>Study <span class="highlight">Materials</span></h1>
                    <p>Organize and access all your academic resources in one place.</p>
                </div>

                <div class="sw-hero-right">
                    <!-- Glass decorative cube shapes matching screenshot -->
                    <div class="sw-cube-decor-small"></div>
                    <div class="sw-cube-decor"></div>

                    <button class="sw-upload-btn" onclick="openUploadModal()">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                            <polyline points="16 16 12 12 8 16"></polyline>
                            <line x1="12" y1="12" x2="12" y2="21"></line>
                            <path d="M20.39 18.39A5 5 0 0 0 18 9h-1.26A8 8 0 1 0 3 16.3"></path>
                            <polyline points="16 16 12 12 8 16"></polyline>
                        </svg>
                        <span>Upload Material</span>
                    </button>
                </div>
            </section>

            <!-- Filter Tabs -->
            <div class="sw-filter-tabs">
                <button class="sw-tab-pill active" onclick="filterByTab(this, 'all')">All Materials</button>
                <button class="sw-tab-pill" onclick="filterByTab(this, 'subjects')">Subjects</button>
                <button class="sw-tab-pill" onclick="filterByTab(this, 'notes')">Notes</button>
                <button class="sw-tab-pill" onclick="filterByTab(this, 'pyqs')">PYQs</button>
                <button class="sw-tab-pill" onclick="filterByTab(this, 'references')">References</button>
                <button class="sw-tab-pill" onclick="filterByTab(this, 'favorites')">Favorites</button>
            </div>

            <!-- Stats Row: 4 Metric Cards + 1 Storage Card -->
            <section class="sw-stats-grid">
                <!-- 1. Subjects Card -->
                <div class="sw-stat-card" onclick="handleStatCardClick('subjects')" title="Click to view all subjects">
                    <div class="sw-stat-icon-box purple">
                        <svg viewBox="0 0 24 24" width="22" height="22" fill="none" stroke="currentColor" stroke-width="2.2">
                            <path d="M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z"></path>
                        </svg>
                    </div>
                    <div class="sw-stat-info">
                        <span class="sw-stat-value" id="statSubjectsCount">12</span>
                        <span class="sw-stat-label">Subjects</span>
                    </div>
                </div>

                <!-- 2. Total Files Card -->
                <div class="sw-stat-card" onclick="handleStatCardClick('files')" title="Click to view all files">
                    <div class="sw-stat-icon-box blue">
                        <svg viewBox="0 0 24 24" width="22" height="22" fill="none" stroke="currentColor" stroke-width="2.2">
                            <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                            <polyline points="14 2 14 8 20 8"></polyline>
                            <line x1="16" y1="13" x2="8" y2="13"></line>
                            <line x1="16" y1="17" x2="8" y2="17"></line>
                            <polyline points="10 9 9 9 8 9"></polyline>
                        </svg>
                    </div>
                    <div class="sw-stat-info">
                        <span class="sw-stat-value" id="statFilesCount">48</span>
                        <span class="sw-stat-label">Total Files</span>
                    </div>
                </div>

                <!-- 3. Storage Used Card -->
                <div class="sw-stat-card" onclick="handleStatCardClick('storage')" title="Click to view storage details">
                    <div class="sw-stat-icon-box cyan">
                        <svg viewBox="0 0 24 24" width="22" height="22" fill="none" stroke="currentColor" stroke-width="2.2">
                            <path d="M18 10h-1.26A8 8 0 1 0 9 20h9a5 5 0 0 0 0-10z"></path>
                        </svg>
                    </div>
                    <div class="sw-stat-info">
                        <span class="sw-stat-value" id="statStorageValue">3.2 GB</span>
                        <span class="sw-stat-label">Storage Used</span>
                    </div>
                </div>

                <!-- 4. Favorites Card -->
                <div class="sw-stat-card" onclick="handleStatCardClick('favorites')" title="Click to view favorites">
                    <div class="sw-stat-icon-box amber">
                        <svg viewBox="0 0 24 24" width="22" height="22" fill="currentColor" stroke="none">
                            <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon>
                        </svg>
                    </div>
                    <div class="sw-stat-info">
                        <span class="sw-stat-value" id="statFavCount">15</span>
                        <span class="sw-stat-label">Favorites</span>
                    </div>
                </div>

                <!-- 5. Storage Meter Widget -->
                <div class="sw-storage-card">
                    <div class="sw-storage-header">Storage</div>
                    <div class="sw-progress-track">
                        <div class="sw-progress-fill" id="storageBar"></div>
                    </div>
                    <div class="sw-storage-bottom">
                        <span>3.2 GB / 10 GB</span>
                        <span class="sw-storage-pct">32%</span>
                    </div>
                </div>
            </section>

            <!-- 2-Column Main Section: Left (Subjects & Recent) + Right (Widgets) -->
            <div class="sw-layout-grid">

                <!-- LEFT COLUMN -->
                <div class="sw-left-col">

                    <!-- ================================================ -->
                    <!-- SUBJECTS SECTION (8 Cards)                       -->
                    <!-- ================================================ -->
                    <div class="sw-section-card" id="subjectsSection">
                        <div class="sw-section-header">
                            <div class="sw-section-title">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                                    <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path>
                                    <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path>
                                </svg>
                                <span>Subjects</span>
                            </div>
                            <a href="javascript:void(0)" onclick="showToast('Viewing all 12 enrolled subjects')" class="sw-view-all">
                                <span>View All</span>
                                <span>&rarr;</span>
                            </a>
                        </div>

                        <div class="sw-subjects-grid">

                            <!-- 1. Data Structures (Blue) -->
                            <div class="sw-subject-item" onclick="openSubjectFolder('Data Structures')">
                                <div class="sw-folder-icon sw-folder-blue">
                                    <svg viewBox="0 0 24 24" fill="currentColor">
                                        <path d="M20 6h-8l-2-2H4c-1.1 0-1.99.9-1.99 2L2 18c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V8c0-1.1-.9-2-2-2zm0 12H4V8h16v10z"></path>
                                    </svg>
                                </div>
                                <div class="sw-subject-content">
                                    <div class="sw-subject-name">Data Structures</div>
                                    <div class="sw-subject-files">8 files</div>
                                </div>
                                <button class="sw-card-menu-btn" onclick="event.stopPropagation(); openFolderMenu(event, 'Data Structures')">
                                    <svg viewBox="0 0 24 24" width="16" height="16" fill="currentColor">
                                        <circle cx="12" cy="5" r="1.5"></circle>
                                        <circle cx="12" cy="12" r="1.5"></circle>
                                        <circle cx="12" cy="19" r="1.5"></circle>
                                    </svg>
                                </button>
                            </div>

                            <!-- 2. Database Management Systems (Purple) -->
                            <div class="sw-subject-item" onclick="openSubjectFolder('Database Management Systems')">
                                <div class="sw-folder-icon sw-folder-purple">
                                    <svg viewBox="0 0 24 24" fill="currentColor">
                                        <path d="M20 6h-8l-2-2H4c-1.1 0-1.99.9-1.99 2L2 18c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V8c0-1.1-.9-2-2-2zm0 12H4V8h16v10z"></path>
                                    </svg>
                                </div>
                                <div class="sw-subject-content">
                                    <div class="sw-subject-name">Database Management Systems</div>
                                    <div class="sw-subject-files">6 files</div>
                                </div>
                                <button class="sw-card-menu-btn" onclick="event.stopPropagation(); openFolderMenu(event, 'Database Management Systems')">
                                    <svg viewBox="0 0 24 24" width="16" height="16" fill="currentColor">
                                        <circle cx="12" cy="5" r="1.5"></circle>
                                        <circle cx="12" cy="12" r="1.5"></circle>
                                        <circle cx="12" cy="19" r="1.5"></circle>
                                    </svg>
                                </button>
                            </div>

                            <!-- 3. Operating Systems (Pink) -->
                            <div class="sw-subject-item" onclick="openSubjectFolder('Operating Systems')">
                                <div class="sw-folder-icon sw-folder-pink">
                                    <svg viewBox="0 0 24 24" fill="currentColor">
                                        <path d="M20 6h-8l-2-2H4c-1.1 0-1.99.9-1.99 2L2 18c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V8c0-1.1-.9-2-2-2zm0 12H4V8h16v10z"></path>
                                    </svg>
                                </div>
                                <div class="sw-subject-content">
                                    <div class="sw-subject-name">Operating Systems</div>
                                    <div class="sw-subject-files">5 files</div>
                                </div>
                                <button class="sw-card-menu-btn" onclick="event.stopPropagation(); openFolderMenu(event, 'Operating Systems')">
                                    <svg viewBox="0 0 24 24" width="16" height="16" fill="currentColor">
                                        <circle cx="12" cy="5" r="1.5"></circle>
                                        <circle cx="12" cy="12" r="1.5"></circle>
                                        <circle cx="12" cy="19" r="1.5"></circle>
                                    </svg>
                                </button>
                            </div>

                            <!-- 4. Computer Networks (Yellow) -->
                            <div class="sw-subject-item" onclick="openSubjectFolder('Computer Networks')">
                                <div class="sw-folder-icon sw-folder-yellow">
                                    <svg viewBox="0 0 24 24" fill="currentColor">
                                        <path d="M20 6h-8l-2-2H4c-1.1 0-1.99.9-1.99 2L2 18c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V8c0-1.1-.9-2-2-2zm0 12H4V8h16v10z"></path>
                                    </svg>
                                </div>
                                <div class="sw-subject-content">
                                    <div class="sw-subject-name">Computer Networks</div>
                                    <div class="sw-subject-files">4 files</div>
                                </div>
                                <button class="sw-card-menu-btn" onclick="event.stopPropagation(); openFolderMenu(event, 'Computer Networks')">
                                    <svg viewBox="0 0 24 24" width="16" height="16" fill="currentColor">
                                        <circle cx="12" cy="5" r="1.5"></circle>
                                        <circle cx="12" cy="12" r="1.5"></circle>
                                        <circle cx="12" cy="19" r="1.5"></circle>
                                    </svg>
                                </button>
                            </div>

                            <!-- 5. Object Oriented Programming (Green) -->
                            <div class="sw-subject-item" onclick="openSubjectFolder('Object Oriented Programming')">
                                <div class="sw-folder-icon sw-folder-green">
                                    <svg viewBox="0 0 24 24" fill="currentColor">
                                        <path d="M20 6h-8l-2-2H4c-1.1 0-1.99.9-1.99 2L2 18c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V8c0-1.1-.9-2-2-2zm0 12H4V8h16v10z"></path>
                                    </svg>
                                </div>
                                <div class="sw-subject-content">
                                    <div class="sw-subject-name">Object Oriented Programming</div>
                                    <div class="sw-subject-files">7 files</div>
                                </div>
                                <button class="sw-card-menu-btn" onclick="event.stopPropagation(); openFolderMenu(event, 'Object Oriented Programming')">
                                    <svg viewBox="0 0 24 24" width="16" height="16" fill="currentColor">
                                        <circle cx="12" cy="5" r="1.5"></circle>
                                        <circle cx="12" cy="12" r="1.5"></circle>
                                        <circle cx="12" cy="19" r="1.5"></circle>
                                    </svg>
                                </button>
                            </div>

                            <!-- 6. Internet of Things (Cyan) -->
                            <div class="sw-subject-item" onclick="openSubjectFolder('Internet of Things')">
                                <div class="sw-folder-icon sw-folder-cyan">
                                    <svg viewBox="0 0 24 24" fill="currentColor">
                                        <path d="M20 6h-8l-2-2H4c-1.1 0-1.99.9-1.99 2L2 18c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V8c0-1.1-.9-2-2-2zm0 12H4V8h16v10z"></path>
                                    </svg>
                                </div>
                                <div class="sw-subject-content">
                                    <div class="sw-subject-name">Internet of Things</div>
                                    <div class="sw-subject-files">5 files</div>
                                </div>
                                <button class="sw-card-menu-btn" onclick="event.stopPropagation(); openFolderMenu(event, 'Internet of Things')">
                                    <svg viewBox="0 0 24 24" width="16" height="16" fill="currentColor">
                                        <circle cx="12" cy="5" r="1.5"></circle>
                                        <circle cx="12" cy="12" r="1.5"></circle>
                                        <circle cx="12" cy="19" r="1.5"></circle>
                                    </svg>
                                </button>
                            </div>

                            <!-- 7. Discrete Mathematics (Indigo) -->
                            <div class="sw-subject-item" onclick="openSubjectFolder('Discrete Mathematics')">
                                <div class="sw-folder-icon sw-folder-indigo">
                                    <svg viewBox="0 0 24 24" fill="currentColor">
                                        <path d="M20 6h-8l-2-2H4c-1.1 0-1.99.9-1.99 2L2 18c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V8c0-1.1-.9-2-2-2zm0 12H4V8h16v10z"></path>
                                    </svg>
                                </div>
                                <div class="sw-subject-content">
                                    <div class="sw-subject-name">Discrete Mathematics</div>
                                    <div class="sw-subject-files">4 files</div>
                                </div>
                                <button class="sw-card-menu-btn" onclick="event.stopPropagation(); openFolderMenu(event, 'Discrete Mathematics')">
                                    <svg viewBox="0 0 24 24" width="16" height="16" fill="currentColor">
                                        <circle cx="12" cy="5" r="1.5"></circle>
                                        <circle cx="12" cy="12" r="1.5"></circle>
                                        <circle cx="12" cy="19" r="1.5"></circle>
                                    </svg>
                                </button>
                            </div>

                            <!-- 8. Fundamentals of Data Science (Coral) -->
                            <div class="sw-subject-item" onclick="openSubjectFolder('Fundamentals of Data Science')">
                                <div class="sw-folder-icon sw-folder-coral">
                                    <svg viewBox="0 0 24 24" fill="currentColor">
                                        <path d="M20 6h-8l-2-2H4c-1.1 0-1.99.9-1.99 2L2 18c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V8c0-1.1-.9-2-2-2zm0 12H4V8h16v10z"></path>
                                    </svg>
                                </div>
                                <div class="sw-subject-content">
                                    <div class="sw-subject-name">Fundamentals of Data Science</div>
                                    <div class="sw-subject-files">6 files</div>
                                </div>
                                <button class="sw-card-menu-btn" onclick="event.stopPropagation(); openFolderMenu(event, 'Fundamentals of Data Science')">
                                    <svg viewBox="0 0 24 24" width="16" height="16" fill="currentColor">
                                        <circle cx="12" cy="5" r="1.5"></circle>
                                        <circle cx="12" cy="12" r="1.5"></circle>
                                        <circle cx="12" cy="19" r="1.5"></circle>
                                    </svg>
                                </button>
                            </div>

                        </div>
                    </div>

                    <!-- ================================================ -->
                    <!-- RECENT MATERIALS SECTION (File list)             -->
                    <!-- ================================================ -->
                    <div class="sw-section-card" id="recentSection">
                        <div class="sw-section-header">
                            <div class="sw-section-title">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                                    <circle cx="12" cy="12" r="10"></circle>
                                    <polyline points="12 6 12 12 16 14"></polyline>
                                </svg>
                                <span>Recent Materials</span>
                            </div>
                            <a href="javascript:void(0)" onclick="showToast('Showing all 48 documents and notes')" class="sw-view-all">
                                <span>View All</span>
                                <span>&rarr;</span>
                            </a>
                        </div>

                        <div class="sw-files-list" id="filesContainer">

                            <!-- File 1: DBMS_Unit3_Notes.pdf -->
                            <div class="sw-file-row" data-name="DBMS_Unit3_Notes.pdf" data-subject="DBMS" data-category="notes" data-starred="false">
                                <div class="sw-file-icon pdf">
                                    <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                                        <polyline points="14 2 14 8 20 8"></polyline>
                                        <line x1="9" y1="15" x2="15" y2="15"></line>
                                    </svg>
                                </div>
                                <div class="sw-file-main">
                                    <div class="sw-file-name">DBMS_Unit3_Notes.pdf</div>
                                    <div class="sw-file-size">2.4 MB</div>
                                </div>
                                <span class="sw-badge dbms">DBMS</span>
                                <div class="sw-file-date">Uploaded on 10 Oct 2026</div>
                                <div class="sw-file-actions">
                                    <button class="sw-star-btn" title="Add to Favorites" onclick="toggleStar(this)">&#9734;</button>
                                    <button class="sw-row-menu-btn" title="Options" onclick="openFileMenu(event, 'DBMS_Unit3_Notes.pdf')">
                                        <svg viewBox="0 0 24 24" width="16" height="16" fill="currentColor">
                                            <circle cx="12" cy="5" r="1.5"></circle>
                                            <circle cx="12" cy="12" r="1.5"></circle>
                                            <circle cx="12" cy="19" r="1.5"></circle>
                                        </svg>
                                    </button>
                                </div>
                            </div>

                            <!-- File 2: Java_Important_Programs.docx -->
                            <div class="sw-file-row" data-name="Java_Important_Programs.docx" data-subject="OOP" data-category="notes" data-starred="false">
                                <div class="sw-file-icon docx">
                                    <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                                        <polyline points="14 2 14 8 20 8"></polyline>
                                        <line x1="16" y1="13" x2="8" y2="13"></line>
                                        <line x1="16" y1="17" x2="8" y2="17"></line>
                                    </svg>
                                </div>
                                <div class="sw-file-main">
                                    <div class="sw-file-name">Java_Important_Programs.docx</div>
                                    <div class="sw-file-size">1.1 MB</div>
                                </div>
                                <span class="sw-badge oop">OOP</span>
                                <div class="sw-file-date">Uploaded on 09 Oct 2026</div>
                                <div class="sw-file-actions">
                                    <button class="sw-star-btn" title="Add to Favorites" onclick="toggleStar(this)">&#9734;</button>
                                    <button class="sw-row-menu-btn" title="Options" onclick="openFileMenu(event, 'Java_Important_Programs.docx')">
                                        <svg viewBox="0 0 24 24" width="16" height="16" fill="currentColor">
                                            <circle cx="12" cy="5" r="1.5"></circle>
                                            <circle cx="12" cy="12" r="1.5"></circle>
                                            <circle cx="12" cy="19" r="1.5"></circle>
                                        </svg>
                                    </button>
                                </div>
                            </div>

                            <!-- File 3: IoT_Week1_Summary.pdf (STARRED in screenshot) -->
                            <div class="sw-file-row" data-name="IoT_Week1_Summary.pdf" data-subject="IoT" data-category="notes" data-starred="true">
                                <div class="sw-file-icon pdf">
                                    <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                                        <polyline points="14 2 14 8 20 8"></polyline>
                                        <line x1="9" y1="15" x2="15" y2="15"></line>
                                    </svg>
                                </div>
                                <div class="sw-file-main">
                                    <div class="sw-file-name">IoT_Week1_Summary.pdf</div>
                                    <div class="sw-file-size">3.0 MB</div>
                                </div>
                                <span class="sw-badge iot">IoT</span>
                                <div class="sw-file-date">Uploaded on 08 Oct 2026</div>
                                <div class="sw-file-actions">
                                    <button class="sw-star-btn starred" title="Remove from Favorites" onclick="toggleStar(this)">&#9733;</button>
                                    <button class="sw-row-menu-btn" title="Options" onclick="openFileMenu(event, 'IoT_Week1_Summary.pdf')">
                                        <svg viewBox="0 0 24 24" width="16" height="16" fill="currentColor">
                                            <circle cx="12" cy="5" r="1.5"></circle>
                                            <circle cx="12" cy="12" r="1.5"></circle>
                                            <circle cx="12" cy="19" r="1.5"></circle>
                                        </svg>
                                    </button>
                                </div>
                            </div>

                            <!-- File 4: DSA_Algorithms.png -->
                            <div class="sw-file-row" data-name="DSA_Algorithms.png" data-subject="Data Structures" data-category="references" data-starred="false">
                                <div class="sw-file-icon img">
                                    <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2">
                                        <rect x="3" y="3" width="18" height="18" rx="2" ry="2"></rect>
                                        <circle cx="8.5" cy="8.5" r="1.5"></circle>
                                        <polyline points="21 15 16 10 5 21"></polyline>
                                    </svg>
                                </div>
                                <div class="sw-file-main">
                                    <div class="sw-file-name">DSA_Algorithms.png</div>
                                    <div class="sw-file-size">800 KB</div>
                                </div>
                                <span class="sw-badge ds">Data Structures</span>
                                <div class="sw-file-date">Uploaded on 07 Oct 2026</div>
                                <div class="sw-file-actions">
                                    <button class="sw-star-btn" title="Add to Favorites" onclick="toggleStar(this)">&#9734;</button>
                                    <button class="sw-row-menu-btn" title="Options" onclick="openFileMenu(event, 'DSA_Algorithms.png')">
                                        <svg viewBox="0 0 24 24" width="16" height="16" fill="currentColor">
                                            <circle cx="12" cy="5" r="1.5"></circle>
                                            <circle cx="12" cy="12" r="1.5"></circle>
                                            <circle cx="12" cy="19" r="1.5"></circle>
                                        </svg>
                                    </button>
                                </div>
                            </div>

                            <!-- File 5: Previous_Year_Questions.pdf -->
                            <div class="sw-file-row" data-name="Previous_Year_Questions.pdf" data-subject="Mixed" data-category="pyqs" data-starred="false">
                                <div class="sw-file-icon pdf">
                                    <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                                        <polyline points="14 2 14 8 20 8"></polyline>
                                        <line x1="9" y1="15" x2="15" y2="15"></line>
                                    </svg>
                                </div>
                                <div class="sw-file-main">
                                    <div class="sw-file-name">Previous_Year_Questions.pdf</div>
                                    <div class="sw-file-size">4.2 MB</div>
                                </div>
                                <span class="sw-badge mixed">Mixed</span>
                                <div class="sw-file-date">Uploaded on 06 Oct 2026</div>
                                <div class="sw-file-actions">
                                    <button class="sw-star-btn" title="Add to Favorites" onclick="toggleStar(this)">&#9734;</button>
                                    <button class="sw-row-menu-btn" title="Options" onclick="openFileMenu(event, 'Previous_Year_Questions.pdf')">
                                        <svg viewBox="0 0 24 24" width="16" height="16" fill="currentColor">
                                            <circle cx="12" cy="5" r="1.5"></circle>
                                            <circle cx="12" cy="12" r="1.5"></circle>
                                            <circle cx="12" cy="19" r="1.5"></circle>
                                        </svg>
                                    </button>
                                </div>
                            </div>

                        </div>
                    </div>

                </div>

                <!-- RIGHT COLUMN WIDGETS -->
                <div class="sw-right-col">

                    <!-- Quick Actions Widget -->
                    <div class="sw-widget">
                        <div class="sw-widget-title">
                            <div class="sw-widget-title-left">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                                    <polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"></polygon>
                                </svg>
                                <span>Quick Actions</span>
                            </div>
                        </div>

                        <div class="sw-action-list">
                            <button class="sw-action-btn" onclick="openUploadModal()">
                                <div class="sw-action-left">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                                        <polyline points="14 2 14 8 20 8"></polyline>
                                        <line x1="12" y1="18" x2="12" y2="12"></line>
                                        <line x1="9" y1="15" x2="15" y2="15"></line>
                                    </svg>
                                    <span>Upload Notes</span>
                                </div>
                                <span class="sw-action-arrow">&rarr;</span>
                            </button>

                            <button class="sw-action-btn" onclick="openAddLinkModal()">
                                <div class="sw-action-left">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M10 13a5 5 0 0 0 7.54.54l3-3a5 5 0 0 0-7.07-7.07l-1.72 1.71"></path>
                                        <path d="M14 11a5 5 0 0 0-7.54-.54l-3 3a5 5 0 0 0 7.07 7.07l1.71-1.71"></path>
                                    </svg>
                                    <span>Add Link</span>
                                </div>
                                <span class="sw-action-arrow">&rarr;</span>
                            </button>

                            <button class="sw-action-btn" onclick="openCreateFolderModal()">
                                <div class="sw-action-left">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z"></path>
                                        <line x1="12" y1="11" x2="12" y2="17"></line>
                                        <line x1="9" y1="14" x2="15" y2="14"></line>
                                    </svg>
                                    <span>Create Folder</span>
                                </div>
                                <span class="sw-action-arrow">&rarr;</span>
                            </button>

                            <button class="sw-action-btn" onclick="triggerScanUpload()">
                                <div class="sw-action-left">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M3 7V5a2 2 0 0 1 2-2h2"></path>
                                        <path d="M17 3h2a2 2 0 0 1 2 2v2"></path>
                                        <path d="M21 17v2a2 2 0 0 1-2 2h-2"></path>
                                        <path d="M7 21H5a2 2 0 0 1-2-2v-2"></path>
                                        <line x1="7" y1="12" x2="17" y2="12"></line>
                                    </svg>
                                    <span>Scan &amp; Upload</span>
                                </div>
                                <span class="sw-action-arrow">&rarr;</span>
                            </button>
                        </div>
                    </div>

                    <!-- Popular Resources Widget -->
                    <div class="sw-widget">
                        <div class="sw-widget-title">
                            <div class="sw-widget-title-left">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                                    <polyline points="23 6 13.5 15.5 8.5 10.5 1 18"></polyline>
                                    <polyline points="17 6 23 6 23 12"></polyline>
                                </svg>
                                <span>Popular Resources</span>
                            </div>
                            <a href="javascript:void(0)" onclick="showToast('Browsing trending university resources')" class="sw-view-all">
                                <span>View All</span>
                                <span>&rarr;</span>
                            </a>
                        </div>

                        <div class="sw-res-list">
                            <div class="sw-res-item" onclick="openResource('Important Questions (All Subjects)')">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                                    <polyline points="14 2 14 8 20 8"></polyline>
                                </svg>
                                <span>Important Questions (All Subjects)</span>
                            </div>

                            <div class="sw-res-item" onclick="openResource('Formula Sheet (DSA + Maths)')">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                                    <polyline points="14 2 14 8 20 8"></polyline>
                                </svg>
                                <span>Formula Sheet (DSA + Maths)</span>
                            </div>

                            <div class="sw-res-item" onclick="openResource('Lab Manual (DBMS)')">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                                    <polyline points="14 2 14 8 20 8"></polyline>
                                </svg>
                                <span>Lab Manual (DBMS)</span>
                            </div>

                            <div class="sw-res-item" onclick="openResource('CAT 1 Preparation Notes')">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                                    <polyline points="14 2 14 8 20 8"></polyline>
                                </svg>
                                <span>CAT 1 Preparation Notes</span>
                            </div>

                            <div class="sw-res-item" onclick="openResource('NPTEL Summaries')">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                                    <polyline points="14 2 14 8 20 8"></polyline>
                                </svg>
                                <span>NPTEL Summaries</span>
                            </div>
                        </div>
                    </div>

                    <!-- Tags Widget -->
                    <div class="sw-widget">
                        <div class="sw-widget-title">
                            <div class="sw-widget-title-left">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                                    <path d="M20.59 13.41l-7.17 7.17a2 2 0 0 1-2.83 0L2 12V2h10l8.59 8.59a2 2 0 0 1 0 2.82z"></path>
                                    <line x1="7" y1="7" x2="7.01" y2="7"></line>
                                </svg>
                                <span>Tags</span>
                            </div>
                            <a href="javascript:void(0)" onclick="openManageTags()" style="color: #a78bfa; font-size: 0.82rem; font-weight: 600;">
                                Manage
                            </a>
                        </div>

                        <div class="sw-tags-wrap">
                            <span class="sw-tag-chip sw-tag-notes" onclick="filterByTag('Notes')">Notes</span>
                            <span class="sw-tag-chip sw-tag-pyq" onclick="filterByTag('PYQ')">PYQ</span>
                            <span class="sw-tag-chip sw-tag-important" onclick="filterByTag('Important')">Important</span>
                            <span class="sw-tag-chip sw-tag-unit" onclick="filterByTag('Unit 1')">Unit 1</span>
                            <span class="sw-tag-chip sw-tag-lab" onclick="filterByTag('Lab')">Lab</span>
                            <span class="sw-tag-chip sw-tag-ref" onclick="filterByTag('Reference')">Reference</span>
                            <span class="sw-tag-chip sw-tag-summary" onclick="filterByTag('Summary')">Summary</span>
                        </div>
                    </div>

                </div>

            </div>

        </div>

    </main>

</div>

<!-- ============================================================ -->
<!-- UPLOAD MATERIAL MODAL                                        -->
<!-- ============================================================ -->
<div class="sw-modal-backdrop" id="uploadModalBackdrop">
    <div class="sw-modal-card">
        <div class="sw-modal-header">
            <h2 class="sw-modal-title">Upload Study Material</h2>
            <button class="sw-modal-close" onclick="closeUploadModal()">&times;</button>
        </div>

        <form id="uploadMaterialForm" onsubmit="handleUploadSubmit(event)">
            <!-- Drag & Drop Area -->
            <div class="sw-drop-zone" onclick="document.getElementById('hiddenFileInput').click()">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path>
                    <polyline points="17 8 12 3 7 8"></polyline>
                    <line x1="12" y1="3" x2="12" y2="15"></line>
                </svg>
                <div class="sw-drop-text" id="dropZoneText">Click to browse or drop file here</div>
                <div class="sw-drop-hint">PDF, DOCX, PPTX, PNG, JPG (Max 50MB)</div>
                <input type="file" id="hiddenFileInput" style="display: none;" onchange="handleFileSelected(this)">
            </div>

            <!-- Material Title -->
            <div class="sw-form-group">
                <label class="sw-form-label">Material Title</label>
                <input type="text" id="uploadTitle" class="sw-form-input" placeholder="e.g. Unit 3 Trees & Graphs Summary.pdf" required>
            </div>

            <!-- Subject & Category -->
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 14px;">
                <div class="sw-form-group">
                    <label class="sw-form-label">Subject</label>
                    <select id="uploadSubject" class="sw-form-select">
                        <option value="DBMS">Database Management Systems</option>
                        <option value="Data Structures">Data Structures</option>
                        <option value="Operating Systems">Operating Systems</option>
                        <option value="Computer Networks">Computer Networks</option>
                        <option value="OOP">Object Oriented Programming</option>
                        <option value="IoT">Internet of Things</option>
                        <option value="Discrete Mathematics">Discrete Mathematics</option>
                        <option value="Data Science">Fundamentals of Data Science</option>
                    </select>
                </div>

                <div class="sw-form-group">
                    <label class="sw-form-label">Category</label>
                    <select id="uploadCategory" class="sw-form-select">
                        <option value="notes">Lecture Notes</option>
                        <option value="pyqs">Previous Year Questions</option>
                        <option value="references">Textbook / Reference</option>
                        <option value="lab">Lab Manual</option>
                        <option value="assignment">Assignment Solution</option>
                    </select>
                </div>
            </div>

            <!-- Tags -->
            <div class="sw-form-group">
                <label class="sw-form-label">Tags (comma separated)</label>
                <input type="text" id="uploadTags" class="sw-form-input" placeholder="e.g. Unit 1, Important, Exam Prep">
            </div>

            <!-- Actions -->
            <div class="sw-modal-actions">
                <button type="button" class="sw-btn-cancel" onclick="closeUploadModal()">Cancel</button>
                <button type="submit" class="sw-btn-submit">Upload to Vault</button>
            </div>
        </form>
    </div>
</div>

<!-- ============================================================ -->
<!-- CREATE FOLDER MODAL                                          -->
<!-- ============================================================ -->
<div class="sw-modal-backdrop" id="createFolderModalBackdrop">
    <div class="sw-modal-card">
        <div class="sw-modal-header">
            <h2 class="sw-modal-title">Create New Folder</h2>
            <button class="sw-modal-close" onclick="closeFolderModal()">&times;</button>
        </div>
        <form onsubmit="handleCreateFolderSubmit(event)">
            <div class="sw-form-group">
                <label class="sw-form-label">Folder Name</label>
                <input type="text" id="newFolderName" class="sw-form-input" placeholder="e.g. Artificial Intelligence" required>
            </div>
            <div class="sw-form-group">
                <label class="sw-form-label">Folder Theme Color</label>
                <select id="newFolderColor" class="sw-form-select">
                    <option value="blue">Electric Blue</option>
                    <option value="purple">Cosmic Purple</option>
                    <option value="pink">Neon Pink</option>
                    <option value="green">Emerald Green</option>
                    <option value="yellow">Amber Yellow</option>
                    <option value="cyan">Aqua Cyan</option>
                </select>
            </div>
            <div class="sw-modal-actions">
                <button type="button" class="sw-btn-cancel" onclick="closeFolderModal()">Cancel</button>
                <button type="submit" class="sw-btn-submit">Create Folder</button>
            </div>
        </form>
    </div>
</div>

<!-- ============================================================ -->
<!-- ADD LINK MODAL                                               -->
<!-- ============================================================ -->
<div class="sw-modal-backdrop" id="addLinkModalBackdrop">
    <div class="sw-modal-card">
        <div class="sw-modal-header">
            <h2 class="sw-modal-title">Add Academic Reference Link</h2>
            <button class="sw-modal-close" onclick="closeLinkModal()">&times;</button>
        </div>
        <form onsubmit="handleAddLinkSubmit(event)">
            <div class="sw-form-group">
                <label class="sw-form-label">Resource Title</label>
                <input type="text" id="linkTitle" class="sw-form-input" placeholder="e.g. NPTEL DBMS Lectures - IIT Kharagpur" required>
            </div>
            <div class="sw-form-group">
                <label class="sw-form-label">URL / Web Address</label>
                <input type="url" id="linkUrl" class="sw-form-input" placeholder="https://nptel.ac.in/courses/..." required>
            </div>
            <div class="sw-modal-actions">
                <button type="button" class="sw-btn-cancel" onclick="closeLinkModal()">Cancel</button>
                <button type="submit" class="sw-btn-submit">Save Link</button>
            </div>
        </form>
    </div>
</div>

<!-- ============================================================ -->
<!-- CONTEXT MENU FOR FILES / FOLDERS                             -->
<!-- ============================================================ -->
<div class="sw-context-menu" id="contextDropdown">
    <div class="sw-context-item" onclick="handleMenuAction('preview')">
        <svg viewBox="0 0 24 24" width="15" height="15" fill="none" stroke="currentColor" stroke-width="2"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path><circle cx="12" cy="12" r="3"></circle></svg>
        <span>Preview</span>
    </div>
    <div class="sw-context-item" onclick="handleMenuAction('download')">
        <svg viewBox="0 0 24 24" width="15" height="15" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path><polyline points="7 10 12 15 17 10"></polyline><line x1="12" y1="15" x2="12" y2="3"></line></svg>
        <span>Download</span>
    </div>
    <div class="sw-context-item" onclick="handleMenuAction('share')">
        <svg viewBox="0 0 24 24" width="15" height="15" fill="none" stroke="currentColor" stroke-width="2"><circle cx="18" cy="5" r="3"></circle><circle cx="6" cy="12" r="3"></circle><circle cx="18" cy="19" r="3"></circle><line x1="8.59" y1="13.51" x2="15.42" y2="17.49"></line><line x1="15.41" y1="6.51" x2="8.59" y2="10.49"></line></svg>
        <span>Share Link</span>
    </div>
    <div class="sw-context-item danger" onclick="handleMenuAction('delete')">
        <svg viewBox="0 0 24 24" width="15" height="15" fill="none" stroke="currentColor" stroke-width="2"><polyline points="3 6 5 6 21 6"></polyline><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path></svg>
        <span>Remove</span>
    </div>
</div>

<!-- ============================================================ -->
<!-- FLOATING TOAST NOTIFICATION                                  -->
<!-- ============================================================ -->
<div class="sw-toast" id="swToast">
    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="#a78bfa" stroke-width="2.2">
        <polyline points="20 6 9 17 4 12"></polyline>
    </svg>
    <span id="swToastText">Action completed successfully</span>
</div>

<!-- ============================================================ -->
<!-- INTERACTIVE SCRIPTS                                          -->
<!-- ============================================================ -->
<script>
    var currentTargetFile = '';
    var favoritesCount = 15;
    var totalFilesCount = 48;
    var storageUsed = 3.2;
    var storageTotal = 10;

    // Toast helper
    function showToast(msg) {
        var toast = document.getElementById('swToast');
        var toastText = document.getElementById('swToastText');
        toastText.textContent = msg;
        toast.classList.add('show');
        setTimeout(function() {
            toast.classList.remove('show');
        }, 3200);
    }

    // Stat Card Click Handler
    function handleStatCardClick(type) {
        if (type === 'subjects') {
            var section = document.getElementById('subjectsSection');
            section.style.display = 'block';
            section.scrollIntoView({ behavior: 'smooth', block: 'start' });
            // Flash highlight animation
            section.style.boxShadow = '0 0 30px rgba(99, 102, 241, 0.35)';
            setTimeout(function() {
                section.style.boxShadow = '';
            }, 1500);
            showToast('Viewing all ' + document.getElementById('statSubjectsCount').textContent + ' enrolled subjects');
        } else if (type === 'files') {
            var recentSec = document.getElementById('recentSection');
            recentSec.scrollIntoView({ behavior: 'smooth', block: 'start' });
            recentSec.style.boxShadow = '0 0 30px rgba(56, 189, 248, 0.3)';
            setTimeout(function() {
                recentSec.style.boxShadow = '';
            }, 1500);
            // Show all files
            document.querySelectorAll('.sw-file-row').forEach(function(r) { r.style.display = 'flex'; });
            showToast('Showing all ' + totalFilesCount + ' uploaded files and documents');
        } else if (type === 'storage') {
            // Show detailed storage breakdown
            var pct = Math.round((storageUsed / storageTotal) * 100);
            var remaining = (storageTotal - storageUsed).toFixed(1);
            showToast('Storage: ' + storageUsed + ' GB / ' + storageTotal + ' GB used (' + pct + '%) — ' + remaining + ' GB remaining');
            // Animate storage bar
            var bar = document.getElementById('storageBar');
            bar.style.width = '0%';
            setTimeout(function() {
                bar.style.width = pct + '%';
            }, 100);
        } else if (type === 'favorites') {
            // Activate favorites tab
            var favBtn = document.querySelector('.sw-tab-pill:last-child');
            filterByTab(favBtn, 'favorites');
        }
    }

    // Live Search Filter
    document.getElementById('globalMaterialSearch').addEventListener('input', function(e) {
        var term = e.target.value.toLowerCase().trim();

        // Filter files
        var rows = document.querySelectorAll('.sw-file-row');
        rows.forEach(function(row) {
            var name = row.getAttribute('data-name').toLowerCase();
            var sub = (row.getAttribute('data-subject') || '').toLowerCase();
            var matches = name.includes(term) || sub.includes(term);
            row.style.display = matches ? 'flex' : 'none';
        });

        // Filter subject folders
        var subjects = document.querySelectorAll('.sw-subject-item');
        subjects.forEach(function(sub) {
            var text = sub.textContent.toLowerCase();
            sub.style.display = text.includes(term) ? 'flex' : 'none';
        });
    });

    // Filter by Tab
    function filterByTab(btn, category) {
        document.querySelectorAll('.sw-tab-pill').forEach(function(el) {
            el.classList.remove('active');
        });
        btn.classList.add('active');

        var rows = document.querySelectorAll('.sw-file-row');
        var subjectsSec = document.getElementById('subjectsSection');

        if (category === 'all') {
            subjectsSec.style.display = 'block';
            rows.forEach(function(r) { r.style.display = 'flex'; });
            showToast('Showing all academic materials');
        } else if (category === 'subjects') {
            subjectsSec.style.display = 'block';
            rows.forEach(function(r) { r.style.display = 'none'; });
            showToast('Displaying subject course folders');
        } else if (category === 'favorites') {
            subjectsSec.style.display = 'none';
            rows.forEach(function(r) {
                var isStarred = r.getAttribute('data-starred') === 'true';
                r.style.display = isStarred ? 'flex' : 'none';
            });
            showToast('Displaying bookmarked favorite materials');
        } else {
            subjectsSec.style.display = 'none';
            rows.forEach(function(r) {
                var cat = r.getAttribute('data-category');
                r.style.display = (cat === category) ? 'flex' : 'none';
            });
            showToast('Filtered by ' + btn.textContent);
        }
    }

    // Filter by Tag
    function filterByTag(tag) {
        document.getElementById('globalMaterialSearch').value = tag;
        var evt = new Event('input');
        document.getElementById('globalMaterialSearch').dispatchEvent(evt);
        showToast('Filtered materials tagged with "' + tag + '"');
    }

    // Toggle Star
    function toggleStar(btn) {
        var row = btn.closest('.sw-file-row');
        var fileName = row.getAttribute('data-name');
        var isStarred = btn.classList.contains('starred');

        if (isStarred) {
            btn.classList.remove('starred');
            btn.innerHTML = '&#9734;';
            btn.title = 'Add to Favorites';
            row.setAttribute('data-starred', 'false');
            favoritesCount--;
            showToast('Removed "' + fileName + '" from favorites');
        } else {
            btn.classList.add('starred');
            btn.innerHTML = '&#9733;';
            btn.title = 'Remove from Favorites';
            row.setAttribute('data-starred', 'true');
            favoritesCount++;
            showToast('Added "' + fileName + '" to favorites!');
        }
        document.getElementById('statFavCount').textContent = favoritesCount;
    }

    // Upload Material Modal
    function openUploadModal() {
        document.getElementById('uploadModalBackdrop').style.display = 'flex';
        document.getElementById('uploadTitle').focus();
    }

    function closeUploadModal() {
        document.getElementById('uploadModalBackdrop').style.display = 'none';
        document.getElementById('uploadMaterialForm').reset();
        document.getElementById('dropZoneText').textContent = 'Click to browse or drop file here';
    }

    function handleFileSelected(input) {
        if (input.files && input.files[0]) {
            var f = input.files[0];
            document.getElementById('dropZoneText').textContent = f.name + ' (' + (f.size / (1024*1024)).toFixed(1) + ' MB)';
            if (!document.getElementById('uploadTitle').value) {
                document.getElementById('uploadTitle').value = f.name;
            }
        }
    }

    function handleUploadSubmit(e) {
        e.preventDefault();
        var title = document.getElementById('uploadTitle').value;
        var subject = document.getElementById('uploadSubject').value;
        var category = document.getElementById('uploadCategory').value;

        // Create new row element at top of list
        var container = document.getElementById('filesContainer');
        var newRow = document.createElement('div');
        newRow.className = 'sw-file-row';
        newRow.setAttribute('data-name', title);
        newRow.setAttribute('data-subject', subject);
        newRow.setAttribute('data-category', category);
        newRow.setAttribute('data-starred', 'false');

        var isPdf = title.toLowerCase().endsWith('.pdf');
        var iconHtml = isPdf ? 
            '<div class="sw-file-icon pdf"><svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="9" y1="15" x2="15" y2="15"></line></svg></div>' :
            '<div class="sw-file-icon docx"><svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line></svg></div>';

        newRow.innerHTML = iconHtml +
            '<div class="sw-file-main">' +
                '<div class="sw-file-name">' + escapeHtml(title) + '</div>' +
                '<div class="sw-file-size">1.8 MB</div>' +
            '</div>' +
            '<span class="sw-badge dbms">' + escapeHtml(subject) + '</span>' +
            '<div class="sw-file-date">Uploaded just now</div>' +
            '<div class="sw-file-actions">' +
                '<button class="sw-star-btn" title="Add to Favorites" onclick="toggleStar(this)">&#9734;</button>' +
                '<button class="sw-row-menu-btn" title="Options" onclick="openFileMenu(event, \'' + escapeHtml(title) + '\')">' +
                    '<svg viewBox="0 0 24 24" width="16" height="16" fill="currentColor"><circle cx="12" cy="5" r="1.5"></circle><circle cx="12" cy="12" r="1.5"></circle><circle cx="12" cy="19" r="1.5"></circle></svg>' +
                '</button>' +
            '</div>';

        container.insertBefore(newRow, container.firstChild);
        totalFilesCount++;
        document.getElementById('statFilesCount').textContent = totalFilesCount;

        // Update storage dynamically
        storageUsed = parseFloat((storageUsed + 0.18).toFixed(1));
        var pct = Math.round((storageUsed / storageTotal) * 100);
        document.getElementById('statStorageValue').textContent = storageUsed + ' GB';
        document.getElementById('storageBar').style.width = pct + '%';
        document.querySelector('.sw-storage-bottom span:first-child').textContent = storageUsed + ' GB / ' + storageTotal + ' GB';
        document.querySelector('.sw-storage-pct').textContent = pct + '%';

        closeUploadModal();
        showToast('Successfully uploaded "' + title + '" to study vault!');
    }

    // Create Folder Modal
    function openCreateFolderModal() {
        document.getElementById('createFolderModalBackdrop').style.display = 'flex';
        document.getElementById('newFolderName').focus();
    }
    function closeFolderModal() {
        document.getElementById('createFolderModalBackdrop').style.display = 'none';
    }
    function handleCreateFolderSubmit(e) {
        e.preventDefault();
        var name = document.getElementById('newFolderName').value;
        closeFolderModal();
        showToast('Created new folder "' + name + '" successfully!');
    }

    // Add Link Modal
    function openAddLinkModal() {
        document.getElementById('addLinkModalBackdrop').style.display = 'flex';
        document.getElementById('linkTitle').focus();
    }
    function closeLinkModal() {
        document.getElementById('addLinkModalBackdrop').style.display = 'none';
    }
    function handleAddLinkSubmit(e) {
        e.preventDefault();
        var title = document.getElementById('linkTitle').value;
        closeLinkModal();
        showToast('Saved resource link "' + title + '"');
    }

    // Scan & Upload Trigger
    function triggerScanUpload() {
        showToast('Document camera / scanner initialized. Position document in frame.');
        setTimeout(function() {
            openUploadModal();
        }, 800);
    }

    // Subject Folder Click
    function openSubjectFolder(name) {
        showToast('Opened folder: ' + name);
        document.getElementById('globalMaterialSearch').value = name;
        var evt = new Event('input');
        document.getElementById('globalMaterialSearch').dispatchEvent(evt);
    }

    // Resource item click
    function openResource(title) {
        showToast('Opening ' + title + ' in viewer...');
    }

    function openManageTags() {
        showToast('Tag Manager opened: 7 active taxonomy categories');
    }

    // Context Menu
    function openFileMenu(e, fileName) {
        e.stopPropagation();
        currentTargetFile = fileName;
        var menu = document.getElementById('contextDropdown');
        menu.style.top = (e.pageY + 10) + 'px';
        menu.style.left = Math.min(e.pageX - 100, window.innerWidth - 180) + 'px';
        menu.classList.add('open');
    }

    function openFolderMenu(e, folderName) {
        e.stopPropagation();
        currentTargetFile = folderName;
        var menu = document.getElementById('contextDropdown');
        menu.style.top = (e.pageY + 10) + 'px';
        menu.style.left = Math.min(e.pageX - 100, window.innerWidth - 180) + 'px';
        menu.classList.add('open');
    }

    function handleMenuAction(action) {
        document.getElementById('contextDropdown').classList.remove('open');
        if (action === 'preview') {
            showToast('Generating document preview for ' + currentTargetFile);
        } else if (action === 'download') {
            showToast('Downloading ' + currentTargetFile + '...');
        } else if (action === 'share') {
            showToast('Shareable link copied to clipboard!');
        } else if (action === 'delete') {
            showToast('Moved ' + currentTargetFile + ' to trash');
        }
    }

    // Close menu when clicking outside
    document.addEventListener('click', function() {
        document.getElementById('contextDropdown').classList.remove('open');
    });

    function escapeHtml(str) {
        return str.replace(/[&<>"']/g, function(m) {
            return {
                '&': '&amp;',
                '<': '&lt;',
                '>': '&gt;',
                '"': '&quot;',
                "'": '&#039;'
            }[m];
        });
    }
</script>

</body>
</html>
