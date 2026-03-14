# Mobile Wireframe: Đăng ký - Chọn vai trò

## Flow Context
Màn hình xuất hiện sau khi người dùng chọn "Đăng ký tài khoản mới" từ màn hình Đăng nhập hoặc Bottom Sheet ở trang chủ. Đây là một `Screen` riêng biệt (Full screen), không phải modal.

## UI Layout (Light Theme - Mobile View)

**Tương tác vuốt (Safe Area Top):**
- `[Nút Back (<)]` góc trái trên.

**Tiêu đề:**
- Heading lớn: `Bạn là ai?`
- Phụ đề: `Chọn một vai trò để trải nghiệm tốt nhất.`

**Content Body (2 Cards Xếp Dọc để dễ bấm):**

### Card 1 (Trên): Phụ Huynh / Học Sinh
*Card rộng full chiều ngang màn hình (padding 16px hai bên), thiết kế nổi (elevation).*
- **Bố cục ngang trong Card:**
  - Trái: Icon Phụ huynh/Học sinh to rõ, nền màu Violet nhạt.
  - Phải: Tiêu đề `Tìm Gia Sư` (Đậm) + Dòng chú thích nhỏ `Học tập hiệu quả hơn.`
- **Trạng thái chọn:** Radio button ở góc hoặc viền Primary bao quanh.

### Card 2 (Dưới): Gia Sư
*Card rộng full chiều ngang màn hình.*
- **Bố cục ngang trong Card:**
  - Trái: Icon Giáo viên, nền màu Indigo nhạt.
  - Phải: Tiêu đề `Làm Gia Sư` (Đậm) + Dòng chú thích nhỏ `Kiếm thu nhập từ việc dạy.`
- **Trạng thái chọn:** Radio button ở góc hoặc viền Primary bao quanh.

**Footer Actions (Ghim dưới đáy - Safe Area Bottom):**
- `[Button (Full Width): Tiếp Tục]` -> (Màu Indigo Gradient - Bị vô hiệu hoá (Disable) xám nếu chưa chọn card nào).
- `[TextLink đoạn giữa]: Đã có tài khoản? [Đăng nhập]` đoạn chữ có màu nổi bật.
