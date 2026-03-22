-- V34: Ensure application_status enum has all required values
-- Fix: if type existed before V32 with only 'PENDING', it won't have APPROVED/REJECTED

DO $$ BEGIN
  ALTER TYPE application_status ADD VALUE IF NOT EXISTS 'APPROVED';
EXCEPTION WHEN others THEN NULL;
END $$;

DO $$ BEGIN
  ALTER TYPE application_status ADD VALUE IF NOT EXISTS 'REJECTED';
EXCEPTION WHEN others THEN NULL;
END $$;
