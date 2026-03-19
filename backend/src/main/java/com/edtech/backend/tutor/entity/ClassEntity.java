package com.edtech.backend.tutor.entity;

import com.edtech.backend.core.entity.BaseEntity;
import com.edtech.backend.core.enums.ClassMode;
import com.edtech.backend.core.enums.ClassStatus;
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

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.UUID;

@Entity
@Table(name = "classes")
@Getter
@Setter
@Builder
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
public class ClassEntity extends BaseEntity {

    @Column(name = "admin_id", nullable = false)
    private UUID adminId;

    @Column(name = "parent_id", nullable = false)
    private UUID parentId;

    @Column(name = "tutor_id")
    private UUID tutorId;

    @Column(name = "title", nullable = false)
    private String title;

    @Column(name = "subject", nullable = false, length = 100)
    private String subject;

    @Column(name = "grade", nullable = false, length = 50)
    private String grade;

    @Column(name = "description", columnDefinition = "TEXT")
    private String description;

    @Enumerated(EnumType.STRING)
    @JdbcTypeCode(SqlTypes.NAMED_ENUM)
    @Column(name = "mode", nullable = false)
    private ClassMode mode;

    @Column(name = "address", length = 500)
    private String address;

    @Column(name = "schedule", nullable = false, columnDefinition = "jsonb")
    @JdbcTypeCode(SqlTypes.JSON)
    private String schedule;

    @Column(name = "sessions_per_week", nullable = false)
    private Integer sessionsPerWeek;

    @Column(name = "session_duration_min", nullable = false)
    private Integer sessionDurationMin;

    @Column(name = "parent_fee", nullable = false)
    private BigDecimal parentFee;

    @Column(name = "tutor_fee")
    private BigDecimal tutorFee;

    @Column(name = "platform_fee", nullable = false)
    private BigDecimal platformFee;

    @Enumerated(EnumType.STRING)
    @JdbcTypeCode(SqlTypes.NAMED_ENUM)
    @Column(name = "status", nullable = false)
    private ClassStatus status;

    @Column(name = "time_frame", length = 100)
    private String timeFrame;

    @Column(name = "start_date")
    private LocalDate startDate;

    @Column(name = "end_date")
    private LocalDate endDate;

    @Column(name = "is_deleted", nullable = false)
    private Boolean isDeleted = false;

    // V20 NEW FIELDS
    @Column(name = "class_code", length = 6)
    private String classCode;

    @Column(name = "fee_percentage")
    private Integer feePercentage;

    @Column(name = "level_fees", columnDefinition = "jsonb")
    @JdbcTypeCode(SqlTypes.JSON)
    private String levelFees;

    @Column(name = "gender_requirement", length = 50)
    private String genderRequirement;
}
