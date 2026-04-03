package com.edtech.backend.messaging.repository;

import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.edtech.backend.messaging.entity.ConversationBackupEntity;

@Repository
public interface ConversationBackupRepository extends JpaRepository<ConversationBackupEntity, UUID> {
}
