-- ============================================================
-- SlotWise Database Schema
-- Smart Academic Free-Time Utilization and Task Planning System
-- ============================================================
-- This script creates the slotwise_db database and all required
-- tables with proper primary keys, foreign keys, and constraints.
-- ============================================================

-- Create and use the database
CREATE DATABASE IF NOT EXISTS slotwise_db
    DEFAULT CHARACTER SET utf8mb4
    DEFAULT COLLATE utf8mb4_unicode_ci;

USE slotwise_db;

-- ============================================================
-- Table: students
-- Stores registered student accounts.
-- ============================================================
CREATE TABLE IF NOT EXISTS students (
    student_id        INT AUTO_INCREMENT PRIMARY KEY,
    full_name         VARCHAR(100)  NOT NULL,
    email             VARCHAR(150)  NOT NULL UNIQUE,
    password_hash     VARCHAR(255)  NOT NULL,
    roll_number       VARCHAR(50)   DEFAULT '250701626',
    department        VARCHAR(150)  DEFAULT 'Computer Science and Engineering',
    year_of_study     VARCHAR(50)   DEFAULT 'CSE - 2nd Year',
    task_reminders    BOOLEAN       DEFAULT TRUE,
    timetable_updates BOOLEAN       DEFAULT TRUE,
    weekly_summary    BOOLEAN       DEFAULT TRUE,
    theme_preference  VARCHAR(20)   DEFAULT 'dark',
    avatar_url        VARCHAR(255)  DEFAULT NULL,
    created_at        TIMESTAMP     DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- Table: timetable_entries
-- Stores a student's weekly class schedule.
-- Each row represents one class on a particular day of the week.
-- Relationship: Many timetable_entries belong to one student.
-- ============================================================
CREATE TABLE IF NOT EXISTS timetable_entries (
    timetable_id  INT AUTO_INCREMENT PRIMARY KEY,
    student_id    INT           NOT NULL,
    subject_name  VARCHAR(100)  NOT NULL,
    room_number   VARCHAR(30)   NOT NULL,
    day_of_week   ENUM('Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday') NOT NULL,
    start_time    TIME          NOT NULL,
    end_time      TIME          NOT NULL,
    created_at    TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,

    -- Foreign key: each entry belongs to a student
    CONSTRAINT fk_timetable_student
        FOREIGN KEY (student_id) REFERENCES students(student_id)
        ON DELETE CASCADE,

    -- Ensure end_time is after start_time
    CONSTRAINT chk_time_range CHECK (end_time > start_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- Table: tasks
-- Stores academic tasks (assignments, exam prep, lab work, etc.)
-- created by students.
-- Relationship: Many tasks belong to one student.
-- ============================================================
CREATE TABLE IF NOT EXISTS tasks (
    task_id           INT AUTO_INCREMENT PRIMARY KEY,
    student_id        INT           NOT NULL,
    title             VARCHAR(150)  NOT NULL,
    description       TEXT,
    task_type         ENUM('ASSIGNMENT','EXAM_PREP','LAB','OTHER') NOT NULL DEFAULT 'OTHER',
    priority          ENUM('HIGH','MEDIUM','LOW') NOT NULL DEFAULT 'MEDIUM',
    estimated_minutes INT           NOT NULL DEFAULT 30,
    deadline          DATE,
    status            ENUM('PENDING','IN_PROGRESS','COMPLETED') NOT NULL DEFAULT 'PENDING',
    created_at        TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,

    -- Foreign key: each task belongs to a student
    CONSTRAINT fk_task_student
        FOREIGN KEY (student_id) REFERENCES students(student_id)
        ON DELETE CASCADE,

    -- Ensure estimated_minutes is positive
    CONSTRAINT chk_estimated_minutes CHECK (estimated_minutes > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- Table: recommendations
-- Stores planner-generated recommendations mapping pending tasks
-- to available free-time slots.
-- Relationship: Each recommendation links a student, a task,
--               and a computed free-time window.
-- ============================================================
CREATE TABLE IF NOT EXISTS recommendations (
    recommendation_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id        INT           NOT NULL,
    task_id           INT           NOT NULL,
    available_start   TIME          NOT NULL,
    available_end     TIME          NOT NULL,
    recommended_minutes INT         NOT NULL,
    reason            VARCHAR(500),
    created_at        TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,

    -- Foreign keys
    CONSTRAINT fk_recommendation_student
        FOREIGN KEY (student_id) REFERENCES students(student_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_recommendation_task
        FOREIGN KEY (task_id) REFERENCES tasks(task_id)
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- Indexes for faster queries
-- ============================================================
CREATE INDEX idx_timetable_student_day ON timetable_entries(student_id, day_of_week);
CREATE INDEX idx_tasks_student_status  ON tasks(student_id, status);
CREATE INDEX idx_recommendations_student ON recommendations(student_id);
