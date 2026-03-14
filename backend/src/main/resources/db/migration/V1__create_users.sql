-- V1: Users & Auth
-- Rollback: DROP TABLE IF EXISTS refresh_tokens, otp_codes, user_devices, users CASCADE;

CREATE EXTENSION IF NOT EXISTS "pgcrypto";

CREATE TYPE user_role AS ENUM ('ADMIN', 'TUTOR', 'PARENT', 'STUDENT');

CREATE TABLE users (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    phone           VARCHAR(20)  UNIQUE,             -- Nullable for STUDENTS
    username        VARCHAR(50)  UNIQUE,             -- For STUDENTS who don't have phones
    password_hash   VARCHAR(255) NOT NULL,
    full_name       VARCHAR(150) NOT NULL,
    avatar_url      VARCHAR(500),
    role            user_role    NOT NULL,
    is_active       BOOLEAN      NOT NULL DEFAULT TRUE,
    is_deleted      BOOLEAN      NOT NULL DEFAULT FALSE,
    failed_attempts INT          NOT NULL DEFAULT 0, -- Brute-force prevention
    locked_until    TIMESTAMPTZ,                     -- Brute-force lockout timestamp
    created_at      TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    CONSTRAINT chk_phone_or_username CHECK (phone IS NOT NULL OR username IS NOT NULL)
);

CREATE TABLE otp_codes (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    phone       VARCHAR(20)  NOT NULL,
    code        VARCHAR(10)  NOT NULL,
    purpose     VARCHAR(50)  NOT NULL,          -- REGISTER | RESET_PASSWORD
    is_used     BOOLEAN      NOT NULL DEFAULT FALSE,
    expires_at  TIMESTAMPTZ  NOT NULL,
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

CREATE TABLE refresh_tokens (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id     UUID         NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    token_hash  VARCHAR(255) NOT NULL UNIQUE,
    expires_at  TIMESTAMPTZ  NOT NULL,
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

-- Store FCM tokens for mobile app push notifications
CREATE TABLE user_devices (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id     UUID         NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    fcm_token   VARCHAR(255) NOT NULL UNIQUE,
    device_name VARCHAR(100),
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_otp_phone_purpose   ON otp_codes(phone, purpose, is_used);
CREATE INDEX idx_refresh_token_user  ON refresh_tokens(user_id);
CREATE INDEX idx_user_devices_user   ON user_devices(user_id);
CREATE INDEX idx_users_phone         ON users(phone) WHERE is_deleted = FALSE AND phone IS NOT NULL;
CREATE INDEX idx_users_username      ON users(username) WHERE is_deleted = FALSE AND username IS NOT NULL;
