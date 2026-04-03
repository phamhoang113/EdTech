-- V6__fix_mock_classes.sql
-- Xóa mock cũ (không có tutor_proposals) → tạo lại với đầy đủ level_fees + tutor_proposals

-- 1) Xóa mock classes cũ
DELETE FROM public.classes WHERE is_mock = true;

-- 2) Tạo lại mock classes
-- level_fees    = phí PH chịu trả theo bậc GS: [{level, fee}]
-- tutor_proposals = lương Admin set cho GS theo bậc: [{level, fee}]
-- parent_fee    = min(level_fees[].fee)  — tạm set = giá trung bình PH đề xuất
-- platform_fee  = 0 (chưa assign GS, tính khi PH chọn GS)

INSERT INTO public.classes (id, admin_id, parent_id, title, subject, grade, description, mode, address, parent_fee, status, sessions_per_week, session_duration_min, class_code, gender_requirement, is_mock, level_fees, tutor_proposals) VALUES
-- MCK001: IELTS 6.5 (Online) - 3 buổi/tuần
(gen_random_uuid(), 'a0000000-0000-0000-0000-000000000001', 'c0000000-0000-0000-0000-000000000001',
 'Cần gia sư luyện thi cấp tốc IELTS 6.5', 'IELTS', 'Người đi làm',
 'Học viên đã có nền tảng, cần mock test', 'ONLINE', 'Online',
 2800000, 'OPEN', 3, 90, 'MCK001', 'Không yêu cầu', true,
 '[{"level":"Sinh viên","fee":2800000},{"level":"Tốt nghiệp","fee":3000000},{"level":"Giáo viên","fee":3200000}]',
 '[{"level":"Sinh viên","fee":1800000},{"level":"Tốt nghiệp","fee":2200000},{"level":"Giáo viên","fee":2800000}]'),

-- MCK002: Toán 12 (Offline HCM) - 2 buổi/tuần
(gen_random_uuid(), 'a0000000-0000-0000-0000-000000000001', 'c0000000-0000-0000-0000-000000000001',
 'Tìm gia sư kèm Toán 12', 'Toán', 'Lớp 12',
 'HS mất gốc toán hình, cần cải thiện ngay', 'OFFLINE', 'Quận 10, Hồ Chí Minh',
 2000000, 'OPEN', 2, 120, 'MCK002', 'Không yêu cầu', true,
 '[{"level":"Sinh viên","fee":2000000},{"level":"Tốt nghiệp","fee":2200000},{"level":"Giáo viên","fee":2500000}]',
 '[{"level":"Sinh viên","fee":1400000},{"level":"Tốt nghiệp","fee":1750000},{"level":"Giáo viên","fee":2200000}]'),

-- MCK003: Tiếng Việt Lớp 1 (Offline HN) - 4 buổi/tuần
(gen_random_uuid(), 'a0000000-0000-0000-0000-000000000001', 'c0000000-0000-0000-0000-000000000001',
 'Dạy rèn chữ đẹp & Toán Tiếng Việt Lớp 1', 'Tiếng Việt', 'Lớp 1',
 'Bé mới vào lớp 1, cần người kiên nhẫn', 'OFFLINE', 'Cầu Giấy, Hà Nội',
 2200000, 'OPEN', 4, 60, 'MCK003', 'Nữ', true,
 '[{"level":"Sinh viên","fee":2200000},{"level":"Tốt nghiệp","fee":2500000},{"level":"Giáo viên","fee":2800000}]',
 '[{"level":"Sinh viên","fee":1500000},{"level":"Tốt nghiệp","fee":1960000},{"level":"Giáo viên","fee":2400000}]'),

-- MCK004: Ngữ Văn 9 (Online) - 2 buổi/tuần
(gen_random_uuid(), 'a0000000-0000-0000-0000-000000000001', 'c0000000-0000-0000-0000-000000000001',
 'Gia sư Ngữ Văn 9 luyện thi vào 10', 'Ngữ Văn', 'Lớp 9',
 'Cần rèn kỹ năng viết nghị luận xã hội', 'ONLINE', 'Online',
 1500000, 'OPEN', 2, 90, 'MCK004', 'Không yêu cầu', true,
 '[{"level":"Sinh viên","fee":1500000},{"level":"Tốt nghiệp","fee":1800000},{"level":"Giáo viên","fee":2000000}]',
 '[{"level":"Sinh viên","fee":1000000},{"level":"Tốt nghiệp","fee":1400000},{"level":"Giáo viên","fee":1800000}]'),

