-- V2__mock_data.sql
-- Password hashes:
--   Ho@ngV@n  → $2a$10$P6cV1yLDvMxZL6hO0A5y0O9Z6oV8W4Vx7ba5Ewoic6.L1Rp8RCaYS
--   123456    → $2a$10$oOCWiEN1yGDwn8/4GjEMo.BkD/bf.uRO0GXDdi2gi90KWB5aZcRZ.

-- ══════════════════════════════════════════════════════════════════
-- 1. ADMIN: ad_edtech / Ho@ngV@n
-- ══════════════════════════════════════════════════════════════════
INSERT INTO public.users (id, username, password_hash, full_name, role, is_active, is_mock, is_deleted, created_at, updated_at)
VALUES ('a0000000-0000-0000-0000-000000000001', 'ad_edtech',
        '$2a$10$P6cV1yLDvMxZL6hO0A5y0O9Z6oV8W4Vx7ba5Ewoic6.L1Rp8RCaYS',
        'Admin Hoàng', 'ADMIN', true, false, false, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- ══════════════════════════════════════════════════════════════════
-- 2. PARENT: mock_parent / 123456
-- ══════════════════════════════════════════════════════════════════
INSERT INTO public.users (id, username, password_hash, full_name, role, is_active, is_mock, is_deleted, created_at, updated_at)
VALUES ('c0000000-0000-0000-0000-000000000001', 'mock_parent',
        '$2a$10$oOCWiEN1yGDwn8/4GjEMo.BkD/bf.uRO0GXDdi2gi90KWB5aZcRZ.',
        'Nguyễn Văn Phụ Huynh', 'PARENT', true, true, false, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- ══════════════════════════════════════════════════════════════════
-- 3. TUTORS (4 GS) — tất cả pass: 123456
-- ══════════════════════════════════════════════════════════════════
INSERT INTO public.users (id, username, password_hash, full_name, role, is_active, is_mock, is_deleted, created_at, updated_at) VALUES
('11000000-0000-0000-0000-000000000001', 'tutor_mock_1', '$2a$10$oOCWiEN1yGDwn8/4GjEMo.BkD/bf.uRO0GXDdi2gi90KWB5aZcRZ.', 'Nguyễn Tuấn Vũ',   'TUTOR', true, true, false, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('11000000-0000-0000-0000-000000000002', 'tutor_mock_2', '$2a$10$oOCWiEN1yGDwn8/4GjEMo.BkD/bf.uRO0GXDdi2gi90KWB5aZcRZ.', 'Phạm Thu Hà',      'TUTOR', true, true, false, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('11000000-0000-0000-0000-000000000003', 'tutor_mock_3', '$2a$10$oOCWiEN1yGDwn8/4GjEMo.BkD/bf.uRO0GXDdi2gi90KWB5aZcRZ.', 'Trần Hoàng Long',  'TUTOR', true, true, false, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('11000000-0000-0000-0000-000000000004', 'tutor_mock_4', '$2a$10$oOCWiEN1yGDwn8/4GjEMo.BkD/bf.uRO0GXDdi2gi90KWB5aZcRZ.', 'Ngô Quỳnh Trang',  'TUTOR', true, true, false, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- ══════════════════════════════════════════════════════════════════
-- 4. TUTOR PROFILES
-- ══════════════════════════════════════════════════════════════════
INSERT INTO public.tutor_profiles (id, user_id, bio, subjects, location, teaching_mode, hourly_rate, rating, rating_count, verification_status, tutor_type, is_mock, experience_years) VALUES
(gen_random_uuid(), '11000000-0000-0000-0000-000000000001', 'Cử nhân Sư phạm Toán xuất sắc, 5 năm kinh nghiệm.',             ARRAY['Toán', 'Vật Lý'],              'Cầu Giấy, Hà Nội',      ARRAY['OFFLINE','ONLINE'], 200000, 4.9, 120, 'APPROVED', 'TEACHER',   true, 5),
(gen_random_uuid(), '11000000-0000-0000-0000-000000000002', 'Sinh viên năm 3 Bách Khoa, giỏi Khoa học.',                      ARRAY['Toán', 'Hóa Học', 'Vật Lý'],   'Hai Bà Trưng, Hà Nội',  ARRAY['OFFLINE'],          100000, 4.7,  45, 'APPROVED', 'STUDENT',   true, 2),
(gen_random_uuid(), '11000000-0000-0000-0000-000000000003', 'Giáo viên Tiếng Anh IELTS 8.0, 10 năm kinh nghiệm.',            ARRAY['Tiếng Anh'],                    'Quận 1, Hồ Chí Minh',   ARRAY['ONLINE'],           300000, 5.0, 310, 'APPROVED', 'TEACHER',   true, 10),
(gen_random_uuid(), '11000000-0000-0000-0000-000000000004', 'Dạy rèn chữ đẹp, Ngữ Văn cơ bản cấp 1-2.',                      ARRAY['Ngữ Văn', 'Tiếng Việt'],        'Hà Đông, Hà Nội',       ARRAY['OFFLINE'],          150000, 4.8,  89, 'APPROVED', 'GRADUATED', true, 3);

-- ══════════════════════════════════════════════════════════════════
-- 5. CLASSES (10 lớp) — admin_id & parent_id mapping chính xác
-- ══════════════════════════════════════════════════════════════════
INSERT INTO public.classes (id, admin_id, parent_id, title, subject, grade, description, mode, address, parent_fee, status, sessions_per_week, session_duration_min, class_code, gender_requirement, is_mock) VALUES
(gen_random_uuid(), 'a0000000-0000-0000-0000-000000000001', 'c0000000-0000-0000-0000-000000000001',
 'Cần gia sư luyện thi cấp tốc IELTS 6.5', 'IELTS',        'Người đi làm', 'Học viên đã có nền tảng, cần mock test',          'ONLINE',  'Online',                    3200000, 'OPEN', 3, 90,  'MCK001', 'Không yêu cầu', true),

(gen_random_uuid(), 'a0000000-0000-0000-0000-000000000001', 'c0000000-0000-0000-0000-000000000001',
 'Tìm sinh viên Bách Khoa kèm Toán 12',    'Toán',          'Lớp 12',       'HS mất gốc toán hình, cần cải thiện ngay',       'OFFLINE', 'Quận 10, Hồ Chí Minh',      2500000, 'OPEN', 2, 120, 'MCK002', 'Không yêu cầu', true),

(gen_random_uuid(), 'a0000000-0000-0000-0000-000000000001', 'c0000000-0000-0000-0000-000000000001',
 'Dạy rèn chữ đẹp & Toán Tiếng Việt Lớp 1','Tiếng Việt',   'Lớp 1',        'Bé mới vào lớp 1, cần người kiên nhẫn',          'OFFLINE', 'Cầu Giấy, Hà Nội',         2800000, 'OPEN', 4, 60,  'MCK003', 'Nữ',             true),

(gen_random_uuid(), 'a0000000-0000-0000-0000-000000000001', 'c0000000-0000-0000-0000-000000000001',
 'Gia sư Ngữ Văn 9 luyện thi vào 10',      'Ngữ Văn',       'Lớp 9',        'Cần rèn kỹ năng viết nghị luận xã hội',          'ONLINE',  'Online',                    2000000, 'OPEN', 2, 90,  'MCK004', 'Không yêu cầu', true),

(gen_random_uuid(), 'a0000000-0000-0000-0000-000000000001', 'c0000000-0000-0000-0000-000000000001',
 'Dạy giao tiếp Tiếng Anh từ con số 0',    'Tiếng Anh',     'Người đi làm', 'Nhân viên văn phòng cần T.A giao tiếp',          'OFFLINE', 'Quận 3, Hồ Chí Minh',      3500000, 'OPEN', 3, 90,  'MCK005', 'Không yêu cầu', true),

(gen_random_uuid(), 'a0000000-0000-0000-0000-000000000001', 'c0000000-0000-0000-0000-000000000001',
 'Cần SV Y Dược kèm Sinh học cấp 3',       'Sinh Học',      'Lớp 11',       'Định hướng thi khối B, cần củng cố kiến thức',   'OFFLINE', 'Thanh Xuân, Hà Nội',       1800000, 'OPEN', 2, 120, 'MCK006', 'Không yêu cầu', true),

(gen_random_uuid(), 'a0000000-0000-0000-0000-000000000001', 'c0000000-0000-0000-0000-000000000001',
 'Dạy lập trình cơ bản Scratch cho trẻ',   'Tin Học',       'Lớp 5',        'Dạy lập trình kéo thả tư duy',                   'ONLINE',  'Online',                    1500000, 'OPEN', 1, 90,  'MCK007', 'Không yêu cầu', true),

(gen_random_uuid(), 'a0000000-0000-0000-0000-000000000001', 'c0000000-0000-0000-0000-000000000001',
 'Kèm báo bài Toán Lý Hóa 8',             'Khác',          'Lớp 8',        'Kèm combo 3 môn KHTN, HS học trung bình',        'OFFLINE', 'Hải Châu, Đà Nẵng',        3000000, 'OPEN', 3, 120, 'MCK008', 'Không yêu cầu', true),

(gen_random_uuid(), 'a0000000-0000-0000-0000-000000000001', 'c0000000-0000-0000-0000-000000000001',
 'Cần giáo viên chuyên Lí kèm ôn ĐH',     'Vật Lý',        'Lớp 12',       'Mục tiêu 8.5+ Đại học',                           'ONLINE',  'Online',                    5000000, 'OPEN', 3, 120, 'MCK009', 'Không yêu cầu', true),

(gen_random_uuid(), 'a0000000-0000-0000-0000-000000000001', 'c0000000-0000-0000-0000-000000000001',
 'Kèm Toán lớp 6, học trò bướng bỉnh',    'Toán',          'Lớp 6',        'Cần SV thật nghiêm khắc',                         'OFFLINE', 'Quận 1, Hồ Chí Minh',      2600000, 'OPEN', 3, 90,  'MCK010', 'Nam',            true);
