package com.edtech.backend.admin.dto;

import java.time.Instant;
import java.util.UUID;

import lombok.Builder;
import lombok.Getter;

import com.edtech.backend.auth.enums.UserRole;

/** Thông tin user cho trang Quản lý người dùng của Admin */
@Getter
@Builder
public class AdminUserListItem {
    UUID id;
    String fullName;
    String email;
    String phone;
    UserRole role;
    Boolean isActive;
    Boolean isDeleted;
    Instant createdAt;
}
