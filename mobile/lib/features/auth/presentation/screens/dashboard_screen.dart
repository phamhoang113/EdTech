import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';
import 'student_dashboard_screen.dart';
import 'tutor_dashboard_screen.dart';

/// DashboardScreen — dispatcher theo role (legacy, không dùng trong MainShell).
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is! AuthAuthenticated) {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => context.go('/home'),
          );
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        switch (state.user.role) {
          case 'TUTOR':
            return const TutorDashboardScreen();
          case 'STUDENT':
            return const StudentDashboardScreen();
          case 'PARENT':
          default:
            // PH giờ dùng HomeScreen qua MainShell
            return const Scaffold(
              body: Center(child: Text('Chuyển hướng...')),
            );
        }
      },
    );
  }
}
