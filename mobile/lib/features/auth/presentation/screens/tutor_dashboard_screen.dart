import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme.dart';
import '../../../../app/theme_cubit.dart';
import '../../../../core/di/injection.dart';
import '../../../tutor_profile/domain/entities/tutor_class_entity.dart';
import '../../../tutor_profile/domain/entities/tutor_session_entity.dart';
import '../../../tutor_profile/presentation/bloc/tutor_profile_bloc.dart';
import '../../../tutor_profile/presentation/bloc/tutor_profile_event.dart';
import '../../../tutor_profile/presentation/bloc/tutor_profile_state.dart';
import '../../../tutor_profile/presentation/screens/tutor_verification_screen.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/dash_stat_card.dart';
import '../widgets/dash_section_header.dart';

/// Tutor Dashboard — Drawer navigation (synced with web TutorSidebar).
/// Real API data: profile + classes + sessions.
class TutorDashboardScreen extends StatefulWidget {
  const TutorDashboardScreen({super.key});

  @override
  State<TutorDashboardScreen> createState() => _TutorDashboardScreenState();
}

class _TutorDashboardScreenState extends State<TutorDashboardScreen> {
  int _currentIndex = 0;
  late final TutorProfileBloc _dashBloc;

  @override
  void initState() {
    super.initState();
    _dashBloc = getIt<TutorProfileBloc>()..add(LoadTutorDashboard());
  }

  @override
  void dispose() {
    _dashBloc.close();
    super.dispose();
  }

