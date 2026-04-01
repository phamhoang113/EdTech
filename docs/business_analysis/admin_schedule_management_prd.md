# 📄 PRD: Admin - Quản lý lịch dạy & Duyệt nghỉ phép (Schedule & Attendance Management)

**Người viết:** BA (Antigravity)
**Mục tiêu:** Cung cấp tài liệu nghiệp vụ rõ ràng để xây dựng module quản trị lịch dạy, xử lý đơn xin nghỉ của gia sư, và cung cấp dữ liệu chính xác tuyệt đối để phục vụ việc **tính lương** và **đánh giá KPI**.

---

## 1. Mục đích & Tầm quan trọng
Luồng quản lý lịch dạy và điểm danh là **trái tim của hệ thống vận hành**. Nó quyết định:
- **Tài chính:** Tính lương cho gia sư đúng (dựa trên số buổi dạy thành công) & hoàn tiền/trừ buổi học viên chính xác.
- **Chất lượng:** Đảm bảo lớp học diễn ra đúng cam kết, không có tình trạng gia sư bỏ lớp không báo trước.
- **Vận hành:** Cho phép Admin can thiệp kịp thời khi có sự cố (gia sư ốm đột xuất, học sinh xin nghỉ).

---

## 2. Các chức năng chính (Functional Requirements)

### 2.1. Quản lý toàn bộ lịch dạy (Global Schedule View)
Admin cần một màn hình để giám sát tất cả buổi học đang diễn ra trên hệ thống.

**Thông tin hiển thị cần thiết:**
- **Bộ lọc (Filters):** Lọc theo khoảng thời gian (ngày/tuần/tháng), trạng thái buổi học (`DRAFT`, `SCHEDULED`, `LIVE`, `COMPLETED`, `CANCELLED`), theo Gia sư, theo Lớp học.
- **Dữ liệu mỗi buổi học:** 
  - Tên lớp, Môn học, Tên & SĐT Gia sư, Tên & SĐT Phụ huynh/Học sinh.
  - Thời gian bắt đầu - kết thúc.
  - Trạng thái điểm danh (Gia sư đã check-in chưa? Học sinh có mặt không?).
- **Quyền hạn của Admin (Actions):**
  - Xem chi tiết buổi học (link Meet, ghi chú).
  - **Force Cancel/Update:** Admin có quyền huỷ hoặc đổi giờ buổi học trong trường hợp khẩn cấp (có popup ghi lý do).

### 2.2. Quản lý Đơn xin nghỉ / Báo vắng (Absence Requests)
Gia sư hoặc Phụ huynh không thể tự ý xoá buổi học đã `SCHEDULED` sát giờ. Họ phải tạo "Đơn xin vắng mặt".

**Thông tin hiển thị cần thiết (Màn hình Duyệt đơn):**
- Danh sách đơn chờ duyệt (`PENDING`), đã duyệt (`APPROVED`), từ chối (`REJECTED`).
- **Chi tiết đơn:**
  - Người gửi: Gia sư X (hoặc Phụ huynh Y).
  - Buổi học bị ảnh hưởng (Ngày, giờ, lớp).
  - **Lý do & Minh chứng:** Bắt buộc chọn lý do (Ốm đau, Sự cố mạng, Lịch thi đột xuất...) và có thể đính kèm ảnh (giấy khám bệnh, v.v.).
  - Thời gian gửi đơn (để check xem có vi phạm rule "báo trước 12h" hay không).
  - **Đề xuất học bù (Makeup Session):** Khung giờ dự kiến học bù (nếu có).

**Quyền hạn của Admin (Actions):**
- **Duyệt (Approve):** Hệ thống tự động chuyển Trạng thái buổi học thành `CANCELLED` (Lý do: Gia sư nghỉ / Học sinh nghỉ). Nếu có lịch học bù, tự động tạo ra 1 session mới dạng `DRAFT` hoặc `SCHEDULED`.
- **Từ chối (Reject):** Ghi rõ lý do từ chối. Buổi học vẫn giữ nguyên trạng thái `SCHEDULED`. Gia sư bắt buộc phải dạy (nếu không sẽ bị tính là vi phạm).

### 2.3. Báo cáo chốt công & Tính lương (Attendance & Payroll Prep)
Màn hình tổng hợp dữ liệu cuối tháng để gửi sang kế toán.

**Thông tin hiển thị cần thiết:**
- Chọn Tháng/Năm.
- Chọn Gia sư (hoặc xem danh sách tất cả Gia sư).
- **Chỉ số của từng Gia sư:**
  - Tổng số buổi `COMPLETED` (Hợp lệ để tính lương).
  - Tổng số buổi `CANCELLED` do lỗi gia sư (Dùng để phạt/trừ KPI).
  - Tổng số buổi `CANCELLED` do lỗi học sinh (Tuỳ chính sách có trả 50% hay 100% lương cho gia sư không).
  - Số phút đi muộn / Về sớm tổng cộng (nếu hệ thống có check-in/out chặt chẽ).
- **Export Excel:** Nút xuất dữ liệu thô để đối soát.

---

## 3. Quy định & Rule nghiệp vụ (Business Rules) cần code

1. **Rule hủy lịch (Cancellation Policy):**
   - Hủy trước **24 giờ**: Tự động duyệt hoặc không phạt.
   - Hủy trước **2-24 giờ**: Cần Admin duyệt, có thể ghi nhận vào tỷ lệ hủy lớp.
   - Hủy **dưới 2 giờ** hoặc Không phép (No-show): Đánh dấu lỗi vi phạm nghiêm trọng (Strike), ảnh hưởng trực tiếp đến thanh toán.

2. **Rule chốt buổi học (Session Completion):**
   - Một buổi học chỉ được tính là `COMPLETED` khi: (1) Đã qua thời gian kết thúc của buổi học VÀ (2) Cả gia sư và học sinh đều không có khiếu nại (Dispute).
   - Nếu Phụ huynh vote 1 sao hoặc báo "Gia sư không vào lớp", trạng thái buổi học chuyển sang `DISPUTED_PENDING` và Admin phải nhảy vào phân xử trước khi tính lương.

3. **Rule về trạng thái buổi học liên quan đến luồng này:**
   - Khi Admin duyệt nghỉ $\rightarrow$ Buổi học chuyển sang `CANCELLED`.
   - Cần có thêm sub-status để phân biệt: `CANCELLED_BY_TUTOR`, `CANCELLED_BY_STUDENT`, `CANCELLED_BY_ADMIN`.

---

## 4. Đề xuất luồng UI/UX cho Admin
- **Sidebar Menu:** Thêm 2 mục lớn:
  1. `Lịch giảng dạy` (Xem tất cả calendar)
  2. `Yêu cầu & Khiếu nại` (Có badge màu đỏ hiển thị số đơn xin nghỉ đang chờ duyệt `PENDING`).
- **Dashboard:** Ngay khi đăng nhập, Admin thấy ngay widget: *"Có 3 đơn xin vắng mặt hôm nay cần xử lý gấp!"*.

---

*Tài liệu này là Base PRD. Dev team có thể dựa vào đây để xác định các bảng cần thêm trong Database (như bảng `absence_requests`, bảng lịch sử thay đổi `session_logs`) và các API cần viết.*
