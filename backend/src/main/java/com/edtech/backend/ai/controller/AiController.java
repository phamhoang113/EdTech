package com.edtech.backend.ai.controller;

import java.util.List;
import java.util.UUID;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import reactor.core.publisher.Flux;
import org.springframework.http.codec.ServerSentEvent;

import com.edtech.backend.ai.dto.AiConversationResponse;
import com.edtech.backend.ai.dto.AiMessageResponse;
import com.edtech.backend.ai.dto.AiSubscriptionStatusResponse;
import com.edtech.backend.ai.dto.CreateConversationRequest;
import com.edtech.backend.ai.dto.SendMessageRequest;
import com.edtech.backend.ai.dto.UpdateConversationRequest;
import com.edtech.backend.ai.service.AiConversationService;
import com.edtech.backend.ai.service.AiSubscriptionService;
import com.edtech.backend.auth.entity.UserEntity;
import com.edtech.backend.auth.repository.UserRepository;
import com.edtech.backend.core.dto.ApiResponse;
import com.edtech.backend.core.exception.EntityNotFoundException;

/**
 * REST API cho module AI Student Study Companion.
 * Chỉ học sinh (STUDENT) được phép sử dụng.
 */
@RestController
@RequestMapping("/api/v1/ai")
@RequiredArgsConstructor
@Tag(name = "AI Study Companion", description = "AI hỗ trợ học tập — chỉ dành cho học sinh")
@SecurityRequirement(name = "bearerAuth")
@PreAuthorize("hasRole('STUDENT')")
public class AiController {

    private final AiSubscriptionService subscriptionService;
    private final AiConversationService conversationService;
    private final UserRepository userRepository;

    // ── Subscription ──────────────────────────────────────────────────────

    @GetMapping("/subscription/status")
    @Operation(summary = "Kiểm tra trạng thái subscription AI (tự kích hoạt trial nếu chưa có)")
    public ResponseEntity<ApiResponse<AiSubscriptionStatusResponse>> getSubscriptionStatus(
            @AuthenticationPrincipal UserDetails userDetails) {

        UUID studentId = resolveUserId(userDetails);
        AiSubscriptionStatusResponse status = subscriptionService.getOrCreateSubscription(studentId);
        return ResponseEntity.ok(ApiResponse.ok(status, "Trạng thái subscription AI."));
    }

    // ── Conversations ─────────────────────────────────────────────────────

    @PostMapping("/conversations")
    @Operation(summary = "Tạo conversation mới")
    public ResponseEntity<ApiResponse<AiConversationResponse>> createConversation(
            @AuthenticationPrincipal UserDetails userDetails,
            @RequestBody CreateConversationRequest request) {

        UUID studentId = resolveUserId(userDetails);
        AiConversationResponse response = conversationService.createConversation(studentId, request);
        return ResponseEntity.ok(ApiResponse.ok(response, "Tạo conversation thành công."));
    }

    @GetMapping("/conversations")
    @Operation(summary = "Danh sách conversations của học sinh")
    public ResponseEntity<ApiResponse<List<AiConversationResponse>>> listConversations(
            @AuthenticationPrincipal UserDetails userDetails) {

        UUID studentId = resolveUserId(userDetails);
        List<AiConversationResponse> list = conversationService.listConversations(studentId);
        return ResponseEntity.ok(ApiResponse.ok(list, "Danh sách conversations."));
    }

    @GetMapping("/conversations/{conversationId}/messages")
    @Operation(summary = "Lịch sử tin nhắn của 1 conversation")
    public ResponseEntity<ApiResponse<List<AiMessageResponse>>> getMessages(
            @AuthenticationPrincipal UserDetails userDetails,
            @PathVariable UUID conversationId) {

        UUID studentId = resolveUserId(userDetails);
        List<AiMessageResponse> messages = conversationService.getMessages(studentId, conversationId);
        return ResponseEntity.ok(ApiResponse.ok(messages, "Lịch sử tin nhắn."));
    }

