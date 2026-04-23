package com.edtech.backend.ai.service;

import java.time.Duration;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;
import org.springframework.web.reactive.function.client.WebClientResponseException;

import reactor.core.publisher.Flux;
import reactor.util.retry.Retry;

/**
 * Service gọi Gemini API — tự động chọn model theo môn học.
 * STEM (Toán, Lý, Hóa, Tin) → Flash (reasoning mạnh, có thinking).
 * Non-STEM (Văn, Anh, Sinh, Sử, Địa) → Flash-Lite (chi phí thấp hơn ~80%).
 * Google Search dùng Dynamic Retrieval — chỉ search khi model cần.
 */
@Slf4j
@Service
public class GeminiService {

    private static final String GEMINI_API_BASE =
            "https://generativelanguage.googleapis.com/v1beta/models/";

    /** Model cho môn STEM — reasoning mạnh, có thinking */
    private static final String FLASH_MODEL = "gemini-2.5-flash";

    /** Model cho môn non-STEM — chi phí thấp hơn ~80%, chất lượng đủ tốt */
    private static final String FLASH_LITE_MODEL = "gemini-2.5-flash-lite";

    private static final int MAX_OUTPUT_TOKENS = 8192;
    private static final double TEMPERATURE = 0.7;

    /** Các môn STEM cần thinking (reasoning) → dùng Flash + thinking enabled */
    private static final Set<String> STEM_SUBJECTS = Set.of("Toán", "Lý", "Hóa", "Tin");
    private static final int STEM_THINKING_BUDGET = 1024;

    /** Retry config — exponential backoff cho 429/500/503 */
    private static final int MAX_RETRIES = 3;
    private static final Duration INITIAL_BACKOFF = Duration.ofSeconds(1);

    /** Dynamic retrieval — model tự quyết định khi nào cần Google Search (tiết kiệm ~70% search cost) */
    private static final double SEARCH_DYNAMIC_THRESHOLD = 0.7;

    private static final String SSE_DATA_PREFIX = "data: ";

    @Value("${gemini.api.key}")
    private String apiKey;

    private final WebClient geminiWebClient = WebClient.builder()
            .codecs(config -> config.defaultCodecs().maxInMemorySize(10 * 1024 * 1024))
            .build();

    private final ObjectMapper objectMapper = new ObjectMapper();

    // ── Public API — Blocking ─────────────────────────────────────────────

    /**
     * Gửi text prompt tới Gemini, trả về response string (blocking).
     */
    public String generateText(String systemPrompt, List<Map<String, Object>> conversationHistory,
                                String userMessage, String subject) {
        List<Map<String, Object>> contents = buildContents(conversationHistory, userMessage, null, null);
        return callGeminiBlocking(systemPrompt, contents, subject);
    }

    /**
     * Gửi multimodal prompt (text + ảnh base64) tới Gemini (blocking).
     */
    public String generateWithImage(String systemPrompt, String userMessage,
                                     String imageBase64, String imageMimeType, String subject) {
        List<Map<String, Object>> contents = buildContents(List.of(), userMessage, imageBase64, imageMimeType);
        return callGeminiBlocking(systemPrompt, contents, subject);
    }

    // ── Public API — Streaming ────────────────────────────────────────────

    /**
     * Gửi text prompt tới Gemini, trả về Flux<String> stream từng chunk text.
     * Mỗi emission là một đoạn text tiếp nối.
     */
    public Flux<String> generateTextStreaming(String systemPrompt,
                                              List<Map<String, Object>> conversationHistory,
                                              String userMessage, String subject) {
        List<Map<String, Object>> contents = buildContents(conversationHistory, userMessage, null, null);
        return callGeminiStreaming(systemPrompt, contents, subject);
    }

    /**
     * Gửi multimodal prompt streaming (text + ảnh base64).
     */
    public Flux<String> generateWithImageStreaming(String systemPrompt, String userMessage,
                                                    String imageBase64, String imageMimeType,
                                                    String subject) {
        List<Map<String, Object>> contents = buildContents(List.of(), userMessage, imageBase64, imageMimeType);
        return callGeminiStreaming(systemPrompt, contents, subject);
    }

    // ── Build request ──────────────────────────────────────────────────────

    private List<Map<String, Object>> buildContents(List<Map<String, Object>> history,
                                                     String userMessage,
                                                     String imageBase64,
                                                     String imageMimeType) {
        List<Map<String, Object>> contents = new ArrayList<>(history);
        List<Map<String, Object>> parts = new ArrayList<>();

        if (imageBase64 != null && !imageBase64.isBlank()) {
            parts.add(Map.of(
                "inlineData", Map.of(
                    "mimeType", imageMimeType != null ? imageMimeType : "image/jpeg",
                    "data", imageBase64
                )
            ));
        }

        parts.add(Map.of("text", userMessage));
        contents.add(Map.of("role", "user", "parts", parts));
        return contents;
    }

    // ── Model routing — STEM dùng Flash, non-STEM dùng Flash-Lite ─────────

