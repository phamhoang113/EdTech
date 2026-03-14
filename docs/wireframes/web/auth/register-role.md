# Web Wireframe: Đăng ký - Chọn vai trò

## Flow Context
Xuất hiện sau khi người dùng bấm "Đăng ký tài khoản" từ Landing Page hoặc từ Login Modal. Độc lập với luồng Auth Guard để không làm gián đoạn việc xem thông tin.

## UI Layout Dạng Modal Hoặc Page Độc Lập (Light Theme)

**Header:**
- Tiêu đề trung tâm: `Tham gia cùng chúng tôi`
- Phụ đề: `Bạn muốn tạo tài khoản với vai trò nào?`

**Content Body (2 Cards Lớn Đặt Song Song):**

### Card 1: Phụ Huynh / Học Sinh
*Kích thước lớn, viền màu xám nhạt (khi hover viền nháy màu Tím Violet, có drop shadow nổi bật)*
- **Icon / Minh họa:** Hình ảnh đồ hoạ biểu tượng Phụ huynh và học sinh.
- **Tiêu đề:** `Tìm Gia Sư`
- **Mô tả:** Tôi muốn tìm gia sư chất lượng cho con tôi hoặc cho bản thân. Tôi muốn đăng ký học.
- **Hành động ẩn (khi chọn):** Border chuyển màu Primary, hiển thị chấu tích v (Checked).

### Card 2: Gia Sư
*Kích thước lớn, viền màu xám nhạt (khi hover viền nháy màu Xanh Indigo, có drop shadow nổi bật)*
- **Icon / Minh họa:** Hình ảnh đồ hoạ biểu tượng Giáo viên / Người hướng dẫn.
- **Tiêu đề:** `Trở Thành Gia Sư`
- **Mô tả:** Tôi muốn áp dụng chuyên môn để kiếm thêm thu nhập bằng cách dạy kèm.
- **Hành động ẩn (khi chọn):** Border chuyển màu Primary, hiển thị chấu tích v (Checked).

**Footer Actions:**
- `[Button: Tiếp tục] (Primary Gradient)` -> Button chỉ Enable (sáng lên) khi người dùng đã tick chọn 1 trong 2 card.
- `[LinkText: Đã có tài khoản? Đăng nhập]` -> Trở về Form Đăng nhập.

---
**Behavior Rule:**
Nhấn "Tiếp tục" sẽ dẫn người dùng sang form nhập số điện thoại và OTP tương ứng với vai trò đã chọn (Gia sư sẽ có thêm bước nhập môn dự kiến dạy, trong khi Phụ huynh chỉ cần Pass).