-- MCK005: Tiếng Anh giao tiếp (Offline HCM) - 3 buổi/tuần
(gen_random_uuid(), 'a0000000-0000-0000-0000-000000000001', 'c0000000-0000-0000-0000-000000000001',
 'Dạy giao tiếp Tiếng Anh từ con số 0', 'Tiếng Anh', 'Người đi làm',
 'Nhân viên văn phòng cần T.A giao tiếp', 'OFFLINE', 'Quận 3, Hồ Chí Minh',
 2800000, 'OPEN', 3, 90, 'MCK005', 'Không yêu cầu', true,
 '[{"level":"Sinh viên","fee":2800000},{"level":"Tốt nghiệp","fee":3000000},{"level":"Giáo viên","fee":3500000}]',
 '[{"level":"Sinh viên","fee":2000000},{"level":"Tốt nghiệp","fee":2450000},{"level":"Giáo viên","fee":3100000}]'),

-- MCK006: Sinh học 11 (Offline HN) - 2 buổi/tuần
(gen_random_uuid(), 'a0000000-0000-0000-0000-000000000001', 'c0000000-0000-0000-0000-000000000001',
 'Cần Sinh viên Y Dược kèm Sinh học cấp 3', 'Sinh học', 'Lớp 11',
 'Định hướng thi khối B, cần củng cố kiến thức', 'OFFLINE', 'Thanh Xuân, Hà Nội',
 1200000, 'OPEN', 2, 120, 'MCK006', 'Không yêu cầu', true,
 '[{"level":"Sinh viên","fee":1200000},{"level":"Tốt nghiệp","fee":1500000},{"level":"Giáo viên","fee":1800000}]',
 '[{"level":"Sinh viên","fee":900000},{"level":"Tốt nghiệp","fee":1260000},{"level":"Giáo viên","fee":1600000}]'),

-- MCK007: Tin học Scratch (Online) - 1 buổi/tuần
(gen_random_uuid(), 'a0000000-0000-0000-0000-000000000001', 'c0000000-0000-0000-0000-000000000001',
 'Dạy lập trình cơ bản Scratch cho trẻ', 'Tin Học', 'Lớp 5',
 'Dạy lập trình kéo thả tư duy', 'ONLINE', 'Online',
 1000000, 'OPEN', 1, 90, 'MCK007', 'Không yêu cầu', true,
 '[{"level":"Sinh viên","fee":1000000},{"level":"Tốt nghiệp","fee":1200000},{"level":"Giáo viên","fee":1500000}]',
 '[{"level":"Sinh viên","fee":750000},{"level":"Tốt nghiệp","fee":1050000},{"level":"Giáo viên","fee":1350000}]'),

-- MCK008: Lý-Hóa 8 (Offline Đà Nẵng) - 3 buổi/tuần
(gen_random_uuid(), 'a0000000-0000-0000-0000-000000000001', 'c0000000-0000-0000-0000-000000000001',
 'Kèm báo bài Toán Lý Hóa 8', 'Lý-Hóa', 'Lớp 8',
 'Kèm combo 3 môn KHTN, HS học trung bình', 'OFFLINE', 'Hải Châu, Đà Nẵng',
 2200000, 'OPEN', 3, 120, 'MCK008', 'Không yêu cầu', true,
 '[{"level":"Sinh viên","fee":2200000},{"level":"Tốt nghiệp","fee":2600000},{"level":"Giáo viên","fee":3000000}]',
 '[{"level":"Sinh viên","fee":1500000},{"level":"Tốt nghiệp","fee":2100000},{"level":"Giáo viên","fee":2700000}]'),

-- MCK009: Piano (Offline HCM) - 2 buổi/tuần — chỉ TN+GV
(gen_random_uuid(), 'a0000000-0000-0000-0000-000000000001', 'c0000000-0000-0000-0000-000000000001',
 'Gia sư đàn Piano căn bản tại nhà', 'Piano', 'Mầm non',
 'Bé 5 tuổi cần làm quen với Piano', 'OFFLINE', 'Quận 7, Hồ Chí Minh',
 3200000, 'OPEN', 2, 60, 'MCK009', 'Nữ', true,
 '[{"level":"Tốt nghiệp","fee":3200000},{"level":"Giáo viên","fee":4000000}]',
 '[{"level":"Tốt nghiệp","fee":2800000},{"level":"Giáo viên","fee":3600000}]'),

