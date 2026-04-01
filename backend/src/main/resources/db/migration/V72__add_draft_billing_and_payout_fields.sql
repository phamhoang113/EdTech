-- Add payout tracking columns to tutor_payouts (BillingStatus is handled as VARCHAR)
-- Add payout tracking columns to tutor_payouts
ALTER TABLE tutor_payouts ADD COLUMN IF NOT EXISTS admin_note TEXT;
ALTER TABLE tutor_payouts ADD COLUMN IF NOT EXISTS paid_at TIMESTAMPTZ;
ALTER TABLE tutor_payouts ADD COLUMN IF NOT EXISTS confirmed_by_tutor_at TIMESTAMPTZ;
