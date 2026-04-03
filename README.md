<div align="center">
  <img src="./frontend/src/assets/logo.png" alt="Gia Sư Tinh Hoa Logo" width="120" />
  <h1>Gia Sư Tinh Hoa (EdTech Platform)</h1>
  <p><b>Nền tảng kết nối Giáo Dục thông minh: Gia Sư - Phụ Huynh - Học Sinh</b></p>
</div>

---

## 📖 Giới thiệu

**Gia Sư Tinh Hoa** là một nền tảng EdTech hiện đại nhằm kết nối những sinh viên xuất sắc, giáo viên chất lượng với Phụ huynh và Học sinh trên toàn quốc. Hệ thống nhằm mục đích phá vỡ rào cản địa lý và chi phí, mang đến trải nghiệm nâng tầm tri thức Việt Nam với lộ trình học tập được cá nhân hóa chặt chẽ.

Các tính năng cốt lõi theo vai trò:
- **Phụ huynh / Học sinh**: Tìm kiếm gia sư theo môn học, lên lịch (booking) lớp học, theo dõi học phí, quản lý lịch học và nhận báo cáo định kỳ.
- **Gia sư**: Tạo profile chuyên nghiệp, quản lý lịch dạy, theo dõi doanh thu (payout), điểm danh và trao đổi bài giảng với học sinh.
- **Quản trị viên (Admin)**: Duyệt profile gia sư, xét duyệt vắng mặt, quản lý hóa đơn (billing), kiểm soát hệ thống và phân phối doanh thu.

---

## 💻 Công nghệ & Kiến trúc (Tech Stack)

Dự án được xây dựng dựa trên nguyên tắc **Clean Architecture**, phân tách rõ ràng UI/UX và Logic, đồng thời đảm bảo tính mở rộng cao (High Scalability).

### 🖥️ Frontend (Web)
- **Framework**: React 19 (Vite) + TypeScript
- **State Management**: Zustand
- **Styling**: Vanilla CSS (CSS Modules) với Design System chuẩn (Primary: Indigo `#6366F1`, Secondary: Violet `#8B5CF6`, Light/Dark Mode)
- **Icons**: Lucide React
- **Performance**: Tuân thủ tiêu chuẩn tối ưu hóa Rendering và Bundle Size của Vercel Web Best Practices.

### ⚙️ Backend (API)
- **Framework**: Java 21 + Spring Boot 3.5
- **Build Tool**: Gradle
- **Database Mapping**: Hibernate / JPA
- **Bảo mật**: Spring Security, JWT (OTP Authentication với UUID token), CORS Config.
- **Kiến trúc**: RESTful API với chuẩn DTO tách biệt, Validation chặt chẽ, và định tuyến Log logic.

### 📱 Mobile (Tuỳ chọn)
- **Công nghệ**: Flutter 3 & Dart (Cross-platform cho iOS/Android)

### 🗄️ Infrastructure & Database
- **RDBMS**: PostgreSQL 15+ (Quản lý schema bằng Flyway)

---

## 🚀 Hướng dẫn Cài đặt & Khởi chạy

### 1. Yêu cầu hệ thống (Prerequisites)
- [Java 21 JDK](https://adoptium.net/) (Cài đặt và setup `JAVA_HOME`)
- [Node.js 20+](https://nodejs.org/) & `npm`
- Chạy các dịch vụ ngầm: PostgreSQL.

### 2. Cấu hình Môi trường
Tạo bản sao của file biến môi trường và điều chỉnh thông tin database, JWT Secret:
```bash
cp infrastructure/.env.example infrastructure/.env
```

### 3. Workflow Tự động nhanh (AI & Developer)
Dự án có sẵn các lệnh workflow tiện ích hỗ trợ trong quá trình phát triển (Khởi chạy qua terminal hoặc Agent prompt):
- `/start`: Khởi động nhanh Backend, Postgres và Frontend.
- `/stop`: Tắt tất cả các service đang chạy.
- `/restart_be`: Khởi động lại Spring Boot backend.
- `/run_fe`: Chạy Vite React Frontend.
- `/test`: Khởi chạy công cụ QA Automation cho từng role.

### 4. Khởi chạy thủ công (Manual)

**Khởi chạy Backend (Cổng `8080`):**
```powershell
cd backend
$env:JAVA_HOME = "C:\Program Files\Java\jdk-21"
.\gradlew.bat bootRun
```
*Ghi chú: Swagger UI API Docs sẽ có mặt tại `http://localhost:8080/swagger-ui.html`*

**Khởi chạy Frontend Web (Cổng `5173`):**
```powershell
cd frontend
npm install
npm run dev
```
*Truy cập ứng dụng tại `http://localhost:5173`*

**Khởi chạy Mobile App (Tuỳ chọn):**
```bash
cd mobile
flutter pub get
flutter run
```

---

## 📂 Cấu trúc Repository Chính

```text
├── backend/                # Spring Boot 3.5 API Server 
│   ├── src/main/java       # Source code Java (Controllers, Services, Repositories, Entities)
│   ├── src/main/resources  # Cấu hình application.yml, DB Migrations
│   └── build.gradle        # Gradle dependencies
├── frontend/               # React 19 Vite Web App
│   ├── src/components/     # UI Components dùng chung và theo phân quyền
│   ├── src/pages/          # React route pages (Home, Admin, Dashboard, Auth...)
│   ├── src/services/       # API Clients giao tiếp với Backend
│   └── src/store/          # Zustand State configuration
├── mobile/                 # Flutter Application
└── infrastructure/         # Docker-compose (nếu dùng) và ENV config files
```

---

## 📝 Tiêu chuẩn Lập trình (Coding Standards)

Dự án áp dụng bộ quy chuẩn vô cùng nghiêm ngặt (Clean Code):
1. **Naming Conventions**: `PascalCase` cho Classes; `camelCase` cho Functions/Variables; `UPPER_CASE` cho Constants.
2. **Nguyên tắc No-Hardcode**: Mọi giá trị phải được đưa vào biến môi trường hoặc Constant files.
3. **Mỗi hàm một chức năng (Single Responsibility)**: Tách biệt hoàn toàn phần UI Rendering và Logic Handle.
4. **Imports**: Không sử dụng `*` import, không FQN (Fully Qualified Name), phân tách nhóm third-party rõ ràng.
5. **No Barrel Imports**: Trên React, để tối ưu Bundle Vite, yêu cầu sử dụng Direct Import cho các Component nặng (vd: `lucide-react/dist/esm/icons/...`).

---
🌟 *Được phát triển với mục tiêu nâng tầm giáo dục, hỗ trợ học sinh chạm tới đỉnh cao tri thức.*
