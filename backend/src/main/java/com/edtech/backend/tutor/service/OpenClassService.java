package com.edtech.backend.tutor.service;

import com.edtech.backend.core.enums.ClassMode;
import com.edtech.backend.core.enums.ClassStatus;
import com.edtech.backend.tutor.dto.response.OpenClassResponse;
import com.edtech.backend.tutor.repository.ClassRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.edtech.backend.tutor.dto.response.ClassFilterResponse;
import com.edtech.backend.tutor.enums.Gender;
import com.edtech.backend.tutor.enums.GradeLevel;
import com.edtech.backend.tutor.enums.Subject;
import com.edtech.backend.tutor.enums.TutorType;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.core.type.TypeReference;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class OpenClassService {

    private final ClassRepository classRepository;
    private final ObjectMapper objectMapper;

    public List<OpenClassResponse> getAllOpenClasses() {
        return classRepository.findByStatusAndIsDeletedFalseOrderByCreatedAtDesc(ClassStatus.OPEN).stream()
                .map(entity -> {
                    String location = entity.getMode() == ClassMode.ONLINE ? "Online" : entity.getAddress();
                    
                    BigDecimal minTutorFee = entity.getTutorFee();
                    BigDecimal maxTutorFee = entity.getTutorFee();
                    List<String> requiredLevels = new ArrayList<>();

                    if (entity.getLevelFees() != null && !entity.getLevelFees().isEmpty()) {
                        try {
                            List<Map<String, Object>> feeList = objectMapper.readValue(entity.getLevelFees(), new TypeReference<List<Map<String, Object>>>(){});
                            if (!feeList.isEmpty()) {
                                minTutorFee = null;
                                maxTutorFee = null;
                                for (Map<String, Object> feeObj : feeList) {
                                    if (feeObj.containsKey("level")) {
                                        requiredLevels.add((String) feeObj.get("level"));
                                    }
                                    if (feeObj.containsKey("tutor_fee")) {
                                        BigDecimal tFee = new BigDecimal(feeObj.get("tutor_fee").toString());
                                        if (minTutorFee == null || tFee.compareTo(minTutorFee) < 0) minTutorFee = tFee;
                                        if (maxTutorFee == null || tFee.compareTo(maxTutorFee) > 0) maxTutorFee = tFee;
                                    }
                                }
                            }
                        } catch (Exception e) {
                            log.error("Failed to parse levelFees JSON", e);
                        }
                    }

                    // Fallbacks if JSON mapping fails or is empty
                    if (requiredLevels.isEmpty()) {
                        requiredLevels = List.of(
                                TutorType.STUDENT.getDisplayName(),
                                TutorType.TEACHER.getDisplayName()
                        );
                    }
                    if (minTutorFee == null) minTutorFee = entity.getTutorFee() != null ? entity.getTutorFee() : BigDecimal.ZERO;
                    if (maxTutorFee == null) maxTutorFee = entity.getTutorFee() != null ? entity.getTutorFee() : BigDecimal.ZERO;

                    return OpenClassResponse.builder()
                            .id(entity.getId())
                            .title(entity.getTitle())
                            .subject(entity.getSubject())
                            .grade(entity.getGrade())
                            .location(location)
                            .schedule(entity.getSchedule())
                            .timeFrame(entity.getTimeFrame())
                            .classCode(entity.getClassCode() != null ? entity.getClassCode() : entity.getId().toString().substring(0, 6).toUpperCase())
                            .feePercentage(entity.getFeePercentage() != null ? entity.getFeePercentage() : 30)
                            .parentFee(entity.getParentFee())
                            .minTutorFee(minTutorFee)
                            .maxTutorFee(maxTutorFee)
                            .tutorLevelRequirement(requiredLevels)
                            .genderRequirement(entity.getGenderRequirement() != null ? entity.getGenderRequirement() : "Không yêu cầu")
                            .sessionsPerWeek(entity.getSessionsPerWeek() != null ? entity.getSessionsPerWeek() : 1)
                            .sessionDurationMin(entity.getSessionDurationMin() != null ? entity.getSessionDurationMin() : 90)
                            .studentCount(1) // Placeholder for UI until class_students logic is fully handled
                            .build();
                })
                .collect(Collectors.toList());
    }

    public ClassFilterResponse getClassFilters() {
        // Single Source of Truth: derive all filter options from canonical enums
        List<String> subjects = Arrays.stream(Subject.values())
                .map(Subject::getDisplayName)
                .collect(Collectors.toList());
        List<String> tutorLevels = Arrays.stream(TutorType.values())
                .map(TutorType::getDisplayName)
                .collect(Collectors.toList());
        List<String> levels = Arrays.stream(GradeLevel.values())
                .map(GradeLevel::getDisplayName)
                .collect(Collectors.toList());
        List<String> genders = Arrays.stream(Gender.values())
                .map(Gender::getDisplayName)
                .collect(Collectors.toList());
        return ClassFilterResponse.builder()
                .subjects(subjects)
                .levels(levels)
                .genders(genders)
                .tutorLevels(tutorLevels)
                .build();
    }
}
