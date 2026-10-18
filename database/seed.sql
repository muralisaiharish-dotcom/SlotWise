-- ============================================================
-- SlotWise Seed Data (DEMO DATA)
-- ============================================================
-- WARNING: This file contains demonstration records for testing
-- and evaluation purposes only. These are NOT real student records.
--
-- The password hash below corresponds to the password: demo123
-- Generated using jBCrypt.
-- ============================================================

USE slotwise_db;

-- ============================================================
-- Demo Student Account
-- Email:    demo@slotwise.com
-- Password: demo123
-- ============================================================
INSERT INTO students (full_name, email, password_hash, roll_number, department, year_of_study, task_reminders, timetable_updates, weekly_summary, theme_preference) VALUES
('Harish M', 'demo@slotwise.com', '$2a$10$ZUyuQeJk6SMPArsiK1duFej263dsvmTbYDfQrtViQfgw.zwom0Zje', '250701626', 'Computer Science and Engineering', 'CSE - 2nd Year', TRUE, TRUE, TRUE, 'dark');

-- ============================================================
-- Demo Timetable Entries (Monday to Friday schedule)
-- ============================================================
INSERT INTO timetable_entries (student_id, subject_name, room_number, day_of_week, start_time, end_time) VALUES
-- Monday
(1, 'Data Structures',      'CSE 201', 'Monday',    '09:00:00', '10:30:00'),
(1, 'Database Systems',     'CSE 103', 'Monday',    '11:00:00', '12:00:00'),
(1, 'Operating Systems',    'CSE 205', 'Monday',    '13:00:00', '14:00:00'),
-- Tuesday
(1, 'Computer Networks',    'CSE 301', 'Tuesday',   '09:30:00', '11:00:00'),
(1, 'Data Structures Lab',  'Lab 1',   'Tuesday',   '11:30:00', '13:00:00'),
(1, 'Discrete Mathematics', 'CSE 102', 'Tuesday',   '14:00:00', '15:00:00'),
-- Wednesday
(1, 'Data Structures',      'CSE 201', 'Wednesday', '09:00:00', '10:30:00'),
(1, 'Database Systems',     'CSE 103', 'Wednesday', '11:00:00', '12:00:00'),
(1, 'OOP with Java',        'CSE 204', 'Wednesday', '13:00:00', '14:30:00'),
-- Thursday
(1, 'Computer Networks',    'CSE 301', 'Thursday',  '09:30:00', '11:00:00'),
(1, 'Operating Systems',    'CSE 205', 'Thursday',  '11:30:00', '12:30:00'),
(1, 'OS Lab',               'Lab 2',   'Thursday',  '14:00:00', '16:00:00'),
-- Friday
(1, 'Discrete Mathematics', 'CSE 102', 'Friday',    '09:00:00', '10:00:00'),
(1, 'OOP with Java',        'CSE 204', 'Friday',    '10:30:00', '12:00:00'),
(1, 'Database Systems Lab', 'Lab 3',   'Friday',    '13:00:00', '15:00:00');

-- ============================================================
-- Demo Tasks
-- ============================================================
INSERT INTO tasks (student_id, title, description, task_type, priority, estimated_minutes, deadline, status) VALUES
(1, 'Complete DBMS Assignment',  'Solve normalization problems and ER diagram for Chapter 5',                     'ASSIGNMENT',  'HIGH',   90,  '2026-10-20', 'PENDING'),
(1, 'Revise Java Notes',         'Review inheritance, polymorphism, and abstraction chapters',                    'EXAM_PREP',   'MEDIUM', 60,  '2026-10-21', 'PENDING'),
(1, 'Prepare Lab Record',        'Write observations and code for DS Lab experiments 3 and 4',                    'LAB',         'LOW',    45,  '2026-10-25', 'PENDING'),
(1, 'OS Process Scheduling',     'Study and compare FCFS, SJF, Round Robin scheduling algorithms',               'EXAM_PREP',   'HIGH',   75,  '2026-10-19', 'PENDING'),
(1, 'CN Assignment - Subnetting','Solve subnetting and CIDR problems from textbook exercises',                    'ASSIGNMENT',  'MEDIUM', 60,  '2026-10-22', 'IN_PROGRESS'),
(1, 'Discrete Math Proofs',      'Practice mathematical induction and set theory proofs',                         'ASSIGNMENT',  'LOW',    50,  '2026-10-28', 'PENDING'),
(1, 'Java OOP Mini Project',     'Build a simple inventory management system demonstrating all OOP concepts',     'LAB',         'HIGH',   120, '2026-10-24', 'PENDING'),
(1, 'DS Linked List Implementation', 'Implement singly and doubly linked lists with all operations in C',         'LAB',         'MEDIUM', 90,  '2026-10-23', 'COMPLETED');
