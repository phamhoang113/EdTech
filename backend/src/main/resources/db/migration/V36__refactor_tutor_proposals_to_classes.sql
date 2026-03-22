-- V36: Refactor proposed tutors storage
-- Thay vì lưu proposed_salary trong từng class_applications row,
-- lưu tổng hợp JSON trên bảng classes để PH có thể query 1 lần.
-- Format: {"<tutor-uuid>": <proposedSalary>, ...}
-- Rollback: ALTER TABLE classes DROP COLUMN tutor_proposals;
--           ALTER TABLE class_applications ADD COLUMN proposed_salary NUMERIC(12,2);

-- Xóa cột proposed_salary khỏi class_applications (vừa thêm ở V35)
ALTER TABLE class_applications DROP COLUMN IF EXISTS proposed_salary;

-- Thêm cột tutor_proposals JSONB vào classes (default rỗng {})
ALTER TABLE classes ADD COLUMN tutor_proposals JSONB NOT NULL DEFAULT '{}';
