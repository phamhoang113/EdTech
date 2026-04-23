package com.edtech.backend.ai.dto;

import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.NoArgsConstructor;

/** Request cập nhật conversation — hiện hỗ trợ cập nhật mục tiêu học tập. */
@Getter
@NoArgsConstructor
public class UpdateConversationRequest {

    /** Mục tiêu học tập — VD: "Ôn thi giữa kỳ chương 3-4", "Luyện đạo hàm" */
    @Size(max = 500, message = "Mục tiêu tối đa 500 ký tự")
    private String learningGoal;
}
