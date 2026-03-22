package com.edtech.backend.admin.dto;

import lombok.Builder;
import lombok.Getter;

import java.math.BigDecimal;
import java.util.List;

/**
 * Thống kê tổng quan cho trang Dashboard của Admin.
 */
@Getter
@Builder
public class DashboardStatsResponse {

    // ── Stat cards ─────────────────────────────────────────────────────────
    long totalUsers;
    long activeTutors;       // gia sư đã duyệt (APPROVED)
    long openClasses;        // lớp đang mở (OPEN)
    long activeClasses;      // lớp đang dạy (ACTIVE)
    long pendingVerifications; // hồ sơ GS chờ duyệt (PENDING)

    // ── Phân bổ user theo role ──────────────────────────────────────────────
    long tutorCount;
    long parentCount;
    long studentCount;
    long adminCount;

    // ── Doanh thu nền tảng ─────────────────────────────────────────────────
    /** Tổng platform fee của các lớp ACTIVE (lớp đang dạy) */
    BigDecimal estimatedMonthlyRevenue;

    // ── User đăng ký theo tháng (6 tháng gần nhất) ─────────────────────────
    List<MonthCount> newUsersPerMonth;

    @Getter
    @Builder
    public static class MonthCount {
        String label;   // VD: "T10", "T11"
        long count;
    }
}
