import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/models/teaching_models.dart';

/// Widget hiển thị danh sách bài tập/kiểm tra dạng card.
class AssessmentListWidget extends StatelessWidget {
  final List<AssessmentModel> assessments;
  final bool isTutor;
  final Future<void> Function() onRefresh;
  final void Function(AssessmentModel assessment)? onTap;

  const AssessmentListWidget({
    super.key,
    required this.assessments,
    required this.isTutor,
    required this.onRefresh,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      itemCount: assessments.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) => _AssessmentCard(
        assessment: assessments[index],
        isTutor: isTutor,
        onTap: onTap != null ? () => onTap!(assessments[index]) : null,
      ),
    );
  }
}

class _AssessmentCard extends StatelessWidget {
  final AssessmentModel assessment;
  final bool isTutor;
  final VoidCallback? onTap;

  const _AssessmentCard({required this.assessment, required this.isTutor, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isOverdue = assessment.isOverdue;
    final isExam = assessment.isExam;

    final statusColor = isOverdue
        ? Colors.red.shade400
        : isExam ? const Color(0xFFF59E0B) : const Color(0xFF10B981);
    final statusText = isOverdue
        ? 'Hết hạn'
        : isExam ? 'Kiểm tra' : 'Đang mở';

    return GestureDetector(
      onTap: onTap,
      child: Container(
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: title + status chip
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: (isExam ? const Color(0xFFF59E0B) : theme.colorScheme.primary)
                        .withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    isExam ? Icons.quiz_rounded : Icons.assignment_rounded,
                    color: isExam ? const Color(0xFFF59E0B) : theme.colorScheme.primary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        assessment.title,
                        style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (assessment.description != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            assessment.description!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Info row: deadline + duration
            Row(
              children: [
                // Deadline
                if (assessment.closesAt != null)
                  _InfoChip(
                    icon: Icons.schedule_rounded,
                    label: 'Hạn: ${DateFormat('dd/MM HH:mm').format(assessment.closesAt!)}',
                    color: isOverdue ? Colors.red.shade400 : theme.colorScheme.onSurfaceVariant,
                  ),

                // Duration (EXAM)
                if (assessment.durationMin != null) ...[
                  const SizedBox(width: 12),
                  _InfoChip(
                    icon: Icons.timer_rounded,
                    label: '${assessment.durationMin} phút',
                    color: const Color(0xFFF59E0B),
                  ),
                ],

                const Spacer(),

                // Score
                _InfoChip(
                  icon: Icons.star_rounded,
                  label: '${assessment.totalScore.toStringAsFixed(0)} điểm',
                  color: theme.colorScheme.primary,
                ),
              ],
            ),

            // Tutor: submission progress bar
            if (isTutor && assessment.submittedCount != null) ...[
              const SizedBox(height: 14),
              _buildSubmissionProgress(theme, assessment),
            ],

            // Attachment badge
            if (assessment.attachmentName != null) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.attach_file_rounded, size: 14, color: theme.colorScheme.primary),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        assessment.attachmentName!,
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
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

  Widget _buildSubmissionProgress(ThemeData theme, AssessmentModel assessment) {
    final submitted = assessment.submittedCount ?? 0;
    final hasTotalStudents = assessment.totalStudents != null && assessment.totalStudents! > 0;
    final total = assessment.totalStudents ?? submitted;
    final ratio = hasTotalStudents ? (submitted / total).clamp(0.0, 1.0) : 1.0;

    final progressColor = submitted == 0
        ? Colors.grey.shade400
        : ratio >= 1.0
            ? const Color(0xFF10B981)
            : const Color(0xFF3B82F6);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.people_outline_rounded, size: 14, color: progressColor),
            const SizedBox(width: 6),
            Text(
              hasTotalStudents ? '$submitted / $total HS đã nộp' : '$submitted bài nộp',
              style: TextStyle(fontSize: 12, color: progressColor, fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            if (hasTotalStudents)
              Text(
                '${(ratio * 100).round()}%',
                style: TextStyle(fontSize: 11, color: progressColor, fontWeight: FontWeight.w700),
              ),
          ],
        ),
        if (hasTotalStudents) ...[
          const SizedBox(height: 5),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: ratio,
              backgroundColor: progressColor.withValues(alpha: 0.12),
              color: progressColor,
              minHeight: 5,
            ),
          ),
        ],
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoChip({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
