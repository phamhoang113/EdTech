package com.edtech.backend.student.service;

import com.edtech.backend.student.dto.StudentRequest;
import com.edtech.backend.student.dto.StudentResponse;

import java.util.List;
import java.util.UUID;

public interface StudentService {

    /** Tìm học sinh theo SĐT — trả null nếu không tồn tại, error nếu không phải STUDENT role */
    StudentResponse lookupByPhone(String phone);

    /** Lấy danh sách con em của phụ huynh */
    List<StudentResponse> getChildrenByParentId(UUID parentId);

    /** Thêm con em (tạo mới hoặc link tài khoản đã có) */
    StudentResponse addChild(StudentRequest request, UUID parentId);

    /** Cập nhật thông tin con em */
    StudentResponse updateChild(UUID studentProfileId, UUID parentId, StudentRequest request);

    /** Xoá liên kết con em */
    void removeChild(UUID studentProfileId, UUID parentId);

    /** (Student) Xem danh sách yêu cầu liên kết từ phụ huynh PENDING hoặc ACCEPTED */
    List<com.edtech.backend.student.dto.ParentLinkResponse> getParentLinks(UUID studentId);

    /** (Student) Chấp thuận liên kết */
    void acceptParentLink(UUID studentId, UUID linkId);

    /** (Student) Từ chối liên kết */
    void rejectParentLink(UUID studentId, UUID linkId);
}
