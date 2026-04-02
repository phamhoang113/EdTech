package com.edtech.backend.tutor.dto.response;

import com.edtech.backend.cls.enums.ApplicationStatus;
import lombok.Builder;
import lombok.Getter;

import java.time.Instant;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

@Getter
@Builder
public class ClassApplicationResponse {
    private UUID applicationId;
    private UUID classId;
    private String classTitle;
    private String classCode;
    private Boolean isMockClass;
    private String description;
    private String subject;
    private String grade;
    private String location;
    private String timeFrame;
    private String schedule;
    private Integer sessionsPerWeek;
    private Integer sessionDurationMin;
    private Integer studentCount;
    private String genderRequirement;
    private String levelFees;
    private String tutorProposals;
    private Integer feePercentage;
    private List<String> tutorLevelRequirement;
    // Tutor info
    private UUID tutorId;
    private String tutorName;
    private String tutorPhone;
    private String tutorType;
    private LocalDate dateOfBirth;   // Năm sinh
    private String achievements;     // Bằng cấp / kinh nghiệm
    private java.math.BigDecimal rating;   // Đánh giá sao trung bình
    private Integer ratingCount;           // Tổng lượt đánh giá
    private String[] certBase64s;          // Ảnh bằng cấp base64
    // Tutor stats (thống kê cho admin)
    private long tutorActiveClassesCount;
    private long tutorPendingApplicationsCount;
    // Parent info
    private String parentPhone;
    // Application info
    private ApplicationStatus status;
    private String note;
    private java.math.BigDecimal proposedSalary;
    private Instant appliedAt;       // Đổi tên từ createdAt
}
