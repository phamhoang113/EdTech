import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../app/theme.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/dash_stat_card.dart';
import '../widgets/dash_section_header.dart';
import '../../../../app/theme.dart';
import '../../../../core/di/injection.dart';
import '../../../tutor_profile/presentation/bloc/tutor_profile_bloc.dart';
import '../../../tutor_profile/presentation/bloc/tutor_profile_event.dart';
import '../../../tutor_profile/presentation/bloc/tutor_profile_state.dart';

class TutorDashboardScreen extends StatefulWidget {
  const TutorDashboardScreen({super.key});

  @override
  State<TutorDashboardScreen> createState() => _TutorDashboardScreenState();
}

class _TutorDashboardScreenState extends State<TutorDashboardScreen> {
  int _navIndex = 0;
  final _profileBloc = getIt<TutorProfileBloc>();

  @override
  void initState() {
    super.initState();
    _profileBloc.add(LoadTutorProfile());
  }

  final _upcomingLessons = const [
    {'subject': 'Toán lớp 10',      'who': 'Lê Bảo Nguyên',  'time': 'Hôm nay, 19:00', 'emoji': '👦'},
    {'subject': 'Tiếng Anh IELTS',  'who': 'Trần Hồng Nhung', 'time': 'Thứ 5, 15:00',   'emoji': '👧'},
    {'subject': 'Lập trình Python',  'who': 'Lớp mở (12 HS)', 'time': 'Thứ 7, 14:00',   'emoji': '💻'},
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<AuthBloc, AuthState>(
      listener: (ctx, state) { if (state is! AuthAuthenticated && state is! AuthLoading) ctx.go('/home'); },
      child: BlocProvider.value(
        value: _profileBloc,
        child: BlocBuilder<TutorProfileBloc, TutorProfileState>(
          builder: (context, profileState) {
            String verificationStatus = 'UNVERIFIED';
            if (profileState is TutorProfileLoaded) {
              verificationStatus = profileState.profile.verificationStatus;
            } else if (profileState is TutorProfileVerificationSuccess) {
              verificationStatus = profileState.profile.verificationStatus;
            }

            return Column(
                children: [
                  // Inline action row
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(icon: const Icon(Icons.notifications_outlined), onPressed: () {}),
                        PopupMenuButton(
                          icon: CircleAvatar(
                            radius: 16,
                            backgroundColor: const Color(0xFF10B981),
                            child: BlocBuilder<AuthBloc, AuthState>(builder: (_, state) {
                              final name = state is AuthAuthenticated ? (state.user.name ?? '?') : '?';
                              return Text(name.isNotEmpty ? name[0].toUpperCase() : '?',
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13));
                            }),
                          ),
                          itemBuilder: (_) => [PopupMenuItem(
                            child: const Text('Đăng xuất'),
                            onTap: () => context.read<AuthBloc>().add(AuthLogoutRequested()),
                          )],
                        ),
                      ],
                    ),
                  ),
                  if (verificationStatus == 'UNVERIFIED')
                    Container(
                      width: double.infinity,
                      color: Colors.orange.shade100,
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          const Text(
                            'Trạng thái tài khoản: CHƯA XÁC THỰC',
                            style: TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () => context.push('/tutor/verify'),
                            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accent),
                            child: const Text('Xác thực ngay', style: TextStyle(color: Colors.white)),
                          )
                        ],
                      ),
                    ),
                  if (verificationStatus == 'PENDING')
                    Container(
                      width: double.infinity,
                      color: Colors.blue.shade100,
                      padding: const EdgeInsets.all(12),
                      child: const Text(
                        'Hồ sơ của bạn đang được duyệt. Vui lòng chờ!',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    ),
                  // Inline tab selector
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isDark ? AppTheme.surface.withAlpha(120) : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        _tabButton('Tổng quan', Icons.home_outlined, 0, cs),
                        _tabButton('Học sinh', Icons.people_outline, 1, cs),
                      ],
                    ),
                  ),
                  Expanded(
                    child: _navIndex == 0 ? _buildHome(isDark, verificationStatus) : _buildStudentsTab(isDark),
                  ),
                ],
            );
          }
        ),
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

  Widget _buildHome(bool isDark, String status) => SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      BlocBuilder<AuthBloc, AuthState>(builder: (_, state) {
        final name = state is AuthAuthenticated ? (state.user.name ?? 'Gia sư') : 'Gia sư';
        return _TutorGreeting(name: name, isDark: isDark);
      }),
      const SizedBox(height: 16),

      // Stats
      GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: 10, mainAxisSpacing: 10,
        childAspectRatio: 1.8,
        children: const <Widget>[
          DashStatCard(value: '12',    label: 'Học sinh',       emoji: '👥', accent: AppTheme.primary),
          DashStatCard(value: '4',     label: 'Lớp đang dạy',  emoji: '📖', accent: AppTheme.accent),
          DashStatCard(value: '4.9★',  label: 'Đánh giá',      emoji: '⭐', accent: Color(0xFFF59E0B)),
          DashStatCard(value: '8.4M',  label: 'Doanh thu T3',  emoji: '💰', accent: Color(0xFF10B981)),
        ],
      ),
      const SizedBox(height: 20),

      DashSectionHeader(title: '📅 Lịch dạy sắp tới', onTap: () {}),
      const SizedBox(height: 10),
      ..._upcomingLessons.map((c) => _LessonTile(c: c, isDark: isDark)),
      const SizedBox(height: 20),

      DashSectionHeader(title: '⚡ Thao tác nhanh', onTap: null),
      const SizedBox(height: 10),
      GridView.count(
        shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 2.4,
        children: [
          _QACard(emoji: '📅', label: 'Lịch dạy', enabled: status == 'APPROVED'),
          _QACard(emoji: '💬', label: 'Tin nhắn', enabled: true),
          _QACard(emoji: '👤', label: 'Hồ sơ gia sư', enabled: true),
          _QACard(emoji: '📊', label: 'Báo cáo doanh thu', enabled: status == 'APPROVED'),
        ],
      ),
    ]),
  );

  Widget _buildStudentsTab(bool isDark) {
    final students = [
      {'name': 'Lê Bảo Nguyên',   'meta': 'Toán lớp 10 · 3 buổi/tuần'},
      {'name': 'Trần Hồng Nhung', 'meta': 'Tiếng Anh IELTS · 2 buổi/tuần'},
      {'name': 'Lớp Python',       'meta': '12 học sinh · Thứ 7'},
    ];
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        DashSectionHeader(title: '👥 Học sinh của tôi', onTap: null),
        const SizedBox(height: 12),
        ...students.map((s) => Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark ? AppTheme.surface : Colors.white,
            border: Border.all(color: isDark ? Colors.white12 : Colors.grey.shade200),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(children: [
            CircleAvatar(radius: 20, backgroundColor: AppTheme.primary,
              child: Text(s['name']![0].toUpperCase(),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700))),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(s['name']!, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
              Text(s['meta']!, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
            ])),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withOpacity(0.1),
                borderRadius: BorderRadius.circular(999),
              ),
              child: const Text('Đang học', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF10B981))),
            ),
          ]),
        )),
      ],
    );
  }
}