-- MCK010: Vật Lý 12 (Online) - 3 buổi/tuần
(gen_random_uuid(), 'a0000000-0000-0000-0000-000000000001', 'c0000000-0000-0000-0000-000000000001',
 'Cần giáo viên chuyên Lí kèm ôn ĐH', 'Vật Lý', 'Lớp 12',
 'Mục tiêu 8.5+ Đại học', 'ONLINE', 'Online',
 3500000, 'OPEN', 3, 120, 'MCK010', 'Không yêu cầu', true,
 '[{"level":"Sinh viên","fee":3500000},{"level":"Tốt nghiệp","fee":4000000},{"level":"Giáo viên","fee":5000000}]',
 '[{"level":"Sinh viên","fee":2500000},{"level":"Tốt nghiệp","fee":3500000},{"level":"Giáo viên","fee":4500000}]'),

-- MCK011: TOEIC (Offline Đà Nẵng) - 4 buổi/tuần
(gen_random_uuid(), 'a0000000-0000-0000-0000-000000000001', 'c0000000-0000-0000-0000-000000000001',
 'Tiếng Anh cấp tốc thi TOEIC 600+', 'Tiếng Anh', 'Sinh viên',
 'Đang nợ chuẩn đầu ra, cần thi lẹ', 'OFFLINE', 'Cẩm Lệ, Đà Nẵng',
 1600000, 'OPEN', 4, 90, 'MCK011', 'Không yêu cầu', true,
 '[{"level":"Sinh viên","fee":1600000},{"level":"Tốt nghiệp","fee":1800000},{"level":"Giáo viên","fee":2200000}]',
 '[{"level":"Sinh viên","fee":1100000},{"level":"Tốt nghiệp","fee":1540000},{"level":"Giáo viên","fee":1980000}]'),

-- MCK012: Tiếng Nhật (Online) - 2 buổi/tuần
(gen_random_uuid(), 'a0000000-0000-0000-0000-000000000001', 'c0000000-0000-0000-0000-000000000001',
 'Cần gia sư tiếng Nhật N4', 'Ngoại ngữ', 'Người đi làm',
 'Đã học xong N5, muốn luyện hội thoại', 'ONLINE', 'Online',
 2400000, 'OPEN', 2, 90, 'MCK012', 'Không yêu cầu', true,
 '[{"level":"Sinh viên","fee":2400000},{"level":"Tốt nghiệp","fee":2800000},{"level":"Giáo viên","fee":3500000}]',
 '[{"level":"Sinh viên","fee":1750000},{"level":"Tốt nghiệp","fee":2450000},{"level":"Giáo viên","fee":3150000}]'),

-- MCK013: Tiếng Việt mầm non (Offline HCM) - 5 buổi/tuần
(gen_random_uuid(), 'a0000000-0000-0000-0000-000000000001', 'c0000000-0000-0000-0000-000000000001',
 'Kèm đánh vần Tiếng Việt lớp mầm non', 'Tiếng Việt', 'Mầm non',
 'Cho bé chuẩn bị vào lớp 1', 'OFFLINE', 'Bình Thạnh, Hồ Chí Minh',
 1000000, 'OPEN', 5, 45, 'MCK013', 'Nữ', true,
 '[{"level":"Sinh viên","fee":1000000},{"level":"Tốt nghiệp","fee":1200000},{"level":"Giáo viên","fee":1500000}]',
 '[{"level":"Sinh viên","fee":750000},{"level":"Tốt nghiệp","fee":1050000},{"level":"Giáo viên","fee":1350000}]'),

-- MCK014: Mỹ Thuật (Offline HN) - 1 buổi/tuần — chỉ TN+GV
(gen_random_uuid(), 'a0000000-0000-0000-0000-000000000001', 'c0000000-0000-0000-0000-000000000001',
 'Gia sư Mỹ Thuật / Vẽ tranh màu nước', 'Khác', 'Khác',
 'Dạy vẽ cơ bản cho người lớn', 'OFFLINE', 'Hoàn Kiếm, Hà Nội',
 1800000, 'OPEN', 1, 120, 'MCK014', 'Không yêu cầu', true,
 '[{"level":"Tốt nghiệp","fee":1800000},{"level":"Giáo viên","fee":2000000}]',
 '[{"level":"Tốt nghiệp","fee":1400000},{"level":"Giáo viên","fee":1800000}]'),

-- MCK015: Toán 6 (Offline HCM) - 3 buổi/tuần
(gen_random_uuid(), 'a0000000-0000-0000-0000-000000000001', 'c0000000-0000-0000-0000-000000000001',
 'Kèm Toán lớp 6, học trò bướng bỉnh', 'Toán', 'Lớp 6',
 'Cần SV thật nghiêm khắc', 'OFFLINE', 'Quận 1, Hồ Chí Minh',
 1800000, 'OPEN', 3, 90, 'MCK015', 'Nam', true,
 '[{"level":"Sinh viên","fee":1800000},{"level":"Tốt nghiệp","fee":2200000},{"level":"Giáo viên","fee":2600000}]',
 '[{"level":"Sinh viên","fee":1300000},{"level":"Tốt nghiệp","fee":1820000},{"level":"Giáo viên","fee":2340000}]'),

