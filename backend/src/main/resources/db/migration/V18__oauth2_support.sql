-- OAuth2 Support: Google & Facebook login/register
-- Cho phép password null cho OAuth2 users (đăng ký qua Google/Facebook không cần password)
ALTER TABLE public.users ALTER COLUMN password_hash DROP NOT NULL;

-- Thêm cột auth_provider để phân biệt nguồn đăng ký ban đầu
ALTER TABLE public.users ADD COLUMN auth_provider VARCHAR(20) DEFAULT 'PHONE' NOT NULL;

-- Bảng liên kết OAuth providers (hỗ trợ 1 user link nhiều providers, chuyển đổi 2 chiều)
CREATE TABLE public.user_linked_providers (
    id UUID DEFAULT gen_random_uuid() NOT NULL,
    user_id UUID NOT NULL,
    provider VARCHAR(20) NOT NULL,
    provider_user_id VARCHAR(255),
    provider_email VARCHAR(255),
    linked_at TIMESTAMPTZ DEFAULT now() NOT NULL,
    CONSTRAINT user_linked_providers_pkey PRIMARY KEY (id),
    CONSTRAINT fk_linked_provider_user FOREIGN KEY (user_id) REFERENCES public.users(id),
    CONSTRAINT uq_user_provider UNIQUE (user_id, provider),
    CONSTRAINT uq_provider_email UNIQUE (provider, provider_email)
);

CREATE INDEX idx_linked_providers_user_id ON public.user_linked_providers(user_id);
CREATE INDEX idx_linked_providers_email ON public.user_linked_providers(provider_email);
