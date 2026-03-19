package com.edtech.backend.tutor.dto.response;

import com.edtech.backend.tutor.enums.TutorType;
import com.edtech.backend.tutor.enums.VerificationStatus;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.util.UUID;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AdminTutorVerificationResponse {
    private UUID id; // userId
    private String name;
    private String[] subjects;
    private String date; // Có thể dùng createDate nhưng entity hiện tại ko expose dễ trực tiếp. Tạm dùng dateOfBirth hoặc ngày hiện tại trên FE. 
    private VerificationStatus status;
    private String phone;
    private String idCardNumber; // Số CCCD
    private String dob;
    private String university; // Map từ achievements
    private String degree; // Map từ tutorType hoặc level
    private String gradYear; // Bỏ trống hoặc map từ experienceYears
    private String experience; // "X năm" từ experienceYears
    private String levels; // join từ teachingLevels
    private String location; // Khu vực dạy
    
    @Builder.Default
    private java.util.List<DocItem> docs = new java.util.ArrayList<>();

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class DocItem {
        private String name;
        private String icon;
        private String url;
    }
}
