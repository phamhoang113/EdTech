import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class LoginSheet extends StatefulWidget {
  final VoidCallback? onSuccess;

  const LoginSheet({super.key, this.onSuccess});

  @override
  State<LoginSheet> createState() => _LoginSheetState();
}

class _LoginSheetState extends State<LoginSheet> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    final phone = _phoneController.text.trim();
    final password = _passwordController.text.trim();
    if (phone.isNotEmpty && password.isNotEmpty) {
      context.read<AuthBloc>().add(AuthLoginRequested(phone, password));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập đầy đủ thông tin')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          context.pop();
          if (state.mustChangePassword) {
            context.push('/change-password', extra: {'isForced': true});
          } else {
            widget.onSuccess?.call();
          }
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: bottomInset + 24,
              left: 24,
              right: 24,
              top: 12,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Handle bar ──
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                // ── Header ──
                Text(
                  'Đăng nhập',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Hãy để ứng dụng tìm gia sư phù hợp nhất cho bạn.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 28),

                // ── Phone Field ──
                TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'Số điện thoại',
                    hintText: '0912 345 678',
                    prefixIcon: const Icon(Icons.phone_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: theme.colorScheme.outline),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
                    ),
                    filled: true,
                    fillColor: isDark
                        ? theme.colorScheme.surfaceContainerHighest.withAlpha(80)
                        : theme.colorScheme.surfaceContainerLowest,
                  ),
                  keyboardType: TextInputType.phone,
                  enabled: !isLoading,
                ),
                const SizedBox(height: 16),

                // ── Password Field ──
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Mật khẩu',
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: theme.colorScheme.outline),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
                    ),
                    filled: true,
                    fillColor: isDark
                        ? theme.colorScheme.surfaceContainerHighest.withAlpha(80)
                        : theme.colorScheme.surfaceContainerLowest,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      ),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  obscureText: _obscurePassword,
                  enabled: !isLoading,
                ),

                // ── Forgot Password ──
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            context.pop();
                            context.push('/forgot-password');
                          },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                    ),
                    child: Text(
                      'Quên mật khẩu?',
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // ── Login Button (Gradient) ──
                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
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
                    onPressed: isLoading ? null : _onLoginPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Text(
                            'Đăng Nhập',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
                const SizedBox(height: 20),

                // ── Divider ──
                Row(
                  children: [
                    Expanded(child: Divider(color: theme.colorScheme.outlineVariant)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Hoặc',
                        style: TextStyle(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: theme.colorScheme.outlineVariant)),
                  ],
                ),
                const SizedBox(height: 20),

                // ── Register Button ──
                OutlinedButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          context.pop();
                          context.push('/register/role');
                        },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: theme.colorScheme.primary, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Đăng ký tài khoản mới',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
