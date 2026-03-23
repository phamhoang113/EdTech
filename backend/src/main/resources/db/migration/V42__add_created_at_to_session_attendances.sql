-- V42: Add created_at and updated_at to session_attendances

ALTER TABLE session_attendances
ADD COLUMN created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
ADD COLUMN updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW();
