import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../app/theme.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/dash_stat_card.dart';
import '../widgets/dash_section_header.dart';
import '../widgets/add_person_sheet.dart';
import '../../../../core/di/injection.dart';
import '../../../student/data/datasources/student_remote_datasource.dart';
import '../../../student/data/models/parent_link_model.dart';
import '../../../student/presentation/cubit/student_link_cubit.dart';
import '../../../student/presentation/cubit/student_link_state.dart';

class StudentDashboardScreen extends StatefulWidget {
  const StudentDashboardScreen({super.key});

  @override
  State<StudentDashboardScreen> createState() => _StudentDashboardScreenState();
}

class _StudentDashboardScreenState extends State<StudentDashboardScreen> {
  int _navIndex = 0;
  late final StudentLinkCubit _linkCubit;

  @override
  void initState() {
    super.initState();
    _linkCubit = StudentLinkCubit(getIt<StudentRemoteDataSource>());
    _linkCubit.loadParentLinks();
  }

  @override
  void dispose() {
    _linkCubit.close();
    super.dispose();
  }

  void _showAddParent() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddPersonSheet(
        title: 'Thêm phụ huynh',
        hint: 'Số điện thoại phụ huynh',
        onConfirm: (phone) => _linkCubit.requestParentLink(phone),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider.value(
      value: _linkCubit,
      child: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(
            listener: (ctx, state) {
              if (state is! AuthAuthenticated) ctx.go('/home');
            },
          ),
          BlocListener<StudentLinkCubit, StudentLinkState>(
            listener: (ctx, state) {
              if (state is StudentLinkActionSuccess) {
                ScaffoldMessenger.of(ctx).showSnackBar(
                  SnackBar(content: Text(state.message), backgroundColor: AppTheme.primary),
                );
              } else if (state is StudentLinkError) {
                ScaffoldMessenger.of(ctx).showSnackBar(
                  SnackBar(content: Text(state.message), backgroundColor: cs.error),
                );
              }
            },
          ),
        ],
        child: Column(
          children: [
            _buildTabSelector(cs, isDark),
            Expanded(
              child: _navIndex == 0
                  ? _buildHome(cs, isDark)
                  : _buildParentsTab(isDark),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────── Tab Selector ───────────────────────

  Widget _buildTabSelector(ColorScheme cs, bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.surface.withAlpha(120) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _tabButton('Tổng quan', Icons.home_outlined, 0, cs),
          _tabButton('Phụ huynh', Icons.family_restroom, 1, cs),
        ],
      ),
    );
  }

  Widget _tabButton(String label, IconData icon, int index, ColorScheme cs) {
    final isActive = _navIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _navIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? cs.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: isActive ? Colors.white : cs.onSurfaceVariant),
              const SizedBox(width: 6),
              Text(label, style: TextStyle(
                fontSize: 13,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                color: isActive ? Colors.white : cs.onSurfaceVariant,
              )),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────── Tab 1: Tổng quan ───────────────────────

  Widget _buildHome(ColorScheme cs, bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting banner
          BlocBuilder<AuthBloc, AuthState>(
            builder: (_, state) {
              final name = state is AuthAuthenticated ? (state.user.name ?? 'Học sinh') : 'Học sinh';
              return _GreetingBanner(name: name, tag: '📚 Học sinh', emoji: '🎒', isDark: isDark);
            },
          ),
          const SizedBox(height: 16),

          // Pending parent requests — nổi bật nếu có PH gửi yêu cầu
          BlocBuilder<StudentLinkCubit, StudentLinkState>(
            builder: (_, state) {
              if (state is StudentLinkLoaded && state.hasPendingRequests) {
                return Column(
                  children: [
                    _PendingRequestsBanner(
                      pendingLinks: state.pendingFromParent,
                      onAccept: (id) => _linkCubit.acceptLink(id),
                      onReject: (id) => _linkCubit.rejectLink(id),
                      isDark: isDark,
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),

          // Stats
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.8,
            children: const [
              DashStatCard(value: '0', label: 'Lớp đang học',   emoji: '📖', accent: AppTheme.primary),
              DashStatCard(value: '0', label: 'Buổi học/tuần',  emoji: '📅', accent: AppTheme.accent),
              DashStatCard(value: '0', label: 'Bài hoàn thành', emoji: '✅', accent: Color(0xFF10B981)),
              DashStatCard(value: '0', label: 'Điểm tích lũy',  emoji: '⭐', accent: Color(0xFFF59E0B)),
            ],
          ),
          const SizedBox(height: 20),

          // Parent link status
          BlocBuilder<StudentLinkCubit, StudentLinkState>(
            builder: (_, state) {
              if (state is StudentLinkLoaded && state.hasParent) {
                return _ParentLinkedChip(parent: state.acceptedLinks.first, isDark: isDark);
              }
              if (state is StudentLinkLoaded && !state.hasParent) {
                return _NoParentCard(onAddParent: _showAddParent, isDark: isDark);
              }
              return const SizedBox.shrink();
            },
          ),
          const SizedBox(height: 20),

          // Quick actions
          DashSectionHeader(title: '⚡ Thao tác nhanh', onTap: null),
          const SizedBox(height: 10),
          _QuickActions(actions: const [
            {'emoji': '💬', 'label': 'Tin nhắn'},
            {'emoji': '📊', 'label': 'Thành tích'},
          ]),
        ],
      ),
    );
  }

  // ─────────────────────── Tab 2: Phụ huynh ───────────────────────

  Widget _buildParentsTab(bool isDark) {
    return BlocBuilder<StudentLinkCubit, StudentLinkState>(
      builder: (_, state) {
        if (state is StudentLinkLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is StudentLinkLoaded) {
          return _ParentsTabContent(
            acceptedLinks: state.acceptedLinks,
            pendingFromParent: state.pendingFromParent,
            pendingSentByStudent: state.pendingSentByStudent,
            isDark: isDark,
            onAddParent: _showAddParent,
            onAccept: (id) => _linkCubit.acceptLink(id),
            onReject: (id) => _linkCubit.rejectLink(id),
          );
        }
        if (state is StudentLinkError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('😕', style: TextStyle(fontSize: 48)),
                const SizedBox(height: 12),
                Text('Không tải được dữ liệu', style: TextStyle(color: Colors.grey[500])),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () => _linkCubit.loadParentLinks(),
                  child: const Text('Thử lại'),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// Widget phụ — tách riêng cho dễ đọc
// ═══════════════════════════════════════════════════════════════════

/// Tab Phụ huynh — nội dung
class _ParentsTabContent extends StatelessWidget {
  final List<ParentLinkModel> acceptedLinks;
  final List<ParentLinkModel> pendingFromParent;
  final List<ParentLinkModel> pendingSentByStudent;
  final bool isDark;
  final VoidCallback onAddParent;
  final void Function(String) onAccept;
  final void Function(String) onReject;

  const _ParentsTabContent({
    required this.acceptedLinks,
    required this.pendingFromParent,
    required this.pendingSentByStudent,
    required this.isDark,
    required this.onAddParent,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final hasAny = acceptedLinks.isNotEmpty || pendingFromParent.isNotEmpty || pendingSentByStudent.isNotEmpty;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Pending requests from parent
        if (pendingFromParent.isNotEmpty) ...[
          DashSectionHeader(title: '🔔 Yêu cầu từ Phụ huynh', onTap: null),
          const SizedBox(height: 8),
          ...pendingFromParent.map((l) => _PendingLinkCard(
            link: l,
            isDark: isDark,
            onAccept: () => onAccept(l.id),
            onReject: () => onReject(l.id),
          )),
          const SizedBox(height: 16),
        ],

        // Accepted parents
        DashSectionHeader(
          title: '👨‍👩‍👧 Phụ huynh liên kết',
          onTap: onAddParent,
          actionLabel: '+ Thêm',
        ),
        const SizedBox(height: 8),
        if (acceptedLinks.isEmpty && pendingSentByStudent.isEmpty)
          _EmptyParentState(onAddParent: onAddParent, isDark: isDark)
        else ...[
          ...acceptedLinks.map((l) => _PersonCard(
            name: l.parentName,
            meta: l.parentPhone ?? 'Đã liên kết',
            statusLabel: 'Đã liên kết',
            statusColor: const Color(0xFF10B981),
            isDark: isDark,
          )),
          ...pendingSentByStudent.map((l) => _PersonCard(
            name: l.parentName,
            meta: l.parentPhone ?? 'Chờ xác nhận',
            statusLabel: 'Đang chờ',
            statusColor: const Color(0xFFF59E0B),
            isDark: isDark,
          )),
        ],
        const SizedBox(height: 16),

        // Add parent button
        if (hasAny)
          OutlinedButton.icon(
            onPressed: onAddParent,
            icon: const Icon(Icons.person_add_outlined),
            label: const Text('Thêm phụ huynh bằng số điện thoại'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 13),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
      ],
    );
  }
}

/// Empty state khi HS chưa có PH nào
class _EmptyParentState extends StatelessWidget {
  final VoidCallback onAddParent;
  final bool isDark;

  const _EmptyParentState({required this.onAddParent, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.surface : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.grey.shade200,
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.family_restroom, size: 40, color: AppTheme.primary),
          ),
          const SizedBox(height: 16),
          const Text(
            'Chưa liên kết phụ huynh',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            'Liên kết phụ huynh để họ theo dõi\ntiến trình học tập của bạn.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.grey[500], height: 1.5),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: onAddParent,
            icon: const Icon(Icons.person_add_outlined, size: 18),
            label: const Text('Liên kết phụ huynh'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }
}

/// Card hiển thị yêu cầu PENDING từ PH — có nút Chấp nhận / Từ chối
class _PendingLinkCard extends StatelessWidget {
  final ParentLinkModel link;
  final bool isDark;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const _PendingLinkCard({
    required this.link,
    required this.isDark,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.surface : Colors.white,
        border: Border.all(color: const Color(0xFFF59E0B).withOpacity(0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFFF59E0B),
                child: Text(
                  link.parentName.isNotEmpty ? link.parentName[0].toUpperCase() : '?',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(link.parentName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                    Text(link.parentPhone ?? 'Phụ huynh', style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text('Chờ duyệt', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFFF59E0B))),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onReject,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Từ chối', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: onAccept,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Chấp nhận', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Banner nổi bật khi có pending requests — hiển thị ở tab Tổng quan
class _PendingRequestsBanner extends StatelessWidget {
  final List<ParentLinkModel> pendingLinks;
  final void Function(String) onAccept;
  final void Function(String) onReject;
  final bool isDark;

  const _PendingRequestsBanner({
    required this.pendingLinks,
    required this.onAccept,
    required this.onReject,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFFF59E0B).withOpacity(0.1), const Color(0xFFF59E0B).withOpacity(0.05)],
        ),
        border: Border.all(color: const Color(0xFFF59E0B).withOpacity(0.3)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.notifications_active, color: Color(0xFFF59E0B), size: 18),
              const SizedBox(width: 6),
              Text(
                '${pendingLinks.length} yêu cầu liên kết từ phụ huynh',
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFFB45309)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...pendingLinks.take(2).map((l) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                const Text('👤 ', style: TextStyle(fontSize: 14)),
                Text(l.parentName, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                if (l.parentPhone != null) ...[
                  const Text(' — ', style: TextStyle(fontSize: 12)),
                  Text(l.parentPhone!, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                ],
              ],
            ),
          )),
        ],
      ),
    );
  }
}

/// Chip nhỏ hiển thị PH đã liên kết — ở tab Tổng quan
class _ParentLinkedChip extends StatelessWidget {
  final ParentLinkModel parent;
  final bool isDark;

  const _ParentLinkedChip({required this.parent, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.surface : Colors.white,
        border: Border.all(color: const Color(0xFF10B981).withOpacity(0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: const Color(0xFF10B981),
            child: Text(
              parent.parentName.isNotEmpty ? parent.parentName[0].toUpperCase() : '?',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Phụ huynh', style: TextStyle(fontSize: 10, color: Colors.grey)),
                Text(parent.parentName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withOpacity(0.1),
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, size: 12, color: Color(0xFF10B981)),
                SizedBox(width: 4),
                Text('Đã liên kết', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF10B981))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Card kêu gọi HS liên kết PH ở tab Tổng quan khi chưa có PH
class _NoParentCard extends StatelessWidget {
  final VoidCallback onAddParent;
  final bool isDark;

  const _NoParentCard({required this.onAddParent, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onAddParent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.surface : Colors.white,
          border: Border.all(color: AppTheme.primary.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.person_add_outlined, size: 20, color: AppTheme.primary),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Chưa liên kết phụ huynh', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                  Text('Nhấn để liên kết ngay', style: TextStyle(fontSize: 11, color: Colors.grey)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, size: 18, color: AppTheme.primary),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// Shared widgets
// ═══════════════════════════════════════════════════════════════════

class _GreetingBanner extends StatelessWidget {
  final String name, tag, emoji;
  final bool isDark;
  const _GreetingBanner({required this.name, required this.tag, required this.emoji, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4F46E5), Color(0xFF7C3AED), Color(0xFFA21CAF)],
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: AppTheme.primary.withOpacity(0.3), blurRadius: 18, offset: const Offset(0, 6)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_greeting(), style: const TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 4),
                Text(name, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(999)),
                  child: Text(tag, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
          Text(emoji, style: const TextStyle(fontSize: 44)),
        ],
      ),
    );
  }

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Chào buổi sáng 👋';
    if (h < 18) return 'Chào buổi chiều 👋';
    return 'Chào buổi tối 👋';
  }
}

class _PersonCard extends StatelessWidget {
  final String name, meta, statusLabel;
  final Color statusColor;
  final bool isDark;
  const _PersonCard({
    required this.name,
    required this.meta,
    required this.statusLabel,
    required this.statusColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.surface : Colors.white,
        border: Border.all(color: isDark ? Colors.white12 : Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: statusColor,
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : '?',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                Text(meta, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(statusLabel, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: statusColor)),
          ),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  final List<Map<String, String>> actions;
  const _QuickActions({required this.actions});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 2.4,
      children: actions.map((a) => _QACard(emoji: a['emoji']!, label: a['label']!, isDark: isDark)).toList(),
    );
  }
}

class _QACard extends StatelessWidget {
  final String emoji, label;
  final bool isDark;
  const _QACard({required this.emoji, required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.surface : Colors.white,
          border: Border.all(color: isDark ? Colors.white12 : Colors.grey.shade200),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
            Expanded(child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
            const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
