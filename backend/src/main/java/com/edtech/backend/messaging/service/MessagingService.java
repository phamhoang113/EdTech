package com.edtech.backend.messaging.service;

import java.time.LocalDateTime;
import java.util.UUID;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.edtech.backend.auth.entity.UserEntity;
import com.edtech.backend.auth.enums.UserRole;
import com.edtech.backend.auth.repository.UserRepository;
import com.edtech.backend.core.exception.EdTechException;
import com.edtech.backend.core.service.StorageService;
import com.edtech.backend.core.util.ImageCompressUtil;
import com.edtech.backend.messaging.dto.ConversationResponseDTO;
import com.edtech.backend.messaging.dto.MessageResponseDTO;
import com.edtech.backend.messaging.dto.SendMessageRequest;
import com.edtech.backend.messaging.entity.ConversationEntity;
import com.edtech.backend.messaging.entity.MessageEntity;
import com.edtech.backend.messaging.repository.ConversationRepository;
import com.edtech.backend.messaging.repository.MessageRepository;
import com.edtech.backend.notification.entity.NotificationType;
import com.edtech.backend.notification.service.NotificationService;

@Service
@RequiredArgsConstructor
@Slf4j
@Transactional(readOnly = true)
public class MessagingService {

    private final ConversationRepository conversationRepository;
    private final MessageRepository messageRepository;
    private final UserRepository userRepository;
    private final NotificationService notificationService;
    private final StorageService storageService;
    private final SimpMessagingTemplate messagingTemplate;

    @Transactional(readOnly = true)
    public Page<ConversationResponseDTO> getConversations(String currentUsername, Pageable pageable) {
        UserEntity currentUser = getUserByUsername(currentUsername);

        if (currentUser.getRole() == UserRole.ADMIN) {
            // Admin can see all conversations
            return conversationRepository.findAllByOrderByLastMessageAtDesc(pageable)
                    .map(this::mapConversation);
        } else {
            // Non-admin can only see their own conversation
            return conversationRepository.findByUserIdOrderByLastMessageAtDesc(currentUser.getId(), pageable)
                    .map(this::mapConversation);
        }
    }

    @Transactional(readOnly = true)
    public ConversationResponseDTO getConversationById(UUID conversationId, String currentUsername) {
        UserEntity currentUser = getUserByUsername(currentUsername);
        ConversationEntity conversation = getConversationAndCheckAccess(conversationId, currentUser);
        return mapConversation(conversation);
    }
    
    @Transactional(readOnly = true)
    public ConversationResponseDTO getMyConversation(String currentUsername) {
        UserEntity currentUser = getUserByUsername(currentUsername);
        if (currentUser.getRole() == UserRole.ADMIN) {
            throw new EdTechException("Admin phải truyền conversationId", "BAD_REQUEST");
        }
        
        ConversationEntity conv = conversationRepository.findByUserId(currentUser.getId())
                .orElseThrow(() -> new EdTechException("Chưa có đoạn chat nào", "NOT_FOUND"));
                
        return mapConversation(conv);
    }

    @Transactional(readOnly = true)
    public Page<MessageResponseDTO> getMessages(UUID conversationId, String currentUsername, Pageable pageable) {
        UserEntity currentUser = getUserByUsername(currentUsername);
        ConversationEntity conversation = getConversationAndCheckAccess(conversationId, currentUser);

        return messageRepository.findByConversationIdOrderByCreatedAtDesc(conversation.getId(), pageable)
                .map(this::mapMessage);
    }

