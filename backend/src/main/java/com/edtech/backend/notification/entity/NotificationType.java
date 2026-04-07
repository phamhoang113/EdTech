package com.edtech.backend.notification.entity;

public enum NotificationType {
    CLASS_OPENED,
    APPLICATION_RECEIVED,
    APPLICATION_ACCEPTED,
    APPLICATION_REJECTED,
    INVOICE_RECEIPT_UPLOADED,
    INVOICE_APPROVED,
    INVOICE_REJECTED,
    SESSION_REMINDER,
    MEET_LINK_SET,
    ASSESSMENT_PUBLISHED,
    SUBMISSION_GRADED,
    PAYOUT_TRANSFERRED,
    CLASS_CANCELLED,
    CLASS_SUSPENDED,          // Lớp bị tạm hoãn
    CLASS_RESUMED,            // Lớp được kích hoạt lại
    CLASS_SUSPEND_REMINDER,   // Nhắc nhở sắp hết thời gian tạm hoãn
    NEW_MESSAGE    // Added for messaging phase
}
