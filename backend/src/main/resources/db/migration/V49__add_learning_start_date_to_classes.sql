-- Add learning_start_date column to classes table
ALTER TABLE classes ADD COLUMN IF NOT EXISTS learning_start_date DATE;
