-- Thêm trạng thái AUTO_CLOSED vào enum class_status
-- Lớp OPEN quá 1 tháng không có GS nhận sẽ tự động chuyển sang AUTO_CLOSED
ALTER TYPE class_status ADD VALUE IF NOT EXISTS 'AUTO_CLOSED';
