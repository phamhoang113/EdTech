-- V44: Create absence_requests table for student absence workflow
-- HS xin nghỉ → GS duyệt/từ chối
-- Rollback: DROP TABLE IF EXISTS absence_requests CASCADE;

CREATE TYPE absence_request_status AS ENUM ('PENDING', 'APPROVED', 'REJECTED');

CREATE TABLE absence_requests (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    session_id      UUID                    NOT NULL REFERENCES sessions(id) ON DELETE CASCADE,
    student_id      UUID                    NOT NULL REFERENCES users(id),
    reason          TEXT,
    make_up_required BOOLEAN                NOT NULL DEFAULT TRUE,
    status          absence_request_status  NOT NULL DEFAULT 'PENDING',
    reviewed_by     UUID                    REFERENCES users(id),
    reviewed_at     TIMESTAMPTZ,
    created_at      TIMESTAMPTZ             NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ             NOT NULL DEFAULT NOW(),
    UNIQUE (session_id, student_id)
);

CREATE INDEX idx_absence_session  ON absence_requests(session_id);
CREATE INDEX idx_absence_student  ON absence_requests(student_id, status);
CREATE INDEX idx_absence_status   ON absence_requests(status);
