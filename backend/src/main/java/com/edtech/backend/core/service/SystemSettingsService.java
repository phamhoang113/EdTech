package com.edtech.backend.core.service;

import com.edtech.backend.core.dto.SystemSettingsDto;
import com.edtech.backend.core.entity.SystemSettingEntity;
import com.edtech.backend.core.repository.SystemSettingRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class SystemSettingsService {

    private final SystemSettingRepository repo;

    /** Lấy toàn bộ settings dưới dạng typed DTO */
    public SystemSettingsDto getSettings() {
        Map<String, String> map = repo.findAll().stream()
                .collect(Collectors.toMap(SystemSettingEntity::getKey, e -> e.getValue() != null ? e.getValue() : ""));

        return SystemSettingsDto.builder()
                // Chung
                .siteName(map.getOrDefault("site_name", "EdTech"))
                .contactEmail(map.getOrDefault("contact_email", "support@edtech.vn"))
                .contactPhone(map.getOrDefault("contact_phone", "1800 1234"))
                .maintenanceMode(parseBool(map, "maintenance_mode", false))
                // Nền tảng
                .platformFeePercent(parseInt(map, "platform_fee_percent", 20))
                .minHourlyRate(parseBd(map, "min_hourly_rate", new BigDecimal("50000")))
                .maxHourlyRate(parseBd(map, "max_hourly_rate", new BigDecimal("2000000")))
                .maxClassesPerTutor(parseInt(map, "max_classes_per_tutor", 5))
                .autoApproveEnabled(parseBool(map, "auto_approve_enabled", false))
                // Bảo mật
                .requireStrongPassword(parseBool(map, "require_strong_password", true))
                .sessionTimeoutMinutes(parseInt(map, "session_timeout_minutes", 60))
                .maxLoginAttempts(parseInt(map, "max_login_attempts", 5))
                // Thông báo
                .emailOnNewUser(parseBool(map, "email_on_new_user", true))
                .emailOnVerification(parseBool(map, "email_on_verification", true))
                .emailOnNewClass(parseBool(map, "email_on_new_class", false))
                .emailOnPayment(parseBool(map, "email_on_payment", true))
                // Giao diện
                .primaryColor(map.getOrDefault("primary_color", "#6366f1"))
                .build();
    }

    /** Cập nhật toàn bộ settings từ DTO */
    @Transactional
    public SystemSettingsDto updateSettings(SystemSettingsDto dto) {
        upsert("site_name",               dto.getSiteName());
        upsert("contact_email",           dto.getContactEmail());
        upsert("contact_phone",           dto.getContactPhone());
        upsert("maintenance_mode",        String.valueOf(dto.isMaintenanceMode()));
        upsert("platform_fee_percent",    String.valueOf(dto.getPlatformFeePercent()));
        upsert("min_hourly_rate",         dto.getMinHourlyRate() != null ? dto.getMinHourlyRate().toPlainString() : "50000");
        upsert("max_hourly_rate",         dto.getMaxHourlyRate() != null ? dto.getMaxHourlyRate().toPlainString() : "2000000");
        upsert("max_classes_per_tutor",   String.valueOf(dto.getMaxClassesPerTutor()));
        upsert("auto_approve_enabled",    String.valueOf(dto.isAutoApproveEnabled()));
        upsert("require_strong_password", String.valueOf(dto.isRequireStrongPassword()));
        upsert("session_timeout_minutes", String.valueOf(dto.getSessionTimeoutMinutes()));
        upsert("max_login_attempts",      String.valueOf(dto.getMaxLoginAttempts()));
        upsert("email_on_new_user",       String.valueOf(dto.isEmailOnNewUser()));
        upsert("email_on_verification",   String.valueOf(dto.isEmailOnVerification()));
        upsert("email_on_new_class",      String.valueOf(dto.isEmailOnNewClass()));
        upsert("email_on_payment",        String.valueOf(dto.isEmailOnPayment()));
        upsert("primary_color",           dto.getPrimaryColor());
        return getSettings();
    }

    /** Đọc 1 setting theo key, trả về String */
    public String get(String key, String defaultValue) {
        return repo.findByKey(key).map(SystemSettingEntity::getValue).orElse(defaultValue);
    }

    // ── Helpers ────────────────────────────────────────────────────────────

    private void upsert(String key, String value) {
        SystemSettingEntity entity = repo.findByKey(key).orElseGet(() ->
                SystemSettingEntity.builder().key(key).build());
        entity.setValue(value);
        repo.save(entity);
    }

    private boolean parseBool(Map<String, String> map, String key, boolean def) {
        String v = map.get(key);
        return v != null ? Boolean.parseBoolean(v) : def;
    }

    private int parseInt(Map<String, String> map, String key, int def) {
        try { return Integer.parseInt(map.getOrDefault(key, String.valueOf(def))); }
        catch (NumberFormatException e) { return def; }
    }

    private BigDecimal parseBd(Map<String, String> map, String key, BigDecimal def) {
        try { return new BigDecimal(map.getOrDefault(key, def.toPlainString())); }
        catch (NumberFormatException e) { return def; }
    }
}
