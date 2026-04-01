ALTER TABLE tutor_payouts ALTER COLUMN class_id DROP NOT NULL;
ALTER TABLE tutor_payouts ALTER COLUMN gross_amount DROP NOT NULL;
ALTER TABLE tutor_payouts ALTER COLUMN net_amount DROP NOT NULL;
