import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/services/web_launcher_service.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../tutor_profile/presentation/bloc/tutor_profile_bloc.dart';
import '../../../tutor_profile/presentation/bloc/tutor_profile_event.dart';
import '../../../tutor_profile/presentation/bloc/tutor_profile_state.dart';
import '../../../tutor_profile/domain/entities/tutor_class_entity.dart';
import '../../../tutor_profile/domain/entities/tutor_session_entity.dart';
import '../../../tutor_profile/data/datasources/tutor_payout_datasource.dart';
import '../../../admin/data/datasources/admin_dashboard_datasource.dart';
import '../widgets/open_classes_section.dart';
import '../widgets/featured_tutors_section.dart';
import '../widgets/guest_hero_section.dart';
import '../../../../shared/widgets/gradient_hero_card.dart';
import '../../../../shared/widgets/stat_card.dart';
import '../../domain/entities/my_class_entity.dart';
import '../../domain/entities/upcoming_session_entity.dart';
import '../../domain/entities/billing_summary_entity.dart';
import '../../domain/entities/student_entity.dart';
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
          if (role == 'ADMIN') return const _AdminHome();
          if (role == 'TUTOR') return const _TutorHome();
          return const _ParentStudentHome();
        }
        return const _GuestHome();
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════
// GUEST HOME (Mockup 01)
// ═══════════════════════════════════════════════════════════
class _GuestHome extends StatelessWidget {
  const _GuestHome();

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 16),
          GuestHeroSection(),
          SizedBox(height: 28),
          OpenClassesSection(),
          SizedBox(height: 28),
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
                    // ── Stat Cards Grid (Mockup 04) ──
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GridView.count(
                        crossAxisCount: role == 'PARENT' ? 4 : 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: role == 'PARENT' ? 0.85 : 1.5,
                        children: [
                          StatCard(
                            value: '${state.classes.length}',
                            label: 'Lớp đang học',
                            icon: const Icon(Icons.menu_book_rounded, size: 16, color: Color(0xFF6366F1)),
                            iconBackground: const Color(0xFF6366F1).withValues(alpha: 0.1),
                          ),
                          StatCard(
                            value: '${state.upcomingSessions.length}',
                            label: 'Buổi tháng này',
                            icon: const Icon(Icons.calendar_month_rounded, size: 16, color: Color(0xFF8B5CF6)),
                            iconBackground: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                          ),
                          if (role == 'PARENT') ...[
                            StatCard(
                              value: '4.8',
                              label: 'Đánh giá',
                              icon: const Icon(Icons.star_rounded, size: 16, color: Color(0xFFF59E0B)),
                              iconBackground: const Color(0xFFF59E0B).withValues(alpha: 0.1),
                            ),
                            StatCard(
                              value: _formatCurrency(state.unpaidBillings),
                              label: 'Chi phí/tháng',
                              icon: const Icon(Icons.account_balance_wallet_rounded, size: 16, color: Color(0xFF10B981)),
                              iconBackground: const Color(0xFF10B981).withValues(alpha: 0.1),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

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

                    // ── Section: Con em liên kết (CHỈ PH) ──
                    if (role == 'PARENT') ...[
                      const SizedBox(height: 20),
                      _SectionTitle(icon: '👧', title: 'Con em của tôi'),
                      _ChildrenLinkCard(children: state.children),
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

  String _formatCurrency(List<BillingSummaryEntity> billings) {
    final total = billings.fold<double>(0, (sum, b) => sum + b.amount);
    if (total >= 1000000) {
      return '${(total / 1000000).toStringAsFixed(1)}M';
    }
    if (total >= 1000) {
      return '${(total / 1000).toStringAsFixed(0)}K';
    }
    return '${total.toInt()}';
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
    final emoji = role == 'PARENT' ? '👋' : '🌟';
    final roleLabel = role == 'PARENT' ? 'Phụ huynh' : 'Học sinh';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GradientHeroCard(
        greeting: '$greeting $emoji',
        userName: name,
        roleLabel: roleLabel,
        roleIcon: role == 'PARENT' ? Icons.family_restroom : Icons.school,
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
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          if (role == 'PARENT') {
            context.push('/parent-class-detail', extra: classItem);
          }
        },
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
// CHILDREN LINK CARD (PH ONLY)
// ═══════════════════════════════════════════════════════════
class _ChildrenLinkCard extends StatelessWidget {
  final List<StudentEntity> children;

  const _ChildrenLinkCard({required this.children});

  void _openChildrenWeb(BuildContext context) {
    final webLauncher = getIt<WebLauncherService>();
    webLauncher.openWithToken('/parent/children');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (children.isEmpty) {
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
              Icon(Icons.family_restroom, size: 32, color: theme.colorScheme.primary.withAlpha(120)),
              const SizedBox(height: 8),
              Text(
                'Chưa có con em nào',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Thêm con em trên web để quản lý lịch học',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant.withAlpha(150),
                ),
              ),
              const SizedBox(height: 14),
              GestureDetector(
                onTap: () => _openChildrenWeb(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add, size: 16, color: Colors.white),
                      SizedBox(width: 6),
                      Text(
                        'Thêm con em',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () => _openChildrenWeb(context),
      child: Padding(
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
              ...children.asMap().entries.map((entry) {
                final child = entry.value;
                final initial = child.fullName.trim().split(' ').last[0].toUpperCase();
                final isPending = child.linkStatus == 'PENDING';

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: const Color(0xFF6366F1).withAlpha(20),
                        child: Text(
                          initial,
                          style: const TextStyle(
                            color: Color(0xFF6366F1),
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              child.fullName,
                              style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            if (child.grade != null || child.school != null)
                              Text(
                                [child.grade, child.school].where((e) => e != null).join(' · '),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: isPending
                              ? const Color(0xFFD97706).withAlpha(20)
                              : const Color(0xFF10B981).withAlpha(20),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          isPending ? 'Đang chờ' : 'Đã liên kết',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: isPending
                                ? const Color(0xFFD97706)
                                : const Color(0xFF10B981),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              // Footer: quản lý trên web
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.open_in_new, size: 13, color: theme.colorScheme.primary),
                    const SizedBox(width: 4),
                    Text(
                      'Quản lý trên web',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
                      context.push('/parent-class-detail', extra: cls);
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
                                Row(
                                  children: [
                                    if (cls.classCode != null) ...[
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: theme.colorScheme.primary.withAlpha(20),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          cls.classCode!,
                                          style: TextStyle(
                                            color: theme.colorScheme.primary,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                    ],
                                    Expanded(
                                      child: Text(
                                        cls.title,
                                        style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
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
                      context.push('/billings');
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
// ADMIN HOME — Dashboard + Notifications
// ═══════════════════════════════════════════════════════════
class _AdminHome extends StatefulWidget {
  const _AdminHome();

  @override
  State<_AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<_AdminHome> {
  AdminStatsModel? _stats;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() { _loading = true; _error = null; });
    try {
      final ds = getIt<AdminDashboardDataSource>();
      final stats = await ds.getStats();
      if (mounted) {
        setState(() { _stats = stats; _loading = false; });
      }
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _loading = false; });
    }
  }

  void _openWebAdmin() {
    getIt<WebLauncherService>().openWithToken('/admin/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final user = (context.read<AuthBloc>().state as AuthAuthenticated).user;
    final name = user.name ?? 'Admin';
    final hour = DateTime.now().hour;
    final greeting = hour < 12 ? 'Chào buổi sáng' : hour < 18 ? 'Chào buổi chiều' : 'Chào buổi tối';

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView(
        padding: const EdgeInsets.only(top: 16, bottom: 100),
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
                      Text('$greeting 👋', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                      const SizedBox(height: 2),
                      Text(name, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444).withAlpha(20),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text('🛡️ Admin', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ── Open Web Admin CTA ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _openWebAdmin,
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6366F1).withAlpha(60),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.open_in_browser_rounded, color: Colors.white, size: 20),
                      SizedBox(width: 10),
                      Text(
                        'Mở trang quản trị Web',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 6),
                      Icon(Icons.arrow_forward_rounded, color: Colors.white70, size: 18),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // ── Content ──
          if (_loading)
            const Padding(
              padding: EdgeInsets.all(60),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_error != null)
            _buildAdminError(theme)
          else
            _buildAdminDashboard(theme, isDark),
        ],
      ),
    );
  }

  Widget _buildAdminError(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFEF4444).withAlpha(10),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFEF4444).withAlpha(40)),
        ),
        child: Column(
          children: [
            Row(children: [
              const Icon(Icons.error_outline, color: Color(0xFFEF4444)),
              const SizedBox(width: 12),
              Expanded(child: Text(_error ?? 'Lỗi không xác định', style: theme.textTheme.bodyMedium)),
            ]),
            const SizedBox(height: 8),
            OutlinedButton(onPressed: _loadData, child: const Text('Thử lại')),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminDashboard(ThemeData theme, bool isDark) {
    final stats = _stats!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Stats Grid ──
          Row(
            children: [
              _AdminStatChip(emoji: '👥', value: '${stats.totalUsers}', label: 'Người dùng', color: const Color(0xFF6366F1)),
              const SizedBox(width: 8),
              _AdminStatChip(emoji: '🎓', value: '${stats.activeTutors}', label: 'GS duyệt', color: const Color(0xFF10B981)),
              const SizedBox(width: 8),
              _AdminStatChip(emoji: '📋', value: '${stats.openClasses}', label: 'Lớp mở', color: const Color(0xFFF59E0B)),
              const SizedBox(width: 8),
              _AdminStatChip(emoji: '📚', value: '${stats.activeClasses}', label: 'Đang dạy', color: const Color(0xFF8B5CF6)),
            ],
          ),
          const SizedBox(height: 20),

          // ── Revenue Card ──
          _AdminRevenueCard(amount: stats.estimatedMonthlyRevenue, isDark: isDark),
          const SizedBox(height: 20),

          // ── Role Distribution ──
          Text('📊 Phân bổ người dùng', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _buildRoleDistribution(theme, isDark, stats),
        ],
      ),
    );
  }

  Widget _buildRoleDistribution(ThemeData theme, bool isDark, AdminStatsModel stats) {
    final roles = [
      _RoleItem('Gia sư', stats.tutorCount, const Color(0xFF6366F1)),
      _RoleItem('Phụ huynh', stats.parentCount, const Color(0xFF10B981)),
      _RoleItem('Học sinh', stats.studentCount, const Color(0xFFF59E0B)),
      _RoleItem('Admin', stats.adminCount, const Color(0xFFEF4444)),
    ];
    final total = stats.totalUsers > 0 ? stats.totalUsers : 1;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? theme.colorScheme.surface : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade200),
      ),
      child: Column(
        children: [
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              height: 12,
              child: Row(
                children: roles.map((r) {
                  final fraction = r.count / total;
                  if (fraction <= 0) return const SizedBox.shrink();
                  return Expanded(
                    flex: (fraction * 100).round().clamp(1, 100),
                    child: Container(color: r.color),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Legend
          Wrap(
            spacing: 16,
            runSpacing: 6,
            children: roles.map((r) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 10, height: 10, decoration: BoxDecoration(color: r.color, borderRadius: BorderRadius.circular(3))),
                const SizedBox(width: 4),
                Text('${r.label}: ${r.count}', style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface)),
              ],
            )).toList(),
          ),
        ],
      ),
    );
  }
}

class _RoleItem {
  final String label;
  final int count;
  final Color color;
  const _RoleItem(this.label, this.count, this.color);
}

/// Admin stat chip
class _AdminStatChip extends StatelessWidget {
  final String emoji, value, label;
  final Color color;

  const _AdminStatChip({required this.emoji, required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
        decoration: BoxDecoration(
          color: isDark ? color.withAlpha(15) : color.withAlpha(8),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withAlpha(25)),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 4),
            Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: color)),
            Text(label, style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }
}

/// Admin revenue highlight card
class _AdminRevenueCard extends StatelessWidget {
  final double amount;
  final bool isDark;

  const _AdminRevenueCard({required this.amount, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final formatted = _formatVND(amount);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF6366F1).withAlpha(30), const Color(0xFF8B5CF6).withAlpha(20)]
              : [const Color(0xFF6366F1).withAlpha(15), const Color(0xFF8B5CF6).withAlpha(10)],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF6366F1).withAlpha(25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.trending_up_rounded, color: Color(0xFF6366F1), size: 20),
              const SizedBox(width: 8),
              Text('Doanh thu nền tảng', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface)),
            ],
          ),
          const SizedBox(height: 8),
          Text(formatted, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xFF6366F1))),
          Text('Tổng phí nền tảng (lớp đang dạy + assigned)', style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant)),
        ],
      ),
    );
  }

  String _formatVND(double amount) {
    if (amount >= 1000000) {
      final m = amount / 1000000;
      return '${m.toStringAsFixed(m == m.truncateToDouble() ? 0 : 1)}M đ';
    }
    if (amount >= 1000) return '${(amount / 1000).toStringAsFixed(0)}K đ';
    return '${amount.toStringAsFixed(0)} đ';
  }
}

