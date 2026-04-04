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
    STUDENT("Sinh viên", 1),
    GRADUATED("Gia sư Tốt nghiệp", 2),
    TEACHER("Giáo viên", 3);

    private final String displayName;
    private final int weight;

    TutorType(String displayName, int weight) {
        this.displayName = displayName;
        this.weight = weight;
    }

    /** Serialize sang JSON dạng tên hiển thị tiếng Việt */
    @JsonValue
    public String getDisplayName() {
        return displayName;
    }

    public int getWeight() {
        return weight;
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

    private static final com.fasterxml.jackson.databind.ObjectMapper SORT_MAPPER = new com.fasterxml.jackson.databind.ObjectMapper();

    public static String sortLevelFeesJson(String rawJson) {
        if (rawJson == null || rawJson.isBlank() || !rawJson.trim().startsWith("[")) {
            return rawJson;
        }
        try {
            java.util.List<java.util.Map<String, Object>> list = SORT_MAPPER.readValue(rawJson, new com.fasterxml.jackson.core.type.TypeReference<java.util.List<java.util.Map<String, Object>>>() {});
            list.sort((m1, m2) -> {
                String l1 = (String) m1.get("level");
                String l2 = (String) m2.get("level");
                int w1 = 99; int w2 = 99;
                if (l1 != null) { try { w1 = TutorType.fromValue(l1).getWeight(); } catch(Exception e){} }
                if (l2 != null) { try { w2 = TutorType.fromValue(l2).getWeight(); } catch(Exception e){} }
                return Integer.compare(w1, w2);
            });
            return SORT_MAPPER.writeValueAsString(list);
        } catch (Exception e) {
            return rawJson;
        }
    }
}
