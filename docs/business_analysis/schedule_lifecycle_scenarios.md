# 🔄 Vòng đời & Bản đồ Kịch bản Lịch dạy (Schedule Lifecycle Scenarios)

**Người viết:** BA (Antigravity)
**Mục tiêu:** Mô tả **chuẩn xác và bao quát toàn bộ** các tình huống (scenarios) có thể xảy ra với một Buổi học (Session) từ lúc thai nghén đến lúc thanh toán xong tiền. 

Tài liệu này là bộ xương sống để Backend State Machine và Frontend UX không bỏ sót edge-cases.

---

## 1. Vòng đời chuẩn của một Session (The State Machine)

Mọi Session trên hệ thống sẽ trải qua các trạng thái (Status) sau:

1. `DRAFT`: Bản nháp. (Có thể xoá/sửa giờ thoải mái bởi Gia sư).
2. `SCHEDULED`: Đã chốt lịch. (Gắn chặt với thời gian thực tế, muốn đổi phải nộp Đơn xin nghỉ).
3. `LIVE`: Đang diễn ra. (Đến giờ học).
4. `COMPLETED_PENDING`: Chờ khiếu nại. (Gia sư báo "Đã dạy xong", chờ KH đánh giá trong vòng 24h).
5. `COMPLETED_FINAL`: Hoàn thành chốt. (Sẵn sàng tính lương).
6. `DISPUTED`: Tranh chấp. (Phụ huynh khiếu nại, chờ Admin phân xử).
7. `CANCELLED`: Đã huỷ (Gồm các loại: `CANCEL_BY_TUTOR`, `CANCEL_BY_STUDENT`, `CANCEL_BY_ADMIN`).

---

## 2. Toàn cảnh các Kịch bản (Scenarios)

### 🟢 Kịch bản 1: The Happy Path (Suôn sẻ từ A-Z)

Đây là luồng chuẩn mà 90% số buổi học sẽ trải qua.

1. **Khởi tạo:** Thứ 2 hàng tuần, Hệ thống tự động sinh ra danh sách buổi dạy nháp (`DRAFT`) cho **tuần tiếp theo** dựa trên Lịch mẫu của lớp.
2. **Xác nhận:** Gia sư có thể tự vào kiểm tra và bấm "Xác nhận tất cả" **trước 18:00 Chủ Nhật** của tuần hiện tại. 
    - Nếu Gia sư bấm xác nhận: Session chuyển sang `SCHEDULED`.
    - Nếu qua 18:00 Chủ Nhật mà Gia sư chưa chốt: Hệ thống sẽ **tự động chốt (Auto-confirm)** toàn bộ `DRAFT` sang `SCHEDULED`. Máy đẩy Noti cho Phụ huynh & Học sinh.
3. **Học bài:** Đến đúng giờ, biểu tượng "Vào lớp" sáng lên (trạng thái `LIVE`). Tutor và Student click vào Google Meet.
4. **Báo cáo:** Hết giờ, Gia sư bấm nút "Kết thúc buổi học". Session chuyển sang `COMPLETED_PENDING`. Noti đẩy về cho Phụ huynh: *"Con bạn vừa học xong, bạn có hài lòng không?"*.
5. **Chốt lương:** Trôi qua 24h, Phụ huynh rate 5 sao hoặc im lặng (không ấn gì) $\rightarrow$ Hệ thống auto chuyển sang `COMPLETED_FINAL`. Cuối tháng, hệ thống đếm số buổi này để trả tiền cho Gia sư.

---

### 🟠 Kịch bản 2: Gia sư xin nghỉ (Tutor Absence)

Khi Session đã lên `SCHEDULED`, Gia sư không thể tự ấn "Xoá".

1. **Gửi Đơn:** Gia sư vào mục "Xin vắng mặt", chọn Session, chọn Lý do (Ốm, Bận đột xuất), upload Ảnh, và chọn Option "Đề xuất học bù vào Thứ 6".
2. **Admin nhận Noti:** Admin kiểm tra thời gian gửi đơn so với giờ học.
    - **Nhánh 2A (Nghỉ hợp lệ - báo trước > 24h):** Admin ấn `Approve` $\rightarrow$ Session chuyển thành `CANCEL_BY_TUTOR`. Tạo thêm 1 Session `DRAFT` vào Thứ 6 như đề xuất học bù. Không bị report vi phạm.
    - **Nhánh 2B (Nghỉ sát giờ - báo trước < 24h):** Admin ấn `Approve`, hệ thống sẽ **Record 1 lỗi Vi Phạm (Penalty)** cho Gia sư (Cuối tháng trừ lương). Session chuyển thành `CANCEL_BY_TUTOR`.
