package com.edtech.backend.admin.dto;

import java.math.BigDecimal;

/**
 * Body cho PATCH /api/v1/admin/classes/{id}/approve.
 *
 * @param tutorFee      Lương GS thấy khi ứng tuyển (hiển thị công khai). Nếu null → tự tính từ feePercentage.
 * @param levelFees     JSON array [{level, tutor_fee}] đã được admin chỉnh sửa. Nếu null → giữ nguyên.
 * @param feePercentage % TT nhận trên lương GS thấy. Nếu null → giữ giá trị hiện tại.
 */
public record ApproveClassRequest(BigDecimal tutorFee, String levelFees, String tutorProposals, Integer feePercentage) {}
