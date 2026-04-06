import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

/// Register OTP Screen — mock Firebase OTP verification
/// Accepts code 123456 on test env (same as web localhost bypass)
/// After verification → calls /api/v1/auth/firebase
class RegisterOtpScreen extends StatefulWidget {
  final String phone;
  final String fullName;
  final String password;
  final String role;

  const RegisterOtpScreen({
    super.key,
    required this.phone,
    required this.fullName,
    required this.password,
    required this.role,
  });

  @override
  State<RegisterOtpScreen> createState() => _RegisterOtpScreenState();
}

class _RegisterOtpScreenState extends State<RegisterOtpScreen>
    with SingleTickerProviderStateMixin {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  static const _mockOtpCode = '123456';
  int _secondsLeft = 300;
  Timer? _timer;
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;
  String? _error;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        if (_secondsLeft > 0) _secondsLeft--;
      });
    });
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    _timer?.cancel();
    _pulseCtrl.dispose();
    super.dispose();
  }

  String get _otp => _controllers.map((c) => c.text).join();
  int get _filledCount => _controllers.where((c) => c.text.isNotEmpty).length;

  String get _timerLabel {
    final m = _secondsLeft ~/ 60;
    final s = _secondsLeft % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  void _onChanged(int index, String value) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    setState(() => _error = null);
    if (_otp.length == 6) _submit();
  }

  void _submit() {
    if (_otp.length < 6) return;

    // Mock OTP verification (same as web)
    if (_otp != _mockOtpCode) {
      _clearOtp();
      setState(() => _error = 'Mã OTP sai. Môi trường test vui lòng nhập: $_mockOtpCode');
      return;
    }

    // OTP correct → call Firebase auth API
    context.read<AuthBloc>().add(AuthRegisterRequested(
          widget.phone,
          widget.password,
          widget.fullName,
          widget.role,
        ));
  }

  void _clearOtp() {
    for (final c in _controllers) {
      c.clear();
    }
    _focusNodes[0].requestFocus();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          context.go('/home');
        } else if (state is AuthError) {
          _clearOtp();
          setState(() => _error = state.message);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 20),
            onPressed: () => context.pop(),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),

                // --- Shield icon with pulse ---
                Center(
                  child: ScaleTransition(
                    scale: _pulseAnim,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [AppTheme.primary, AppTheme.accent],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primary.withAlpha(100),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.shield_outlined, color: Colors.white, size: 38),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // --- Title ---
                const Text(
                  'Xác thực OTP',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text.rich(
                  TextSpan(
                    text: 'Mã 6 chữ số đã gửi đến\n',
                    style: TextStyle(
                      color: isDark ? Colors.white54 : Colors.grey[600],
                      height: 1.5,
                    ),
                    children: [
                      TextSpan(
                        text: widget.phone,
                        style: TextStyle(
                          color: cs.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Text(
                  'Môi trường test: nhập 123456',
                  style: TextStyle(
                    color: isDark ? Colors.white30 : Colors.grey[400],
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 24),

                // --- Progress bar ---
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: _filledCount / 6,
                    minHeight: 4,
                    backgroundColor: isDark ? Colors.white12 : Colors.grey.shade200,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primary),
                  ),
                ),

                const SizedBox(height: 28),

                // --- OTP input boxes ---
                _buildOtpBoxes(cs, isDark),

                const SizedBox(height: 20),

                // --- Error ---
                if (_error != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    margin: const EdgeInsets.only(bottom: 14),
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
                          child: Text(
                            _error!,
                            style: const TextStyle(color: AppTheme.error, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),

                // --- Submit button ---
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (_, state) {
                    final isLoading = state is AuthLoading;
                    return GestureDetector(
                      onTap: (_filledCount == 6 && !isLoading) ? _submit : null,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: (_filledCount == 6 && !isLoading)
                              ? const LinearGradient(colors: [AppTheme.primary, AppTheme.accent])
                              : null,
                          color: (_filledCount < 6 || isLoading) ? Colors.grey[300] : null,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: _filledCount == 6 && !isLoading
                              ? [const BoxShadow(color: Color(0x446366F1), blurRadius: 16, offset: Offset(0, 6))]
                              : [],
                        ),
                        child: Center(
                          child: isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                )
                              : Text(
                                  'Xác nhận & Tạo tài khoản',
                                  style: TextStyle(
                                    color: _filledCount == 6 ? Colors.white : Colors.grey[500],
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                  ),
                                ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 16),

                // --- Timer ---
                Center(
                  child: Text(
                    _secondsLeft > 0 ? 'Mã hết hạn sau $_timerLabel' : 'Mã đã hết hạn',
                    style: TextStyle(
                      color: _secondsLeft > 0
                          ? (isDark ? Colors.white38 : Colors.grey[500])
                          : AppTheme.error,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOtpBoxes(ColorScheme cs, bool isDark) {
    final filled = _controllers.map((c) => c.text.isNotEmpty).toList();
    final borderBase = isDark ? Colors.white12 : Colors.grey.shade300;

    Widget box(int i) => SizedBox(
          width: 46,
          height: 54,
          child: TextFormField(
            controller: _controllers[i],
            focusNode: _focusNodes[i],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            autofocus: i == 0,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: filled[i] ? AppTheme.primary : null,
            ),
            decoration: InputDecoration(
              counterText: '',
              filled: filled[i],
              fillColor: filled[i] ? AppTheme.primary.withAlpha(20) : Colors.transparent,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: filled[i] ? AppTheme.primary : borderBase,
                  width: filled[i] ? 2 : 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppTheme.primary, width: 2),
              ),
            ),
            onChanged: (v) => _onChanged(i, v),
          ),
        );

    const sep = Padding(
      padding: EdgeInsets.symmetric(horizontal: 6),
      child: Text('·', style: TextStyle(fontSize: 22, color: Colors.grey)),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ...List.generate(
            3,
            (i) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: box(i),
                )),
        sep,
        ...List.generate(
            3,
            (j) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: box(j + 3),
                )),
      ],
    );
  }
}
