import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/models/teaching_models.dart';
import '../utils/file_download_helper.dart';

/// Widget hiển thị danh sách tài liệu dạng card.
class MaterialListWidget extends StatelessWidget {
  final List<MaterialModel> materials;
  final bool isTutor;
  final Future<void> Function(String id) onDelete;
  final Future<void> Function() onRefresh;

  const MaterialListWidget({
    super.key,
    required this.materials,
    required this.isTutor,
    required this.onDelete,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      itemCount: materials.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) => _MaterialCard(
        material: materials[index],
        isTutor: isTutor,
        onDelete: onDelete,
      ),
    );
  }
}

class _MaterialCard extends StatelessWidget {
  final MaterialModel material;
  final bool isTutor;
  final Future<void> Function(String id) onDelete;

  const _MaterialCard({
    required this.material,
    required this.isTutor,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final iconData = _getIconForType(material.type);
    final iconColor = _getColorForType(material.type);
    final sizeText = _formatFileSize(material.fileSize);
    final dateText = DateFormat('dd/MM/yyyy').format(material.createdAt);

    return Container(
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
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(iconData, color: iconColor, size: 24),
        ),
        title: Text(
          material.title,
          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Row(
            children: [
              if (material.fileName != null) ...[
                Flexible(
                  child: Text(
                    material.fileName!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Text(
                sizeText,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Text(
                dateText,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Download
            IconButton(
              icon: Icon(Icons.download_rounded, color: theme.colorScheme.primary, size: 22),
              onPressed: () => FileDownloadHelper.openDownloadUrl(context, material.downloadUrl),
            ),
            // Xóa (chỉ GS)
            if (isTutor)
              IconButton(
                icon: Icon(Icons.delete_outline_rounded, color: Colors.red.shade400, size: 22),
                onPressed: () => _confirmDelete(context),
              ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xóa tài liệu'),
        content: Text('Bạn có chắc muốn xóa "${material.title}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Hủy')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              onDelete(material.id);
            },
            child: Text('Xóa', style: TextStyle(color: Colors.red.shade400)),
          ),
        ],
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'DOCUMENT': return Icons.description_rounded;
      case 'VIDEO': return Icons.play_circle_rounded;
      case 'IMAGE': return Icons.image_rounded;
      case 'LINK': return Icons.link_rounded;
      default: return Icons.insert_drive_file_rounded;
    }
  }

  Color _getColorForType(String type) {
    switch (type) {
      case 'DOCUMENT': return const Color(0xFF6366F1); // Indigo
      case 'VIDEO': return const Color(0xFFEF4444); // Red
      case 'IMAGE': return const Color(0xFF10B981); // Green
      case 'LINK': return const Color(0xFF3B82F6); // Blue
      default: return const Color(0xFF8B5CF6); // Violet
    }
  }

  String _formatFileSize(int? bytes) {
    if (bytes == null) return '';
    if (bytes < 1024) return '${bytes}B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)}KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
  }
}
