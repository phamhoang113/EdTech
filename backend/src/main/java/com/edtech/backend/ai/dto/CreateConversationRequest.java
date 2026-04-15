package com.edtech.backend.ai.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;

/** Request tạo conversation mới. */
@Getter
@NoArgsConstructor
public class CreateConversationRequest {

    /** Môn học (optional, lấy từ class context nếu có) */
    private String subject;

    /** Lớp (optional) */
    private String grade;
}
