-- Alter users table
ALTER TABLE users ALTER COLUMN avatar_url TYPE TEXT;

-- Alter tutor_profiles table
ALTER TABLE tutor_profiles ALTER COLUMN id_card_url TYPE TEXT;
ALTER TABLE tutor_profiles ALTER COLUMN id_card_back_url TYPE TEXT;
-- Note: cert_urls is already configured as TEXT[] inside the entity and migration V2
