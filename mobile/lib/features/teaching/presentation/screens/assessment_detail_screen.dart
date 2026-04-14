import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../data/datasources/teaching_datasource.dart';
import '../../data/models/teaching_models.dart';
import '../utils/file_download_helper.dart';
import 'submit_assignment_screen.dart';
import 'submission_list_screen.dart';

/// Chi tiết bài tập/kiểm tra — điểm vào chung cho GS (xem bài nộp) và HS (nộp bài).
class AssessmentDetailScreen extends StatefulWidget {
  final String assessmentId;

  const AssessmentDetailScreen({super.key, required this.assessmentId});

  @override
  State<AssessmentDetailScreen> createState() => _AssessmentDetailScreenState();
}

class _AssessmentDetailScreenState extends State<AssessmentDetailScreen> {
  final _dataSource = TeachingDataSource();
  AssessmentModel? _assessment;
  SubmissionModel? _mySubmission; // HS: bài nộp của mình
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    try {
      setState(() => _isLoading = true);
      final detail = await _dataSource.getAssessmentDetail(widget.assessmentId);

      // HS và PH (nộp thay con): tự động load bài nộp nếu có
      SubmissionModel? mySub;
      if (_userRole == 'STUDENT' || _userRole == 'PARENT') {
        try {
          mySub = await _dataSource.getMySubmission(widget.assessmentId);
        } catch (_) {}
      }

      if (mounted) {
        setState(() {
          _assessment = detail;
          _mySubmission = mySub;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String? get _userRole {
    final state = context.read<AuthBloc>().state;
    if (state is AuthAuthenticated) return state.user.role;
    return null;
  }

  bool get _notStarted {
    if (_assessment == null) return false;
    if (!_assessment!.isExam) return false;
    if (_assessment!.opensAt == null) return false;
    return DateTime.now().isBefore(_assessment!.opensAt!);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(_assessment?.isExam == true ? 'Chi tiết kiểm tra' : 'Chi tiết bài tập'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _assessment == null
              ? const Center(child: Text('Không tìm thấy.'))
              : RefreshIndicator(
                  onRefresh: _loadDetail,
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      _buildHeader(theme, isDark),
                      const SizedBox(height: 20),
                      _buildTimeSection(theme, isDark),
                      if (_assessment!.description != null) ...[
                        const SizedBox(height: 20),
                        _buildDescription(theme, isDark),
                      ],
                      if (_assessment!.attachmentName != null) ...[
                        const SizedBox(height: 16),
                        _buildAttachment(theme),
                      ],
                      const SizedBox(height: 24),
                      _buildActions(theme),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
    );
  }

  Widget _buildHeader(ThemeData theme, bool isDark) {
    final a = _assessment!;
    final isExam = a.isExam;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isExam
              ? [const Color(0xFFF59E0B), const Color(0xFFEF4444)]
              : [const Color(0xFF6366F1), const Color(0xFF8B5CF6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (isExam ? const Color(0xFFF59E0B) : const Color(0xFF6366F1))
                .withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isExam ? Icons.quiz_rounded : Icons.assignment_rounded,
                color: Colors.white,
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  a.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _HeaderChip(
                icon: Icons.star_rounded,
                label: '${a.totalScore.toStringAsFixed(0)} điểm',
              ),
              if (a.durationMin != null) ...[
                const SizedBox(width: 10),
                _HeaderChip(
                  icon: Icons.timer_rounded,
                  label: '${a.durationMin} phút',
                ),
              ],
              if (a.isPublished) ...[
                const SizedBox(width: 10),
                const _HeaderChip(
                  icon: Icons.check_circle_rounded,
                  label: 'Đã publish',
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSection(ThemeData theme, bool isDark) {
    final a = _assessment!;
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.grey.shade200,
        ),
      ),
      child: Column(
        children: [
          if (a.opensAt != null)
            _TimeRow(
              icon: Icons.play_circle_outline_rounded,
              label: 'Bắt đầu',
              value: dateFormat.format(a.opensAt!),
              color: theme.colorScheme.primary,
            ),
          if (a.closesAt != null) ...[
            if (a.opensAt != null && a.isExam) ...[
              _TimeRow(
                icon: Icons.play_circle_outline_rounded,
                label: 'Mở lúc',
                value: dateFormat.format(a.opensAt!),
                color: _notStarted ? const Color(0xFFF59E0B) : theme.colorScheme.primary,
              ),
              const SizedBox(height: 10),
            ],
            _TimeRow(
              icon: Icons.event_rounded,
              label: a.isExam ? 'Kết thúc' : 'Deadline',
              value: dateFormat.format(a.closesAt!),
              color: a.isOverdue ? Colors.red : theme.colorScheme.primary,
            ),
          ],
          if (a.isOverdue) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.warning_amber_rounded, size: 16, color: Colors.red.shade400),
                  const SizedBox(width: 6),
                  Text(
                    'ĐÃ HẾT HẠN',
                    style: TextStyle(
                      color: Colors.red.shade400,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
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

  Widget _buildDescription(ThemeData theme, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Yêu cầu', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text(
            _assessment!.description!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachment(ThemeData theme) {
    if (_notStarted) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            const Icon(Icons.lock_rounded, color: Colors.grey),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _assessment!.attachmentName!,
                    style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  const Text('Chưa đến giờ tải đề', style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: () => FileDownloadHelper.openDownloadUrl(context, _assessment!.attachmentDownloadUrl),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Icon(Icons.attach_file_rounded, color: theme.colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _assessment!.attachmentName!,
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Tải xuống file đề',
                    style: TextStyle(
                      color: theme.colorScheme.primary.withValues(alpha: 0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.download_rounded, color: theme.colorScheme.primary),
          ],
        ),
      ),
    );
  }

  Widget _buildActions(ThemeData theme) {
    final role = _userRole;

    if (role == 'TUTOR') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Publish (nếu chưa publish)
          if (!_assessment!.isPublished)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: OutlinedButton.icon(
                onPressed: _publishAssessment,
                icon: const Icon(Icons.send_rounded),
                label: const Text('Publish & Thông báo'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: BorderSide(color: theme.colorScheme.primary),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
          // Xem bài nộp
          FilledButton.icon(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SubmissionListScreen(assessmentId: widget.assessmentId),
                ),
              );
              _loadDetail();
            },
            icon: const Icon(Icons.grading_rounded),
            label: Text('Xem bài nộp (${_assessment!.submittedCount ?? 0})'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      );
    }

    if (role == 'STUDENT' || role == 'PARENT') {
      // HS/PH đã nộp → hiển thị trạng thái
      if (_mySubmission != null) {
        return _buildMySubmissionCard(theme);
      }

      // Chưa nộp + chưa hết hạn
      if (!_assessment!.isOverdue) {
        if (_notStarted) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF59E0B).withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.timer_rounded, color: Color(0xFFF59E0B)),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Chưa tới giờ làm bài',
                    style: TextStyle(color: Color(0xFFF59E0B), fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          );
        }

        return FilledButton.icon(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SubmitAssignmentScreen(assessmentId: widget.assessmentId),
              ),
            );
            if (result == true && mounted) _loadDetail();
          },
          icon: const Icon(Icons.upload_file_rounded),
          label: const Text('Nộp bài'),
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        );
      }

      // Hết hạn + chưa nộp
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.red.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red.shade400),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Đã hết hạn nộp bài',
                style: TextStyle(color: Colors.red.shade600, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }

  /// Card hiển thị trạng thái bài nộp của HS
  Widget _buildMySubmissionCard(ThemeData theme) {
    final s = _mySubmission!;
    final isDark = theme.brightness == Brightness.dark;
    final statusLabel = SubmissionModel.getStatusLabel(s.status);
    final statusColor = SubmissionModel.statusColor(s.status);
    final hasScore = s.score != null;
    final hasComment = s.tutorComment != null && s.tutorComment!.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.grey.shade200),
        boxShadow: isDark ? null : [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(Icons.check_circle_outline_rounded, color: statusColor, size: 22),
              const SizedBox(width: 10),
              Text('Bài nộp của bạn', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(statusLabel, style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.w700)),
              ),
            ],
          ),

          // Điểm
          if (hasScore) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                Text('Điểm:', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
                const Spacer(),
                Text(
                  s.score!.toStringAsFixed(1),
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: statusColor),
                ),
              ],
            ),
          ],

          // GS comment
          if (hasComment) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withValues(alpha: 0.03) : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nhận xét của GS', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(
                    s.tutorComment!,
                    style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant, height: 1.4),
                  ),
                ],
              ),
            ),
          ],

          // File sửa bài GS
          if (s.tutorFileDownloadUrl != null) ...[
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () => FileDownloadHelper.openDownloadUrl(context, s.tutorFileDownloadUrl),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.file_download_outlined, size: 18, color: theme.colorScheme.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        s.tutorFileName ?? 'File sửa bài',
                        style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.w600, fontSize: 13),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(Icons.download_rounded, size: 18, color: theme.colorScheme.primary),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _publishAssessment() async {
    try {
      await _dataSource.publishAssessment(widget.assessmentId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đã publish & gửi thông báo!'),
            backgroundColor: Color(0xFF10B981),
          ),
        );
        _loadDetail();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi publish: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }
}

class _HeaderChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _HeaderChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _TimeRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _TimeRow({required this.icon, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 10),
        Text(label, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w500)),
        const Spacer(),
        Text(value, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w700)),
      ],
    );
  }
}
