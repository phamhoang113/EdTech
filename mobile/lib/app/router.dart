import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/screens/login_sheet.dart';
import '../features/auth/presentation/screens/register_role_screen.dart';
import '../features/home/presentation/screens/home_screen.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/auth/presentation/bloc/auth_state.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/home',
  routes: [
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/register/role',
      builder: (context, state) => const RegisterRoleScreen(),
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
    builder: (_) => BlocProvider.value(
      value: context.read<AuthBloc>(),
      child: LoginSheet(onSuccess: onSuccess),
    ),
  );
}
