# 🔍 Gap Analysis & Execution Plan

**Người đánh giá:** Software Architect
**Cơ sở:** Mã nguồn hiện tại so với tài liệu Phân tích Nghiệp vụ (PRD).

Sau khi kiểm tra sâu vào Architecture của Backend và Frontend hiện tại, dưới đây là danh sách những thứ **Chưa làm / Bị sai lệch** và **Kế hoạch thực thi (Execution Plan)** để đạt 100% tài liệu BA.

---

## 1. Hiện trạng vs Yêu cầu BA (Gap Analysis)

### 🔴 1. Database & Entities (Lõi dữ liệu)
- **Hiện trạng:** 
  - Enum `SessionStatus` chỉ có 5 trạng thái cơ bản (`DRAFT`, `SCHEDULED`, `LIVE`, `COMPLETED`, `CANCELLED`), không thể phân biệt huỷ do ai hay có bị tranh chấp không.
  - Bảng `absence_requests` (tại `V44`) đang hardcode `student_id NOT NULL`, nghĩa là hệ thống hiện tại **không cho phép Gia sư xin nghỉ**.
- **Cần thay đổi:**
  - Viết script Flyway `V45` để cấu trúc lại bảng xin vắng mặt (đổi thành `requester_id` dùng chung cho cả GS và HS). Thêm cột `request_type`.
  - Bổ sung các Enum Status mới: `COMPLETED_PENDING`, `CANCELLED_BY_TUTOR`, `CANCELLED_BY_STUDENT`, `DISPUTED`.

### 🟡 2. Backend Admin APIs
- **Hiện trạng:** Có các controller quản lý Lớp (`AdminClassController`), Gia sư (`AdminTutorController`), nhưng **KHÔNG CÓ** controller nào quản trị Lịch dạy (Schedule), Đơn xin nghỉ (Absence), hay Tính lương (Payroll).
- **Cần thay đổi (Thêm mới 100%):**
  - Xây dựng `AdminScheduleController` (Xem lịch toàn cầu, Force Cancel).
  - Xây dựng `AdminAbsenceController` (Get danh sách đơn nghỉ, Approve, Reject).
  - Xây dựng `AdminPayrollController` (Tính toán số buổi `COMPLETED` ra tiền cho từng gia sư).

### 🟢 3. Frontend Web Admin & Client UI (Tutor/Parent/Student)
- **Hiện trạng (Admin):** Sidebar mới chỉ có Users, Tutors, Classes, Verification, Settings.
- **Hiện trạng (Client - GS/PH/HS):** Lịch dạy trên Dashboard Gia sư mới chỉ cho phép Đổi giờ nháp, CHƯA CÓ chức năng "Xin vắng mặt" cho buổi học đã SCHEDULED. Phụ huynh/Học sinh cũng chưa có chỗ tạo đơn xin nghỉ.
- **Cần thay đổi:**
  - **Admin UI:** Thêm Routing và Sidebar menu cho: Lịch dạy, Duyệt đơn nghỉ phép, Tính lương. Code 3 màn hình tương ứng.
  - **Client UI (GS/PH/HS):** Bổ sung nút "Xin vắng mặt" (Form tạo Đơn gửi Admin) trên màn hình Lịch dạy của Gia sư, Phụ huynh, và Học sinh. Hiển thị đầy đủ thông báo (Warning) về rules huỷ điểm/trừ tiền theo đúng PRD.

---

## 2. Kế hoạch Thực thi (Execution Roadmap)

Mô hình làm tiếp theo được chia thành 3 Giai đoạn (Phases) chạy tuần tự. **Team Dev sẽ bám sát lộ trình này để code:**

### Phase 1: Database & Core Entities (Backend)
1. Tạo file migration `V45__update_session_and_absence.sql`:
   - `ALTER TYPE session_status ADD VALUE 'COMPLETED_PENDING';`
   - `ALTER TYPE session_status ADD VALUE 'CANCELLED_BY_TUTOR';`
   - `ALTER TYPE session_status ADD VALUE 'CANCELLED_BY_STUDENT';`
   - `ALTER TYPE session_status ADD VALUE 'DISPUTED';`
   - Đổi cột `student_id` trong `absence_requests` thành `requester_id`. Thêm cột `request_type`.
2. Update Java Classes: `SessionStatus.java`, `AbsenceRequestEntity.java`.

### Phase 2: Core Admin Business Logic (Backend APIs)
1. Code `AdminScheduleService` + `AdminScheduleController`:
   - API `GET /api/v1/admin/schedule/sessions`
   - API `PUT /api/v1/admin/schedule/sessions/{id}/cancel`
2. Code `AdminAbsenceService` + `AdminAbsenceController`:
   - API `GET /api/v1/admin/absence-requests`
   - API `PUT .../{id}/approve` & `.../{id}/reject`
3. Code `AdminPayrollService` + `AdminPayrollController`:
   - API `GET /api/v1/admin/payroll/summary` chứa logic gom nhóm đếm số Session x Rate.

### Phase 3: Admin Web Interfaces (Frontend)
1. Khai báo API trong `adminApi.ts`.
2. Tạo màn `AdminSchedulePage.tsx`: DataGrid hiển thị toàn bộ lịch hệ thống, kèm bộ lọc thời gian.
3. Tạo màn `AdminAbsenceRequestsPage.tsx`: Quản lý danh sách Approve/Reject đơn xin nghỉ.
4. Tạo màn `AdminPayrollPage.tsx`: Báo cáo chốt công cuối tháng.
5. Gắn tất cả vào `AdminSidebar.tsx`.

### Phase 4: Client Interfaces (Tutor, Parent, Student UI)
1. Cấu hình Backend API: Endpoints POST `/api/v1/tutor/absence-requests` và POST `/api/v1/parent/absence-requests`.
2. Tích hợp API vào `tutorApi.ts` và `parentApi.ts` / `studentApi.ts`.
3. Cập nhật **Tutor Dashboard** (`TutorSchedulePage.tsx`): 
   - Thay Button "Huỷ buổi" trước đó bằng Form "Tạo đơn xin nghỉ". Cần upload ảnh và chọn ngày học bù.
4. Cập nhật **Parent/Student Dashboard** (`ParentSchedulePage.tsx`):
   - Thêm nút "Báo vắng", thiết kế UI chứa thông điệp cảnh báo cực rõ về policy hoàn phí.
5. Xử lý UI Notification (Chuông thông báo) cho GS/PH/HS khi Admin phê duyệt lịch hoặc đơn xin nghỉ.

---

Kế hoạch này đảm bảo **Luồng dữ liệu sạch từ gốc (Database), xử lý tập trung (Admin), và minh bạch luồng giao tiếp (Client UI)**.
