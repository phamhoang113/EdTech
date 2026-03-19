import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../app/theme.dart';
import '../../bloc/auth_bloc.dart';
import '../../bloc/auth_event.dart';
import '../../bloc/auth_state.dart';
import '../widgets/dash_stat_card.dart';
import '../widgets/dash_section_header.dart';
import '../widgets/add_person_sheet.dart';

class ParentDashboardScreen extends StatefulWidget {
  const ParentDashboardScreen({super.key});

  @override
  State<ParentDashboardScreen> createState() => _ParentDashboardScreenState();
}

class _ParentDashboardScreenState extends State<ParentDashboardScreen> {
  int _navIndex = 0;

  List<Map<String, String>> _students = [
    {'name': 'Lê Bảo Nguyên', 'meta': 'Lớp 10A2 · Toán, Anh'},
    {'name': 'Lê Minh Khoa',  'meta': 'Lớp 8B · Toán, Lý'},
  ];

  final _upcoming = const [
    {'subject': 'Toán lớp 10',     'who': 'GS Nguyễn Minh Anh', 'time': 'Hôm nay, 19:00', 'emoji': '🧑‍🏫'},
    {'subject': 'Tiếng Anh IELTS', 'who': 'GS Trần Lan Phương',  'time': 'Thứ 6, 08:00',   'emoji': '👩‍🏫'},
  ];

  void _showAddStudent() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddPersonSheet(
        title: 'Thêm học sinh',
        hint: 'Số điện thoại học sinh',
        onConfirm: (phone) => setState(() => _students = [..._students, {'name': phone, 'meta': 'Học sinh mới liên kết'}]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<AuthBloc, AuthState>(
      listener: (ctx, state) { if (state is! AuthAuthenticated) ctx.go('/home'); },
      child: Scaffold(
        appBar: _appBar(context, cs, isDark),
        body: _navIndex == 0 ? _buildHome(isDark) : _buildStudentsTab(isDark),
        bottomNavigationBar: _navBar(cs, isDark),
      ),
    );
  }

  AppBar _appBar(BuildContext context, ColorScheme cs, bool isDark) => AppBar(
    backgroundColor: isDark ? AppTheme.surface : Colors.white,
    elevation: 0,
    title: Row(children: [
      const Text('🎓', style: TextStyle(fontSize: 20)),
      const SizedBox(width: 6),
      Text('EdTech', style: TextStyle(
        fontWeight: FontWeight.w800,
        foreground: Paint()..shader = const LinearGradient(colors: [AppTheme.primary, AppTheme.accent])
            .createShader(const Rect.fromLTWH(0, 0, 80, 20)),
      )),
    ]),
    actions: [
      IconButton(icon: const Icon(Icons.notifications_outlined), onPressed: () {}),
      PopupMenuButton(
        icon: CircleAvatar(
          radius: 16,
          backgroundColor: AppTheme.accent,
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (_, state) {
              final name = state is AuthAuthenticated ? state.user.fullName : '?';
              return Text(name.isNotEmpty ? name[0].toUpperCase() : '?',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13));
            },
          ),
        ),
        itemBuilder: (_) => [PopupMenuItem(
          child: const Text('Đăng xuất'),
          onTap: () => context.read<AuthBloc>().add(const AuthLogoutRequested()),
        )],
      ),
      const SizedBox(width: 8),
    ],
  );

  Widget _buildHome(bool isDark) => SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      BlocBuilder<AuthBloc, AuthState>(builder: (_, state) {
        final name = state is AuthAuthenticated ? state.user.fullName : 'Phụ huynh';
        return _GreetingBanner(name: name, tag: '👨‍👩‍👧 Phụ huynh', emoji: '🏠', isDark: isDark);
      }),
      const SizedBox(height: 16),
      GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: 10, mainAxisSpacing: 10,
        childAspectRatio: 1.8,
        children: [
          DashStatCard(value: '${_students.length}', label: 'Con em đang học',   emoji: '👦', accent: AppTheme.primary),
          const DashStatCard(value: '6',    label: 'Buổi học/tuần',              emoji: '📅', accent: AppTheme.accent),
          const DashStatCard(value: '2.4M', label: 'Chi phí tháng',             emoji: '💰', accent: Color(0xFFF59E0B)),
          const DashStatCard(value: '88%',  label: 'Tiến độ trung bình',        emoji: '📈', accent: Color(0xFF10B981)),
        ],
      ),
      const SizedBox(height: 20),
      DashSectionHeader(title: '📅 Lịch học sắp tới', onTap: () {}),
      const SizedBox(height: 10),
      ..._upcoming.map((c) => _UpcomingTile(c: c, isDark: isDark)),
      const SizedBox(height: 20),
      DashSectionHeader(title: '⚡ Thao tác nhanh', onTap: null),
      const SizedBox(height: 10),
      GridView.count(
        shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 2.4,
        children: const [
          _QACard(emoji: '🔍', label: 'Tìm gia sư'),
          _QACard(emoji: '👶', label: 'Quản lý con'),
          _QACard(emoji: '📅', label: 'Lịch học'),
          _QACard(emoji: '💳', label: 'Thanh toán'),
        ],
      ),
    ]),
  );

  Widget _buildStudentsTab(bool isDark) => ListView(
    padding: const EdgeInsets.all(16),
    children: [
      DashSectionHeader(title: '👦👧 Con em đã liên kết', onTap: _showAddStudent, actionLabel: '+ Thêm'),
      const SizedBox(height: 12),
      ..._students.map((s) => _PersonTile(name: s['name']!, meta: s['meta']!, isDark: isDark)),
      const SizedBox(height: 10),
      OutlinedButton.icon(
        onPressed: _showAddStudent,
        icon: const Icon(Icons.person_add_outlined),
        label: const Text('Thêm học sinh bằng số điện thoại'),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 13),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    ],
  );

  BottomNavigationBar _navBar(ColorScheme cs, bool isDark) => BottomNavigationBar(
    currentIndex: _navIndex,
    onTap: (i) => setState(() => _navIndex = i),
    backgroundColor: isDark ? AppTheme.surface : Colors.white,
    selectedItemColor: cs.primary,
    unselectedItemColor: Colors.grey,
    type: BottomNavigationBarType.fixed,
    items: const [
      BottomNavigationBarItem(icon: Icon(Icons.home_outlined),          label: 'Tổng quan'),
      BottomNavigationBarItem(icon: Icon(Icons.child_care),             label: 'Con em'),
      BottomNavigationBarItem(icon: Icon(Icons.calendar_today_outlined), label: 'Lịch học'),
      BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline),    label: 'Tin nhắn'),
    ],
  );
}

