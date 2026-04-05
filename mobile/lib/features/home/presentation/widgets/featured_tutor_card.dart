import 'dart:convert';
import 'package:flutter/material.dart';

import '../../../tutor_profile/domain/entities/tutor_public_entity.dart';

/// Card hiển thị thông tin gia sư công khai trên Home screen.
/// Layout ngang: Avatar bên trái — Thông tin bên phải.
class FeaturedTutorCard extends StatelessWidget {
  final TutorPublicEntity tutor;

  const FeaturedTutorCard({super.key, required this.tutor});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subjectText = tutor.subjects.isEmpty
        ? 'Chưa cập nhật'
        : tutor.subjects.join(', ');
    final bioText = (tutor.bio != null && tutor.bio!.isNotEmpty)
        ? tutor.bio!
        : 'Chưa có giới thiệu.';

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Avatar column ──
          Column(
            children: [
              _buildAvatar(theme),
              const SizedBox(height: 6),
              // Rating badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B).withAlpha(25),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star_rounded, size: 13, color: Color(0xFFF59E0B)),
                    const SizedBox(width: 2),
                    Text(
                      tutor.rating > 0 ? tutor.rating.toStringAsFixed(1) : 'Mới',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 10),

          // ── Info column ──
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name
                Text(
                  tutor.fullName,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),

                // Type badge + Experience
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    if (tutor.tutorType != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withAlpha(20),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          _formatTutorType(tutor.tutorType!),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    if (tutor.experienceYears != null && tutor.experienceYears! > 0)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.work_outline, size: 11, color: theme.colorScheme.onSurfaceVariant),
                          const SizedBox(width: 2),
                          Text(
                            '${tutor.experienceYears} năm',
                            style: TextStyle(fontSize: 10, color: theme.colorScheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                  ],
                ),
                const SizedBox(height: 4),

                // Subjects
                Row(
                  children: [
                    Icon(Icons.school_outlined, size: 12, color: theme.colorScheme.primary.withAlpha(180)),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        subjectText,
                        style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurfaceVariant),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),

                // Bio
                Text(
                  bioText,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.3,
                    fontSize: 11,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                // Rating count
                if (tutor.ratingCount > 0) ...[
                  const SizedBox(height: 3),
                  Text(
                    '${tutor.ratingCount} đánh giá',
                    style: TextStyle(fontSize: 10, color: theme.colorScheme.onSurfaceVariant),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(ThemeData theme) {
    final rawBase64 = tutor.avatarBase64;
    final initial = tutor.fullName.isNotEmpty ? tutor.fullName[0].toUpperCase() : '?';

    if (rawBase64 != null && rawBase64.isNotEmpty) {
      try {
        // Strip "data:image/...;base64," prefix if present
        final base64String = rawBase64.contains(',')
            ? rawBase64.split(',').last
            : rawBase64;
        final bytes = base64Decode(base64String);
        return ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Image.memory(
            bytes,
            width: 56,
            height: 56,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _buildFallbackAvatar(theme, initial),
          ),
        );
      } catch (_) {
        // Fallback if base64 decode fails
      }
    }

    return _buildFallbackAvatar(theme, initial);
  }

  Widget _buildFallbackAvatar(ThemeData theme, String initial) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(14),
      ),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 20,
        ),
      ),
    );
  }

  String _formatTutorType(String type) {
    switch (type) {
      case 'STUDENT':
        return 'Sinh viên';
      case 'TEACHER':
        return 'Giáo viên';
      case 'GRADUATED':
        return 'Đã tốt nghiệp';
      default:
        return type;
    }
  }
}
