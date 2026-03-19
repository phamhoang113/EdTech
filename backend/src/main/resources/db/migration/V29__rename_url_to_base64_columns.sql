-- V29: Drop redundant columns from tutor_profiles
-- The columns id_card_base64 and cert_base64s already have correct names from previous work.
-- This migration only cleans up columns no longer needed.

-- Drop id_card_back_url (added in V13, redundant)
-- Rollback: ALTER TABLE tutor_profiles ADD COLUMN id_card_back_url TEXT;
ALTER TABLE tutor_profiles DROP COLUMN IF EXISTS id_card_back_url;

-- Drop id_card_back_base64 (redundant back-side field, not part of verification flow)
-- Rollback: ALTER TABLE tutor_profiles ADD COLUMN id_card_back_base64 TEXT;
ALTER TABLE tutor_profiles DROP COLUMN IF EXISTS id_card_back_base64;

-- Drop level (superseded by teaching_levels TEXT[] added in V26)
-- Rollback: ALTER TABLE tutor_profiles ADD COLUMN level VARCHAR(100);
ALTER TABLE tutor_profiles DROP COLUMN IF EXISTS level;
