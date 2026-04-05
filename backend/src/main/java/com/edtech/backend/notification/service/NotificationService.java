package com.edtech.backend.notification.service;

import java.time.LocalDateTime;
import java.util.UUID;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.edtech.backend.auth.entity.UserEntity;
import com.edtech.backend.auth.repository.UserRepository;
import com.edtech.backend.core.exception.EdTechException;
import com.edtech.backend.notification.dto.NotificationResponseDTO;
import com.edtech.backend.notification.entity.NotificationEntity;
import com.edtech.backend.notification.entity.NotificationType;
import com.edtech.backend.notification.repository.NotificationRepository;

@Service
@RequiredArgsConstructor
@Slf4j
@Transactional(readOnly = true)
public class NotificationService {

    private final NotificationRepository notificationRepository;
    private final UserRepository userRepository;
    private final SimpMessagingTemplate messagingTemplate;
    private final FcmPushService fcmPushService;

    @Transactional(readOnly = true)
    public Page<NotificationResponseDTO> getUserNotifications(String username, Pageable pageable) {
        UserEntity user = getUserByUsername(username);
        return notificationRepository.findByRecipientIdOrderByCreatedAtDesc(user.getId(), pageable)
                .map(this::mapToDTO);
    }

    @Transactional(readOnly = true)
    public long getUnreadCount(String username) {
        UserEntity user = getUserByUsername(username);
        return notificationRepository.countUnreadByRecipientId(user.getId());
    }

    @Transactional
    public void markAsRead(UUID notificationId, String username) {
        UserEntity user = getUserByUsername(username);
        NotificationEntity notif = notificationRepository.findById(notificationId)
                .orElseThrow(() -> new EdTechException("Không tìm thấy thông báo", "NOT_FOUND"));
        
        if (!notif.getRecipient().getId().equals(user.getId())) {
            throw new EdTechException("Không có quyền thao tác thông báo này", "FORBIDDEN");
        }
        
        if (!notif.isRead()) {
            notif.setRead(true);
            notif.setReadAt(LocalDateTime.now());
            notificationRepository.save(notif);
        }
    }
    
    @Transactional
    public void markAllAsRead(String username) {
        UserEntity user = getUserByUsername(username);
        notificationRepository.markAllAsRead(user.getId());
    }

    /**
     * Gửi thông báo mới và broadcast qua WebSocket
     */
    @Transactional
    public void sendNotification(UUID recipientId, NotificationType type, String title, String body, String entityType, UUID entityId) {
        UserEntity recipient = userRepository.findById(recipientId)
                .orElseThrow(() -> new EdTechException("Không tìm thấy người nhận", "NOT_FOUND"));

        NotificationEntity notif = NotificationEntity.builder()
                .recipient(recipient)
                .type(type)
                .title(title)
                .body(body)
                .entityType(entityType)
                .entityId(entityId)
                .isRead(false)
                .build();
                
        notif = notificationRepository.save(notif);
        
        NotificationResponseDTO dto = mapToDTO(notif);
        
        // Gửi qua WebSocket
        try {
            String destinationUser = recipient.getPhone() != null ? recipient.getPhone() : recipient.getUsername();
            // Prefix /user is handled by UserDestinationMessageHandler
            messagingTemplate.convertAndSendToUser(
                    destinationUser, 
                    "/queue/notifications", 
                    dto
            );
            
            long unreadCount = notificationRepository.countUnreadByRecipientId(recipientId);
            messagingTemplate.convertAndSendToUser(
                    destinationUser,
                    "/queue/notifications/unread",
                    unreadCount
            );
        } catch (Exception e) {
            log.warn("Failed to send WebSocket notification to user {}: {}", recipientId, e.getMessage());
        }

        // Gửi FCM push notification (chạy async, không block)
        fcmPushService.sendToUser(recipientId, title, body, entityType, entityId);
    }

    private UserEntity getUserByUsername(String username) {
        return userRepository.findByIdentifierAndIsDeletedFalse(username)
                .orElseThrow(() -> new EdTechException("Không tìm thấy người dùng", "NOT_FOUND"));
    }

    private NotificationResponseDTO mapToDTO(NotificationEntity entity) {
        return NotificationResponseDTO.builder()
                .id(entity.getId())
                .type(entity.getType())
                .title(entity.getTitle())
                .body(entity.getBody())
                .entityType(entity.getEntityType())
                .entityId(entity.getEntityId())
                .isRead(entity.isRead())
                .readAt(entity.getReadAt())
                .createdAt(entity.getCreatedAt())
                .build();
    }
}
