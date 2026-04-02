-- V3__mock_demo_accounts.sql

-- 1. Admin: admin_edtech / Ho@ngV@n
INSERT INTO public.users (id, username, password_hash, full_name, role, is_active, is_mock, is_deleted, created_at, updated_at) 
VALUES ('a0000000-0000-0000-0000-000000000009', 'admin_edtech', '$2a$10$P6cV1yLDvMxZL6hO0A5y0O9Z6oV8W4Vx7ba5Ewoic6.L1Rp8RCaYS', 'Admin Hoàng', 'ADMIN', true, true, false, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- 2. GS: 0000000001 / hoangproIT1
INSERT INTO public.users (id, username, password_hash, full_name, role, is_active, is_mock, is_deleted, created_at, updated_at) 
VALUES ('11000000-0000-0000-0000-000000000009', '0000000001', '$2a$10$KnpCJMUkGJUqWVWBx.vPEefWPhRjWXg1YzvoU6ISFC/KITEjdRj5C', 'Gia sư Hoàng', 'TUTOR', true, true, false, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO public.tutor_profiles (id, user_id, bio, subjects, location, teaching_mode, hourly_rate, rating, rating_count, verification_status, tutor_type, is_mock, experience_years) 
VALUES (gen_random_uuid(), '11000000-0000-0000-0000-000000000009', 'Gia sư test demo', ARRAY['Toán', 'Lập trình'], 'Hà Nội', ARRAY['ONLINE', 'OFFLINE'], 500000, 5.0, 10, 'APPROVED', 'TEACHER', true, 5);

-- 3. PH: 0000000002 / hoangproIT1
INSERT INTO public.users (id, username, password_hash, full_name, role, is_active, is_mock, is_deleted, created_at, updated_at) 
VALUES ('c0000000-0000-0000-0000-000000000002', '0000000002', '$2a$10$KnpCJMUkGJUqWVWBx.vPEefWPhRjWXg1YzvoU6ISFC/KITEjdRj5C', 'Phụ huynh Hoàng', 'PARENT', true, true, false, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- 4. HS liên kết PH ở trên: 0000000003 / hoangproIT1
INSERT INTO public.users (id, username, password_hash, full_name, role, is_active, is_mock, is_deleted, created_at, updated_at) 
VALUES ('b0000000-0000-0000-0000-000000000003', '0000000003', '$2a$10$KnpCJMUkGJUqWVWBx.vPEefWPhRjWXg1YzvoU6ISFC/KITEjdRj5C', 'Học sinh Liên kết Hoàng', 'STUDENT', true, true, false, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO public.student_profiles (id, user_id, parent_id, grade, school, created_at)
VALUES (gen_random_uuid(), 'b0000000-0000-0000-0000-000000000003', 'c0000000-0000-0000-0000-000000000002', 'Lớp 12', 'THPT Hà Nội', CURRENT_TIMESTAMP);

-- 5. HS chưa liên kết: 0000000004 / hoangproIT1
INSERT INTO public.users (id, username, password_hash, full_name, role, is_active, is_mock, is_deleted, created_at, updated_at) 
VALUES ('b0000000-0000-0000-0000-000000000004', '0000000004', '$2a$10$KnpCJMUkGJUqWVWBx.vPEefWPhRjWXg1YzvoU6ISFC/KITEjdRj5C', 'Học sinh Độc lập Hoàng', 'STUDENT', true, true, false, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
