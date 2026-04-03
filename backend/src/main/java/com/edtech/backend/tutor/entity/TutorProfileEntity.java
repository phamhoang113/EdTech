package com.edtech.backend.tutor.entity;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.UUID;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.Table;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

import com.edtech.backend.core.entity.BaseEntity;
import com.edtech.backend.tutor.enums.TutorType;
import com.edtech.backend.tutor.enums.VerificationStatus;

@Entity
@Table(name = "tutor_profiles")
@Getter
@Setter
@Builder
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
public class TutorProfileEntity extends BaseEntity {

    @Column(name = "user_id", nullable = false, unique = true)
    private UUID userId;

    @Column(name = "bio", columnDefinition = "TEXT")
    private String bio;

    @JdbcTypeCode(SqlTypes.ARRAY)
    @Column(name = "subjects", columnDefinition = "text[]")
    @Builder.Default
    private String[] subjects = new String[0];


    @Column(name = "location", length = 255)
    private String location;

    @Column(name = "teaching_mode", length = 20, nullable = false)
    @Builder.Default
    private String teachingMode = "BOTH";

    @Column(name = "hourly_rate")
    private BigDecimal hourlyRate;

    @Column(name = "rating", nullable = false)
    @Builder.Default
    private BigDecimal rating = BigDecimal.valueOf(5.0);

    @Column(name = "rating_count", nullable = false)
    @Builder.Default
    private Integer ratingCount = 1;

    @Column(name = "id_card_number", length = 20)
    private String idCardNumber;


    @JdbcTypeCode(SqlTypes.ARRAY)
    @Column(name = "cert_base64s", columnDefinition = "text[]")
    @Builder.Default
    private String[] certBase64s = new String[0];

    @Enumerated(EnumType.STRING)
    @JdbcTypeCode(SqlTypes.NAMED_ENUM)
    @Column(name = "verification_status", nullable = false, length = 20)
    @Builder.Default
    private VerificationStatus verificationStatus = VerificationStatus.UNVERIFIED;

    @Enumerated(EnumType.STRING)
    @JdbcTypeCode(SqlTypes.NAMED_ENUM)
    @Column(name = "tutor_type", length = 50)
    private TutorType tutorType;

    /** Ngày tháng năm sinh gia sư */
    @Column(name = "date_of_birth")
    private LocalDate dateOfBirth;

    /** Các khối / lớp gia sư có thể giảng dạy, tối đa 5 (e.g. Lớp 1, Lớp 2,...) */
    @JdbcTypeCode(SqlTypes.ARRAY)
    @Column(name = "teaching_levels", columnDefinition = "text[]")
    @Builder.Default
    private String[] teachingLevels = new String[0];

    /** Thành tích nổi bật, giải thưởng, kinh nghiệm dạy học (tự do nhập) */
    @Column(name = "achievements", columnDefinition = "TEXT")
    private String achievements;

    /** Số năm kinh nghiệm giảng dạy */
    @Column(name = "experience_years")
    @Builder.Default
    private Integer experienceYears = 0;

    // --- Thông tin ngân hàng nhận thù lao ---
    @Column(name = "bank_name", length = 100)
    private String bankName;

    @Column(name = "bank_account_number", length = 50)
    private String bankAccountNumber;

    @Column(name = "bank_owner_name", length = 150)
    private String bankOwnerName;
    
    @Column(name = "is_mock")
    @Builder.Default
    private Boolean isMock = false;
}