// ═══════════════════════════════════════════════════════════
// TUTOR HOME — unchanged
// ═══════════════════════════════════════════════════════════
class _TutorHome extends StatefulWidget {
  const _TutorHome();

  @override
  State<_TutorHome> createState() => _TutorHomeState();
}

class _TutorHomeState extends State<_TutorHome> {
  late final TutorProfileBloc _dashBloc;
  List<TutorPayoutModel> _payouts = [];
  bool _payoutsLoading = true;

  @override
  void initState() {
    super.initState();
    _dashBloc = getIt<TutorProfileBloc>()..add(LoadTutorDashboard());
    _loadPayouts();
  }

  Future<void> _loadPayouts() async {
    try {
      final ds = getIt<TutorPayoutDataSource>();
      final result = await ds.getPayouts();
      if (mounted) setState(() { _payouts = result; _payoutsLoading = false; });
    } catch (_) {
      if (mounted) setState(() => _payoutsLoading = false);
    }
  }

  Future<void> _confirmPayout(TutorPayoutModel payout) async {
    try {
      await getIt<TutorPayoutDataSource>().confirmPayout(payout.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Đã xác nhận nhận lương!'), backgroundColor: Color(0xFF10B981)),
        );
        _loadPayouts();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: $e'), backgroundColor: const Color(0xFFEF4444)),
        );
      }
    }
  }

  @override
  void dispose() {
    _dashBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final user = (context.read<AuthBloc>().state as AuthAuthenticated).user;
    final name = user.name ?? 'Gia sư';
    final hour = DateTime.now().hour;
    final greeting = hour < 12 ? 'Chào buổi sáng' : hour < 18 ? 'Chào buổi chiều' : 'Chào buổi tối';

    return BlocProvider.value(
      value: _dashBloc,
      child: RefreshIndicator(
        onRefresh: () async {
          _dashBloc.add(LoadTutorDashboard());
          _loadPayouts();
        },
        child: ListView(
          padding: const EdgeInsets.only(top: 16, bottom: 100),
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
                        Text('$greeting 👋', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
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
            const SizedBox(height: 16),

            // ── Dashboard content from BLoC ──
            BlocBuilder<TutorProfileBloc, TutorProfileState>(
              builder: (context, state) {
                if (state is TutorProfileLoading || state is TutorProfileInitial) {
                  return const Padding(
                    padding: EdgeInsets.all(40),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (state is TutorProfileError) {
                  return _buildTutorErrorCard(theme, state.message);
                }
                if (state is TutorDashboardLoaded) {
                  return _buildTutorDashboard(context, theme, isDark, state);
                }
                return const SizedBox.shrink();
              },
            ),
          ],

        ),
      ),
    );
  }

  Widget _buildTutorErrorCard(ThemeData theme, String message) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFEF4444).withAlpha(10),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFEF4444).withAlpha(40)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.error_outline, color: Color(0xFFEF4444)),
                const SizedBox(width: 12),
                Expanded(child: Text(message, style: theme.textTheme.bodyMedium)),
              ],
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => _dashBloc.add(LoadTutorDashboard()),
              child: const Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTutorDashboard(BuildContext context, ThemeData theme, bool isDark, TutorDashboardLoaded data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Verification warning ──
          if (data.isUnverified)
            _TutorVerificationBanner(status: 'UNVERIFIED', theme: theme),
          if (data.isPending)
            _TutorVerificationBanner(status: 'PENDING', theme: theme),
          if (data.isUnverified || data.isPending)
            const SizedBox(height: 12),

          // ── Alert: Lương chờ xác nhận ──
          ..._buildPayoutAlerts(theme),

          // ── Stats grid ──
          Row(
            children: [
              _TutorStatChip(emoji: '📚', value: '${data.classes.length}', label: 'Lớp dạy', color: const Color(0xFF6366F1)),
              const SizedBox(width: 8),
              _TutorStatChip(emoji: '📅', value: '${data.upcomingSessions.length}', label: 'Sắp tới', color: const Color(0xFF8B5CF6)),
              const SizedBox(width: 8),
              _TutorStatChip(
                emoji: '⭐',
                value: data.profile.rating > 0 ? data.profile.rating.toStringAsFixed(1) : '—',
                label: 'Đánh giá',
                color: const Color(0xFFF59E0B),
              ),
              const SizedBox(width: 8),
              _TutorStatChip(
                emoji: '💰',
                value: _formatCurrency(data.totalRevenue),
                label: 'Thu nhập',
                color: const Color(0xFF10B981),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── Lịch dạy sắp tới ──
          if (data.upcomingSessions.isNotEmpty) ...[
            _TutorSectionTitle(icon: '📅', title: 'Lịch dạy sắp tới', onSeeAll: () => GoRouter.of(context).go('/schedule')),
            const SizedBox(height: 8),
            ...data.upcomingSessions.take(3).map((s) => _TutorSessionCard(session: s, isDark: isDark)),
            const SizedBox(height: 16),
          ],

          // ── Lớp mới phù hợp ──
          const SizedBox(height: 20),
          _TutorSectionTitle(icon: '⚡', title: 'Lớp mới phù hợp', onSeeAll: null),
          const SizedBox(height: 8),
          const OpenClassesSection(),
          const SizedBox(height: 20),

          // ── Lớp đang dạy ──
          _TutorSectionTitle(icon: '📚', title: 'Lớp đang dạy', onSeeAll: null),
          const SizedBox(height: 8),
          if (data.classes.isEmpty)
            _buildEmptyHint(theme, 'Chưa có lớp nào được phân công.', isDark)
          else
            ...data.classes.take(4).map((c) => _TutorClassCard(cls: c, isDark: isDark)),

          // ── Doanh thu ──
          const SizedBox(height: 20),
          _TutorSectionTitle(icon: '💰', title: 'Doanh thu', onSeeAll: null),
          const SizedBox(height: 8),
          _buildRevenueSection(theme, isDark, data),
        ],
      ),
    );
  }

  Widget _buildEmptyHint(ThemeData theme, String text, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? theme.colorScheme.surface : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, size: 20, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 10),
          Text(text, style: TextStyle(fontSize: 13, color: theme.colorScheme.onSurfaceVariant)),
        ],
      ),
    );
  }

  String _formatCurrency(num n) {
    if (n == 0) return '0';
    if (n >= 1000000) {
      final m = n / 1000000;
      return '${m.toStringAsFixed(m == m.truncate() ? 0 : 1)}M';
    }
    if (n >= 1000) {
      final k = n / 1000;
      return '${k.toStringAsFixed(k == k.truncate() ? 0 : 1)}K';
    }
    return n.toString();
  }

  /// Alert banners cho lương chờ xác nhận
  List<Widget> _buildPayoutAlerts(ThemeData theme) {
    final pendingConfirm = _payouts.where((p) => p.needsConfirmation).toList();
    if (pendingConfirm.isEmpty) return [];
    return [
      Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF10B981).withAlpha(15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF10B981).withAlpha(40)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.account_balance_wallet_rounded, color: Color(0xFF10B981), size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${pendingConfirm.length} khoản lương chờ xác nhận',
                    style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF10B981), fontSize: 13),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...pendingConfirm.take(3).map((p) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${p.classTitle ?? "Lớp"} • ${p.periodLabel} • ${_formatVND(p.amount)}',
                      style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface),
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 28,
                    child: ElevatedButton(
                      onPressed: () => _showConfirmDialog(p),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Đã nhận'),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    ];
  }

  void _showConfirmDialog(TutorPayoutModel payout) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận nhận lương'),
        content: Text(
          'Bạn xác nhận đã nhận ${_formatVND(payout.amount)} '
          'cho lớp "${payout.classTitle}" (${payout.periodLabel})?',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Hủy')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _confirmPayout(payout);
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981)),
            child: const Text('Xác nhận', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  /// Revenue overview section
  Widget _buildRevenueSection(ThemeData theme, bool isDark, TutorDashboardLoaded data) {
    if (_payoutsLoading) {
      return const Center(child: Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator()));
    }
    if (_payouts.isEmpty) {
      return _buildEmptyHint(theme, 'Chưa có dữ liệu doanh thu.', isDark);
    }

    // Tính tổng theo trạng thái
    final totalAll = _payouts.fold<double>(0, (s, p) => s + p.amount);
    final totalConfirmed = _payouts.where((p) => p.isConfirmed).fold<double>(0, (s, p) => s + p.amount);
    final pendingCount = _payouts.where((p) => p.needsConfirmation).length;

    return Column(
      children: [
        // Revenue summary cards
        Row(
          children: [
            Expanded(
              child: _RevenueCard(
                label: 'Tổng thu nhập',
                value: _formatVND(totalAll),
                icon: Icons.account_balance_wallet,
                color: const Color(0xFF6366F1),
                isDark: isDark,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _RevenueCard(
                label: 'Đã nhận',
                value: _formatVND(totalConfirmed),
                icon: Icons.check_circle_outline,
                color: const Color(0xFF10B981),
                isDark: isDark,
              ),
            ),
          ],
        ),
        if (pendingCount > 0)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF59E0B).withAlpha(15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.hourglass_bottom, size: 16, color: Color(0xFFF59E0B)),
                  const SizedBox(width: 8),
                  Text(
                    '$pendingCount khoản chờ xác nhận nhận tiền',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFFB45309)),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  String _formatVND(double amount) {
    if (amount >= 1000000) {
      final m = amount / 1000000;
      return '${m.toStringAsFixed(m == m.truncateToDouble() ? 0 : 1)}M đ';
    }
    if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)}K đ';
    }
    return '${amount.toStringAsFixed(0)} đ';
  }
}

