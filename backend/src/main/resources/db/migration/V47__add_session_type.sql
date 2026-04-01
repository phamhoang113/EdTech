CREATE TYPE session_type AS ENUM ('REGULAR', 'MAKEUP', 'EXTRA');

ALTER TABLE sessions 
ADD COLUMN session_type session_type NOT NULL DEFAULT 'REGULAR';
