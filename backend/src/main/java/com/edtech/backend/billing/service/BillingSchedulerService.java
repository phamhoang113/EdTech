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
import com.edtech.backend.auth.repository.UserRepository;
import com.edtech.backend.billing.entity.BillingEntity;
import com.edtech.backend.billing.entity.TutorPayoutEntity;
import com.edtech.backend.billing.enums.BillingStatus;
import com.edtech.backend.billing.enums.TutorPayoutStatus;
import com.edtech.backend.billing.repository.BillingRepository;
import com.edtech.backend.billing.repository.TutorPayoutRepository;
import com.edtech.backend.cls.entity.ClassEntity;
import com.edtech.backend.cls.enums.SessionStatus;
import com.edtech.backend.cls.repository.ClassRepository;
import com.edtech.backend.cls.repository.SessionRepository;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class BillingSchedulerService {

    private final SessionRepository sessionRepository;
    private final ClassRepository classRepository;
    private final BillingRepository billingRepository;
    private final TutorPayoutRepository tutorPayoutRepository;
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
        List<SessionStatus> validStatuses = List.of(SessionStatus.COMPLETED, SessionStatus.COMPLETED_PENDING);

        List<Object[]> stats = sessionRepository.countSessionsByClassAndDateRange(validStatuses, startDate, endDate);
        log.info("[BillingScheduler] Tim thay {} lop hoc co session hoan thanh trong {}/{}", stats.size(), targetMonth, targetYear);

        // Chunk process de toi uu RAM
        final int CHUNK_SIZE = 200;
        for (int i = 0; i < stats.size(); i += CHUNK_SIZE) {
            int end = Math.min(i + CHUNK_SIZE, stats.size());
            List<Object[]> chunk = stats.subList(i, end);
            processChunk(chunk, targetMonth, targetYear);
        }
        log.info("[BillingScheduler] Ket thuc Job chot so thang {}/{}", targetMonth, targetYear);
    }

    @Transactional
    protected void processChunk(List<Object[]> chunk, int month, int year) {
        List<UUID> classIds = chunk.stream()
                .map(row -> (UUID) row[0])
                .collect(Collectors.toList());

        Map<UUID, ClassEntity> classMap = classRepository.findAllById(classIds)
                .stream().collect(Collectors.toMap(ClassEntity::getId, c -> c));

        List<BillingEntity> newBillings = new ArrayList<>();

        for (Object[] row : chunk) {
            UUID classId = (UUID) row[0];
            Long countLong = (Long) row[1];
            int totalSessions = countLong.intValue();

            ClassEntity cls = classMap.get(classId);
            if (cls == null) continue;

            // Skip lớp đang tạm hoãn — phòng thủ thêm dù SUSPENDED sẽ không có COMPLETED session mới
            if (cls.getStatus() == com.edtech.backend.cls.enums.ClassStatus.SUSPENDED) {
                log.info("[Billing] Class {} dang SUSPENDED, skip.", classId);
                continue;
            }

            // Check if billing already generated to prevent duplication
            if (billingRepository.existsByClsIdAndMonthAndYear(classId, month, year)) {
                log.warn("[Billing] Class {} da co hoa don thang {}/{}, skip.", classId, month, year);
                continue;
            }

            // Calculation
            int sessionsPerMonth = cls.getSessionsPerWeek() != null && cls.getSessionsPerWeek() > 0 
                ? cls.getSessionsPerWeek() * 4 
                : 4;

            BigDecimal parentFeePerSession = cls.getParentFee().divide(BigDecimal.valueOf(sessionsPerMonth), 0, RoundingMode.HALF_UP);
            BigDecimal totalParentFee = parentFeePerSession.multiply(BigDecimal.valueOf(totalSessions));

            BigDecimal totalTutorFee = BigDecimal.ZERO;
            if (cls.getTutorFee() != null) {
                BigDecimal tutorFeePerSession = cls.getTutorFee().divide(BigDecimal.valueOf(sessionsPerMonth), 0, RoundingMode.HALF_UP);
                totalTutorFee = tutorFeePerSession.multiply(BigDecimal.valueOf(totalSessions));
            }

            UserEntity payer = cls.getParentId() != null ? userRepository.getReferenceById(cls.getParentId()) : null;

            String prefix = "PAYP";
            if (payer != null && payer.getRole() != null && payer.getRole().name().equals("STUDENT")) {
                prefix = "PAYS";
            }

            // Format for payer: PAYP/PAYS<ParentIdSubstring><MMyy>
            String yymm = String.format("%02d%02d", month, year % 100);
            String parentIdSub = cls.getParentId() != null ? cls.getParentId().toString().substring(0,6).toUpperCase() : "UNK";
            String parentTxCode = prefix + parentIdSub + yymm;

            BillingEntity billing = BillingEntity.builder()
                    .cls(cls)
                    .parent(payer)
                    .month(month)
                    .year(year)
                    .totalSessions(totalSessions)
                    .parentFeeAmount(totalParentFee)
                    .tutorPayoutAmount(totalTutorFee)
                    .transactionCode(parentTxCode)
                    .status(totalParentFee.compareTo(BigDecimal.ZERO) == 0 ? BillingStatus.PAID : BillingStatus.DRAFT)
                    .build();

            newBillings.add(billing);

            // Defer payout generation until billing ID is available (we need to save billings first)
        }

        if (!newBillings.isEmpty()) {
            billingRepository.saveAll(newBillings);
            // TutorPayout is created when admin approves DRAFT → UNPAID
        }
    }
}
