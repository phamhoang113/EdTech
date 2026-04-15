import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import '../../data/datasources/teaching_datasource.dart';
import '../../data/models/teaching_models.dart';
import '../utils/file_download_helper.dart';

/// GS chấm điểm 1 bài nộp — nhập điểm, comment, upload file sửa bài.
class GradeSubmissionScreen extends StatefulWidget {
  final SubmissionModel submission;

  const GradeSubmissionScreen({super.key, required this.submission});

  @override
  State<GradeSubmissionScreen> createState() => _GradeSubmissionScreenState();
}

class _GradeSubmissionScreenState extends State<GradeSubmissionScreen> {
  final _dataSource = TeachingDataSource();
  final _scoreController = TextEditingController();
  final _commentController = TextEditingController();

  String? _tutorFilePath;
  String? _tutorFileName;
  bool _isSaving = false;
  bool _isCompleting = false;

  bool get _isAlreadyGraded => widget.submission.isGraded;
  bool get _isCompleted => widget.submission.isCompleted;

  @override
  void initState() {
    super.initState();
    final s = widget.submission;
    if (s.totalScore != null) _scoreController.text = s.totalScore!.toStringAsFixed(1);
    if (s.tutorComment != null) _commentController.text = s.tutorComment!;
  }

  @override
  void dispose() {
    _scoreController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _pickTutorFile() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _tutorFilePath = result.files.single.path!;
        _tutorFileName = result.files.single.name;
      });
    }
  }

  Future<void> _saveGrade() async {
    final scoreText = _scoreController.text.trim();
    final score = double.tryParse(scoreText);
    final comment = _commentController.text.trim();

    if (scoreText.isNotEmpty && score == null) {
      _showError('Điểm phải là số hợp lệ.');
      return;
    }

    setState(() => _isSaving = true);

    try {
      await _dataSource.gradeSubmission(
        submissionId: widget.submission.id,
        score: score,
        comment: comment.isEmpty ? null : comment,
        tutorFilePath: _tutorFilePath,
        tutorFileName: _tutorFileName,
      );

      if (mounted) {
        _showSuccess('Đã lưu chấm điểm!');
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        _showError('Lỗi: $e');
      }
    }
  }

  Future<void> _markComplete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.check_circle_outline_rounded, color: Color(0xFF8B5CF6)),
            SizedBox(width: 10),
            Text('Hoàn thành'),
          ],
        ),
        content: const Text('Đánh dấu hoàn thành? File sẽ tự động xóa sau 7 ngày.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Hủy')),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFF8B5CF6)),
            child: const Text('Xác nhận'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isCompleting = true);

    try {
      await _dataSource.markComplete(widget.submission.id);

      if (mounted) {
        _showSuccess('Đã đánh dấu hoàn thành!');
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isCompleting = false);
        _showError('Lỗi: $e');
      }
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red),
    );
  }

  void _showSuccess(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: const Color(0xFF10B981)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final s = widget.submission;

    return Scaffold(
      appBar: AppBar(
        title: Text(s.studentName ?? 'Chấm bài'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // ── Status banner ──
          _buildStatusBanner(theme, s),

          // ── Scrollable content ──
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Student file info
                  _buildStudentFileSection(theme, isDark, s),

                  const SizedBox(height: 24),

                  // Existing score display (nếu đã chấm)
                  if (_isAlreadyGraded && s.totalScore != null) ...[
                    _buildCurrentScoreBadge(theme, s),
                    const SizedBox(height: 20),
                  ],

                  // ── Score input ──
                  _buildSectionLabel(theme, Icons.star_rounded, 'Điểm số'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _scoreController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: InputDecoration(
                            hintText: 'VD: 8.5',
                            prefixIcon: const Icon(Icons.star_rounded),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Max score badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.06)
                              : theme.colorScheme.primary.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: theme.colorScheme.primary.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Text(
                          '/ 10',
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ── Comment ──
                  _buildSectionLabel(theme, Icons.comment_rounded, 'Nhận xét'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _commentController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Nhận xét cho học sinh...',
                      prefixIcon: const Padding(
                        padding: EdgeInsets.only(bottom: 72),
                        child: Icon(Icons.comment_rounded),
                      ),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── Tutor file upload ──
                  _buildSectionLabel(theme, Icons.upload_file_rounded, 'File sửa bài'),
                  const SizedBox(height: 8),

                  // Existing tutor file
                  if (s.tutorFileName != null && _tutorFilePath == null)
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              s.tutorFileName!,
                              style: const TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.w500),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),

                  GestureDetector(
                    onTap: _pickTutorFile,
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.04)
                            : theme.colorScheme.primary.withValues(alpha: 0.04),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: _tutorFilePath != null
                              ? theme.colorScheme.primary
                              : isDark ? Colors.white.withValues(alpha: 0.12) : Colors.grey.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _tutorFilePath != null ? Icons.attach_file_rounded : Icons.upload_file_rounded,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _tutorFilePath != null ? _tutorFileName! : 'Chọn file sửa bài (PDF, Word, Ảnh)',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: _tutorFilePath != null
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.onSurfaceVariant,
                                fontWeight: _tutorFilePath != null ? FontWeight.w600 : null,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // ── Sticky Bottom Action Bar ──
      bottomNavigationBar: _buildBottomBar(theme, s),
    );
  }

  Widget _buildStatusBanner(ThemeData theme, SubmissionModel s) {
    final color = _statusColor(s.status);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: color.withValues(alpha: 0.08),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 8, height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(
            s.statusLabel,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
          if (s.submittedAt != null) ...[
            const SizedBox(width: 12),
            Icon(Icons.schedule_rounded, size: 13, color: color.withValues(alpha: 0.7)),
            const SizedBox(width: 4),
            Text(
              _formatDateTime(s.submittedAt!),
              style: TextStyle(
                color: color.withValues(alpha: 0.8),
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCurrentScoreBadge(ThemeData theme, SubmissionModel s) {
    final score = s.totalScore!;
    final color = score >= 8 ? const Color(0xFF10B981) : score >= 5 ? const Color(0xFFF59E0B) : Colors.red;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.12), color.withValues(alpha: 0.04)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 52, height: 52,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                score.toStringAsFixed(1),
                style: TextStyle(
                  color: color,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Điểm đã lưu',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: color.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '$score / 10',
                  style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 16),
                ),
                if (s.tutorComment != null && s.tutorComment!.isNotEmpty)
                  Text(
                    s.tutorComment!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: color.withValues(alpha: 0.7),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          Icon(Icons.edit_rounded, size: 16, color: color.withValues(alpha: 0.6)),
        ],
      ),
    );
  }

  Widget _buildStudentFileSection(ThemeData theme, bool isDark, SubmissionModel s) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bài nộp của học sinh',
            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),

          if (s.fileName != null)
            Row(
              children: [
                Icon(Icons.description_rounded, size: 20, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    s.fileName!,
                    style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.download_rounded, color: theme.colorScheme.primary, size: 22),
                  onPressed: () => FileDownloadHelper.openDownloadUrl(context, s.downloadUrl),
                ),
              ],
            )
          else
            Text(
              'Không có file đính kèm',
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(ThemeData theme, IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 16, color: theme.colorScheme.primary),
        const SizedBox(width: 6),
        Text(
          label,
          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }

  Widget _buildBottomBar(ThemeData theme, SubmissionModel s) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 12, 20, MediaQuery.of(context).padding.bottom + 12),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Mark complete button (nếu đã chấm và chưa complete)
          if (_isAlreadyGraded && !_isCompleted) ...[
            Expanded(
              flex: 2,
              child: OutlinedButton.icon(
                onPressed: _isCompleting ? null : _markComplete,
                icon: _isCompleting
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.check_circle_outline_rounded, size: 18),
                label: Text(_isCompleting ? '...' : 'Hoàn thành'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: Color(0xFF8B5CF6)),
                  foregroundColor: const Color(0xFF8B5CF6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],

          // Save button
          Expanded(
            flex: 3,
            child: FilledButton.icon(
              onPressed: _isSaving ? null : _saveGrade,
              icon: _isSaving
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.save_rounded),
              label: Text(_isSaving ? 'Đang lưu...' : 'Lưu chấm điểm'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'SUBMITTED': return const Color(0xFF3B82F6);
      case 'REVIEWING': return const Color(0xFFF59E0B);
      case 'GRADED': return const Color(0xFF10B981);
      case 'COMPLETED': return const Color(0xFF8B5CF6);
      default: return const Color(0xFF6B7280);
    }
  }
}
