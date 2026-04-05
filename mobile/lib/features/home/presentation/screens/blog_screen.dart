import 'package:flutter/material.dart';

/// Blog screen placeholder — sẽ tích hợp nội dung blog sau.
class BlogScreen extends StatelessWidget {
  const BlogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withAlpha(20),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.article_rounded,
                size: 48,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),

            Text(
              'Blog',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            Text(
              'Bài viết, kinh nghiệm học tập\nvà chia sẻ từ gia sư.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withAlpha(20),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: theme.colorScheme.primary.withAlpha(60)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.construction_rounded, size: 16, color: theme.colorScheme.primary),
                  const SizedBox(width: 6),
                  Text(
                    'Sắp ra mắt',
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
