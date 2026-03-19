-- V12: Add tutor_type to tutor_profiles
-- Rollback: ALTER TABLE tutor_profiles DROP COLUMN IF EXISTS tutor_type CASCADE;

ALTER TABLE tutor_profiles
ADD COLUMN IF NOT EXISTS tutor_type VARCHAR(50);
