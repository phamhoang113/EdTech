-- V38: Thêm PENDING_APPROVAL vào enum class_status và thêm rejected_reason field
ALTER TYPE class_status ADD VALUE IF NOT EXISTS 'PENDING_APPROVAL' BEFORE 'OPEN';

-- Thêm cột ghi chú từ chối (admin dùng khi không duyệt yêu cầu mở lớp)
ALTER TABLE classes
    ADD COLUMN IF NOT EXISTS rejection_reason TEXT;
