CREATE TABLE IF NOT EXISTS conversation_backups (
    id UUID PRIMARY KEY,
    user_id UUID NOT NULL,
    user_role VARCHAR(20) NOT NULL,
    last_message_preview VARCHAR(255),
    last_message_at TIMESTAMP,
    last_message_sender_name VARCHAR(100),
    unread_count_admin INT DEFAULT 0,
    unread_count_user INT DEFAULT 0,
    is_closed BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    archived_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS message_backups (
    id UUID PRIMARY KEY,
    conversation_id UUID NOT NULL,
    sender_id UUID NOT NULL,
    content TEXT NOT NULL,
    message_type VARCHAR(20) DEFAULT 'TEXT',
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP,
    archived_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
