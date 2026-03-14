-- V4: Schedule & Sessions
-- Rollback: DROP TABLE IF EXISTS sessions CASCADE;

CREATE TYPE session_status AS ENUM ('SCHEDULED', 'LIVE', 'COMPLETED', 'CANCELLED');

CREATE TABLE sessions (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    class_id        UUID            NOT NULL REFERENCES classes(id) ON DELETE CASCADE,
    session_date    DATE            NOT NULL,
    start_time      TIME            NOT NULL,
    end_time        TIME            NOT NULL,
    meet_link       VARCHAR(500),                        -- Google Meet link (gắn trước 1h)
    meet_link_set_at TIMESTAMPTZ,                        -- thời điểm gắn link
    status          session_status  NOT NULL DEFAULT 'SCHEDULED',
    tutor_note      TEXT,
    created_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW()
);

-- Attendance tracking per session
CREATE TABLE session_attendances (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    session_id  UUID        NOT NULL REFERENCES sessions(id) ON DELETE CASCADE,
    student_id  UUID        NOT NULL REFERENCES users(id),
    is_present  BOOLEAN     NOT NULL DEFAULT FALSE,
    note        TEXT,
    UNIQUE (session_id, student_id)
);

-- Indexes
CREATE INDEX idx_sessions_class      ON sessions(class_id, session_date);
CREATE INDEX idx_sessions_date       ON sessions(session_date, status);
CREATE INDEX idx_attendance_session  ON session_attendances(session_id);
CREATE INDEX idx_attendance_student  ON session_attendances(student_id);
