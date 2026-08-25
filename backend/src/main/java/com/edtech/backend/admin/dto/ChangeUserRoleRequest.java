package com.edtech.backend.admin.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;

import com.edtech.backend.auth.enums.UserRole;

@Getter
@Setter
public class ChangeUserRoleRequest {

    @NotNull(message = "Vai trò mới không được để trống")
    private UserRole role;
}
