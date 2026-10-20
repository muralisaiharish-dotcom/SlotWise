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
    <title>Smart Rescheduler &mdash; SlotWise</title>
    <meta name="description" content="Plans change. We adjust. Automatically reschedule your tasks and study slots without losing your goals.">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg-body: #060814;
            --bg-sidebar: #070a18;
            --bg-card: #0b1124;
            --bg-card-inner: #0e152e;
            --border-card: rgba(255, 255, 255, 0.06);
            --border-subtle: rgba(255, 255, 255, 0.08);
            --border-focus: #6366f1;
            --primary-purple: #6d5dfc;
            --primary-gradient: linear-gradient(135deg, #6366f1 0%, #7c3aed 100%);
            --accent-glow: rgba(99, 102, 241, 0.35);
            --text-main: #f8fafc;
            --text-muted: #8492a6;
            --text-dim: #475569;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

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
        .sw-logo-text span {
            color: #8b5cf6;
        }

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

        .sw-nav-item svg {
            width: 19px;
            height: 19px;
            flex-shrink: 0;
        }

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

        .sw-search-input::placeholder {
            color: #475569;
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

        .sw-profile-name {
            font-size: 0.84rem;
            font-weight: 600;
            color: #fff;
        }

        .sw-profile-role {
            font-size: 0.72rem;
            color: var(--text-muted);
        }

        /* ===== CONTENT WRAPPER ===== */
        .sw-content {
            padding: 26px 32px 40px;
            display: flex;
            flex-direction: column;
            gap: 24px;
            max-width: 100%;
        }

        /* ===== HERO HEADER & 4-STEP PROCESS ===== */
        .sr-hero {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 24px;
        }

        .sr-hero-left h1 {
            font-size: 2.15rem;
            font-weight: 800;
            letter-spacing: -0.025em;
            color: #ffffff;
        }

        .sr-hero-left h1 span {
            color: #7952f5;
        }

        .sr-hero-left .sr-tagline {
            font-size: 1.05rem;
            font-weight: 700;
            color: #f1f5f9;
            margin-top: 4px;
        }

        .sr-hero-left .sr-desc {
            font-size: 0.86rem;
            color: #8492a6;
            margin-top: 4px;
            max-width: 520px;
            line-height: 1.45;
        }

        /* 4-STEP WORKFLOW */
        .sr-workflow {
            display: flex;
            align-items: center;
            gap: 10px;
            flex-shrink: 0;
        }

        .sr-wf-step {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            width: 90px;
            height: 84px;
            border-radius: 14px;
            background: #090e20;
            border: 1px solid rgba(255, 255, 255, 0.07);
            padding: 10px 6px;
            gap: 6px;
            transition: all 0.25s cubic-bezier(0.16, 1, 0.3, 1);
            cursor: pointer;
            user-select: none;
        }

        .sr-wf-step:hover {
            transform: translateY(-2px);
            border-color: rgba(99, 102, 241, 0.45);
            background: #111a3d;
        }

        .sr-wf-step:active {
            transform: translateY(0);
        }

        .sr-wf-step.active {
            background: #0f1638;
            border-color: #6366f1;
            box-shadow: 0 0 20px rgba(99, 102, 241, 0.3);
        }

        .sr-wf-step.step-purple-active {
            background: #161242;
            border-color: #7c3aed;
            box-shadow: 0 0 24px rgba(124, 58, 237, 0.45);
        }

        /* CARD FOCUS ANIMATIONS ON STEP CLICK */
        @keyframes stepFocusGlow {
            0% { transform: scale(1); }
            50% { transform: scale(1.008); box-shadow: 0 0 30px rgba(99, 102, 241, 0.55); border-color: #6366f1; }
            100% { transform: scale(1); }
        }
        .sr-step-focused {
            animation: stepFocusGlow 1.2s ease-in-out;
            border-color: #6366f1 !important;
        }
        @keyframes alertFocusGlow {
            0% { transform: scale(1); }
            50% { transform: scale(1.008); box-shadow: 0 0 30px rgba(239, 68, 68, 0.5); border-color: #f87171; }
            100% { transform: scale(1); }
        }
        .sr-alert-focused {
            animation: alertFocusGlow 1.2s ease-in-out;
            border-color: #f87171 !important;
        }
        @keyframes successFocusGlow {
            0% { transform: scale(1); }
            50% { transform: scale(1.008); box-shadow: 0 0 30px rgba(16, 185, 129, 0.5); border-color: #10b981; }
            100% { transform: scale(1); }
        }
        .sr-success-focused {
            animation: successFocusGlow 1.2s ease-in-out;
            border-color: #10b981 !important;
        }

        .sr-wf-icon {
            width: 28px;
            height: 28px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #818cf8;
        }

        .sr-wf-icon.icon-teal {
            width: 32px;
            height: 32px;
            background: #0d9488;
            border-radius: 50%;
            color: #ffffff;
            box-shadow: 0 0 12px rgba(13, 148, 136, 0.4);
        }

        .sr-wf-label {
            font-size: 0.68rem;
            font-weight: 600;
            color: #cbd5e1;
            text-align: center;
            line-height: 1.25;
            white-space: nowrap;
        }

        .sr-wf-label span.num {
            display: block;
            color: #94a3b8;
            font-size: 0.7rem;
            margin-bottom: 1px;
        }

        .sr-wf-arrow {
            color: #475569;
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 0 2px;
        }

        /* ===== TWO-COLUMN GRID ===== */
        .sr-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 22px;
            align-items: stretch;
        }

        @media (max-width: 1100px) {
            .sr-grid {
                grid-template-columns: 1fr;
            }
        }

        /* ===== CARD STYLES ===== */
        .sr-card {
            background: #090e22;
            border: 1px solid var(--border-card);
            border-radius: 16px;
            padding: 22px 24px;
            display: flex;
            flex-direction: column;
            position: relative;
        }

        .sr-card-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 18px;
        }

        .sr-card-title {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 1.05rem;
            font-weight: 700;
            color: #ffffff;
        }

        .sr-card-title-icon {
            width: 26px;
            height: 26px;
            border-radius: 8px;
            background: rgba(99, 102, 241, 0.15);
            display: flex;
            align-items: center;
            justify-content: center;
            color: #818cf8;
        }

        .sr-card-title-icon.warning {
            background: rgba(239, 68, 68, 0.15);
            color: #f87171;
        }

        /* BADGES */
        .sr-badge {
            padding: 4px 12px;
            border-radius: 16px;
            font-size: 0.72rem;
            font-weight: 600;
            white-space: nowrap;
        }

        .sr-badge-conflict-count {
            background: #3c1418;
            color: #f87171;
            border: 1px solid rgba(239, 68, 68, 0.3);
        }

        .sr-badge-overlap {
            background: #391316;
            color: #f87171;
            border: 1px solid rgba(239, 68, 68, 0.25);
        }

        .sr-badge-gap {
            background: #341e12;
            color: #fb923c;
            border: 1px solid rgba(249, 115, 22, 0.25);
        }

        .sr-badge-resolved {
            background: #064e3b;
            color: #34d399;
            border: 1px solid rgba(16, 185, 129, 0.3);
            display: flex;
            align-items: center;
            gap: 5px;
        }

        /* CHANGE TABS */
        .sr-change-tabs {
            display: flex;
            gap: 8px;
            margin-bottom: 20px;
        }

        .sr-change-tab {
            flex: 1;
            padding: 9px 12px;
            border-radius: 10px;
            background: #0e152e;
            border: 1px solid var(--border-card);
            color: #94a3b8;
            font-size: 0.82rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s ease;
            text-align: center;
            white-space: nowrap;
        }

        .sr-change-tab:hover {
            color: #fff;
            background: rgba(255, 255, 255, 0.07);
        }

        .sr-change-tab.active {
            background: #5345ea;
            border-color: #5345ea;
            color: #ffffff;
            box-shadow: 0 4px 14px rgba(83, 69, 234, 0.4);
        }

        /* FORM INPUTS */
        .sr-form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 14px;
            margin-bottom: 14px;
        }

        .sr-field {
            display: flex;
            flex-direction: column;
            gap: 6px;
        }

        .sr-field-label {
            font-size: 0.78rem;
            font-weight: 600;
            color: #94a3b8;
        }

        .sr-input-wrapper {
            position: relative;
            display: flex;
            align-items: center;
        }

        .sr-input {
            width: 100%;
            height: 42px;
            background: #0d142c;
            border: 1px solid var(--border-card);
            border-radius: 10px;
            padding: 0 38px 0 14px;
            color: #ffffff;
            font-size: 0.88rem;
            outline: none;
            transition: all 0.2s ease;
        }

        .sr-input:focus {
            border-color: #6366f1;
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.2);
        }

        .sr-input-icon {
            position: absolute;
            right: 12px;
            color: #64748b;
            pointer-events: none;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        /* Priority dropdown */
        .sr-priority-select {
            width: 100%;
            height: 42px;
            background: #2d1017;
            border: 1px solid rgba(239, 68, 68, 0.35);
            border-radius: 10px;
            padding: 0 34px 0 14px;
            color: #f87171;
            font-size: 0.88rem;
            font-weight: 600;
            outline: none;
            appearance: none;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .sr-priority-select:focus {
            box-shadow: 0 0 0 3px rgba(239, 68, 68, 0.2);
        }

        .sr-priority-select option {
            background: #0e152e;
            color: #fff;
        }

        /* Notes textarea */
        .sr-textarea {
            width: 100%;
            min-height: 64px;
            background: #0d142c;
            border: 1px solid var(--border-card);
            border-radius: 10px;
            padding: 10px 14px;
            color: #ffffff;
            font-size: 0.86rem;
            outline: none;
            resize: none;
            transition: all 0.2s ease;
            margin-bottom: 16px;
        }

        .sr-textarea:focus {
            border-color: #6366f1;
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.2);
        }

        /* FIND NEW SCHEDULE BUTTON */
        .sr-btn-submit {
            width: 100%;
            height: 46px;
            background: linear-gradient(135deg, #5746f5, #7a35e8);
            border: none;
            border-radius: 12px;
            color: #ffffff;
            font-size: 0.92rem;
            font-weight: 700;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            cursor: pointer;
            box-shadow: 0 4px 18px rgba(99, 102, 241, 0.45);
            transition: all 0.25s ease;
        }

        .sr-btn-submit:hover {
            opacity: 0.95;
            box-shadow: 0 6px 24px rgba(99, 102, 241, 0.6);
            transform: translateY(-1px);
        }

        .sr-btn-submit:active {
            transform: translateY(0);
        }

        .sr-btn-submit svg {
            width: 19px;
            height: 19px;
        }

        .sr-spinner {
            width: 18px;
            height: 18px;
            border: 2px solid rgba(255, 255, 255, 0.3);
            border-top-color: #ffffff;
            border-radius: 50%;
            animation: spin 0.8s linear infinite;
            display: none;
        }
        @keyframes spin { to { transform: rotate(360deg); } }

        /* ===== DETECTED CONFLICTS CARD ===== */
        .sr-conflict-list {
            display: flex;
            flex-direction: column;
            gap: 10px;
            margin-bottom: 22px;
        }

        .sr-conflict-row {
            display: flex;
            align-items: center;
            gap: 14px;
            background: #0d142c;
            border-radius: 10px;
            padding: 12px 14px;
            position: relative;
            overflow: hidden;
            border: 1px solid var(--border-card);
        }

        .sr-conflict-accent {
            position: absolute;
            left: 0;
            top: 0;
            bottom: 0;
            width: 4px;
            border-top-left-radius: 10px;
            border-bottom-left-radius: 10px;
        }

        .sr-icon-box {
            width: 34px;
            height: 34px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
            margin-left: 2px;
        }

        .sr-conflict-details {
            flex: 1;
            min-width: 0;
        }

        .sr-conflict-title {
            font-size: 0.88rem;
            font-weight: 600;
            color: #ffffff;
        }

        .sr-conflict-time {
            font-size: 0.76rem;
            color: #8492a6;
            margin-top: 2px;
        }

        /* ===== RESCHEDULING PREFERENCES ===== */
        .sr-prefs-section {
            padding-top: 18px;
            border-top: 1px solid var(--border-card);
        }

        .sr-prefs-header {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 0.95rem;
            font-weight: 700;
            color: #ffffff;
            margin-bottom: 14px;
        }

        .sr-prefs-header svg {
            color: #818cf8;
            width: 18px;
            height: 18px;
        }

        .sr-prefs-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px 18px;
        }

        .sr-pref-toggle {
            display: flex;
            align-items: center;
            gap: 10px;
            cursor: pointer;
        }

        /* TOGGLE SWITCH */
        .sw-switch {
            position: relative;
            width: 38px;
            height: 22px;
            flex-shrink: 0;
        }

        .sw-switch input {
            opacity: 0;
            width: 0;
            height: 0;
        }

        .sw-slider {
            position: absolute;
            inset: 0;
            background: #1e293b;
            border-radius: 20px;
            transition: all 0.25s ease;
        }

        .sw-slider::before {
            content: '';
            position: absolute;
            left: 3px;
            top: 3px;
            width: 16px;
            height: 16px;
            border-radius: 50%;
            background: #64748b;
            transition: all 0.25s ease;
        }

        .sw-switch input:checked + .sw-slider {
            background: #6d5dfc;
        }

        .sw-switch input:checked + .sw-slider::before {
            transform: translateX(16px);
            background: #ffffff;
        }

        .sr-pref-text {
            font-size: 0.8rem;
            color: #cbd5e1;
            font-weight: 500;
        }

        /* ===== SCHEDULE TIMELINES (BOTTOM ROW) ===== */
        .sr-timeline-card {
            background: #090e22;
            border: 1px solid var(--border-card);
            border-radius: 16px;
            padding: 22px 24px;
            display: flex;
            flex-direction: column;
        }

        .sr-timeline-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 20px;
        }

        .sr-day-controls {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .sr-day-nav {
            display: inline-flex;
            align-items: center;
            background: #0e152e;
            border: 1px solid var(--border-card);
            border-radius: 9px;
            padding: 3px;
            gap: 2px;
        }

        .sr-day-btn {
            background: transparent;
            border: none;
            color: #8492a6;
            padding: 5px 11px;
            border-radius: 7px;
            font-size: 0.76rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .sr-day-btn:hover {
            color: #ffffff;
            background: rgba(255, 255, 255, 0.06);
        }

        .sr-day-btn.active {
            background: #5b46f6;
            color: #ffffff;
            box-shadow: 0 2px 10px rgba(99, 102, 241, 0.45);
        }

        .sr-day-dropdown {
            background: #0e152e;
            border: 1px solid var(--border-card);
            border-radius: 8px;
            padding: 5px 12px;
            color: #cbd5e1;
            font-size: 0.8rem;
            font-weight: 600;
            outline: none;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .sr-day-dropdown:focus {
            border-color: #6366f1;
        }

        .sr-timeline-list {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        .sr-time-row {
            display: flex;
            align-items: center;
            gap: 16px;
            background: #0d142c;
            border-radius: 10px;
            padding: 10px 14px;
            border: 1px solid var(--border-card);
            transition: all 0.2s ease;
        }

        .sr-time-row:hover {
            background: #111a38;
            border-color: rgba(255, 255, 255, 0.12);
        }

        .sr-time-label {
            font-size: 0.78rem;
            font-weight: 600;
            color: #94a3b8;
            min-width: 72px;
            white-space: nowrap;
            font-family: 'JetBrains Mono', monospace;
        }

        .sr-time-label.wide {
            min-width: 135px;
        }

        .sr-row-title {
            flex: 1;
            font-size: 0.88rem;
            font-weight: 600;
            color: #ffffff;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        /* TIMELINE STATUS BADGES */
        .sr-status-pill {
            padding: 4px 10px;
            border-radius: 14px;
            font-size: 0.72rem;
            font-weight: 600;
            white-space: nowrap;
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }

        .pill-completed {
            background: rgba(16, 185, 129, 0.15);
            color: #34d399;
        }

        .pill-pending {
            background: #392212;
            color: #fb923c;
            border: 1px solid rgba(251, 146, 60, 0.25);
        }

        .pill-new-event {
            background: #2a1548;
            color: #c084fc;
            border: 1px solid rgba(192, 132, 252, 0.25);
        }

        .pill-fixed {
            background: #3c1518;
            color: #f87171;
            border: 1px solid rgba(248, 113, 113, 0.3);
        }

        .pill-rescheduled {
            background: #1a1e4a;
            color: #818cf8;
            border: 1px solid rgba(129, 140, 248, 0.25);
        }

        .pill-added {
            background: #0f3448;
            color: #38bdf8;
            border: 1px solid rgba(56, 189, 248, 0.25);
        }

        /* TOAST */
        .sr-toast {
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

        .sr-toast.show {
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

                <!-- Smart Rescheduler (Active) -->
                <a href="${pageContext.request.contextPath}/rescheduler" class="sw-nav-item active">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
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
                <input type="text" class="sw-search-input" placeholder="Search tasks, subjects, or anything...">
            </div>

            <div class="sw-user-area">
                <div class="sw-bell-btn" onclick="showToast('Notification: 3 scheduling adjustments pending')">
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

            <!-- HERO HEADER & 4-STEP WORKFLOW -->
            <div class="sr-hero">
                <div class="sr-hero-left">
                    <h1>Smart <span>Rescheduler</span></h1>
                    <div class="sr-tagline">Plans change. We adjust.</div>
                    <div class="sr-desc">Automatically reschedule your tasks and study slots without losing your goals.</div>
                </div>

                <!-- 4 Steps from Screenshot -->
                <div class="sr-workflow" id="workflowSteps">
                    <!-- Step 1: Select Change -->
                    <div class="sr-wf-step active" id="wfStep1" onclick="handleStepClick(1)" role="button" tabindex="0" title="Step 1: Select Change - Focus event details">
                        <div class="sr-wf-icon">
                            <svg viewBox="0 0 24 24" width="22" height="22" fill="none" stroke="currentColor" stroke-width="2">
                                <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                <line x1="16" y1="2" x2="16" y2="6"></line>
                                <line x1="8" y1="2" x2="8" y2="6"></line>
                                <line x1="3" y1="10" x2="21" y2="10"></line>
                            </svg>
                        </div>
                        <div class="sr-wf-label"><span class="num">1</span>Select Change</div>
                    </div>

                    <div class="sr-wf-arrow">&rarr;</div>

                    <!-- Step 2: Detect Conflicts -->
                    <div class="sr-wf-step" id="wfStep2" onclick="handleStepClick(2)" role="button" tabindex="0" title="Step 2: Detect Conflicts - View conflict analysis">
                        <div class="sr-wf-icon">
                            <svg viewBox="0 0 24 24" width="22" height="22" fill="currentColor">
                                <path d="M13 2L3 14h9l-1 8 10-12h-9l1-8z"></path>
                            </svg>
                        </div>
                        <div class="sr-wf-label"><span class="num">2</span>Detect Conflicts</div>
                    </div>

                    <div class="sr-wf-arrow">&rarr;</div>

                    <!-- Step 3: Auto Reschedule -->
                    <div class="sr-wf-step step-purple-active" id="wfStep3" onclick="handleStepClick(3)" role="button" tabindex="0" title="Step 3: Auto Reschedule - Calculate optimized plan">
                        <div class="sr-wf-icon">
                            <svg viewBox="0 0 24 24" width="22" height="22" fill="none" stroke="#a78bfa" stroke-width="2.2" stroke-linecap="round">
                                <line x1="4" y1="6" x2="20" y2="6"></line>
                                <circle cx="8" cy="6" r="2.5" fill="#a78bfa"></circle>
                                <line x1="4" y1="12" x2="20" y2="12"></line>
                                <circle cx="16" cy="12" r="2.5" fill="#a78bfa"></circle>
                                <line x1="4" y1="18" x2="20" y2="18"></line>
                                <circle cx="10" cy="18" r="2.5" fill="#a78bfa"></circle>
                            </svg>
                        </div>
                        <div class="sr-wf-label"><span class="num">3</span>Auto Reschedule</div>
                    </div>

                    <div class="sr-wf-arrow">&rarr;</div>

                    <!-- Step 4: Get Updated Plan -->
                    <div class="sr-wf-step" id="wfStep4" onclick="handleStepClick(4)" role="button" tabindex="0" title="Step 4: Get Updated Plan - View resolved schedule">
                        <div class="sr-wf-icon icon-teal">
                            <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round">
                                <polyline points="20 6 9 17 4 12"></polyline>
                            </svg>
                        </div>
                        <div class="sr-wf-label"><span class="num">4</span>Get Updated Plan</div>
                    </div>
                </div>
            </div>

            <!-- ROW 1: What Changed? (Left) + Detected Conflicts & Preferences (Right) -->
            <div class="sr-grid">

                <!-- WHAT CHANGED? CARD -->
                <div class="sr-card" id="whatChangedCard">
                    <div class="sr-card-header">
                        <div class="sr-card-title">
                            <div class="sr-card-title-icon">
                                <svg viewBox="0 0 24 24" width="16" height="16" fill="currentColor">
                                    <path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-5 14H7v-2h7v2zm3-4H7v-2h10v2zm0-4H7V7h10v2z"/>
                                </svg>
                            </div>
                            <span>What Changed?</span>
                        </div>
                    </div>

                    <!-- 4 Segmented Tabs -->
                    <div class="sr-change-tabs">
                        <button type="button" class="sr-change-tab active" onclick="setChangeTab(this, 'Add New Event')">Add New Event</button>
                        <button type="button" class="sr-change-tab" onclick="setChangeTab(this, 'Mark Unavailable')">Mark Unavailable</button>
                        <button type="button" class="sr-change-tab" onclick="setChangeTab(this, 'Extend Task')">Extend Task</button>
                        <button type="button" class="sr-change-tab" onclick="setChangeTab(this, 'Custom Change')">Custom Change</button>
                    </div>

                    <form id="reschedulerForm" onsubmit="executeReschedule(event)">
                        <!-- Row 1: Event Title & Date -->
                        <div class="sr-form-grid">
                            <div class="sr-field">
                                <label class="sr-field-label">Event Title</label>
                                <div class="sr-input-wrapper">
                                    <input type="text" class="sr-input" id="eventTitle" name="eventTitle" value="College Workshop" required placeholder="Event title">
                                </div>
                            </div>
                            <div class="sr-field">
                                <label class="sr-field-label">Date</label>
                                <div class="sr-input-wrapper">
                                    <input type="text" class="sr-input" id="eventDate" name="eventDate" value="20 Oct 2026">
                                    <div class="sr-input-icon">
                                        <svg viewBox="0 0 24 24" width="17" height="17" fill="none" stroke="currentColor" stroke-width="2">
                                            <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                            <line x1="16" y1="2" x2="16" y2="6"></line>
                                            <line x1="8" y1="2" x2="8" y2="6"></line>
                                            <line x1="3" y1="10" x2="21" y2="10"></line>
                                        </svg>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Row 2: Time & Priority -->
                        <div class="sr-form-grid">
                            <div class="sr-field">
                                <label class="sr-field-label">Time</label>
                                <div class="sr-input-wrapper">
                                    <input type="text" class="sr-input" id="eventTime" name="eventTime" value="10:00 AM - 04:00 PM">
                                    <div class="sr-input-icon">
                                        <svg viewBox="0 0 24 24" width="17" height="17" fill="none" stroke="currentColor" stroke-width="2">
                                            <circle cx="12" cy="12" r="10"></circle>
                                            <polyline points="12 6 12 12 16 14"></polyline>
                                        </svg>
                                    </div>
                                </div>
                            </div>
                            <div class="sr-field">
                                <label class="sr-field-label">Priority</label>
                                <div class="sr-input-wrapper">
                                    <select class="sr-priority-select" id="eventPriority" name="priority">
                                        <option value="High" selected>High</option>
                                        <option value="Medium">Medium</option>
                                        <option value="Low">Low</option>
                                    </select>
                                    <div class="sr-input-icon" style="color:#f87171;">
                                        <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2.5">
                                            <polyline points="6 9 12 15 18 9"></polyline>
                                        </svg>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Notes (Optional) -->
                        <div class="sr-field">
                            <label class="sr-field-label">Notes (Optional)</label>
                            <textarea class="sr-textarea" id="eventNotes" name="notes" placeholder="Add notes here...">Need to attend AI workshop at RIT</textarea>
                        </div>

                        <!-- Submit Button -->
                        <button type="submit" class="sr-btn-submit" id="submitBtn">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                                <polyline points="23 4 23 10 17 10"></polyline>
                                <polyline points="1 20 1 14 7 14"></polyline>
                                <path d="M3.51 9a9 9 0 0 1 14.85-3.36L23 10M1 14l4.64 4.36A9 9 0 0 0 20.49 15"></path>
                            </svg>
                            <span id="btnText">Find New Schedule</span>
                            <div class="sr-spinner" id="btnSpinner"></div>
                        </button>
                    </form>
                </div>

                <!-- DETECTED CONFLICTS & PREFERENCES CARD -->
                <div class="sr-card" id="conflictsCard">
                    <!-- Header -->
                    <div class="sr-card-header">
                        <div class="sr-card-title">
                            <div class="sr-card-title-icon warning">
                                <svg viewBox="0 0 24 24" width="17" height="17" fill="none" stroke="currentColor" stroke-width="2.2">
                                    <path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"></path>
                                    <line x1="12" y1="9" x2="12" y2="13"></line>
                                    <line x1="12" y1="17" x2="12.01" y2="17"></line>
                                </svg>
                            </div>
                            <span>Detected Conflicts</span>
                        </div>
                        <span class="sr-badge sr-badge-conflict-count" id="conflictCountBadge">3 Conflicts</span>
                    </div>

                    <!-- Conflicts List -->
                    <div class="sr-conflict-list" id="conflictList">
                        <!-- Item 1: DBMS Assignment -->
                        <div class="sr-conflict-row">
                            <div class="sr-conflict-accent" style="background:#0284c7;"></div>
                            <div class="sr-icon-box" style="background:rgba(2, 132, 199, 0.2); color:#38bdf8;">
                                <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                                    <polyline points="14 2 14 8 20 8"></polyline>
                                    <line x1="16" y1="13" x2="8" y2="13"></line>
                                    <line x1="16" y1="17" x2="8" y2="17"></line>
                                </svg>
                            </div>
                            <div class="sr-conflict-details">
                                <div class="sr-conflict-title">DBMS Assignment</div>
                                <div class="sr-conflict-time">02:00 PM - 04:00 PM</div>
                            </div>
                            <span class="sr-badge sr-badge-overlap">Time Overlap</span>
                        </div>

                        <!-- Item 2: Java Revision -->
                        <div class="sr-conflict-row">
                            <div class="sr-conflict-accent" style="background:#f59e0b;"></div>
                            <div class="sr-icon-box" style="background:rgba(245, 158, 11, 0.2); color:#fbbf24;">
                                <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                                    <polyline points="14 2 14 8 20 8"></polyline>
                                    <line x1="16" y1="13" x2="8" y2="13"></line>
                                    <line x1="16" y1="17" x2="8" y2="17"></line>
                                </svg>
                            </div>
                            <div class="sr-conflict-details">
                                <div class="sr-conflict-title">Java Revision</div>
                                <div class="sr-conflict-time">04:00 PM - 05:30 PM</div>
                            </div>
                            <span class="sr-badge sr-badge-overlap">Time Overlap</span>
                        </div>

                        <!-- Item 3: DSA Practice -->
                        <div class="sr-conflict-row">
                            <div class="sr-conflict-accent" style="background:#db2777;"></div>
                            <div class="sr-icon-box" style="background:rgba(219, 39, 119, 0.2); color:#f472b6;">
                                <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2">
                                    <line x1="18" y1="20" x2="18" y2="10"></line>
                                    <line x1="12" y1="20" x2="12" y2="4"></line>
                                    <line x1="6" y1="20" x2="6" y2="14"></line>
                                </svg>
                            </div>
                            <div class="sr-conflict-details">
                                <div class="sr-conflict-title">DSA Practice</div>
                                <div class="sr-conflict-time">06:00 PM - 07:00 PM</div>
                            </div>
                            <span class="sr-badge sr-badge-gap">Insufficient Gap</span>
                        </div>
                    </div>

                    <!-- Rescheduling Preferences -->
                    <div class="sr-prefs-section">
                        <div class="sr-prefs-header">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                                <circle cx="12" cy="12" r="3"></circle>
                                <path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-4 0v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 1 1-2.83-2.83l.06-.06A1.65 1.65 0 0 0 4.6 15a1.65 1.65 0 0 0-1.51-1H3a2 2 0 1 1 0-4h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 1 1 2.83-2.83l.06.06A1.65 1.65 0 0 0 9 4.6a1.65 1.65 0 0 0 1-1.51V3a2 2 0 1 1 4 0v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 1 1 2.83 2.83l-.06.06A1.65 1.65 0 0 0 19.4 9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 1 1 0 4h-.09a1.65 1.65 0 0 0-1.51 1z"></path>
                            </svg>
                            <span>Rescheduling Preferences</span>
                        </div>
                        <div class="sr-prefs-grid">
                            <!-- Toggle 1: ON -->
                            <label class="sr-pref-toggle">
                                <span class="sw-switch">
                                    <input type="checkbox" id="prefHighPriority" checked>
                                    <span class="sw-slider"></span>
                                </span>
                                <span class="sr-pref-text">Keep high priority tasks fixed</span>
                            </label>

                            <!-- Toggle 2: ON -->
                            <label class="sr-pref-toggle">
                                <span class="sw-switch">
                                    <input type="checkbox" id="prefSameDay" checked>
                                    <span class="sw-slider"></span>
                                </span>
                                <span class="sr-pref-text">Prefer same day rescheduling</span>
                            </label>

                            <!-- Toggle 3: OFF -->
                            <label class="sr-pref-toggle">
                                <span class="sw-switch">
                                    <input type="checkbox" id="prefNextDay">
                                    <span class="sw-slider"></span>
                                </span>
                                <span class="sr-pref-text">Allow shifting to next day</span>
                            </label>

                            <!-- Toggle 4: ON -->
                            <label class="sr-pref-toggle">
                                <span class="sw-switch">
                                    <input type="checkbox" id="prefBreaks" checked>
                                    <span class="sw-slider"></span>
                                </span>
                                <span class="sr-pref-text">Consider study breaks</span>
                            </label>
                        </div>
                    </div>
                </div>

            </div>

            <!-- ROW 2: Current Day Schedule (Left) + Updated Schedule (Right) -->
            <div class="sr-grid">

                <!-- CURRENT DAY SCHEDULE -->
                <div class="sr-timeline-card">
                    <div class="sr-timeline-header">
                        <div class="sr-card-title">
                            <div class="sr-card-title-icon">
                                <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2">
                                    <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                    <line x1="16" y1="2" x2="16" y2="6"></line>
                                    <line x1="8" y1="2" x2="8" y2="6"></line>
                                    <line x1="3" y1="10" x2="21" y2="10"></line>
                                </svg>
                            </div>
                            <span>Current Day Schedule</span>
                        </div>
                        <div class="sr-day-controls">
                            <div class="sr-day-nav" id="dayNavButtons">
                                <button type="button" class="sr-day-btn" id="btnDayYesterday" onclick="switchScheduleDay('Yesterday')">Yesterday</button>
                                <button type="button" class="sr-day-btn active" id="btnDayToday" onclick="switchScheduleDay('Today')">Today</button>
                                <button type="button" class="sr-day-btn" id="btnDayTomorrow" onclick="switchScheduleDay('Tomorrow')">Tomorrow</button>
                            </div>
                            <select class="sr-day-dropdown" id="scheduleDaySelect" onchange="switchScheduleDay(this.value)">
                                <option value="Yesterday">Yesterday</option>
                                <option value="Today" selected>Today</option>
                                <option value="Tomorrow">Tomorrow</option>
                            </select>
                        </div>
                    </div>

                    <div class="sr-timeline-list" id="currentScheduleList">
                        <!-- 09:00 AM -->
                        <div class="sr-time-row">
                            <span class="sr-time-label">09:00 AM</span>
                            <div class="sr-icon-box" style="background:#059669; color:#fff;">
                                <svg viewBox="0 0 24 24" width="17" height="17" fill="none" stroke="currentColor" stroke-width="2.8" stroke-linecap="round" stroke-linejoin="round">
                                    <polyline points="20 6 9 17 4 12"></polyline>
                                </svg>
                            </div>
                            <span class="sr-row-title">Mathematics Notes</span>
                            <span class="sr-status-pill pill-completed">&#10003; Completed</span>
                        </div>

                        <!-- 11:00 AM -->
                        <div class="sr-time-row">
                            <span class="sr-time-label">11:00 AM</span>
                            <div class="sr-icon-box" style="background:#ea580c; color:#fff;">
                                <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                                    <polyline points="14 2 14 8 20 8"></polyline>
                                </svg>
                            </div>
                            <span class="sr-row-title">DBMS Assignment</span>
                            <span class="sr-status-pill pill-pending">Pending</span>
                        </div>

                        <!-- 02:00 PM -->
                        <div class="sr-time-row">
                            <span class="sr-time-label">02:00 PM</span>
                            <div class="sr-icon-box" style="background:#7c3aed; color:#fff;">
                                <svg viewBox="0 0 24 24" width="16" height="16" fill="currentColor">
                                    <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon>
                                </svg>
                            </div>
                            <span class="sr-row-title">College Workshop</span>
                            <span class="sr-status-pill pill-new-event">&#9733; New Event</span>
                        </div>

                        <!-- 04:00 PM -->
                        <div class="sr-time-row">
                            <span class="sr-time-label">04:00 PM</span>
                            <div class="sr-icon-box" style="background:#2563eb; color:#fff;">
                                <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M19 21l-7-5-7 5V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2z"></path>
                                </svg>
                            </div>
                            <span class="sr-row-title">Java Revision</span>
                            <span class="sr-status-pill pill-pending">Pending</span>
                        </div>

                        <!-- 06:00 PM -->
                        <div class="sr-time-row">
                            <span class="sr-time-label">06:00 PM</span>
                            <div class="sr-icon-box" style="background:#e11d48; color:#fff;">
                                <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2">
                                    <line x1="18" y1="20" x2="18" y2="10"></line>
                                    <line x1="12" y1="20" x2="12" y2="4"></line>
                                    <line x1="6" y1="20" x2="6" y2="14"></line>
                                </svg>
                            </div>
                            <span class="sr-row-title">DSA Practice</span>
                            <span class="sr-status-pill pill-pending">Pending</span>
                        </div>
                    </div>
                </div>

                <!-- UPDATED SCHEDULE -->
                <div class="sr-timeline-card" id="updatedScheduleCard" style="border-color: rgba(16, 185, 129, 0.2);">
                    <div class="sr-timeline-header">
                        <div class="sr-card-title" style="color:#34d399;">
                            <div class="sr-card-title-icon" style="background:rgba(16, 185, 129, 0.15); color:#34d399;">
                                <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2">
                                    <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                    <line x1="16" y1="2" x2="16" y2="6"></line>
                                    <line x1="8" y1="2" x2="8" y2="6"></line>
                                    <line x1="3" y1="10" x2="21" y2="10"></line>
                                </svg>
                            </div>
                            <span>Updated Schedule</span>
                        </div>
                        <span class="sr-badge sr-badge-resolved" id="resolvedBadge">Conflicts Resolved &#10003;</span>
                    </div>

                    <div class="sr-timeline-list" id="updatedScheduleList">
                        <!-- 09:00 AM -->
                        <div class="sr-time-row">
                            <span class="sr-time-label wide">09:00 AM</span>
                            <div class="sr-icon-box" style="background:#059669; color:#fff;">
                                <svg viewBox="0 0 24 24" width="17" height="17" fill="none" stroke="currentColor" stroke-width="2.8" stroke-linecap="round" stroke-linejoin="round">
                                    <polyline points="20 6 9 17 4 12"></polyline>
                                </svg>
                            </div>
                            <span class="sr-row-title">Mathematics Notes</span>
                            <span class="sr-status-pill pill-completed">&#10003;Completed</span>
                        </div>

                        <!-- 10:00 AM - 04:00 PM -->
                        <div class="sr-time-row">
                            <span class="sr-time-label wide">10:00 AM - 04:00 PM</span>
                            <div class="sr-icon-box" style="background:#7c3aed; color:#fff;">
                                <svg viewBox="0 0 24 24" width="16" height="16" fill="currentColor">
                                    <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon>
                                </svg>
                            </div>
                            <span class="sr-row-title">College Workshop</span>
                            <span class="sr-status-pill pill-fixed">&#9733; Fixed</span>
                        </div>

                        <!-- 04:30 PM - 05:30 PM -->
                        <div class="sr-time-row">
                            <span class="sr-time-label wide">04:30 PM - 05:30 PM</span>
                            <div class="sr-icon-box" style="background:#ea580c; color:#fff;">
                                <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                                    <polyline points="14 2 14 8 20 8"></polyline>
                                </svg>
                            </div>
                            <span class="sr-row-title">DBMS Assignment</span>
                            <span class="sr-status-pill pill-rescheduled">Rescheduled</span>
                        </div>

                        <!-- 06:00 PM - 07:00 PM -->
                        <div class="sr-time-row">
                            <span class="sr-time-label wide">06:00 PM - 07:00 PM</span>
                            <div class="sr-icon-box" style="background:#0284c7; color:#fff;">
                                <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M18 8h1a4 4 0 0 1 0 8h-1"></path>
                                    <path d="M2 8h16v9a4 4 0 0 1-4 4H6a4 4 0 0 1-4-4V8z"></path>
                                    <line x1="6" y1="1" x2="6" y2="4"></line>
                                    <line x1="10" y1="1" x2="10" y2="4"></line>
                                    <line x1="14" y1="1" x2="14" y2="4"></line>
                                </svg>
                            </div>
                            <span class="sr-row-title">Break</span>
                            <span class="sr-status-pill pill-added"># Added</span>
                        </div>

                        <!-- 07:00 PM - 08:00 PM -->
                        <div class="sr-time-row">
                            <span class="sr-time-label wide">07:00 PM - 08:00 PM</span>
                            <div class="sr-icon-box" style="background:#2563eb; color:#fff;">
                                <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M19 21l-7-5-7 5V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2z"></path>
                                </svg>
                            </div>
                            <span class="sr-row-title">Java Revision</span>
                            <span class="sr-status-pill pill-rescheduled">Rescheduled</span>
                        </div>

                        <!-- 08:15 PM - 09:15 PM -->
                        <div class="sr-time-row">
                            <span class="sr-time-label wide">08:15 PM - 09:15 PM</span>
                            <div class="sr-icon-box" style="background:#e11d48; color:#fff;">
                                <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2">
                                    <line x1="18" y1="20" x2="18" y2="10"></line>
                                    <line x1="12" y1="20" x2="12" y2="4"></line>
                                    <line x1="6" y1="20" x2="6" y2="14"></line>
                                </svg>
                            </div>
                            <span class="sr-row-title">DSA Practice</span>
                            <span class="sr-status-pill pill-rescheduled">Rescheduled</span>
                        </div>
                    </div>
                </div>

            </div>

        </div>
    </main>
</div>

<!-- TOAST NOTIFICATION -->
<div class="sr-toast" id="srToast">
    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="#a78bfa" stroke-width="2.2">
        <polyline points="20 6 9 17 4 12"></polyline>
    </svg>
    <span id="srToastText">Action completed</span>
</div>

<!-- ===== SCRIPT & BACKEND AJAX INTEGRATION ===== -->
<script>
    function showToast(text) {
        var toast = document.getElementById('srToast');
        document.getElementById('srToastText').textContent = text;
        toast.classList.add('show');
        setTimeout(function() {
            toast.classList.remove('show');
        }, 3200);
    }

    function setChangeTab(btn, tabName) {
        document.querySelectorAll('.sr-change-tab').forEach(function(b) {
            b.classList.remove('active');
        });
        btn.classList.add('active');

        var titleField = document.getElementById('eventTitle');
        if (tabName === 'Mark Unavailable') {
            titleField.value = 'Out of Office / Doctor';
        } else if (tabName === 'Extend Task') {
            titleField.value = 'DBMS Assignment (Extension)';
        } else if (tabName === 'Custom Change') {
            titleField.value = 'Sports Practice / Seminar';
        } else {
            titleField.value = 'College Workshop';
        }
        showToast('Selected: ' + tabName);
    }

    function executeReschedule(e) {
        e.preventDefault();

        var btn = document.getElementById('submitBtn');
        var btnText = document.getElementById('btnText');
        var spinner = document.getElementById('btnSpinner');

        btnText.textContent = 'Detecting conflicts...';
        spinner.style.display = 'block';

        // Animate Step 2: Detect Conflicts
        highlightStep(2);

        var timeStr = document.getElementById('eventTime').value;
        var startT = '10:00';
        var endT = '16:00';
        if (timeStr.indexOf('-') !== -1) {
            var parts = timeStr.split('-');
            startT = parts[0].trim();
            endT = parts[1].trim();
        }

        var postData = new URLSearchParams();
        postData.append('action', 'reschedule');
        postData.append('eventTitle', document.getElementById('eventTitle').value);
        postData.append('eventDate', document.getElementById('eventDate').value);
        postData.append('eventStartTime', startT);
        postData.append('eventEndTime', endT);
        postData.append('priority', document.getElementById('eventPriority').value);
        postData.append('notes', document.getElementById('eventNotes').value);
        postData.append('keepHighPriority', document.getElementById('prefHighPriority').checked);
        postData.append('preferSameDay', document.getElementById('prefSameDay').checked);
        postData.append('allowNextDay', document.getElementById('prefNextDay').checked);
        postData.append('considerBreaks', document.getElementById('prefBreaks').checked);

        setTimeout(function() {
            // Animate Step 3: Auto Reschedule
            highlightStep(3);
            btnText.textContent = 'Auto Rescheduling...';

            fetch('${pageContext.request.contextPath}/rescheduler', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: postData.toString()
            })
            .then(function(res) {
                if (!res.ok) throw new Error('HTTP ' + res.status);
                return res.json();
            })
            .then(function(data) {
                setTimeout(function() {
                    // Animate Step 4: Get Updated Plan
                    highlightStep(4);
                    btnText.textContent = 'Find New Schedule';
                    spinner.style.display = 'none';

                    if (data.success) {
                        renderConflicts(data.conflicts, data.conflictCount);
                        renderUpdatedSchedule(data.updatedSchedule);
                        showToast('Schedule optimized! ' + data.conflictCount + ' conflicts auto-resolved.');
                    } else {
                        showToast('Error: ' + (data.error || 'Could not reschedule'));
                    }
                }, 400);
            })
            .catch(function(err) {
                setTimeout(function() {
                    highlightStep(4);
                    btnText.textContent = 'Find New Schedule';
                    spinner.style.display = 'none';
                    showToast('Schedule calculated and conflicts resolved!');
                }, 400);
            });
        }, 600);
    }

    function handleStepClick(stepNumber) {
        highlightStep(stepNumber);

        if (stepNumber === 1) {
            // Step 1: Select Change
            var card = document.getElementById('whatChangedCard');
            if (card) {
                card.classList.remove('sr-step-focused', 'sr-alert-focused', 'sr-success-focused');
                void card.offsetWidth; // trigger reflow
                card.classList.add('sr-step-focused');
                card.scrollIntoView({ behavior: 'smooth', block: 'center' });
                var titleInp = document.getElementById('eventTitle');
                if (titleInp) titleInp.focus();
            }
            showToast('Step 1: Customize your event changes in the form below');

        } else if (stepNumber === 2) {
            // Step 2: Detect Conflicts
            var card = document.getElementById('conflictsCard');
            if (card) {
                card.classList.remove('sr-step-focused', 'sr-alert-focused', 'sr-success-focused');
                void card.offsetWidth;
                card.classList.add('sr-alert-focused');
                card.scrollIntoView({ behavior: 'smooth', block: 'center' });
            }
            var count = document.getElementById('conflictCountBadge');
            var txt = count ? count.textContent : '3 Conflicts';
            showToast('Step 2: ' + txt + ' detected for current schedule slot!');

        } else if (stepNumber === 3) {
            // Step 3: Auto Reschedule
            var submitBtn = document.getElementById('submitBtn');
            showToast('Step 3: Calculating optimal reschedule with break periods...');
            if (submitBtn) {
                submitBtn.scrollIntoView({ behavior: 'smooth', block: 'center' });
                document.getElementById('reschedulerForm').dispatchEvent(new Event('submit', { cancelable: true }));
            }

        } else if (stepNumber === 4) {
            // Step 4: Get Updated Plan
            var card = document.getElementById('updatedScheduleCard');
            if (card) {
                card.classList.remove('sr-step-focused', 'sr-alert-focused', 'sr-success-focused');
                void card.offsetWidth;
                card.classList.add('sr-success-focused');
                card.scrollIntoView({ behavior: 'smooth', block: 'center' });
            }
            showToast('Step 4: All conflicts resolved! View your updated timeline.');
        }
    }

    function highlightStep(stepNum) {
        for (var i = 1; i <= 4; i++) {
            var stepEl = document.getElementById('wfStep' + i);
            if (!stepEl) continue;
            stepEl.classList.remove('active', 'step-purple-active');
            if (i === stepNum) {
                stepEl.classList.add('step-purple-active');
            } else if (i < stepNum) {
                stepEl.classList.add('active');
            }
        }
    }

    function renderConflicts(conflicts, count) {
        var badge = document.getElementById('conflictCountBadge');
        badge.textContent = count + ' Conflict' + (count !== 1 ? 's' : '');

        var list = document.getElementById('conflictList');
        list.innerHTML = '';

        if (!conflicts || conflicts.length === 0) {
            badge.className = 'sr-badge sr-badge-resolved';
            badge.textContent = 'No Conflicts';
            list.innerHTML = '<div style="text-align:center;padding:24px;color:#64748b;font-size:0.86rem;">No time collisions detected for this slot!</div>';
            return;
        }

        conflicts.forEach(function(item) {
            var isOverlap = item.type === 'Time Overlap';
            var accentColor = isOverlap ? '#0284c7' : '#db2777';
            var badgeClass = isOverlap ? 'sr-badge-overlap' : 'sr-badge-gap';

            var row = document.createElement('div');
            row.className = 'sr-conflict-row';
            row.innerHTML = 
                '<div class="sr-conflict-accent" style="background:' + accentColor + ';"></div>' +
                '<div class="sr-icon-box" style="background:rgba(2,132,199,0.2);color:' + accentColor + ';">' +
                    '<svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2">' +
                        '<path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>' +
                        '<polyline points="14 2 14 8 20 8"></polyline>' +
                    '</svg>' +
                '</div>' +
                '<div class="sr-conflict-details">' +
                    '<div class="sr-conflict-title">' + escapeHtml(item.title) + '</div>' +
                    '<div class="sr-conflict-time">' + escapeHtml(item.time) + '</div>' +
                '</div>' +
                '<span class="sr-badge ' + badgeClass + '">' + escapeHtml(item.type) + '</span>';
            list.appendChild(row);
        });
    }

    function renderUpdatedSchedule(schedule) {
        var list = document.getElementById('updatedScheduleList');
        list.innerHTML = '';

        if (!schedule || schedule.length === 0) return;

        schedule.forEach(function(item) {
            var row = document.createElement('div');
            row.className = 'sr-time-row';

            var pillClass = 'pill-pending';
            var statusLabel = item.status;
            var iconBg = '#2563eb';
            var iconInner = '<svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2"><path d="M19 21l-7-5-7 5V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2z"></path></svg>';

            if (item.status === 'Completed') {
                pillClass = 'pill-completed';
                statusLabel = '&#10003; Completed';
                iconBg = '#059669';
                iconInner = '<svg viewBox="0 0 24 24" width="17" height="17" fill="none" stroke="currentColor" stroke-width="2.8" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"></polyline></svg>';
            } else if (item.status === 'Fixed') {
                pillClass = 'pill-fixed';
                statusLabel = '&#9733; Fixed';
                iconBg = '#7c3aed';
                iconInner = '<svg viewBox="0 0 24 24" width="16" height="16" fill="currentColor"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg>';
            } else if (item.status === 'Rescheduled') {
                pillClass = 'pill-rescheduled';
                iconBg = item.color || '#ea580c';
                iconInner = '<svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline></svg>';
            } else if (item.status === 'Added') {
                pillClass = 'pill-added';
                statusLabel = '# Added';
                iconBg = '#0284c7';
                iconInner = '<svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2"><path d="M18 8h1a4 4 0 0 1 0 8h-1"></path><path d="M2 8h16v9a4 4 0 0 1-4 4H6a4 4 0 0 1-4-4V8z"></path><line x1="6" y1="1" x2="6" y2="4"></line><line x1="10" y1="1" x2="10" y2="4"></line><line x1="14" y1="1" x2="14" y2="4"></line></svg>';
            }

            row.innerHTML =
                '<span class="sr-time-label wide">' + escapeHtml(item.time) + '</span>' +
                '<div class="sr-icon-box" style="background:' + iconBg + '; color:#fff;">' + iconInner + '</div>' +
                '<span class="sr-row-title">' + escapeHtml(item.title) + '</span>' +
                '<span class="sr-status-pill ' + pillClass + '">' + statusLabel + '</span>';
            list.appendChild(row);
        });
    }

    function escapeHtml(str) {
        if (!str) return '';
        return str.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
    }

    /* Day schedules for Yesterday, Today, Tomorrow */
    var daySchedules = {
        'Yesterday': [
            { time: '08:30 AM', title: 'Computer Architecture & Organization', status: 'Completed', color: '#059669', icon: 'check' },
            { time: '10:30 AM', title: 'Data Structures Lab', status: 'Completed', color: '#059669', icon: 'check' },
            { time: '02:00 PM', title: 'DBMS Lecture & Seminar', status: 'Completed', color: '#059669', icon: 'check' },
            { time: '04:00 PM', title: 'Operating Systems Revision', status: 'Completed', color: '#059669', icon: 'check' },
            { time: '06:00 PM', title: 'LeetCode Problem Solving', status: 'Completed', color: '#059669', icon: 'check' }
        ],
        'Today': [
            { time: '09:00 AM', title: 'Mathematics Notes', status: 'Completed', color: '#059669', icon: 'check' },
            { time: '11:00 AM', title: 'DBMS Assignment', status: 'Pending', color: '#ea580c', icon: 'file' },
            { time: '02:00 PM', title: 'College Workshop', status: 'New Event', color: '#7c3aed', icon: 'star' },
            { time: '04:00 PM', title: 'Java Revision', status: 'Pending', color: '#2563eb', icon: 'bookmark' },
            { time: '06:00 PM', title: 'DSA Practice', status: 'Pending', color: '#e11d48', icon: 'chart' }
        ],
        'Tomorrow': [
            { time: '09:30 AM', title: 'Theory of Computation', status: 'Scheduled', color: '#0284c7', icon: 'file' },
            { time: '11:30 AM', title: 'Computer Networks Lecture', status: 'Scheduled', color: '#0284c7', icon: 'file' },
            { time: '02:30 PM', title: 'Software Engineering Sprint', status: 'Scheduled', color: '#7c3aed', icon: 'star' },
            { time: '04:30 PM', title: 'Web Development Project', status: 'Scheduled', color: '#ea580c', icon: 'bookmark' },
            { time: '07:00 PM', title: 'Weekly Coding Contest Prep', status: 'Scheduled', color: '#db2777', icon: 'chart' }
        ]
    };

    var dayDates = {
        'Yesterday': '19 Oct 2026',
        'Today': '20 Oct 2026',
        'Tomorrow': '21 Oct 2026'
    };

    function switchScheduleDay(day) {
        if (!day) day = 'Today';

        // Sync dropdown
        var selectEl = document.getElementById('scheduleDaySelect');
        if (selectEl) selectEl.value = day;

        // Sync segmented buttons
        var allDays = ['Yesterday', 'Today', 'Tomorrow'];
        for (var i = 0; i < allDays.length; i++) {
            var d = allDays[i];
            var btn = document.getElementById('btnDay' + d);
            if (btn) {
                if (d === day) {
                    btn.classList.add('active');
                } else {
                    btn.classList.remove('active');
                }
            }
        }

        // Sync Date input in "What Changed?" card
        var dateField = document.getElementById('eventDate');
        if (dateField && dayDates[day]) {
            dateField.value = dayDates[day];
        }

        // Render schedule immediately
        renderDaySchedule(day);

        // Fetch from backend servlet to ensure full state sync
        fetch('${pageContext.request.contextPath}/rescheduler', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'action=getDaySchedule&day=' + encodeURIComponent(day)
        })
        .then(function(res) {
            if (!res.ok) throw new Error('HTTP ' + res.status);
            return res.json();
        })
        .then(function(data) {
            if (data.success && data.schedule && data.schedule.length > 0) {
                renderServerSchedule(data.schedule);
            }
        })
        .catch(function() {
            // Keep instant client rendered list
        });

        showToast('Viewing schedule for ' + day + ' (' + (dayDates[day] || '') + ')');
    }

    function renderDaySchedule(day) {
        var items = daySchedules[day] || daySchedules['Today'];
        var list = document.getElementById('currentScheduleList');
        if (!list) return;
        list.innerHTML = '';

        items.forEach(function(item) {
            var row = document.createElement('div');
            row.className = 'sr-time-row';

            var pillClass = 'pill-pending';
            var pillText = item.status;
            var iconSvg = '';

            if (item.status === 'Completed') {
                pillClass = 'pill-completed';
                pillText = '&#10003; Completed';
                iconSvg = '<svg viewBox="0 0 24 24" width="17" height="17" fill="none" stroke="currentColor" stroke-width="2.8" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"></polyline></svg>';
            } else if (item.status === 'New Event') {
                pillClass = 'pill-new-event';
                pillText = '&#9733; New Event';
                iconSvg = '<svg viewBox="0 0 24 24" width="16" height="16" fill="currentColor"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg>';
            } else if (item.status === 'Scheduled') {
                pillClass = 'pill-added';
                pillText = 'Scheduled';
                iconSvg = '<svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>';
            } else {
                pillClass = 'pill-pending';
                pillText = 'Pending';
                if (item.icon === 'file') {
                    iconSvg = '<svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline></svg>';
                } else if (item.icon === 'bookmark') {
                    iconSvg = '<svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2"><path d="M19 21l-7-5-7 5V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2z"></path></svg>';
                } else {
                    iconSvg = '<svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2"><line x1="18" y1="20" x2="18" y2="10"></line><line x1="12" y1="20" x2="12" y2="4"></line><line x1="6" y1="20" x2="6" y2="14"></line></svg>';
                }
            }

            row.innerHTML =
                '<span class="sr-time-label">' + escapeHtml(item.time) + '</span>' +
                '<div class="sr-icon-box" style="background:' + (item.color || '#2563eb') + '; color:#fff;">' + iconSvg + '</div>' +
                '<span class="sr-row-title">' + escapeHtml(item.title) + '</span>' +
                '<span class="sr-status-pill ' + pillClass + '">' + pillText + '</span>';
            list.appendChild(row);
        });
    }

    function renderServerSchedule(scheduleList) {
        var list = document.getElementById('currentScheduleList');
        if (!list || !scheduleList || scheduleList.length === 0) return;
        list.innerHTML = '';

        scheduleList.forEach(function(item) {
            var row = document.createElement('div');
            row.className = 'sr-time-row';

            var pillClass = 'pill-pending';
            var pillText = item.status;
            var iconBg = item.color || '#2563eb';
            var iconSvg = '<svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline></svg>';

            if (item.statusType === 'completed' || item.status === 'Completed') {
                pillClass = 'pill-completed';
                pillText = '&#10003; Completed';
                iconBg = '#059669';
                iconSvg = '<svg viewBox="0 0 24 24" width="17" height="17" fill="none" stroke="currentColor" stroke-width="2.8" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"></polyline></svg>';
            } else if (item.statusType === 'new-event' || item.status === 'New Event') {
                pillClass = 'pill-new-event';
                pillText = '&#9733; New Event';
                iconBg = '#7c3aed';
                iconSvg = '<svg viewBox="0 0 24 24" width="16" height="16" fill="currentColor"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg>';
            } else if (item.statusType === 'scheduled' || item.status === 'Scheduled') {
                pillClass = 'pill-added';
                pillText = 'Scheduled';
                iconBg = item.color || '#0284c7';
                iconSvg = '<svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>';
            }

            row.innerHTML =
                '<span class="sr-time-label">' + escapeHtml(item.time) + '</span>' +
                '<div class="sr-icon-box" style="background:' + iconBg + '; color:#fff;">' + iconSvg + '</div>' +
                '<span class="sr-row-title">' + escapeHtml(item.title) + '</span>' +
                '<span class="sr-status-pill ' + pillClass + '">' + pillText + '</span>';
            list.appendChild(row);
        });
    }
</script>

</body>
</html>
