-- V9: Notifications
-- Rollback: DROP TABLE IF EXISTS notifications, notification_tokens CASCADE;

CREATE TYPE notification_channel AS ENUM ('IN_APP', 'FCM');
CREATE TYPE notification_type AS ENUM (
    'CLASS_OPENED',           -- lớp mới mở (→ TUTOR)
    'APPLICATION_RECEIVED',   -- gia sư ứng tuyển (→ PARENT)
    'APPLICATION_ACCEPTED',   -- được chấp nhận (→ TUTOR)
    'APPLICATION_REJECTED',   -- bị từ chối (→ TUTOR)
    'INVOICE_RECEIPT_UPLOADED', -- PH upload biên lai (→ ADMIN)
    'INVOICE_APPROVED',       -- biên lai được duyệt (→ PARENT)
    'INVOICE_REJECTED',       -- biên lai bị từ chối (→ PARENT)
    'SESSION_REMINDER',       -- sắp đến giờ học (→ TUTOR, STUDENT, PARENT)
    'MEET_LINK_SET',          -- gia sư gắn link Meet (→ STUDENT, PARENT)
    'ASSESSMENT_PUBLISHED',   -- bài kiểm tra mới (→ STUDENT)
    'SUBMISSION_GRADED',      -- bài đã chấm (→ STUDENT, PARENT)
    'PAYOUT_TRANSFERRED',     -- tiền được chuyển (→ TUTOR)
    'CLASS_CANCELLED'         -- lớp bị hủy (→ TUTOR, PARENT, STUDENT)
);

CREATE TABLE notifications (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    recipient_id UUID         NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    type        notification_type NOT NULL,
    title       VARCHAR(255)  NOT NULL,
    body        TEXT          NOT NULL,
    -- Reference to source entity
    entity_type VARCHAR(50),   -- 'CLASS', 'SESSION', 'ASSESSMENT', 'INVOICE', ...
    entity_id   UUID,
    -- Status
    is_read     BOOLEAN       NOT NULL DEFAULT FALSE,
    read_at     TIMESTAMPTZ,
    created_at  TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

-- FCM device tokens (per user, per device)
CREATE TABLE notification_tokens (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id     UUID        NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    token       VARCHAR(500) NOT NULL UNIQUE,
    device_type VARCHAR(20)  NOT NULL DEFAULT 'ANDROID', -- ANDROID | IOS | WEB
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_notif_recipient    ON notifications(recipient_id, is_read, created_at DESC);
CREATE INDEX idx_notif_entity       ON notifications(entity_type, entity_id);
CREATE INDEX idx_notif_tokens_user  ON notification_tokens(user_id);
