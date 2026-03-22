-- V33: Add ASSIGNED to class_status enum
-- Must run before ALTER TABLE since enum values cannot be removed

ALTER TYPE class_status ADD VALUE IF NOT EXISTS 'ASSIGNED' BEFORE 'MATCHED';
