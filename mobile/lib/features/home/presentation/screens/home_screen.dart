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
import '../../domain/entities/upcoming_session_entity.dart';
import '../../domain/entities/billing_summary_entity.dart';
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
    final greeting = hour < 12
        ? 'Chào buổi sáng'
        : hour < 18
            ? 'Chào buổi chiều'
            : 'Chào buổi tối';

    return RefreshIndicator(
      onRefresh: () async {
        context.read<MyClassesBloc>().add(LoadMyClassesRequested(role));
      },
      child: ListView(
        padding: const EdgeInsets.only(top: 16, bottom: 100),
        children: [
          // ── Greeting ──
          _GreetingHeader(greeting: greeting, name: name, role: role),
          const SizedBox(height: 20),

          // ── CTA: Đăng ký lớp mới (LUÔN HIỆN) ──
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
          const SizedBox(height: 16),

          // ── BLoC-driven sections ──
          BlocBuilder<MyClassesBloc, MyClassesState>(
            builder: (context, state) {
              if (state is MyClassesLoading || state is MyClassesInitial) {
                return const Padding(
                  padding: EdgeInsets.all(40),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (state is MyClassesError) {
                return _buildErrorCard(theme, state.message);
              }
              if (state is MyClassesLoaded) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Alert: GS ứng tuyển (conditional) ──
                    if (state.totalPendingApplicants > 0 && role == 'PARENT')
                      _AlertBanner(
                        icon: Icons.person_search_rounded,
                        color: const Color(0xFFF59E0B),
                        title: '${state.totalPendingApplicants} gia sư ứng tuyển',
                        subtitle: 'Xem và chọn gia sư phù hợp',
                        onTap: () => _showApplicantsSheet(context, state.classes),
                      ),

                    // ── Alert: Hóa đơn chưa TT (conditional, chỉ PH) ──
                    if (state.unpaidBillings.isNotEmpty && role == 'PARENT')
                      _AlertBanner(
                        icon: Icons.receipt_long_rounded,
                        color: const Color(0xFFEF4444),
                        title: '${state.unpaidBillings.length} hóa đơn chưa thanh toán',
                        subtitle: 'Xem chi tiết hóa đơn',
                        onTap: () => _showBillingsSheet(context, state.unpaidBillings),
                      ),

                    // ── Section: Lớp học của tôi (LUÔN CÓ) ──
                    _SectionTitle(icon: '📋', title: 'Lớp học của tôi'),
                    if (state.classes.isEmpty)
                      _buildEmptyState(
                        theme,
                        Icons.school_outlined,
                        'Chưa có lớp nào',
                        'Nhấn "Đăng ký lớp mới" để bắt đầu',
                      )
                    else
                      ...state.classes.take(5).map(
                            (cls) => _MyClassCard(classItem: cls, role: role),
                          ),

                    const SizedBox(height: 20),

                    // ── Section: Lịch học sắp tới (LUÔN CÓ) ──
                    _SectionTitle(icon: '📅', title: 'Lịch học sắp tới'),
                    if (state.upcomingSessions.isEmpty)
                      _buildEmptyState(
                        theme,
                        Icons.calendar_today_outlined,
                        'Chưa có lịch học nào',
                        'Lịch sẽ hiển thị khi lớp bắt đầu hoạt động',
                      )
                    else
                      ...state.upcomingSessions.map(
                            (s) => _UpcomingSessionCard(session: s),
                          ),

                    // ── Section: Học sinh của tôi (CHỈ PH) ──
                    if (role == 'PARENT') ...[
                      const SizedBox(height: 20),
                      _SectionTitle(icon: '👧', title: 'Lịch học theo học sinh'),
                      _StudentScheduleCard(classes: state.classes),
                    ],
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildErrorCard(ThemeData theme, String message) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFEF4444).withAlpha(10),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFEF4444).withAlpha(40)),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: Color(0xFFEF4444)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(message, style: theme.textTheme.bodyMedium),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme, IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withAlpha(60),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: theme.colorScheme.outline.withAlpha(40)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 36, color: theme.colorScheme.onSurfaceVariant.withAlpha(120)),
            const SizedBox(height: 8),
            Text(title, style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            )),
            const SizedBox(height: 4),
            Text(subtitle, style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withAlpha(150),
            )),
          ],
        ),
      ),
    );
  }

  void _showApplicantsSheet(BuildContext context, List<MyClassEntity> classes) {
    final classesWithApplicants = classes.where((c) => c.pendingApplicationCount > 0).toList();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ApplicantsBottomSheet(classes: classesWithApplicants),
    );
  }

  void _showBillingsSheet(BuildContext context, List<BillingSummaryEntity> billings) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _BillingsBottomSheet(billings: billings),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// GREETING HEADER