-- MCK016: Toán Hóa 10 (Online) - 2 buổi/tuần
(gen_random_uuid(), 'a0000000-0000-0000-0000-000000000001', 'c0000000-0000-0000-0000-000000000001',
 'Dạy Toán Hóa khối B lớp 10', 'Toán', 'Lớp 10',
 'Giúp lấy gốc mất gốc tự tin', 'ONLINE', 'Online',
 1300000, 'OPEN', 2, 120, 'MCK016', 'Không yêu cầu', true,
 '[{"level":"Sinh viên","fee":1300000},{"level":"Tốt nghiệp","fee":1600000},{"level":"Giáo viên","fee":1900000}]',
 '[{"level":"Sinh viên","fee":950000},{"level":"Tốt nghiệp","fee":1330000},{"level":"Giáo viên","fee":1710000}]'),

-- MCK017: Toán nâng cao HSG (Offline Đà Nẵng) - 2 buổi/tuần — chỉ TN+GV
(gen_random_uuid(), 'a0000000-0000-0000-0000-000000000001', 'c0000000-0000-0000-0000-000000000001',
 'Toán nâng cao HSG cấp huyện', 'Toán', 'Lớp 9',
 'HS chăm chỉ, cần giáo viên hướng dẫn đề khó', 'OFFLINE', 'Sơn Trà, Đà Nẵng',
 3800000, 'OPEN', 2, 120, 'MCK017', 'Không yêu cầu', true,
 '[{"level":"Tốt nghiệp","fee":3800000},{"level":"Giáo viên","fee":4500000}]',
 '[{"level":"Tốt nghiệp","fee":3150000},{"level":"Giáo viên","fee":4050000}]'),

-- MCK018: C++ Đại học (Online) - 1 buổi/tuần — chỉ TN+GV
(gen_random_uuid(), 'a0000000-0000-0000-0000-000000000001', 'c0000000-0000-0000-0000-000000000001',
 'Giảng viên dạy lập trình C++ cho SV năm 1', 'Tin Học', 'Đại học',
 'Cần người hiểu sâu giải thuật', 'ONLINE', 'Online',
 4000000, 'OPEN', 1, 150, 'MCK018', 'Không yêu cầu', true,
 '[{"level":"Tốt nghiệp","fee":4000000},{"level":"Giáo viên","fee":5000000}]',
 '[{"level":"Tốt nghiệp","fee":3500000},{"level":"Giáo viên","fee":4500000}]'),

-- MCK019: Sử Địa 12 (Offline HCM) - 3 buổi/tuần
(gen_random_uuid(), 'a0000000-0000-0000-0000-000000000001', 'c0000000-0000-0000-0000-000000000001',
 'Kèm Sử Địa lớp 12 luyện thi QG', 'Sử-Địa', 'Lớp 12',
 'Khoanh vùng kiến thức trọng tâm', 'OFFLINE', 'Thủ Đức, Hồ Chí Minh',
 1600000, 'OPEN', 3, 90, 'MCK019', 'Không yêu cầu', true,
 '[{"level":"Sinh viên","fee":1600000},{"level":"Tốt nghiệp","fee":1900000},{"level":"Giáo viên","fee":2300000}]',
 '[{"level":"Sinh viên","fee":1150000},{"level":"Tốt nghiệp","fee":1610000},{"level":"Giáo viên","fee":2070000}]'),

-- MCK020: Tiếng Anh lớp 3 (Offline HN) - 3 buổi/tuần
(gen_random_uuid(), 'a0000000-0000-0000-0000-000000000001', 'c0000000-0000-0000-0000-000000000001',
 'Anh văn cơ bản hè cho bé lên lớp 3', 'Tiếng Anh', 'Lớp 3',
 'Tạo hứng thú, chơi trò chơi', 'OFFLINE', 'Tây Hồ, Hà Nội',
 1100000, 'OPEN', 3, 90, 'MCK020', 'Không yêu cầu', true,
 '[{"level":"Sinh viên","fee":1100000},{"level":"Tốt nghiệp","fee":1300000},{"level":"Giáo viên","fee":1600000}]',
 '[{"level":"Sinh viên","fee":800000},{"level":"Tốt nghiệp","fee":1120000},{"level":"Giáo viên","fee":1440000}]');
