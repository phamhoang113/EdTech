import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../home/data/datasources/home_remote_datasource.dart';
import '../../../home/domain/entities/upcoming_session_entity.dart';

/// Tab Lịch học — Calendar view cá nhân hóa cho PH/HS.
class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedMonth = DateTime.now();
  List<UpcomingSessionEntity> _sessions = [];
  bool _loading = true;
  String? _error;

  // Cache: month key → sessions
  final Map<String, List<UpcomingSessionEntity>> _cache = {};

  @override
  void initState() {
    super.initState();
    _loadMonthSessions(_focusedMonth);
  }

  String _monthKey(DateTime d) => '${d.year}-${d.month}';

  Future<void> _loadMonthSessions(DateTime month) async {
    final key = _monthKey(month);
    if (_cache.containsKey(key)) {
      setState(() {
        _sessions = _cache[key]!;
        _loading = false;
        _error = null;
      });
      return;
    }

    setState(() => _loading = true);

    try {
      final authState = context.read<AuthBloc>().state;
      final role = (authState is AuthAuthenticated) ? authState.user.role : 'PARENT';

      final firstDay = DateTime(month.year, month.month, 1);
      final lastDay = DateTime(month.year, month.month + 1, 0);

      final ds = getIt<HomeRemoteDataSource>();
      final startStr = _formatDateApi(firstDay);
      final endStr = _formatDateApi(lastDay);

      // Reuse datasource logic — gọi API sessions theo khoảng ngày
      final response = await ds.getUpcomingSessionsRange(role, startStr, endStr);

      _cache[key] = response;
      if (mounted) {
        setState(() {
          _sessions = response;
          _loading = false;
          _error = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = 'Lỗi tải lịch: $e';
        });
      }
    }
  }

  String _formatDateApi(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  List<UpcomingSessionEntity> _sessionsForDate(DateTime date) {
    final dateStr = _formatDateApi(date);
    return _sessions.where((s) => s.sessionDate == dateStr).toList();
  }

  bool _hasSession(DateTime date) {
    final dateStr = _formatDateApi(date);
    return _sessions.any((s) => s.sessionDate == dateStr);
  }

  void _onMonthChanged(int delta) {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + delta, 1);
    });
    _loadMonthSessions(_focusedMonth);
  }

  String _formatVietnameseDate(DateTime date) {
    const weekdays = ['Chủ nhật', 'Thứ 2', 'Thứ 3', 'Thứ 4', 'Thứ 5', 'Thứ 6', 'Thứ 7'];
    final weekday = weekdays[date.weekday % 7];
    return '$weekday, ${date.day} tháng ${date.month}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sessionsToday = _sessionsForDate(_selectedDate);

    return RefreshIndicator(
      onRefresh: () async {
        _cache.remove(_monthKey(_focusedMonth));
        await _loadMonthSessions(_focusedMonth);
      },
      child: ListView(
        padding: const EdgeInsets.only(bottom: 100),
        children: [
          // ── Month navigation ──
          _buildMonthHeader(theme),

          // ── Calendar grid ──
          _buildCalendarGrid(theme),

          const SizedBox(height: 16),

          // ── Selected date sessions ──
          _buildDateLabel(theme),

          if (_loading)
            const Padding(
              padding: EdgeInsets.all(40),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_error != null)
            _buildErrorWidget(theme)
          else if (sessionsToday.isEmpty)
            _buildEmptyDay(theme)
          else
            ...sessionsToday.map((s) => _SessionCard(session: s)),
        ],
      ),
    );
  }

  // ─── Month Header ───────────────────────────────────────
  Widget _buildMonthHeader(ThemeData theme) {
    final monthName = 'Tháng ${_focusedMonth.month}/${_focusedMonth.year}';
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => _onMonthChanged(-1),
            icon: const Icon(Icons.chevron_left),
            style: IconButton.styleFrom(
              backgroundColor: theme.colorScheme.surfaceContainerHighest.withAlpha(80),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _focusedMonth = DateTime.now();
                _selectedDate = DateTime.now();
              });
              _loadMonthSessions(_focusedMonth);
            },
            child: Text(
              monthName,
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            onPressed: () => _onMonthChanged(1),
            icon: const Icon(Icons.chevron_right),
            style: IconButton.styleFrom(
              backgroundColor: theme.colorScheme.surfaceContainerHighest.withAlpha(80),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Calendar Grid ───────────────────────────────────────
  Widget _buildCalendarGrid(ThemeData theme) {
    final firstDay = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    final lastDay = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0);
    final startWeekday = firstDay.weekday; // 1=Mon
    final totalDays = lastDay.day;
    final today = DateTime.now();

    const dayLabels = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          // Day headers
          Row(
            children: dayLabels.map((d) => Expanded(
              child: Center(
                child: Text(
                  d,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: d == 'CN' ? const Color(0xFFEF4444) : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            )).toList(),
          ),
          const SizedBox(height: 8),
          // Day cells
          ..._buildWeekRows(firstDay, startWeekday, totalDays, today, theme),
        ],
      ),
    );
  }

  List<Widget> _buildWeekRows(DateTime firstDay, int startWeekday, int totalDays, DateTime today, ThemeData theme) {
    final rows = <Widget>[];
    int dayNum = 1 - (startWeekday - 1); // offset to fill blanks

    while (dayNum <= totalDays) {
      final cells = <Widget>[];
      for (int w = 0; w < 7; w++) {
        if (dayNum < 1 || dayNum > totalDays) {
          cells.add(const Expanded(child: SizedBox(height: 44)));
        } else {
          final date = DateTime(firstDay.year, firstDay.month, dayNum);
          final isToday = date.year == today.year && date.month == today.month && date.day == today.day;
          final isSelected = date.year == _selectedDate.year &&
              date.month == _selectedDate.month &&
              date.day == _selectedDate.day;
          final hasData = _hasSession(date);
          final dayVal = dayNum;

          cells.add(Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedDate = date),
              child: Container(
                height: 44,
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : isToday
                          ? theme.colorScheme.primary.withAlpha(20)
                          : null,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(
                      '$dayVal',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isToday || isSelected ? FontWeight.w700 : FontWeight.w400,
                        color: isSelected
                            ? Colors.white
                            : isToday
                                ? theme.colorScheme.primary
                                : null,
                      ),
                    ),
                    if (hasData && !isSelected)
                      Positioned(
                        bottom: 4,
                        child: Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ));
        }
        dayNum++;
      }
      rows.add(Row(children: cells));
    }
    return rows;
  }

  // ─── Date Label ───────────────────────────────────────
  Widget _buildDateLabel(ThemeData theme) {
    final label = _formatVietnameseDate(_selectedDate);
    final sessionsCount = _sessionsForDate(_selectedDate).length;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Row(
        children: [
          Text(
            label[0].toUpperCase() + label.substring(1),
            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          if (sessionsCount > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withAlpha(20),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$sessionsCount buổi',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: theme.colorScheme.primary),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyDay(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Icon(Icons.event_busy_outlined, size: 40, color: theme.colorScheme.onSurfaceVariant.withAlpha(120)),
          const SizedBox(height: 8),
          Text(
            'Không có buổi học nào',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFEF4444).withAlpha(10),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFEF4444).withAlpha(40)),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: Color(0xFFEF4444)),
            const SizedBox(width: 12),
            Expanded(child: Text(_error ?? '', style: theme.textTheme.bodyMedium)),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// SESSION CARD
// ═══════════════════════════════════════════════════════════
class _SessionCard extends StatelessWidget {
  final UpcomingSessionEntity session;

  const _SessionCard({required this.session});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusConfig = _resolveStatus(session.status);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: statusConfig.color.withAlpha(40)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(6),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Time column
            Container(
              width: 56,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: statusConfig.color.withAlpha(15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Text(
                    _formatTime(session.startTime),
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: statusConfig.color),
                  ),
                  Text(
                    _formatTime(session.endTime),
                    style: TextStyle(fontSize: 11, color: statusConfig.color.withAlpha(180)),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            // Info
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
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.menu_book, size: 13, color: theme.colorScheme.onSurfaceVariant),
                      const SizedBox(width: 4),
                      Text(
                        session.subject,
                        style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                      ),
                      if (session.tutorName != null) ...[
                        const SizedBox(width: 10),
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
            // Status badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusConfig.color.withAlpha(15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                statusConfig.label,
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: statusConfig.color),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(String time) => time.length >= 5 ? time.substring(0, 5) : time;

  _StatusConfig _resolveStatus(String status) {
    switch (status) {
      case 'SCHEDULED':
        return const _StatusConfig('Đã lên lịch', Color(0xFF6366F1));
      case 'DRAFT':
        return const _StatusConfig('Nháp', Color(0xFF6B7280));
      case 'COMPLETED':
        return const _StatusConfig('Hoàn thành', Color(0xFF10B981));
      case 'CANCELLED':
      case 'CANCELLED_BY_TUTOR':
      case 'CANCELLED_BY_STUDENT':
        return const _StatusConfig('Đã hủy', Color(0xFFEF4444));
      default:
        return _StatusConfig(status, const Color(0xFF6B7280));
    }
  }
}

class _StatusConfig {
  final String label;
  final Color color;
  const _StatusConfig(this.label, this.color);
}
