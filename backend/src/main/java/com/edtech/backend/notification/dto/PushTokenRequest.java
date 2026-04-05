package com.edtech.backend.notification.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PushTokenRequest {

    @NotBlank(message = "FCM token không được để trống")
    private String token;

    @Builder.Default
    private String deviceType = "WEB";
}
