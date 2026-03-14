-- V5: Learning Materials (Tài liệu học tập)
-- Rollback: DROP TABLE IF EXISTS materials CASCADE;

CREATE TYPE material_type AS ENUM ('DOCUMENT', 'VIDEO', 'IMAGE', 'LINK', 'OTHER');

CREATE TABLE materials (
    id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    class_id     UUID            NOT NULL REFERENCES classes(id) ON DELETE CASCADE,
    uploaded_by  UUID            NOT NULL REFERENCES users(id),   -- TUTOR
    title        VARCHAR(255)    NOT NULL,
    description  TEXT,
    type         material_type   NOT NULL DEFAULT 'DOCUMENT',
    file_url     VARCHAR(500),                                     -- MinIO path
    file_size    BIGINT,                                           -- bytes, max 50MB = 52428800
    external_url VARCHAR(500),                                     -- for LINK type
    is_deleted   BOOLEAN         NOT NULL DEFAULT FALSE,
    created_at   TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMPTZ     NOT NULL DEFAULT NOW(),

    CONSTRAINT chk_material_source CHECK (
        (file_url IS NOT NULL) OR (external_url IS NOT NULL)
    ),
    CONSTRAINT chk_file_size CHECK (file_size IS NULL OR file_size <= 52428800)
);

-- Indexes
CREATE INDEX idx_materials_class ON materials(class_id, created_at DESC) WHERE is_deleted = FALSE;
