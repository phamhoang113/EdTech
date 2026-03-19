import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/screens/login_sheet.dart';
import '../features/auth/presentation/screens/register_role_screen.dart';
import '../features/auth/presentation/screens/register_form_screen.dart';
import '../features/auth/presentation/screens/otp_verify_screen.dart';
import '../features/auth/presentation/screens/dashboard_screen.dart';
import '../features/home/presentation/screens/home_screen.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/auth/presentation/bloc/auth_state.dart';
import '../features/tutor_profile/presentation/screens/tutor_verification_screen.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/home',
  // ── Auth guard redirect ──────────────────────────────────────
  redirect: (context, state) {
    final isAuthenticated = context.read<AuthBloc>().state is AuthAuthenticated;
    final protectedPaths = ['/dashboard'];
    final going = state.uri.path;

    // Chưa đăng nhập → không được vào protected routes
    if (!isAuthenticated && protectedPaths.any((p) => going.startsWith(p))) {
      return '/home';
    }
    // Đã đăng nhập cố vào /home → đi thẳng dashboard
    if (isAuthenticated && going == '/home') {
      return '/dashboard';
    }
    return null;
  },
  routes: [
    /* ── Public ── */
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
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
      path: '/verify-otp',
      builder: (context, state) {
        final extra = state.extra as Map<String, String>? ?? {};
        return OtpVerifyScreen(
          phone:    extra['phone']    ?? '',
          otpToken: extra['otpToken'] ?? '',
        );
      },
    ),

    /* ── Protected ── */
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardScreen(),
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