/// Revenue summary card
class _RevenueCard extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color;
  final bool isDark;

  const _RevenueCard({required this.label, required this.value, required this.icon, required this.color, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? color.withAlpha(15) : color.withAlpha(8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(height: 6),
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: color)),
          Text(label, style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}

// ── Tutor Verification Banner ──
class _TutorVerificationBanner extends StatelessWidget {
  final String status;
  final ThemeData theme;

  const _TutorVerificationBanner({required this.status, required this.theme});

  @override
  Widget build(BuildContext context) {
    final isUnverified = status == 'UNVERIFIED';
    final bgColor = isUnverified ? const Color(0xFFDC2626).withAlpha(20) : const Color(0xFFEAB308).withAlpha(20);
    final textColor = isUnverified ? const Color(0xFFDC2626) : const Color(0xFFCA8A04);
    final icon = isUnverified ? Icons.warning_amber_rounded : Icons.hourglass_top;
    final title = isUnverified ? 'Chưa xác thực hồ sơ!' : 'Hồ sơ đang chờ duyệt';
    final desc = isUnverified ? 'Xác thực để bắt đầu nhận lớp.' : 'Vui lòng chờ phê duyệt.';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: textColor, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.w700, color: textColor, fontSize: 13)),
                const SizedBox(height: 2),
                Text(desc, style: TextStyle(color: textColor, fontSize: 12)),
              ],
            ),
          ),
          if (isUnverified)
            TextButton(
              onPressed: () => GoRouter.of(context).go('/profile'),
              child: const Text('Xác thực', style: TextStyle(fontWeight: FontWeight.w700)),
            ),
        ],
      ),
    );
  }
}

