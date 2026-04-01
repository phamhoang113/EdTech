package com.edtech.backend.tutor.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.UUID;

@Getter
@Setter
public class TutorAbsenceReqDTO {
    @NotNull(message = "Session ID cannot be null")
    private UUID sessionId;

    @NotBlank(message = "Lý do xin nghỉ không được để trống")
    private String reason;

    private LocalDate makeupDate;
    private LocalTime makeupTime;
    private String proofUrl;
}
