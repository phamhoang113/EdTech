-- V10: Add SUSPENDED status to class_status enum + suspend columns to classes table

-- Add SUSPENDED to class_status enum
ALTER TYPE public.class_status ADD VALUE IF NOT EXISTS 'SUSPENDED';

-- Add suspend tracking columns
ALTER TABLE public.classes ADD COLUMN IF NOT EXISTS suspended_at TIMESTAMPTZ;
ALTER TABLE public.classes ADD COLUMN IF NOT EXISTS suspend_reason TEXT;
ALTER TABLE public.classes ADD COLUMN IF NOT EXISTS suspend_start_date DATE;
ALTER TABLE public.classes ADD COLUMN IF NOT EXISTS suspend_end_date DATE;

-- Add notification types for suspend/resume
ALTER TYPE public.notification_type ADD VALUE IF NOT EXISTS 'CLASS_SUSPENDED';
ALTER TYPE public.notification_type ADD VALUE IF NOT EXISTS 'CLASS_RESUMED';
ALTER TYPE public.notification_type ADD VALUE IF NOT EXISTS 'CLASS_SUSPEND_REMINDER';
