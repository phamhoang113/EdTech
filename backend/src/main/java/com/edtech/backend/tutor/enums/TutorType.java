package com.edtech.backend.tutor.enums;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonValue;

/**
 * Loại (cấp độ) gia sư trong hệ thống.
 * Single Source of Truth: dashboard xác thực, filter lớp học, level_fees JSONB đều dùng enum này.
 *
 * HỆ THỐNG CÓ ĐÚNG 3 CẤP ĐỘ (thứ tự tăng dần theo kinh nghiệm):
 *   STUDENT   → Sinh viên
 *   GRADUATED → Gia sư Tốt nghiệp
 *   TEACHER   → Giáo viên
 */
public enum TutorType {
    STUDENT("Sinh viên"),
    GRADUATED("Gia sư Tốt nghiệp"),
    TEACHER("Giáo viên");

    private final String displayName;

    TutorType(String displayName) {
        this.displayName = displayName;
    }

    /** Serialize sang JSON dạng tên hiển thị tiếng Việt */
    @JsonValue
    public String getDisplayName() {
        return displayName;
    }

    /** Cho phép deserialize từ cả tên tiếng Việt lẫn key enum (để tương thích ngược) */
    @JsonCreator
    public static TutorType fromValue(String value) {
        for (TutorType t : values()) {
            if (t.name().equalsIgnoreCase(value) || t.displayName.equalsIgnoreCase(value)) {
                return t;
            }
        }
        throw new IllegalArgumentException("Unknown TutorType: " + value);
    }
}
