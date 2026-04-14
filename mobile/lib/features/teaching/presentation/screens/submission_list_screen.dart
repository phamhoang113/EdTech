import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/datasources/teaching_datasource.dart';
import '../../data/models/teaching_models.dart';
import 'grade_submission_screen.dart';

/// GS xem danh sách bài nộp cho 1 assessment.
class SubmissionListScreen extends StatefulWidget {
  final String assessmentId;

  const SubmissionListScreen({super.key, required this.assessmentId});

  @override
  State<SubmissionListScreen> createState() => _SubmissionListScreenState();
}

class _SubmissionListScreenState extends State<SubmissionListScreen> {
  final _dataSource = TeachingDataSource();
  List<SubmissionModel>? _submissions;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      setState(() => _isLoading = true);
      final list = await _dataSource.getSubmissions(widget.assessmentId);
      if (mounted) setState(() { _submissions = list; _isLoading = false; });
    } catch (e) {
      if (mounted) setState(() { _isLoading = false; _submissions = []; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách bài nộp'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : (_submissions?.isEmpty ?? true)
              ? _buildEmpty(theme)
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _submissions!.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, index) => _SubmissionCard(
                      submission: _submissions![index],
                      onTap: () => _openGrading(_submissions![index]),
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
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.inbox_rounded, size: 40, color: theme.colorScheme.primary),
          ),
          const SizedBox(height: 16),
          Text(
            'Chưa có bài nộp nào',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _openGrading(SubmissionModel submission) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GradeSubmissionScreen(submission: submission),
      ),
    );
    if (result == true && mounted) _load();
  }
}

class _SubmissionCard extends StatelessWidget {
  final SubmissionModel submission;
  final VoidCallback onTap;

  const _SubmissionCard({required this.submission, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final statusColor = _statusColor(submission.status);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.grey.withValues(alpha: 0.12),
          ),
          boxShadow: isDark
              ? null
              : [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.person_rounded, color: statusColor, size: 22),
            ),
            const SizedBox(width: 12),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    submission.studentName ?? 'Học sinh',
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          submission.statusLabel,
                          style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.w700),
                        ),
                      ),
                      if (submission.submittedAt != null) ...[
                        const SizedBox(width: 8),
                        Text(
                          DateFormat('dd/MM HH:mm').format(submission.submittedAt!),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            // Score
            if (submission.totalScore != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  submission.totalScore!.toStringAsFixed(1),
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ] else
              Icon(Icons.chevron_right_rounded, color: theme.colorScheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'SUBMITTED': return const Color(0xFF3B82F6);
      case 'REVIEWING': return const Color(0xFFF59E0B);
      case 'GRADED': return const Color(0xFF10B981);
      case 'COMPLETED': return const Color(0xFF8B5CF6);
      case 'ARCHIVED': return const Color(0xFF6B7280);
      default: return const Color(0xFF6B7280);
    }
  }
}
