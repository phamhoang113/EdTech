package com.edtech.backend.tutor.enums;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonValue;

/**
 * Cấp độ / lớp học trong hệ thống.
 * Single Source of Truth: filter lớp học, xác thực gia sư, tạo lớp học đều dùng enum này.
 */
public enum GradeLevel {
    PRESCHOOL("Mầm non"),
    GRADE_1("Lớp 1"),
    GRADE_2("Lớp 2"),
    GRADE_3("Lớp 3"),
    GRADE_4("Lớp 4"),
    GRADE_5("Lớp 5"),
    GRADE_6("Lớp 6"),
    GRADE_7("Lớp 7"),
    GRADE_8("Lớp 8"),
    GRADE_9("Lớp 9"),
    GRADE_10("Lớp 10"),
    GRADE_11("Lớp 11"),
    GRADE_12("Lớp 12"),
    UNIVERSITY("Đại học"),
    OTHER("Khác");

    private final String displayName;

    GradeLevel(String displayName) {
        this.displayName = displayName;
    }

    @JsonValue
    public String getDisplayName() {
        return displayName;
    }

    @JsonCreator
    public static GradeLevel fromValue(String value) {
        for (GradeLevel g : values()) {
            if (g.name().equalsIgnoreCase(value) || g.displayName.equalsIgnoreCase(value)) {
                return g;
            }
        }
        throw new IllegalArgumentException("Unknown GradeLevel: " + value);
    }
}
