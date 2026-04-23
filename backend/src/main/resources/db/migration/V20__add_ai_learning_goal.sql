-- V10: Thêm learning_goal cho AI conversation
-- Cho phép HS/GS đặt mục tiêu học tập cụ thể, AI sẽ tập trung coaching phần đó.
ALTER TABLE ai_conversation ADD COLUMN IF NOT EXISTS learning_goal VARCHAR(500);
