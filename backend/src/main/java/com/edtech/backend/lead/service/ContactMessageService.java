package com.edtech.backend.lead.service;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.edtech.backend.auth.enums.UserRole;
import com.edtech.backend.auth.repository.UserRepository;
import com.edtech.backend.core.exception.EntityNotFoundException;
import com.edtech.backend.lead.dto.ContactMessageRequest;
import com.edtech.backend.lead.dto.ContactMessageResponse;
import com.edtech.backend.lead.entity.ContactMessageEntity;
import com.edtech.backend.lead.repository.ContactMessageRepository;
import com.edtech.backend.notification.entity.NotificationType;
import com.edtech.backend.notification.service.NotificationService;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class ContactMessageService {

    private final ContactMessageRepository contactMessageRepository;
    private final NotificationService notificationService;
    private final UserRepository userRepository;

    @Transactional
    public ContactMessageResponse createMessage(ContactMessageRequest request) {
        log.info("[CONTACT] New message from {} ({})", request.getName(), request.getEmail());

        ContactMessageEntity entity = ContactMessageEntity.builder()
                .name(request.getName())
                .email(request.getEmail())
                .subject(request.getSubject())
                .message(request.getMessage())
                .isRead(false)
                .build();

        ContactMessageEntity saved = contactMessageRepository.save(entity);

        notifyAdmins(saved);

        return ContactMessageResponse.fromEntity(saved);
    }

    public List<ContactMessageResponse> getAllMessages() {
        return contactMessageRepository.findAllByOrderByCreatedAtDesc()
                .stream()
                .map(ContactMessageResponse::fromEntity)
                .collect(Collectors.toList());
    }

    @Transactional
    public ContactMessageResponse toggleReadStatus(UUID id) {
        ContactMessageEntity entity = contactMessageRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Tin nhắn không tồn tại"));

        entity.setIsRead(!entity.getIsRead());
        ContactMessageEntity updated = contactMessageRepository.save(entity);
        return ContactMessageResponse.fromEntity(updated);
    }

    private void notifyAdmins(ContactMessageEntity message) {
        String title = "Tin nhắn liên hệ mới";
        String body = String.format("%s (%s) gửi tin nhắn: %s",
                message.getName(), message.getEmail(), message.getSubject());

        userRepository.findByRoleAndIsDeletedFalseOrderByCreatedAtDesc(UserRole.ADMIN)
                .forEach(admin -> notificationService.sendNotification(
                        admin.getId(), NotificationType.CONTACT_MESSAGE_RECEIVED,
                        title, body, "CONTACT", message.getId()));
    }
}
