import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme.dart';
import '../../../../core/di/injection.dart';
import '../bloc/tutor_profile_bloc.dart';
import '../bloc/tutor_profile_event.dart';
import '../bloc/tutor_profile_state.dart';

/// Tutor Verification Screen — 9 fields matching web TutorVerificationModal.
/// POST /api/v1/tutors/profile/verify (multipart/form-data)
class TutorVerificationScreen extends StatefulWidget {
  const TutorVerificationScreen({super.key});

  @override
  State<TutorVerificationScreen> createState() => _TutorVerificationScreenState();
}

class _TutorVerificationScreenState extends State<TutorVerificationScreen> {
  final _bloc = getIt<TutorProfileBloc>();
  final _picker = ImagePicker();

  static const int _maxChipSelect = 5;
  static const int _maxTextLength = 500;

  // ── Form state ──
  String _tutorType = 'STUDENT';
  String _dateOfBirth = '';
  String _idCardNumber = '';
  File? _degree;
  Uint8List? _degreeBytes; // For preview on web
  final List<String> _subjects = [];
  final List<String> _teachingLevels = [];
  int _experienceYears = 0;
  String _location = '';
  String _achievements = '';
  String? _error;

  // ── Filter data from BLoC ──
  List<String> _availableSubjects = [];
  List<String> _availableLevels = [];
  bool _filtersLoaded = false;

  @override
  void initState() {
    super.initState();
    _bloc.add(LoadClassFilters());
  }