    @Transactional
    public MessageResponseDTO sendMessage(SendMessageRequest request, String currentUsername) {
        UserEntity sender = getUserByUsername(currentUsername);
        ConversationEntity conversation;

        if (sender.getRole() == UserRole.ADMIN) {
            // Admin must specify conversationId or targetUserId
            if (request.getConversationId() != null) {
                conversation = conversationRepository.findById(request.getConversationId())
                        .orElseThrow(() -> new EdTechException("Không tìm thấy conversation", "NOT_FOUND"));
            } else if (request.getTargetUserId() != null) {
                conversation = getOrCreateConversation(request.getTargetUserId());
            } else {
                throw new EdTechException("Admin phải cung cấp conversationId hoặc targetUserId", "BAD_REQUEST");
            }
        } else {
            // Non-admin always uses their own conversation
            conversation = getOrCreateConversation(sender.getId());
        }

        // Create message
        MessageEntity message = MessageEntity.builder()
                .conversation(conversation)
                .sender(sender)
                .content(request.getContent())
                .messageType(request.getMessageType())
                .isRead(false)
                .build();
        message = messageRepository.saveAndFlush(message);

        // Update conversation
        conversation.setLastMessagePreview(getPreview(request.getContent(), request.getMessageType()));
        conversation.setLastMessageSenderName(sender.getFullName());
        conversation.setLastMessageAt(message.getCreatedAt() != null ? message.getCreatedAt() : LocalDateTime.now());
        
        if (sender.getRole() == UserRole.ADMIN) {
            conversation.setUnreadCountUser(conversation.getUnreadCountUser() + 1);
        } else {
            conversation.setUnreadCountAdmin(conversation.getUnreadCountAdmin() + 1);
        }
        conversation = conversationRepository.saveAndFlush(conversation);

        // Map response
        MessageResponseDTO dto = mapMessage(message);

        // Broadcast to specific conversation topic
        messagingTemplate.convertAndSend("/topic/messages/" + conversation.getId(), dto);

        // Try to trigger a global notification to the recipient
        triggerNewMessageNotification(conversation, sender, dto);

        return dto;
    }

    @Transactional
    public void markAsRead(UUID conversationId, String currentUsername) {
        UserEntity currentUser = getUserByUsername(currentUsername);
        ConversationEntity conversation = getConversationAndCheckAccess(conversationId, currentUser);

        messageRepository.markMessagesAsRead(conversationId, currentUser.getId());

        if (currentUser.getRole() == UserRole.ADMIN) {
            conversation.setUnreadCountAdmin(0);
        } else {
            conversation.setUnreadCountUser(0);
        }
        
        conversationRepository.save(conversation);
        
        // Broadcast new unread count just in case clients track total badges
        broadcastUnreadCounts(conversation);
    }

    @Transactional(readOnly = true)
    public long getUnreadCount(String currentUsername) {
        UserEntity currentUser = getUserByUsername(currentUsername);
        if (currentUser.getRole() == UserRole.ADMIN) {
            Long count = conversationRepository.sumUnreadCountAdmin();
            return count != null ? count : 0L;
        } else {
            Long count = conversationRepository.getUnreadCountUser(currentUser.getId());
            return count != null ? count : 0L;
        }
    }

    // --- Helpers ---

    private UserEntity getUserByUsername(String username) {
        return userRepository.findByIdentifierAndIsDeletedFalse(username)
                .orElseThrow(() -> new EdTechException("Không tìm thấy người dùng", "NOT_FOUND"));
    }

    private ConversationEntity getConversationAndCheckAccess(UUID conversationId, UserEntity currentUser) {
        ConversationEntity conversation = conversationRepository.findById(conversationId)
                .orElseThrow(() -> new EdTechException("Không tìm thấy conversation", "NOT_FOUND"));

        if (currentUser.getRole() != UserRole.ADMIN && !conversation.getUser().getId().equals(currentUser.getId())) {
            throw new EdTechException("Bạn không có quyền truy cập đoạn chat này", "FORBIDDEN");
        }
        return conversation;
    }

    private ConversationEntity getOrCreateConversation(UUID userId) {
        return conversationRepository.findByUserId(userId)
                .orElseGet(() -> {
                    UserEntity targetUser = userRepository.findById(userId)
                            .orElseThrow(() -> new EdTechException("Không tìm thấy user", "NOT_FOUND"));
                    if (targetUser.getRole() == UserRole.ADMIN) {
                        throw new EdTechException("Không thể tạo conversation với Admin khác", "BAD_REQUEST");
                    }
                    ConversationEntity newConv = ConversationEntity.builder()
                            .user(targetUser)
                            .userRole(targetUser.getRole())
                            .build();
                    return conversationRepository.save(newConv);
                });
    }

