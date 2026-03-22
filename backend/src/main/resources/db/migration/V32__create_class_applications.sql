-- V32: Create class_applications table for tutor apply for open classes

DO $$ BEGIN
  CREATE TYPE application_status AS ENUM ('PENDING', 'APPROVED', 'REJECTED');
EXCEPTION
  WHEN duplicate_object THEN NULL;
END $$;

CREATE TABLE class_applications (
    id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    class_id   UUID NOT NULL REFERENCES classes(id) ON DELETE CASCADE,
    tutor_id   UUID NOT NULL REFERENCES users(id)   ON DELETE CASCADE,
    status     application_status NOT NULL DEFAULT 'PENDING',
    note       TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE (class_id, tutor_id)
);

CREATE INDEX idx_class_applications_class_id   ON class_applications(class_id);
CREATE INDEX idx_class_applications_tutor_id   ON class_applications(tutor_id);
CREATE INDEX idx_class_applications_status     ON class_applications(status);
