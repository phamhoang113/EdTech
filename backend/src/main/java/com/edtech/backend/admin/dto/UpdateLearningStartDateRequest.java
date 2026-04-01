package com.edtech.backend.admin.dto;

import lombok.Getter;
import lombok.Setter;
import java.time.LocalDate;

@Getter
@Setter
public class UpdateLearningStartDateRequest {
    private LocalDate learningStartDate;
}
