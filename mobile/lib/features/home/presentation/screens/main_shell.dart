import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme_cubit.dart';
import '../../../../app/router.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/di/tutor_verification_notifier.dart';
import '../../../../core/services/push_notification_service.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../notification/data/datasources/notification_datasource.dart';
import '../../../notification/presentation/screens/notification_screen.dart';

/// MainShell — Provides fixed AppBar + BottomNavigationBar.
/// PH/GS/Guest: 4 tabs (Home, Lịch, Blog, Tôi).
/// STUDENT: 6 tabs (Home, Lịch, Blog, Tài liệu, AI, Tôi).
class MainShell extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const MainShell({super.key, required this.navigationShell});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  /// Total branches in router: 0=Home, 1=Lịch, 2=Blog, 3=Docs, 4=AI, 5=Profile
  static const int _totalBranches = 6;

  int _unreadCount = 0;
  final _notifDataSource = NotificationDataSource();

  @override
  void initState() {
    super.initState();
    _loadUnreadCount();
    _setupPushCallbacks();
  }

  void _loadUnreadCount() async {
    try {
      final authState = context.read<AuthBloc>().state;
      if (authState is! AuthAuthenticated) return;
      final count = await _notifDataSource.getUnreadCount();
      if (mounted) setState(() => _unreadCount = count);
    } catch (_) {}
  }

  void _setupPushCallbacks() {
    final pushService = PushNotificationService.instance;

    // Refresh badge when new notification arrives
    pushService.onNotificationReceived = () => _loadUnreadCount();

    // Navigate to correct screen when user taps notification
    pushService.onNotificationTap = (entityType, entityId) {
      if (!mounted) return;
      _navigateByEntityType(entityType);
    };
  }

  void _navigateByEntityType(String entityType) {
    final role = _userRole;
    switch (entityType) {
      case 'CLASS':
      case 'APPLICATION':
        widget.navigationShell.goBranch(0, initialLocation: true); // Home
        break;
      case 'SESSION':
      case 'ABSENCE':
        if (role != 'ADMIN') {
          widget.navigationShell.goBranch(1, initialLocation: true); // Schedule
        }
        break;
      case 'CONVERSATION':
        // Navigate to messages — go to home and push messages route
        context.push('/messages');
        break;
      case 'INVOICE':
      case 'VERIFICATION':
        widget.navigationShell.goBranch(_profileBranchIndex, initialLocation: true);
        break;
      default:
        widget.navigationShell.goBranch(0, initialLocation: true);
    }
  }

  /// Admin tabs: 0=Home, 5=Profile
  static const List<int> _adminBranches = [0, 5];

  /// Non-student tabs: 0=Home, 1=Lịch, 2=Blog, 5=Profile
  static const List<int> _defaultBranches = [0, 1, 2, 5];

  /// Student tabs: all 6
  static const List<int> _studentBranches = [0, 1, 2, 3, 4, 5];

  String? get _userRole {
    final state = context.read<AuthBloc>().state;
    if (state is AuthAuthenticated) return state.user.role;
    return null;
  }

  List<int> get _activeBranches {
    final role = _userRole;
    if (role == 'ADMIN') return _adminBranches;
    if (role == 'STUDENT') return _studentBranches;
    return _defaultBranches;
  }

  /// Map visual tab index → real branch index
  int _visualToReal(int visualIndex) {
    final branches = _activeBranches;
    if (visualIndex < 0 || visualIndex >= branches.length) return 0;
    return branches[visualIndex];
  }

  /// Map real branch index → visual tab index
  int _realToVisual(int realIndex) {
    final branches = _activeBranches;
    final idx = branches.indexOf(realIndex);
    return idx >= 0 ? idx : 0;
  }

  int get _profileBranchIndex => _totalBranches - 1; // always last = 5
  int get _scheduleBranchIndex => 1;

  void _onTabTapped(int visualIndex) {
    final realIndex = _visualToReal(visualIndex);

    // Schedule & Profile require login
    if (realIndex == _scheduleBranchIndex || realIndex == _profileBranchIndex) {
      final authState = context.read<AuthBloc>().state;
      if (authState is! AuthAuthenticated) {
        showAuthGuard(context, onSuccess: () {
          widget.navigationShell.goBranch(
            realIndex,
            initialLocation: realIndex == widget.navigationShell.currentIndex,
          );
        });
        return;
      }
    }

    // Block navigation for UNVERIFIED tutors
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated &&
        authState.user.role == 'TUTOR' &&
        realIndex != _profileBranchIndex) {
      final notifier = getIt<TutorVerificationNotifier>();
      if (notifier.isBlocked) {
        if (widget.navigationShell.currentIndex == _profileBranchIndex) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Vui lòng hoàn thành xác thực hồ sơ trước.'),
              duration: Duration(seconds: 2),
            ),
          );
          return;
        }
        widget.navigationShell.goBranch(_profileBranchIndex, initialLocation: true);
        return;
      }
    }

    widget.navigationShell.goBranch(
      realIndex,
      initialLocation: realIndex == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final currentRealIndex = widget.navigationShell.currentIndex;
    final currentVisualIndex = _realToVisual(currentRealIndex);

    // Ẩn AppBar khi ở tab "Tôi" (Profile tự quản lý header)
    final isProfileTab = currentRealIndex == _profileBranchIndex;

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
                // Notification bell with badge
                _buildNotificationBell(),
                const SizedBox(width: 4),
              ],
            ),

      body: widget.navigationShell,

      // ── Bottom Navigation Bar — role-aware ──
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentVisualIndex,
        onDestinationSelected: _onTabTapped,
        backgroundColor: theme.colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        indicatorColor: theme.colorScheme.primary.withAlpha(30),
        elevation: 3,
        shadowColor: isDark ? Colors.black54 : Colors.black12,
        height: 64,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: _buildDestinations(),
      ),
    );
  }

  List<NavigationDestination> _buildDestinations() {
    final role = _userRole;

    // Admin: only Home + Profile
    if (role == 'ADMIN') {
      return const [
        NavigationDestination(
          icon: Icon(Icons.dashboard_outlined),
          selectedIcon: Icon(Icons.dashboard),
          label: 'Tổng quan',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: 'Tôi',
        ),
      ];
    }

    // Base tabs for non-admin
    final destinations = <NavigationDestination>[
      const NavigationDestination(
        icon: Icon(Icons.home_outlined),
        selectedIcon: Icon(Icons.home),
        label: 'Trang chủ',
      ),
      const NavigationDestination(
        icon: Icon(Icons.calendar_month_outlined),
        selectedIcon: Icon(Icons.calendar_month),
        label: 'Lịch',
      ),
      const NavigationDestination(
        icon: Icon(Icons.article_outlined),
        selectedIcon: Icon(Icons.article_rounded),
        label: 'Blog',
      ),
    ];

    // Student-only tabs
    if (role == 'STUDENT') {
      destinations.addAll([
        const NavigationDestination(
          icon: Icon(Icons.menu_book_outlined),
          selectedIcon: Icon(Icons.menu_book_rounded),
          label: 'Tài liệu',
        ),
        const NavigationDestination(
          icon: Icon(Icons.smart_toy_outlined),
          selectedIcon: Icon(Icons.smart_toy_rounded),
          label: 'AI',
        ),
      ]);
    }

    // Profile tab (always last)
    destinations.add(
      const NavigationDestination(
        icon: Icon(Icons.person_outline),
        selectedIcon: Icon(Icons.person),
        label: 'Tôi',
      ),
    );

    return destinations;
  }

  Widget _buildNotificationBell() {
    return Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () async {
            // Check login
            final authState = context.read<AuthBloc>().state;
            if (authState is! AuthAuthenticated) {
              showAuthGuard(context, onSuccess: () {
                _openNotificationScreen();
              });
              return;
            }
            _openNotificationScreen();
          },
        ),
        if (_unreadCount > 0)
          Positioned(
            right: 6,
            top: 6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              decoration: BoxDecoration(
                color: const Color(0xFFEF4444),
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: const BoxConstraints(minWidth: 18, minHeight: 16),
              child: Text(
                _unreadCount > 99 ? '99+' : '$_unreadCount',
                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }

  void _openNotificationScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const NotificationScreen()),
    ).then((_) => _loadUnreadCount()); // Refresh badge on return
  }
}
