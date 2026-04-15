import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/datasources/teaching_datasource.dart';

/// HS nộp bài tập — chụp ảnh trực tiếp (nhiều tờ) hoặc chọn file.
///
/// Tính năng nổi bật:
/// - Chụp nhiều ảnh liên tiếp bằng camera (cho bài viết tay)
/// - Chọn nhiều ảnh từ thư viện
/// - Chọn file (PDF, Word, Excel)
/// - Preview lưới ảnh + xóa từng ảnh
/// - Upload tất cả cùng lúc
class SubmitAssignmentScreen extends StatefulWidget {
  final String assessmentId;

  const SubmitAssignmentScreen({super.key, required this.assessmentId});

  @override
  State<SubmitAssignmentScreen> createState() => _SubmitAssignmentScreenState();
}

class _SubmitAssignmentScreenState extends State<SubmitAssignmentScreen> {
  final _dataSource = TeachingDataSource();
  final _imagePicker = ImagePicker();

  // Danh sách file sẽ nộp: {path, name, type: 'image'|'file'}
  final List<_SubmitFile> _files = [];

  bool _isSubmitting = false;

  // ── Chụp ảnh bằng camera ──
  Future<void> _capturePhoto() async {
    final photo = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
      preferredCameraDevice: CameraDevice.rear,
    );

