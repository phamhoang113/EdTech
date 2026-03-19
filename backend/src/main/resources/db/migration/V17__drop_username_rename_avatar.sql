-- V17: Drop username and rename avatar_url
ALTER TABLE users DROP COLUMN IF EXISTS username;
ALTER TABLE users RENAME COLUMN avatar_url TO avatar_base64;
ALTER TABLE tutor_profiles RENAME COLUMN id_card_url TO id_card_base64;
ALTER TABLE tutor_profiles RENAME COLUMN id_card_back_url TO id_card_back_base64;
ALTER TABLE tutor_profiles RENAME COLUMN cert_urls TO cert_base64s;
