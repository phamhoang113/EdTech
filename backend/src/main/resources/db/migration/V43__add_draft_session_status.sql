-- V43: Add DRAFT to session_status enum
-- Rollback: N/A (cannot remove enum values in PostgreSQL)

ALTER TYPE session_status ADD VALUE IF NOT EXISTS 'DRAFT' BEFORE 'SCHEDULED';
