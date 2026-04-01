-- Cập nhật rating hệ thống mặc định: Mọi Gia sư đăng ký đều có 1 đánh giá 5 sao.

ALTER TABLE tutor_profiles ALTER COLUMN rating SET DEFAULT 5.00;
ALTER TABLE tutor_profiles ALTER COLUMN rating_count SET DEFAULT 1;

-- Cập nhật những gia sư cũ đang có 0 đánh giá thành 5 sao mặc định
UPDATE tutor_profiles 
SET rating = 5.00, rating_count = 1 
WHERE rating = 0 OR rating IS NULL;
