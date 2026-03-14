-- V3: Classes (Lớp học) & Tutor Applications
-- Rollback: DROP TABLE IF EXISTS tutor_applications, classes CASCADE;

CREATE TYPE class_mode AS ENUM ('ONLINE', 'OFFLINE');
CREATE TYPE class_status AS ENUM ('OPEN', 'MATCHED', 'ACTIVE', 'COMPLETED', 'CANCELLED');
CREATE TYPE application_status AS ENUM ('PENDING', 'ACCEPTED', 'REJECTED', 'CANCELLED');

CREATE TABLE classes (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    -- Created by admin based on parent request
    admin_id            UUID          NOT NULL REFERENCES users(id),
    parent_id           UUID          NOT NULL REFERENCES users(id),
    tutor_id            UUID          REFERENCES users(id),        -- set after matching
    -- Content
    title               VARCHAR(255)  NOT NULL,
    subject             VARCHAR(100)  NOT NULL,
    grade               VARCHAR(50)   NOT NULL,
    description         TEXT,
    mode                class_mode    NOT NULL,
    address             VARCHAR(500),                              -- for OFFLINE
    -- Schedule (JSONB: [{dayOfWeek, startTime, endTime}])
    schedule            JSONB         NOT NULL DEFAULT '[]',
    sessions_per_week   INT           NOT NULL DEFAULT 1,
    session_duration_min INT          NOT NULL DEFAULT 90,         -- minutes
    -- Fees
    parent_fee          NUMERIC(12,2) NOT NULL,                    -- học phí PH đề xuất
    tutor_fee           NUMERIC(12,2) NOT NULL,                    -- học phí admin đặt (cao hơn)
    platform_fee        NUMERIC(12,2) NOT NULL DEFAULT 0,          -- chênh lệch = doanh thu platform
    -- Meta
    status              class_status  NOT NULL DEFAULT 'OPEN',
    start_date          DATE,
    end_date            DATE,
    is_deleted          BOOLEAN       NOT NULL DEFAULT FALSE,
    created_at          TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

-- Parent requirement notes (trước khi admin tạo lớp chính thức)
CREATE TABLE class_requests (
    id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    parent_id        UUID         NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    subject          VARCHAR(100) NOT NULL,
    grade            VARCHAR(50)  NOT NULL,
    mode             class_mode   NOT NULL,
    address          VARCHAR(500),
    preferred_schedule JSONB      NOT NULL DEFAULT '[]',
    expected_fee     NUMERIC(12,2),
    note             TEXT,
    status           VARCHAR(20)  NOT NULL DEFAULT 'PENDING',      -- PENDING | CONVERTED | CLOSED
    class_id         UUID         REFERENCES classes(id),          -- set khi admin tạo lớp
    created_at       TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

-- Students enrolled in a class (PH có thể có nhiều học sinh)
CREATE TABLE class_students (
    class_id    UUID NOT NULL REFERENCES classes(id) ON DELETE CASCADE,
    student_id  UUID NOT NULL REFERENCES users(id)   ON DELETE CASCADE,
    joined_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (class_id, student_id)
);

-- Tutor applications to open classes
CREATE TABLE tutor_applications (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    class_id    UUID              NOT NULL REFERENCES classes(id) ON DELETE CASCADE,
    tutor_id    UUID              NOT NULL REFERENCES users(id)   ON DELETE CASCADE,
    cover_note  TEXT,
    status      application_status NOT NULL DEFAULT 'PENDING',
    applied_at  TIMESTAMPTZ       NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ       NOT NULL DEFAULT NOW(),
    UNIQUE (class_id, tutor_id)
);

-- Indexes
CREATE INDEX idx_classes_status     ON classes(status) WHERE is_deleted = FALSE;
CREATE INDEX idx_classes_parent     ON classes(parent_id);
CREATE INDEX idx_classes_tutor      ON classes(tutor_id);
CREATE INDEX idx_applications_class ON tutor_applications(class_id, status);
CREATE INDEX idx_applications_tutor ON tutor_applications(tutor_id, status);
CREATE INDEX idx_class_students_st  ON class_students(student_id);
CREATE INDEX idx_requests_parent    ON class_requests(parent_id, status);
