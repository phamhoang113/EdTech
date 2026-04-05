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
/// 6 tabs: Home, Lớp học, Blog, Tài liệu, AI, Dashboard (icon only).
class MainShell extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const MainShell({super.key, required this.navigationShell});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  /// Dashboard index (last tab)
  static const int _dashboardTabIndex = 5;

  void _onTabTapped(int index) {
    if (index == _dashboardTabIndex) {
      // Dashboard tab — guard with auth
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

    // Block navigation for UNVERIFIED tutors — force them to complete verification
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated &&
        authState.user.role == 'TUTOR' &&
        index != _dashboardTabIndex) {
      final notifier = getIt<TutorVerificationNotifier>();
      if (notifier.isBlocked) {
        // Already on dashboard → just show message
        if (widget.navigationShell.currentIndex == _dashboardTabIndex) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Vui lòng hoàn thành xác thực hồ sơ trước khi sử dụng tính năng khác.'),
              duration: Duration(seconds: 2),
            ),
          );
          return;
        }
        // Not on dashboard → navigate to dashboard
        widget.navigationShell.goBranch(_dashboardTabIndex, initialLocation: true);
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

    final isDashboard = currentIndex == _dashboardTabIndex;

    return Scaffold(
      // ── AppBar hidden on Dashboard tab (Dashboard has its own AppBar + Drawer) ──
      appBar: isDashboard
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

      // ── Body — current tab ──
      body: widget.navigationShell,

      // ── Bottom Navigation Bar — 6 tabs, icon only ──
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: _onTabTapped,
        backgroundColor: theme.colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        indicatorColor: theme.colorScheme.primary.withAlpha(30),
        elevation: 3,
        shadowColor: isDark ? Colors.black54 : Colors.black12,
        height: 60,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.class_outlined),
            selectedIcon: Icon(Icons.class_),
            label: 'Lớp học',
          ),
          NavigationDestination(
            icon: Icon(Icons.article_outlined),
            selectedIcon: Icon(Icons.article_rounded),
            label: 'Blog',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book_rounded),
            label: 'Tài liệu',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_awesome_outlined),
            selectedIcon: Icon(Icons.auto_awesome),
            label: 'AI',
          ),
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
        ],
      ),
    );
  }
}
