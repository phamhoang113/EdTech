package com.edtech.backend.admin.service;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.YearMonth;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.edtech.backend.admin.dto.DashboardStatsResponse.MonthCount;
import com.edtech.backend.admin.dto.DashboardStatsResponse;
import com.edtech.backend.auth.enums.UserRole;
import com.edtech.backend.auth.repository.UserRepository;
import com.edtech.backend.cls.entity.ClassEntity;
import com.edtech.backend.cls.enums.ApplicationStatus;
import com.edtech.backend.cls.enums.ClassStatus;
import com.edtech.backend.cls.repository.ClassApplicationRepository;
import com.edtech.backend.cls.repository.ClassRepository;
import com.edtech.backend.tutor.enums.VerificationStatus;
import com.edtech.backend.tutor.repository.TutorProfileRepository;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class AdminDashboardService {

    private final UserRepository userRepository;
    private final TutorProfileRepository tutorProfileRepository;
    private final ClassRepository classRepository;
    private final ClassApplicationRepository classApplicationRepository;

    public DashboardStatsResponse getStats() {
        // ── Stat cards ───────────────────────────────────────────────────────
        long totalUsers = userRepository.countByIsDeletedFalse();
        long activeTutors = tutorProfileRepository.countByVerificationStatus(VerificationStatus.APPROVED);
        long openClasses = classRepository.findByStatusAndIsDeletedFalse(ClassStatus.OPEN).size();
        long activeClasses = classRepository.findByStatusAndIsDeletedFalse(ClassStatus.ACTIVE).size();
        long pendingVerifications = tutorProfileRepository.countByVerificationStatus(VerificationStatus.PENDING);

        // ── Phân bổ role ─────────────────────────────────────────────────────
        long tutorCount = userRepository.countByRoleAndIsDeletedFalse(UserRole.TUTOR);
        long parentCount = userRepository.countByRoleAndIsDeletedFalse(UserRole.PARENT);
        long studentCount = userRepository.countByRoleAndIsDeletedFalse(UserRole.STUDENT);
        long adminCount = userRepository.countByRoleAndIsDeletedFalse(UserRole.ADMIN);

        // ── Doanh thu ước tính: tổng platform_fee các lớp ASSIGNED + ACTIVE ────
        List<ClassEntity> revenueClasses = new ArrayList<>();
        revenueClasses.addAll(classRepository.findByStatusAndIsDeletedFalse(ClassStatus.ACTIVE));
        revenueClasses.addAll(classRepository.findByStatusAndIsDeletedFalse(ClassStatus.ASSIGNED));
        BigDecimal estimatedRevenue = revenueClasses.stream()
                .map(c -> c.getPlatformFee() != null ? c.getPlatformFee() : BigDecimal.ZERO)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        // ── User mới 6 tháng gần nhất ────────────────────────────────────────
        List<MonthCount> newUsersPerMonth = buildMonthlyNewUsers(6);

        return DashboardStatsResponse.builder()
                .totalUsers(totalUsers)
                .activeTutors(activeTutors)
                .openClasses(openClasses)
                .activeClasses(activeClasses)
                .pendingVerifications(pendingVerifications)
                .tutorCount(tutorCount)
                .parentCount(parentCount)
                .studentCount(studentCount)
                .adminCount(adminCount)
                .estimatedMonthlyRevenue(estimatedRevenue)
                .newUsersPerMonth(newUsersPerMonth)
                .build();
    }

    /** Đếm user mới đăng ký theo từng tháng, trả về `monthCount` tháng gần nhất */
    private List<MonthCount> buildMonthlyNewUsers(int monthCount) {
        ZoneId zone = ZoneId.of("Asia/Ho_Chi_Minh");
        YearMonth current = YearMonth.now(zone);
        List<MonthCount> result = new ArrayList<>();

        for (int i = monthCount - 1; i >= 0; i--) {
            YearMonth ym = current.minusMonths(i);
            Instant from = ym.atDay(1).atStartOfDay(zone).toInstant();
            Instant to = ym.atEndOfMonth().plusDays(1).atStartOfDay(zone).toInstant();
            long count = userRepository.countByCreatedAtBetween(from, to);
            result.add(MonthCount.builder()
                    .label("T" + ym.getMonthValue())
                    .count(count)
                    .build());
        }
        return result;
    }

    /** Lấy badge counts cho sidebar admin */
    public Map<String, Long> getBadgeCounts() {
        long pendingApplications = classApplicationRepository.countByStatus(ApplicationStatus.PENDING);
        long pendingVerifications = tutorProfileRepository.countByVerificationStatus(VerificationStatus.PENDING);
        long pendingClassRequests = classRepository.countByStatusAndIsDeletedFalse(ClassStatus.PENDING_APPROVAL);

        return Map.of(
                "pendingApplications", pendingApplications,
                "pendingVerifications", pendingVerifications,
                "pendingClassRequests", pendingClassRequests
        );
    }
}
