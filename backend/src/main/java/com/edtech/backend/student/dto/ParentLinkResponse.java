package com.edtech.backend.student.dto;

import java.time.Instant;
import java.util.UUID;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class ParentLinkResponse {
    private UUID id;            // student_profile.id
    private UUID parentId;      // user.id của phụ huynh
    private String parentName;  // Tên phụ huynh
    private String parentPhone; // SĐT phụ huynh
    private String linkStatus;  // PENDING | ACCEPTED
    private String initiatedBy; // Mới thêm: PARENT | STUDENT
    private Instant createdAt;
}
