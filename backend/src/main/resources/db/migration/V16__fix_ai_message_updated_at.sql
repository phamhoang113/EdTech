-- V16__fix_ai_message_updated_at.sql
-- Fix: thêm cột updated_at vào bảng ai_message (bị thiếu ở V15)
ALTER TABLE public.ai_message
    ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ NOT NULL DEFAULT now();
