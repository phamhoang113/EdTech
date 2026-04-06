import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/services/web_launcher_service.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../widgets/open_classes_section.dart';
import '../widgets/featured_tutors_section.dart';
import '../../domain/entities/my_class_entity.dart';
import '../bloc/my_classes_bloc.dart';
import '../bloc/my_classes_event.dart';
import '../bloc/my_classes_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          final role = state.user.role;
          if (role == 'TUTOR') return const _TutorHome();
          return const _ParentStudentHome();
        }
        return const _GuestHome();
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════
// GUEST HOME
// ═══════════════════════════════════════════════════════════
class _GuestHome extends StatelessWidget {
  const _GuestHome();

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 16),
          OpenClassesSection(),
          SizedBox(height: 32),
          FeaturedTutorsSection(),
          SizedBox(height: 40),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// PARENT / STUDENT HOME — uses MyClassesBloc
// ═══════════════════════════════════════════════════════════
class _ParentStudentHome extends StatelessWidget {
  const _ParentStudentHome();

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    final role = (authState is AuthAuthenticated) ? authState.user.role : 'PARENT';

    return BlocProvider(
      create: (_) => getIt<MyClassesBloc>()..add(LoadMyClassesRequested(role)),
      child: _ParentStudentContent(role: role),
    );
  }
}

class _ParentStudentContent extends StatelessWidget {
  final String role;

  const _ParentStudentContent({required this.role});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = (context.read<AuthBloc>().state as AuthAuthenticated).user;
    final name = user.name ?? 'bạn';
    final hour = DateTime.now().hour;
    final greeting = hour < 12 ? 'Chào buổi sáng' : hour < 18 ? 'Chào buổi chiều' : 'Chào buổi tối';
    final webLauncher = getIt<WebLauncherService>();

