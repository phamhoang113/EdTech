package com.edtech.backend.cls.enums;

import java.time.DayOfWeek;

/**
 * Enum ánh xạ mã ngày trong tuần (VN + EN) sang {@link DayOfWeek}.
 * Hỗ trợ cả format "T2".."CN" và "Monday".."Sunday" cho backward compat.
 */
public enum WeekDay {

    MONDAY("T2", "Thứ 2", DayOfWeek.MONDAY),
    TUESDAY("T3", "Thứ 3", DayOfWeek.TUESDAY),
    WEDNESDAY("T4", "Thứ 4", DayOfWeek.WEDNESDAY),
    THURSDAY("T5", "Thứ 5", DayOfWeek.THURSDAY),
    FRIDAY("T6", "Thứ 6", DayOfWeek.FRIDAY),
    SATURDAY("T7", "Thứ 7", DayOfWeek.SATURDAY),
    SUNDAY("CN", "Chủ nhật", DayOfWeek.SUNDAY);

    private final String code;
    private final String label;
    private final DayOfWeek dayOfWeek;

    WeekDay(String code, String label, DayOfWeek dayOfWeek) {
        this.code = code;
        this.label = label;
        this.dayOfWeek = dayOfWeek;
    }

    public String getCode() { return code; }
    public String getLabel() { return label; }
    public DayOfWeek toDayOfWeek() { return dayOfWeek; }

    /**
     * Resolve mã ngày → {@link DayOfWeek}.
     * Chấp nhận mã VN ("T2".."CN") hoặc tên EN ("Monday".."Sunday").
     *
     * @return DayOfWeek hoặc null nếu không hợp lệ
     */
    public static DayOfWeek resolve(String input) {
        if (input == null) return null;
        for (WeekDay weekDay : values()) {
            if (weekDay.code.equals(input)) return weekDay.dayOfWeek;
        }
        // Backward compat: English day name
        try {
            return DayOfWeek.valueOf(input.toUpperCase());
        } catch (IllegalArgumentException e) {
            return null;
        }
    }
}