    /** Chọn model phù hợp theo subject để tối ưu chi phí + chất lượng */
    private String resolveGenerateUrl(String subject) {
        return resolveModelUrl(subject) + ":generateContent";
    }

    private String resolveStreamUrl(String subject) {
        return resolveModelUrl(subject) + ":streamGenerateContent?alt=sse";
    }

    private String resolveModelUrl(String subject) {
        String model = STEM_SUBJECTS.contains(subject) ? FLASH_MODEL : FLASH_LITE_MODEL;
        log.debug("Model cho subject '{}': {}", subject, model);
        return GEMINI_API_BASE + model;
    }

    // ── Build request body ────────────────────────────────────────────────

    private Map<String, Object> buildRequestBody(String systemPrompt,
                                                  List<Map<String, Object>> contents,
                                                  String subject) {
        Map<String, Object> generationConfig = new HashMap<>();
        generationConfig.put("maxOutputTokens", MAX_OUTPUT_TOKENS);
        generationConfig.put("temperature", TEMPERATURE);

        // Chỉ bật thinking cho môn STEM — giảm output tokens cho non-STEM
        if (STEM_SUBJECTS.contains(subject)) {
            generationConfig.put("thinkingConfig", Map.of("thinkingBudget", STEM_THINKING_BUDGET));
        }

        // Dynamic retrieval — model tự quyết định khi nào cần Google Search
        Map<String, Object> dynamicSearch = Map.of(
            "google_search_retrieval", Map.of(
                "dynamic_retrieval_config", Map.of(
                    "mode", "MODE_DYNAMIC",
                    "dynamic_threshold", SEARCH_DYNAMIC_THRESHOLD
                )
            )
        );

        return Map.of(
            "system_instruction", Map.of(
                "parts", List.of(Map.of("text", systemPrompt))
            ),
            "contents", contents,
            "generationConfig", generationConfig,
            "tools", List.of(dynamicSearch)
        );
    }

    // ── Blocking call (giữ nguyên cho backward compat) ────────────────────

    @SuppressWarnings("unchecked")
    private String callGeminiBlocking(String systemPrompt,
                                      List<Map<String, Object>> contents,
                                      String subject) {
        Map<String, Object> requestBody = buildRequestBody(systemPrompt, contents, subject);

        try {
            Map<String, Object> response = geminiWebClient
                    .post()
                    .uri(resolveGenerateUrl(subject))
                    .header("x-goog-api-key", apiKey)
                    .contentType(MediaType.APPLICATION_JSON)
                    .bodyValue(requestBody)
                    .retrieve()
                    .bodyToMono(Map.class)
                    .retryWhen(buildRetrySpec())
                    .block();

            if (response == null) {
                throw new IllegalStateException("Gemini API trả về null response.");
            }

            log.debug("Gemini raw response: {}", response);
            return extractTextFromResponse(response);

        } catch (IllegalStateException e) {
            throw e;
        } catch (Exception e) {
            log.error("Lỗi gọi Gemini API: {}", e.getMessage(), e);
            throw new IllegalStateException("AI tạm thời không khả dụng. Vui lòng thử lại sau.");
        }
    }

    // ── Streaming call ────────────────────────────────────────────────────

    /**
     * Gọi Gemini streamGenerateContent, parse SSE lines → emit text chunks.
     * Mỗi SSE line format: "data: {json}" — extract text từ candidates[0].content.parts[].text
     */
    private Flux<String> callGeminiStreaming(String systemPrompt,
                                             List<Map<String, Object>> contents,
                                             String subject) {
        Map<String, Object> requestBody = buildRequestBody(systemPrompt, contents, subject);

        return geminiWebClient
                .post()
                .uri(resolveStreamUrl(subject))
                .header("x-goog-api-key", apiKey)
                .contentType(MediaType.APPLICATION_JSON)
                .bodyValue(requestBody)
                .retrieve()
                .bodyToFlux(String.class)
                .retryWhen(buildRetrySpec())
                .flatMap(this::parseSseChunk)
                .onErrorResume(e -> {
                    log.error("Lỗi streaming Gemini API: {}", e.getMessage(), e);
                    return Flux.error(
                        new IllegalStateException("AI tạm thời không khả dụng. Vui lòng thử lại sau.")
                    );
                });
    }

    // ── Retry spec ────────────────────────────────────────────────────────

    private Retry buildRetrySpec() {
        return Retry.backoff(MAX_RETRIES, INITIAL_BACKOFF)
                .filter(this::isRetryableError)
                .doBeforeRetry(signal ->
                    log.warn("Gemini API retry #{} sau lỗi: {}",
                             signal.totalRetries() + 1,
                             signal.failure().getMessage())
                )
                .onRetryExhaustedThrow((spec, signal) -> {
                    log.error("Gemini API hết {} lần retry", MAX_RETRIES);
                    return new IllegalStateException(
                        "AI tạm thời không khả dụng sau " + MAX_RETRIES + " lần thử. Vui lòng thử lại sau."
                    );
                });
    }

    private boolean isRetryableError(Throwable throwable) {
        if (throwable instanceof WebClientResponseException wcre) {
            int status = wcre.getStatusCode().value();
            return status == 429 || status == 500 || status == 503;
        }
        return false;
    }

