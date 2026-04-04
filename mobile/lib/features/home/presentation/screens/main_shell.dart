import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme_cubit.dart';
import '../../../../app/router.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';

/// MainShell — Provides fixed AppBar + BottomNavigationBar (like Facebook).
/// Wraps tabs: Home, Classes, Dashboard.
class MainShell extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const MainShell({super.key, required this.navigationShell});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  void _onTabTapped(int index) {
    if (index == 2) {
      // Dashboard tab — guard with auth
      final authState = context.read<AuthBloc>().state;
      if (authState is! AuthAuthenticated) {
        showAuthGuard(context, onSuccess: () {
          widget.navigationShell.goBranch(index, initialLocation: index == widget.navigationShell.currentIndex);
        });
        return;
      }
    }
    widget.navigationShell.goBranch(index, initialLocation: index == widget.navigationShell.currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      // ── Fixed AppBar ──
      appBar: AppBar(
        title: Image.asset(
          'assets/logo.png',
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

      // ── Bottom Navigation Bar ──
      bottomNavigationBar: NavigationBar(
        selectedIndex: widget.navigationShell.currentIndex,
        onDestinationSelected: _onTabTapped,
        backgroundColor: theme.colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        indicatorColor: theme.colorScheme.primary.withAlpha(30),
        elevation: 3,
        shadowColor: isDark ? Colors.black54 : Colors.black12,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          NavigationDestination(
            icon: Icon(Icons.class_outlined),
            selectedIcon: Icon(Icons.class_),
            label: 'Lớp học',
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
