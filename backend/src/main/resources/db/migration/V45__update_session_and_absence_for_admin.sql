-- V45: Update session status and absence request tables for Admin management

-- Add new values to session_status enum
ALTER TYPE session_status ADD VALUE IF NOT EXISTS 'COMPLETED_PENDING';
ALTER TYPE session_status ADD VALUE IF NOT EXISTS 'CANCELLED_BY_TUTOR';
ALTER TYPE session_status ADD VALUE IF NOT EXISTS 'CANCELLED_BY_STUDENT';
ALTER TYPE session_status ADD VALUE IF NOT EXISTS 'DISPUTED';

-- Create new enum for absence request type
CREATE TYPE absence_request_type AS ENUM ('TUTOR_LEAVE', 'STUDENT_LEAVE');

-- Modify absence_requests table
ALTER TABLE absence_requests RENAME COLUMN student_id TO requester_id;
ALTER TABLE absence_requests ALTER COLUMN requester_id DROP NOT NULL;

-- Recreate constraint since column was renamed and behavior changed
ALTER TABLE absence_requests DROP CONSTRAINT IF EXISTS absence_requests_session_id_student_id_key;
ALTER TABLE absence_requests ADD CONSTRAINT absence_requests_session_requester_unique UNIQUE (session_id, requester_id);

-- Add new columns
ALTER TABLE absence_requests ADD COLUMN request_type absence_request_type NOT NULL DEFAULT 'STUDENT_LEAVE';
ALTER TABLE absence_requests ADD COLUMN proof_url TEXT;
ALTER TABLE absence_requests ADD COLUMN makeup_date DATE;
ALTER TABLE absence_requests ADD COLUMN makeup_time TIME;
