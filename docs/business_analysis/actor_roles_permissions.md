# 👥 Phân tích Vai trò & Quyền hạn (Roles & Permissions Matrix)

**Người viết:** BA (Antigravity)
**Mục tiêu:** Định nghĩa chuẩn xác 100% vai trò, giới hạn quyền lực của từng Actor (người dùng/hệ thống) trong nền tảng EdTech. File này là căn cứ cốt lõi (Source of Truth) để System Architect thiết kế Database Role-Based Access Control (RBAC) và phân rã các module hợp lý, tránh sai lệch luồng nghiệp vụ.

---

## 1. Định nghĩa các Actor (Actors Definition)

Hệ thống có **5 nhóm Actor** chính bao gồm 4 nhóm con người và 1 nhóm máy móc tự động:

| Actor | Ký hiệu | Mô tả ngắn | Mối quan hệ chính |
|---|---|---|---|
| **Học sinh (Student)** | `STD` | Người trực tiếp học. Ít quyền quyết định tài chính. | Một Phụ huynh có thể quản lý nhiều Học sinh. |
| **Phụ huynh (Parent)** | `PRT` | Người chi trả tiền, quyết định thuê gia sư. Giám sát lịch học. | Liên kết 1-n với Học sinh. Quản lý ví tiền/thanh toán. |
| **Gia sư (Tutor)** | `TUT` | Người cung cấp dịch vụ giảng dạy. | Nhận lớp từ PRT/Hệ thống. |
| **Quản trị viên (Admin)** | `ADM` | Người điều hành nền tảng (Staff/Mod/SuperAdmin). | Quyền lực cao nhất, quản lý dòng tiền, xử lý tranh chấp. |
| **Hệ thống (System)** | `SYS` | Các cron-job chạy ngầm (Quartz/Spring Scheduler). | Tự động hoá luồng nghiệp vụ (tạo lịch, huỷ lớp, chuyển trạng thái). |

---

## 2. Phân quyền chi tiết theo Luồng nghiệp vụ (Functional Permissions Matrix)

*Quy ước:* 
- ✅ (Được làm toàn quyền)
- 👁 (Chỉ được xem)
- ❌ (Không có quyền)
- ⚠️ (Được làm nhưng cần Admin duyệt hoặc có rào cản)

### 2.1 Luồng Hồ sơ & Xác thực (Auth & Profile)

| Chức năng | Admin | Gia sư | Phụ huynh | Học sinh | Ghi chú cho Architect |
|---|:---:|:---:|:---:|:---:|---|
| Tạo tài khoản / OTP | ✅ | ✅ | ✅ | ✅ | |
| Cập nhật Profile cá nhân | ✅ | ✅ | ✅ | ✅ | |
| Thêm/Sửa bằng cấp, CCCD | 👁 | ⚠️ | ❌ | ❌ | Gia sư sửa profile sẽ kích hoạt trạng thái `PENDING_APPROVAL`, Admin duyệt mới hiện lên trang tìm kiếm. |
| Duyệt hồ sơ Gia sư | ✅ | ❌ | ❌ | ❌ | |
| Liên kết tài khoản PRT - STD | 👁 | ❌ | ✅ | ✅ | PRT tạo mã liên kết, STD nhập mã để kết nối. |
| Khoá/Ban tài khoản bất kỳ | ✅ | ❌ | ❌ | ❌ | |

### 2.2 Luồng Tìm kiếm & Đăng ký Lớp (Discovery & Booking)

| Chức năng | Admin | Gia sư | Phụ huynh | Học sinh | Ghi chú cho Architect |
|---|:---:|:---:|:---:|:---:|---|
| Đăng tìm gia sư (Tạo Request) | 👁 | ❌ | ✅ | ❌ | Chỉ PRT được phép tạo yêu cầu (để đảm bảo thanh toán). STD chỉ được xem. |
| Ứng tuyển vào lớp (Apply) | ❌ | ✅ | ❌ | ❌ | Gia sư gửi Proposal (Báo giá, giới thiệu). |
| Chọn Gia sư và Chốt lớp | 👁 | ❌ | ✅ | ❌ | PRT chốt Tutor, hệ thống sinh ra `ClassEntity`. |
| Theo dõi trạng thái Request | 👁 | 👁 | ✅ | 👁 | |