// ── Tutor Stat Chip ──
class _TutorStatChip extends StatelessWidget {
  final String emoji, value, label;
  final Color color;

  const _TutorStatChip({required this.emoji, required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? color.withAlpha(15) : color.withAlpha(10),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withAlpha(30)),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 4),
            Text(value, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: color)),
            Text(label, style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }
}

// ── Tutor Section Title ──
class _TutorSectionTitle extends StatelessWidget {
  final String icon, title;
  final VoidCallback? onSeeAll;

  const _TutorSectionTitle({required this.icon, required this.title, this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Text('$icon $title', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
        const Spacer(),
        if (onSeeAll != null)
          TextButton(
            onPressed: onSeeAll,
            style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
            child: const Text('Xem tất cả', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          ),
      ],
    );
  }
}

// ── Tutor Session Card ──
class _TutorSessionCard extends StatelessWidget {
  final TutorSessionEntity session;
  final bool isDark;

  const _TutorSessionCard({required this.session, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? theme.colorScheme.surface : Colors.white,
        border: Border.all(color: isDark ? Colors.white12 : Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Time badge
          Container(
            width: 50,
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1).withAlpha(15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Text(
                  session.startTime.length >= 5 ? session.startTime.substring(0, 5) : session.startTime,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF6366F1)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(session.classTitle, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(session.subject, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1).withAlpha(15),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              _formatSessionDate(),
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF6366F1)),
            ),
          ),
        ],
      ),
    );
  }

  String _formatSessionDate() {
    final date = DateTime.tryParse(session.sessionDate);
    if (date == null) return session.startTime;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final sessionDay = DateTime(date.year, date.month, date.day);
    final time = session.startTime.length >= 5 ? session.startTime.substring(0, 5) : session.startTime;
    if (sessionDay == today) return 'Hôm nay';
    if (sessionDay == tomorrow) return 'Ngày mai';
    const dayNames = ['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'];
    return '${dayNames[date.weekday % 7]}, ${date.day}/${date.month}';
  }
}

// ── Tutor Class Card ──
class _TutorClassCard extends StatelessWidget {
  final TutorClassEntity cls;
  final bool isDark;

  const _TutorClassCard({required this.cls, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = cls.status == 'ACTIVE' ? const Color(0xFF10B981) : const Color(0xFF6B7280);
    final statusLabel = cls.status == 'ACTIVE' ? 'Đang dạy' : cls.status;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? theme.colorScheme.surface : Colors.white,
        border: Border.all(color: isDark ? Colors.white12 : Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Subject badge
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)]),
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Text(
              cls.subject.length >= 2 ? cls.subject.substring(0, 2).toUpperCase() : cls.subject.toUpperCase(),
              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(cls.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(
                  '${cls.subject} • ${cls.grade} • ${cls.sessionsPerWeek} buổi/tuần',
                  style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: statusColor.withAlpha(15),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(statusLabel, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: statusColor)),
          ),
        ],
      ),
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
