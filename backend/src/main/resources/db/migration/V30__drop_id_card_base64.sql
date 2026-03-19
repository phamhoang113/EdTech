-- V30: Drop id_card_base64 from tutor_profiles
-- Only id_card_number (text) is collected in the verification flow. No image is stored.
-- Rollback: ALTER TABLE tutor_profiles ADD COLUMN id_card_base64 TEXT;
ALTER TABLE tutor_profiles DROP COLUMN IF EXISTS id_card_base64;
