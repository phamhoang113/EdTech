package com.edtech.backend.student.entity;

import java.util.UUID;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import com.edtech.backend.auth.entity.UserEntity;
import com.edtech.backend.core.entity.BaseEntity;

@Entity
@Table(name = "student_profiles")
@Getter
@Setter
@Builder
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
public class StudentProfileEntity extends BaseEntity {

    /** User account của học sinh (role = STUDENT) */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private UserEntity user;

    /** UUID của phụ huynh sở hữu */
    @Column(name = "parent_id", nullable = false)
    private UUID parentId;

    /** Khối/lớp học (vd: Lớp 6, Lớp 10, ...) */
    @Column(length = 50)
    private String grade;

    /** Trường đang học */
    @Column(length = 255)
    private String school;

    /** Trạng thái liên kết với phụ huynh */
    @Column(name = "link_status", length = 20, nullable = false)
    @Builder.Default
    private String linkStatus = "ACCEPTED";

    /** Ai là người gửi yêu cầu liên kết (PARENT hoặc STUDENT) */
    @Column(name = "initiated_by", length = 20, nullable = false)
    @Builder.Default
    private String initiatedBy = "PARENT";
}
