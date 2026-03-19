import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme.dart';

/// Màn hình chọn vai trò — 3 roles: PARENT, STUDENT, TUTOR
/// Layout: vertical rows (emoji | text | radio) giống web
class RegisterRoleScreen extends StatefulWidget {
  const RegisterRoleScreen({super.key});

  @override
  State<RegisterRoleScreen> createState() => _RegisterRoleScreenState();
}

class _RegisterRoleScreenState extends State<RegisterRoleScreen> {
  String? _selectedRole;

  static const _roles = [
    _RoleConfig(
      key: 'PARENT',
      emoji: '👨‍👩‍👧',
      title: 'Phụ huynh',
      subtitle: 'Đặt gia sư cho con',
      desc: 'Tìm gia sư chất lượng, đặt lịch và theo dõi tiến độ học tập của con em.',
      accentColor: Color(0xFF8B5CF6), // violet
    ),
    _RoleConfig(
      key: 'STUDENT',
      emoji: '📚',
      title: 'Học sinh',
      subtitle: 'Tự học & tự thanh toán',
      desc: 'Tự tìm gia sư phù hợp, đặt lịch học và thanh toán học phí cho bản thân.',
      accentColor: Color(0xFF06B6D4), // cyan
    ),
    _RoleConfig(
      key: 'TUTOR',
      emoji: '👩‍🏫',
      title: 'Gia sư',
      subtitle: 'Dạy học, kiếm thêm thu nhập',
      desc: 'Chia sẻ kiến thức, nhận học sinh và tạo nguồn thu nhập ổn định từ việc dạy thêm.',
      accentColor: Color(0xFF6366F1), // indigo
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo
              Row(
                children: [
                  Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [AppTheme.primary, AppTheme.accent]),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text('🎓', style: TextStyle(fontSize: 18)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'EdTech',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      foreground: Paint()
                        ..shader = const LinearGradient(
                          colors: [AppTheme.primary, AppTheme.accent],
                        ).createShader(const Rect.fromLTWH(0, 0, 80, 20)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Heading
              const Text(
                'Tham gia cùng chúng tôi',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              Text(
                'Bạn muốn đăng ký với vai trò nào?',
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.white54 : Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),

              // Role rows
              Expanded(
                child: ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _roles.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) => _buildRoleRow(_roles[i], cs, isDark),
                ),
              ),

              const SizedBox(height: 16),

              // Continue button
              _GradientButton(
                onPressed: _selectedRole == null
                    ? null
                    : () => context.push('/register-form?role=$_selectedRole'),
                label: _selectedRole == null
                    ? 'Chọn vai trò để tiếp tục'
                    : 'Tiếp tục với vai trò ${_roles.firstWhere((r) => r.key == _selectedRole).title}',
              ),

              const SizedBox(height: 12),
              Center(
                child: TextButton(
                  onPressed: () => context.pop(),
                  child: RichText(
                    text: TextSpan(
                      text: 'Đã có tài khoản? ',
                      style: TextStyle(color: isDark ? Colors.white54 : Colors.grey[600]),
                      children: [
                        TextSpan(
                          text: 'Đăng nhập',
                          style: TextStyle(
                            color: cs.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleRow(_RoleConfig r, ColorScheme cs, bool isDark) {
    final selected = _selectedRole == r.key;
    final surfaceColor = isDark ? const Color(0xFF1A1A2E) : Colors.white;
    final borderColor = selected ? r.accentColor : (isDark ? Colors.white12 : Colors.grey.shade200);

    return GestureDetector(
      onTap: () => setState(() => _selectedRole = r.key),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected
              ? r.accentColor.withOpacity(0.07)
              : surfaceColor,
          border: Border.all(
            color: borderColor,
            width: selected ? 2.0 : 1.5,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: selected
              ? [BoxShadow(color: r.accentColor.withOpacity(0.2), blurRadius: 12, offset: const Offset(0, 4))]
              : [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2))],
        ),
        child: Row(
          children: [
            // Emoji
            Text(r.emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 14),

            // Text block
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        r.title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: selected ? r.accentColor : null,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '· ${r.subtitle}',
                        style: TextStyle(
                          fontSize: 11,
                          color: selected ? r.accentColor : (isDark ? Colors.white38 : Colors.grey),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    r.desc,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white54 : Colors.grey[600],
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),

            // Radio indicator
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? r.accentColor : Colors.transparent,
                border: Border.all(
                  color: selected ? r.accentColor : (isDark ? Colors.white24 : Colors.grey.shade400),
                  width: 2,
                ),
              ),
              child: selected
                  ? const Icon(Icons.check, size: 13, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Data class ──
class _RoleConfig {
  final String key, emoji, title, subtitle, desc;
  final Color accentColor;
  const _RoleConfig({
    required this.key,
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.desc,
    required this.accentColor,
  });
}

// ── Gradient button ──
class _GradientButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  const _GradientButton({required this.onPressed, required this.label});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 50,
        decoration: BoxDecoration(
          gradient: onPressed != null
              ? const LinearGradient(colors: [AppTheme.primary, AppTheme.accent])
              : null,
          color: onPressed == null ? Colors.grey[300] : null,
          borderRadius: BorderRadius.circular(12),
          boxShadow: onPressed != null
              ? [const BoxShadow(color: Color(0x446366F1), blurRadius: 16, offset: Offset(0, 6))]
              : [],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: onPressed != null ? Colors.white : Colors.grey[600],
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
