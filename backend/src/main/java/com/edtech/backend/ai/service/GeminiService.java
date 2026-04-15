package com.edtech.backend.ai.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;

/**
 * Service gọi Gemini 2.0 Flash API.
 * Hỗ trợ: text-only và multimodal (text + ảnh base64).
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class GeminiService {

    private static final String GEMINI_API_URL =
            "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent";

    private static final int MAX_OUTPUT_TOKENS = 2048;

    @Value("${gemini.api.key}")
    private String apiKey;

    private final WebClient webClient = WebClient.builder().build();

    /**
     * Gửi text prompt tới Gemini, trả về response string.
     */
    public String generateText(String systemPrompt, List<Map<String, Object>> conversationHistory,
                                String userMessage) {
        List<Map<String, Object>> contents = buildContents(conversationHistory, userMessage, null, null);
        return callGemini(systemPrompt, contents);
    }

    /**
     * Gửi multimodal prompt (text + ảnh base64) tới Gemini.
     * Dùng cho tính năng "Chụp ảnh → AI giải bài".
     */
    public String generateWithImage(String systemPrompt, String userMessage,
                                     String imageBase64, String imageMimeType) {
        List<Map<String, Object>> contents = buildContents(List.of(), userMessage, imageBase64, imageMimeType);
        return callGemini(systemPrompt, contents);
    }

    // ── Private helpers ────────────────────────────────────────────────────

    private List<Map<String, Object>> buildContents(List<Map<String, Object>> history,
                                                     String userMessage,
                                                     String imageBase64,
                                                     String imageMimeType) {
        List<Map<String, Object>> contents = new ArrayList<>(history);

        List<Map<String, Object>> parts = new ArrayList<>();

        // Thêm ảnh nếu có (camera solver)
        if (imageBase64 != null && !imageBase64.isBlank()) {
            parts.add(Map.of(
                "inlineData", Map.of(
                    "mimeType", imageMimeType != null ? imageMimeType : "image/jpeg",
                    "data", imageBase64
                )
            ));
        }

        // Thêm text message
        parts.add(Map.of("text", userMessage));

        contents.add(Map.of("role", "user", "parts", parts));
        return contents;
    }

    @SuppressWarnings("unchecked")
    private String callGemini(String systemPrompt, List<Map<String, Object>> contents) {
        Map<String, Object> requestBody = Map.of(
            "system_instruction", Map.of(
                "parts", List.of(Map.of("text", systemPrompt))
            ),
            "contents", contents,
            "generationConfig", Map.of(
                "maxOutputTokens", MAX_OUTPUT_TOKENS,
                "temperature", 0.7
            )
        );

        try {
            Map<String, Object> response = webClient.post()
                    .uri(GEMINI_API_URL + "?key=" + apiKey)
                    .contentType(MediaType.APPLICATION_JSON)
                    .bodyValue(requestBody)
                    .retrieve()
                    .bodyToMono(Map.class)
                    .block();

            if (response == null) {
                throw new IllegalStateException("Gemini API trả về null response.");
            }

            // Parse: response.candidates[0].content.parts[0].text
            List<Map<String, Object>> candidates = (List<Map<String, Object>>) response.get("candidates");
            if (candidates == null || candidates.isEmpty()) {
                throw new IllegalStateException("Gemini không trả về kết quả.");
            }

            Map<String, Object> content = (Map<String, Object>) candidates.get(0).get("content");
            List<Map<String, Object>> parts = (List<Map<String, Object>>) content.get("parts");
            return (String) parts.get(0).get("text");

        } catch (Exception e) {
            log.error("Lỗi gọi Gemini API: {}", e.getMessage(), e);
            throw new IllegalStateException("AI tạm thời không khả dụng. Vui lòng thử lại sau.");
        }
    }
}