    // ── SSE parsing ───────────────────────────────────────────────────────

    /**
     * Parse 1 SSE chunk raw → extract text.
     * Gemini SSE format: mỗi chunk là 1 JSON object hoàn chỉnh
     * chứa candidates[0].content.parts[].text
     */
    @SuppressWarnings("unchecked")
    private Flux<String> parseSseChunk(String rawChunk) {
        // SSE lines có thể chứa nhiều "data:" prefix
        String[] lines = rawChunk.split("\n");
        List<String> textChunks = new ArrayList<>();

        for (String line : lines) {
            String trimmed = line.trim();
            if (!trimmed.startsWith(SSE_DATA_PREFIX)) {
                continue;
            }

            String jsonStr = trimmed.substring(SSE_DATA_PREFIX.length()).trim();
            if (jsonStr.isEmpty() || "[DONE]".equals(jsonStr)) {
                continue;
            }

            try {
                Map<String, Object> chunk = objectMapper.readValue(jsonStr, Map.class);
                String extracted = extractTextFromStreamChunk(chunk);
                if (extracted != null && !extracted.isEmpty()) {
                    textChunks.add(extracted);
                }
            } catch (JsonProcessingException e) {
                log.debug("Bỏ qua SSE chunk không parse được: {}", jsonStr);
            }
        }

        return Flux.fromIterable(textChunks);
    }

    /**
     * Extract text từ 1 stream chunk JSON.
     * Bỏ qua thought parts (thought=true).
     */
    @SuppressWarnings("unchecked")
    private String extractTextFromStreamChunk(Map<String, Object> chunk) {
        List<Map<String, Object>> candidates =
                (List<Map<String, Object>>) chunk.get("candidates");
        if (candidates == null || candidates.isEmpty()) {
            return null;
        }

        Map<String, Object> content =
                (Map<String, Object>) candidates.get(0).get("content");
        if (content == null) {
            return null;
        }

        List<Map<String, Object>> parts =
                (List<Map<String, Object>>) content.get("parts");
        if (parts == null || parts.isEmpty()) {
            return null;
        }

        StringBuilder result = new StringBuilder();
        for (Map<String, Object> part : parts) {
            // Bỏ qua thought parts
            if (Boolean.TRUE.equals(part.get("thought"))) {
                continue;
            }
            Object textObj = part.get("text");
            if (textObj != null && !textObj.toString().isEmpty()) {
                result.append(textObj);
            }
        }

        return result.isEmpty() ? null : result.toString();
    }

    // ── Extract text từ blocking response (giữ nguyên) ────────────────────

    @SuppressWarnings("unchecked")
    private String extractTextFromResponse(Map<String, Object> response) {
        List<Map<String, Object>> candidates = (List<Map<String, Object>>) response.get("candidates");
        if (candidates == null || candidates.isEmpty()) {
            log.error("Gemini response không có candidates. Full response: {}", response);
            throw new IllegalStateException("Gemini không trả về kết quả.");
        }

        Map<String, Object> firstCandidate = candidates.get(0);

        String finishReason = (String) firstCandidate.get("finishReason");
        if ("SAFETY".equals(finishReason)) {
            log.warn("Gemini từ chối trả lời vì lý do an toàn: {}", firstCandidate);
            return "Xin lỗi, mình không thể trả lời câu hỏi này. Bạn hãy hỏi câu khác liên quan đến bài học nhé! 😊";
        }

        Map<String, Object> content = (Map<String, Object>) firstCandidate.get("content");
        if (content == null) {
            log.error("Gemini candidate không có content. finishReason={}, candidate={}", finishReason, firstCandidate);
            throw new IllegalStateException("Gemini không trả về nội dung.");
        }

        List<Map<String, Object>> parts = (List<Map<String, Object>>) content.get("parts");
        if (parts == null || parts.isEmpty()) {
            log.error("Gemini content không có parts. content={}", content);
            throw new IllegalStateException("Gemini không trả về nội dung chi tiết.");
        }

        StringBuilder textResult = new StringBuilder();
        for (Map<String, Object> part : parts) {
            Object thoughtFlag = part.get("thought");
            if (Boolean.TRUE.equals(thoughtFlag)) {
                continue;
            }
            Object textObj = part.get("text");
            if (textObj != null) {
                String text = textObj.toString();
                if (!text.isBlank()) {
                    textResult.append(text);
                }
            }
        }

        if (textResult.isEmpty()) {
            log.warn("Không tìm thấy text thường, fallback lấy thought text. Parts: {}", parts);
            for (Map<String, Object> part : parts) {
                Object textObj = part.get("text");
                if (textObj != null && !textObj.toString().isBlank()) {
                    textResult.append(textObj.toString());
                }
            }
        }

        if (textResult.isEmpty()) {
            log.error("Không tìm thấy text trong bất kỳ part nào: {}", parts);
            throw new IllegalStateException("AI không trả về nội dung. Vui lòng thử lại.");
        }

        return textResult.toString();
    }
}
