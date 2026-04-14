-- Add SESSION_NOTE_UPDATED to notification_type enum
ALTER TYPE notification_type ADD VALUE IF NOT EXISTS 'SESSION_NOTE_UPDATED';
