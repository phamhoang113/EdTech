-- Migration: V26__add_tutor_profile_fields.sql
-- Description: Add multi-subject specialties, grade levels, achievements, and experience years to tutor_profiles.

-- Add teaching_levels: array of grade levels gia sư có thể dạy (max 5 applied in app logic)
ALTER TABLE tutor_profiles 
ADD COLUMN IF NOT EXISTS teaching_levels TEXT[] DEFAULT '{}';

-- Add date_of_birth: ngày tháng năm sinh gia sư
ALTER TABLE tutor_profiles 
ADD COLUMN IF NOT EXISTS date_of_birth DATE;

-- Add achievements: thành tích / kinh nghiệm dạy học tự do nhập
ALTER TABLE tutor_profiles 
ADD COLUMN IF NOT EXISTS achievements TEXT;

-- Add experience_years: số năm kinh nghiệm gia sư
ALTER TABLE tutor_profiles 
ADD COLUMN IF NOT EXISTS experience_years INTEGER DEFAULT 0;
