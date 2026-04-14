-- V12__teaching_module.sql
-- Bổ sung cho module Giảng dạy: Tài liệu, Bài tập, Kiểm tra

-- 1. Notification types mới
ALTER TYPE public.notification_type ADD VALUE IF NOT EXISTS 'MATERIAL_UPLOADED';
ALTER TYPE public.notification_type ADD VALUE IF NOT EXISTS 'HOMEWORK_ASSIGNED';
ALTER TYPE public.notification_type ADD VALUE IF NOT EXISTS 'HOMEWORK_DEADLINE_REMINDER';
ALTER TYPE public.notification_type ADD VALUE IF NOT EXISTS 'HOMEWORK_SUBMITTED';
ALTER TYPE public.notification_type ADD VALUE IF NOT EXISTS 'TEST_SCHEDULED';

-- 2. Submission status mới (mở rộng lifecycle)
ALTER TYPE public.submission_status ADD VALUE IF NOT EXISTS 'REVIEWING';
ALTER TYPE public.submission_status ADD VALUE IF NOT EXISTS 'COMPLETED';
ALTER TYPE public.submission_status ADD VALUE IF NOT EXISTS 'ARCHIVED';

-- 3. Materials: thêm file_name, mime_type cho download
ALTER TABLE public.materials ADD COLUMN IF NOT EXISTS file_name VARCHAR(255);
ALTER TABLE public.materials ADD COLUMN IF NOT EXISTS mime_type VARCHAR(100);

-- 4. Assessments: thêm attachment file (đề bài upload)
ALTER TABLE public.assessments ADD COLUMN IF NOT EXISTS attachment_url VARCHAR(500);
ALTER TABLE public.assessments ADD COLUMN IF NOT EXISTS attachment_name VARCHAR(255);

-- 5. Submissions: thêm file nộp bài + lifecycle tracking
ALTER TABLE public.submissions ADD COLUMN IF NOT EXISTS file_url VARCHAR(500);
ALTER TABLE public.submissions ADD COLUMN IF NOT EXISTS file_name VARCHAR(255);
ALTER TABLE public.submissions ADD COLUMN IF NOT EXISTS file_size BIGINT;

-- GS upload file chữa bài
ALTER TABLE public.submissions ADD COLUMN IF NOT EXISTS tutor_file_url VARCHAR(500);
ALTER TABLE public.submissions ADD COLUMN IF NOT EXISTS tutor_file_name VARCHAR(255);

-- Lifecycle tracking cho auto-cleanup
ALTER TABLE public.submissions ADD COLUMN IF NOT EXISTS completed_at TIMESTAMPTZ;
ALTER TABLE public.submissions ADD COLUMN IF NOT EXISTS last_interaction_at TIMESTAMPTZ DEFAULT NOW();
ALTER TABLE public.submissions ADD COLUMN IF NOT EXISTS files_cleaned BOOLEAN DEFAULT FALSE;
