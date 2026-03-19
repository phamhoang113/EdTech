package com.edtech.backend.tutor.service;

import com.edtech.backend.auth.entity.UserEntity;
import com.edtech.backend.auth.repository.UserRepository;
import com.edtech.backend.core.exception.EntityNotFoundException;
import com.edtech.backend.tutor.dto.response.AdminTutorVerificationResponse;
import com.edtech.backend.tutor.entity.TutorProfileEntity;
import com.edtech.backend.tutor.enums.VerificationStatus;
import com.edtech.backend.tutor.repository.TutorProfileRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class AdminTutorService {

    private final TutorProfileRepository tutorProfileRepository;
    private final UserRepository userRepository;

    public List<AdminTutorVerificationResponse> getAllVerifications() {
        // Fetch all tutor profiles
        List<TutorProfileEntity> profiles = tutorProfileRepository.findAll().stream()
                .filter(p -> p.getVerificationStatus() != VerificationStatus.UNVERIFIED)
                .collect(Collectors.toList());

        if (profiles.isEmpty()) {
            return new ArrayList<>();
        }

        // Fetch corresponding users
        List<UUID> userIds = profiles.stream().map(TutorProfileEntity::getUserId).collect(Collectors.toList());
        Map<UUID, UserEntity> userMap = userRepository.findAllById(userIds).stream()
                .collect(Collectors.toMap(UserEntity::getId, u -> u));

        // Map to Response
        return profiles.stream().map(profile -> {
            UserEntity user = userMap.get(profile.getUserId());
            if (user == null || user.getIsDeleted()) {
                return null;
            }
            return mapToAdminResponse(profile, user);
        }).filter(java.util.Objects::nonNull).collect(Collectors.toList());
    }

    @Transactional
    public void approveTutor(UUID userId, java.math.BigDecimal rate) {
        TutorProfileEntity profile = tutorProfileRepository.findByUserId(userId)
                .orElseThrow(() -> new EntityNotFoundException("Không tìm thấy hồ sơ Gia sư cho user ID: " + userId));

        if (profile.getVerificationStatus() != VerificationStatus.PENDING) {
            throw new IllegalArgumentException("Hồ sơ không ở trạng thái chờ duyệt.");
        }

        profile.setHourlyRate(rate);
        profile.setVerificationStatus(VerificationStatus.APPROVED);
        tutorProfileRepository.save(profile);
        log.info("Admin approved tutor profile for user {} with hourlyRate={}", userId, rate);
    }

    @Transactional
    public void rejectTutor(UUID userId) {
        TutorProfileEntity profile = tutorProfileRepository.findByUserId(userId)
                .orElseThrow(() -> new EntityNotFoundException("Không tìm thấy hồ sơ Gia sư cho user ID: " + userId));

        if (profile.getVerificationStatus() != VerificationStatus.PENDING) {
            throw new IllegalArgumentException("Hồ sơ không ở trạng thái chờ duyệt.");
        }

        profile.setVerificationStatus(VerificationStatus.REJECTED);
        tutorProfileRepository.save(profile);
        log.info("Admin rejected tutor profile for user {}", userId);
    }

    private AdminTutorVerificationResponse mapToAdminResponse(TutorProfileEntity profile, UserEntity user) {
        List<AdminTutorVerificationResponse.DocItem> docs = new ArrayList<>();
        
        // Only cert (degree/certificate) images are stored - CCCD is number only
        if (profile.getCertBase64s() != null && profile.getCertBase64s().length > 0) {
            docs.add(AdminTutorVerificationResponse.DocItem.builder().name("Bằng cấp/Chứng chỉ").icon("🎓").url(profile.getCertBase64s()[0]).build());
        }

        String levelsStr = profile.getTeachingLevels() != null ? String.join(", ", profile.getTeachingLevels()) : "Chưa cập nhật";
        String universityStr = profile.getAchievements() != null && !profile.getAchievements().trim().isEmpty() 
                                ? profile.getAchievements() : "Chưa cập nhật";
        String degreeStr = profile.getTutorType() != null ? profile.getTutorType().getDisplayName() : "Chưa cập nhật";
        String experienceStr = profile.getExperienceYears() != null ? profile.getExperienceYears() + " năm" : "Chưa cập nhật";

        java.time.format.DateTimeFormatter formatter = java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy");
        String dateStr = profile.getCreatedAt() != null 
                ? profile.getCreatedAt().atZone(java.time.ZoneId.systemDefault()).toLocalDate().format(formatter) 
                : LocalDate.now().format(formatter);
        String dobStr = profile.getDateOfBirth() != null ? profile.getDateOfBirth().format(formatter) : "Chưa cập nhật";

        return AdminTutorVerificationResponse.builder()
                .id(profile.getUserId())
                .name(user.getFullName())
                .phone(user.getPhone())
                .idCardNumber(profile.getIdCardNumber())
                .subjects(profile.getSubjects())
                .date(dateStr)
                .status(profile.getVerificationStatus())
                .dob(dobStr)
                .university(universityStr)
                .degree(degreeStr)
                .gradYear(profile.getExperienceYears() != null ? String.valueOf(LocalDate.now().getYear() - profile.getExperienceYears()) : "N/A")
                .experience(experienceStr)
                .levels(levelsStr)
                .docs(docs)
                .location(profile.getLocation() != null ? profile.getLocation() : "Chưa cập nhật")
                .build();
    }
}
