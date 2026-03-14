-- V6: Assessments — Bài kiểm tra (MCQ + Tự luận) & Bài tập
-- Rollback: DROP TABLE IF EXISTS submission_answers, submissions, assessment_questions, assessments CASCADE;

CREATE TYPE assessment_type   AS ENUM ('EXAM', 'HOMEWORK');
CREATE TYPE question_type     AS ENUM ('MCQ', 'ESSAY');
CREATE TYPE submission_status AS ENUM ('DRAFT', 'SUBMITTED', 'GRADED');

-- Bài kiểm tra / bài tập
CREATE TABLE assessments (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    class_id        UUID            NOT NULL REFERENCES classes(id) ON DELETE CASCADE,
    created_by      UUID            NOT NULL REFERENCES users(id),   -- TUTOR
    title           VARCHAR(255)    NOT NULL,
    description     TEXT,
    type            assessment_type NOT NULL DEFAULT 'EXAM',
    -- Time window
    opens_at        TIMESTAMPTZ     NOT NULL,
    closes_at       TIMESTAMPTZ,
    duration_min    INT,                                              -- NULL = không giới hạn
    -- Scoring
    total_score     NUMERIC(6,2)    NOT NULL DEFAULT 100,
    pass_score      NUMERIC(6,2),
    -- Solution published after grading
    solution_url    VARCHAR(500),
    solution_text   TEXT,
    is_published    BOOLEAN         NOT NULL DEFAULT FALSE,           -- solution visible to students
    is_deleted      BOOLEAN         NOT NULL DEFAULT FALSE,
    created_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW()
);

-- Câu hỏi
CREATE TABLE assessment_questions (
    id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    assessment_id    UUID         NOT NULL REFERENCES assessments(id) ON DELETE CASCADE,
    order_index      INT          NOT NULL DEFAULT 0,
    type             question_type NOT NULL DEFAULT 'MCQ',
    content          TEXT         NOT NULL,
    -- MCQ options (JSON array: [{label, text, is_correct}])
    options          JSONB        NOT NULL DEFAULT '[]',
    -- Essay max length
    max_length       INT,
    score            NUMERIC(5,2) NOT NULL DEFAULT 1,
    explanation      TEXT                                             -- lời giải câu hỏi
);

-- Bài làm của học sinh
CREATE TABLE submissions (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    assessment_id   UUID              NOT NULL REFERENCES assessments(id) ON DELETE CASCADE,
    student_id      UUID              NOT NULL REFERENCES users(id),
    status          submission_status NOT NULL DEFAULT 'DRAFT',
    total_score     NUMERIC(6,2),                                     -- NULL until graded
    tutor_comment   TEXT,
    submitted_at    TIMESTAMPTZ,
    graded_at       TIMESTAMPTZ,
    graded_by       UUID              REFERENCES users(id),
    created_at      TIMESTAMPTZ       NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ       NOT NULL DEFAULT NOW(),
    UNIQUE (assessment_id, student_id)
);

-- Câu trả lời từng câu hỏi
CREATE TABLE submission_answers (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    submission_id   UUID     NOT NULL REFERENCES submissions(id) ON DELETE CASCADE,
    question_id     UUID     NOT NULL REFERENCES assessment_questions(id) ON DELETE CASCADE,
    -- MCQ: selected option label; Essay: text
    answer_mcq      VARCHAR(10),
    answer_essay    TEXT,
    is_correct      BOOLEAN,                                          -- NULL for essay (set by tutor)
    score_awarded   NUMERIC(5,2),
    tutor_feedback  TEXT,
    UNIQUE (submission_id, question_id)
);

-- Indexes
CREATE INDEX idx_assessments_class      ON assessments(class_id, opens_at DESC) WHERE is_deleted = FALSE;
CREATE INDEX idx_questions_assessment   ON assessment_questions(assessment_id, order_index);
CREATE INDEX idx_submissions_assessment ON submissions(assessment_id, status);
CREATE INDEX idx_submissions_student    ON submissions(student_id, status);
CREATE INDEX idx_sub_answers_submission ON submission_answers(submission_id);
