-- Thêm notification types cho luồng Absence + Schedule
ALTER TYPE public.notification_type ADD VALUE IF NOT EXISTS 'ABSENCE_REQUESTED';
ALTER TYPE public.notification_type ADD VALUE IF NOT EXISTS 'ABSENCE_APPROVED';
ALTER TYPE public.notification_type ADD VALUE IF NOT EXISTS 'ABSENCE_REJECTED';
ALTER TYPE public.notification_type ADD VALUE IF NOT EXISTS 'SCHEDULE_UPDATED';
ALTER TYPE public.notification_type ADD VALUE IF NOT EXISTS 'SCHEDULE_CONFIRMED';
