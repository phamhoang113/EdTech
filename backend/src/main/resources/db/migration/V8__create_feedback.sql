-- V8: Feedback (Phụ huynh đánh giá gia sư — ẩn với gia sư, chỉ admin thấy)
-- Rollback: DROP TABLE IF EXISTS feedbacks CASCADE;

CREATE TABLE feedbacks (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    class_id    UUID         NOT NULL REFERENCES classes(id),
    parent_id   UUID         NOT NULL REFERENCES users(id),
    tutor_id    UUID         NOT NULL REFERENCES users(id),
    rating      SMALLINT     NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment     TEXT,
    is_visible  BOOLEAN      NOT NULL DEFAULT FALSE,             -- chỉ admin thấy, gia sư không thấy
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    UNIQUE (class_id, parent_id)                                -- 1 PH đánh giá 1 lớp 1 lần
);

-- Indexes
CREATE INDEX idx_feedback_tutor  ON feedbacks(tutor_id);
CREATE INDEX idx_feedback_parent ON feedbacks(parent_id);
