-- Remove the temporary student/teacher fee columns added in V20 since the logic changed
ALTER TABLE classes DROP COLUMN IF EXISTS student_fee;
ALTER TABLE classes DROP COLUMN IF EXISTS teacher_fee;

-- Enforce the business logic: tutor_fee = parent_fee - platform_fee directly in the DB
ALTER TABLE classes DROP COLUMN tutor_fee;
ALTER TABLE classes ADD COLUMN tutor_fee NUMERIC(12,2) GENERATED ALWAYS AS (parent_fee - platform_fee) STORED;
