package com.edtech.backend.student.service;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.edtech.backend.auth.entity.UserEntity;
import com.edtech.backend.auth.enums.UserRole;
import com.edtech.backend.auth.repository.UserRepository;
import com.edtech.backend.billing.enums.BillingStatus;
import com.edtech.backend.billing.repository.BillingRepository;
import com.edtech.backend.cls.enums.ClassStatus;
import com.edtech.backend.cls.repository.ClassRepository;
import com.edtech.backend.core.exception.BusinessRuleException;
import com.edtech.backend.core.exception.EntityNotFoundException;
import com.edtech.backend.core.util.ImageCompressUtil;
import com.edtech.backend.student.dto.ParentLinkResponse;
import com.edtech.backend.student.dto.StudentRequest;
import com.edtech.backend.student.dto.StudentResponse;
import com.edtech.backend.student.entity.StudentProfileEntity;
import com.edtech.backend.student.repository.StudentProfileRepository;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class StudentServiceImpl implements StudentService {

    private static final String ERROR_NOT_STUDENT_ROLE = "SĐT này không phải tài khoản học sinh.";
    private static final String ERROR_ALREADY_LINKED   = "Con em này đã được thêm vào danh sách của bạn.";
    private static final String ERROR_STUDENT_NOT_FOUND = "Không tìm thấy thông tin con em.";
    private static final String ERROR_PARENT_NOT_FOUND  = "Không tìm thấy phụ huynh.";

    private final StudentProfileRepository studentProfileRepository;
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final ClassRepository classRepository;
    private final BillingRepository billingRepository;

    @Override
    public StudentResponse lookupByPhone(String phone) {
        Optional<UserEntity> studentUser = userRepository.findByIdentifierAndRoleAndIsDeletedFalse(phone, UserRole.STUDENT);

        if (studentUser.isEmpty()) {
            assertPhoneNotUsedByOtherRole(phone);
            return null; // NOT_FOUND — caller xử lý
        }

        return toBasicResponse(studentUser.get());
    }

    @Override
    public List<StudentResponse> getChildrenByParentId(UUID parentId) {
        return studentProfileRepository.findByParentIdAndNotDeleted(parentId)
                .stream()
                .map(this::toResponse)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional
    public StudentResponse addChild(StudentRequest request, UUID parentId) {
        if (request.phone() != null && !request.phone().isBlank()) {
            return addExistingOrPhoneChild(request, parentId);
        } else {
            return addNewPhonelessChild(request, parentId);
        }
    }

    private StudentResponse addExistingOrPhoneChild(StudentRequest request, UUID parentId) {
        Optional<UserEntity> existingStudent = userRepository
                .findByIdentifierAndRoleAndIsDeletedFalse(request.phone(), UserRole.STUDENT);

        if (existingStudent.isEmpty()) {
            assertPhoneNotUsedByOtherRole(request.phone());
            // SĐT chưa có trong hệ thống → yêu cầu HS tự đăng ký
            throw new BusinessRuleException(
                    "Không tìm thấy tài khoản học sinh với SĐT này. "
                  + "Vui lòng yêu cầu học sinh đăng ký tài khoản trên ứng dụng trước, "
                  + "sau đó quay lại liên kết bằng SĐT.");
        }

        UserEntity studentUser = existingStudent.get();
        boolean linkedToMe = studentProfileRepository.findByUserIdAndParentId(studentUser.getId(), parentId).isPresent();
        if (linkedToMe) {
            throw new BusinessRuleException(ERROR_ALREADY_LINKED);
        }

        // Tạo yêu cầu liên kết PENDING — HS phải chấp nhận
        StudentProfileEntity profile = buildStudentProfile(studentUser, parentId, request, "PENDING");
        profile.setInitiatedBy("PARENT");
        return toResponseEx(studentProfileRepository.save(profile), null, null);
    }

    private StudentResponse addNewPhonelessChild(StudentRequest request, UUID parentId) {
        String generatedUsername = "hs_" + UUID.randomUUID().toString().substring(0, 8);
        String defaultPassword = "123456";

        UserEntity newStudent = createNewStudentUser(request, null, generatedUsername);
        StudentProfileEntity profile = buildStudentProfile(newStudent, parentId, request, "ACCEPTED");

        return toResponseEx(studentProfileRepository.save(profile), generatedUsername, defaultPassword);
    }

    @Override
    @Transactional
    public StudentResponse updateChild(UUID studentProfileId, UUID parentId, StudentRequest request) {
        StudentProfileEntity profile = findProfileOrThrow(studentProfileId, parentId);

        updateUserName(profile.getUser(), request.fullName());
        updateProfileDetails(profile, request);

        StudentProfileEntity savedProfile = studentProfileRepository.save(profile);
        return toResponse(savedProfile);
    }

    @Override
    @Transactional
    public void removeChild(UUID studentProfileId, UUID parentId) {
        StudentProfileEntity profile = findProfileOrThrow(studentProfileId, parentId);
        UserEntity studentUser = profile.getUser();

        // Chặn hủy liên kết nếu có lớp học đang active hoặc có hóa đơn chưa thanh toán
        assertNoActiveClassesOrUnpaidBills(studentUser.getId());

        studentProfileRepository.delete(profile);
        
        // Chỉ soft-delete user nếu học sinh này không có SĐT (tài khoản do PH tạo 100%)
        if (studentUser.getPhone() == null || studentUser.getPhone().isBlank()) {
            softDeleteUser(studentUser);
        }
    }

    // ─── Student API ──────────────────────────────────────────────────────────

    @Override
    public List<ParentLinkResponse> getParentLinks(UUID studentId) {
        return studentProfileRepository.findByUserId(studentId)
                .stream()
                .map(profile -> {
                    UserEntity parent = userRepository.findById(profile.getParentId())
                            .orElseThrow(() -> new EntityNotFoundException("Không tìm thấy phụ huynh: " + profile.getParentId()));
                    return ParentLinkResponse.builder()
                            .id(profile.getId())
                            .parentId(parent.getId())
                            .parentName(parent.getFullName())
                            .parentPhone(parent.getPhone())
                            .linkStatus(profile.getLinkStatus())
                            .initiatedBy(profile.getInitiatedBy())
                            .createdAt(profile.getCreatedAt())
                            .build();
                })
                .collect(Collectors.toList());
    }

    @Override
    @Transactional
    public void acceptParentLink(UUID studentId, UUID linkId) {
        StudentProfileEntity profile = studentProfileRepository.findById(linkId)
                .orElseThrow(() -> new EntityNotFoundException("Không tìm thấy yêu cầu liên kết."));
        if (!profile.getUser().getId().equals(studentId)) {
            throw new BusinessRuleException("Bạn không có quyền thao tác trên liên kết này.");
        }
        profile.setLinkStatus("ACCEPTED");
        studentProfileRepository.save(profile);
        
        migrateStudentAssetsToParent(studentId, profile.getParentId());
    }

    @Override
    @Transactional
    public void rejectParentLink(UUID studentId, UUID linkId) {
        StudentProfileEntity profile = studentProfileRepository.findById(linkId)
                .orElseThrow(() -> new EntityNotFoundException("Không tìm thấy yêu cầu liên kết."));
        if (!profile.getUser().getId().equals(studentId)) {
            throw new BusinessRuleException("Bạn không có quyền thao tác trên liên kết này.");
        }
        
        // Nếu đây là hủy liên kết đã ACCEPTED, cũng cần check điều kiện
        if ("ACCEPTED".equals(profile.getLinkStatus())) {
            assertNoActiveClassesOrUnpaidBills(studentId);
        }
        
        studentProfileRepository.delete(profile);
    }

    @Override
    @Transactional
    public void requestParentLink(UUID studentId, String parentPhone) {
        UserEntity parent = userRepository.findByIdentifierAndRoleAndIsDeletedFalse(parentPhone, UserRole.PARENT)
                .orElseThrow(() -> new BusinessRuleException("Không tìm thấy phụ huynh với số điện thoại này."));

        UserEntity student = userRepository.findById(studentId)
                .orElseThrow(() -> new EntityNotFoundException("Không tìm thấy học sinh."));

        boolean isAlreadyLinked = studentProfileRepository.findByUserIdAndParentId(studentId, parent.getId()).isPresent();
        if (isAlreadyLinked) {
            throw new BusinessRuleException("Bạn đã gửi yêu cầu hoặc đã liên kết với phụ huynh này.");
        }

        StudentProfileEntity profile = StudentProfileEntity.builder()
                .user(student)
                .parentId(parent.getId())
                .grade(null)
                .school(null)
                .linkStatus("ACCEPTED") // Tự động duyệt theo yêu cầu
                .initiatedBy("STUDENT")
                .build();
        studentProfileRepository.save(profile);
        
        migrateStudentAssetsToParent(studentId, parent.getId());
    }

    // ─── Private helpers ─────────────────────────────────────────────────────

    private void assertPhoneNotUsedByOtherRole(String phone) {
        boolean isUsedByOtherRole = userRepository.findByPhoneAndIsDeletedFalse(phone).isPresent();
        if (isUsedByOtherRole) {
            throw new BusinessRuleException(ERROR_NOT_STUDENT_ROLE);
        }
    }

    private UserEntity createNewStudentUser(StudentRequest request, String phone, String username) {
        String pwd = (username != null) ? passwordEncoder.encode("123456") : "";
        UserEntity newUser = UserEntity.builder()
                .phone(phone)
                .username(username)
                .passwordHash(pwd)
                .fullName(request.fullName())
                .role(UserRole.STUDENT)
                .isActive(true)
                .isDeleted(false)
                .failedAttempts(0)
                .build();
        return userRepository.save(newUser);
    }

    private StudentProfileEntity buildStudentProfile(UserEntity studentUser, UUID parentId, StudentRequest request, String status) {
        return StudentProfileEntity.builder()
                .user(studentUser)
                .parentId(parentId)
                .grade(request.grade())
                .school(request.school())
                .linkStatus(status)
                .build();
    }

    private StudentProfileEntity findProfileOrThrow(UUID profileId, UUID parentId) {
        return studentProfileRepository.findByIdAndParentId(profileId, parentId)
                .orElseThrow(() -> new EntityNotFoundException(ERROR_STUDENT_NOT_FOUND));
    }

    private void updateUserName(UserEntity user, String fullName) {
        user.setFullName(fullName);
        userRepository.save(user);
    }

    private void updateProfileDetails(StudentProfileEntity profile, StudentRequest request) {
        profile.setGrade(request.grade());
        profile.setSchool(request.school());
    }

    private void softDeleteUser(UserEntity user) {
        user.setIsDeleted(true);
        userRepository.save(user);
    }

    @Override
    @Transactional
    public void resetChildPassword(UUID studentProfileId, UUID parentId, String newPassword) {
        StudentProfileEntity profile = findProfileOrThrow(studentProfileId, parentId);
        UserEntity studentUser = profile.getUser();

        studentUser.setPasswordHash(passwordEncoder.encode(newPassword));
        userRepository.save(studentUser);
    }

    private StudentResponse toBasicResponse(UserEntity user) {
        return StudentResponse.builder()
                .userId(user.getId())
                .fullName(user.getFullName())
                .avatarBase64(ImageCompressUtil.decompress(user.getAvatarBase64()))
                .build();
    }

    private StudentResponse toResponse(StudentProfileEntity profile) {
        return toResponseEx(profile, null, null);
    }

    private StudentResponse toResponseEx(StudentProfileEntity profile, String username, String defaultPassword) {
        UserEntity user = profile.getUser();
        return StudentResponse.builder()
                .id(profile.getId())
                .userId(user.getId())
                .fullName(user.getFullName())
                .phone(user.getPhone())
                .grade(profile.getGrade())
                .school(profile.getSchool())
                .avatarBase64(ImageCompressUtil.decompress(user.getAvatarBase64()))
                .createdAt(profile.getCreatedAt())
                .username(username != null ? username : user.getUsername())
                .defaultPassword(defaultPassword)
                .linkStatus(profile.getLinkStatus())
                .build();
    }

    private void assertNoActiveClassesOrUnpaidBills(UUID studentId) {
        long activeClasses = classRepository.countByStudents_IdAndStatusInAndIsDeletedFalse(
                studentId,
                List.of(ClassStatus.PENDING_APPROVAL, ClassStatus.OPEN, ClassStatus.ASSIGNED, ClassStatus.MATCHED, ClassStatus.ACTIVE)
        );
        if (activeClasses > 0) {
            throw new BusinessRuleException("Không thể huỷ liên kết vì học sinh đang tham gia lớp học đang hoạt động.");
        }

        long unpaidBills = billingRepository.countUnpaidByStudentId(
                studentId,
                List.of(BillingStatus.UNPAID, BillingStatus.VERIFYING)
        );
        if (unpaidBills > 0) {
            throw new BusinessRuleException("Không thể huỷ liên kết vì học sinh đang có hoá đơn chưa thanh toán.");
        }
    }

    private void migrateStudentAssetsToParent(UUID studentId, UUID parentId) {
        classRepository.migrateParentId(studentId, parentId);
        UserEntity parent = userRepository.getReferenceById(parentId);
        billingRepository.migrateParent(studentId, parent);
    }
}
