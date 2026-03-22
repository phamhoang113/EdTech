-- V37: Tạo bảng system_settings để lưu cấu hình hệ thống dưới dạng key-value
CREATE TABLE IF NOT EXISTS system_settings (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    key         VARCHAR(100) NOT NULL UNIQUE,
    value       TEXT,
    description VARCHAR(500),
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Seed default settings
INSERT INTO system_settings (key, value, description) VALUES
    ('site_name',               'EdTech',                   'Tên nền tảng'),
    ('contact_email',           'support@edtech.vn',        'Email liên hệ hỗ trợ'),
    ('contact_phone',           '1800 1234',                'Hotline hỗ trợ'),
    ('maintenance_mode',        'false',                    'Chế độ bảo trì (true/false)'),
    ('platform_fee_percent',    '20',                       'Phí nền tảng (%)'),
    ('min_hourly_rate',         '50000',                    'Lương gia sư tối thiểu (VNĐ/h)'),
    ('max_hourly_rate',         '2000000',                  'Lương gia sư tối đa (VNĐ/h)'),
    ('max_classes_per_tutor',   '5',                        'Số lớp tối đa mỗi gia sư'),
    ('auto_approve_enabled',    'false',                    'Tự động duyệt hồ sơ gia sư'),
    ('require_strong_password', 'true',                     'Yêu cầu mật khẩu mạnh'),
    ('session_timeout_minutes', '60',                       'Thời gian hết phiên đăng nhập (phút)'),
    ('max_login_attempts',      '5',                        'Số lần đăng nhập sai tối đa'),
    ('email_on_new_user',       'true',                     'Gửi email khi có người dùng mới'),
    ('email_on_verification',   'true',                     'Gửi email khi có hồ sơ chờ duyệt'),
    ('email_on_new_class',      'false',                    'Gửi email khi có lớp mới'),
    ('email_on_payment',        'true',                     'Gửi email khi có giao dịch'),
    ('primary_color',           '#6366f1',                  'Màu chủ đạo giao diện admin')
ON CONFLICT (key) DO NOTHING;
