import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/screens/login_sheet.dart';
import '../features/auth/presentation/screens/register_role_screen.dart';
import '../features/auth/presentation/screens/register_form_screen.dart';
import '../features/auth/presentation/screens/otp_verify_screen.dart';
import '../features/auth/presentation/screens/dashboard_screen.dart';
import '../features/home/presentation/screens/home_screen.dart';
import '../features/home/presentation/screens/main_shell.dart';
import '../features/classes/presentation/screens/class_list_screen.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/auth/presentation/bloc/auth_state.dart';
import '../features/tutor_profile/presentation/screens/tutor_verification_screen.dart';
import '../features/auth/presentation/screens/change_password_screen.dart';
import '../features/auth/presentation/screens/forgot_password_screen.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _homeNavKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final GlobalKey<NavigatorState> _classesNavKey = GlobalKey<NavigatorState>(debugLabel: 'classes');
final GlobalKey<NavigatorState> _dashboardNavKey = GlobalKey<NavigatorState>(debugLabel: 'dashboard');

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/home',
  routes: [
    // ── Main Shell with Bottom Navigation ──
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
        // Tab 1: Class List
        StatefulShellBranch(
          navigatorKey: _classesNavKey,
          routes: [
            GoRoute(
              path: '/classes',
              builder: (context, state) => const ClassListScreen(),
            ),
          ],
        ),
        // Tab 2: Dashboard
        StatefulShellBranch(
          navigatorKey: _dashboardNavKey,
          routes: [
            GoRoute(
              path: '/dashboard',
              builder: (context, state) => const DashboardScreen(),
            ),
          ],
        ),
      ],
    ),

    // ── Non-shell routes (full screen, no bottom nav) ──
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
      path: '/verify-otp',
      builder: (context, state) {
        final extra = state.extra as Map<String, String>? ?? {};
        return OtpVerifyScreen(
          phone:    extra['phone']    ?? '',
          otpToken: extra['otpToken'] ?? '',
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
