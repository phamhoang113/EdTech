-- V23: Cho phép tạo lớp mà chưa có Phụ Huynh (parentId nullable)
ALTER TABLE classes ALTER COLUMN parent_id DROP NOT NULL;
