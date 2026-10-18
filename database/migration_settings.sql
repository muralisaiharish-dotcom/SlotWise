-- ============================================================
-- SlotWise Migration: Settings, Profile & Preferences
-- ============================================================
USE slotwise_db;

-- Add new profile and preference columns to students table
ALTER TABLE students 
ADD COLUMN IF NOT EXISTS roll_number VARCHAR(50) DEFAULT '250701626',
ADD COLUMN IF NOT EXISTS department VARCHAR(150) DEFAULT 'Computer Science and Engineering',
ADD COLUMN IF NOT EXISTS year_of_study VARCHAR(50) DEFAULT '2nd Year',
ADD COLUMN IF NOT EXISTS task_reminders BOOLEAN DEFAULT TRUE,
ADD COLUMN IF NOT EXISTS timetable_updates BOOLEAN DEFAULT TRUE,
ADD COLUMN IF NOT EXISTS weekly_summary BOOLEAN DEFAULT TRUE,
ADD COLUMN IF NOT EXISTS theme_preference VARCHAR(20) DEFAULT 'dark',
ADD COLUMN IF NOT EXISTS avatar_url VARCHAR(255) DEFAULT NULL;

-- Update demo student default profile
UPDATE students SET 
    full_name = 'Harish M',
    roll_number = '250701626',
    department = 'Computer Science and Engineering',
    year_of_study = 'CSE - 2nd Year',
    task_reminders = TRUE,
    timetable_updates = TRUE,
    weekly_summary = TRUE,
    theme_preference = 'dark'
WHERE student_id = 1;