  static const _drawerItems = <_DrawerItem>[
    _DrawerItem(icon: Icons.dashboard_outlined, label: 'Tổng quan', section: 'Dạy học'),
    _DrawerItem(icon: Icons.menu_book_outlined, label: 'Lớp học', section: 'Dạy học'),
    _DrawerItem(icon: Icons.calendar_month_outlined, label: 'Lịch dạy', section: 'Dạy học'),
    _DrawerItem(icon: Icons.chat_bubble_outline, label: 'Tin nhắn', section: 'Dạy học'),
    _DrawerItem(icon: Icons.person_outline, label: 'Hồ sơ gia sư', section: 'Hồ sơ & Tài chính'),
    _DrawerItem(icon: Icons.bar_chart_outlined, label: 'Doanh thu', section: 'Hồ sơ & Tài chính'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider.value(
      value: _dashBloc,
      child: BlocListener<AuthBloc, AuthState>(
        listener: (ctx, state) {
          if (state is! AuthAuthenticated) ctx.go('/home');
        },
        child: BlocBuilder<TutorProfileBloc, TutorProfileState>(
          builder: (context, profileState) {
            final isUnverified = profileState is TutorDashboardLoaded && profileState.isUnverified;
            final appBarTitle = isUnverified ? 'Xác thực hồ sơ' : _drawerItems[_currentIndex].label;

            return Scaffold(
              appBar: AppBar(
                title: Text(appBarTitle),
                leading: isUnverified
                    ? null
                    : Builder(
                        builder: (ctx) => IconButton(
                          icon: const Icon(Icons.menu),
                          onPressed: () => Scaffold.of(ctx).openDrawer(),
                        ),
                      ),
                actions: [
                  BlocBuilder<ThemeCubit, ThemeMode>(
                    builder: (ctx, themeMode) {
                      final dark = themeMode == ThemeMode.dark ||
                          (themeMode == ThemeMode.system &&
                              MediaQuery.of(ctx).platformBrightness == Brightness.dark);
                      return IconButton(
                        icon: Icon(
                          dark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                          size: 20,
                        ),
                        onPressed: () => ctx.read<ThemeCubit>().toggleTheme(),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined, size: 20),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 4),
                ],
              ),
              drawer: isUnverified ? null : _buildDrawer(theme),
              body: isUnverified
                  ? const TutorVerificationScreen()
                  : IndexedStack(
                      index: _currentIndex,
                      children: [
                        _TutorOverviewTab(dashBloc: _dashBloc),
                        _ComingSoonTab(title: 'Lớp học', icon: Icons.menu_book_outlined),
                        _ComingSoonTab(title: 'Lịch dạy', icon: Icons.calendar_month_outlined),
                        _ComingSoonTab(title: 'Tin nhắn', icon: Icons.chat_bubble_outline),
                        _ComingSoonTab(title: 'Hồ sơ gia sư', icon: Icons.person_outline),
                        _ComingSoonTab(title: 'Doanh thu', icon: Icons.bar_chart_outlined),
                      ],
                    ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDrawer(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // Logo header
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: Image.asset(
                'assets/logo.webp',
                height: 40,
                errorBuilder: (_, __, ___) => Text(
                  'Gia Sư Tinh Hoa',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const Divider(height: 1),

            // Menu items grouped by section
            Expanded(child: _buildDrawerItems(theme, isDark)),

            // Logout
            const Divider(height: 1),
            ListTile(
              leading: Icon(Icons.logout, color: theme.colorScheme.error, size: 20),
              title: Text('Đăng xuất', style: TextStyle(color: theme.colorScheme.error)),
              onTap: () {
                Navigator.pop(context);
                context.read<AuthBloc>().add(AuthLogoutRequested());
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItems(ThemeData theme, bool isDark) {
    final widgets = <Widget>[];
    String? lastSection;

    for (int i = 0; i < _drawerItems.length; i++) {
      final item = _drawerItems[i];

      // Section header
      if (item.section != lastSection) {
        lastSection = item.section;
        widgets.add(Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
          child: Text(
            item.section,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ));
      }

      final isActive = _currentIndex == i;
      widgets.add(
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: isActive ? theme.colorScheme.primary.withAlpha(20) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            dense: true,
            leading: Icon(
              item.icon,
              size: 20,
              color: isActive ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
            ),
            title: Text(
              item.label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive ? theme.colorScheme.primary : theme.colorScheme.onSurface,
              ),
            ),
            onTap: () {
              setState(() => _currentIndex = i);
              Navigator.pop(context);
            },
          ),
        ),
      );
    }

    return ListView(children: widgets);
  }
}

/// ── Drawer Item Data ──
class _DrawerItem {
  final IconData icon;
  final String label;
  final String section;

  const _DrawerItem({required this.icon, required this.label, required this.section});
}

/// ── OVERVIEW TAB (Real API Data) ──
class _TutorOverviewTab extends StatelessWidget {
  final TutorProfileBloc dashBloc;

  const _TutorOverviewTab({required this.dashBloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TutorProfileBloc, TutorProfileState>(
      bloc: dashBloc,
      builder: (context, state) {
        if (state is TutorProfileLoading || state is TutorProfileInitial) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is TutorProfileError) {
          return _ErrorView(message: state.message, onRetry: () => dashBloc.add(LoadTutorDashboard()));
        }
        if (state is TutorDashboardLoaded) {
          return _OverviewContent(data: state);
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _OverviewContent extends StatelessWidget {
  final TutorDashboardLoaded data;

  const _OverviewContent({required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return RefreshIndicator(
      onRefresh: () async {
        context.read<TutorProfileBloc>().add(LoadTutorDashboard());
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Greeting
          _GreetingBanner(isDark: isDark),
          const SizedBox(height: 12),

          // Verification warning
          if (data.isUnverified) _VerificationBanner(status: 'UNVERIFIED', theme: theme),
          if (data.isPending) _VerificationBanner(status: 'PENDING', theme: theme),
          if (data.isUnverified || data.isPending) const SizedBox(height: 12),

          // Stats
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.8,
            children: [
              DashStatCard(
                value: '${data.classes.length}',
                label: 'Lớp đang dạy',
                emoji: '📚',
                accent: AppTheme.primary,
              ),
              DashStatCard(
                value: '${data.upcomingSessions.length}',
                label: 'Buổi sắp tới',
                emoji: '📅',
                accent: AppTheme.accent,
              ),
              DashStatCard(
                value: data.profile.rating > 0 ? '${data.profile.rating.toStringAsFixed(1)} ★' : '— ★',
                label: 'Đánh giá',
                emoji: '⭐',
                accent: const Color(0xFFF59E0B),
              ),
              DashStatCard(
                value: _formatCurrency(data.totalRevenue),
                label: 'Thù lao/tháng',
                emoji: '💰',
                accent: const Color(0xFF10B981),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Upcoming sessions
          DashSectionHeader(title: '📅 Lịch dạy sắp tới', onTap: () {}),
          const SizedBox(height: 10),
          if (data.upcomingSessions.isEmpty)
            _EmptyHint(text: 'Không có buổi dạy nào sắp tới.', isDark: isDark)
          else
            ...data.upcomingSessions.map((s) => _SessionItem(session: s, isDark: isDark)),

          const SizedBox(height: 20),

          // My classes
          DashSectionHeader(title: '📚 Lớp học', onTap: () {}),
          const SizedBox(height: 10),
          if (data.classes.isEmpty)
            _EmptyHint(text: 'Chưa có lớp nào được phân công.', isDark: isDark)
          else
            ...data.classes.take(4).map((c) => _ClassItem(cls: c, isDark: isDark)),

          const SizedBox(height: 20),

          // Quick actions
          DashSectionHeader(title: '⚡ Thao tác nhanh', onTap: null),
          const SizedBox(height: 10),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 2.4,
            children: [
              _QuickAction(emoji: '📅', label: 'Lịch dạy', onTap: () {}),
              _QuickAction(emoji: '📚', label: 'Lớp học', onTap: () {}),
              _QuickAction(
                emoji: '🔎',
                label: 'Tìm lớp mới',
                onTap: () => context.go('/classes'),
              ),
              _QuickAction(emoji: '📊', label: 'Thống kê', onTap: () {}),
            ],
          ),
        ],
      ),
    );
  }

  String _formatCurrency(num n) {
    if (n == 0) return '0';
    if (n >= 1000000) {
      final m = n / 1000000;
      return '${m.toStringAsFixed(m == m.truncate() ? 0 : 1)}M';
    }
    if (n >= 1000) {
      final k = n / 1000;
      return '${k.toStringAsFixed(k == k.truncate() ? 0 : 1)}K';
    }
    return n.toString();
  }
}

/// ── Greeting Banner ──
class _GreetingBanner extends StatelessWidget {
  final bool isDark;

  const _GreetingBanner({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final name = authState is AuthAuthenticated ? (authState.user.name ?? 'Gia sư') : 'Gia sư';

    final h = DateTime.now().hour;
    final greeting = h < 12 ? 'Chào buổi sáng 👋' : h < 18 ? 'Chào buổi chiều 👋' : 'Chào buổi tối 👋';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4F46E5), Color(0xFF7C3AED), Color(0xFFA21CAF)],
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: AppTheme.primary.withAlpha(80), blurRadius: 18, offset: const Offset(0, 6)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(greeting, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 4),
                Text(name, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(999)),
                  child: const Text('👩‍🏫 Gia sư', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
          const Text('📖', style: TextStyle(fontSize: 44)),
        ],
      ),
    );
  }
}

/// ── Verification Banner ──
class _VerificationBanner extends StatelessWidget {
  final String status;
  final ThemeData theme;

  const _VerificationBanner({required this.status, required this.theme});

  @override
  Widget build(BuildContext context) {
    final isUnverified = status == 'UNVERIFIED';
    final bgColor = isUnverified ? const Color(0xFFDC2626).withAlpha(20) : const Color(0xFFEAB308).withAlpha(20);
    final textColor = isUnverified ? const Color(0xFFDC2626) : const Color(0xFFCA8A04);
    final icon = isUnverified ? Icons.warning_amber_rounded : Icons.hourglass_top;
    final title = isUnverified ? 'Chưa xác thực hồ sơ!' : 'Hồ sơ đang chờ duyệt!';
    final desc = isUnverified
        ? 'Vui lòng xác thực để bắt đầu nhận lớp.'
        : 'Bạn đã gửi thông tin, vui lòng chờ phê duyệt.';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: textColor, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.w700, color: textColor, fontSize: 13)),
                const SizedBox(height: 2),
                Text(desc, style: TextStyle(color: textColor, fontSize: 12)),
              ],
            ),
          ),
          if (isUnverified)
            TextButton(
              onPressed: () => context.push('/tutor/verify'),
              child: const Text('Xác thực', style: TextStyle(fontWeight: FontWeight.w700)),
            ),
        ],
      ),
    );
  }
}

/// ── Session Item ──
class _SessionItem extends StatelessWidget {
  final TutorSessionEntity session;
  final bool isDark;

  const _SessionItem({required this.session, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.surface : Colors.white,
        border: Border.all(color: isDark ? Colors.white12 : Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Text('📚', style: TextStyle(fontSize: 22)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(session.classTitle, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                Text(session.subject, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.primary.withAlpha(25),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.access_time, size: 12, color: AppTheme.primary),
                const SizedBox(width: 3),
                Text(
                  _formatTime(),
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppTheme.primary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime() {
    final date = DateTime.tryParse(session.sessionDate);
    if (date == null) return session.startTime;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final sessionDay = DateTime(date.year, date.month, date.day);
    final time = session.startTime.length >= 5 ? session.startTime.substring(0, 5) : session.startTime;

    if (sessionDay == today) return 'Hôm nay, $time';
    if (sessionDay == tomorrow) return 'Ngày mai, $time';

    const dayNames = ['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'];
    return '${dayNames[date.weekday % 7]}, $time';
  }
}

/// ── Class Item ──
class _ClassItem extends StatelessWidget {
  final TutorClassEntity cls;
  final bool isDark;

  const _ClassItem({required this.cls, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.surface : Colors.white,
        border: Border.all(color: isDark ? Colors.white12 : Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Subject initials badge
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)]),
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Text(
              cls.subject.length >= 2 ? cls.subject.substring(0, 2).toUpperCase() : cls.subject.toUpperCase(),
              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(cls.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                Text('${cls.subject} • ${cls.grade}', style: TextStyle(fontSize: 11, color: Colors.grey[500])),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withAlpha(20),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.people_outline, size: 12, color: Color(0xFF10B981)),
                const SizedBox(width: 3),
                Text(
                  '${cls.sessionsPerWeek} buổi/tuần',
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF10B981)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// ── Quick Action ──
class _QuickAction extends StatelessWidget {
  final String emoji;
  final String label;
  final VoidCallback onTap;

  const _QuickAction({required this.emoji, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.surface : Colors.white,
          border: Border.all(color: isDark ? Colors.white12 : Colors.grey.shade200),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
            Expanded(child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
            const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

/// ── Empty Hint ──
class _EmptyHint extends StatelessWidget {
  final String text;
  final bool isDark;

  const _EmptyHint({required this.text, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(text, style: TextStyle(fontSize: 13, color: Colors.grey[500])),
    );
  }
}

/// ── Coming Soon Tab ──
class _ComingSoonTab extends StatelessWidget {
  final String title;
  final IconData icon;

  const _ComingSoonTab({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withAlpha(20),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 36, color: theme.colorScheme.primary),
          ),
          const SizedBox(height: 16),
          Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withAlpha(20),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: theme.colorScheme.primary.withAlpha(60)),
            ),
            child: Text(
              '🚧 Đang phát triển',
              style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

/// ── Error View ──
class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 48, color: Theme.of(context).colorScheme.error),
          const SizedBox(height: 8),
          Text(message),
          const SizedBox(height: 16),
          OutlinedButton(onPressed: onRetry, child: const Text('Thử lại')),
        ],
      ),
    );
  }
}
