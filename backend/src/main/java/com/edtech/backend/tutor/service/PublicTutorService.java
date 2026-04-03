package com.edtech.backend.tutor.service;

import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.edtech.backend.auth.entity.UserEntity;
import com.edtech.backend.auth.repository.UserRepository;
import com.edtech.backend.core.exception.EdTechException;
import com.edtech.backend.core.service.SystemSettingsService;
import com.edtech.backend.tutor.dto.response.TutorPublicResponse;
import com.edtech.backend.tutor.entity.TutorProfileEntity;
import com.edtech.backend.tutor.enums.VerificationStatus;
import com.edtech.backend.tutor.repository.TutorProfileRepository;

@Service
@RequiredArgsConstructor
@Slf4j
@Transactional(readOnly = true)
public class PublicTutorService {

    private final TutorProfileRepository tutorProfileRepository;
    private final UserRepository userRepository;
    private final SystemSettingsService systemSettingsService;

    @Transactional(readOnly = true)
    public Page<TutorPublicResponse> getPublicTutors(Pageable pageable) {
        boolean includeMock = systemSettingsService.getSettings().isMockDataEnabled();
        // Fetch verified profiles
        Page<TutorProfileEntity> profilesPage = tutorProfileRepository.findPublicProfiles(VerificationStatus.APPROVED, includeMock, pageable);

        // Optimization: fetch users in one query
        var userIds = profilesPage.getContent().stream()
                .map(TutorProfileEntity::getUserId)
                .collect(Collectors.toList());

        Map<UUID, UserEntity> userMap = userRepository.findAllById(userIds).stream()
                .collect(Collectors.toMap(UserEntity::getId, user -> user));

        return profilesPage.map(profile -> {
            UserEntity user = userMap.get(profile.getUserId());
            if (user == null) {
                // Return fallback if user not found, though realistically user should exist
                return mapToPublicResponse(profile, null, "Không xác định", null);
            }
            return mapToPublicResponse(profile, user.getId(), user.getFullName(), user.getAvatarBase64());
        });
    }

    private TutorPublicResponse mapToPublicResponse(TutorProfileEntity entity, UUID userId, String fullName, String avatarBase64) {
        return TutorPublicResponse.builder()
                .userId(userId)
                .fullName(fullName)
                .bio(entity.getBio())
                .subjects(entity.getSubjects())
                .location(entity.getLocation())
                .teachingMode(entity.getTeachingMode())
                .hourlyRate(entity.getHourlyRate())
                .rating(entity.getRating())
                .ratingCount(entity.getRatingCount())
                .teachingLevels(entity.getTeachingLevels())
                .achievements(entity.getAchievements())
                .experienceYears(entity.getExperienceYears())
                .avatarBase64(avatarBase64)
                .tutorType(entity.getTutorType() != null ? entity.getTutorType().name() : null)
                .build();
    }
}
