-- V11: Add otp_token (UUID) to otp_codes for stateless OTP verification
-- Client receives otpToken after register, uses otpToken + code to verify (no phone needed in verify request)

ALTER TABLE otp_codes
    ADD COLUMN IF NOT EXISTS otp_token UUID NOT NULL DEFAULT gen_random_uuid();

CREATE UNIQUE INDEX IF NOT EXISTS idx_otp_token ON otp_codes(otp_token);
