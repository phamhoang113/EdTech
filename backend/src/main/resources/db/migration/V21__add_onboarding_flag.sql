-- V21: Thêm cờ onboarding cho user mới đăng ký
ALTER TABLE users ADD COLUMN has_completed_onboarding BOOLEAN NOT NULL DEFAULT FALSE;

-- User hiện tại (đã sử dụng) → đánh dấu đã onboarding
UPDATE users SET has_completed_onboarding = TRUE WHERE is_deleted = FALSE;
