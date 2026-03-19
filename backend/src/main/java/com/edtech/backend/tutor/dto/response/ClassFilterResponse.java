package com.edtech.backend.tutor.dto.response;

import lombok.Builder;
import lombok.Getter;

import java.util.List;

@Getter
@Builder
public class ClassFilterResponse {
    private List<String> subjects;
    private List<String> levels;
    private List<String> genders;
    private List<String> tutorLevels;
}