// ─── Local widgets ───────────────────────────────────────────

class _GreetingBanner extends StatelessWidget {
  final String name, tag, emoji;
  final bool isDark;
  const _GreetingBanner({required this.name, required this.tag, required this.emoji, required this.isDark});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF4F46E5), Color(0xFF7C3AED), Color(0xFFA21CAF)]),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: AppTheme.primary.withOpacity(0.3), blurRadius: 18, offset: const Offset(0, 6))],
      ),
      child: Row(children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(_greeting(), style: const TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 4),
          Text(name, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(999)),
            child: Text(tag, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
          ),
        ])),
        Text(emoji, style: const TextStyle(fontSize: 44)),
      ]),
    );
  }
  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Chào buổi sáng 👋';
    if (h < 18) return 'Chào buổi chiều 👋';
    return 'Chào buổi tối 👋';
  }
}

class _UpcomingTile extends StatelessWidget {
  final Map<String, String> c;
  final bool isDark;
  const _UpcomingTile({required this.c, required this.isDark});
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
      child: Row(children: [
        Text(c['emoji']!, style: const TextStyle(fontSize: 22)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(c['subject']!, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
          Text(c['who']!, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
        ])),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
          decoration: BoxDecoration(color: AppTheme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(999)),
          child: Text(c['time']!, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppTheme.primary)),
        ),
      ]),
    );
  }
}

class _PersonTile extends StatelessWidget {
  final String name, meta;
  final bool isDark;
  const _PersonTile({required this.name, required this.meta, required this.isDark});
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
      child: Row(children: [
        CircleAvatar(radius: 20, backgroundColor: AppTheme.primary,
          child: Text(name.isNotEmpty ? name[0].toUpperCase() : '?',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
          Text(meta, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
        ])),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
          decoration: BoxDecoration(color: AppTheme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(999)),
          child: const Text('Đang học', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppTheme.primary)),
        ),
      ]),
    );
  }
}

class _QACard extends StatelessWidget {
  final String emoji, label;
  const _QACard({required this.emoji, required this.label});
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.surface : Colors.white,
          border: Border.all(color: isDark ? Colors.white12 : Colors.grey.shade200),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 8),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
          const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
        ]),
      ),
    );
  }
}
