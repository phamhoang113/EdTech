import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme_cubit.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/services/web_launcher_service.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';

/// Tab "Tôi" — Profile + Settings + Links web.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _avatarBase64;

  @override
  void initState() {
    super.initState();
    _loadAvatar();
  }

  Future<void> _loadAvatar() async {
    try {
      final dio = getIt<DioClient>().dio;
      final response = await dio.get('/api/v1/users/profile/me');
      final data = response.data['data'] as Map<String, dynamic>? ?? {};
      if (mounted) {
        setState(() => _avatarBase64 = data['avatarBase64']?.toString());
      }
    } catch (_) {
      // Silently fail — avatar just stays as initial
    }
  }

  Future<void> _navigateToEditProfile() async {
    final result = await context.push<bool>('/edit-profile');
    if (result == true) {
      _loadAvatar();
    }
  }

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
            _buildProfileHeader(context, theme, user.name ?? 'Người dùng', role, _avatarBase64),

            const SizedBox(height: 12),

            // ── Edit profile ──
            _buildActionTile(
              context, theme,
              icon: Icons.edit_outlined,
              label: 'Chỉnh sửa hồ sơ',
              onTap: _navigateToEditProfile,
            ),

            const SizedBox(height: 16),

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
              _buildActionTile(
                context, theme,
                icon: Icons.monetization_on_outlined,
                label: 'Chi tiết thu nhập',
                onTap: () => getIt<WebLauncherService>().openWithToken('/tutor/revenue'),
              ),
              _buildActionTile(
                context, theme,
                icon: Icons.bar_chart_outlined,
                label: 'Thống kê giảng dạy',
                onTap: () => getIt<WebLauncherService>().openWithToken('/tutor/dashboard'),
              ),
              const SizedBox(height: 16),
            ],

            if (role == 'ADMIN') ...[
              _buildSectionTitle(theme, '🛡️ Quản trị'),
              _buildActionTile(
                context, theme,
                icon: Icons.verified_user_outlined,
                label: 'Quản lý gia sư',
                onTap: () => getIt<WebLauncherService>().openWithToken('/admin/tutors'),
              ),
              _buildActionTile(
                context, theme,
                icon: Icons.class_outlined,
                label: 'Quản lý lớp học',
                onTap: () => getIt<WebLauncherService>().openWithToken('/admin/classes'),
              ),
              _buildActionTile(
                context, theme,
                icon: Icons.monetization_on_outlined,
                label: 'Quản lý billing',
                onTap: () => getIt<WebLauncherService>().openWithToken('/admin/billing'),
              ),
              _buildActionTile(
                context, theme,
                icon: Icons.people_outline,
                label: 'Quản lý người dùng',
                onTap: () => getIt<WebLauncherService>().openWithToken('/admin/users'),
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
            _buildActionTile(
              context, theme,
              icon: Icons.link_outlined,
              label: 'Liên kết mạng xã hội',
              onTap: () => context.push('/account-linking'),
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

            // ── Version footer (Mockup 10) ──
            const SizedBox(height: 16),
            Center(
              child: Text(
                'v1.0.0',
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.onSurfaceVariant.withAlpha(100),
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
  Widget _buildProfileHeader(BuildContext context, ThemeData theme, String name, String role, String? avatarBase64) {
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
    final hasAvatar = avatarBase64 != null && avatarBase64.contains('base64,');

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            // ── Avatar with gradient ring (Mockup 10) ──
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFF6366F1), Color(0xFF8B5CF6), Color(0xFFA855F7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.25),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(3),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.colorScheme.surface,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: ClipOval(
                      child: hasAvatar
                          ? Image.memory(
                              base64Decode(avatarBase64!.split('base64,').last),
                              fit: BoxFit.cover,
                              width: 88,
                              height: 88,
                            )
                          : Container(
                              width: 88,
                              height: 88,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [color, color.withAlpha(180)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  name.isNotEmpty ? name[0].toUpperCase() : '?',
                                  style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(name, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: color.withAlpha(20),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                roleLabels[role] ?? role,
                style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
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
