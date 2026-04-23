-- Fix missing base columns for user_linked_providers table
ALTER TABLE public.user_linked_providers ADD COLUMN created_at TIMESTAMPTZ DEFAULT now() NOT NULL;
ALTER TABLE public.user_linked_providers ADD COLUMN updated_at TIMESTAMPTZ DEFAULT now() NOT NULL;
ALTER TABLE public.user_linked_providers ADD COLUMN is_deleted BOOLEAN DEFAULT false NOT NULL;
