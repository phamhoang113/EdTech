package com.edtech.backend.ai.service;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.edtech.backend.ai.dto.AiConversationResponse;
import com.edtech.backend.ai.dto.AiMessageResponse;
import com.edtech.backend.ai.dto.CreateConversationRequest;
import com.edtech.backend.ai.dto.SendMessageRequest;
import com.edtech.backend.ai.entity.AiConversationEntity;
import com.edtech.backend.ai.entity.AiMessageEntity;
import com.edtech.backend.ai.entity.AiSubscriptionEntity;
import com.edtech.backend.ai.entity.AiUsageLogEntity;
import com.edtech.backend.ai.enums.AiMessageRole;
import com.edtech.backend.ai.repository.AiConversationRepository;
import com.edtech.backend.ai.repository.AiMessageRepository;
import com.edtech.backend.ai.repository.AiUsageLogRepository;
import com.edtech.backend.core.exception.BusinessRuleException;
import com.edtech.backend.core.exception.EntityNotFoundException;

/**
 * Service xử lý conversation AI và gửi/nhận message.
 * Tách biệt rõ: subscription check → usage check → call Gemini → save.
 */
@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class AiConversationService {

    private static final String SYSTEM_PROMPT_TEMPLATE = """
            Bạn là AI Tutor của nền tảng gia sư EdTech — người bạn học thông minh của học sinh.

            🎯 Vai trò:
            - Giúp học sinh hiểu bài, giải bài tập, ôn thi
            - Giải thích từng bước rõ ràng, kiên nhẫn
            - Sau mỗi lời giải, đặt câu hỏi ngắn để kiểm tra hiểu bài

            📚 Ngữ cảnh học sinh:
            - Môn học: %s
            - Lớp: %s

            📝 Quy tắc:
            - Luôn dùng tiếng Việt
            - Không đưa thẳng đáp án — hướng dẫn từng bước
            - Dùng ví dụ thực tế, dễ hiểu
            - Nếu là bài Toán/Lý/Hóa → trình bày từng bước có ký hiệu rõ ràng
            - Khích lệ, thân thiện — không phán xét sai lầm của học sinh
            """;

    private final AiConversationRepository conversationRepository;
    private final AiMessageRepository messageRepository;
    private final AiUsageLogRepository usageLogRepository;
    private final AiSubscriptionService subscriptionService;
    private final GeminiService geminiService;

    // ── Conversations ─────────────────────────────────────────────────────

    @Transactional
    public AiConversationResponse createConversation(UUID studentId, CreateConversationRequest request) {
        // Kiểm tra quyền truy cập (tự tạo trial nếu chưa có)
        subscriptionService.requireAccess(studentId);

        AiConversationEntity entity = AiConversationEntity.builder()
                .studentId(studentId)
                .subject(request.getSubject())
                .grade(request.getGrade())
                .title("Cuộc trò chuyện mới")
                .build();

        entity = conversationRepository.save(entity);
        log.info("AI conversation created: id={}, studentId={}", entity.getId(), studentId);
        return AiConversationResponse.from(entity);
    }

    public List<AiConversationResponse> listConversations(UUID studentId) {
        return conversationRepository.findByStudentIdOrderByCreatedAtDesc(studentId)
                .stream()
                .map(AiConversationResponse::from)
                .toList();
    }

    public List<AiMessageResponse> getMessages(UUID studentId, UUID conversationId) {
        AiConversationEntity conv = findConversationForStudent(studentId, conversationId);
        return messageRepository.findByConversationIdOrderByCreatedAtAsc(conv.getId())
                .stream()
                .map(AiMessageResponse::from)
                .toList();
    }

    @Transactional
    public void deleteConversation(UUID studentId, UUID conversationId) {
        AiConversationEntity conv = findConversationForStudent(studentId, conversationId);
        conversationRepository.delete(conv);
    }

    // ── Send Message ──────────────────────────────────────────────────────

    /**
     * Gửi message mới từ HS → gọi Gemini → lưu cả 2 message (USER + ASSISTANT).
     */
    @Transactional
    public AiMessageResponse sendMessage(UUID studentId, UUID conversationId,
                                          SendMessageRequest request) {
        AiConversationEntity conv = findConversationForStudent(studentId, conversationId);

        // 1. Kiểm tra subscription access
        AiSubscriptionEntity subscription = subscriptionService.requireAccess(studentId);

        // 2. Kiểm tra daily usage limit
        checkDailyLimit(studentId, subscription);

        // 3. Lưu message của HS
        AiMessageEntity userMessage = AiMessageEntity.builder()
                .conversationId(conv.getId())
                .role(AiMessageRole.USER)
                .content(request.getContent() != null ? request.getContent() : "")
                .imageUrl(null) // imageBase64 không lưu DB, chỉ pass qua Gemini
                .build();
        messageRepository.save(userMessage);

        // 4. Xây dựng system prompt có context môn/lớp
        String systemPrompt = String.format(SYSTEM_PROMPT_TEMPLATE,
                conv.getSubject() != null ? conv.getSubject() : "Chưa xác định",
                conv.getGrade() != null ? conv.getGrade() : "Chưa xác định");

        // 5. Build conversation history (tối đa 20 tin gần nhất để tránh token quá lớn)
        List<Map<String, Object>> history = buildGeminiHistory(conv.getId());

        // 6. Gọi Gemini AI
        String aiReply;
        if (request.getImageBase64() != null && !request.getImageBase64().isBlank()) {
            // Multimodal: text + ảnh (camera solver)
            String textContent = request.getContent() != null ? request.getContent()
                    : "Hãy giải bài tập trong ảnh này từng bước chi tiết.";
            aiReply = geminiService.generateWithImage(
                    systemPrompt, textContent,
                    request.getImageBase64(), request.getImageMimeType());
        } else {
            aiReply = geminiService.generateText(systemPrompt, history, request.getContent());
        }

        // 7. Lưu message của AI
        AiMessageEntity assistantMessage = AiMessageEntity.builder()
                .conversationId(conv.getId())
                .role(AiMessageRole.ASSISTANT)
                .content(aiReply)
                .build();
        assistantMessage = messageRepository.save(assistantMessage);

        // 8. Cập nhật title conversation nếu còn mặc định
        if ("Cuộc trò chuyện mới".equals(conv.getTitle()) && request.getContent() != null) {
            String autoTitle = request.getContent().length() > 50
                    ? request.getContent().substring(0, 50) + "..."
                    : request.getContent();
            conv.setTitle(autoTitle);
            conversationRepository.save(conv);
        }

        // 9. Increment usage log
        incrementUsage(studentId);

        log.info("AI message sent: conversationId={}, studentId={}", conversationId, studentId);
        return AiMessageResponse.from(assistantMessage);
    }

    // ── Private helpers ───────────────────────────────────────────────────

    private AiConversationEntity findConversationForStudent(UUID studentId, UUID conversationId) {
        AiConversationEntity conv = conversationRepository.findById(conversationId)
                .orElseThrow(() -> new EntityNotFoundException("Conversation không tồn tại."));
        if (!conv.getStudentId().equals(studentId)) {
            throw new BusinessRuleException("Bạn không có quyền truy cập conversation này.");
        }
        return conv;
    }

    private List<Map<String, Object>> buildGeminiHistory(UUID conversationId) {
        List<AiMessageEntity> allMessages = messageRepository
                .findByConversationIdOrderByCreatedAtAsc(conversationId);

        // Lấy 20 tin gần nhất để tránh context quá dài
        int fromIndex = Math.max(0, allMessages.size() - 20);
        List<AiMessageEntity> recent = allMessages.subList(fromIndex, allMessages.size());

        List<Map<String, Object>> history = new ArrayList<>();
        for (AiMessageEntity msg : recent) {
            String role = msg.getRole() == AiMessageRole.USER ? "user" : "model";
            history.add(Map.of(
                "role", role,
                "parts", List.of(Map.of("text", msg.getContent()))
            ));
        }
        return history;
    }

    private void checkDailyLimit(UUID studentId, AiSubscriptionEntity subscription) {
        LocalDate today = LocalDate.now();
        int limit = subscriptionService.getDailyLimit(subscription);
        int used = usageLogRepository.findByStudentIdAndLogDate(studentId, today)
                .map(AiUsageLogEntity::getMessageCount)
                .orElse(0);

        if (used >= limit) {
            throw new BusinessRuleException(
                "AI_DAILY_LIMIT_REACHED",
                String.format("Bạn đã dùng hết %d tin nhắn AI hôm nay. Quay lại vào ngày mai nhé!", limit)
            );
        }
    }

    private void incrementUsage(UUID studentId) {
        LocalDate today = LocalDate.now();
        AiUsageLogEntity log = usageLogRepository
                .findByStudentIdAndLogDate(studentId, today)
                .orElseGet(() -> AiUsageLogEntity.builder()
                        .studentId(studentId)
                        .logDate(today)
                        .messageCount(0)
                        .build());
        log.setMessageCount(log.getMessageCount() + 1);
        usageLogRepository.save(log);
    }
}