  Future<void> _pickDegreeImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() {
        _degreeBytes = bytes;
        if (!kIsWeb) _degree = File(picked.path);
      });
    }
  }

  void _toggleChip(String item, List<String> list) {
    setState(() {
      if (list.contains(item)) {
        list.remove(item);
      } else if (list.length < _maxChipSelect) {
        list.add(item);
      }
    });
  }

  void _submit() {
    // Validation (same as web)
    if (_dateOfBirth.length != 10) {
      setState(() => _error = 'Vui lòng nhập đầy đủ ngày tháng năm sinh (DD/MM/YYYY).');
      return;
    }
    if (_idCardNumber.trim().isEmpty) {
      setState(() => _error = 'Vui lòng nhập số CCCD / CMND.');
      return;
    }
    if (_degreeBytes == null) {
      setState(() => _error = 'Vui lòng tải lên ảnh chứng từ phù hợp.');
      return;
    }
    if (_subjects.isEmpty) {
      setState(() => _error = 'Vui lòng chọn ít nhất 1 môn học sở trường.');
      return;
    }
    if (_teachingLevels.isEmpty) {
      setState(() => _error = 'Vui lòng chọn ít nhất 1 lớp giảng dạy.');
      return;
    }

    setState(() => _error = null);

    // Convert DD/MM/YYYY → YYYY-MM-DD for BE
    final parts = _dateOfBirth.split('/');
    final formattedDob = (parts.length == 3) ? '${parts[2]}-${parts[1]}-${parts[0]}' : _dateOfBirth;

    _bloc.add(VerifyTutorProfile(
      tutorType: _tutorType,
      idCardNumber: _idCardNumber.trim(),
      degree: _degree,
      dateOfBirth: formattedDob,
      subjects: List<String>.from(_subjects),
      teachingLevels: List<String>.from(_teachingLevels),
      achievements: _achievements.trim(),
      experienceYears: _experienceYears,
      location: _location.trim(),
    ));
  }

  String get _degreeLabel {
    switch (_tutorType) {
      case 'STUDENT':
        return 'Ảnh thẻ sinh viên';
      case 'TEACHER':
        return 'Chứng chỉ nghiệp vụ / sư phạm';
      case 'GRADUATED':
        return 'Bằng / Chứng nhận tốt nghiệp';
      default:
        return 'Giấy tờ liên quan';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocProvider.value(
      value: _bloc,
      child: BlocConsumer<TutorProfileBloc, TutorProfileState>(
        listener: (context, state) {
          if (state is ClassFiltersLoaded) {
            setState(() {
              _availableSubjects = state.subjects;
              _availableLevels = state.levels;
              _filtersLoaded = true;
            });
          } else if (state is TutorProfileError) {
            setState(() => _error = state.message);
          } else if (state is TutorProfileVerificationSuccess) {
            _showSuccessDialog();
          }
        },
        builder: (context, state) {
          final isLoading = state is TutorProfileLoading;

          // No Scaffold — this widget is embedded inside TutorDashboard's body
          if (!_filtersLoaded) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildHeader(isDark),
                        const SizedBox(height: 24),
                        _buildTutorTypeDropdown(theme),
                        const SizedBox(height: 16),
                        _buildDateOfBirthField(theme, isDark),
                        const SizedBox(height: 16),
                        _buildIdCardField(theme, isDark),
                        const SizedBox(height: 16),
                        _buildDegreeUpload(theme, isDark),
                        const SizedBox(height: 20),
                        _buildChipSection('Môn học sở trường', _availableSubjects, _subjects),
                        const SizedBox(height: 16),
                        _buildChipSection('Lớp giảng dạy', _availableLevels, _teachingLevels),
                        const SizedBox(height: 16),
                        _buildExperienceField(theme, isDark),
                        const SizedBox(height: 16),
                        _buildTextAreaField(
                          label: 'Khu vực dạy',
                          hint: 'VD: Quận 1, Quận 3, TP.HCM / Cầu Giấy, Hà Nội...',
                          value: _location,
                          onChanged: (v) => setState(() => _location = v),
                          maxLines: 2,
                          theme: theme,
                          isDark: isDark,
                        ),
                        const SizedBox(height: 16),
                        _buildTextAreaField(
                          label: 'Thành tích & Kinh nghiệm dạy học',
                          hint: 'Mô tả thành tích nổi bật, giải thưởng, kinh nghiệm...',
                          value: _achievements,
                          onChanged: (v) => setState(() => _achievements = v),
                          maxLines: 4,
                          theme: theme,
                          isDark: isDark,
                        ),
                        const SizedBox(height: 20),
                        if (_error != null) _buildErrorBox(),
                        const SizedBox(height: 8),
                        _buildSubmitButton(isLoading),
                        const SizedBox(height: 32),
                      ],
                    ),
                  );
        },
      ),
    );
  }

  // ── Sub-widgets ──

  Widget _buildHeader(bool isDark) {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(colors: [AppTheme.primary, AppTheme.accent]),
            boxShadow: [BoxShadow(color: AppTheme.primary.withAlpha(60), blurRadius: 16, offset: const Offset(0, 6))],
          ),
          child: const Icon(Icons.verified_user_outlined, color: Colors.white, size: 30),
        ),
        const SizedBox(height: 12),
        const Text('Xác thực hồ sơ gia sư', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
        const SizedBox(height: 4),
        Text(
          'Để bắt đầu nhận lớp, bạn cần hoàn thành xác thực hồ sơ.',
          style: TextStyle(color: isDark ? Colors.white54 : Colors.grey[600], fontSize: 13),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildTutorTypeDropdown(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Loại gia sư', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: _tutorType,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
          items: const [
            DropdownMenuItem(value: 'STUDENT', child: Text('Sinh viên')),
            DropdownMenuItem(value: 'TEACHER', child: Text('Giáo viên')),
            DropdownMenuItem(value: 'GRADUATED', child: Text('Gia sư Tốt nghiệp')),
          ],
          onChanged: (val) {
            if (val != null) setState(() { _tutorType = val; _degree = null; });
          },
        ),
      ],
    );
  }

  Widget _buildDateOfBirthField(ThemeData theme, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _requiredLabel('Ngày tháng năm sinh'),
        const SizedBox(height: 6),
        TextFormField(
          initialValue: _dateOfBirth,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly, _DateInputFormatter()],
          decoration: _fieldDecoration(theme, isDark, 'DD/MM/YYYY', Icons.calendar_today),
          onChanged: (v) => _dateOfBirth = v,
        ),
      ],
    );
  }

  Widget _buildIdCardField(ThemeData theme, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _requiredLabel('Số CCCD / CMND'),
        const SizedBox(height: 6),
        TextFormField(
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(12)],
          decoration: _fieldDecoration(theme, isDark, 'Nhập số CCCD/CMND (12 số)', Icons.credit_card),
          onChanged: (v) => _idCardNumber = v,
        ),
      ],
    );
  }

  Widget _buildDegreeUpload(ThemeData theme, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _requiredLabel(_degreeLabel),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: _pickDegreeImage,
          child: Container(
            height: 130,
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withAlpha(10) : Colors.grey.withAlpha(20),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _degreeBytes != null ? AppTheme.primary : (isDark ? Colors.white24 : Colors.grey.shade300),
                width: _degreeBytes != null ? 2 : 1,
              ),
            ),
            child: _degreeBytes != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.memory(_degreeBytes!, fit: BoxFit.cover),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.close, color: Colors.white, size: 18),
                              onPressed: () => setState(() { _degree = null; _degreeBytes = null; }),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_photo_alternate_outlined, size: 36, color: isDark ? Colors.white38 : Colors.grey),
                      const SizedBox(height: 6),
                      Text('Nhấn để chọn ảnh', style: TextStyle(color: isDark ? Colors.white38 : Colors.grey, fontSize: 13)),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildChipSection(String label, List<String> available, List<String> selected) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _requiredLabel('$label (Tối đa $_maxChipSelect)'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: available.map((item) {
            final isSelected = selected.contains(item);
            final isDisabled = !isSelected && selected.length >= _maxChipSelect;
            return GestureDetector(
              onTap: isDisabled ? null : () => _toggleChip(item, selected),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.primary.withAlpha(25) : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? AppTheme.primary : (isDisabled ? Colors.grey.shade300 : Colors.grey.shade400),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Text(
                  item,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? AppTheme.primary : (isDisabled ? Colors.grey.shade400 : null),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 4),
        Text(
          '${selected.length}/$_maxChipSelect đã chọn',
          style: TextStyle(fontSize: 12, color: Colors.grey[500]),
        ),
      ],
    );
  }

  Widget _buildExperienceField(ThemeData theme, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Số năm kinh nghiệm giảng dạy', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 6),
        TextFormField(
          initialValue: _experienceYears.toString(),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(2)],
          decoration: _fieldDecoration(theme, isDark, '0', Icons.work_outline),
          onChanged: (v) => _experienceYears = int.tryParse(v) ?? 0,
        ),
      ],
    );
  }

  Widget _buildTextAreaField({
    required String label,
    required String hint,
    required String value,
    required ValueChanged<String> onChanged,
    required int maxLines,
    required ThemeData theme,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label (Tối đa $_maxTextLength ký tự)', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 6),
        TextFormField(
          initialValue: value,
          maxLines: maxLines,
          maxLength: _maxTextLength,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: isDark ? theme.colorScheme.surfaceContainerHighest.withAlpha(80) : theme.colorScheme.surfaceContainerLowest,
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildErrorBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.error.withAlpha(20),
        border: Border.all(color: AppTheme.error.withAlpha(60)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppTheme.error, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(_error!, style: const TextStyle(color: AppTheme.error, fontSize: 13))),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(bool isLoading) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [AppTheme.primary, AppTheme.accent]),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: AppTheme.primary.withAlpha(60), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : _submit,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: isLoading
            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : const Text('Gửi xác thực', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 56),
            const SizedBox(height: 12),
            const Text('Gửi xác thực thành công!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text(
              'Hồ sơ đã được gửi. Vui lòng chờ Quản trị viên phê duyệt.',
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pop(); // close dialog
        context.go('/home');
      }
    });
  }

  // ── Helpers ──

  Widget _requiredLabel(String text) {
    return RichText(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: Theme.of(context).textTheme.bodyMedium?.color,
        ),
        children: const [
          TextSpan(text: ' (Bắt buộc)', style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w400)),
        ],
      ),
    );
  }

  InputDecoration _fieldDecoration(ThemeData theme, bool isDark, String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, size: 20),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      fillColor: isDark ? theme.colorScheme.surfaceContainerHighest.withAlpha(80) : theme.colorScheme.surfaceContainerLowest,
    );
  }
}

/// Auto-format date input: 01012000 → 01/01/2000
class _DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text.replaceAll('/', '');
    if (text.length > 8) text = text.substring(0, 8);

    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if (i == 2 || i == 4) buffer.write('/');
      buffer.write(text[i]);
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}
