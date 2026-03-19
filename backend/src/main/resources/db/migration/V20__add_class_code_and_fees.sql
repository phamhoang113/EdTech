-- V20: Add Class Code, Fee fields, and Requirements to classes table
-- Rollback: ALTER TABLE classes DROP COLUMN class_code, DROP COLUMN fee_percentage, DROP COLUMN student_fee, DROP COLUMN teacher_fee, DROP COLUMN tutor_level_requirement, DROP COLUMN gender_requirement;

-- Add new columns
ALTER TABLE classes
ADD COLUMN class_code VARCHAR(6) UNIQUE,
ADD COLUMN fee_percentage INT NOT NULL DEFAULT 30,           -- % phí trung tâm
ADD COLUMN student_fee NUMERIC(12,2),                        -- Học phí trả cho Sinh viên
ADD COLUMN teacher_fee NUMERIC(12,2),                        -- Học phí trả cho Giáo viên
ADD COLUMN tutor_level_requirement JSONB NOT NULL DEFAULT '["Sinh viên", "Giáo viên"]', -- Sinh viên, Giáo viên, etc
ADD COLUMN gender_requirement VARCHAR(50) NOT NULL DEFAULT 'Không yêu cầu';

-- Generate 6-digit class_code for existing records
WITH updated_classes AS (
    SELECT id, 
           lpad(floor(random() * 900000 + 100000)::int::text, 6, '0') as gen_code
    FROM classes
)
UPDATE classes SET class_code = updated_classes.gen_code
FROM updated_classes
WHERE classes.id = updated_classes.id;

-- Make class_code NOT NULL after backfilling
ALTER TABLE classes ALTER COLUMN class_code SET NOT NULL;

-- Backfill fees for existing data based on parent_fee
UPDATE classes
SET student_fee = parent_fee,
    teacher_fee = parent_fee + 200000; -- Arbitrary markup for existing mock records
