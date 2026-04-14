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
import '../../../../shared/widgets/floating_bottom_nav.dart';

/// MainShell — Provides fixed AppBar + BottomNavigationBar.
/// PH/GS/Guest: 4 tabs (Home, Lịch, Giảng dạy/Học tập, Tôi).
/// STUDENT: 6 tabs (Home, Lịch, Học tập, Tài liệu, AI, Tôi).
class MainShell extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const MainShell({super.key, required this.navigationShell});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  /// Total branches in router: 0=Home, 1=Lịch, 2=Giảng dạy, 3=Docs, 4=AI, 5=Profile
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
        // Chat chỉ có trên web → dẫn tới Profile (có link "Liên hệ hỗ trợ")
        // KHÔNG tự mở trình duyệt — user tự tap link khi cần
        widget.navigationShell.goBranch(_profileBranchIndex, initialLocation: true);
        break;
      case 'INVOICE':
        // Có màn BillingsScreen riêng → dẫn thẳng tới đó
        context.push('/billings');
        break;
      case 'VERIFICATION':
        // Có màn TutorVerificationScreen riêng → dẫn thẳng tới đó
        context.push('/tutor/verify');
        break;
      case 'MATERIAL':
      case 'ASSESSMENT':
      case 'SUBMISSION':
        widget.navigationShell.goBranch(2, initialLocation: true); // Teaching
        break;
      default:
        widget.navigationShell.goBranch(0, initialLocation: true);
    }
  }

  /// Admin tabs: 0=Home, 5=Profile
  static const List<int> _adminBranches = [0, 5];

  /// Non-student tabs: 0=Home, 1=Lịch, 2=Giảng dạy/Học tập, 5=Profile
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

      body: Stack(
        children: [
          // Content area — thêm padding bottom để nav bar không che nội dung
          Padding(
            padding: const EdgeInsets.only(bottom: 80),
            child: widget.navigationShell,
          ),
          // ── Floating Bottom Navigation ──
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: FloatingBottomNav(
              currentIndex: currentVisualIndex,
              onTap: _onTabTapped,
              items: _buildNavItems(),
            ),
          ),
        ],
      ),
    );
  }

  List<FloatingBottomNavItem> _buildNavItems() {
    final role = _userRole;

    if (role == 'ADMIN') {
      return const [
        FloatingBottomNavItem(icon: Icons.dashboard_outlined, activeIcon: Icons.dashboard, label: 'Tổng quan'),
        FloatingBottomNavItem(icon: Icons.person_outline, activeIcon: Icons.person, label: 'Tôi'),
      ];
    }

    // Label thay đổi theo role: GS → "Giảng dạy", HS/PH → "Học tập"
    final teachingLabel = role == 'TUTOR' ? 'Giảng dạy' : 'Học tập';

    final items = <FloatingBottomNavItem>[
      const FloatingBottomNavItem(icon: Icons.home_outlined, activeIcon: Icons.home, label: 'Home'),
      const FloatingBottomNavItem(icon: Icons.calendar_month_outlined, activeIcon: Icons.calendar_month, label: 'Lịch'),
      FloatingBottomNavItem(icon: Icons.school_outlined, activeIcon: Icons.school_rounded, label: teachingLabel),
    ];

    if (role == 'STUDENT') {
      items.addAll(const [
        FloatingBottomNavItem(icon: Icons.menu_book_outlined, activeIcon: Icons.menu_book_rounded, label: 'Tài liệu'),
        FloatingBottomNavItem(icon: Icons.smart_toy_outlined, activeIcon: Icons.smart_toy_rounded, label: 'AI'),
      ]);
    }

    items.add(const FloatingBottomNavItem(icon: Icons.person_outline, activeIcon: Icons.person, label: 'Tôi'));
    return items;
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
