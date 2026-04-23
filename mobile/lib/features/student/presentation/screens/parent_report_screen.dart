import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/datasources/parent_report_datasource.dart';

/// Màn hình báo cáo tiến độ học tập dành cho phụ huynh.
class ParentReportScreen extends StatefulWidget {
  const ParentReportScreen({super.key});

  @override
  State<ParentReportScreen> createState() => _ParentReportScreenState();
}

class _ParentReportScreenState extends State<ParentReportScreen> {
  late final ParentReportDatasource _datasource;

  List<SimpleClassInfo> _classes = [];
  String? _selectedClassId;
  ProgressSummary? _summary;
  bool _isLoadingClasses = true;
  bool _isLoadingSummary = false;
  String? _error;

  static const _primaryColor = Color(0xFF6366F1);
  static const _amberColor = Color(0xFFF59E0B);
  static const _greenColor = Color(0xFF10B981);
  static const _redColor = Color(0xFFEF4444);
  static const _violetColor = Color(0xFF8B5CF6);

  @override
  void initState() {
    super.initState();
    _datasource = ParentReportDatasource(getIt<DioClient>().dio);
    _loadClasses();
  }

  Future<void> _loadClasses() async {
    try {
      final classes = await _datasource.getParentClasses();
      if (mounted) {
        setState(() {
          _classes = classes;
          _isLoadingClasses = false;
          if (classes.isNotEmpty) {
            _selectedClassId = classes.first.id;
          }
        });
        if (_selectedClassId != null) _loadSummary(_selectedClassId!);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingClasses = false;
          _error = 'Không thể tải danh sách lớp.';
        });
      }
    }
  }

  Future<void> _loadSummary(String classId) async {
    setState(() { _isLoadingSummary = true; _error = null; });
    try {
      final summary = await _datasource.getProgressSummary(classId);
      if (mounted) setState(() { _summary = summary; _isLoadingSummary = false; });
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingSummary = false;
          _error = 'Không thể tải báo cáo cho lớp này.';
          _summary = null;
        });
      }
    }
  }

  void _onClassChanged(String? classId) {
    if (classId == null || classId == _selectedClassId) return;
    setState(() { _selectedClassId = classId; _summary = null; });
    _loadSummary(classId);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await _loadClasses();
          },
          child: CustomScrollView(
            slivers: [
              // ── Header ──
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [_primaryColor, _violetColor],
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.bar_chart_rounded,
                                color: Colors.white, size: 20),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Báo cáo học tập',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Class selector
                      _buildClassSelector(theme),
                    ],
                  ),
                ),
              ),

              // ── Body ──
              if (_isLoadingClasses || _isLoadingSummary)
                const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (_error != null)
                SliverFillRemaining(child: _buildError(theme))
              else if (_summary == null || _summary!.details.isEmpty)
                SliverFillRemaining(child: _buildEmpty(theme))
              else ...[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        _buildSummaryCards(theme),
                        const SizedBox(height: 16),
                        _buildScoreChart(theme),
                        const SizedBox(height: 16),
                        _buildAssessmentSection(
                          title: 'Bài tập',
                          icon: Icons.book_outlined,
                          color: _primaryColor,
                          items: _summary!.details
                              .where((d) => d.type == 'HOMEWORK')
                              .toList(),
                          theme: theme,
                        ),
                        const SizedBox(height: 16),
                        _buildAssessmentSection(
                          title: 'Kiểm tra',
                          icon: Icons.quiz_outlined,
                          color: _amberColor,
                          items: _summary!.details
                              .where((d) => d.type == 'EXAM')
                              .toList(),
                          theme: theme,
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // ── Class Selector ──────────────────────────────────────────────────────────

  Widget _buildClassSelector(ThemeData theme) {
    if (_isLoadingClasses) {
      return const LinearProgressIndicator();
    }
    if (_classes.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.colorScheme.outlineVariant),
        ),
        child: Text(
          'Chưa có lớp học nào đang hoạt động.',
          style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedClassId,
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down_rounded,
              color: theme.colorScheme.onSurfaceVariant),
          items: _classes.map((c) {
            return DropdownMenuItem(
              value: c.id,
              child: Text('${c.title} (${c.subject})',
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium),
            );
          }).toList(),
          onChanged: _onClassChanged,
        ),
      ),
    );
  }

  // ── Summary Cards ───────────────────────────────────────────────────────────

  Widget _buildSummaryCards(ThemeData theme) {
    final s = _summary!;
    final pendingColor = s.pendingHomeworkCount > 0 ? _redColor : _greenColor;

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1.5,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _StatCard(
          icon: Icons.book_outlined,
          label: 'ĐTB Bài tập',
          value: s.homeworkAvgScore > 0
              ? s.homeworkAvgScore.toStringAsFixed(1)
              : '—',
          subtext: '${s.totalHomework} bài',
          color: _primaryColor,
        ),
        _StatCard(
          icon: Icons.quiz_outlined,
          label: 'ĐTB Kiểm tra',
          value: s.examAvgScore > 0
              ? s.examAvgScore.toStringAsFixed(1)
              : '—',
          subtext: '${s.totalExam} bài',
          color: _amberColor,
        ),
        _StatCard(
          icon: Icons.assignment_late_outlined,
          label: 'BT Chưa nộp',
          value: '${s.pendingHomeworkCount}',
          subtext: s.pendingHomeworkCount > 0 ? 'Cần hoàn thành!' : 'Tốt lắm! 👏',
          color: pendingColor,
        ),
        _StatCard(
          icon: Icons.schedule_rounded,
          label: 'KT Sắp tới',
          value: '${s.upcomingExamCount}',
          subtext: s.upcomingExamCount > 0 ? 'Chuẩn bị ôn tập' : 'Không có KT tới',
          color: _violetColor,
        ),
      ],
    );
  }

  // ── Score Chart ──────────────────────────────────────────────────────────────

  Widget _buildScoreChart(ThemeData theme) {
    final gradedItems = _summary!.details
        .where((d) => d.score != null &&
            (d.status == 'GRADED' || d.status == 'COMPLETED'))
        .toList()
        .reversed
        .toList();

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.trending_up_rounded,
                  size: 18, color: _primaryColor),
              const SizedBox(width: 6),
              Text('Biểu đồ điểm số',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  )),
            ],
          ),
          const SizedBox(height: 12),
          if (gradedItems.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text('Chưa có điểm số để hiển thị.',
                    style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
              ),
            )
          else
            SizedBox(
              height: 200,
              child: CustomPaint(
                painter: _ScoreChartPainter(
                  items: gradedItems,
                  isDark: theme.brightness == Brightness.dark,
                ),
                child: const SizedBox.expand(),
              ),
            ),
          // Legend
          if (gradedItems.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  _LegendDot(color: _primaryColor, label: 'Bài tập'),
                  const SizedBox(width: 16),
                  _LegendDot(color: _amberColor, label: 'Kiểm tra', dashed: true),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // ── Assessment Section ───────────────────────────────────────────────────────

  Widget _buildAssessmentSection({
    required String title,
    required IconData icon,
    required Color color,
    required List<StudentProgressItem> items,
    required ThemeData theme,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              children: [
                Icon(icon, size: 18, color: color),
                const SizedBox(width: 8),
                Text('$title (${items.length})',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    )),
              ],
            ),
          ),
          const Divider(height: 1),
          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text('Chưa có $title nào.',
                    style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
              ),
            )
          else
            ...items.map((item) => _AssessmentRow(item: item, theme: theme)),
        ],
      ),
    );
  }

  // ── Empty / Error States ─────────────────────────────────────────────────────

  Widget _buildEmpty(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.emoji_events_outlined,
                size: 64, color: theme.colorScheme.outlineVariant),
            const SizedBox(height: 12),
            Text(
              _classes.isEmpty
                  ? 'Chưa có lớp học nào đang hoạt động.'
                  : 'Chưa có bài tập hoặc kiểm tra nào trong lớp này.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: theme.colorScheme.onSurfaceVariant, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline_rounded,
                size: 56, color: theme.colorScheme.error.withOpacity(0.5)),
            const SizedBox(height: 12),
            Text(_error ?? 'Đã có lỗi xảy ra.',
                textAlign: TextAlign.center,
                style: TextStyle(color: theme.colorScheme.error)),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _loadClasses,
              icon: const Icon(Icons.refresh),
              label: const Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Stat Card Widget
