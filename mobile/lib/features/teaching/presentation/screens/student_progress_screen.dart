import 'package:flutter/material.dart';

import '../../data/datasources/teaching_datasource.dart';

/// PH xem tiến độ BT/KT của con em trong 1 lớp.
class StudentProgressScreen extends StatefulWidget {
  final String classId;
  final String className;

  const StudentProgressScreen({
    super.key,
    required this.classId,
    required this.className,
  });

  @override
  State<StudentProgressScreen> createState() => _StudentProgressScreenState();
}

class _StudentProgressScreenState extends State<StudentProgressScreen> {
  final _dataSource = TeachingDataSource();
  List<Map<String, dynamic>>? _progressList;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      setState(() => _isLoading = true);
      final list = await _dataSource.getClassProgress(widget.classId);
      if (mounted) setState(() { _progressList = list; _isLoading = false; });
    } catch (e) {
      if (mounted) setState(() { _isLoading = false; _progressList = []; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Tiến độ — ${widget.className}'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : (_progressList?.isEmpty ?? true)
              ? _buildEmpty(theme)
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _progressList!.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, index) => _ProgressCard(
                      data: _progressList![index],
                    ),
                  ),
                ),
    );
  }

  Widget _buildEmpty(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80, height: 80,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.trending_up_rounded, size: 40, color: theme.colorScheme.primary),
          ),
          const SizedBox(height: 16),
          Text(
            'Chưa có bài tập/kiểm tra nào',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const _ProgressCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final title = data['assessmentTitle'] as String? ?? '';
    final type = data['type'] as String? ?? 'HOMEWORK';
    final status = data['status'] as String? ?? 'PENDING';
    final score = (data['score'] as num?)?.toDouble();
    final totalScore = (data['totalScore'] as num?)?.toDouble() ?? 10;
    final tutorComment = data['tutorComment'] as String?;
    final closesAt = data['closesAt'] as String?;

    final isExam = type == 'EXAM';
    final statusConfig = _resolveStatus(status);
    final hasScore = score != null;
    final scorePercentage = hasScore ? (score / totalScore).clamp(0.0, 1.0) : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.grey.withValues(alpha: 0.12),
        ),
        boxShadow: isDark ? null : [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: icon + title + status
          Row(
            children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: (isExam ? const Color(0xFFEF4444) : const Color(0xFF6366F1)).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  isExam ? Icons.quiz_rounded : Icons.assignment_rounded,
                  size: 20,
                  color: isExam ? const Color(0xFFEF4444) : const Color(0xFF6366F1),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (closesAt != null)
                      Text(
                        'Hạn: ${_formatDate(closesAt)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontSize: 11,
                        ),
                      ),
                  ],
                ),
              ),
              // Status badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusConfig.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  statusConfig.label,
                  style: TextStyle(
                    color: statusConfig.color,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          // Score bar (nếu đã chấm)
          if (hasScore) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: scorePercentage,
                      backgroundColor: theme.colorScheme.surfaceContainerHighest,
                      color: _scoreColor(scorePercentage),
                      minHeight: 8,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '${score.toStringAsFixed(1)}/${totalScore.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: _scoreColor(scorePercentage),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],

          // Tutor comment
          if (tutorComment != null && tutorComment.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withValues(alpha: 0.03) : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.chat_bubble_outline_rounded, size: 14, color: theme.colorScheme.onSurfaceVariant),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      tutorComment,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        height: 1.4,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _scoreColor(double percentage) {
    if (percentage >= 0.8) return const Color(0xFF10B981);
    if (percentage >= 0.5) return const Color(0xFFF59E0B);
    return const Color(0xFFEF4444);
  }

  _StatusConfig _resolveStatus(String status) {
    switch (status) {
      case 'PENDING': return const _StatusConfig('Chưa nộp', Color(0xFF6B7280));
      case 'SUBMITTED': return const _StatusConfig('Đã nộp', Color(0xFF3B82F6));
      case 'REVIEWING': return const _StatusConfig('Đang chấm', Color(0xFFF59E0B));
      case 'GRADED': return const _StatusConfig('Đã chấm', Color(0xFF10B981));
      case 'COMPLETED': return const _StatusConfig('Hoàn thành', Color(0xFF8B5CF6));
      default: return _StatusConfig(status, const Color(0xFF6B7280));
    }
  }

  String _formatDate(String isoDate) {
    try {
      final dt = DateTime.parse(isoDate);
      return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
    } catch (_) {
      return isoDate;
    }
  }
}

class _StatusConfig {
  final String label;
  final Color color;
  const _StatusConfig(this.label, this.color);
}
