import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

/// Forgot Password — 3 steps: INIT → OTP → SUCCESS
/// Synced with web ForgotPasswordModal.tsx.
/// On test env: mock OTP = 123456, mock idToken = MOCK_TOKEN_<phone>
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _identifierCtrl = TextEditingController();
  final _otpCtrl = TextEditingController();

  String _step = 'INIT'; // INIT → OTP → SUCCESS
  String _identifier = '';
  String _maskedPhone = '';
  String _fullPhone = '';
  String _newPassword = '';
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _identifierCtrl.dispose();
    _otpCtrl.dispose();
    super.dispose();
  }

  void _onInitSubmit() {
    final identifier = _identifierCtrl.text.trim();
    if (identifier.isEmpty) {
      setState(() => _error = 'Vui lòng nhập SĐT hoặc tên đăng nhập');
      return;
    }
    setState(() {
      _identifier = identifier;
      _error = null;
    });
    context.read<AuthBloc>().add(AuthForgotPasswordInitRequested(identifier));
  }

  void _onOtpSubmit() {
    final code = _otpCtrl.text.trim();
    if (code.length < 6) {
      setState(() => _error = 'Vui lòng nhập mã OTP 6 số');
      return;
    }
    setState(() => _error = null);

    // Mock for test environment (same as web: code 123456 → MOCK_TOKEN)
    // In production, use Firebase Phone Auth here
    final idToken = 'MOCK_TOKEN_$_fullPhone';
    context.read<AuthBloc>().add(
      AuthForgotPasswordResetRequested(_identifier, idToken),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          setState(() => _isLoading = true);
        } else {
          setState(() => _isLoading = false);
        }

        if (state is AuthForgotPasswordInitSuccess) {
          setState(() {
            _step = 'OTP';
            _maskedPhone = state.maskedPhone;
            _fullPhone = state.fullPhone;
            _error = null;
          });
        } else if (state is AuthForgotPasswordResetSuccess) {
          setState(() {
            _step = 'SUCCESS';
            _newPassword = state.newPassword;
            _error = null;
          });
        } else if (state is AuthError) {
          setState(() => _error = state.message);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 20),
            onPressed: () {
              if (_step == 'OTP') {
                setState(() {
                  _step = 'INIT';
                  _error = null;
                });
              } else {
                context.pop();
              }
            },
          ),
          title: Text(_step == 'INIT'
              ? 'Quên mật khẩu'
              : _step == 'OTP'
                  ? 'Xác thực SMS'
                  : 'Thành công'),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Icon
                Center(
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [AppTheme.primary, AppTheme.accent],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primary.withAlpha(60),
                          blurRadius: 20,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Icon(
                      _step == 'SUCCESS' ? Icons.check_circle : Icons.lock_reset,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Error
                if (_error != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: AppTheme.error.withAlpha(20),
                      border: Border.all(color: AppTheme.error.withAlpha(60)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, color: AppTheme.error, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(_error!, style: const TextStyle(color: AppTheme.error, fontSize: 13)),
                        ),
                      ],
                    ),
                  ),

                // Steps
                if (_step == 'INIT') _buildInitStep(theme, isDark),
                if (_step == 'OTP') _buildOtpStep(theme, isDark),
                if (_step == 'SUCCESS') _buildSuccessStep(theme, isDark),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInitStep(ThemeData theme, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Nhập SĐT hoặc tên đăng nhập của bạn. Hệ thống sẽ gửi mã OTP qua SMS.',
          style: TextStyle(color: isDark ? Colors.white60 : Colors.grey[600], height: 1.5),
        ),
        const SizedBox(height: 24),
        TextField(
          controller: _identifierCtrl,
          keyboardType: TextInputType.phone,
          enabled: !_isLoading,
          decoration: InputDecoration(
            labelText: 'SĐT hoặc Tên đăng nhập',
            hintText: '0901234567',
            prefixIcon: const Icon(Icons.person_outline),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme.colorScheme.outline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
            ),
          ),
        ),
        const SizedBox(height: 24),
        _buildGradientButton(
          text: 'Tiếp tục',
          onPressed: _isLoading ? null : _onInitSubmit,
          isLoading: _isLoading,
        ),
      ],
    );
  }

  Widget _buildOtpStep(ThemeData theme, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        RichText(
          text: TextSpan(
            style: TextStyle(color: isDark ? Colors.white60 : Colors.grey[600], height: 1.5, fontSize: 14),
            children: [
              const TextSpan(text: 'Mã OTP đã gửi đến '),
              TextSpan(
                text: _maskedPhone,
                style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.w700),
              ),
              const TextSpan(text: '.\nMôi trường test: nhập '),
              const TextSpan(
                text: '123456',
                style: TextStyle(fontWeight: FontWeight.w700, fontFamily: 'monospace'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        TextField(
          controller: _otpCtrl,
          keyboardType: TextInputType.number,
          maxLength: 6,
          enabled: !_isLoading,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, letterSpacing: 8),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            labelText: 'Mã OTP (6 số)',
            counterText: '',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme.colorScheme.outline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
            ),
          ),
        ),
        const SizedBox(height: 24),
        _buildGradientButton(
          text: 'Xác nhận',
          onPressed: _isLoading ? null : _onOtpSubmit,
          isLoading: _isLoading,
        ),
      ],
    );
  }

  Widget _buildSuccessStep(ThemeData theme, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF10B981).withAlpha(15),
            border: Border.all(color: const Color(0xFF10B981).withAlpha(40)),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: [
              const Icon(Icons.check_circle, color: Color(0xFF10B981), size: 40),
              const SizedBox(height: 12),
              const Text(
                'Cấp lại mật khẩu thành công!',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Hệ thống đã tạo mật khẩu mới. Nhấn để sao chép:',
                style: TextStyle(color: isDark ? Colors.white60 : Colors.grey[600], fontSize: 13),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: _newPassword));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đã sao chép mật khẩu!')),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white12 : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: theme.colorScheme.primary),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _newPassword,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: theme.colorScheme.primary,
                          fontFamily: 'monospace',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.copy, size: 16, color: theme.colorScheme.primary),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        _buildGradientButton(
          text: 'Quay lại đăng nhập',
          onPressed: () => context.go('/home'),
          isLoading: false,
        ),
      ],
    );
  }

  Widget _buildGradientButton({
    required String text,
    required VoidCallback? onPressed,
    required bool isLoading,
  }) {
    return Container(
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
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
            : Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
