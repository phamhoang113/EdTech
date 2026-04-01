package com.edtech.backend.admin.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.util.List;
import java.util.UUID;

@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ScheduleSuggestDTO {

    private List<TutorSuggestion> tutors;
    private List<ClassSuggestion> classes;

    @Getter
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class TutorSuggestion {
        private UUID id;
        private String fullName;
        private String phone;
    }

    @Getter
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class ClassSuggestion {
        private UUID id;
        private String classCode;
        private String title;
        private String subject;
    }
}
