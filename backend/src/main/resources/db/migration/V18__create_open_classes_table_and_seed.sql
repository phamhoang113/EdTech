-- V18: Create Open Classes table and seed mock data

CREATE TABLE IF NOT EXISTS open_classes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title VARCHAR(255) NOT NULL,
    subject VARCHAR(100) NOT NULL,
    grade VARCHAR(50) NOT NULL,
    location VARCHAR(255) NOT NULL,
    schedule VARCHAR(255) NOT NULL,
    fee DECIMAL(19, 2) NOT NULL,
    time_frame VARCHAR(100) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Seed Initial Mock Data
INSERT INTO open_classes (title, subject, grade, location, schedule, fee, time_frame) VALUES
('Tìm Gia Sư Dạy Toán Lớp 10 Bồi Dưỡng Học Sinh Giỏi', 'Toán', 'Lớp 10', 'Quận Cầu Giấy, Hà Nội (Học online)', '2 buổi / tuần (Tối T3, T5)', 2000000, 'Bắt đầu tuần tới'),
('Giao Tiếp Tiếng Anh Cơ Bản Luyện Speaking', 'Tiếng Anh', 'Sinh Viên', 'Quận 1, TP. HCM (Tại nhà)', '3 buổi / tuần (Linh hoạt)', 3500000, 'Gấp'),
('Ôn Thi Đại Học Môn Vật Lý Khối A', 'Vật Lý', 'Lớp 12', 'Học Trực Tuyến', '2 buổi / tuần', 2500000, 'Trong tháng này'),
('Hướng dẫn Giải bài tập Hoá 11', 'Hoá Học', 'Lớp 11', 'Quận Đống Đa, Hà Nội', '1 buổi / tuần (Cuối tuần)', 1500000, 'Tùy sắp xếp'),
('Dạy kèm Tiếng Nhật N5 cho người mới bắt đầu', 'Tiếng Nhật', 'Sinh Viên', 'Quận Bình Thạnh, TP. HCM', '3 buổi / tuần', 2500000, 'Sớm nhất có thể'),
('Luyện viết chữ đẹp cho bé vô lớp 1', 'Tiếng Việt', 'Lớp 1', 'Gò Vấp, TP. HCM', '2 buổi / tuần', 1800000, 'Sang tuần bắt đầu');
