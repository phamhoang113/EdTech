package com.edtech.backend.billing.service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.temporal.TemporalAdjusters;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Async;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.edtech.backend.auth.entity.UserEntity;
import com.edtech.backend.auth.enums.UserRole;
import com.edtech.backend.auth.repository.UserRepository;
import com.edtech.backend.billing.entity.BillingEntity;
import com.edtech.backend.billing.enums.BillingStatus;
import com.edtech.backend.billing.repository.BillingRepository;
import com.edtech.backend.cls.entity.ClassEntity;
import com.edtech.backend.cls.enums.ClassStatus;
import com.edtech.backend.cls.enums.SessionStatus;
import com.edtech.backend.cls.enums.SessionType;
import com.edtech.backend.cls.repository.ClassRepository;
import com.edtech.backend.cls.repository.SessionRepository;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class BillingSchedulerService {

    /** Số lượng billing xử lý mỗi lần để tối ưu RAM */
    private static final int CHUNK_SIZE = 200;
    /** 1 tháng = 4 tuần cố định */
    private static final int WEEKS_PER_MONTH = 4;
    /** Đơn vị làm tròn lương GS */
    private static final BigDecimal ROUND_UNIT = BigDecimal.valueOf(10_000);

    private final SessionRepository sessionRepository;
    private final ClassRepository classRepository;
    private final BillingRepository billingRepository;
    private final UserRepository userRepository;

    /**
     * Chạy tự động lúc 00:01 ngày 01 hằng tháng.
     * Quét toàn bộ lớp có buổi học hoàn thành trong tháng TRƯỚC và chốt sổ.
     */
    @Scheduled(cron = "0 1 0 1 * ?")
    @Async
    public void generateMonthlyBillingsAutomated() {
        log.info("[BillingScheduler] Bat dau chay Job chot so cho thang truoc...");
        LocalDate now = LocalDate.now();
        LocalDate firstDayOfLastMonth = now.minusMonths(1).withDayOfMonth(1);
        LocalDate lastDayOfLastMonth = now.minusMonths(1).with(TemporalAdjusters.lastDayOfMonth());

        int targetMonth = firstDayOfLastMonth.getMonthValue();
        int targetYear = firstDayOfLastMonth.getYear();

        generateBillingsForTimeframe(firstDayOfLastMonth, lastDayOfLastMonth, targetMonth, targetYear);
    }

    /**
     * Manual Trigger cho Admin / For Testing
     */
    @Transactional
    public void generateMonthlyBillingsManual(int month, int year) {
        log.info("[BillingScheduler] Admin manually triggered chot so cho thang {}/{}", month, year);
        LocalDate firstDay = LocalDate.of(year, month, 1);
        LocalDate lastDay = firstDay.with(TemporalAdjusters.lastDayOfMonth());

        generateBillingsForTimeframe(firstDay, lastDay, month, year);
    }

    private void generateBillingsForTimeframe(LocalDate startDate, LocalDate endDate, int targetMonth, int targetYear) {
        // Đếm buổi COMPLETED + COMPLETED_PENDING theo class
        List<SessionStatus> completedStatuses = List.of(SessionStatus.COMPLETED, SessionStatus.COMPLETED_PENDING);
        List<Object[]> completedStats = sessionRepository.countSessionsByClassAndDateRange(completedStatuses, startDate, endDate);

        // Đếm buổi tăng cường (EXTRA) đã COMPLETED theo class
        List<Object[]> extraStats = sessionRepository.countSessionsByTypeAndStatusesAndClassAndDateRange(
                SessionType.EXTRA, completedStatuses, startDate, endDate);
        Map<UUID, Long> extraCompletedMap = extraStats.stream()
                .collect(Collectors.toMap(row -> (UUID) row[0], row -> (Long) row[1]));

        log.info("[BillingScheduler] Tim thay {} lop hoc co session hoan thanh trong {}/{}", completedStats.size(), targetMonth, targetYear);

        for (int i = 0; i < completedStats.size(); i += CHUNK_SIZE) {
            int end = Math.min(i + CHUNK_SIZE, completedStats.size());
            List<Object[]> chunk = completedStats.subList(i, end);
            processChunk(chunk, extraCompletedMap, targetMonth, targetYear);
        }
        log.info("[BillingScheduler] Ket thuc Job chot so thang {}/{}", targetMonth, targetYear);
    }

    @Transactional
    protected void processChunk(List<Object[]> chunk, Map<UUID, Long> extraCompletedMap, int month, int year) {
        List<UUID> classIds = chunk.stream()
                .map(row -> (UUID) row[0])
                .collect(Collectors.toList());

        Map<UUID, ClassEntity> classMap = classRepository.findAllById(classIds)
                .stream().collect(Collectors.toMap(ClassEntity::getId, c -> c));

        List<BillingEntity> newBillings = new ArrayList<>();

        for (Object[] row : chunk) {
            UUID classId = (UUID) row[0];
            int completedSessions = ((Long) row[1]).intValue();

            ClassEntity cls = classMap.get(classId);
            if (cls == null) continue;

            // Skip lớp đang tạm hoãn
            if (cls.getStatus() == ClassStatus.SUSPENDED) {
                log.info("[Billing] Class {} dang SUSPENDED, skip.", classId);
                continue;
            }

            // Check if billing already generated to prevent duplication
            if (billingRepository.existsByClsIdAndMonthAndYear(classId, month, year)) {
                log.warn("[Billing] Class {} da co hoa don thang {}/{}, skip.", classId, month, year);
                continue;
            }

            int expectedSessions = calculateExpectedSessions(cls);

            BigDecimal totalParentFee = calculateParentFee(cls, completedSessions, expectedSessions);
            long extraCompleted = extraCompletedMap.getOrDefault(classId, 0L);
            BigDecimal totalTutorFee = calculateTutorPayout(cls, completedSessions, (int) extraCompleted);

            UserEntity payer = cls.getParentId() != null ? userRepository.getReferenceById(cls.getParentId()) : null;
            String transactionCode = buildTransactionCode(payer, cls, month, year);

            BillingEntity billing = BillingEntity.builder()
                    .cls(cls)
                    .parent(payer)
                    .month(month)
                    .year(year)
                    .totalSessions(completedSessions)
                    .parentFeeAmount(totalParentFee)
                    .tutorPayoutAmount(totalTutorFee)
                    .transactionCode(transactionCode)
                    .status(totalParentFee.compareTo(BigDecimal.ZERO) == 0 ? BillingStatus.PAID : BillingStatus.DRAFT)
                    .build();

            newBillings.add(billing);

            log.info("[Billing] Class {} | completed={} expected={} extra={} | parentFee={} tutorPayout={}",
                    classId, completedSessions, expectedSessions, extraCompleted, totalParentFee, totalTutorFee);
        }

        if (!newBillings.isEmpty()) {
            billingRepository.saveAll(newBillings);
        }
    }

    // ─── Calculation helpers ────────────────────────────────────────────────

    /** Số buổi kỳ vọng/tháng = sessionsPerWeek × 4 */
    private int calculateExpectedSessions(ClassEntity cls) {
        int sessionsPerWeek = cls.getSessionsPerWeek() != null && cls.getSessionsPerWeek() > 0
                ? cls.getSessionsPerWeek() : 1;
        return sessionsPerWeek * WEEKS_PER_MONTH;
    }

    /**
     * Phí PH = parentFeePerSession × completedSessions
     * parentFeePerSession = parentFee / expectedSessions
     */
    private BigDecimal calculateParentFee(ClassEntity cls, int completedSessions, int expectedSessions) {
        if (cls.getParentFee() == null || cls.getParentFee().compareTo(BigDecimal.ZERO) == 0) {
            return BigDecimal.ZERO;
        }
        BigDecimal feePerSession = cls.getParentFee()
                .divide(BigDecimal.valueOf(expectedSessions), 0, RoundingMode.HALF_UP);
        return feePerSession.multiply(BigDecimal.valueOf(completedSessions));
    }

    /**
     * Lương GS:
     * - Base = tutorFee (cố định/tháng)
     * - netMissed = max(0, expected - completed) → thiếu buổi so với quota
     * - realExtra = min(extraTypeCount, max(0, completed - expected)) → chỉ EXTRA vượt quota
     * - Trừ/buổi = roundDown(tutorFee / expected, 10k) → GS bị trừ ít
     * - Kết quả cuối = roundUp(payout, 10k) → GS nhận nhiều hơn chút
     *
     * Buổi EXTRA bù cho buổi nghỉ trước. Chỉ khi vượt quota mới tính bonus.
     * VD: expected=8, GS nghỉ 1, dạy bù 1 EXTRA → completed=8 → net=0 → 1.500k (full)
     * VD: expected=8, 1 EXTRA không bù → completed=9 → realExtra=1 → 1.500k + 180k
     */
    private BigDecimal calculateTutorPayout(ClassEntity cls, int completedSessions, int extraTypeCount) {
        if (cls.getTutorFee() == null || cls.getTutorFee().compareTo(BigDecimal.ZERO) == 0) {
            return BigDecimal.ZERO;
        }

        BigDecimal tutorFee = cls.getTutorFee();
        int expectedSessions = calculateExpectedSessions(cls);

        // Trừ/buổi làm tròn XUỐNG 10k → GS bị trừ ít hơn
        BigDecimal feePerSession = roundDownTo10k(
                tutorFee.divide(BigDecimal.valueOf(expectedSessions), 2, RoundingMode.HALF_UP));

        // Thiếu buổi so với quota (GS nghỉ hoặc HS nghỉ đều giảm completed)
        int netMissed = Math.max(0, expectedSessions - completedSessions);
        BigDecimal deduction = feePerSession.multiply(BigDecimal.valueOf(netMissed));

        // Buổi tăng cường thật = EXTRA sessions vượt quota (bù xong mới tính)
        int realExtra = Math.min(extraTypeCount, Math.max(0, completedSessions - expectedSessions));
        BigDecimal bonus = feePerSession.multiply(BigDecimal.valueOf(realExtra));

        BigDecimal payout = tutorFee.subtract(deduction).add(bonus);

        // Không cho âm
        if (payout.compareTo(BigDecimal.ZERO) < 0) {
            return BigDecimal.ZERO;
        }

        // Kết quả làm tròn LÊN 10k → GS nhận nhiều hơn chút
        return roundUpTo10k(payout);
    }

    /** Làm tròn XUỐNG đến bội số 10.000đ (dùng cho trừ lương/buổi) */
    private BigDecimal roundDownTo10k(BigDecimal amount) {
        return amount.divide(ROUND_UNIT, 0, RoundingMode.FLOOR).multiply(ROUND_UNIT);
    }

    /** Làm tròn LÊN đến bội số 10.000đ (dùng cho kết quả cuối) */
    private BigDecimal roundUpTo10k(BigDecimal amount) {
        return amount.divide(ROUND_UNIT, 0, RoundingMode.CEILING).multiply(ROUND_UNIT);
    }

    private String buildTransactionCode(UserEntity payer, ClassEntity cls, int month, int year) {
        String prefix = "PAYP";
        if (payer != null && payer.getRole() == UserRole.STUDENT) {
            prefix = "PAYS";
        }
        String yymm = String.format("%02d%02d", month, year % 100);
        String payerIdSub = cls.getParentId() != null
                ? cls.getParentId().toString().substring(0, 6).toUpperCase() : "UNK";
        return prefix + payerIdSub + yymm;
    }
}
