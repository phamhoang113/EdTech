ALTER TABLE tutor_payouts ADD COLUMN IF NOT EXISTS billing_id UUID;

-- Optional: add foreign key constraint if you want strict referential integrity
ALTER TABLE tutor_payouts DROP CONSTRAINT IF EXISTS fk_tutor_payouts_billing_id;
ALTER TABLE tutor_payouts ADD CONSTRAINT fk_tutor_payouts_billing_id FOREIGN KEY (billing_id) REFERENCES billings(id);
