package com.edtech.backend.ai.entity;

import java.util.UUID;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import com.edtech.backend.core.entity.BaseEntity;

/**
 * Một cuộc hội thoại AI của học sinh.
 * Mỗi conversation có context môn học + lớp để AI trả lời đúng chủ đề.
 */
@Entity
@Table(name = "ai_conversation")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AiConversationEntity extends BaseEntity {

    @Column(name = "student_id", nullable = false)
    private UUID studentId;

    /** Tự sinh từ câu hỏi đầu tiên của HS (tối đa 200 ký tự) */
    @Column(name = "title", length = 200)
    private String title;

    /** Môn học từ context lớp học (Toán, Văn, Anh...) */
    @Column(name = "subject", length = 100)
    private String subject;

    /** Lớp học (Lớp 10, Lớp 11...) */
    @Column(name = "grade", length = 50)
    private String grade;

    /** Mục tiêu học tập — HS tự đặt (VD: "Ôn thi giữa kỳ chương 3-4", "Luyện đạo hàm") */
    @Column(name = "learning_goal", length = 500)
    private String learningGoal;
}