// ═══════════════════════════════════════════════════════════
class _GreetingHeader extends StatelessWidget {
  final String greeting;
  final String name;
  final String role;

  const _GreetingHeader({required this.greeting, required this.name, required this.role});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
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
              role == 'PARENT' ? '👨‍👩‍👧 Phụ huynh' : '📚 Học sinh',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// SECTION TITLE
// ═══════════════════════════════════════════════════════════
class _SectionTitle extends StatelessWidget {
  final String icon;
  final String title;

  const _SectionTitle({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      child: Text(
        '$icon $title',
        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// ALERT BANNER — conditional notification
// ═══════════════════════════════════════════════════════════
class _AlertBanner extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _AlertBanner({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Material(
        color: color.withAlpha(12),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withAlpha(40)),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: color.withAlpha(25),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w700, color: color,
                      )),
                      Text(subtitle, style: TextStyle(
                        fontSize: 11, color: color.withAlpha(180),
                      )),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios, size: 14, color: color.withAlpha(150)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// MY CLASS CARD — improved
// ═══════════════════════════════════════════════════════════
class _MyClassCard extends StatelessWidget {
  final MyClassEntity classItem;
  final String role;

  const _MyClassCard({required this.classItem, required this.role});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusLabel = _resolveStatusLabel(classItem.status);
    final statusColor = _resolveStatusColor(classItem.status);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: theme.colorScheme.outline.withAlpha(50)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(6),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
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
                if (classItem.mode != null) ...[
                  const SizedBox(width: 6),
                  Icon(
                    classItem.mode == 'ONLINE' ? Icons.videocam_outlined : Icons.home_outlined,
                    size: 14,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ],
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
            Row(
              children: [
                Text(
                  '${classItem.subject} • ${classItem.grade}',
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
                if (classItem.tutorName != null) ...[
                  Text(
                    ' • GS: ${classItem.tutorName}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF10B981),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
            if (classItem.pendingApplicationCount > 0 && role == 'PARENT') ...[
              const SizedBox(height: 8),
              Container(
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
                      '${classItem.pendingApplicationCount} gia sư ứng tuyển',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFFF59E0B)),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _resolveStatusLabel(String status) {
    const labels = {
      'PENDING_APPROVAL': '⏳ Chờ duyệt',
      'OPEN': '🟢 Đang mở',
      'ASSIGNED': '✅ Đã có GS',
      'ACTIVE': '📚 Đang học',
      'COMPLETED': '🏆 Hoàn thành',
      'SUSPENDED': '⏸️ Tạm hoãn',
      'REJECTED': '❌ Từ chối',
    };
    return labels[status] ?? status;
  }

  Color _resolveStatusColor(String status) {
    const colors = {
      'PENDING_APPROVAL': Color(0xFFF59E0B),
      'OPEN': Color(0xFF6366F1),
      'ASSIGNED': Color(0xFF10B981),
      'ACTIVE': Color(0xFF10B981),
      'COMPLETED': Color(0xFF6B7280),
      'SUSPENDED': Color(0xFFD97706),
      'REJECTED': Color(0xFFEF4444),
    };
    return colors[status] ?? const Color(0xFF6B7280);
  }
}

// ═══════════════════════════════════════════════════════════
// UPCOMING SESSION CARD
// ═══════════════════════════════════════════════════════════
class _UpcomingSessionCard extends StatelessWidget {
  final UpcomingSessionEntity session;

  const _UpcomingSessionCard({required this.session});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Parse date for display
    final parts = session.sessionDate.split('-');
    String dayLabel = session.sessionDate;
    if (parts.length == 3) {
      final date = DateTime.tryParse(session.sessionDate);
      if (date != null) {
        const dayNames = ['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'];
        dayLabel = '${dayNames[date.weekday % 7]} ${parts[2]}/${parts[1]}';
      }
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF6366F1).withAlpha(30)),
        ),
        child: Row(
          children: [
            // Date chip
            Container(
              width: 52,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF6366F1).withAlpha(15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Text(
                    dayLabel.split(' ').first,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF6366F1),
                    ),
                  ),
                  Text(
                    dayLabel.contains(' ') ? dayLabel.split(' ').last : '',
                    style: const TextStyle(fontSize: 11, color: Color(0xFF6366F1)),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Session info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    session.classTitle,
                    style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 13, color: theme.colorScheme.onSurfaceVariant),
                      const SizedBox(width: 4),
                      Text(
                        '${_formatTime(session.startTime)} - ${_formatTime(session.endTime)}',
                        style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                      ),
                      if (session.tutorName != null) ...[
                        const SizedBox(width: 8),
                        Icon(Icons.person_outline, size: 13, color: theme.colorScheme.onSurfaceVariant),
                        const SizedBox(width: 3),
                        Flexible(
                          child: Text(
                            session.tutorName!,
                            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(String time) {
    // "14:00:00" → "14:00"
    return time.length >= 5 ? time.substring(0, 5) : time;
  }
}

// ═══════════════════════════════════════════════════════════
// STUDENT SCHEDULE CARD (PH ONLY)
// ═══════════════════════════════════════════════════════════
class _StudentScheduleCard extends StatelessWidget {
  final List<MyClassEntity> classes;

  const _StudentScheduleCard({required this.classes});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeClasses = classes.where((c) => c.status == 'ACTIVE').toList();

    if (activeClasses.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withAlpha(60),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: theme.colorScheme.outline.withAlpha(40)),
          ),
          child: Column(
            children: [
              Icon(Icons.person_outline, size: 32, color: theme.colorScheme.onSurfaceVariant.withAlpha(120)),
              const SizedBox(height: 6),
              Text(
                'Chưa có lớp đang hoạt động',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: theme.colorScheme.outline.withAlpha(50)),
        ),
        child: Column(
          children: [
            ...activeClasses.map((cls) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1).withAlpha(15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.school, size: 16, color: Color(0xFF6366F1)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cls.title,
                          style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '${cls.subject} • ${cls.sessionsPerWeek ?? '?'} buổi/tuần',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (cls.tutorName != null)
                    Text(
                      'GS: ${cls.tutorName}',
                      style: TextStyle(
                        fontSize: 11,
                        color: const Color(0xFF10B981),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// APPLICANTS BOTTOM SHEET
// ═══════════════════════════════════════════════════════════
class _ApplicantsBottomSheet extends StatelessWidget {
  final List<MyClassEntity> classes;

  const _ApplicantsBottomSheet({required this.classes});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final webLauncher = getIt<WebLauncherService>();

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.6,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.outline.withAlpha(60),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '🎓 Gia sư ứng tuyển',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 12),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              itemCount: classes.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, i) {
                final cls = classes[i];
                return Material(
                  color: const Color(0xFFF59E0B).withAlpha(8),
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      Navigator.pop(context);
                      webLauncher.openWithToken('/parent/classes/${cls.id}/applicants');
                    },
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFF59E0B).withAlpha(30)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(cls.title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                                const SizedBox(height: 2),
                                Text(
                                  '${cls.subject} • ${cls.grade}',
                                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF59E0B).withAlpha(20),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${cls.pendingApplicationCount} GS',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFFF59E0B)),
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFFF59E0B)),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// BILLINGS BOTTOM SHEET
// ═══════════════════════════════════════════════════════════
class _BillingsBottomSheet extends StatelessWidget {
  final List<BillingSummaryEntity> billings;

  const _BillingsBottomSheet({required this.billings});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final webLauncher = getIt<WebLauncherService>();

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.6,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.outline.withAlpha(60),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '💰 Hóa đơn chưa thanh toán',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 12),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              itemCount: billings.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, i) {
                final bill = billings[i];
                return Material(
                  color: const Color(0xFFEF4444).withAlpha(8),
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      Navigator.pop(context);
                      webLauncher.openWithToken('/parent/payment');
                    },
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFEF4444).withAlpha(30)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEF4444).withAlpha(15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.receipt_outlined, color: Color(0xFFEF4444), size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(bill.classTitle, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                                Text(
                                  'T${bill.month}/${bill.year} • ${bill.transactionCode}',
                                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            _formatCurrency(bill.amount),
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFFEF4444)),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatCurrency(double amount) {
    final formatted = amount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
    return '${formatted}đ';
  }
}

// ═══════════════════════════════════════════════════════════
// TUTOR HOME — unchanged
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
                      style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: 2),
                    Text(name, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6).withAlpha(20),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text('🎓 Gia sư', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              _StatMini(icon: Icons.calendar_today, label: 'Lịch dạy', color: const Color(0xFF6366F1), onTap: () => GoRouter.of(context).go('/schedule')),
              const SizedBox(width: 12),
              _StatMini(icon: Icons.monetization_on_outlined, label: 'Thu nhập', color: const Color(0xFF10B981), onTap: () => webLauncher.openWithToken('/tutor/revenue')),
              const SizedBox(width: 12),
              _StatMini(icon: Icons.dashboard_outlined, label: 'Dashboard', color: const Color(0xFFF59E0B), onTap: () => webLauncher.openWithToken('/tutor/dashboard')),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('⚡ Lớp mới phù hợp với bạn', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
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
