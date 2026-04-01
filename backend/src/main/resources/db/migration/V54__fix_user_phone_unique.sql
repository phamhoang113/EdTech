-- V54: Fix unique constraint for soft-deleted phone numbers
-- Allow re-registering with deleted phone numbers by replacing UNIQUE constraint with Partial Index.

ALTER TABLE users DROP CONSTRAINT IF EXISTS users_phone_key;
ALTER TABLE users DROP CONSTRAINT IF EXISTS users_username_key;

-- Drop older indexes if they exist (V1 created idx_users_phone)
DROP INDEX IF EXISTS idx_users_phone;
DROP INDEX IF EXISTS idx_users_username;

-- Create partial unique indexes
CREATE UNIQUE INDEX uk_users_active_phone ON users(phone) WHERE is_deleted = FALSE AND phone IS NOT NULL;
CREATE UNIQUE INDEX uk_users_active_username ON users(username) WHERE is_deleted = FALSE AND username IS NOT NULL;
