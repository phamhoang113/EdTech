-- V55: Add initiated_by to student_profiles to track who requested the link
-- Options: PARENT or STUDENT

-- 1. Support multiple parents per student
ALTER TABLE student_profiles DROP CONSTRAINT IF EXISTS student_profiles_user_id_key;

-- 2. Track who initiated the link
ALTER TABLE student_profiles ADD COLUMN initiated_by VARCHAR(20) NOT NULL DEFAULT 'PARENT';

-- Set existing records to PARENT since that was the only way initially
UPDATE student_profiles SET initiated_by = 'PARENT' WHERE initiated_by IS NULL;
