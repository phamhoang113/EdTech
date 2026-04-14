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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đã lưu chấm điểm!'),
            backgroundColor: Color(0xFF10B981),
          ),
        );
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
        title: const Text('Hoàn thành'),
        content: const Text('Đánh dấu hoàn thành? File sẽ tự động xóa sau 7 ngày.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Hủy')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Xác nhận')),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isCompleting = true);

    try {
      await _dataSource.markComplete(widget.submission.id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đã đánh dấu hoàn thành!'),
            backgroundColor: Color(0xFF10B981),
          ),
        );
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final s = widget.submission;

    return Scaffold(
      appBar: AppBar(
        title: Text(s.studentName ?? 'Chấm bài'),
        centerTitle: true,
        actions: [
          if (s.isGraded && !s.isCompleted)
            TextButton(
              onPressed: _isCompleting ? null : _markComplete,
              child: _isCompleting
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Hoàn thành', style: TextStyle(fontWeight: FontWeight.w700)),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Student file info
            _buildStudentFileSection(theme, isDark, s),

            const SizedBox(height: 24),

            // Score
            Text('Điểm số', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            TextFormField(
              controller: _scoreController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                hintText: 'Nhập điểm (VD: 8.5)',
                prefixIcon: const Icon(Icons.star_rounded),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),

            const SizedBox(height: 20),

            // Comment
            Text('Nhận xét', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
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

            // Tutor file upload
            Text('File sửa bài', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
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
                          color: _tutorFilePath != null ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
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

            const SizedBox(height: 32),

            // Save button
            FilledButton.icon(
              onPressed: _isSaving ? null : _saveGrade,
              icon: _isSaving
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.save_rounded),
              label: Text(_isSaving ? 'Đang lưu...' : 'Lưu chấm điểm'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
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
            ),

          if (s.submittedAt != null) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.schedule_rounded, size: 14, color: theme.colorScheme.onSurfaceVariant),
                const SizedBox(width: 6),
                Text(
                  'Nộp lúc: ${_formatDateTime(s.submittedAt!)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],

          // Status
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _statusColor(s.status).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              s.statusLabel,
              style: TextStyle(
                color: _statusColor(s.status),
                fontSize: 12,
                fontWeight: FontWeight.w700,
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
