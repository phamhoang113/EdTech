package com.edtech.backend.tutor.enums;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonValue;

/**
 * Danh sách môn học trong hệ thống.
 * Single Source of Truth: dùng cho filter lớp học, xác thực gia sư, và tạo lớp học.
 * Môn học là môn cố định trong enum. Môn tùy chỉnh (PH nhập) lưu thẳng vào DB theo chuỗi.
 */
public enum Subject {
    MATH("Toán"),
    PHYSICS("Vật Lý"),
    CHEMISTRY("Hóa Học"),
    BIOLOGY("Sinh Học"),
    LITERATURE("Ngữ Văn"),
    ENGLISH("Tiếng Anh"),
    INFORMATICS("Tin Học"),
    OTHER("Khác");

    private final String displayName;

    Subject(String displayName) {
        this.displayName = displayName;
    }

    @JsonValue
    public String getDisplayName() {
        return displayName;
    }

    @JsonCreator
    public static Subject fromValue(String value) {
        for (Subject s : values()) {
            if (s.name().equalsIgnoreCase(value) || s.displayName.equalsIgnoreCase(value)) {
                return s;
            }
        }
        throw new IllegalArgumentException("Unknown Subject: " + value);
    }
}
