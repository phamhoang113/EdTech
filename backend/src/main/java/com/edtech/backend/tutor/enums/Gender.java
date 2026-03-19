package com.edtech.backend.tutor.enums;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonValue;

/**
 * Giới tính trong hệ thống.
 * Single Source of Truth: filter lớp học, yêu cầu gia sư đều dùng enum này.
 */
public enum Gender {
    MALE("Nam"),
    FEMALE("Nữ");

    private final String displayName;

    Gender(String displayName) {
        this.displayName = displayName;
    }

    @JsonValue
    public String getDisplayName() {
        return displayName;
    }

    @JsonCreator
    public static Gender fromValue(String value) {
        for (Gender g : values()) {
            if (g.name().equalsIgnoreCase(value) || g.displayName.equalsIgnoreCase(value)) {
                return g;
            }
        }
        throw new IllegalArgumentException("Unknown Gender: " + value);
    }
}
