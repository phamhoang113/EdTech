-- V15__ai_module.sql
-- Module AI Study Companion — chỉ dành cho role STUDENT
-- Trial 30 ngày miễn phí, sau đó 200k/tháng

-- 1. Enum subscription status
CREATE TYPE public.ai_subscription_status AS ENUM (
    'TRIAL',      -- Đang dùng thử
    'ACTIVE',     -- Đã trả phí, còn hạn
    'EXPIRED',    -- Hết hạn (trial hoặc paid)
    'CANCELLED'   -- Tự huỷ
);

-- 2. Enum message role
CREATE TYPE public.ai_message_role AS ENUM ('USER', 'ASSISTANT');

-- 3. Bảng subscription — 1 student 1 subscription duy nhất
CREATE TABLE public.ai_subscription (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    student_id      UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    status          public.ai_subscription_status NOT NULL DEFAULT 'TRIAL',
    trial_started_at TIMESTAMPTZ,
    trial_ends_at   TIMESTAMPTZ,
    paid_until      TIMESTAMPTZ,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE(student_id)
);

-- 4. Bảng conversation
CREATE TABLE public.ai_conversation (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    student_id  UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    title       VARCHAR(200),
    subject     VARCHAR(100),   -- Môn học (lấy từ class context)
    grade       VARCHAR(50),    -- Lớp (lấy từ class context)
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 5. Bảng messages
CREATE TABLE public.ai_message (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    conversation_id     UUID NOT NULL REFERENCES public.ai_conversation(id) ON DELETE CASCADE,
    role                public.ai_message_role NOT NULL,
    content             TEXT NOT NULL,
    image_url           VARCHAR(500),   -- Nếu HS gửi ảnh (camera solver)
    tokens_used         INT DEFAULT 0,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 6. Bảng usage tracking — giới hạn tin nhắn/ngày
CREATE TABLE public.ai_usage_log (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    student_id      UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    log_date        DATE NOT NULL,
    message_count   INT NOT NULL DEFAULT 0,
    UNIQUE(student_id, log_date)
);

-- 7. Indexes
CREATE INDEX idx_ai_subscription_student     ON public.ai_subscription(student_id);
CREATE INDEX idx_ai_subscription_status      ON public.ai_subscription(status);
CREATE INDEX idx_ai_conversation_student     ON public.ai_conversation(student_id);
CREATE INDEX idx_ai_conversation_created     ON public.ai_conversation(created_at DESC);
CREATE INDEX idx_ai_message_conversation     ON public.ai_message(conversation_id);
CREATE INDEX idx_ai_message_created          ON public.ai_message(created_at);
CREATE INDEX idx_ai_usage_student_date       ON public.ai_usage_log(student_id, log_date);

-- 8. Notification types mới cho AI
ALTER TYPE public.notification_type ADD VALUE IF NOT EXISTS 'AI_TRIAL_EXPIRING';
ALTER TYPE public.notification_type ADD VALUE IF NOT EXISTS 'AI_TRIAL_EXPIRED';
ALTER TYPE public.notification_type ADD VALUE IF NOT EXISTS 'AI_SUBSCRIPTION_RENEWED';
