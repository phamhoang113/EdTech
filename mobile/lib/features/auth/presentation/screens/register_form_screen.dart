import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme.dart';

class RegisterFormScreen extends StatefulWidget {
  final String role;

  const RegisterFormScreen({super.key, required this.role});

  @override
  State<RegisterFormScreen> createState() => _RegisterFormScreenState();
}

class _RegisterFormScreenState extends State<RegisterFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  String get _roleLabel {
    switch (widget.role) {
      case 'TUTOR':
        return 'Gia Sư';
      case 'STUDENT':
        return 'Học Sinh';
      default:
        return 'Phụ Huynh';
    }
  }

  String get _roleEmoji {
    switch (widget.role) {
      case 'TUTOR':
        return '👩‍🏫';
      case 'STUDENT':
        return '📚';
      default:
        return '👨‍👩‍👧';
    }
  }

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _nameCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    // Navigate to OTP screen — API is called AFTER OTP mock verification
    context.push(
      '/register-otp',
      extra: {
        'phone': _phoneCtrl.text.trim(),
        'fullName': _nameCtrl.text.trim(),
        'password': _passwordCtrl.text,
        'role': widget.role,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 20),
            onPressed: () => context.pop(),
          ),
          title: Text('Đăng ký — $_roleLabel'),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Logo ──
                  Center(
                    child: Image.asset(
                      'assets/logo.webp',
                      width: 80,
                      height: 80,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Tạo tài khoản',
                    style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Điền thông tin để bắt đầu',
                    style: TextStyle(color: isDark ? Colors.white54 : Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28),

                  // ── Họ và tên ──
                  _buildField(
                    controller: _nameCtrl,
                    label: 'Họ và tên',
                    hint: 'Nguyễn Văn A',
                    icon: Icons.person_outline,
                    keyboardType: TextInputType.name,
                    theme: theme,
                    isDark: isDark,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Vui lòng nhập họ và tên';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // ── SĐT ──
                  _buildField(
                    controller: _phoneCtrl,
                    label: 'Số điện thoại',
                    hint: '0901234567',
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    theme: theme,
                    isDark: isDark,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Vui lòng nhập số điện thoại';
                      final phoneRegex = RegExp(r'^(0|\+84)(3|5|7|8|9)\d{8}$');
                      if (!phoneRegex.hasMatch(v.trim())) return 'Số điện thoại không hợp lệ';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // ── Mật khẩu ──
                  _buildField(
                    controller: _passwordCtrl,
                    label: 'Mật khẩu',
                    hint: 'Ít nhất 6 ký tự',
                    icon: Icons.lock_outline,
                    theme: theme,
                    isDark: isDark,
                    obscureText: _obscurePassword,
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Vui lòng nhập mật khẩu';
                      if (v.length < 6) return 'Mật khẩu phải có ít nhất 6 ký tự';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // ── Xác nhận mật khẩu ──
                  _buildField(
                    controller: _confirmPasswordCtrl,
                    label: 'Xác nhận mật khẩu',
                    hint: 'Nhập lại mật khẩu',
                    icon: Icons.lock_outline,
                    theme: theme,
                    isDark: isDark,
                    obscureText: _obscureConfirm,
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Match indicator
                        if (_confirmPasswordCtrl.text.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: Icon(
                              _passwordCtrl.text == _confirmPasswordCtrl.text
                                  ? Icons.check_circle
                                  : Icons.cancel,
                              size: 18,
                              color: _passwordCtrl.text == _confirmPasswordCtrl.text
                                  ? const Color(0xFF10B981)
                                  : AppTheme.error,
                            ),
                          ),
                        IconButton(
                          icon: Icon(_obscureConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                          onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                        ),
                      ],
                    ),
                    onChanged: (_) => setState(() {}),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Vui lòng xác nhận mật khẩu';
                      if (v != _passwordCtrl.text) return 'Mật khẩu không khớp';
                      return null;
                    },
                  ),
                  const SizedBox(height: 28),

                  // ── Submit ──
                  Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6366F1).withAlpha(60),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text(
                        'Đăng Ký & Nhận OTP',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Terms ──
                  Text(
                    'Bằng cách đăng ký, bạn đồng ý với Điều khoản sử dụng của chúng tôi.',
                    style: TextStyle(
                      color: isDark ? Colors.white38 : Colors.grey[500],
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required ThemeData theme,
    required bool isDark,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.error),
        ),
        filled: true,
        fillColor: isDark
            ? theme.colorScheme.surfaceContainerHighest.withAlpha(80)
            : theme.colorScheme.surfaceContainerLowest,
      ),
      validator: validator,
    );
  }
}
