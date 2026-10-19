-- ============================================================
-- SlotWise Progress Page Migration
-- Adds study_sessions and academic_goals tables
-- Run AFTER schema.sql has been executed
-- ============================================================

USE slotwise_db;

-- ============================================================
-- Table: study_sessions
-- Records each study session logged by a student.
-- Used to compute: study hours per day, weekly totals.
-- ============================================================
CREATE TABLE IF NOT EXISTS study_sessions (
    session_id      INT AUTO_INCREMENT PRIMARY KEY,
    student_id      INT           NOT NULL,
    subject_name    VARCHAR(100)  NOT NULL,
    session_date    DATE          NOT NULL,
    duration_minutes INT          NOT NULL CHECK (duration_minutes > 0),
    notes           VARCHAR(500)  DEFAULT NULL,
    created_at      TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_session_student
        FOREIGN KEY (student_id) REFERENCES students(student_id)
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- Table: academic_goals
-- Stores academic and personal goals set by students.
-- Used to compute: goals achieved, goal progress %.
-- ============================================================
CREATE TABLE IF NOT EXISTS academic_goals (
    goal_id         INT AUTO_INCREMENT PRIMARY KEY,
    student_id      INT           NOT NULL,
    title           VARCHAR(200)  NOT NULL,
    description     TEXT          DEFAULT NULL,
    goal_type       ENUM('STUDY_HOURS','TASK_COMPLETION','SUBJECT_MASTERY','STREAK','CUSTOM') NOT NULL DEFAULT 'CUSTOM',
    target_value    INT           NOT NULL DEFAULT 100    COMMENT 'e.g. hours, tasks, days, percent',
    current_value   INT           NOT NULL DEFAULT 0     COMMENT 'progress so far',
    deadline        DATE          DEFAULT NULL,
    status          ENUM('IN_PROGRESS','COMPLETED','AT_RISK','ON_TRACK') NOT NULL DEFAULT 'IN_PROGRESS',
    created_at      TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_goal_student
        FOREIGN KEY (student_id) REFERENCES students(student_id)
        ON DELETE CASCADE,

    CONSTRAINT chk_goal_values CHECK (current_value >= 0 AND target_value > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- Indexes for performance
-- ============================================================
CREATE INDEX IF NOT EXISTS idx_sessions_student_date ON study_sessions(student_id, session_date);
CREATE INDEX IF NOT EXISTS idx_goals_student_status   ON academic_goals(student_id, status);

-- ============================================================
-- Demo study session data (for student_id = 1)
-- Covers the last 7 days from 2026-10-19 (this week)
-- ============================================================
INSERT INTO study_sessions (student_id, subject_name, session_date, duration_minutes, notes) VALUES
(1, 'Data Structures',    '2026-10-13', 270, 'Revised trees, graphs, and sorting algorithms'),
(1, 'Database Systems',   '2026-10-13', 60,  'ER diagrams and normalization'),
(1, 'Operating Systems',  '2026-10-14', 180, 'Process scheduling — FCFS, SJF, Round Robin'),
(1, 'Computer Networks',  '2026-10-15', 150, 'Subnetting and CIDR practice'),
(1, 'Data Structures',    '2026-10-15', 150, 'Linked list and stack implementation'),
(1, 'Database Systems',   '2026-10-16', 120, 'SQL joins and subqueries'),
(1, 'Software Engineering','2026-10-16', 90, 'SDLC models — Agile and Waterfall'),
(1, 'Mathematics',        '2026-10-17', 240, 'Set theory proofs and mathematical induction'),
(1, 'Computer Networks',  '2026-10-17', 60,  'OSI model layers review'),
(1, 'Operating Systems',  '2026-10-18', 60,  'Memory management and paging'),
(1, 'Data Structures',    '2026-10-18', 150, 'Graph BFS and DFS algorithms'),
(1, 'Database Systems',   '2026-10-19', 90,  'Transactions and ACID properties'),
(1, 'Software Engineering','2026-10-19', 120, 'Design patterns overview');

-- ============================================================
-- Demo academic goals (for student_id = 1)
-- ============================================================
INSERT INTO academic_goals (student_id, title, description, goal_type, target_value, current_value, deadline, status) VALUES
(1, 'Complete DBMS Assignment',         'Finish ER diagrams, normalization, and SQL queries for Chapter 5', 'TASK_COMPLETION',  100, 70, '2026-10-22', 'IN_PROGRESS'),
(1, 'Maintain 20 study hours this week','Log at least 20 hours of study sessions this week',               'STUDY_HOURS',      20,  18, '2026-10-20', 'ON_TRACK'),
(1, 'Complete all pending lab records', 'Write observations and code for DS Lab experiments 3 and 4',      'TASK_COMPLETION',  100, 67, '2026-10-25', 'IN_PROGRESS'),
(1, 'Revise Java & DSA',                'Complete revision of OOP and Data Structures before exams',       'SUBJECT_MASTERY',  100, 40, '2026-10-30', 'AT_RISK');
