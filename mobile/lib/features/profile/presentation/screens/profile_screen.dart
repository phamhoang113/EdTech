import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme_cubit.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/services/web_launcher_service.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';

/// Tab "Tôi" — Profile + Settings + Links web.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is! AuthAuthenticated) {
          return _buildGuestProfile(context, theme);
        }

        final user = state.user;
        final role = user.role;
        final isParentOrIndependent = role == 'PARENT' || role == 'STUDENT';
        final isTutor = role == 'TUTOR';

        return ListView(
          padding: const EdgeInsets.only(top: 24, bottom: 80),
          children: [
            // ── Avatar + Info ──
            _buildProfileHeader(context, theme, user.name ?? 'Người dùng', role),

            const SizedBox(height: 24),

            // ── Quick Links (role-based, mở web) ──
            if (isParentOrIndependent) ...[
              _buildSectionTitle(theme, '📋 Quản lý'),
              _buildWebLink(
                context, theme,
                icon: Icons.dashboard_outlined,
                label: 'Dashboard chi tiết',
                subtitle: 'Xem thống kê trên web',
                webPath: role == 'PARENT' ? '/parent/dashboard' : '/student/dashboard',
              ),
              _buildWebLink(
                context, theme,
                icon: Icons.payment_outlined,
                label: 'Thanh toán học phí',
                subtitle: 'Xem hóa đơn & thanh toán',
                webPath: role == 'PARENT' ? '/parent/payment' : '/student/payment',
              ),
              if (role == 'PARENT')
                _buildWebLink(
                  context, theme,
                  icon: Icons.child_care_outlined,
                  label: 'Quản lý con',
                  subtitle: 'Thêm / xem thông tin con',
                  webPath: '/parent/children',
                ),
              const SizedBox(height: 16),
            ],

            if (isTutor) ...[
              _buildSectionTitle(theme, '📋 Quản lý'),
              _buildWebLink(
                context, theme,
                icon: Icons.dashboard_outlined,
                label: 'Dashboard chi tiết',
                subtitle: 'Xem thống kê trên web',
                webPath: '/tutor/dashboard',
              ),
              _buildWebLink(
                context, theme,
                icon: Icons.monetization_on_outlined,
                label: 'Thu nhập',
                subtitle: 'Xem chi tiết doanh thu',
                webPath: '/tutor/revenue',
              ),
              const SizedBox(height: 16),
            ],

            // ── Hỗ trợ ──
            _buildSectionTitle(theme, '💬 Hỗ trợ'),
            _buildWebLink(
              context, theme,
              icon: Icons.chat_bubble_outline,
              label: 'Liên hệ hỗ trợ',
              subtitle: 'Nhắn tin với Admin',
              webPath: isTutor ? '/tutor/messages'
                  : (role == 'STUDENT' ? '/student/messages' : '/parent/messages'),
            ),
            const SizedBox(height: 16),

            // ── Cài đặt ──
            _buildSectionTitle(theme, '⚙️ Cài đặt'),
            _buildSettingTile(
              context, theme,
              icon: isDark ? Icons.light_mode : Icons.dark_mode_outlined,
              label: 'Giao diện tối',
              trailing: Switch(
                value: isDark,
                onChanged: (_) => context.read<ThemeCubit>().toggleTheme(),
                activeColor: theme.colorScheme.primary,
              ),
            ),
            _buildActionTile(
              context, theme,
              icon: Icons.lock_outline,
              label: 'Đổi mật khẩu',
              onTap: () => context.push('/change-password'),
            ),

            const SizedBox(height: 24),

            // ── Đăng xuất ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: OutlinedButton.icon(
                onPressed: () {
                  context.read<AuthBloc>().add(AuthLogoutRequested());
                },
                icon: const Icon(Icons.logout, size: 18),
                label: const Text('Đăng xuất'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: theme.colorScheme.error,
                  side: BorderSide(color: theme.colorScheme.error.withAlpha(100)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ── Guest profile (chưa đăng nhập) ──
  Widget _buildGuestProfile(BuildContext context, ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withAlpha(20),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.person_outline, size: 48, color: theme.colorScheme.primary),
            ),
            const SizedBox(height: 24),
            Text(
              'Chưa đăng nhập',
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Đăng nhập để sử dụng đầy đủ tính năng.',
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // ── Profile header ──
  Widget _buildProfileHeader(BuildContext context, ThemeData theme, String name, String role) {
    final roleLabels = {
      'PARENT': 'Phụ huynh',
      'STUDENT': 'Học sinh',
      'TUTOR': 'Gia sư',
      'ADMIN': 'Quản trị viên',
    };

    final roleColors = {
      'PARENT': const Color(0xFF6366F1),
      'STUDENT': const Color(0xFF10B981),
      'TUTOR': const Color(0xFF8B5CF6),
      'ADMIN': const Color(0xFFEF4444),
    };

    final color = roleColors[role] ?? theme.colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color, color.withAlpha(180)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : '?',
                style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: color.withAlpha(20),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    roleLabels[role] ?? role,
                    style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Section title ──
  Widget _buildSectionTitle(ThemeData theme, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Text(title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
    );
  }

  // ── Web link tile ──
  Widget _buildWebLink(
    BuildContext context,
    ThemeData theme, {
    required IconData icon,
    required String label,
    required String subtitle,
    required String webPath,
  }) {
    final webLauncher = getIt<WebLauncherService>();

    return ListTile(
      leading: Icon(icon, color: theme.colorScheme.primary),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant)),
      trailing: Icon(Icons.open_in_new, size: 16, color: theme.colorScheme.onSurfaceVariant),
      onTap: () => webLauncher.openWithToken(webPath),
    );
  }

  // ── Setting tile with trailing widget ──
  Widget _buildSettingTile(
    BuildContext context,
    ThemeData theme, {
    required IconData icon,
    required String label,
    required Widget trailing,
  }) {
    return ListTile(
      leading: Icon(icon, color: theme.colorScheme.primary),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: trailing,
    );
  }

  // ── Action tile ──
  Widget _buildActionTile(
    BuildContext context,
    ThemeData theme, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: theme.colorScheme.primary),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: Icon(Icons.chevron_right, size: 20, color: theme.colorScheme.onSurfaceVariant),
      onTap: onTap,
    );
  }
}
