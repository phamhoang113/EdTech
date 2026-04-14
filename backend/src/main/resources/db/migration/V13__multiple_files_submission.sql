-- V13__multiple_files_submission.sql
-- Thêm cột JSONB để hỗ trợ nộp nhiều file bài tập

ALTER TABLE public.submissions ADD COLUMN IF NOT EXISTS student_attachments JSONB DEFAULT '[]'::jsonb;
ALTER TABLE public.submissions ADD COLUMN IF NOT EXISTS tutor_attachments JSONB DEFAULT '[]'::jsonb;

-- Migrate dữ liệu sinh viên
UPDATE public.submissions
SET student_attachments = jsonb_build_array(
    jsonb_build_object(
        'fileUrl', file_url,
        'fileName', file_name,
        'fileSize', COALESCE(file_size, 0)
    )
)
WHERE file_url IS NOT NULL;

-- Migrate dữ liệu gia sư chữa bài
UPDATE public.submissions
SET tutor_attachments = jsonb_build_array(
    jsonb_build_object(
        'fileUrl', tutor_file_url,
        'fileName', tutor_file_name,
        'fileSize', 0
    )
)
WHERE tutor_file_url IS NOT NULL;
