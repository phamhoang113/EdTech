package com.edtech.backend.student.service;

import java.util.List;
import java.util.UUID;

import com.edtech.backend.student.dto.ParentLinkResponse;
import com.edtech.backend.student.dto.StudentRequest;
import com.edtech.backend.student.dto.StudentResponse;

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

    /** (Student) Gửi yêu cầu liên kết tới Phụ huynh qua SDT (tự động duyệt) */
    void requestParentLink(UUID studentId, String parentPhone);

    /** (Student) Xem danh sách yêu cầu liên kết từ phụ huynh PENDING hoặc ACCEPTED */
    List<ParentLinkResponse> getParentLinks(UUID studentId);

    /** (Student) Chấp thuận liên kết do phụ huynh gửi */
    void acceptParentLink(UUID studentId, UUID linkId);

    /** (Student) Từ chối liên kết do phụ huynh gửi */
    void rejectParentLink(UUID studentId, UUID linkId);

    /** (Parent) Đặt lại mật khẩu cho con em */
    void resetChildPassword(UUID studentProfileId, UUID parentId, String newPassword);
}
