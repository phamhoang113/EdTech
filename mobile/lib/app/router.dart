import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/screens/login_sheet.dart';
import '../features/auth/presentation/screens/register_role_screen.dart';
import '../features/auth/presentation/screens/register_form_screen.dart';
import '../features/auth/presentation/screens/register_otp_screen.dart';


import '../features/home/presentation/screens/home_screen.dart';
import '../features/home/presentation/screens/main_shell.dart';
import '../features/schedule/presentation/screens/schedule_screen.dart';
import '../features/classes/presentation/screens/class_list_screen.dart';
import '../features/classes/presentation/screens/request_class_screen.dart';
import '../features/home/presentation/screens/blog_screen.dart';
import '../features/profile/presentation/screens/profile_screen.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/auth/presentation/bloc/auth_state.dart';
import '../features/tutor_profile/presentation/screens/tutor_verification_screen.dart';
import '../features/auth/presentation/screens/change_password_screen.dart';
import '../features/auth/presentation/screens/forgot_password_screen.dart';
import '../features/classes/presentation/screens/class_detail_screen.dart';
import '../features/classes/domain/entities/open_class_entity.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _homeNavKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final GlobalKey<NavigatorState> _scheduleNavKey = GlobalKey<NavigatorState>(debugLabel: 'schedule');
final GlobalKey<NavigatorState> _blogNavKey = GlobalKey<NavigatorState>(debugLabel: 'blog');
final GlobalKey<NavigatorState> _profileNavKey = GlobalKey<NavigatorState>(debugLabel: 'profile');

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/home',
  routes: [
    // ── Main Shell with Bottom Navigation — 4 tabs ──
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainShell(navigationShell: navigationShell);
      },
      branches: [
        // Tab 0: Home
        StatefulShellBranch(
          navigatorKey: _homeNavKey,
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        // Tab 1: Lịch (schedule)
        StatefulShellBranch(
          navigatorKey: _scheduleNavKey,
          routes: [
            GoRoute(
              path: '/schedule',
              builder: (context, state) => const ScheduleScreen(),
            ),
          ],
        ),
        // Tab 2: Blog
        StatefulShellBranch(
          navigatorKey: _blogNavKey,
          routes: [
            GoRoute(
              path: '/blog',
              builder: (context, state) => const BlogScreen(),
            ),
          ],
        ),
        // Tab 3: Tôi (Profile + Settings)
        StatefulShellBranch(
          navigatorKey: _profileNavKey,
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),

    // ── Non-shell routes (full screen, no bottom nav) ──
    GoRoute(
      path: '/classes',
      builder: (context, state) => Scaffold(
        appBar: AppBar(title: const Text('Tất cả lớp học')),
        body: const ClassListScreen(),
      ),
    ),
    GoRoute(
      path: '/request-class',
      builder: (context, state) => const RequestClassScreen(),
    ),
    GoRoute(
      path: '/class-detail',
      builder: (context, state) {
        final classItem = state.extra as OpenClassEntity;
        return ClassDetailScreen(classItem: classItem);
      },
    ),
    GoRoute(
      path: '/register/role',
      builder: (context, state) => const RegisterRoleScreen(),
    ),
    GoRoute(
      path: '/register-form',
      builder: (context, state) {
        final role = state.uri.queryParameters['role'] ?? 'PARENT';
        return RegisterFormScreen(role: role);
      },
    ),
    GoRoute(
      path: '/register-otp',
      builder: (context, state) {
        final extra = state.extra as Map<String, String>? ?? {};
        return RegisterOtpScreen(
          phone: extra['phone'] ?? '',
          fullName: extra['fullName'] ?? '',
          password: extra['password'] ?? '',
          role: extra['role'] ?? 'PARENT',
        );
      },
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/change-password',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final isForced = extra?['isForced'] as bool? ?? false;
        return ChangePasswordScreen(isForced: isForced);
      },
    ),
    GoRoute(
      path: '/tutor/verify',
      builder: (context, state) => const TutorVerificationScreen(),
    ),
  ],
);

/// Khởi chạy AuthGuard dưới dạng Bottom Sheet
void showAuthGuard(BuildContext context, {required VoidCallback onSuccess}) {
  final authState = context.read<AuthBloc>().state;
  if (authState is AuthAuthenticated) {
    onSuccess();
    return;
  }
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => BlocProvider.value(
      value: context.read<AuthBloc>(),
      child: LoginSheet(onSuccess: onSuccess),
    ),
  );
}
