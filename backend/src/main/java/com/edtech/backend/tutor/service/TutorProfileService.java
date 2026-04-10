package com.edtech.backend.tutor.service;

import java.time.LocalDate;
import java.util.List;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.edtech.backend.auth.entity.UserEntity;
import com.edtech.backend.auth.repository.UserRepository;
import com.edtech.backend.core.exception.EntityNotFoundException;
import com.edtech.backend.core.service.StorageService;
import com.edtech.backend.core.util.ImageCompressUtil;
import com.edtech.backend.tutor.dto.request.UpdateTutorProfileRequest;
import com.edtech.backend.tutor.dto.response.TutorProfileResponse;
import com.edtech.backend.tutor.entity.TutorProfileEntity;
import com.edtech.backend.tutor.enums.TutorType;
import com.edtech.backend.tutor.enums.VerificationStatus;
import com.edtech.backend.tutor.repository.TutorProfileRepository;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class TutorProfileService {

    private final TutorProfileRepository tutorProfileRepository;
    private final UserRepository userRepository;
    private final StorageService storageService;

    public TutorProfileResponse getMyProfileByUsername(String username) {
        UserEntity user = userRepository.findByIdentifierAndIsDeletedFalse(username)
                .orElseThrow(() -> new EntityNotFoundException("Không tìm thấy người dùng."));

        TutorProfileEntity profile = tutorProfileRepository.findByUserId(user.getId())
                .orElseThrow(() -> new EntityNotFoundException("Không tìm thấy hồ sơ Gia sư."));
        return mapToResponse(profile, user);
    }

    @Transactional
    public TutorProfileResponse updateMyProfile(String username, UpdateTutorProfileRequest req) {
        UserEntity user = userRepository.findByIdentifierAndIsDeletedFalse(username)
                .orElseThrow(() -> new EntityNotFoundException("Không tìm thấy người dùng."));

        TutorProfileEntity profile = tutorProfileRepository.findByUserId(user.getId())
                .orElseThrow(() -> new EntityNotFoundException("Không tìm thấy hồ sơ Gia sư."));

        // Update UserEntity fields
        if (req.getEmail() != null) user.setEmail(req.getEmail().isBlank() ? null : req.getEmail().trim());
        if (req.getAvatarBase64() != null && !req.getAvatarBase64().isBlank()) {
            user.setAvatarBase64(ImageCompressUtil.compress(req.getAvatarBase64()));
        }
        userRepository.save(user);

        // Update TutorProfileEntity fields
        if (req.getBio() != null) profile.setBio(req.getBio());
        if (req.getLocation() != null) profile.setLocation(req.getLocation().length() > 500 ? req.getLocation().substring(0, 500) : req.getLocation());
        if (req.getSubjects() != null) profile.setSubjects(req.getSubjects());
        if (req.getTeachingLevels() != null) profile.setTeachingLevels(req.getTeachingLevels());
        if (req.getAchievements() != null) profile.setAchievements(req.getAchievements());
        if (req.getExperienceYears() != null) profile.setExperienceYears(req.getExperienceYears());
        if (req.getTeachingMode() != null && !req.getTeachingMode().isBlank()) {
            profile.setTeachingMode(req.getTeachingMode());
        }
        if (req.getBankName() != null) profile.setBankName(req.getBankName());
        if (req.getBankAccountNumber() != null) profile.setBankAccountNumber(req.getBankAccountNumber());
        if (req.getBankOwnerName() != null) profile.setBankOwnerName(req.getBankOwnerName());

        TutorProfileEntity saved = tutorProfileRepository.save(profile);
        log.info("User {} updated their tutor profile", user.getId());
        return mapToResponse(saved, user);
    }

    @Transactional
    public TutorProfileResponse verifyProfileByUsername(
            String username,
            TutorType tutorType,
            LocalDate dateOfBirth,
            String idCardNumber,
            MultipartFile degree,
            List<String> subjects,
            List<String> teachingLevels,
            String achievements,
            Integer experienceYears,
            String location
    ) {
        UserEntity user = userRepository.findByIdentifierAndIsDeletedFalse(username)
                .orElseThrow(() -> new EntityNotFoundException("Không tìm thấy người dùng."));

        TutorProfileEntity profile = tutorProfileRepository.findByUserId(user.getId())
                .orElseGet(() -> TutorProfileEntity.builder()
                        .userId(user.getId())
                        .verificationStatus(VerificationStatus.UNVERIFIED)
                        .build());

        profile.setTutorType(tutorType);
        profile.setDateOfBirth(dateOfBirth);
        profile.setIdCardNumber(idCardNumber);

        if (subjects != null && !subjects.isEmpty()) {
            profile.setSubjects(subjects.toArray(new String[0]));
        }
        if (teachingLevels != null && !teachingLevels.isEmpty()) {
            profile.setTeachingLevels(teachingLevels.toArray(new String[0]));
        }
        if (achievements != null) {
            profile.setAchievements(achievements);
        }
        if (experienceYears != null) {
            profile.setExperienceYears(experienceYears);
        }
        if (location != null && !location.isBlank()) {
            profile.setLocation(location.length() > 500 ? location.substring(0, 500) : location);
        }

        if (degree != null && !degree.isEmpty()) {
            String degreeBase64 = storageService.upload(degree, "tutors/degrees");
            profile.setCertBase64s(ImageCompressUtil.compressArray(new String[]{degreeBase64}));
        }

        profile.setVerificationStatus(VerificationStatus.PENDING);
        TutorProfileEntity savedProfile = tutorProfileRepository.save(profile);

        log.info("User {} submitted tutor profile for verification. Type: {}", user.getId(), tutorType);

        return mapToResponse(savedProfile, user);
    }

    private TutorProfileResponse mapToResponse(TutorProfileEntity profile, UserEntity user) {
        return TutorProfileResponse.builder()
                .fullName(user.getFullName())
                .email(user.getEmail())
                .avatarBase64(ImageCompressUtil.decompress(user.getAvatarBase64()))
                .bio(profile.getBio())
                .subjects(profile.getSubjects())
                .teachingLevels(profile.getTeachingLevels())
                .location(profile.getLocation())
                .teachingMode(profile.getTeachingMode())
                .rating(profile.getRating())
                .ratingCount(profile.getRatingCount())
                .idCardNumber(profile.getIdCardNumber())
                .certBase64s(ImageCompressUtil.decompressArray(profile.getCertBase64s()))
                .verificationStatus(profile.getVerificationStatus())
                .tutorType(profile.getTutorType())
                .dateOfBirth(profile.getDateOfBirth())
                .achievements(profile.getAchievements())
                .experienceYears(profile.getExperienceYears())
                .bankName(profile.getBankName())
                .bankAccountNumber(profile.getBankAccountNumber())
                .bankOwnerName(profile.getBankOwnerName())
                .build();
    }
}
