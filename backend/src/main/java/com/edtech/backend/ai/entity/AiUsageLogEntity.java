package com.edtech.backend.ai.entity;

import java.time.LocalDate;
import java.util.UUID;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import jakarta.persistence.UniqueConstraint;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import com.edtech.backend.core.entity.BaseEntity;

/**
 * Tracking số tin nhắn AI theo ngày.
 * Trial: tối đa 20 tin/ngày. Paid: tối đa 100 tin/ngày.
 */
@Entity
@Table(
    name = "ai_usage_log",
    uniqueConstraints = @UniqueConstraint(columnNames = {"student_id", "log_date"})
)
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AiUsageLogEntity extends BaseEntity {

    @Column(name = "student_id", nullable = false)
    private UUID studentId;

    @Column(name = "log_date", nullable = false)
    private LocalDate logDate;

    @Column(name = "message_count", nullable = false)
    @Builder.Default
    private Integer messageCount = 0;
}
