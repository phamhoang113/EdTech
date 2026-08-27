-- V22: Tạo TutorProfile cho các TUTOR chưa có profile
-- Trước đây khi đăng ký role TUTOR, backend không tự tạo TutorProfileEntity
-- Fix: insert missing profiles cho TUTOR đã tồn tại

INSERT INTO tutor_profiles (id, user_id, created_at, updated_at)
SELECT gen_random_uuid(), u.id, NOW(), NOW()
FROM users u
WHERE u.role = 'TUTOR'
  AND u.is_deleted = FALSE
  AND u.id NOT IN (SELECT tp.user_id FROM tutor_profiles tp);
