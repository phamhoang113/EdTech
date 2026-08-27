package com.edtech.backend.admin.dto;

/**
 * Request body cho endpoint cập nhật phí lớp OPEN.
 * @param levelFees      JSON array [{level, fee}] — tiền PH trả theo từng loại GS. Null → giữ nguyên.
 * @param tutorProposals JSON array [{level, fee}] — tiền TT set cho GS thấy. Null → giữ nguyên.
 * @param feePercentage  % phí nhận lớp 1 lần. Null → giữ nguyên.
 */
public record UpdateClassFeesRequest(
        String levelFees,
        String tutorProposals,
        Integer feePercentage
) {}
