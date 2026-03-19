-- Update classes table for Multi-Level JSONB Pricing

-- 1. Remove tutor_level_requirement as level_fees JSONB will handle it
ALTER TABLE classes DROP COLUMN IF EXISTS tutor_level_requirement;

-- 2. Drop the Computed/Generated constraints on tutor_fee to allow manual chốt giá later
ALTER TABLE classes DROP COLUMN tutor_fee;
ALTER TABLE classes ADD COLUMN tutor_fee NUMERIC(12,2); 
-- They default to NULL in OPEN state, and are only assigned when MATCHED.

-- 3. Add level_fees JSONB to store the array of pricing options
ALTER TABLE classes ADD COLUMN level_fees JSONB DEFAULT '[]'::jsonb;

-- 4. Set a placeholder JSON for existing OPEN classes to prevent them from breaking the UI
UPDATE classes
SET level_fees = '[
  {"level": "Sinh viên", "parent_fee": 2000000, "platform_fee": 500000, "tutor_fee": 1500000},
  {"level": "Giáo viên", "parent_fee": 3000000, "platform_fee": 500000, "tutor_fee": 2500000}
]'::jsonb
WHERE status = 'OPEN';
