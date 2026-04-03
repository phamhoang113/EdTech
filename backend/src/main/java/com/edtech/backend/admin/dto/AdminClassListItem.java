package com.edtech.backend.admin.dto;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

import lombok.Builder;
import lombok.Value;

import com.edtech.backend.cls.enums.ClassStatus;

@Value
@Builder
public class AdminClassListItem {
    UUID id;
    String classCode;
    Boolean isMock;
    String title;
    String subject;
    String grade;
    String mode;
    String address;

    // Parent info
    String parentName;
    String parentPhone;

    // Tutor info (null nếu chưa được assign)
    String tutorName;
    String tutorPhone;
    String tutorType;

    // Fees
    BigDecimal parentFee;
    BigDecimal tutorFee;
    BigDecimal platformFee;
    Integer feePercentage;

    // Schedule
    Integer sessionsPerWeek;
    Integer sessionDurationMin;
    String timeFrame;
    String schedule;
    String genderRequirement;
    LocalDate learningStartDate;
    /** JSON array levelFees: [{level, fee}] — dùng khi lớp OPEN để hiển thị bảng học phí */
    String levelFees;
    /** JSON array tutorProposals: [{level, fee}] — lưu lương trung tâm đề xuất cho Gia sư */
    String tutorProposals;
    /** Lý do từ chối (chỉ có khi status = CANCELLED) */
    String rejectionReason;

    // Quota Warnings
    Integer missingSessionsThisWeek;
    Integer pendingMakeupCount;

    ClassStatus status;
    /** True nếu admin đã đề xuất GS cho PH nhưng PH chưa chọn (tutor_proposals không rỗng) */
    boolean hasPendingProposals;
    long pendingApplicationCount;
    Instant createdAt;
    List<UUID> studentIds;
}
