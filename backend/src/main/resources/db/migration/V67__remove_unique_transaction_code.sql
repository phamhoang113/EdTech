-- V67: Remove UNIQUE constraint on transaction_code for grouped payments

-- Depending on the database dialect, removing constraint by name or by index
ALTER TABLE billings DROP CONSTRAINT IF EXISTS billings_transaction_code_key;
ALTER TABLE tutor_payouts DROP CONSTRAINT IF EXISTS tutor_payouts_transaction_code_key;
