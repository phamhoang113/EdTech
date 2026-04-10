package com.edtech.backend.auth.dto;

import lombok.Getter;
import lombok.Setter;

/**
 * Request DTO để cập nhật profile chung (Parent, Student).
 * Chỉ chứa các fields có thể sửa.
 */
@Getter
@Setter
public class UpdateUserProfileRequest {
    private String phone;
    private String email;
    private String avatarBase64;
    private String address;
    private String school;
    private String grade;
}
