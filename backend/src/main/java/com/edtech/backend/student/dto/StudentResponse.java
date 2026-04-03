package com.edtech.backend.student.dto;

import java.time.Instant;
import java.util.UUID;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class StudentResponse {

    private UUID id;           // student_profile.id
    private UUID userId;       // user.id của học sinh
    private String fullName;
    private String phone;      // SĐT học sinh (nếu có)
    private String grade;
    private String school;
    private String avatarBase64;
    private Instant createdAt;

    // Fields for newly created accounts without phone
    private String username;
    private String defaultPassword;
    private String linkStatus;
    private String initiatedBy; // Mới thêm: PARENT | STUDENT
}