// ─────────────────────────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String subtext;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.subtext,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    letterSpacing: 0.3,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: color,
              height: 1,
            ),
          ),
          Text(
            subtext,
            style: TextStyle(
              fontSize: 11,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Assessment Row Widget
// ─────────────────────────────────────────────────────────────────────────────

class _AssessmentRow extends StatelessWidget {
  final StudentProgressItem item;
  final ThemeData theme;

  const _AssessmentRow({required this.item, required this.theme});

  static const _statusConfig = {
    'PENDING':   (label: 'Chưa nộp',   color: Color(0xFFEF4444)),
    'SUBMITTED': (label: 'Đã nộp',     color: Color(0xFFF59E0B)),
    'GRADED':    (label: 'Đã chấm',    color: Color(0xFF10B981)),
    'COMPLETED': (label: 'Hoàn thành', color: Color(0xFF6366F1)),
  };

  @override
  Widget build(BuildContext context) {
    final cfg = _statusConfig[item.status] ??
        (label: 'Chưa nộp', color: const Color(0xFFEF4444));
    final isOverdue = item.status == 'PENDING' &&
        item.closesAt != null &&
        item.closesAt!.isBefore(DateTime.now());
    final gradeInfo = item.score != null ? _gradeLabel(item.score!) : null;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: theme.colorScheme.outlineVariant)),
      ),
      child: Row(
        children: [
          // Title + deadline
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.assessmentTitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (item.closesAt != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    '${isOverdue ? '⚠️ Quá hạn' : '📅 Hạn nộp'}: ${_formatDate(item.closesAt!)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isOverdue
                          ? const Color(0xFFEF4444)
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Status badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: cfg.color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              cfg.label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: cfg.color,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Score
          SizedBox(
            width: 52,
            child: item.score != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${item.score}/${item.totalScore?.toInt() ?? 10}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: gradeInfo?.color,
                        ),
                      ),
                      if (gradeInfo != null)
                        Text(
                          gradeInfo.label,
                          style: TextStyle(
                            fontSize: 10,
                            color: gradeInfo.color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                    ],
                  )
                : Text('—',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        color: theme.colorScheme.onSurfaceVariant)),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) =>
      DateFormat('dd/MM/yy').format(dt);

  ({String label, Color color}) _gradeLabel(double score) {
    if (score >= 9) return (label: 'Xuất sắc', color: const Color(0xFF059669));
    if (score >= 8) return (label: 'Giỏi',     color: const Color(0xFF10B981));
    if (score >= 6.5) return (label: 'Khá',    color: const Color(0xFFF59E0B));
    if (score >= 5) return (label: 'TB',        color: const Color(0xFFF97316));
    return (label: 'Yếu', color: const Color(0xFFEF4444));
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Score Chart CustomPainter
// ─────────────────────────────────────────────────────────────────────────────

class _ScoreChartPainter extends CustomPainter {
  final List<StudentProgressItem> items;
  final bool isDark;

  const _ScoreChartPainter({required this.items, required this.isDark});

  static const _hwColor = Color(0xFF6366F1);
  static const _examColor = Color(0xFFF59E0B);
  static const _gridColor = Color(0x26475569);

  @override
  void paint(Canvas canvas, Size size) {
    final homeworks = items.where((d) => d.type == 'HOMEWORK').toList();
    final exams = items.where((d) => d.type == 'EXAM').toList();

    const pad = EdgeInsets.only(top: 20, right: 20, bottom: 30, left: 32);
    final chartRect = Rect.fromLTWH(
      pad.left,
      pad.top,
      size.width - pad.left - pad.right,
      size.height - pad.top - pad.bottom,
    );

    _drawGrid(canvas, chartRect);
    _drawLine(canvas, chartRect, homeworks, _hwColor);
    _drawLine(canvas, chartRect, exams, _examColor, dashed: true);
  }

  void _drawGrid(Canvas canvas, Rect chart) {
    final paint = Paint()
      ..color = _gridColor
      ..strokeWidth = 1;
    final labelPaint = TextPainter(textDirection: ui.TextDirection.ltr);

    for (var i = 0; i <= 10; i += 2) {
      final y = chart.bottom - (i / 10) * chart.height;
      canvas.drawLine(Offset(chart.left, y), Offset(chart.right, y), paint);
      labelPaint
        ..text = TextSpan(
          text: '$i',
          style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8)),
        )
        ..layout()
        ..paint(canvas, Offset(chart.left - 24, y - 6));
    }
  }

  void _drawLine(
    Canvas canvas,
    Rect chart,
    List<StudentProgressItem> items,
    Color color, {
    bool dashed = false,
  }) {
    if (items.isEmpty) return;

    final n = items.length;
    final stepX = n == 1 ? chart.width / 2 : chart.width / (n - 1);

    List<Offset> points = [];
    for (var i = 0; i < n; i++) {
      final x = chart.left + (n == 1 ? chart.width / 2 : i * stepX);
      final y = chart.bottom - ((items[i].score ?? 0) / 10) * chart.height;
      points.add(Offset(x, y));
    }

    // Draw line
    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    if (dashed) {
      _drawDashedPath(canvas, points, linePaint);
    } else {
      final path = Path()..moveTo(points.first.dx, points.first.dy);
      for (final p in points.skip(1)) {
        path.lineTo(p.dx, p.dy);
      }
      canvas.drawPath(path, linePaint);
    }

    // Draw dots + score labels
    for (final p in points) {
      canvas.drawCircle(p, 5, Paint()..color = Colors.white);
      canvas.drawCircle(
          p, 5, Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 2.5);
      final textPainter = TextPainter(
        text: TextSpan(
          text: items[points.indexOf(p)].score.toString(),
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        textDirection: ui.TextDirection.ltr,
      )..layout();
      textPainter.paint(canvas, Offset(p.dx - textPainter.width / 2, p.dy - 18));
    }
  }

  void _drawDashedPath(Canvas canvas, List<Offset> points, Paint paint) {
    const dashLen = 6.0;
    const gapLen = 3.0;
    for (var i = 0; i < points.length - 1; i++) {
      final start = points[i];
      final end = points[i + 1];
      final dx = end.dx - start.dx;
      final dy = end.dy - start.dy;
      final dist = math.sqrt(dx * dx + dy * dy);
      final nx = dx / dist;
      final ny = dy / dist;
      double d = 0;
      bool draw = true;
      while (d < dist) {
        final len = math.min(draw ? dashLen : gapLen, dist - d);
        if (draw) {
          canvas.drawLine(
            Offset(start.dx + nx * d, start.dy + ny * d),
            Offset(start.dx + nx * (d + len), start.dy + ny * (d + len)),
            paint,
          );
        }
        d += len;
        draw = !draw;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ScoreChartPainter old) =>
      old.items != items || old.isDark != isDark;
}

// ─────────────────────────────────────────────────────────────────────────────
// Legend Dot Widget
// ─────────────────────────────────────────────────────────────────────────────

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  final bool dashed;

  const _LegendDot({required this.color, required this.label, this.dashed = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomPaint(
          size: const Size(24, 2),
          painter: _LinePainter(color: color, dashed: dashed),
        ),
        const SizedBox(width: 6),
        Text(label,
            style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurfaceVariant)),
      ],
    );
  }
}

class _LinePainter extends CustomPainter {
  final Color color;
  final bool dashed;

  const _LinePainter({required this.color, required this.dashed});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..strokeWidth = 2.5;
    if (!dashed) {
      canvas.drawLine(Offset.zero, Offset(size.width, 0), paint);
    } else {
      double x = 0;
      while (x < size.width) {
        canvas.drawLine(Offset(x, 0), Offset(math.min(x + 6, size.width), 0), paint);
        x += 9;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _LinePainter old) =>
      old.color != color || old.dashed != dashed;
}
