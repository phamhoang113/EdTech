# Mobile Wireframe: Home Screen (Public)

## Context
App layout is optimized for thumb reach, utilizing a sticky Bottom Navigation Bar and horizontal scroll areas. The default theme is **Light Mode** (white/soft gray backgrounds) with Indigo accents.

## 1. App Bar (Top)
- **Left:** `[Logo: EdTech]`
- **Right:** `[Toggle: ☀️/🌙 (Theme)]`, `[Icon: Notification Bell]`

## 2. Search Section (Sticky underneath App Bar)
- `[Search Bar: "Tìm gia sư, môn học..."]` with `[Icon: Filter]`
- *Hint: Tapping search transitions to the Search Screen with keyboard open.*

## 3. Hero Banner (Horizontal Swipeable)
*A CarouselSlider taking 25% of the screen height.*
- **Slide 1:** "Học giỏi không khó - Có gia sư lo!" `[Button: Tìm hiểu thêm]`
- **Slide 2:** "Tuyển gấp gia sư Toán cấp 3" `[Button: Đăng ký ngay] -> [AuthGuard]`

## 4. Categories (Horizontal Scroll)
*Quick filters by subject category.*
`[Toán]` `[Lý]` `[Hóa]` `[Anh Văn]` `[Lập trình]` `[Năng khiếu]`

## 5. Top Rated Tutors (Horizontal Scroll)
*Header: "Gia sư tiêu biểu" | "Xem tất cả >"*
- **Card 1 (Width: 70% of screen):**
  - Avatar [Image], Name, Rating 5.0 ⭐
  - Subject tags
  - `[Button: Đặt lịch] (Indigo gradient)` -> `[AuthGuard: Intercept]`
- **Card 2:** ...

## 6. How it Works (Vertical List)
*Header: "3 bước đơn giản"*
1. `[Icon: Search]` Tìm kiếm gia sư phù hợp
2. `[Icon: Calendar]` Đặt lịch hẹn học **[AuthGuard]**
3. `[Icon: Video]` Học qua Google Meet

## 7. Bottom Navigation Bar (Fixed)
*A standard 4-tab Material 3 NavigationBar.*
1. **[Home]** (Active - Indigo)
2. **[Bookings / Classes]** -> `[AuthGuard]` if not logged in
3. **[Chat]** -> `[AuthGuard]`
4. **[Profile]** (Always accessible. If not logged in, shows "Guest" profile with "Log in" button).
