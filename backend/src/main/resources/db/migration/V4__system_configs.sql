-- V4__system_configs.sql

INSERT INTO public.system_settings (id, key, value, description) VALUES
(gen_random_uuid(), 'site_name', 'EdTech', 'Tên hệ thống nền tảng'),
(gen_random_uuid(), 'contact_email', 'support@edtech.vn', 'Email hỗ trợ'),
(gen_random_uuid(), 'contact_phone', '1800 1234', 'SĐT tổng đài'),
(gen_random_uuid(), 'maintenance_mode', 'false', 'Bảo trì hệ thống'),
(gen_random_uuid(), 'mock_data_enabled', 'true', 'Cho phép dùng dữ liệu mock'),
(gen_random_uuid(), 'platform_fee_percent', '20', 'Phí nạp nền tảng (%)'),
(gen_random_uuid(), 'min_hourly_rate', '50000', 'Giá mở lớp - Thấp nhất/giờ (VND)'),
(gen_random_uuid(), 'max_hourly_rate', '2000000', 'Giá mở lớp - Cao nhất/giờ (VND)'),
(gen_random_uuid(), 'max_classes_per_tutor', '5', 'Số lớp tối đa cho GS'),
(gen_random_uuid(), 'auto_approve_enabled', 'false', 'Tự động duyệt profile gia sư'),
(gen_random_uuid(), 'email_on_new_user', 'true', 'Gửi email khi user đăng ký'),
(gen_random_uuid(), 'email_on_verification', 'true', 'Gửi email khi GS xác thực'),
(gen_random_uuid(), 'email_on_new_class', 'false', 'Gửi email khi có lớp mới'),
(gen_random_uuid(), 'email_on_payment', 'true', 'Gửi email giao dịch'),
(gen_random_uuid(), 'primary_color', '#6366f1', 'Màu chủ đề');
