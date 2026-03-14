-- V2: Tutor / Parent / Student Profiles + Payment Methods
-- Rollback: DROP TABLE IF EXISTS payment_methods, student_profiles, parent_profiles, tutor_profiles CASCADE;

CREATE TABLE tutor_profiles (
    id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id       UUID         NOT NULL UNIQUE REFERENCES users(id) ON DELETE CASCADE,
    bio           TEXT,
    subjects      TEXT[]       NOT NULL DEFAULT '{}',
    level         VARCHAR(100),              -- e.g. Tiểu học, THCS, THPT, Đại học
    location      VARCHAR(255),
    teaching_mode VARCHAR(20)  NOT NULL DEFAULT 'BOTH', -- ONLINE | OFFLINE | BOTH
    hourly_rate         NUMERIC(12,2),
    rating              NUMERIC(3,2) NOT NULL DEFAULT 0.00,
    rating_count        INT          NOT NULL DEFAULT 0,
    id_card_url         VARCHAR(500),
    cert_urls           TEXT[]       NOT NULL DEFAULT '{}',
    verification_status VARCHAR(20)  NOT NULL DEFAULT 'UNVERIFIED', -- UNVERIFIED | PENDING | APPROVED | REJECTED
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

CREATE TABLE parent_profiles (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id     UUID         NOT NULL UNIQUE REFERENCES users(id) ON DELETE CASCADE,
    address     VARCHAR(500),
    note        TEXT,
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

CREATE TABLE student_profiles (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id     UUID         NOT NULL UNIQUE REFERENCES users(id) ON DELETE CASCADE,
    parent_id   UUID         NOT NULL REFERENCES users(id),    -- PH tạo hộ
    grade       VARCHAR(50),
    school      VARCHAR(255),
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

-- Platform fee config (admin-managed)
CREATE TABLE platform_configs (
    id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    config_key    VARCHAR(100) NOT NULL UNIQUE,  -- e.g. PLATFORM_FEE_TYPE, PLATFORM_FEE_VALUE
    config_value  VARCHAR(500) NOT NULL,
    description   VARCHAR(255),
    updated_by    UUID         REFERENCES users(id),
    updated_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

-- Seed default config
INSERT INTO platform_configs (config_key, config_value, description)
VALUES
    ('PLATFORM_FEE_TYPE',  'PERCENT',  'PERCENT hoặc FIXED'),
    ('PLATFORM_FEE_VALUE', '10',       'Giá trị: 10% hoặc 100000 VND');

-- Payment methods of tutor
CREATE TABLE payment_methods (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tutor_id        UUID         NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    method_type     VARCHAR(20)  NOT NULL,   -- BANK | MOMO
    account_number  VARCHAR(50)  NOT NULL,
    account_name    VARCHAR(150) NOT NULL,
    bank_name       VARCHAR(100),
    is_default      BOOLEAN      NOT NULL DEFAULT FALSE,
    created_at      TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

-- Admin bank account (for parent to transfer to)
CREATE TABLE admin_bank_accounts (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    method_type     VARCHAR(20)  NOT NULL,   -- BANK | MOMO
    account_number  VARCHAR(50)  NOT NULL,
    account_name    VARCHAR(150) NOT NULL,
    bank_name       VARCHAR(100),
    is_active       BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at      TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_tutor_subjects  ON tutor_profiles USING GIN(subjects);
CREATE INDEX idx_tutor_rating    ON tutor_profiles(rating DESC) WHERE verification_status = 'APPROVED';
CREATE INDEX idx_students_parent ON student_profiles(parent_id);
CREATE INDEX idx_payment_tutor   ON payment_methods(tutor_id);
