# Web Wireframe: Landing Page (Public)

## Target Audience
Principally Parents seeking tutors, Students looking for help, and Tutors wanting to join.

## 1. Header (Navigation)
`[Logo: EdTech]`  `[Home]` `[Find a Tutor]` `[About Us]`    `[Toggle: ☀️/🌙]`  `[Log In / Register]`
*Note: The header remains sticky.*

## 2. Hero Section
**Headline:** Tìm Gia Sư Giỏi - Nâng Tương Lai Sáng
**Sub-headline:** Kết nối với hàng ngàn gia sư chất lượng cao trải dài trên toàn quốc. Học trực tuyến hay tại nhà, tất cả đều trong tầm tay.
**Actions:**
- `[Button: Tìm Gia Sư Ngay] (Primary Gradient)` -> *Clicks to Tutor Search*
- `[Button: Trở Thành Gia Sư] (Secondary/Ghost)` -> *Clicks opens Role-Selection Register Modal*
**Visual:** Graphic showing a student and a tutor interacting happily (glassmorphism card overlays showing "100+ Subjects", "Verified Tutors").

## 3. Platform Stats
`[Icon: Users] 10,000+ Học sinh` | `[Icon: Tutors] 3,000+ Gia sư` | `[Icon: Star] 4.8/5 Đánh giá`

## 4. Featured Tutors (Carousel)
*A horizontal scrolling list of top-rated tutors.*

### Tutor Card 1
- **Avatar:** [Image] (Online badge: Green Dot)
- **Name:** Nguyễn Văn A
- **Subjects:** Toán, Lý (THPT)
- **Rating:** 5.0 ⭐ (120 reviews)
- **Hourly Rate:** 150,000 VND / h
- **Action:** `[Button: Đặt lịch học]` -> **[AUTH GUARD INTERCEPT]**

### Tutor Card 2
- **Avatar:** [Image] (Online badge: Gray Dot)
- **Name:** Trần Thị B
- **Subjects:** Tiếng Anh (IELTS)
- **Rating:** 4.9 ⭐ (85 reviews)
- **Hourly Rate:** 200,000 VND / h
- **Action:** `[Button: Đặt lịch học]` -> **[AUTH GUARD INTERCEPT]**

## 5. How It Works (3 Steps)
1. **Tìm kiếm:** Lọc gia sư theo môn học, khu vực, giá tiền.
2. **Kết nối:** Gửi yêu cầu học và trao đổi chi tiết. **[AUTH GUARD INTERCEPT]**
3. **Học tập:** Bắt đầu lớp học trực tuyến qua Google Meet hoặc offline.

## 6. Footer
- Links: Về chúng tôi, Liên hệ, Chính sách bảo mật, Điều khoản sử dụng.
- Social links.

---
**Behavior Rule:**
Any button that triggers a platform use case (e.g., `[Đặt lịch học]`, `[Nhắn tin]`, `[Tạo yêu cầu tìm gia sư]`) will check the global auth state. If not logged in, it triggers the Login Modal, saving the intended action to be executed post-login.