// ─── Widgets ───────────────────────────────────────────────────

class _TutorGreeting extends StatelessWidget {
  final String name;
  final bool isDark;
  const _TutorGreeting({required this.name, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final h = DateTime.now().hour;
    final greet = h < 12 ? 'Chào buổi sáng 👋' : h < 18 ? 'Chào buổi chiều 👋' : 'Chào buổi tối 👋';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF4F46E5), Color(0xFF7C3AED), Color(0xFFA21CAF)]),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: AppTheme.primary.withOpacity(0.3), blurRadius: 18, offset: const Offset(0, 6))],
      ),
      child: Row(children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(greet, style: const TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 4),
          Text(name, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(999)),
            child: const Text('👩‍🏫 Gia sư', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
          ),
        ])),
        const Text('📖', style: TextStyle(fontSize: 44)),
      ]),
    );
  }
}

class _LessonTile extends StatelessWidget {
  final Map<String, String> c;
  final bool isDark;
  const _LessonTile({required this.c, required this.isDark});
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

class _QACard extends StatelessWidget {
  final String emoji, label;
  final bool enabled;
  const _QACard({required this.emoji, required this.label, this.enabled = true});
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: enabled ? () {} : null,
      child: Opacity(
        opacity: enabled ? 1.0 : 0.5,
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
      ),
    );
  }
}
