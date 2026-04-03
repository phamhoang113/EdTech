package com.edtech.backend.admin.dto;

import java.time.LocalDate;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class UpdateLearningStartDateRequest {
    private LocalDate learningStartDate;
}
