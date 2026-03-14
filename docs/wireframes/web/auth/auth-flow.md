# Web Wireframe: Auth Guard Flow

## Flow Description
This flow demonstrates what happens when an unauthenticated user attempts an action that requires an account on a public page.

---

### Step 1: User Action on Public Page
- **Scenario:** User is on the `Tutor Search` or `Landing Page`.
- **Action:** User clicks `[Button: Đặt Lịch Học]` on Tutor Nguyễn Văn A.

### Step 2: Interception (Auth Guard)
- The system checks Redux/Zustand state: `isAuthenticated = false`.
- The system prevents navigation to the booking page.
- The system saves the target action/URL: `redirectUrl = '/booking/tutor-id-123'`.
- The system opens the **Login Modal** (or redirects to `/login`).

---

### Step 3: Login Modal UI (Glassmorphism Modal)

**[X] Close Button (Top right)**

**Header:**
`Xin chào! Vui lòng đăng nhập để tiếp tục.`

**Body:**
- `[Input: Số điện thoại (Phone)]`
- `[Input: Mật khẩu (Password) (👁️ Toggle visibility)]`
- `[Link: Quên mật khẩu?]`

**Actions:**
- `[Button: Đăng Nhập] (Primary Gradient)` -> *loading state (Spinner)*
- `[Divider: --- Hoặc ---]`
- `[Button: Chưa có tài khoản? Đăng ký ngay]` -> *Switches to Register Modal*

---

### Step 4: Post-Login Resolution
- **Success:** User successfully logs in.
- Modal closes.
- System checks `redirectUrl`:
    - If `redirectUrl` exists, router pushes to `/booking/tutor-id-123`.
    - If no `redirectUrl` exists (standard login), user is routed to their respective dashboard (`/parent`, `/tutor`, etc. based on Role).

---

### Alternate Scenario: Registration from Auth Guard
If the user clicks "Đăng ký ngay", they see the Role Selection:

**Header:** `Chọn vai trò của bạn`
- `[Card: Khách hàng / Phụ huynh] (Violet Accent)`
- `[Card: Gia sư] (Indigo Accent)`
*(After selecting, proceeds to standard OTP/Registration form).*
