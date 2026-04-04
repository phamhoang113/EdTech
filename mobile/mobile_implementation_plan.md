# Kế hoạch Phát triển Mobile App (EdTech Flutter)

Dựa trên cấu trúc và tính năng của hệ thống Web (React/Vite + Spring Boot Backend) và kết quả phân tích cấu trúc folder `mobile/` hiện tại (đã khởi tạo sẵn Flutter với BLoC, Dio, GoRouter, GetIt...), đây là kế hoạch phát triển ứng dụng di động chi tiết hướng tới đối tượng người dùng cuối (Parents, Students, Tutors).

> [!NOTE]
> Ứng dụng Mobile sẽ được định hướng ĐỘC QUYỀN dành cho 3 đối tượng người dùng: **Gia sư (Tutor)**, **Phụ huynh (Parent)**, và **Học sinh (Student)**. Chức năng Admin sẽ không tồn tại trên Mobile App.

## Đánh giá Kỹ thuật (Tech Stack App)
- **Framework:** Flutter 3.x
- **State Management:** `flutter_bloc`
- **Dependency Injection:** `get_it` & `injectable`
- **Network / API:** `dio` & `json_annotation`
- **Routing:** `go_router`
- **Local Storage:** `flutter_secure_storage`
- **Realtime:** `stomp_dart_client` (Dùng cho websocket chat/notification)

---

## Kiến trúc Flutter (Feature-First) đề xuất

```text
lib/
├── app/                  # GoRouter config, Theme (Light/Dark), Navigation Layouts
├── core/
│   ├── network/          # Dio config, Token Interceptors, API Client
│   ├── utils/            # Validators, Formatters, Constants
│   └── widgets/          # Shared UI Components (CustomTextField, PrimaryButton, Modals)
└── features/
    ├── auth/             # Login, Register, Forgot/Change Password, OTP
    ├── tutor_profile/    # Manage tutor info, CV upload, Verification
    ├── search/           # Parent/Student: Search & Filter Tutors
    ├── classes/          # My Classes, Class Board, Send/Approve Applications
    ├── messages/         # Chat UI, Websocket Stomp client
    └── billing/          # Payment history, Tuition fee
```

## Lộ trình Triển khai Toàn diện V1 (Theo đúng Tài liệu Hệ thống)

Căn cứ vào `project_overview.md`, mô hình ứng dụng là **Tutor Booking Model** (Giống Uber/Grab cho gia sư, học viên tự chủ động tìm kiếm và book Gia sư). Do đó, lộ trình 4 Phase sẽ được xây dựng chính xác sát với kiến trúc:

### Phase 1: Authentication & Onboarding (ĐÃ HOÀN THÀNH)
Mục tiêu: Đưa người dùng vào App an toàn, phân loại 3 Role chuẩn (TUTOR, PARENT, STUDENT).
- **Step 1:** Setup cấu trúc `lib/features`, Material 3 Theme và GoRouter. Config `flutter_bloc`.
- **Step 2:** `Dio` Interceptors xử lý JWT Token.
- **Step 3:** UI Login & Register. Tích hợp gửi OTP xác thực sđt (như Web).
- **Step 4:** Logic Force Password Change & Forgot Password bằng OTP.
- **Step 5:** Splash và Base Navigation (Bottom Bar tuỳ biến theo Role).

### Phase 2: Hệ Sinh Thái Phụ Huynh / Học Sinh (Parent / Student App) (TIẾP THEO)
Mục tiêu: Cho phép Phụ huynh/Học sinh nộp Yêu cầu mở lớp, theo dõi tiến độ duyệt và quản lý lớp học.
- **Step 6:** **Tutor Feed (Trang chủ)**: Xem danh sách gia sư nổi bật. Xem chi tiết Profile gia sư (Chỉ hiển thị Bio, Rating, Môn học, Kinh nghiệm — **Không hiển thị giá $ và lịch rảnh**).
- **Step 7:** **Request Class Flow (Yêu cầu Mở lớp)**: Xây dựng Form "Yêu cầu mở lớp" (Nhập môn, mô tả, mức học phí có thể trả, khung giờ). Yêu cầu này sẽ được đẩy lên Admin Web để xét duyệt thành lớp OPEN.
  - *Lưu ý Scope*: 
    - **Parent**: Điền form cho con cái. Quản lý Request & Thanh toán toàn quyền. 
    - **Student (Độc lập/Tự trị)**: Học sinh không có tài khoản Parent liên kết. Toàn quyền y như Phụ Huynh.
    - **Student (Phụ thuộc)**: Có tài khoản Parent quản lý. Màn hình chỉ hiển thị Thời khóa biểu (Calendars/Schedules) cơ bản. Không được quyền tạo Request Class và Không xem/đóng thanh toán.
- **Step 8:** **My Request & Classes (Dashboard Học viên)**: Theo dõi trạng thái Yêu cầu (Đang chờ Admin duyệt, Đã duyệt, Đang chờ Gia sư...). Xem thông tin Lớp học (Classroom) khi đã được Admin ghép Gia sư thành công.
- **Step 9:** Review/Đánh giá hệ thống (Rating flow sau lớp) -> Nộp API feedback.

### Phase 3: Hệ Sinh Thái Gia Sư (Tutor App)
Mục tiêu: Cho phép Khách hàng Gia sư cập nhật hồ sơ, lên **Bảng Tin (Class Board)** tìm lớp phù hợp và **Apply (Đăng ký nhận lớp)**.
- **Step 10:** **Tutor Profile Update**: Màn quản lý thông tin tiểu sử, môn học, upload chứng chỉ để xác thực. (Không có lịch rảnh, giá tiền theo giờ).
- **Step 11:** **Class Board (Lớp học đang mở)**: Đồng bộ tính năng `ClassesPage`. Lướt xem danh sách các Lớp `OPEN` mà Phụ huynh yêu cầu đã được Admin duyệt. Tính năng Filter lớp.
- **Step 12:** **Class Application Flow (Đăng ký nhận lớp)**: Bấm xem chi tiết lớp OPEN $\rightarrow$ Nhấn "Đăng ký nhận lớp". Yêu cầu sẽ bay về Admin Web để Admin cân nhắc và xét duyệt ghép lớp.
- **Step 13:** **My Active Classes (Lớp đang dạy)**: Danh sách các classroom (gắn tutor + students) đã được Admin duyệt. Xem lịch dạy, timeline, số học viên.
- **Step 14:** **Doanh thu và Thanh toán**: Quản lý thu nhập từ các class.

### Phase 4: Quản lý Thanh toán & Tương tác Realtime (Chat & Push Alerts)
Mục tiêu: Chốt chặn giao dịch tài chính & nâng tầm trải nghiệm người dùng với tin nhắn nhanh.
- **Step 15:** Triển khai màn hình **Billings (Thu nhập & Học phí)**. Xem hoá đơn chờ thanh toán.
- **Step 16:** **Realtime Chat Platform**: Tích hợp `Stomp` client (`/ws` Backend). Dựng màn Danh sách Bạn chát (Conversation List) & Màn Hình Chat Inbox (Trong khuôn khổ Classroom).
- **Step 17:** Tích hợp Firebase Cloud Messaging (FCM) push notification lúc app chạy background (Có lớp OPEN mới, Yêu cầu được duyệt, Tin nhắn mới).
- **Step 18:** Testing E2E, rà soát ngoại lệ và Release V1 APK.