    private void triggerNewMessageNotification(ConversationEntity conversation, UserEntity sender, MessageResponseDTO message) {
        try {
            UUID recipientId;
            boolean toAdmin = false;
            
            if (sender.getRole() == UserRole.ADMIN) {
                recipientId = conversation.getUser().getId();
            } else {
                // To Admin: We don't have a single admin ID, usually we notify a general topic or all admins.
                // For simplicity let's rely on the messaging topic `/topic/messages/unread/admin` instead of pushing to `notifications` table for every message sent to Admin inbox.
                toAdmin = true;
                recipientId = null; 
            }

            if (!toAdmin && recipientId != null) {
                // Normal notification for Non-Admin
                notificationService.sendNotification(
                        recipientId,
                        NotificationType.NEW_MESSAGE,
                        "Tin nhắn mới từ Hỗ trợ",
                        getPreview(message.getContent(), message.getMessageType()),
                        "CONVERSATION",
                        conversation.getId()
                );
            }
            
            // Broadcast badge update
            broadcastUnreadCounts(conversation);
            
        } catch (Exception e) {
            log.warn("Failed to trigger message notification", e);
        }
    }
    
    private void broadcastUnreadCounts(ConversationEntity conversation) {
        // Broadcast user's unread count
        try {
            UserEntity user = conversation.getUser();
            String userDest = user.getPhone() != null ? user.getPhone() : user.getUsername();
            messagingTemplate.convertAndSendToUser(
                    userDest, 
                    "/queue/messages/unread", 
                    conversation.getUnreadCountUser()
            );
        } catch (Exception e) {
            log.warn("Failed to broadcast user unread count: {}", e.getMessage());
        }

        // Broadcast admin's unread count
        try {
            Long totalAdminUnread = conversationRepository.sumUnreadCountAdmin();
            messagingTemplate.convertAndSend("/topic/messages/unread/admin", totalAdminUnread != null ? totalAdminUnread : 0);
        } catch (Exception e) {
            log.warn("Failed to broadcast admin unread count: {}", e.getMessage());
        }
    }

    private String getPreview(String content, String type) {
        if (!"TEXT".equals(type)) return "[" + type + "]";
        if (content.length() > 50) return content.substring(0, 47) + "...";
        return content;
    }

    private ConversationResponseDTO mapConversation(ConversationEntity entity) {
        return ConversationResponseDTO.builder()
                .id(entity.getId())
                .userId(entity.getUser().getId())
                .userFullName(entity.getUser().getFullName())
                .userAvatarBase64(ImageCompressUtil.decompress(entity.getUser().getAvatarBase64()))
                .userRole(entity.getUserRole())
                .lastMessagePreview(entity.getLastMessagePreview())
                .lastMessageSenderName(entity.getLastMessageSenderName())
                .lastMessageAt(entity.getLastMessageAt())
                .unreadCountAdmin(entity.getUnreadCountAdmin())
                .unreadCountUser(entity.getUnreadCountUser())
                .isClosed(entity.isClosed())
                .createdAt(entity.getCreatedAt())
                .updatedAt(entity.getUpdatedAt())
                .build();
    }

    private MessageResponseDTO mapMessage(MessageEntity entity) {
        return MessageResponseDTO.builder()
                .id(entity.getId())
                .conversationId(entity.getConversation().getId())
                .senderId(entity.getSender().getId())
                .senderName(entity.getSender().getFullName())
                .content(entity.getContent())
                .messageType(entity.getMessageType())
                .isRead(entity.isRead())
                .createdAt(entity.getCreatedAt())
                .build();
    }

    @Transactional
    public MessageResponseDTO sendImageMessage(MultipartFile file,
                                                UUID conversationId, UUID targetUserId,
                                                String currentUsername) {
        String base64DataUri = storageService.upload(file, "chat-images");

        SendMessageRequest request = new SendMessageRequest();
        request.setContent(base64DataUri);
        request.setMessageType("IMAGE");
        request.setConversationId(conversationId);
        request.setTargetUserId(targetUserId);

        return sendMessage(request, currentUsername);
    }
}
