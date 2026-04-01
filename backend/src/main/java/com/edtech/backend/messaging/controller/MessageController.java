package com.edtech.backend.messaging.controller;

import com.edtech.backend.core.dto.ApiResponse;
import com.edtech.backend.messaging.dto.ConversationResponseDTO;
import com.edtech.backend.messaging.dto.MessageResponseDTO;
import com.edtech.backend.messaging.dto.SendMessageRequest;
import com.edtech.backend.messaging.service.MessagingService;
import com.edtech.backend.notification.dto.UnreadCountDTO;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.UUID;

@RestController
@RequestMapping("/api/v1/messages")
@RequiredArgsConstructor
public class MessageController {

    private final MessagingService messagingService;

    @GetMapping("/conversations")
    public ApiResponse<Page<ConversationResponseDTO>> getConversations(
            @AuthenticationPrincipal UserDetails userDetails,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size) {
        
        Pageable pageable = PageRequest.of(page, size);
        Page<ConversationResponseDTO> responses = messagingService.getConversations(userDetails.getUsername(), pageable);
        return ApiResponse.ok(responses, "Lấy danh sách trò chuyện thành công");
    }

    @GetMapping("/conversations/my")
    public ApiResponse<ConversationResponseDTO> getMyConversation(
            @AuthenticationPrincipal UserDetails userDetails) {
        ConversationResponseDTO response = messagingService.getMyConversation(userDetails.getUsername());
        return ApiResponse.ok(response, "Lấy trò chuyện của tôi thành công");
    }

    @GetMapping("/conversations/{id}")
    public ApiResponse<ConversationResponseDTO> getConversationById(
            @PathVariable UUID id,
            @AuthenticationPrincipal UserDetails userDetails) {
        
        ConversationResponseDTO response = messagingService.getConversationById(id, userDetails.getUsername());
        return ApiResponse.ok(response, "Lấy chi tiết trò chuyện thành công");
    }

    @GetMapping("/conversations/{conversationId}/history")
    public ApiResponse<Page<MessageResponseDTO>> getMessages(
            @PathVariable UUID conversationId,
            @AuthenticationPrincipal UserDetails userDetails,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "50") int size) {
        
        Pageable pageable = PageRequest.of(page, size);
        Page<MessageResponseDTO> messages = messagingService.getMessages(conversationId, userDetails.getUsername(), pageable);
        return ApiResponse.ok(messages, "Lấy lịch sử tin nhắn thành công");
    }

    @PostMapping
    public ApiResponse<MessageResponseDTO> sendMessage(
            @Valid @RequestBody SendMessageRequest request,
            @AuthenticationPrincipal UserDetails userDetails) {
        
        MessageResponseDTO message = messagingService.sendMessage(request, userDetails.getUsername());
        return ApiResponse.ok(message, "Gửi tin nhắn thành công");
    }

    @PostMapping("/image")
    public ApiResponse<MessageResponseDTO> sendImageMessage(
            @RequestParam("file") org.springframework.web.multipart.MultipartFile file,
            @RequestParam(value = "conversationId", required = false) UUID conversationId,
            @RequestParam(value = "targetUserId", required = false) UUID targetUserId,
            @AuthenticationPrincipal UserDetails userDetails) {

        MessageResponseDTO message = messagingService.sendImageMessage(
                file, conversationId, targetUserId, userDetails.getUsername());
        return ApiResponse.ok(message, "Gửi ảnh thành công");
    }

    @PatchMapping("/conversations/{id}/read")
    public ApiResponse<Void> markAsRead(
            @PathVariable UUID id,
            @AuthenticationPrincipal UserDetails userDetails) {
        
        messagingService.markAsRead(id, userDetails.getUsername());
        return ApiResponse.ok(null, "Đánh dấu đã đọc thành công");
    }

    @GetMapping("/unread-count")
    public ApiResponse<UnreadCountDTO> getUnreadCount(
            @AuthenticationPrincipal UserDetails userDetails) {
        
        long count = messagingService.getUnreadCount(userDetails.getUsername());
        return ApiResponse.ok(UnreadCountDTO.builder().count(count).build(), "Lấy số tin nhắn chưa đọc thành công");
    }
}
