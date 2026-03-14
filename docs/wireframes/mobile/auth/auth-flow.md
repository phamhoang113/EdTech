# Mobile Wireframe: Auth Guard Flow (Bottom Sheet)

## Context
Unlike the web version which uses a centered modal, the Mobile App uses a `ModalBottomSheet` for authentication. This is crucial for mobile UX so the user doesn't lose context of the screen they were on.

---

### Step 1: User Action on Public Screen
- **Scenario:** User is on the Home Screen exploring Tutors.
- **Action:** User taps the **[Đặt lịch]** button on a Tutor Card.

### Step 2: Interception (Auth Guard)
- The BLoC reads `AuthState` -> `Unauthenticated`.
- The system intercepts the tap. The original action `() => context.push('/booking/tutor_123')` is saved.
- The app triggers `showModalBottomSheet(context: context, builder: (_) => const LoginSheet())`.

---

### Step 3: Login Bottom Sheet UI

*The sheet slides up from the bottom, covering ~60% of the screen. The background behind it is darkened with a semi-transparent overlay.*

**(Top Indicator)** A small horizontal handle indicating it can be dragged down.

**Header Area:**
- **Title:** `Đăng nhập để tiếp tục`
- **Subtitle:** `Hãy ứng dụng tìm gia sư phù hợp nhất cho bạn.`

**Form Body:**
- `[TextField: Số điện thoại]` (Floating label, clear icon)
- `[TextField: Mật khẩu]` (Floating label, eye icon to toggle visibility)
- `[Link (Right aligned): Quên mật khẩu?]`

**Actions Area:**
- `[Button (Full width): Đăng Nhập] (Indigo Gradient)`
- `-- Hoặc -- (Divider)`
- `[Button (Full width, Outlined): Đăng ký tài khoản mới]` -> *Tapping this dismisses the sheet and routes to the full Screen `RegisterRoleSelection`.*

*(Safe Area bottom padding applied to avoid Home Indicator overlap).*

---

### Step 4: Post-Login Resolution
- **Success:** BLoC emits `AuthSuccess`.
- The Bottom Sheet listens to this state: `Navigator.pop(context)`.
- The saved action is executed: `context.push('/booking/tutor_123')`.
- User seamlessly continues their booking flow.
