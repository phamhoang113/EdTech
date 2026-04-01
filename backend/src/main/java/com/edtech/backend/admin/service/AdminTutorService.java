package com.edtech.backend.admin.service;

import com.edtech.backend.auth.entity.UserEntity;
import com.edtech.backend.auth.repository.RefreshTokenRepository;
import com.edtech.backend.auth.repository.UserRepository;
import com.edtech.backend.cls.enums.ClassStatus;
import com.edtech.backend.core.exception.EntityNotFoundException;
import com.edtech.backend.admin.dto.AdminTutorListItem;
import com.edtech.backend.admin.dto.AdminTutorVerificationResponse;
import com.edtech.backend.cls.entity.ClassApplicationEntity;
import com.edtech.backend.cls.entity.ClassEntity;
import com.edtech.backend.tutor.entity.TutorProfileEntity;
import com.edtech.backend.cls.enums.ApplicationStatus;
import com.edtech.backend.tutor.enums.VerificationStatus;
import com.edtech.backend.cls.repository.ClassApplicationRepository;
import com.edtech.backend.cls.repository.ClassRepository;
import com.edtech.backend.tutor.repository.TutorProfileRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.UUID;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class AdminTutorService {

    private static final String ERR_TUTOR_NOT_FOUND = "Không tìm thấy gia sư.";
    private static final String ERR_PROFILE_NOT_FOUND = "Không tìm thấy hồ sơ Gia sư cho user ID: %s";
    private static final String ERR_NOT_PENDING_STATUS = "Hồ sơ không ở trạng thái chờ duyệt.";
    private static final String DEFAULT_VALUE = "Chưa cập nhật";
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("dd/MM/yyyy");

    private final TutorProfileRepository tutorProfileRepository;
    private final UserRepository userRepository;
    private final RefreshTokenRepository refreshTokenRepository;
    private final ClassRepository classRepository;
    private final ClassApplicationRepository applicationRepository;

    /** Lấy toàn bộ gia sư (kể cả đã xóa mềm) để admin xem */
    public List<AdminTutorListItem> getAllTutors() {
        List<TutorProfileEntity> profiles = tutorProfileRepository.findAll();
        if (profiles.isEmpty()) return new ArrayList<>();

        List<UUID> userIds = profiles.stream()
                .map(TutorProfileEntity::getUserId)
                .collect(Collectors.toList());
        Map<UUID, UserEntity> userMap = userRepository.findAllById(userIds).stream()
                .collect(Collectors.toMap(UserEntity::getId, u -> u));

        List<AdminTutorListItem> result = new ArrayList<>();
        for (TutorProfileEntity p : profiles) {
            UserEntity u = userMap.get(p.getUserId());
            if (u == null) continue;

            // Lớp đang phụ trách = ASSIGNED + ACTIVE
            List<ClassStatus> teachingStatuses = List.of(ClassStatus.ASSIGNED, ClassStatus.ACTIVE);
            List<ClassEntity> teachingClasses = classRepository.findByTutorIdAndStatusInAndIsDeletedFalse(u.getId(), teachingStatuses);
            long activeCnt = teachingClasses.size();

            // Thu nhập GS/tháng = sum(tutorFee)
            BigDecimal monthlyEarnings = teachingClasses.stream()
                    .filter(c -> c.getTutorFee() != null)
                    .map(ClassEntity::getTutorFee)
                    .reduce(BigDecimal.ZERO, BigDecimal::add);

            // Phí nền tảng/tháng = sum(platformFee)
            BigDecimal platformFee = teachingClasses.stream()
                    .filter(c -> c.getPlatformFee() != null)
                    .map(ClassEntity::getPlatformFee)
                    .reduce(BigDecimal.ZERO, BigDecimal::add);

            result.add(AdminTutorListItem.builder()
                    .userId(u.getId())
                    .fullName(u.getFullName())
                    .phone(u.getPhone())
                    .tutorType(p.getTutorType() != null ? p.getTutorType().getDisplayName() : null)
                    .verificationStatus(p.getVerificationStatus())
                    .isDeleted(Boolean.TRUE.equals(u.getIsDeleted()))
                    .isActive(Boolean.TRUE.equals(u.getIsActive()))
                    .subjects(p.getSubjects() != null ? Arrays.asList(p.getSubjects()) : null)
                    .location(p.getLocation())
                    .hourlyRate(p.getHourlyRate())
                    .activeClassCount(activeCnt)
                    .estimatedMonthlyEarnings(monthlyEarnings)
                    .platformFeePerMonth(platformFee)
                    .createdAt(u.getCreatedAt())
                    .build());
        }
        return result;
    }

    /** Xóa mềm gia sư: revoke login, revert classes, reject pending apps */
    @Transactional
    public void deleteTutor(UUID userId) {
        UserEntity user = userRepository.findById(userId)
                .orElseThrow(() -> new EntityNotFoundException(ERR_TUTOR_NOT_FOUND));

        // 1. Soft delete user
        user.setIsDeleted(true);
        user.setIsActive(false);
        userRepository.save(user);

        // 2. Revoke tất cả refresh token → mất login
        refreshTokenRepository.deleteAllByUserId(userId);

        // 3. Revert các lớp ASSIGNED + ACTIVE của gia sư về OPEN
        List<ClassEntity> assignedClasses = classRepository.findByTutorIdAndStatusInAndIsDeletedFalse(
                userId, List.of(ClassStatus.ASSIGNED, ClassStatus.ACTIVE));
        assignedClasses.forEach(cls -> {
            cls.setTutorId(null);
            cls.setStatus(ClassStatus.OPEN);
            cls.setTutorFee(null);
        });
        classRepository.saveAll(assignedClasses);

        // 4. Reject tất cả đơn PENDING của gia sư
        List<ClassApplicationEntity> pendingApps = applicationRepository.findByTutorId(userId).stream()
                .filter(a -> a.getStatus() == ApplicationStatus.PENDING)
                .collect(Collectors.toList());
        pendingApps.forEach(a -> a.setStatus(ApplicationStatus.REJECTED));
        applicationRepository.saveAll(pendingApps);

        log.info("[DELETE_TUTOR] userId={}, revertedClasses={}, rejectedApps={}",
                userId, assignedClasses.size(), pendingApps.size());
    }


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
        }).filter(Objects::nonNull).collect(Collectors.toList());
    }

    @Transactional
    public void approveTutor(UUID userId, BigDecimal rate) {
        TutorProfileEntity profile = tutorProfileRepository.findByUserId(userId)
                .orElseThrow(() -> new EntityNotFoundException(String.format(ERR_PROFILE_NOT_FOUND, userId)));

        if (profile.getVerificationStatus() != VerificationStatus.PENDING) {
            throw new IllegalArgumentException(ERR_NOT_PENDING_STATUS);
        }

        profile.setHourlyRate(rate);
        profile.setVerificationStatus(VerificationStatus.APPROVED);
        tutorProfileRepository.save(profile);
        log.info("[APPROVE_TUTOR] userId={}, hourlyRate={}", userId, rate);
    }

    @Transactional
    public void rejectTutor(UUID userId) {
        TutorProfileEntity profile = tutorProfileRepository.findByUserId(userId)
                .orElseThrow(() -> new EntityNotFoundException(String.format(ERR_PROFILE_NOT_FOUND, userId)));

        if (profile.getVerificationStatus() != VerificationStatus.PENDING) {
            throw new IllegalArgumentException(ERR_NOT_PENDING_STATUS);
        }

        profile.setVerificationStatus(VerificationStatus.REJECTED);
        tutorProfileRepository.save(profile);
        log.info("[REJECT_TUTOR] userId={}", userId);
    }

    private AdminTutorVerificationResponse mapToAdminResponse(TutorProfileEntity profile, UserEntity user) {
        List<AdminTutorVerificationResponse.DocItem> docs = new ArrayList<>();
        
        // Only cert (degree/certificate) images are stored - CCCD is number only
        if (profile.getCertBase64s() != null && profile.getCertBase64s().length > 0) {
            docs.add(AdminTutorVerificationResponse.DocItem.builder().name("Bằng cấp/Chứng chỉ").icon("🎓").url(profile.getCertBase64s()[0]).build());
        }

        String levelsStr = profile.getTeachingLevels() != null ? String.join(", ", profile.getTeachingLevels()) : DEFAULT_VALUE;
        String universityStr = profile.getAchievements() != null && !profile.getAchievements().trim().isEmpty() 
                                ? profile.getAchievements() : DEFAULT_VALUE;
        String degreeStr = profile.getTutorType() != null ? profile.getTutorType().getDisplayName() : DEFAULT_VALUE;
        String experienceStr = profile.getExperienceYears() != null ? profile.getExperienceYears() + " năm" : DEFAULT_VALUE;

        String dateStr = profile.getCreatedAt() != null 
                ? profile.getCreatedAt().atZone(ZoneId.systemDefault()).toLocalDate().format(DATE_FORMATTER) 
                : LocalDate.now().format(DATE_FORMATTER);
        String dobStr = profile.getDateOfBirth() != null ? profile.getDateOfBirth().format(DATE_FORMATTER) : DEFAULT_VALUE;

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
                .location(profile.getLocation() != null ? profile.getLocation() : DEFAULT_VALUE)
                .build();
    }
}
