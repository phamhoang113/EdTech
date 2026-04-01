package com.edtech.backend.auth.dto;

import lombok.Builder;
import lombok.Getter;

/**
 * Response DTO chứa thông tin profile chung cho mọi role (Parent, Student).
 * Tutor có endpoint riêng với nhiều fields hơn.
 */
@Getter
@Builder
public class UserProfileResponse {
    private final String fullName;
    private final String phone;
    private final String email;
    private final String avatarBase64;
    private final String role;
    private final String address;
    private final String school;
    private final String grade;
}
