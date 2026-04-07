package com.edtech.backend.cls.enums;

public enum ClassStatus {
    PENDING_APPROVAL, // PH gửi yêu cầu, chờ admin duyệt
    OPEN,
    ASSIGNED,
    MATCHED,
    ACTIVE,
    COMPLETED,
    CANCELLED,
    AUTO_CLOSED,  // Hết hạn 1 tháng không có GS nhận → tự đóng
    SUSPENDED     // Admin tạm hoãn lớp (nghỉ hè, lý do cá nhân...) — không tạo session, không tính phí
}
