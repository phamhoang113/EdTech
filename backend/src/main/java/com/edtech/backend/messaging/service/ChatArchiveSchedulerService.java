package com.edtech.backend.messaging.service;

import com.edtech.backend.messaging.entity.ConversationBackupEntity;
import com.edtech.backend.messaging.entity.ConversationEntity;
import com.edtech.backend.messaging.entity.MessageBackupEntity;
import com.edtech.backend.messaging.entity.MessageEntity;
import com.edtech.backend.messaging.repository.ConversationBackupRepository;
import com.edtech.backend.messaging.repository.ConversationRepository;
import com.edtech.backend.messaging.repository.MessageBackupRepository;
import com.edtech.backend.messaging.repository.MessageRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class ChatArchiveSchedulerService {

    private final ConversationRepository conversationRepository;
    private final MessageRepository messageRepository;
    private final ConversationBackupRepository conversationBackupRepository;
    private final MessageBackupRepository messageBackupRepository;

    @Scheduled(cron = "0 0 2 * * ?") // 2 AM everyday
    @Transactional
    public void archiveInactiveChats() {
        LocalDateTime threshold = LocalDateTime.now().minusDays(30);
        log.info("Starting chat archive job for conversations inactive since {}", threshold);

        List<ConversationEntity> idleConversations = conversationRepository.findIdleConversations(threshold);
        if (idleConversations.isEmpty()) {
            log.info("No inactive conversations found to archive.");
            return;
        }

        List<UUID> idleConversationIds = idleConversations.stream()
                .map(ConversationEntity::getId)
                .collect(Collectors.toList());

        List<MessageEntity> messages = messageRepository.findByConversationIdIn(idleConversationIds);

        // Map and save message backups
        List<MessageBackupEntity> messageBackups = messages.stream().map(m -> MessageBackupEntity.builder()
                .id(m.getId())
                .conversationId(m.getConversation().getId())
                .senderId(m.getSender().getId())
                .content(m.getContent())
                .messageType(m.getMessageType())
                .isRead(m.isRead())
                .createdAt(m.getCreatedAt())
                .archivedAt(LocalDateTime.now())
                .build()).collect(Collectors.toList());
        messageBackupRepository.saveAll(messageBackups);

        // Map and save conversation backups
        List<ConversationBackupEntity> conversationBackups = idleConversations.stream().map(c -> ConversationBackupEntity.builder()
                .id(c.getId())
                .userId(c.getUser().getId())
                .userRole(c.getUserRole())
                .lastMessagePreview(c.getLastMessagePreview())
                .lastMessageAt(c.getLastMessageAt())
                .lastMessageSenderName(c.getLastMessageSenderName())
                .unreadCountAdmin(c.getUnreadCountAdmin())
                .unreadCountUser(c.getUnreadCountUser())
                .isClosed(c.isClosed())
                .createdAt(c.getCreatedAt())
                .updatedAt(c.getUpdatedAt())
                .archivedAt(LocalDateTime.now())
                .build()).collect(Collectors.toList());
        conversationBackupRepository.saveAll(conversationBackups);

        // Delete from original tables
        messageRepository.deleteByConversationIdIn(idleConversationIds);
        conversationRepository.deleteAllById(idleConversationIds);

        log.info("Successfully archived {} conversations and {} messages.", idleConversations.size(), messages.size());
    }
}
