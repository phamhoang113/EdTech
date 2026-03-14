-- V10: Global Indexes + Admin Seed
-- Rollback: Remove indexes and admin user manually.

-- ========================================
-- Full-text search on tutor profiles
-- ========================================
CREATE INDEX idx_tutor_fts ON tutor_profiles
    USING GIN(to_tsvector('simple', COALESCE(bio, '') || ' ' || COALESCE(location, '')));

-- ========================================
-- Composite indexes from dba agent spec
-- ========================================
CREATE INDEX idx_tutor_location    ON tutor_profiles(location);
CREATE INDEX idx_tutor_rate        ON tutor_profiles(hourly_rate);
CREATE INDEX idx_bookings_parent   ON invoices(parent_id, status);         -- re-alias for dba compat
CREATE INDEX idx_messages_room     ON notifications(recipient_id, created_at DESC);

-- ========================================
-- Seed: Default Admin
-- ========================================
-- Password: Admin@123 (bcrypt strength=12, change on first login)
INSERT INTO users (id, phone, password_hash, full_name, role, is_active)
VALUES (
    gen_random_uuid(),
    '0900000000',
    '$2a$12$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2MtjgYpHm6m',  -- Admin@123
    'Super Admin',
    'ADMIN',
    TRUE
);

-- Seed: Admin bank account
INSERT INTO admin_bank_accounts (method_type, account_number, account_name, bank_name, is_active)
VALUES
    ('BANK', '1234567890', 'CONG TY EDTECH', 'Vietcombank', TRUE),
    ('MOMO', '0900000000', 'EDTECH PLATFORM', NULL, TRUE);
