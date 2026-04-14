import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/network/dio_client.dart';

/// Constants
const int _maxSelectTags = 5;
const int _maxBioLength = 500;
const int _maxAchievementsLength = 500;
const int _maxLocationLength = 500;

const List<String> _fallbackSubjects = [
  'Toán', 'Vật Lý', 'Hóa Học', 'Sinh Học', 'Ngữ Văn', 'Tiếng Anh', 'Tin Học',
];

const List<String> _fallbackGradeLevels = [
  'Mầm non', 'Lớp 1', 'Lớp 2', 'Lớp 3', 'Lớp 4', 'Lớp 5',
  'Lớp 6', 'Lớp 7', 'Lớp 8', 'Lớp 9', 'Lớp 10', 'Lớp 11', 'Lớp 12', 'Đại học',
];

const List<Map<String, String>> _teachingModes = [
  {'value': 'ONLINE', 'label': '🌐 Online'},
  {'value': 'OFFLINE', 'label': '🏠 Tại nhà'},
  {'value': 'BOTH', 'label': '✅ Cả hai'},
];

/// Màn hình chỉnh sửa thông tin cá nhân (role-aware).
/// TUTOR: show full profile fields matching web.
/// PARENT/STUDENT: basic fields.
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _imagePicker = ImagePicker();

  // Common fields
  late TextEditingController _emailController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;

  // Student-only
  late TextEditingController _schoolController;
  late TextEditingController _gradeController;

  // Tutor-only
  late TextEditingController _bioController;
  late TextEditingController _locationController;
  late TextEditingController _achievementsController;
  late TextEditingController _bankNameController;
  late TextEditingController _bankAccountController;
  late TextEditingController _bankOwnerController;

  int _experienceYears = 0;
  String _teachingMode = 'BOTH';
  List<String> _selectedSubjects = [];
  List<String> _selectedLevels = [];

  // Available options from API
  List<String> _availableSubjects = _fallbackSubjects;
  List<String> _availableGradeLevels = _fallbackGradeLevels;

  bool _saving = false;
  bool _loading = true;
  bool _isPhoneEditable = false;
  bool _isDirty = false;
  String _role = '';
  String _fullName = '';
  String? _idCardNumber;
  String? _avatarBase64;

  // Snapshots for dirty tracking
  String _initialEmail = '';
  String _initialAddress = '';
  String _initialSchool = '';
  String _initialGrade = '';
  String _initialPhone = '';
  String _initialBio = '';
  String _initialLocation = '';
  String _initialAchievements = '';
  String _initialBankName = '';
  String _initialBankAccount = '';
  String _initialBankOwner = '';
  int _initialExperienceYears = 0;
  String _initialTeachingMode = 'BOTH';
  List<String> _initialSubjects = [];
  List<String> _initialLevels = [];
  String? _initialAvatar;

  bool get _isTutor => _role == 'TUTOR';
  bool get _isStudent => _role == 'STUDENT';

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _addressController = TextEditingController();
    _phoneController = TextEditingController();
    _schoolController = TextEditingController();
    _gradeController = TextEditingController();
    _bioController = TextEditingController();
    _locationController = TextEditingController();
    _achievementsController = TextEditingController();
    _bankNameController = TextEditingController();
    _bankAccountController = TextEditingController();
    _bankOwnerController = TextEditingController();

    // Track changes
    for (final c in _allControllers) {
      c.addListener(_checkDirty);
    }

    _loadProfile();
  }

  List<TextEditingController> get _allControllers => [
    _emailController, _addressController, _phoneController,
    _schoolController, _gradeController,
    _bioController, _locationController, _achievementsController,
    _bankNameController, _bankAccountController, _bankOwnerController,
  ];

  @override
  void dispose() {
    for (final c in _allControllers) {
      c.dispose();
    }
    super.dispose();
  }

  // ═══════════════════════════════════════════════════
  // DATA LOADING
  // ═══════════════════════════════════════════════════

  Future<void> _loadProfile() async {
    try {
      final dio = getIt<DioClient>().dio;

      // First, load basic profile to get role
      final basicResponse = await dio.get('/api/v1/users/profile/me');
      final basicData = basicResponse.data['data'] as Map<String, dynamic>? ?? {};
      _role = basicData['role']?.toString() ?? '';

      if (_isTutor) {
        await _loadTutorProfile(dio);
        await _loadClassFilters(dio);
      } else {
        _populateBasicFields(basicData);
      }

      setState(() => _loading = false);
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
        _showSnack('Lỗi tải thông tin', isError: true);
      }
    }
  }

  Future<void> _loadTutorProfile(dio) async {
    final response = await dio.get('/api/v1/tutors/profile/me');
    final data = response.data['data'] as Map<String, dynamic>? ?? {};

    setState(() {
      _fullName = data['fullName']?.toString() ?? '';
      _idCardNumber = data['idCardNumber']?.toString();
      _avatarBase64 = data['avatarBase64']?.toString();
      _emailController.text = data['email']?.toString() ?? '';
      _bioController.text = data['bio']?.toString() ?? '';
      _locationController.text = data['location']?.toString() ?? '';
      _achievementsController.text = data['achievements']?.toString() ?? '';
      _experienceYears = (data['experienceYears'] as num?)?.toInt() ?? 0;
      _teachingMode = data['teachingMode']?.toString() ?? 'BOTH';
      _selectedSubjects = List<String>.from(data['subjects'] ?? []);
      _selectedLevels = List<String>.from(data['teachingLevels'] ?? []);
      _bankNameController.text = data['bankName']?.toString() ?? '';
      _bankAccountController.text = data['bankAccountNumber']?.toString() ?? '';
      _bankOwnerController.text = data['bankOwnerName']?.toString() ?? '';

      _snapshotInitialTutorState();
    });
  }

  Future<void> _loadClassFilters(dio) async {
    try {
      final response = await dio.get('/api/v1/classes/filters');
      final data = response.data['data'] as Map<String, dynamic>? ?? {};
      final subjects = List<String>.from(data['subjects'] ?? []);
      final levels = List<String>.from(data['levels'] ?? []);
      setState(() {
        if (subjects.isNotEmpty) {
          _availableSubjects = subjects.where((s) => s != 'Khác').toList();
        }
        if (levels.isNotEmpty) {
          _availableGradeLevels = levels.where((l) => l != 'Khác').toList();
        }
      });
    } catch (_) {
      // Use fallback values
    }
  }

  void _populateBasicFields(Map<String, dynamic> data) {
    final phoneValue = data['phone']?.toString() ?? '';
    setState(() {
      _fullName = data['fullName']?.toString() ?? '';
      _emailController.text = data['email']?.toString() ?? '';
      _addressController.text = data['address']?.toString() ?? '';
      _schoolController.text = data['school']?.toString() ?? '';
      _gradeController.text = data['grade']?.toString() ?? '';
      _phoneController.text = phoneValue;
      _isPhoneEditable = phoneValue.isEmpty;
      _avatarBase64 = data['avatarBase64']?.toString();

      _initialEmail = _emailController.text;
      _initialAddress = _addressController.text;
      _initialSchool = _schoolController.text;
      _initialGrade = _gradeController.text;
      _initialPhone = _phoneController.text;
      _initialAvatar = _avatarBase64;
      _isDirty = false;
    });
  }

  void _snapshotInitialTutorState() {
    _initialEmail = _emailController.text;
    _initialBio = _bioController.text;
    _initialLocation = _locationController.text;
    _initialAchievements = _achievementsController.text;
    _initialExperienceYears = _experienceYears;
    _initialTeachingMode = _teachingMode;
    _initialSubjects = List<String>.from(_selectedSubjects);
    _initialLevels = List<String>.from(_selectedLevels);
    _initialBankName = _bankNameController.text;
    _initialBankAccount = _bankAccountController.text;
    _initialBankOwner = _bankOwnerController.text;
    _initialAvatar = _avatarBase64;
    _isDirty = false;
  }

  // ═══════════════════════════════════════════════════
  // DIRTY CHECK
  // ═══════════════════════════════════════════════════

  void _checkDirty() {
    bool dirty;
    if (_isTutor) {
      dirty = _emailController.text != _initialEmail ||
          _bioController.text != _initialBio ||
          _locationController.text != _initialLocation ||
          _achievementsController.text != _initialAchievements ||
          _experienceYears != _initialExperienceYears ||
          _teachingMode != _initialTeachingMode ||
          _bankNameController.text != _initialBankName ||
          _bankAccountController.text != _initialBankAccount ||
          _bankOwnerController.text != _initialBankOwner ||
          _avatarBase64 != _initialAvatar ||
          !_listEquals(_selectedSubjects, _initialSubjects) ||
          !_listEquals(_selectedLevels, _initialLevels);
    } else {
      dirty = _emailController.text != _initialEmail ||
          _addressController.text != _initialAddress ||
          _schoolController.text != _initialSchool ||
          _gradeController.text != _initialGrade ||
          _phoneController.text != _initialPhone ||
          _avatarBase64 != _initialAvatar;
    }
    if (dirty != _isDirty) {
      setState(() => _isDirty = dirty);
    }
  }

  bool _listEquals(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    final sortedA = List<String>.from(a)..sort();
    final sortedB = List<String>.from(b)..sort();
    for (int i = 0; i < sortedA.length; i++) {
      if (sortedA[i] != sortedB[i]) return false;
    }
    return true;
  }

  // ═══════════════════════════════════════════════════
  // AVATAR
  // ═══════════════════════════════════════════════════

  Future<void> _pickAvatar() async {
    try {
      final picked = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 70,
      );
      if (picked == null) return;
      final bytes = await picked.readAsBytes();
      final base64Str = 'data:image/jpeg;base64,${base64Encode(bytes)}';
      setState(() {
        _avatarBase64 = base64Str;
        _checkDirty();
      });
    } catch (e) {
      _showSnack('Không thể chọn ảnh', isError: true);
    }
  }

  // ═══════════════════════════════════════════════════
  // SAVE
  // ═══════════════════════════════════════════════════

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);
    try {
      final dio = getIt<DioClient>().dio;

      if (_isTutor) {
        await _saveTutorProfile(dio);
      } else {
        await _saveBasicProfile(dio);
      }

      if (!mounted) return;
      _showSnack('Đã cập nhật thông tin ✅');
      Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        _showSnack('Lỗi: $e', isError: true);
      }
    }
  }

  Future<void> _saveTutorProfile(dio) async {
    final body = <String, dynamic>{
      'email': _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
      'bio': _bioController.text.trim().isEmpty ? null : _bioController.text.trim(),
      'location': _locationController.text.trim().isEmpty ? null : _locationController.text.trim(),
      'achievements': _achievementsController.text.trim().isEmpty ? null : _achievementsController.text.trim(),
      'experienceYears': _experienceYears,
      'teachingMode': _teachingMode,
      'subjects': _selectedSubjects,
      'teachingLevels': _selectedLevels,
      'bankName': _bankNameController.text.trim(),
      'bankAccountNumber': _bankAccountController.text.trim(),
      'bankOwnerName': _bankOwnerController.text.trim(),
    };
    if (_avatarBase64 != null) {
      body['avatarBase64'] = _avatarBase64;
    }
    await dio.put('/api/v1/tutors/profile/me', data: body);
  }

  Future<void> _saveBasicProfile(dio) async {
    final body = <String, dynamic>{
      'email': _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
      'address': _addressController.text.trim().isEmpty ? null : _addressController.text.trim(),
    };
    if (_isStudent) {
      body['school'] = _schoolController.text.trim().isEmpty ? null : _schoolController.text.trim();
      body['grade'] = _gradeController.text.trim().isEmpty ? null : _gradeController.text.trim();
    }
    if (_isPhoneEditable && _phoneController.text.trim().isNotEmpty) {
      body['phone'] = _phoneController.text.trim();
    }
    if (_avatarBase64 != null) {
      body['avatarBase64'] = _avatarBase64;
    }
    await dio.put('/api/v1/users/profile', data: body);
  }

  // ═══════════════════════════════════════════════════
  // HELPERS
  // ═══════════════════════════════════════════════════

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg, style: const TextStyle(fontWeight: FontWeight.w500)),
      backgroundColor: isError ? const Color(0xFFEF4444) : const Color(0xFF10B981),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    ));
  }

  String _translateRole(String? role) {
    const roles = {
      'PARENT': 'Phụ huynh',
      'STUDENT': 'Học sinh',
      'TUTOR': 'Gia sư',
      'ADMIN': 'Quản trị viên',
    };
    return roles[role] ?? role ?? '—';
  }

  Color _roleColor() {
    const colors = {
      'PARENT': Color(0xFF6366F1),
      'STUDENT': Color(0xFF10B981),
      'TUTOR': Color(0xFF8B5CF6),
      'ADMIN': Color(0xFFEF4444),
    };
    return colors[_role] ?? const Color(0xFF6366F1);
  }

  // ═══════════════════════════════════════════════════
  // BUILD
  // ═══════════════════════════════════════════════════

  /// Xử lý khi nhấn back: nếu có thay đổi → hỏi lưu.
  Future<bool> _onBackPressed() async {
    if (!_isDirty) return true; // Không thay đổi → thoát luôn

    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Lưu thay đổi?'),
        content: const Text('Bạn có muốn lưu những thay đổi trước khi rời đi không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, 'discard'),
            child: Text('Không lưu', style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, 'cancel'),
            child: const Text('Ở lại'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, 'save'),
            child: const Text('Lưu'),
          ),
        ],
      ),
    );

    if (result == 'save') {
      await _saveProfile();
      return false; // _saveProfile đã pop nếu thành công
    }
    return result == 'discard';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final shouldPop = await _onBackPressed();
        if (shouldPop && mounted) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              final shouldPop = await _onBackPressed();
              if (shouldPop && mounted) {
                Navigator.pop(context);
              }
            },
          ),
          title: const Text('Chỉnh sửa hồ sơ'),
          centerTitle: true,
          backgroundColor: theme.colorScheme.surface,
          elevation: 0,
          scrolledUnderElevation: 0,
          titleTextStyle: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
          ),
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  children: [
                    _buildAvatarSection(theme),
                    const SizedBox(height: 24),

                    if (_isTutor)
                      _buildTutorForm(theme)
                    else ...[
                      _buildInfoSection(theme),
                      const SizedBox(height: 20),
                      _buildBasicFormSection(theme),
                    ],

                    const SizedBox(height: 28),
                    _buildSaveButton(theme),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════
  // AVATAR
  // ═══════════════════════════════════════════════════
  Widget _buildAvatarSection(ThemeData theme) {
    final initial = _fullName.isNotEmpty ? _fullName[0].toUpperCase() : '?';
    final color = _roleColor();

    return Column(
        children: [
          GestureDetector(
            onTap: _pickAvatar,
            child: Stack(
              children: [
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [color, color.withAlpha(180)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(color: color.withAlpha(30), blurRadius: 16, offset: const Offset(0, 6)),
                    ],
                  ),
                  child: ClipOval(
                    child: _avatarBase64 != null && _avatarBase64!.contains('base64,')
                        ? Image.memory(
                            base64Decode(_avatarBase64!.split('base64,').last),
                            fit: BoxFit.cover,
                            width: 88,
                            height: 88,
                          )
                        : Center(
                            child: Text(initial, style: const TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.bold)),
                          ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      shape: BoxShape.circle,
                      border: Border.all(color: theme.colorScheme.outlineVariant, width: 1.5),
                    ),
                    child: Icon(Icons.camera_alt_outlined, size: 15, color: theme.colorScheme.onSurfaceVariant),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(_fullName, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: color.withAlpha(18),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _translateRole(_role),
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color),
            ),
          ),
        ],
    );
  }

  // ═══════════════════════════════════════════════════
  // TUTOR FULL FORM
  // ═══════════════════════════════════════════════════
  Widget _buildTutorForm(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Identity card (read-only) ──
        if (_idCardNumber != null && _idCardNumber!.isNotEmpty) ...[
          _buildReadOnlyTile(theme, Icons.badge_outlined, 'Số CCCD / CMND',
              _idCardNumber!.replaceAllMapped(RegExp(r'(\d{4})(?=\d)'), (m) => '${m[1]} ')),
          const SizedBox(height: 16),
        ],

        // ── Email ──
        _buildSectionCard(theme, title: '📧 Email liên hệ', children: [
          _buildField(theme, controller: _emailController, label: 'Email', hint: 'example@gmail.com', icon: Icons.email_outlined, keyboardType: TextInputType.emailAddress),
        ]),

        // ── Bank Info ──
        _buildSectionCard(theme, title: '💸 Tài khoản ngân hàng', subtitle: 'Vui lòng nhập chính xác. Kế toán sẽ chuyển khoản tự động.', children: [
          _buildField(theme, controller: _bankNameController, label: 'Ngân hàng', hint: 'VD: MB Bank, Vietcombank...', icon: Icons.account_balance_outlined),
          const SizedBox(height: 12),
          _buildField(theme, controller: _bankAccountController, label: 'Số tài khoản', hint: 'Nhập số tài khoản', icon: Icons.credit_card_outlined, keyboardType: TextInputType.number),
          const SizedBox(height: 12),
          _buildField(theme, controller: _bankOwnerController, label: 'Tên người thụ hưởng', hint: 'VIẾT HOA KHÔNG DẤU', icon: Icons.person_outline),
        ]),

        // ── Bio ──
        _buildSectionCard(theme, title: '📝 Giới thiệu bản thân', children: [
          _buildTextarea(theme, controller: _bioController, hint: 'Giới thiệu ngắn về bản thân, phong cách dạy học...', maxLength: _maxBioLength),
        ]),

        // ── Location ──
        _buildSectionCard(theme, title: '📍 Khu vực dạy', children: [
          _buildTextarea(theme, controller: _locationController, hint: 'VD: Quận 1, Quận 3, TP.HCM...', maxLength: _maxLocationLength, maxLines: 2),
        ]),

        // ── Subjects ──
        _buildSectionCard(theme, title: '📚 Môn học', subtitle: 'Chọn tối đa $_maxSelectTags môn', children: [
          _buildTagSelector(theme, options: _availableSubjects, selected: _selectedSubjects, onToggle: (s) {
            setState(() {
              if (_selectedSubjects.contains(s)) {
                _selectedSubjects.remove(s);
              } else if (_selectedSubjects.length < _maxSelectTags) {
                _selectedSubjects.add(s);
              }
              _checkDirty();
            });
          }),
        ]),

        // ── Teaching Levels ──
        _buildSectionCard(theme, title: '🎓 Cấp độ giảng dạy', subtitle: 'Chọn tối đa $_maxSelectTags cấp', children: [
          _buildTagSelector(theme, options: _availableGradeLevels, selected: _selectedLevels, onToggle: (l) {
            setState(() {
              if (_selectedLevels.contains(l)) {
                _selectedLevels.remove(l);
              } else if (_selectedLevels.length < _maxSelectTags) {
                _selectedLevels.add(l);
              }
              _checkDirty();
            });
          }),
        ]),

        // ── Teaching Mode + Experience ──
        _buildSectionCard(theme, title: '🏫 Hình thức dạy', children: [
          _buildTeachingModeSelector(theme),
          const SizedBox(height: 20),
          _buildSectionLabel(theme, '⭐ Số năm kinh nghiệm'),
          _buildExperienceInput(theme),
        ]),

        // ── Achievements ──
        _buildSectionCard(theme, title: '🏆 Thành tích & Kinh nghiệm', children: [
          _buildTextarea(theme, controller: _achievementsController, hint: 'Giải thưởng, kinh nghiệm nổi bật, chứng chỉ...', maxLength: _maxAchievementsLength),
        ]),
      ],
    );
  }

  // ═══════════════════════════════════════════════════
  // SECTION CARD — wraps content in a bordered card
  // ═══════════════════════════════════════════════════
  Widget _buildSectionCard(ThemeData theme, {
    required String title,
    String? subtitle,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline.withAlpha(35)),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withAlpha(8),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant.withAlpha(150)),
            ),
          ],
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════
  // SECTION LABEL (for inline use inside cards)
  // ═══════════════════════════════════════════════════
  Widget _buildSectionLabel(ThemeData theme, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700, color: theme.colorScheme.onSurfaceVariant),
      ),
    );
  }

  // ═══════════════════════════════════════════════════
  // TEXTAREA
  // ═══════════════════════════════════════════════════
  Widget _buildTextarea(ThemeData theme, {
    required TextEditingController controller,
    required String hint,
    required int maxLength,
    int maxLines = 4,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        TextFormField(
          controller: controller,
          maxLength: maxLength,
          maxLines: maxLines,
          onChanged: (v) {
            if (v.length > maxLength) {
              controller.text = v.substring(0, maxLength);
              controller.selection = TextSelection.fromPosition(TextPosition(offset: maxLength));
            }
          },
          style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: theme.colorScheme.onSurfaceVariant.withAlpha(100)),
            counterText: '', // hide default counter
            filled: true,
            fillColor: theme.colorScheme.surfaceContainerHighest.withAlpha(50),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme.colorScheme.outline.withAlpha(40)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme.colorScheme.outline.withAlpha(40)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.5),
            ),
            contentPadding: const EdgeInsets.all(14),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4, right: 4),
          child: Text(
            '${controller.text.length}/$maxLength',
            style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurfaceVariant.withAlpha(120)),
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════
  // TAG SELECTOR (multi-select chips)
  // ═══════════════════════════════════════════════════
  Widget _buildTagSelector(ThemeData theme, {
    required List<String> options,
    required List<String> selected,
    required ValueChanged<String> onToggle,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((tag) {
        final isSelected = selected.contains(tag);
        return GestureDetector(
          onTap: () => onToggle(tag),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? theme.colorScheme.primary.withAlpha(20)
                  : theme.colorScheme.surfaceContainerHighest.withAlpha(60),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? theme.colorScheme.primary.withAlpha(100)
                    : theme.colorScheme.outline.withAlpha(40),
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Text(
              tag,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ═══════════════════════════════════════════════════
  // TEACHING MODE SELECTOR
  // ═══════════════════════════════════════════════════
  Widget _buildTeachingModeSelector(ThemeData theme) {
    return Row(
      children: _teachingModes.map((mode) {
        final isSelected = _teachingMode == mode['value'];
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: mode != _teachingModes.last ? 8 : 0,
            ),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _teachingMode = mode['value']!;
                  _checkDirty();
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.primary.withAlpha(20)
                      : theme.colorScheme.surfaceContainerHighest.withAlpha(60),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outline.withAlpha(40),
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    mode['label']!,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ═══════════════════════════════════════════════════
  // EXPERIENCE INPUT
  // ═══════════════════════════════════════════════════
  Widget _buildExperienceInput(ThemeData theme) {
    return Row(
      children: [
        _buildExperienceButton(theme, Icons.remove, () {
          if (_experienceYears > 0) {
            setState(() {
              _experienceYears--;
              _checkDirty();
            });
          }
        }),
        const SizedBox(width: 16),
        Container(
          width: 56,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withAlpha(80),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '$_experienceYears',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(width: 16),
        _buildExperienceButton(theme, Icons.add, () {
          if (_experienceYears < 50) {
            setState(() {
              _experienceYears++;
              _checkDirty();
            });
          }
        }),
        const SizedBox(width: 12),
        Text('năm', style: TextStyle(fontSize: 14, color: theme.colorScheme.onSurfaceVariant)),
      ],
    );
  }

  Widget _buildExperienceButton(ThemeData theme, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withAlpha(15),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: theme.colorScheme.primary.withAlpha(40)),
        ),
        child: Icon(icon, color: theme.colorScheme.primary, size: 20),
      ),
    );
  }

  // ═══════════════════════════════════════════════════
  // BASIC FORM (Parent/Student)
  // ═══════════════════════════════════════════════════
  Widget _buildInfoSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_isPhoneEditable)
          _buildField(theme, controller: _phoneController, label: 'Số điện thoại', hint: '0345851204', icon: Icons.phone_outlined, keyboardType: TextInputType.phone,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return null;
              if (!RegExp(r'^0\d{9}$').hasMatch(v.trim())) return '10 số, bắt đầu bằng 0';
              return null;
            },
          )
        else
          _buildReadOnlyTile(theme, Icons.phone_outlined, 'Số điện thoại', _phoneController.text),
      ],
    );
  }

  Widget _buildBasicFormSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel(theme, 'Thông tin liên hệ'),
        _buildField(theme, controller: _emailController, label: 'Email', hint: 'your@email.com', icon: Icons.email_outlined, keyboardType: TextInputType.emailAddress),
        const SizedBox(height: 14),
        _buildField(theme, controller: _addressController, label: 'Địa chỉ', hint: 'Số nhà, đường, quận/huyện...', icon: Icons.location_on_outlined, maxLines: 2),
        if (_isStudent) ...[
          const SizedBox(height: 14),
          _buildField(theme, controller: _schoolController, label: 'Trường học', hint: 'Tên trường', icon: Icons.school_outlined),
          const SizedBox(height: 14),
          _buildField(theme, controller: _gradeController, label: 'Lớp / Khối', hint: 'VD: Lớp 10', icon: Icons.class_outlined),
        ],
      ],
    );
  }

  // ═══════════════════════════════════════════════════
  // INPUT FIELD
  // ═══════════════════════════════════════════════════
  Widget _buildField(
    ThemeData theme, {
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: TextStyle(color: theme.colorScheme.onSurfaceVariant.withAlpha(100)),
        prefixIcon: Icon(icon, size: 20, color: theme.colorScheme.onSurfaceVariant),
        filled: true,
        fillColor: theme.colorScheme.surfaceContainerHighest.withAlpha(50),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.colorScheme.outline.withAlpha(40)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.colorScheme.outline.withAlpha(40)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFEF4444)),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  // ═══════════════════════════════════════════════════
  // READ-ONLY TILE
  // ═══════════════════════════════════════════════════
  Widget _buildReadOnlyTile(ThemeData theme, IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withAlpha(60),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline.withAlpha(25)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurfaceVariant)),
              const SizedBox(height: 2),
              Text(
                value.isNotEmpty ? value : '—',
                style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const Spacer(),
          Icon(Icons.lock_outline, size: 15, color: theme.colorScheme.onSurfaceVariant.withAlpha(80)),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════
  // SAVE BUTTON
  // ═══════════════════════════════════════════════════
  Widget _buildSaveButton(ThemeData theme) {
    final canSave = _isDirty && !_saving;

    return AnimatedOpacity(
      opacity: _isDirty ? 1.0 : 0.4,
      duration: const Duration(milliseconds: 200),
      child: FilledButton(
        onPressed: canSave ? _saveProfile : null,
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: theme.colorScheme.primary,
          disabledBackgroundColor: theme.colorScheme.primary.withAlpha(100),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: _saving
            ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
            : const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check, size: 20, color: Colors.white),
                  SizedBox(width: 8),
                  Text('Lưu thay đổi', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ],
              ),
      ),
    );
  }
}