3. **Báo cáo Phụ huynh & Học sinh:** **BẤT CỨ LÚC NÀO lịch học bị thay đổi giờ, xếp bù, hoặc bị huỷ bởi Gia sư hay Admin, hệ thống BẮT BUỘC phải phát thông báo (SMS/App Noti) ngay lập tức cho Phụ huynh và Học sinh** để phía gia đạo nắm thông tin. Ví dụ: *"Gia sư xin nghỉ vì ốm đau, buổi học được bù vào..."*.

---

### 🟡 Kịch bản 3: Học sinh xin nghỉ (Student Absence)

Phụ huynh/Học sinh có việc bận đột xuất.

1. **Gửi Đơn:** Phụ huynh gửi thông tin xin vắng mặt lên Trung tâm (Admin). 
    *Lưu ý UI cho FE:* Trên màn hình xin nghỉ, phải có một câu **Cảnh báo (Warning)** để Phụ huynh nắm thông tin trước khi gửi đơn: *"Lưu ý: Việc báo vắng sát giờ học có thể không được hoàn lại học phí theo quy định của Trung tâm. Thông tin của bạn sẽ được xử lý linh hoạt dựa trên tình hình thực tế."*
2. **Phân xử của Admin (Khách hàng là trung tâm):** Admin nhận thông tin, xem xét tình huống thực tế của Phụ huynh (Ốm năng, hiếu hỉ...) và đưa ra quyết định dựa trên quyền hạn của Trung tâm:
    - **Nhánh 3A (Miễn trừ học phí):** Khách báo hợp lý / Trung tâm linh động hỗ trợ $\rightarrow$ Admin ấn `Approve & Refund`. Session $\rightarrow$ `CANCEL_BY_STUDENT`. Phụ huynh **không rớt ví**. Gia sư nghỉ buổi đó **không tính lương**.
    - **Nhánh 3B (Tính học phí):** Phụ huynh lạm dụng nghỉ nhiều lần, nghỉ sát giờ không hợp lý $\rightarrow$ Admin ấn `Approve & Charge` $\rightarrow$ Session $\rightarrow$ `CANCEL_BY_STUDENT_CHARGED`. Buổi học này Phụ huynh vẫn bị trừ học phí, và **Gia sư vẫn được trả lương 100% thời lượng** (Gia sư làm đúng bổn phận).

---

### 🔴 Kịch bản 4: No Show (Bỏ lớp không phép)

Sự cố vận hành nặng nhất.

**Trường hợp 4A: Gia sư bỏ lớp (Tutor No-Show)**
1. **Phát sinh:** Đến giờ học (`LIVE`), học sinh ngoan ngoãn vào Meet chờ 15 phút không thấy Gia sư. Học sinh ấn nút **"Gia sư không có mặt"** (Nút này xuất hiện sau 10p).
2. **Can thiệp:** Màn hình Admin réo còi cảnh báo. Admin bốc máy gọi Gia sư không được.
3. **Huỷ lệnh:** Admin ấn nút `Force Cancel` với lý do `TUTOR_NO_SHOW`. 
4. **Hậu quả:** Session chết. Phụ huynh được thối tiền lại. Gia sư dính **Heavy Penalty** (Vi phạm cực nặng, trừ 3-5 buổi lương).

**Trường hợp 4B: Học sinh bỏ lớp (Student No-Show)**
1. **Phát sinh:** Gia sư vào Meet chờ 15p không thấy Học sinh. Gia sư ấn nút **"Học sinh không có mặt"**.
2. **Can thiệp:** Admin bốc máy gọi Phụ huynh. Khách bảo quên báo nghỉ.
3. **Phán xử:** Theo chính sách, lỗi do phụ huynh. Buổi học vẫn được coi như diễn ra. Gia sư ấn "Kết thúc buổi học". Session về `COMPLETED_FINAL`, Gia sư vẫn nhận nửa/hoặc full lương buổi đó.

