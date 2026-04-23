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

import reactor.core.publisher.Flux;

import com.edtech.backend.ai.dto.AiConversationResponse;
import com.edtech.backend.ai.dto.AiMessageResponse;
import com.edtech.backend.ai.dto.CreateConversationRequest;
import com.edtech.backend.ai.dto.SendMessageRequest;
import com.edtech.backend.ai.dto.UpdateConversationRequest;
import com.edtech.backend.ai.entity.AiConversationEntity;
import com.edtech.backend.ai.entity.AiMessageEntity;
import com.edtech.backend.ai.entity.AiSubscriptionEntity;
import com.edtech.backend.ai.entity.AiUsageLogEntity;
import com.edtech.backend.ai.enums.AiMessageRole;
import com.edtech.backend.ai.repository.AiConversationRepository;
import com.edtech.backend.ai.repository.AiMessageRepository;
import com.edtech.backend.ai.repository.AiUsageLogRepository;
import com.edtech.backend.teaching.repository.SubmissionRepository;
import com.edtech.backend.core.exception.BusinessRuleException;
import org.springframework.data.domain.PageRequest;
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

    // System prompt được sinh động bởi SubjectPromptStrategy theo từng môn học

    private final AiConversationRepository conversationRepository;
    private final AiMessageRepository messageRepository;
    private final AiUsageLogRepository usageLogRepository;
    private final SubmissionRepository submissionRepository;
    private final AiSubscriptionService subscriptionService;
    private final GeminiService geminiService;

    // ── Conversations ─────────────────────────────────────────────────────

    @Transactional
    public AiConversationResponse createConversation(UUID studentId, CreateConversationRequest request) {
        // Kiểm tra quyền truy cập (tự tạo trial nếu chưa có)
        subscriptionService.requireAccess(studentId);

        // Validate subject phải nằm trong danh sách cố định
        if (request.getSubject() == null || !SubjectPromptStrategy.isValidSubject(request.getSubject())) {
            throw new BusinessRuleException(
                    "INVALID_SUBJECT",
                    "Môn học không hợp lệ. Vui lòng chọn: " + String.join(", ", SubjectPromptStrategy.ALL_SUBJECTS)
            );
        }

        AiConversationEntity entity = AiConversationEntity.builder()
                .studentId(studentId)
                .subject(request.getSubject())
                .grade(request.getGrade())
                .title("Cuộc trò chuyện mới")
                .build();

        entity = conversationRepository.save(entity);
        log.info("AI conversation created: id={}, studentId={}, subject={}", entity.getId(), studentId, request.getSubject());
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

    /**
     * Cập nhật conversation (hiện hỗ trợ mục tiêu học tập).
     */
    @Transactional
    public AiConversationResponse updateConversation(UUID studentId, UUID conversationId,
                                                      UpdateConversationRequest request) {
        AiConversationEntity conv = findConversationForStudent(studentId, conversationId);

        if (request.getLearningGoal() != null) {
            conv.setLearningGoal(request.getLearningGoal().isBlank() ? null : request.getLearningGoal().trim());
        }

        conv = conversationRepository.save(conv);
        log.info("AI conversation updated: id={}, learningGoal={}", conversationId, conv.getLearningGoal());
        return AiConversationResponse.from(conv);
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

        // 3. Xây dựng system prompt chuyên biệt theo môn + context điểm số + mục tiêu
        List<Object[]> recentSubmissions = submissionRepository
                .findGradedWithAssessmentDetails(studentId, PageRequest.of(0, 8));

        String systemPrompt = SubjectPromptStrategy.buildPrompt(
                conv.getSubject(),
                conv.getGrade(),
                recentSubmissions,
                conv.getLearningGoal()
        );

        // 4. Build conversation history TRƯỚC khi lưu message mới (tránh duplicate)
        List<Map<String, Object>> history = buildGeminiHistory(conv.getId());

        // 5. Lưu message của HS (sau khi đã build history)
        AiMessageEntity userMessage = AiMessageEntity.builder()
                .conversationId(conv.getId())
                .role(AiMessageRole.USER)
                .content(request.getContent() != null ? request.getContent() : "")
                .imageUrl(null) // imageBase64 không lưu DB, chỉ pass qua Gemini
                .build();
        messageRepository.save(userMessage);

        // 6. Gọi Gemini AI (subject được truyền để STEM có thinkingBudget cao hơn)
        String aiReply;
        String subject = conv.getSubject();
        if (request.getImageBase64() != null && !request.getImageBase64().isBlank()) {
            // Multimodal: text + ảnh (camera solver)
            String textContent = request.getContent() != null ? request.getContent()
                    : "Hãy giải bài tập trong ảnh này từng bước chi tiết.";
            aiReply = geminiService.generateWithImage(
                    systemPrompt, textContent,
                    request.getImageBase64(), request.getImageMimeType(), subject);
        } else {
            aiReply = geminiService.generateText(systemPrompt, history, request.getContent(), subject);
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

    // ── Send Message Streaming ────────────────────────────────────────────

    /**
     * Gửi message streaming: trả về Flux<String> từng chunk text real-time.
     * Validate + save user message TRƯỚC → stream Gemini → save AI message KHI XONG.
     *
     * Trả về StreamContext chứa: conversationId (để client refresh) + Flux<String>.
     */
    @Transactional
    public StreamingResult sendMessageStreaming(UUID studentId, UUID conversationId,
                                                SendMessageRequest request) {
        AiConversationEntity conv = findConversationForStudent(studentId, conversationId);

        // 1. Kiểm tra subscription access
        AiSubscriptionEntity subscription = subscriptionService.requireAccess(studentId);

        // 2. Kiểm tra daily usage limit
        checkDailyLimit(studentId, subscription);

        // 3. Xây dựng system prompt
        List<Object[]> recentSubmissions = submissionRepository
                .findGradedWithAssessmentDetails(studentId, PageRequest.of(0, 8));

        String systemPrompt = SubjectPromptStrategy.buildPrompt(
                conv.getSubject(), conv.getGrade(),
                recentSubmissions, conv.getLearningGoal()
        );

        // 4. Build conversation history
        List<Map<String, Object>> history = buildGeminiHistory(conv.getId());

        // 5. Lưu message user
        AiMessageEntity userMessage = AiMessageEntity.builder()
                .conversationId(conv.getId())
                .role(AiMessageRole.USER)
                .content(request.getContent() != null ? request.getContent() : "")
                .imageUrl(null)
                .build();
        messageRepository.save(userMessage);

        // 6. Cập nhật title nếu còn mặc định
        if ("Cuộc trò chuyện mới".equals(conv.getTitle()) && request.getContent() != null) {
            String autoTitle = request.getContent().length() > 50
                    ? request.getContent().substring(0, 50) + "..."
                    : request.getContent();
            conv.setTitle(autoTitle);
            conversationRepository.save(conv);
        }

        // 7. Tạo Flux streaming từ Gemini
        String subject = conv.getSubject();
        UUID convId = conv.getId();

        Flux<String> streamFlux;
        if (request.getImageBase64() != null && !request.getImageBase64().isBlank()) {
            String textContent = request.getContent() != null ? request.getContent()
                    : "Hãy giải bài tập trong ảnh này từng bước chi tiết.";
            streamFlux = geminiService.generateWithImageStreaming(
                    systemPrompt, textContent,
                    request.getImageBase64(), request.getImageMimeType(), subject);
        } else {
            streamFlux = geminiService.generateTextStreaming(
                    systemPrompt, history, request.getContent(), subject);
        }

        // 8. Accumulate text → save AI message khi stream hoàn tất
        StringBuilder fullText = new StringBuilder();
        Flux<String> resultFlux = streamFlux
                .doOnNext(fullText::append)
                .doOnComplete(() -> saveStreamedResponse(studentId, convId, fullText.toString()));

        return new StreamingResult(convId, resultFlux);
    }

    /**
     * Lưu AI response sau khi stream hoàn tất.
     * Chạy trong transaction riêng (vì Flux stream ngoài transaction scope).
     */
    @Transactional
    public void saveStreamedResponse(UUID studentId, UUID conversationId, String aiContent) {
        if (aiContent == null || aiContent.isBlank()) {
            log.warn("Stream completed nhưng không có nội dung AI. convId={}", conversationId);
            return;
        }

        AiMessageEntity assistantMessage = AiMessageEntity.builder()
                .conversationId(conversationId)
                .role(AiMessageRole.ASSISTANT)
                .content(aiContent)
                .build();
        messageRepository.save(assistantMessage);

        incrementUsage(studentId);
        log.info("AI streaming message saved: conversationId={}, length={}", conversationId, aiContent.length());
    }

    /** Kết quả của sendMessageStreaming — chứa convId để client refresh + Flux stream. */
    public record StreamingResult(UUID conversationId, Flux<String> textStream) {}

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

        // Lấy 10 tin gần nhất — tối ưu input tokens mà vẫn đủ context
        int fromIndex = Math.max(0, allMessages.size() - 10);
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
