-- V35: Add proposed_salary to class_applications
-- Admin đề xuất mức lương GS sẽ nhận khi PH chọn.
-- Rollback: ALTER TABLE class_applications DROP COLUMN proposed_salary;

ALTER TABLE class_applications
    ADD COLUMN proposed_salary NUMERIC(12, 2);
