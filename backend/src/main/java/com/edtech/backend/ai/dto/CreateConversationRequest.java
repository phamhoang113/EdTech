package com.edtech.backend.ai.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Getter;
import lombok.NoArgsConstructor;

/** Request tạo conversation mới — bắt buộc chọn môn học. */
@Getter
@NoArgsConstructor
public class CreateConversationRequest {

    /** Môn học — bắt buộc, phải nằm trong danh sách 9 môn cố định */
    @NotBlank(message = "Vui lòng chọn môn học")
    private String subject;

    /** Lớp (optional) */
    private String grade;
}