    return RefreshIndicator(
      onRefresh: () async {
        context.read<MyClassesBloc>().add(LoadMyClassesRequested(role));
      },
      child: ListView(
        padding: const EdgeInsets.only(top: 16, bottom: 80),
        children: [
          // ── Greeting ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$greeting 👋',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        name,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6366F1).withAlpha(20),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    user.role == 'PARENT' ? '👨‍👩‍👧 Phụ huynh' : '📚 Học sinh',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // ── Quick Actions ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _StatMini(
                  icon: Icons.add_circle_outline,
                  label: 'Tạo lớp',
                  color: const Color(0xFF6366F1),
                  onTap: () => context.push('/request-class'),
                ),
                const SizedBox(width: 12),
                _StatMini(
                  icon: Icons.calendar_today,
                  label: 'Lịch học',
                  color: const Color(0xFF10B981),
                  onTap: () => GoRouter.of(context).go('/schedule'),
                ),
                const SizedBox(width: 12),
                _StatMini(
                  icon: Icons.payment,
                  label: 'Thanh toán',
                  color: const Color(0xFFF59E0B),
                  onTap: () => webLauncher.openWithToken(
                    user.role == 'PARENT' ? '/parent/payment' : '/student/payment',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ── CTA: Đăng ký lớp ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _CtaCard(
              icon: Icons.add_circle_outline,
              title: 'Đăng ký lớp mới',
              subtitle: 'Tìm gia sư phù hợp cho bạn',
              gradient: const [Color(0xFF6366F1), Color(0xFF8B5CF6)],
              onTap: () => context.push('/request-class'),
            ),
          ),
          const SizedBox(height: 24),

          // ── Lớp học của tôi (BLoC) ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '📋 Lớp học của tôi',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                BlocBuilder<MyClassesBloc, MyClassesState>(
                  builder: (context, state) {
                    if (state is MyClassesLoading || state is MyClassesInitial) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(24),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    if (state is MyClassesError) {
                      return _buildEmptyClassState(theme);
                    }
                    if (state is MyClassesLoaded) {
                      if (state.classes.isEmpty) return _buildEmptyClassState(theme);
                      return Column(
                        children: state.classes
                            .take(5)
                            .map((cls) => _MyClassCard(
                                  classItem: cls,
                                  webLauncher: webLauncher,
                                ))
                            .toList(),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyClassState(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withAlpha(60),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.colorScheme.outline.withAlpha(40)),
      ),
      child: Column(
        children: [
          Icon(Icons.school_outlined, size: 40, color: theme.colorScheme.onSurfaceVariant.withAlpha(120)),
          const SizedBox(height: 8),
          Text('Chưa có lớp nào', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          const SizedBox(height: 4),
          Text('Nhấn "Đăng ký lớp mới" để bắt đầu', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant.withAlpha(150))),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// MY CLASS CARD (typed entity instead of Map<String, dynamic>)
// ═══════════════════════════════════════════════════════════
class _MyClassCard extends StatelessWidget {
  final MyClassEntity classItem;
  final WebLauncherService webLauncher;

  const _MyClassCard({required this.classItem, required this.webLauncher});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusLabel = _resolveStatusLabel(classItem.status);
    final statusColor = _resolveStatusColor(classItem.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline.withAlpha(60)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withAlpha(20),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  classItem.classCode ?? '',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: theme.colorScheme.primary),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor.withAlpha(20),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(statusLabel, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: statusColor)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(classItem.title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(
            '${classItem.subject} • ${classItem.grade}',
            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
          if (classItem.pendingApplicationCount > 0) ...[
            const SizedBox(height: 8),
            InkWell(
              onTap: () => webLauncher.openWithToken('/parent/classes/${classItem.id}/applicants'),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B).withAlpha(15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFF59E0B).withAlpha(40)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.person_search, size: 15, color: Color(0xFFF59E0B)),
                    const SizedBox(width: 6),
                    Text(
                      '${classItem.pendingApplicationCount} gia sư ứng tuyển →',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFFF59E0B)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _resolveStatusLabel(String status) {
    switch (status) {
      case 'PENDING_APPROVAL': return '⏳ Chờ duyệt';
      case 'OPEN': return '🟢 Đang mở';
      case 'ASSIGNED': return '✅ Đã có GS';
      case 'ACTIVE': return '📚 Đang học';
      case 'COMPLETED': return '🏆 Hoàn thành';
      case 'REJECTED': return '❌ Từ chối';
      default: return status;
    }
  }

  Color _resolveStatusColor(String status) {
    switch (status) {
      case 'PENDING_APPROVAL': return const Color(0xFFF59E0B);
      case 'OPEN': return const Color(0xFF6366F1);
      case 'ASSIGNED': case 'ACTIVE': return const Color(0xFF10B981);
      case 'COMPLETED': return const Color(0xFF6B7280);
      case 'REJECTED': return const Color(0xFFEF4444);
      default: return const Color(0xFF6B7280);
    }
  }
}

// ═══════════════════════════════════════════════════════════
// TUTOR HOME
// ═══════════════════════════════════════════════════════════
class _TutorHome extends StatelessWidget {
  const _TutorHome();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = (context.read<AuthBloc>().state as AuthAuthenticated).user;
    final name = user.name ?? 'Gia sư';
    final hour = DateTime.now().hour;
    final greeting = hour < 12 ? 'Chào buổi sáng' : hour < 18 ? 'Chào buổi chiều' : 'Chào buổi tối';
    final webLauncher = getIt<WebLauncherService>();

    return ListView(
      padding: const EdgeInsets.only(top: 16, bottom: 80),
      children: [
        // ── Greeting ──
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$greeting 👋',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      name,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6).withAlpha(20),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '🎓 Gia sư',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // ── Quick Stats ──
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              _StatMini(
                icon: Icons.calendar_today,
                label: 'Lịch dạy',
                color: const Color(0xFF6366F1),
                onTap: () => GoRouter.of(context).go('/schedule'),
              ),
              const SizedBox(width: 12),
              _StatMini(
                icon: Icons.monetization_on_outlined,
                label: 'Thu nhập',
                color: const Color(0xFF10B981),
                onTap: () => webLauncher.openWithToken('/tutor/revenue'),
              ),
              const SizedBox(width: 12),
              _StatMini(
                icon: Icons.dashboard_outlined,
                label: 'Dashboard',
                color: const Color(0xFFF59E0B),
                onTap: () => webLauncher.openWithToken('/tutor/dashboard'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // ── Lớp mới phù hợp ──
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '⚡ Lớp mới phù hợp với bạn',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 8),
        const OpenClassesSection(),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════
// SHARED WIDGETS
// ═══════════════════════════════════════════════════════════

/// Card CTA nổi bật với gradient
class _CtaCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<Color> gradient;
  final VoidCallback onTap;

  const _CtaCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: gradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(50),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.white, size: 26),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 2),
                    Text(subtitle, style: TextStyle(color: Colors.white.withAlpha(200), fontSize: 13)),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.white.withAlpha(150), size: 18),
            ],
          ),
        ),
      ),
    );
  }
}

/// Mini stat shortcut card
class _StatMini extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _StatMini({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: color.withAlpha(15),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: color.withAlpha(40)),
            ),
            child: Column(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(height: 6),
                Text(
                  label,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