    @DeleteMapping("/conversations/{conversationId}")
    @Operation(summary = "Xóa conversation")
    public ResponseEntity<ApiResponse<Void>> deleteConversation(
            @AuthenticationPrincipal UserDetails userDetails,
            @PathVariable UUID conversationId) {

        UUID studentId = resolveUserId(userDetails);
        conversationService.deleteConversation(studentId, conversationId);
        return ResponseEntity.ok(ApiResponse.ok(null, "Đã xóa conversation."));
    }

    @PatchMapping("/conversations/{conversationId}")
    @Operation(summary = "Cập nhật conversation (đặt mục tiêu học tập)")
    public ResponseEntity<ApiResponse<AiConversationResponse>> updateConversation(
            @AuthenticationPrincipal UserDetails userDetails,
            @PathVariable UUID conversationId,
            @RequestBody UpdateConversationRequest request) {

        UUID studentId = resolveUserId(userDetails);
        AiConversationResponse response = conversationService.updateConversation(studentId, conversationId, request);
        return ResponseEntity.ok(ApiResponse.ok(response, "Đã cập nhật conversation."));
    }

    // ── Messages ──────────────────────────────────────────────────────────

    @PostMapping("/conversations/{conversationId}/messages")
    @Operation(summary = "Gửi message tới AI (hỗ trợ text + ảnh base64 cho camera solver)")
    public ResponseEntity<ApiResponse<AiMessageResponse>> sendMessage(
            @AuthenticationPrincipal UserDetails userDetails,
            @PathVariable UUID conversationId,
            @RequestBody SendMessageRequest request) {

        UUID studentId = resolveUserId(userDetails);
        AiMessageResponse response = conversationService.sendMessage(studentId, conversationId, request);
        return ResponseEntity.ok(ApiResponse.ok(response, "AI đã trả lời."));
    }

    @PostMapping(value = "/conversations/{conversationId}/messages/stream",
                 produces = org.springframework.http.MediaType.TEXT_EVENT_STREAM_VALUE)
    @Operation(summary = "Gửi message tới AI (SSE streaming — response từng chunk real-time)")
    public Flux<ServerSentEvent<String>> sendMessageStreaming(
            @AuthenticationPrincipal UserDetails userDetails,
            @PathVariable UUID conversationId,
            @RequestBody SendMessageRequest request) {

        UUID studentId = resolveUserId(userDetails);

        try {
            AiConversationService.StreamingResult result =
                    conversationService.sendMessageStreaming(studentId, conversationId, request);

            UUID convId = result.conversationId();

            return result.textStream()
                    .map(chunk -> ServerSentEvent.<String>builder()
                            .event("chunk")
                            .data(chunk)
                            .build())
                    .concatWith(Flux.just(
                            ServerSentEvent.<String>builder()
                                    .event("done")
                                    .data("{\"conversationId\":\"" + convId + "\"}")
                                    .build()
                    ))
                    .onErrorResume(e -> Flux.just(
                            ServerSentEvent.<String>builder()
                                    .event("error")
                                    .data(e.getMessage() != null ? e.getMessage()
                                            : "AI tạm thời không khả dụng.")
                                    .build()
                    ));
        } catch (Exception e) {
            return Flux.just(
                    ServerSentEvent.<String>builder()
                            .event("error")
                            .data(e.getMessage() != null ? e.getMessage()
                                    : "Có lỗi xảy ra. Vui lòng thử lại.")
                            .build()
            );
        }
    }

    // ── Private helpers ───────────────────────────────────────────────────

    private UUID resolveUserId(UserDetails userDetails) {
        UserEntity user = userRepository.findByIdentifierAndIsDeletedFalse(userDetails.getUsername())
                .orElseThrow(() -> new EntityNotFoundException("User not found"));
        return user.getId();
    }
}
