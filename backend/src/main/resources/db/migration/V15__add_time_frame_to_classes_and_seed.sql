-- V15: Add time_frame to classes and requests, then seed mock classes
-- Rollback: ALTER TABLE classes DROP COLUMN time_frame;
--            ALTER TABLE class_requests DROP COLUMN time_frame;
--            DELETE FROM classes WHERE title LIKE 'Mock %';

-- 1. Alter Schema
ALTER TABLE classes 
ADD COLUMN IF NOT EXISTS time_frame VARCHAR(100);

ALTER TABLE class_requests 
ADD COLUMN IF NOT EXISTS time_frame VARCHAR(100);

-- 2. Seed Mock Class Data
DO $$
DECLARE
    v_admin_id UUID;
    v_parent_id UUID;
BEGIN
    -- Get or fallback Admin ID
    SELECT id INTO v_admin_id FROM users WHERE role = 'ADMIN' LIMIT 1;
    
    -- Get or fallback Parent ID
    SELECT id INTO v_parent_id FROM users WHERE role = 'PARENT' LIMIT 1;
    
    IF v_parent_id IS NULL THEN
        -- Create a dummy parent if none exists for seeding
        INSERT INTO users (id, phone, password_hash, full_name, role, is_active)
        VALUES (gen_random_uuid(), '0988888888', '$2a$12$dummyhash', 'Phụ Huynh Test', 'PARENT', TRUE)
        RETURNING id INTO v_parent_id;
    END IF;

    IF v_admin_id IS NULL THEN
        RAISE EXCEPTION 'Admin user not found. Run V10 seed first.';
    END IF;

    -- Insert ~20 Classes with varied data
    INSERT INTO classes (admin_id, parent_id, title, subject, grade, mode, address, schedule, sessions_per_week, parent_fee, tutor_fee, time_frame, status)
    VALUES
    (v_admin_id, v_parent_id, 'Tìm Gia Sư Dạy Toán Lớp 10 Bồi Dưỡng Học Sinh Giỏi', 'Toán', 'Lớp 10', 'ONLINE', NULL, '[{"dayOfWeek": "TUESDAY", "startTime": "19:00:00", "endTime": "21:00:00"}, {"dayOfWeek": "THURSDAY", "startTime": "19:00:00", "endTime": "21:00:00"}]', 2, 2000000, 2500000, 'Bắt đầu tuần tới', 'OPEN'),
    (v_admin_id, v_parent_id, 'Giao Tiếp Tiếng Anh Cơ Bản Luyện Speaking', 'Tiếng Anh', 'Sinh Viên', 'OFFLINE', 'Quận 1, TP. HCM', '[]', 3, 3500000, 4000000, 'Gấp', 'OPEN'),
    (v_admin_id, v_parent_id, 'Ôn Thi Đại Học Môn Vật Lý Khối A', 'Vật Lý', 'Lớp 12', 'ONLINE', NULL, '[]', 2, 2500000, 3000000, 'Trong tháng này', 'OPEN'),
    (v_admin_id, v_parent_id, 'Luyện thi IELTS Target 6.5', 'Tiếng Anh', 'Lớp 11', 'OFFLINE', 'Quận Cầu Giấy, Hà Nội', '[]', 2, 4000000, 4500000, 'Bắt đầu từ tháng 4', 'OPEN'),
    (v_admin_id, v_parent_id, 'Toán Lớp 9 Ôn Thi Vào 10 Chuyên', 'Toán', 'Lớp 9', 'ONLINE', NULL, '[]', 3, 2800000, 3200000, 'Cần ngay', 'OPEN'),
    (v_admin_id, v_parent_id, 'Ngữ Văn Lớp 12 - Luyện Đề Tốt Nghiệp', 'Ngữ Văn', 'Lớp 12', 'ONLINE', NULL, '[]', 2, 2000000, 2500000, 'Bắt đầu tuần tới', 'OPEN'),
    (v_admin_id, v_parent_id, 'Hóa Học Lớp 8 Cơ Bản - Lấy lại gốc', 'Hóa Học', 'Lớp 8', 'OFFLINE', 'Quận 3, TP. HCM', '[]', 2, 1800000, 2000000, 'Trong tuần này', 'OPEN'),
    (v_admin_id, v_parent_id, 'Toán Tiếng Anh Quốc Tế Cambridge', 'Toán', 'Lớp 5', 'ONLINE', NULL, '[]', 2, 3500000, 4000000, 'Thoải mái thời gian', 'OPEN'),
    (v_admin_id, v_parent_id, 'Sinh Học Lớp 11 Nâng Cao', 'Sinh Học', 'Lớp 11', 'ONLINE', NULL, '[]', 1, 1500000, 1800000, 'Tháng sau', 'OPEN'),
    (v_admin_id, v_parent_id, 'Tin Học Lập Trình Python Cơ Bản Cho Trẻ Em', 'Tin Học', 'Lớp 6', 'ONLINE', NULL, '[]', 2, 2200000, 2600000, 'Mùa hè năm nay', 'OPEN'),
    (v_admin_id, v_parent_id, 'Tiếng Nhật N4 Luyện Thi JLPT', 'Tiếng Nhật', 'Sinh Viên', 'OFFLINE', 'Quận Bình Thạnh, TP. HCM', '[]', 3, 3000000, 3500000, 'Đầu tuần tới', 'OPEN'),
    (v_admin_id, v_parent_id, 'Lịch Sử Lớp 12 Ôn Thi Khối C', 'Lịch Sử', 'Lớp 12', 'ONLINE', NULL, '[]', 2, 2000000, 2200000, 'Gấp', 'OPEN'),
    (v_admin_id, v_parent_id, 'Địa Lý 12 Ôn Thi Khối C', 'Địa Lý', 'Lớp 12', 'ONLINE', NULL, '[]', 2, 2000000, 2200000, 'Ngay lập tức', 'OPEN'),
    (v_admin_id, v_parent_id, 'Tiếng Hàn Sơ Cấp 1 Giao Tiếp', 'Tiếng Hàn', 'Đi Làm', 'ONLINE', NULL, '[]', 2, 2500000, 3000000, 'Học buổi tối', 'OPEN'),
    (v_admin_id, v_parent_id, 'Toán Tư Duy Soroban Lớp 1-3', 'Toán', 'Lớp 2', 'OFFLINE', 'Quận Hai Bà Trưng, Hà Nội', '[]', 1, 1200000, 1500000, 'Cuối tuần', 'OPEN'),
    (v_admin_id, v_parent_id, 'Rèn Chữ Đẹp Hành Trang Vào Lớp 1', 'Tiếng Việt', 'Mầm Non', 'OFFLINE', 'Quận 7, TP. HCM', '[]', 2, 1500000, 1800000, 'Bắt đầu ngay', 'OPEN'),
    (v_admin_id, v_parent_id, 'Tiếng Anh Mầm Non Giao Tiếp Với Người Nước Ngoài', 'Tiếng Anh', 'Mầm Non', 'ONLINE', NULL, '[]', 3, 4000000, 4500000, 'Tuần sau', 'OPEN'),
    (v_admin_id, v_parent_id, 'Dạy Đàn Guitar Đệm Hát Cơ Bản', 'Nghệ Thuật', 'Sinh Viên', 'OFFLINE', 'Quận Đống Đa, Hà Nội', '[]', 1, 1000000, 1200000, 'Tùy chọn', 'OPEN'),
    (v_admin_id, v_parent_id, 'Dạy Vẽ Mỹ Thuật Ôn Thi Khối V, H', 'Mỹ Thuật', 'Lớp 12', 'OFFLINE', 'Quận 10, TP. HCM', '[]', 2, 3000000, 3500000, 'Trong tháng 5', 'OPEN'),
    (v_admin_id, v_parent_id, 'Vật Lý 10 Cơ Bản Bám Sát SGK', 'Vật Lý', 'Lớp 10', 'ONLINE', NULL, '[]', 2, 1800000, 2100000, 'Tuần sau', 'OPEN')
    ;
END $$;