    if (photo != null) {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      setState(() {
        _files.add(_SubmitFile(
          path: photo.path,
          name: 'anh_bai_lam_$timestamp.jpg',
          type: _FileType.image,
        ));
      });

      // Hỏi có muốn chụp thêm không
      if (mounted) _askCaptureMore();
    }
  }

  // ── Hỏi chụp thêm ảnh ──
  void _askCaptureMore() {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Icon(Icons.check_circle_rounded, color: const Color(0xFF10B981), size: 48),
            const SizedBox(height: 12),
            Text(
              'Đã chụp ${_files.where((f) => f.type == _FileType.image).length} ảnh',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              'Muốn chụp thêm trang tiếp theo?',
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.pop(ctx),
                    icon: const Icon(Icons.done_rounded),
                    label: const Text('Xong'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      _capturePhoto();
                    },
                    icon: const Icon(Icons.camera_alt_rounded),
                    label: const Text('Chụp tiếp'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Chọn nhiều ảnh từ thư viện ──
  Future<void> _pickImages() async {
    final photos = await _imagePicker.pickMultiImage(imageQuality: 85);
    if (photos.isNotEmpty) {
      setState(() {
        for (final photo in photos) {
          _files.add(_SubmitFile(
            path: photo.path,
            name: photo.name,
            type: _FileType.image,
          ));
        }
      });
    }
  }

  // ── Chọn file tài liệu ──
  Future<void> _pickFile() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'xls', 'xlsx'],
      allowMultiple: true,
    );

    if (result != null) {
      setState(() {
        for (final f in result.files) {
          if (f.path != null) {
            _files.add(_SubmitFile(
              path: f.path!,
              name: f.name,
              type: _FileType.document,
            ));
          }
        }
      });
    }
  }

  // ── Xóa file ──
  void _removeFile(int index) {
    setState(() => _files.removeAt(index));
  }

  // ── Submit ──
  Future<void> _submit() async {
    if (_files.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng thêm ít nhất 1 ảnh hoặc file bài làm.')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final fileList = _files
          .map((f) => {'path': f.path, 'name': f.name})
          .toList();

      await _dataSource.submitAssignment(
        assessmentId: widget.assessmentId,
        files: fileList,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Nộp bài thành công!'),
            backgroundColor: Color(0xFF10B981),
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi nộp bài: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final imageFiles = _files.where((f) => f.type == _FileType.image).toList();
    final docFiles = _files.where((f) => f.type == _FileType.document).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nộp bài làm'),
        centerTitle: true,
        actions: [
          if (_files.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${_files.length} file',
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Action buttons ──
                  _buildActionButtons(theme, isDark),

                  const SizedBox(height: 24),

                  // ── Image grid preview ──
                  if (imageFiles.isNotEmpty) ...[
                    _buildSectionLabel(theme, Icons.photo_library_rounded, 'Ảnh bài làm (${imageFiles.length})'),
                    const SizedBox(height: 10),
                    _buildImageGrid(theme, imageFiles),
                    const SizedBox(height: 20),
                  ],

                  // ── Document list ──
                  if (docFiles.isNotEmpty) ...[
                    _buildSectionLabel(theme, Icons.description_rounded, 'File tài liệu (${docFiles.length})'),
                    const SizedBox(height: 10),
                    _buildDocList(theme, isDark, docFiles),
                    const SizedBox(height: 20),
                  ],

                  // Empty state
                  if (_files.isEmpty) _buildEmptyState(theme, isDark),
                ],
              ),
            ),
          ),

          // ── Sticky bottom bar ──
          _buildBottomBar(theme),
        ],
      ),
    );
  }

  Widget _buildActionButtons(ThemeData theme, bool isDark) {
    return Column(
      children: [
        // Camera button — nổi bật nhất
        _ActionButton(
          icon: Icons.camera_alt_rounded,
          label: 'Chụp ảnh bài làm',
          sublabel: 'Chụp từng trang, nhiều ảnh',
          color: theme.colorScheme.primary,
          isDark: isDark,
          onTap: _capturePhoto,
          isPrimary: true,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _ActionButton(
                icon: Icons.photo_library_rounded,
                label: 'Thư viện',
                sublabel: 'Chọn nhiều ảnh',
                color: const Color(0xFF8B5CF6),
                isDark: isDark,
                onTap: _pickImages,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ActionButton(
                icon: Icons.attach_file_rounded,
                label: 'File',
                sublabel: 'PDF, Word, Excel',
                color: const Color(0xFF3B82F6),
                isDark: isDark,
                onTap: _pickFile,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionLabel(ThemeData theme, IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 16, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Text(label, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
      ],
    );
  }

  Widget _buildImageGrid(ThemeData theme, List<_SubmitFile> images) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: images.length,
      itemBuilder: (_, index) {
        final file = images[index];
        final globalIndex = _files.indexOf(file);
        return Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(File(file.path), fit: BoxFit.cover),
            ),
            // Page number badge
            Positioned(
              left: 6, bottom: 6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Trang ${index + 1}',
                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            // Delete button
            Positioned(
              top: 4, right: 4,
              child: GestureDetector(
                onTap: () => _removeFile(globalIndex),
                child: Container(
                  width: 24, height: 24,
                  decoration: BoxDecoration(
                    color: Colors.red.shade600,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close_rounded, color: Colors.white, size: 16),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDocList(ThemeData theme, bool isDark, List<_SubmitFile> docs) {
    return Column(
      children: docs.map((file) {
        final globalIndex = _files.indexOf(file);
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.grey.shade200,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.description_rounded, color: Color(0xFF3B82F6), size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      file.name,
                      style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      _formatFileSize(File(file.path).lengthSync()),
                      style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded, color: Colors.red, size: 20),
                onPressed: () => _removeFile(globalIndex),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEmptyState(ThemeData theme, bool isDark) {
    return Container(
      height: 280,
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.03)
            : theme.colorScheme.primary.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.grey.withValues(alpha: 0.15),
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72, height: 72,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.camera_alt_rounded, size: 36, color: theme.colorScheme.primary),
          ),
          const SizedBox(height: 16),
          Text(
            'Chưa có file nào',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            'Chụp ảnh bài làm hoặc chọn file bên trên',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(ThemeData theme) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 12, 20, MediaQuery.of(context).padding.bottom + 12),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(top: BorderSide(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4))),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 12, offset: const Offset(0, -4))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Progress bar khi đang upload
          if (_isSubmitting) ...[
            LinearProgressIndicator(
              borderRadius: BorderRadius.circular(4),
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 10),
          ],

          FilledButton.icon(
            onPressed: (_isSubmitting || _files.isEmpty) ? null : _submit,
            icon: _isSubmitting
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Icon(Icons.send_rounded),
            label: Text(
              _isSubmitting
                  ? 'Đang nộp...'
                  : _files.isEmpty
                      ? 'Chưa có file'
                      : 'Nộp ${_files.length} file bài làm',
            ),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1048576) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / 1048576).toStringAsFixed(1)} MB';
  }
}

// ── Action button cho camera/gallery/file ──
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sublabel;
  final Color color;
  final bool isDark;
  final VoidCallback onTap;
  final bool isPrimary;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.sublabel,
    required this.color,
    required this.isDark,
    required this.onTap,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(isPrimary ? 20 : 14),
        decoration: BoxDecoration(
          color: isDark
              ? color.withValues(alpha: 0.08)
              : color.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(isPrimary ? 18 : 14),
          border: Border.all(color: color.withValues(alpha: isPrimary ? 0.35 : 0.2)),
        ),
        child: Row(
          children: [
            Container(
              width: isPrimary ? 52 : 40,
              height: isPrimary ? 52 : 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(isPrimary ? 14 : 10),
              ),
              child: Icon(icon, color: color, size: isPrimary ? 28 : 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w700,
                      fontSize: isPrimary ? 16 : 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    sublabel,
                    style: TextStyle(
                      color: color.withValues(alpha: 0.7),
                      fontSize: isPrimary ? 13 : 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isPrimary ? Icons.arrow_forward_ios_rounded : Icons.add_rounded,
              color: color.withValues(alpha: 0.5),
              size: isPrimary ? 16 : 20,
            ),
          ],
        ),
      ),
    );
  }
}

// ── File model ──
enum _FileType { image, document }

class _SubmitFile {
  final String path;
  final String name;
  final _FileType type;

  const _SubmitFile({required this.path, required this.name, required this.type});
}
