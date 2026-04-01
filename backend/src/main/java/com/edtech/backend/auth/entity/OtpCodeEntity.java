package com.edtech.backend.auth.entity;

import com.edtech.backend.auth.enums.OtpPurpose;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.GenericGenerator;

import java.time.Instant;
import java.util.UUID;

@Entity
@Table(name = "otp_codes")
@Getter
@Setter
@Builder
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
public class OtpCodeEntity {

    @Id
    @GeneratedValue(generator = "UUID")
    @GenericGenerator(name = "UUID", strategy = "org.hibernate.id.UUIDGenerator")
    @Column(updatable = false, nullable = false)
    private UUID id;

    @Column(nullable = false, length = 20)
    private String phone;

    @Column(nullable = false, length = 10)
    private String code;

    /**
     * Purpose dùng enum thay vì raw String.
     * Lưu DB dạng STRING (REGISTER, RESET_PASSWORD, CHANGE_PHONE).
     */
    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 50)
    private OtpPurpose purpose;

    /**
     * UUID được trả cho client sau khi đăng ký.
     * Client dùng otpToken + code để verify — không cần gửi lại phone.
     */
    @Column(name = "otp_token", nullable = false, updatable = false, unique = true)
    @Builder.Default
    private UUID otpToken = UUID.randomUUID();

    @Column(name = "is_used", nullable = false)
    @Builder.Default
    private Boolean isUsed = false;

    @Column(name = "expires_at", nullable = false)
    private Instant expiresAt;

    @Column(name = "created_at", nullable = false, updatable = false)
    @Builder.Default
    private Instant createdAt = Instant.now();
}
