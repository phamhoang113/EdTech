package com.edtech.backend.core.dto;

import lombok.Builder;
import lombok.Getter;

import java.math.BigDecimal;

/** Toàn bộ cài đặt hệ thống trả về cho Admin */
@Getter
@Builder
public class SystemSettingsDto {

    // ── Chung ─────────────────────────────────────────────────────────────
    String siteName;
    String contactEmail;
    String contactPhone;
    boolean maintenanceMode;

    // ── Nền tảng ──────────────────────────────────────────────────────────
    int platformFeePercent;
    BigDecimal minHourlyRate;
    BigDecimal maxHourlyRate;
    int maxClassesPerTutor;
    boolean autoApproveEnabled;

    // ── Bảo mật ───────────────────────────────────────────────────────────
    boolean requireStrongPassword;
    int sessionTimeoutMinutes;
    int maxLoginAttempts;

    // ── Thông báo ─────────────────────────────────────────────────────────
    boolean emailOnNewUser;
    boolean emailOnVerification;
    boolean emailOnNewClass;
    boolean emailOnPayment;

    // ── Giao diện ─────────────────────────────────────────────────────────
    String primaryColor;
}
