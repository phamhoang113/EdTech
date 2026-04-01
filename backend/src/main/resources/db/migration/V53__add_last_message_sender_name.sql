-- Add last_message_sender_name to conversations for preview display
ALTER TABLE conversations ADD COLUMN IF NOT EXISTS last_message_sender_name VARCHAR(255);