### 2.3 Luồng Quản lý Lớp học (Class Management)

| Chức năng | Admin | Gia sư | Phụ huynh | Học sinh | Ghi chú cho Architect |
|---|:---:|:---:|:---:|:---:|---|
| Set Lịch dạy mẫu của Lớp | 👁 | ✅ | 👁 | 👁 | TUT phải thao tác tạo Schedule Template (thứ mấy lúc mấy giờ). |
| Thêm/bớt Học sinh vào Lớp | ✅ | ❌ | ⚠️ | ❌ | PRT gửi yêu cầu (cho lớp nhóm), ADM/TUT duyệt. |
| Kết thúc Lớp (Hoàn thành) | ✅ | ⚠️ | ⚠️ | ❌ | TUT/PRT báo cáo hoàn thành lộ trình, kết thúc lớp. |
| Đóng cửa Lớp (Huỷ ngang) | ✅ | ⚠️ | ⚠️ | ❌ | Huỷ ngang phải thông qua ADM để đối soát tiền. |

### 2.4 Luồng Buổi dạy & Điểm danh (Session & Attendance)

Đây là luồng hay bị sai lệch nhất, cần map rõ quyền.

| Chức năng | Admin | Gia sư | Phụ huynh | Học sinh | Ghi chú cho Architect |
|---|:---:|:---:|:---:|:---:|---|
| **Tạo lịch nháp** (Generate Drafts) | ✅ | ✅ | ❌ | ❌ | TUT bấm nút tạo hoặc `SYS` tự tạo hàng tuần. Trạng thái `DRAFT`. |
| **Xác nhận lịch tuần/tháng** | 👁 | ✅ | 👁 | 👁 | TUT bấm "Confirm", lịch nhảy từ `DRAFT` $\rightarrow$ `SCHEDULED`. Cả PRT và STD sẽ thấy lịch này. |
| Báo cáo Hoàn thành buổi học | 👁 | ✅ | ❌ | ❌ | TUT bấm hoàn thành, session $\rightarrow$ `COMPLETED_PENDING_REVIEW` |
| Phản hồi chất lượng buổi học | 👁 | ❌ | ✅ | ✅ | Sau khi TUT nhấn Hoàn thành, PRT/STD có 24h để khiếu nại hoặc rating. Hệ thống auto-chuyển sang `COMPLETED_FINAL` sau 24h nếu không có khiếu nại. |
| Force Cancel/Đổi lịch sự cố | ✅ | ❌ | ❌ | ❌ | Chỉ Admin có quyền Force Edit buổi học đang `SCHEDULED`. |

### 2.5 Luồng Xin nghỉ phép & Học bù (Absence Request & Make up)

**Tuyệt đối không cho TUT/PRT tự ý đổi/xoá lịch đã SCHEDULED.** Họ phải đi qua luồng tạo Đơn xin nghỉ.

| Chức năng | Admin | Gia sư | Phụ huynh | Học sinh | Ghi chú cho Architect |
|---|:---:|:---:|:---:|:---:|---|
| Tạo đơn Xin vắng mặt (Absence) | ❌ | ✅ | ✅ | ⚠️ | STD chỉ được tạo nếu PRT cho phép, còn cơ bản PRT/TUT tạo. |
| Duyệt Đơn xin vắng mặt | ✅ | ❌ | ❌ | ❌ | **Chỉ Admin mới có quyền duyệt**. Khi duyệt, Session sẽ tự động huỷ (`CANCELLED_BY_TUTOR` hoặc `CANCELLED_BY_STUDENT`). |
| Đề xuất lịch học bù | 👁 | ✅ | ✅ | ❌ | Đi kèm trong Đơn xin nghỉ. Khi ADM duyệt vắng mặt, tự động tạo Session nháp mới ở khung giờ học bù. |

