package com.edtech.backend.tutor.dto.response;

import java.util.List;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class ClassFilterResponse {
    private List<String> subjects;
    private List<String> levels;
    private List<String> genders;
    private List<String> tutorLevels;
}
