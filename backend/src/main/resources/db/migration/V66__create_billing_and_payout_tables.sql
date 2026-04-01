-- V66: Create Billings and Tutor Payouts tables

CREATE TABLE IF NOT EXISTS billings (
    id UUID PRIMARY KEY,
    class_id UUID NOT NULL REFERENCES classes(id),
    parent_id UUID NOT NULL REFERENCES users(id),
    month INT NOT NULL,
    year INT NOT NULL,
    total_sessions INT NOT NULL,
    parent_fee_amount DECIMAL(15, 2) NOT NULL,
    tutor_payout_amount DECIMAL(15, 2) NOT NULL,
    transaction_code VARCHAR(50) NOT NULL UNIQUE,
    status VARCHAR(50) NOT NULL,
    verified_by_admin_id UUID REFERENCES users(id),
    verified_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL,
    created_by VARCHAR(255),
    updated_by VARCHAR(255)
);

CREATE INDEX IF NOT EXISTS idx_billings_parent_month_year ON billings(parent_id, month, year);
CREATE INDEX IF NOT EXISTS idx_billings_tx_code ON billings(transaction_code);

CREATE TABLE IF NOT EXISTS tutor_payouts (
    id UUID PRIMARY KEY,
    tutor_id UUID NOT NULL REFERENCES users(id),
    billing_id UUID NOT NULL REFERENCES billings(id),
    amount DECIMAL(15, 2) NOT NULL,
    transaction_code VARCHAR(50) UNIQUE,
    status VARCHAR(50) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL,
    created_by VARCHAR(255),
    updated_by VARCHAR(255)
);

CREATE INDEX IF NOT EXISTS idx_tutor_payouts_tutor_id ON tutor_payouts(tutor_id);
