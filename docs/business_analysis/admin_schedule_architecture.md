# 🏗️ Tech Spec & Dev Plan: Admin Schedule & Leave Management

**Người viết:** System Architect & Tech Leads (BE + FE)
**Cơ sở:** Dựa trên PRD `admin_schedule_management_prd.md`

Tài liệu này hướng dẫn chi tiết cách BE và FE cần triển khai để đáp ứng yêu cầu tính lương, quản lý lịch và duyệt nghỉ phép.

---

## 1. System Architecture & Database Design

### 1.1 Khảo sát hiện trạng (Current State)
- Đã có bảng `sessions` lưu lịch học (status: DRAFT, SCHEDULED, LIVE, COMPLETED, CANCELLED).
- Đã có bảng `absence_requests` (ở file `V44`) nhưng **chỉ hỗ trợ Học sinh xin nghỉ** (`student_id NOT NULL`), kịch bản cũ là Học sinh gửi -> Gia sư duyệt.

### 1.2 Thiết kế mới (Database Changes)
Cần tạo file migration `V45__update_absence_requests_for_admin.sql` để định nghĩa lại hệ thống xin nghỉ phép:
- **Đổi tên / Sửa cột:** Đổi `student_id` thành `requester_id` (tham chiếu đến `users(id)` có thể là Gia sư hoặc Phụ huynh/Học sinh).
- **Thêm cột `request_type`:** Enum `('TUTOR_LEAVE', 'STUDENT_LEAVE')`.
- **Cập nhật quy trình Duyệt (Approve/Reject):** Admin sẽ là người duyệt (vào cột `reviewed_by`).
- **Thêm bảng `payroll_records` (Optional):** Hoặc tạo cột `is_paid` trong bảng `sessions` để theo dõi các session đã được đối soát và trả lương cuối tháng.

### 1.3 Logic chuyển đổi trạng thái (State Machine)
Khi Admin duyệt đơn `absence_requests` (chuyển sang `APPROVED`):
- BE sẽ lấy `session_id` được liên kết.
- Nếu `request_type == 'TUTOR_LEAVE'`: `session.setStatus(CANCELLED_BY_TUTOR)` (Có thể cần update enum `SessionStatus` để tách bạch loại CANCEL). Hoặc vẫn giữ `CANCELLED` nhưng lưu `cancel_reason`.
- Tính lương: API `/api/v1/admin/payroll/summary` sẽ query bảng `sessions` đếm những buổi `COMPLETED`.

---

## 2. Backend Implementation Plan (BE Dev)

### 2.1 API Lịch dạy (Admin Schedule API)
Tạo `AdminScheduleController` (`/api/v1/admin/schedule`):
1. **[GET] `/sessions`**:
   - Query: `startDate`, `endDate`, `tutorId` (optional), `classId` (optional), `status` (optional).
   - Response: List `SessionDTO` có join thêm profile tutor và student để hiển thị tên + SĐT.
2. **[PUT] `/sessions/{sessionId}/cancel`**:
   - Body: `String reason`.
   - Logic: Force đổi status thành `CANCELLED`. Lưu lý do huỷ vào log/note.

### 2.2 API Nghỉ phép (Admin Absence API)
Đưa màn duyệt đơn về Admin (`AdminAbsenceController`):
1. **[GET] `/absence-requests`**:
   - Mặc định load status `PENDING`. Có thể filter `APPROVED`, `REJECTED`.
2. **[PUT] `/absence-requests/{id}/approve`**:
   - Logic: Đổi status đơn -> `APPROVED`. Find Session -> Xử lý (Cancel session, gửi noti). Yêu cầu tạo session MAKEUP nháp (tuỳ chọn).
3. **[PUT] `/absence-requests/{id}/reject`**:
   - Body: `String rejectReason`. Đổi status đơn -> `REJECTED`. Session vẫn giữ `SCHEDULED`.

### 2.3 API Báo cáo & Lương (Admin Payroll API)
Tạo `AdminPayrollController` (`/api/v1/admin/payroll`):
1. **[GET] `/summary`**:
   - Query: `month`, `year`.
   - Response: Gom nhóm theo Tutor (TutorName, TutorPhone). Đếm: `completedSessions`, `cancelledByTutor`, `totalAmount` = `completedSessions * tutorFeeCard`.

---

## 3. Frontend Implementation Plan (FE Dev)

### 3.1 Cấu trúc & Layout
Thêm menu vào `AdminSidebar.tsx`:
- `Lịch học toàn cầu` (Global Calendar)
- `Đơn vắng mặt` (Absence Requests có badge đỏ với Zustand store lấy số đơn PENDING).
- `Thống kê & Lương` (Payroll summary).

### 3.2 Các Component/Trang cần xây dựng
1. **`AdminSchedulePage.tsx`**:
   - Header có DatePicker, Tutor Select.
   - Body: Dùng dạng **Grid DataTable** hoặc **DataGrid Calendar** để hiện các Session.
   - Action: Cột "Thao tác" -> Có nút huỷ khẩn cấp (màu đỏ).
   - Modal Force Cancel: Nhập lý do (Bắt buộc).
2. **`AdminAbsenseRequestsPage.tsx`**:
   - Tab layout: `Chờ duyệt` | `Đã xử lý`
   - List/Card view: `<Avatar>`, *Tên gia sư*, *Xin nghỉ lớp Toán ngày X*.
   - Nút Duyệt / Nút Từ chối (mở modal nhập lý do).
3. **`AdminPayrollPage.tsx`**:
   - Chốt công cuối tháng. Hiển thị bảng chi tiết:
     - Cột Gia sư | Tổng lớp | Tổng buổi HT | Số buổi xin nghỉ | Tạm tính Lương.
     - Action: Export Excel (FE export dạng CSV hoặc gọi API trả file Blob).

### 3.3 State Management & API Client
Trong `adminApi.ts` thêm:
- `getAllSessions(params)`
- `forceCancelSession(id)`
- `getAbsenceRequests(params)`
- `approveRequest(id)`
- `rejectRequest(id, reason)`
- `getPayrollSummary(month, year)`

---

## 4. Rủi ro & Chú ý (Risks & Notes)
- Phân biệt rõ `CANCELLED` do hệ thống (auto-cancel nếu draft quá hạn) với `CANCELLED` do nghỉ phép.
- Đồng hồ Database: Báo cáo tính lương phụ thuộc timezone. Cầm đảm bảo timezone lưu UTC nhưng query / xuất báo cáo dùng LocalTime cho đúng thứ/ngày.
- Real-time: Nên dùng WebSocket để đẩy thông báo (`NotificationEntity`) cho Admin khi có người tạo `absence_request` mới để badge tự `+1`.
