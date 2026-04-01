-- V51: Thêm loại thông báo NEW_MESSAGE (Tin nhắn mới)
ALTER TYPE notification_type ADD VALUE IF NOT EXISTS 'NEW_MESSAGE';
