package com.edtech.backend.core.entity;

import jakarta.persistence.*;
import lombok.*;

/** Lưu cấu hình hệ thống theo dạng key-value */
@Entity
@Table(name = "system_settings")
@Getter
@Setter
@Builder
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
public class SystemSettingEntity extends BaseEntity {

    @Column(nullable = false, unique = true, length = 100)
    private String key;

    @Column(columnDefinition = "TEXT")
    private String value;

    @Column(length = 500)
    private String description;
}
