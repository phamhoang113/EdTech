-- Migration: V25__update_chuyen_gia_to_da_tot_nghiep.sql
-- Description: Replaces legacy 'Chuyên gia' and 'Đã tốt nghiệp' strings in JSONB arrays
-- to the canonical value 'Gia sư Tốt nghiệp' matching TutorType.GRADUATED enum

-- Replace "Chuyên gia" (old label)
UPDATE classes 
SET level_fees = replace(level_fees::text, '"Chuyên gia"', '"Gia sư Tốt nghiệp"')::jsonb
WHERE level_fees::text LIKE '%"Chuyên gia"%';

-- Replace "Đã tốt nghiệp" (transitional label from V23)
UPDATE classes 
SET level_fees = replace(level_fees::text, '"Đã tốt nghiệp"', '"Gia sư Tốt nghiệp"')::jsonb
WHERE level_fees::text LIKE '%"Đã tốt nghiệp"%';

-- Replace "Cử nhân" if any exist
UPDATE classes
SET level_fees = replace(level_fees::text, '"Cử nhân"', '"Gia sư Tốt nghiệp"')::jsonb
WHERE level_fees::text LIKE '%"Cử nhân"%';
