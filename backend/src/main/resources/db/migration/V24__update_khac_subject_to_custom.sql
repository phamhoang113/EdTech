-- Migration: V24__update_khac_subject_to_custom.sql
-- Description: Update the seed class that had subject = 'Khác' to demonstrate Custom Subject text like 'Lập trình Web'

UPDATE classes 
SET subject = 'Lập trình Web' 
WHERE subject = 'Khác';
