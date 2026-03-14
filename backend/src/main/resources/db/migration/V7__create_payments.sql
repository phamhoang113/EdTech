-- V7: Payments (Thanh toán)
-- Rollback: DROP TABLE IF EXISTS tutor_payouts, invoices CASCADE;

CREATE TYPE invoice_status AS ENUM ('PENDING', 'RECEIPT_UPLOADED', 'APPROVED', 'REJECTED');
CREATE TYPE payout_status  AS ENUM ('PENDING', 'TRANSFERRED', 'FAILED');

-- Hóa đơn học phí của phụ huynh
CREATE TABLE invoices (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    class_id            UUID            NOT NULL REFERENCES classes(id),
    parent_id           UUID            NOT NULL REFERENCES users(id),
    admin_bank_id       UUID            REFERENCES admin_bank_accounts(id),
    -- Amount
    amount              NUMERIC(12,2)   NOT NULL,
    period_label        VARCHAR(100),                               -- e.g. "Tháng 3/2026"
    -- Receipt
    receipt_url         VARCHAR(500),                              -- ảnh biên lai (MinIO)
    receipt_uploaded_at TIMESTAMPTZ,
    -- Admin review
    status              invoice_status  NOT NULL DEFAULT 'PENDING',
    reviewed_by         UUID            REFERENCES users(id),
    reviewed_at         TIMESTAMPTZ,
    reject_reason       TEXT,
    -- Audit
    created_at          TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ     NOT NULL DEFAULT NOW()
);

-- Lịch sử giao tiền cho gia sư
CREATE TABLE tutor_payouts (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    class_id        UUID            NOT NULL REFERENCES classes(id),
    tutor_id        UUID            NOT NULL REFERENCES users(id),
    payment_method_id UUID          REFERENCES payment_methods(id),
    gross_amount    NUMERIC(12,2)   NOT NULL,                       -- tổng học phí tutor nhận
    platform_fee    NUMERIC(12,2)   NOT NULL DEFAULT 0,
    net_amount      NUMERIC(12,2)   NOT NULL,                       -- net = gross - platform_fee
    period_label    VARCHAR(100),
    transfer_note   TEXT,
    status          payout_status   NOT NULL DEFAULT 'PENDING',
    paid_by         UUID            REFERENCES users(id),
    paid_at         TIMESTAMPTZ,
    created_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_invoices_parent  ON invoices(parent_id, status);
CREATE INDEX idx_invoices_class   ON invoices(class_id);
CREATE INDEX idx_payouts_tutor    ON tutor_payouts(tutor_id, status);
CREATE INDEX idx_payouts_class    ON tutor_payouts(class_id);
