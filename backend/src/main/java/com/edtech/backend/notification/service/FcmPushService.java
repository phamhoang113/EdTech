package com.edtech.backend.notification.service;

import java.util.List;
import java.util.Map;
import java.util.UUID;

import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.FirebaseMessagingException;
import com.google.firebase.messaging.Message;
import com.google.firebase.messaging.MessagingErrorCode;
import com.google.firebase.messaging.Notification;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.edtech.backend.auth.entity.UserEntity;
import com.edtech.backend.auth.repository.UserRepository;
import com.edtech.backend.core.exception.EdTechException;
import com.edtech.backend.notification.dto.PushTokenRequest;
import com.edtech.backend.notification.entity.UserPushTokenEntity;
import com.edtech.backend.notification.repository.UserPushTokenRepository;

@Service
@RequiredArgsConstructor
@Slf4j
@Transactional(readOnly = true)
public class FcmPushService {

    private final UserPushTokenRepository pushTokenRepository;
    private final UserRepository userRepository;

    /**
     * Đăng ký FCM token cho user hiện tại.
     * Nếu token đã tồn tại → bỏ qua (idempotent).
     */
    @Transactional
    public void registerToken(String username, PushTokenRequest request) {
        if (pushTokenRepository.existsByToken(request.getToken())) {
            log.debug("FCM token already registered, skipping");
            return;
        }

        UserEntity user = userRepository.findByIdentifierAndIsDeletedFalse(username)
                .orElseThrow(() -> new EdTechException("Không tìm thấy người dùng", "NOT_FOUND"));

        UserPushTokenEntity tokenEntity = UserPushTokenEntity.builder()
                .user(user)
                .token(request.getToken())
                .deviceType(request.getDeviceType() != null ? request.getDeviceType() : "WEB")
                .build();

        pushTokenRepository.save(tokenEntity);
        log.info("Registered FCM token for user {} ({})", username, request.getDeviceType());
    }

    /**
     * Xóa FCM token (khi user logout hoặc token hết hạn).
     */
    @Transactional
    public void unregisterToken(String token) {
        pushTokenRepository.deleteByToken(token);
        log.info("Unregistered FCM token");
    }

    /**
     * Gửi push notification đến tất cả device của user.
     * Chạy async để không block luồng chính.
     */
    @Async
    public void sendToUser(UUID userId, String title, String body, String entityType, UUID entityId) {
        List<UserPushTokenEntity> tokens = pushTokenRepository.findByUserId(userId);

        if (tokens.isEmpty()) {
            log.debug("No FCM tokens for user {}, skipping push", userId);
            return;
        }

        for (UserPushTokenEntity tokenEntity : tokens) {
            sendSinglePush(tokenEntity, title, body, entityType, entityId);
        }
    }

    private void sendSinglePush(UserPushTokenEntity tokenEntity, String title, String body,
                                String entityType, UUID entityId) {
        try {
            Message.Builder messageBuilder = Message.builder()
                    .setToken(tokenEntity.getToken())
                    .setNotification(Notification.builder()
                            .setTitle(title)
                            .setBody(body)
                            .build());

            // Đính kèm data để client xử lý navigation khi click
            if (entityType != null) {
                messageBuilder.putData("entityType", entityType);
            }
            if (entityId != null) {
                messageBuilder.putData("entityId", entityId.toString());
            }

            FirebaseMessaging.getInstance().send(messageBuilder.build());
            log.debug("FCM push sent to token {}", tokenEntity.getToken().substring(0, 10));

        } catch (FirebaseMessagingException e) {
            handleFcmError(tokenEntity, e);
        } catch (Exception e) {
            log.warn("Unexpected error sending FCM push: {}", e.getMessage());
        }
    }

    /**
     * Xử lý lỗi FCM: nếu token hết hạn/unregistered → tự xóa khỏi DB.
     */
    @Transactional
    protected void handleFcmError(UserPushTokenEntity tokenEntity, FirebaseMessagingException e) {
        MessagingErrorCode errorCode = e.getMessagingErrorCode();

        if (errorCode == MessagingErrorCode.UNREGISTERED || errorCode == MessagingErrorCode.INVALID_ARGUMENT) {
            log.info("FCM token expired/invalid, removing: {}", tokenEntity.getToken().substring(0, 10));
            pushTokenRepository.delete(tokenEntity);
        } else {
            log.warn("FCM push failed ({}): {}", errorCode, e.getMessage());
        }
    }
}