### 2.6 Luồng Thanh toán & Tính lương (Billing & Payroll)

| Chức năng | Admin | Gia sư | Phụ huynh | Học sinh | Ghi chú cho Architect |
|---|:---:|:---:|:---:|:---:|---|
| Nạp tiền / Thanh toán hoá đơn | 👁 | ❌ | ✅ | ❌ | PRT thanh toán học phí. Dòng tiền vào hệ thống. |
| Rút tiền (Thu nhập Gia sư) | 👁 | ✅ | ❌ | ❌ | TUT tạo lệch Withdrawal Request. Gửi cho ADM xử lý. |
| Duyệt Yêu cầu Rút tiền | ✅ | ❌ | ❌ | ❌ | ADM kiểm tra và thực hiện đối soát ngân hàng. |
| Tổng kết Lương/Thưởng cuối tháng | ✅ | 👁 | ❌ | ❌ | ADM chốt công dựa trên số Session = `COMPLETED_FINAL` trừ đi tiền phạt do số lượng đơn huỷ lỗi TUT. |

---

## 3. Workflow tương tác chuẩn giữa các Actor (Interaction Model)

Để dễ hình dung, dưới đây là quy trình vận hành chuẩn mà Architect cần bám sát để chia Controller / Service:

1. **Khởi tạo:** Gia sư `TUT` đăng ký tài khoản $\rightarrow$ `ADM` duyệt hồ sơ $\rightarrow$ Tài khoản Active.
2. **Tìm Lớp:** Phụ huynh `PRT` tạo Yêu cầu học (Lớp Toán lớp 9) $\rightarrow$ Nhiều Gia sư `TUT` Apply $\rightarrow$ Phụ huynh chọn Gia sư `A`.
3. **Thành lập Lớp:** Hệ thống sinh mã Lớp (`ClassEntity`). Cả `PRT`, `TUT`, `STD` (con của PRT) đều được assign vào lớp này.
4. **Vận hành Hành tuần:**
    - `TUT` (hoặc `SYS`) sinh lịch nháp hàng tuần.
    - `TUT` xác nhận lịch. `PRT` và `STD` nhận Noti.
    - Học xong, `TUT` xác nhận hoàn thành, `PRT` vote 5 sao (Đóng tiền cho buổi đó).
5. **Sự cố:**
    - `TUT` ốm $\rightarrow$ `TUT` gửi *Absence Request*.
    - `ADM` nhận thông báo $\rightarrow$ `ADM` vào duyệt đơn $\rightarrow$ Lịch báo huỷ cho `PRT/STD`, tạo lịch học bù (nếu có yêu cầu).
6. **Cuối tháng (`SYS` auto chốt + `ADM` ra quyết định):**
    - `ADM` mở bảng Payroll $\rightarrow$ Xem `TUT_A` có 10 buổi thành công x 200k = 2 triệu. Bị phạt 1 buổi nghỉ ốm sát giờ: -100k. Tổng nhận: 1tr9. 
    - `ADM` bấm duyệt bảng lương $\rightarrow$ Tiền cộng vào ví `TUT_A`.

---

### Lời nhắn gửi System Architect ⚠️
Luồng trên cho thấy sự tách biệt rõ ràng:
- **Tutor / Parent:** Chủ yếu là CRUD dữ liệu của chính họ (Self-service).
- **Admin:** Là `Orchestrator` và `Validator`. Admin là nút thắt cổ chai bắt buộc cho những luồng thay đổi trạng thái quan trọng (Duyệt hồ sơ, Duyệt nghỉ phép, Chốt lương). 
- Module nên được tách thành: `Admin-Web` (Chỉ dành cho Admin, view cục diện toàn bộ data) và `Client-Web/Mobile` (Cho Tutor, Parent, Student, Data chỉ giới hạn trong phạm vi Class mà họ tham gia).