---

### 🟣 Kịch bản 5: Bất đồng / Tranh chấp (Data Dispute)

Xảy ra ở giai đoạn sau buổi học (`COMPLETED_PENDING`).

1. **Khởi nguồn:** Gia sư báo "Đã dạy xong" 2 tiếng. Tuy nhiên Phụ huynh phản hồi: *"Hôm nay gia sư vào dạy muộn 40 phút mà vẫn về đúng giờ, chỉ dạy có nửa tiếng!"*.
2. **Chuyển state:** Phụ huynh ấn nút khiếu nại kèm Rate 1 Sao $\rightarrow$ Session ngay lập tức đổi màu sang `DISPUTED` (Cảnh báo cam chớp nháy ở màn hình Admin).
3. **Phân xử:**
    - Admin liên lạc 2 bên thu thập Data (Xem lại record Google Meet, log của platform).
    - **Kết luận do Gia sư:** Admin sửa trạng thái Session thành `CANCELLED_BY_TUTOR_VIOLATION` (thối lại tiền Phụ huynh, phạt Gia sư).
    - **Kết luận do Phụ huynh phàn nàn vô lý:** Admin bảo vệ Gia sư, Force update Session thành `COMPLETED_FINAL` -> Gia sư vẫn nhận lương.

---

### 🌐 Kịch bản 6: Luồng chuyên biệt cho Lớp Học Trực Tuyến (Online Classes)

Đối với các lớp gắn cờ `isOnline = true` (hoặc tuỳ chọn Online), hệ thống ràng buộc luồng nghiệp vụ khắt khe hơn để tự động hoá việc đánh điểm danh thay vì chỉ chờ Gia sư bấm nút.

1. **Khởi tạo Link học (Meet Link Generation):** 
    - Khi Session chuyển từ `DRAFT` $\rightarrow$ `SCHEDULED`, Hệ thống (hoặc tài khoản Google Workspace của Trung tâm) có thể tự động sinh link Google Meet và gắn vào trường `meet_link` của Session, kèm timestamp `meet_link_set_at`.
    - Hoặc Gia sư chủ động dán link Meet của cá nhân vào chi tiết buổi học. Bắt buộc phải có Link trước h học **30 phút**.
2. **Cổng vào lớp (Entry Gateway):**
    - Học sinh và Gia sư bắt buộc phải đăng nhập vào hệ thống EdTech, vào Dashboard $\rightarrow$ Lịch học $\rightarrow$ bấm nút **"Vào lớp" (Join Class)**.
    - Việc bấm nút này giúp hệ thống (BE) ghi nhận Audit Log `attended_at` để chốt là Gia sư đã có mặt đúng giờ, tự động đổi Session thành state `LIVE`.
3. **Phát hiện Bỏ lớp tự động (Auto No-Show Detection):**
    - Nếu quá giờ học 15 phút (vd: 19:15 cho ca 19:00) mà hệ thống không ghi nhận Gia sư bấm nút "Vào lớp", hệ thống sẽ **bắn cảnh báo đỏ (Red Alert)** lên màn hình của Admin: *"Phát hiện gia sư A chưa vào lớp Toán 9"*.
    - Admin bốc máy gọi ngay cho Gia sư để cứu net (giữ chân khách hàng). Nếu gọi không được $\rightarrow$ Force Cancel chuyển sang Kịch bản 4A.
4. **Kết thúc buổi Onine:** Gia sư bấm kết thúc hoặc hệ thống check thời lượng vượt quá khung giờ quy định để tự chuyển `COMPLETED_PENDING`.

---

## 3. Tổng kết yêu cầu State Machine cho Dev
Với toàn bộ các map kịch bản trên, BE Developer và Architect PHẢI có 1 bảng `SessionLogs` lưu vết (Audit Trail) để trả lời câu hỏi: *Ai/Hệ thống đã đổi trạng thái của buổi học này từ XX sang YY lúc mấy giờ, lý do là gì?* Mọi hành động click link, ấn nút bắt đầu đều phải được lưu trữ để giải quyết tranh chấp.
