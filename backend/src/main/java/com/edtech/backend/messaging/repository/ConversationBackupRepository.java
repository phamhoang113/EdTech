package com.edtech.backend.messaging.repository;

import com.edtech.backend.messaging.entity.ConversationBackupEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
public interface ConversationBackupRepository extends JpaRepository<ConversationBackupEntity, UUID> {
}
