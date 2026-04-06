import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme_cubit.dart';
import '../../../../app/router.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/di/tutor_verification_notifier.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';

/// MainShell — Provides fixed AppBar + BottomNavigationBar.
/// 4 tabs: Trang chủ, Lịch, Blog, Tôi.
class MainShell extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const MainShell({super.key, required this.navigationShell});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  /// Profile tab index (last tab)
  static const int _profileTabIndex = 3;
  /// Schedule tab index
  static const int _scheduleTabIndex = 1;

  void _onTabTapped(int index) {
    // Schedule & Profile tabs require login
    if (index == _scheduleTabIndex || index == _profileTabIndex) {
      final authState = context.read<AuthBloc>().state;
      if (authState is! AuthAuthenticated) {
        showAuthGuard(context, onSuccess: () {
          widget.navigationShell.goBranch(
            index,
            initialLocation: index == widget.navigationShell.currentIndex,
          );
        });
        return;
      }
    }

    // Block navigation for UNVERIFIED tutors
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated &&
        authState.user.role == 'TUTOR' &&
        index != _profileTabIndex) {
      final notifier = getIt<TutorVerificationNotifier>();
      if (notifier.isBlocked) {
        if (widget.navigationShell.currentIndex == _profileTabIndex) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Vui lòng hoàn thành xác thực hồ sơ trước.'),
              duration: Duration(seconds: 2),
            ),
          );
          return;
        }
        widget.navigationShell.goBranch(_profileTabIndex, initialLocation: true);
        return;
      }
    }

    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final currentIndex = widget.navigationShell.currentIndex;

    // Ẩn AppBar khi ở tab "Tôi" (Profile tự quản lý header)
    final isProfileTab = currentIndex == _profileTabIndex;

    return Scaffold(
      appBar: isProfileTab
          ? null
          : AppBar(
              title: Image.asset(
                'assets/logo.webp',
                height: 36,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
              ),
              actions: [
                // Theme toggle
                IconButton(
                  icon: BlocBuilder<ThemeCubit, ThemeMode>(
                    builder: (context, themeMode) {
                      final dark = themeMode == ThemeMode.dark ||
                          (themeMode == ThemeMode.system &&
                              MediaQuery.of(context).platformBrightness == Brightness.dark);
                      return Icon(dark ? Icons.light_mode : Icons.dark_mode_outlined);
                    },
                  ),
                  onPressed: () => context.read<ThemeCubit>().toggleTheme(),
                ),
                // Notification bell
                IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () {
                    // TODO: Navigate to notifications
                  },
                ),
                const SizedBox(width: 4),
              ],
            ),

      body: widget.navigationShell,

      // ── Bottom Navigation Bar — 4 tabs ──
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: _onTabTapped,
        backgroundColor: theme.colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        indicatorColor: theme.colorScheme.primary.withAlpha(30),
        elevation: 3,
        shadowColor: isDark ? Colors.black54 : Colors.black12,
        height: 64,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: 'Lịch',
          ),
          NavigationDestination(
            icon: Icon(Icons.article_outlined),
            selectedIcon: Icon(Icons.article_rounded),
            label: 'Blog',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Tôi',
          ),
        ],
      ),
    );
  }
}
