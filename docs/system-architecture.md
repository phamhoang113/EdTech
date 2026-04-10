# Gia Sư Tinh Hoa — Tài liệu Kiến trúc Hệ thống

> Phiên bản: 1.0 · Cập nhật: 2026-04-09

---

## 1. Tổng quan

**Gia Sư Tinh Hoa** là nền tảng kết nối gia sư — phụ huynh — học sinh tại Việt Nam.
Phụ huynh/học sinh tìm gia sư, đặt lịch, quản lý lớp học, thanh toán và chat trực tiếp.

---

## 2. Tech Stack

| Layer | Công nghệ | Ghi chú |
|-------|-----------|---------|
| **Backend** | Spring Boot 3.5.11 · Java 21 · Gradle | REST API + WebSocket |
| **Frontend Web** | React 19 · TypeScript 5.9 · Vite 8 | SPA, responsive |
| **Mobile** | Flutter 3 · Dart · BLoC · GoRouter | Android + iOS |
| **Database** | PostgreSQL 16 · Flyway | 12 migrations (V1..V12) |
| **ORM** | Spring Data JPA · Hibernate 6 | Named Enum support |
| **Real-time** | WebSocket STOMP · SockJS · @stomp/stompjs | Chat, notifications |
| **Push Notification** | Firebase Admin SDK 9.2 · FCM | Mobile + Web push |
| **Auth & Security** | Spring Security · JWT (jjwt 0.12) | Access + Refresh Token |
| **Google API** | Google Calendar API | Tạo Google Meet link |
| **API Docs** | SpringDoc OpenAPI (Swagger UI) | `/swagger-ui.html` |
| **State (FE)** | Zustand 5 · React Query 5 | Global state + data fetching |
| **UI (FE)** | Lucide React · Leaflet · QRCode.react | Icons, map, QR |
| **Testing** | JUnit 5 · JaCoCo (≥75% coverage) | Backend test |
| **SEO** | react-helmet-async · Puppeteer prerender | SSR-like cho blog |
| **File Storage** | Base64 trong PostgreSQL | Avatar, chứng chỉ gia sư |

---

## 3. Kiến trúc tổng thể

```
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│  React Web   │     │ Flutter App  │     │   Admin Web  │
│  (Vite:5173) │     │  (Android)   │     │  (React SPA) │
└──────┬───────┘     └──────┬───────┘     └──────┬───────┘
       │ HTTPS              │ HTTPS              │ HTTPS
       └────────────┬───────┴────────────────────┘
                    ▼
           ┌────────────────┐
           │   Nginx / LB   │  (GCP VM / Reverse Proxy)
           └────────┬───────┘
                    ▼
       ┌────────────────────────┐
       │   Spring Boot :8080    │
       │  ┌──────────────────┐  │
       │  │  REST Controllers │  │
       │  │  WebSocket STOMP  │  │
       │  │  Scheduler Jobs   │  │
       │  │  FCM Push Service │  │
       │  └──────────────────┘  │
       └──────────┬─────────────┘
                  │
          ┌───────▼──────┐
          │  PostgreSQL   │
          │    :5432      │
          └──────────────┘
```

---

## 4. Cấu trúc Package Backend

```
com.edtech.backend
├── core/                    # Shared: BaseEntity, ApiResponse, Exception handlers
├── auth/                    # Đăng ký, đăng nhập, JWT, OTP, brute-force lock
├── security/                # SecurityConfig, JwtService, JwtAuthFilter
├── admin/                   # Dashboard, thống kê, cài đặt hệ thống
├── tutor/                   # Hồ sơ gia sư, xác minh, tìm kiếm
├── student/                 # Hồ sơ học sinh, liên kết phụ huynh
├── cls/                     # Lớp học, buổi học (sessions), lịch dạy, đơn xin nghỉ
├── billing/                 # Hóa đơn, thanh toán, chi trả gia sư
├── messaging/               # Chat (conversations, messages), WebSocket
├── notification/            # Thông báo in-app, FCM push
├── lead/                    # Khách tiềm năng (leads), tin nhắn liên hệ (contact)
└── location/                # Tỉnh/thành, phường/xã
```

### Quy tắc mỗi module:
```
module/
├── controller/     # REST endpoints
├── dto/            # Request, Response, Payload DTOs
├── entity/         # JPA Entities (hậu tố Entity)
├── enums/          # Enums (nếu có)
├── repository/     # Spring Data JPA Repositories
└── service/        # Business logic
```

---

## 5. Hệ thống User & Roles

| Role | Mô tả |
|------|-------|
| **ADMIN** | Quản trị toàn bộ platform: duyệt gia sư, mở lớp, quản lý thanh toán |
| **TUTOR** | Gia sư: nhận lớp, dạy, quản lý lịch, theo dõi doanh thu |
| **PARENT** | Phụ huynh: tìm gia sư cho con, đặt lớp, thanh toán, theo dõi tiến độ |
| **STUDENT** | Học sinh (cấp 3/sinh viên): tự đăng ký, tự thanh toán, học 1:1 |

---

## 6. Authentication & Security

### Auth Flow (OTP-based)

```
Đăng ký:  POST /auth/register → tạo user (inactive) → sinh OTP
          POST /auth/verify-otp → kích hoạt user → trả JWT tokens

Đăng nhập: POST /auth/login → check lock → authenticate → trả JWT tokens

Refresh:   POST /auth/refresh → rotate tokens
```

### Bảo mật
- **JWT Access Token**: 1 giờ TTL
- **JWT Refresh Token**: 7 ngày TTL, lưu DB, rotate mỗi lần refresh
- **Brute-force**: Lock 15 phút sau 5 lần đăng nhập sai
- **CORS**: Whitelist origins qua `app.cors.allowed-origins`
- **PostgreSQL Named Enum**: Bắt buộc `@JdbcTypeCode(SqlTypes.NAMED_ENUM)`

---

## 7. Real-time Communication

### WebSocket (STOMP)
- Endpoint: `/ws` (SockJS fallback)
- Channels:
  - `/user/{phone}/queue/notifications` — Thông báo real-time
  - `/user/{phone}/queue/notifications/unread` — Đếm chưa đọc
  - `/user/{phone}/queue/messages` — Chat messages

### Push Notification (FCM)
- Token lưu trong `user_push_tokens`
- Gửi qua `FcmPushService` (async, không block)

---

## 8. Scheduled Jobs (Cron)

| Job | Lịch | Chức năng |
|-----|------|-----------|
| **BillingScheduler** | Đầu tháng | Tạo hóa đơn tự động cho tất cả lớp ACTIVE |
| **SessionAutoComplete** | Hàng ngày | Tự chuyển buổi học quá hạn → COMPLETED |
| **DraftAutoConfirm** | Hàng ngày | Tự xác nhận DRAFT sessions sắp tới |
| **WeeklySessionGenerator** | Cuối tuần | Tạo draft buổi học cho tuần tiếp theo |

---

## 9. Deployment

### Hiện tại: GCP VM (e2-medium)
- Backend: `java -jar backend.jar` (port 8080)
- Frontend: Vite build → static files served by Nginx
- PostgreSQL: Cloud SQL hoặc local trên VM
- Reverse Proxy: Nginx

### Kế hoạch:
- Chuyển sang VPS (Contabo) khi hết GCP credits
- SSL: Let's Encrypt auto-renew
- Domain: `giasutinhhoa.com`

---

## 10. Monitoring & Health

- Health check: `GET /api/health`
- Actuator: `/actuator/**` (metrics, info)
- Logging: SLF4J + Logback
