# Backend Coding Standards — EdTech

> Tài liệu này là **quy ước bắt buộc** cho toàn bộ backend Spring Boot.  
> Mọi PR phải tuân thủ, reviewer sẽ reject nếu vi phạm.

---

## 1. Cấu trúc Package

```
com.edtech.backend
├── core/                      # Dùng chung (exception, dto base, filter, util)
│   ├── controller/
│   ├── dto/
│   ├── exception/
│   └── util/
└── {feature}/                 # auth, booking, classroom, chat, ...
    ├── controller/
    ├── dto/
    │   ├── request/           # *Request.java
    │   ├── response/          # *Response.java
    │   └── payload/           # Dữ liệu nội bộ / event payload
    ├── entity/                # *Entity.java
    ├── enums/                 # Enum constants
    ├── repository/
    └── service/
        └── impl/
```

---

## 2. Quy tắc Đặt Tên

### 2.1 Entity — bắt buộc hậu tố `Entity`

```java
// ✅ Đúng
public class UserEntity { }
public class OtpCodeEntity { }
public class BookingSessionEntity { }

// ❌ Sai
public class User { }
public class OtpCode { }
```

### 2.2 DTO — tách thành 3 loại

| Loại | Hậu tố | Mục đích |
|------|--------|---------|
| **Request** | `*Request` | Dữ liệu client gửi lên (API input) |
| **Response** | `*Response` | Dữ liệu server trả về (API output). Dùng `ApiResponse<T>` để wrap |
| **Payload** | `*Payload` | Dữ liệu nội bộ: event, message queue, scheduled job |

```java
// ✅ Request: client → server
public class LoginRequest { ... }
public class RegisterRequest { ... }

// ✅ Response: server → client  
public class TokenResponse { ... }
public class RegisterResponse { ... }

// ✅ Payload: nội bộ (event, queue, cache)
public class OtpSentPayload { ... }
public class NotificationPayload { ... }

// ❌ Không dùng DTO generic không rõ loại
public class AuthDto { ... }
public class UserData { ... }
```

### 2.3 Enum — dùng cho mọi giá trị cố định

```java
// ✅ Đúng — tất cả constant phải là enum
public enum UserRole { ADMIN, TUTOR, PARENT, STUDENT }
public enum OtpPurpose { REGISTER, RESET_PASSWORD, CHANGE_PHONE }
public enum BookingStatus { PENDING, CONFIRMED, CANCELLED, COMPLETED }
public enum ClassroomStatus { ACTIVE, INACTIVE, ARCHIVED }
public enum AppEnvironment { DEVELOPMENT, STAGING, PRODUCTION }

// ❌ Sai — không được dùng String raw
private String role;        // Thay bằng UserRole role
private String purpose;     // Thay bằng OtpPurpose purpose
private String status;      // Thay bằng BookingStatus status
```

---

## 3. Nghiêm cấm Hard-code String

Mọi giá trị String "magic" phải được khai báo thành hằng số hoặc enum.

```java
// ❌ Tuyệt đối cấm
otpCodeRepository.findBy...(phone, "REGISTER")
if (env.equals("production"))
log.info("Generated OTP {} for phone {}", code, phone)
user.setRole("TUTOR")

// ✅ Phải thay bằng
otpCodeRepository.findBy...(phone, OtpPurpose.REGISTER)
if (appEnvironment == AppEnvironment.PRODUCTION)
```

### 3.1 Khai báo Constants đúng cách

```java
// Trong class service/entity sử dụng nó:
private static final int MAX_FAILED_ATTEMPTS = 5;
private static final int OTP_EXPIRATION_MINUTES = 5;
private static final int LOCKOUT_MINUTES = 15;
private static final String DEV_OTP_CODE = "123456";

// Config key từ application.yml — KHÔNG hardcode
@Value("${app.environment}")
private AppEnvironment appEnvironment;

@Value("${app.otp.expiration-minutes:5}")
private int otpExpirationMinutes;
```

---

## 4. Quy tắc Entity

- Tên class = `{TênChứcNăng}Entity`, map tới bảng `{ten_chuc_nang}s` (snake_case, plural)
- Dùng `UUID` làm PK, generate bằng `@GeneratedValue(strategy = GenerationType.UUID)`
- Luôn có `createdAt` (dùng `@CreatedDate`)
- Dùng `@Builder` + `@NoArgsConstructor(access = PROTECTED)` để kiểm soát khởi tạo
- Enum field phải dùng `@Enumerated(EnumType.STRING)`

```java
// ✅ Ví dụ chuẩn
@Entity
@Table(name = "otp_codes")
@Getter @Setter @Builder
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
public class OtpCodeEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(nullable = false)
    @Enumerated(EnumType.STRING)
    private OtpPurpose purpose;   // ← Enum, không phải String
    
    @CreatedDate
    @Column(name = "created_at", updatable = false, nullable = false)
    private Instant createdAt;
}
```

---

## 5. API Response — luôn wrap bằng `ApiResponse<T>`

```java
// ✅ Luôn dùng generic wrapper
ApiResponse<RegisterResponse> register(...)
ApiResponse<TokenResponse> login(...)
ApiResponse<Void> logout(...)

// ❌ Không trả raw object
RegisterResponse register(...)    // Thiếu wrapper
```

---

## 6. Exception Handling

- Dùng custom exception, không throw `RuntimeException` trực tiếp
- `BusinessRuleException` → HTTP 400 (logic nghiệp vụ sai)
- `EntityNotFoundException` → HTTP 404
- `UnauthorizedException` → HTTP 401

```java
// ✅ Đúng
throw new BusinessRuleException("Phone number already exists.");
throw new EntityNotFoundException("User not found with id: " + id);

// ❌ Sai
throw new RuntimeException("Phone exists");
```

---

## 7. Service Layer

- Interface trong `service/`, Implementation trong `service/impl/`
- Không gọi Repository từ Controller
- `@Transactional(readOnly = true)` ở class level; override `@Transactional` ở method write

```java
@Service
@Transactional(readOnly = true)  // Default read-only
public class AuthServiceImpl implements AuthService {

    @Transactional  // Override cho write operation
    public RegisterResponse register(RegisterRequest request) { ... }
}
```

---

## 8. Checklist PR Review

- [ ] Entity có hậu tố `Entity`
- [ ] DTO tách đúng `Request` / `Response` / `Payload`
- [ ] Không có String magic — dùng `enum` hoặc `static final`
- [ ] Không `@Autowired` field injection — dùng `@RequiredArgsConstructor`
- [ ] API Response wrap bằng `ApiResponse<T>`
- [ ] Enum field trong Entity dùng `@Enumerated(EnumType.STRING)`
- [ ] Config value lấy từ `@Value`, không hardcode
