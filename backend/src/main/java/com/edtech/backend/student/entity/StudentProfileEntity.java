package com.edtech.backend.student.entity;

import com.edtech.backend.auth.entity.UserEntity;
import com.edtech.backend.core.entity.BaseEntity;
import jakarta.persistence.*;
import lombok.*;

import java.util.UUID;

@Entity
@Table(name = "student_profiles")
@Getter
@Setter
@Builder
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
public class StudentProfileEntity extends BaseEntity {

    /** User account của học sinh (role = STUDENT) */
    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false, unique = true)
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
}
