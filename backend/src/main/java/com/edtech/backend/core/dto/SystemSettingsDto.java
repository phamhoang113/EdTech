package com.edtech.backend.core.dto;

import java.math.BigDecimal;

import lombok.Builder;
import lombok.Getter;

/** Toàn bộ cài đặt hệ thống trả về cho Admin */
@Getter
@Builder
public class SystemSettingsDto {

    // ── Chung ─────────────────────────────────────────────────────────────
    String siteName;
    String contactEmail;
    String contactPhone;
    boolean maintenanceMode;
    boolean mockDataEnabled;

    // ── Nền tảng ──────────────────────────────────────────────────────────
    int platformFeePercent;
    BigDecimal minHourlyRate;
    BigDecimal maxHourlyRate;
    int maxClassesPerTutor;
    boolean autoApproveEnabled;

    // ── Bảo mật ───────────────────────────────────────────────────────────
    // Đã xóa: requireStrongPassword, sessionTimeoutMinutes, maxLoginAttempts do không sử dụng

    // ── Thông báo ─────────────────────────────────────────────────────────
    boolean emailOnNewUser;
    boolean emailOnVerification;
    boolean emailOnNewClass;
    boolean emailOnPayment;

    // ── Giao diện ─────────────────────────────────────────────────────────
    String primaryColor;
}
