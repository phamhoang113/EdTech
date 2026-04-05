import 'package:flutter/material.dart';

/// Màn hình "Tính năng đang phát triển" cho các tab chưa hoàn thiện.
class ComingSoonScreen extends StatelessWidget {
  final String featureName;
  final IconData icon;

  const ComingSoonScreen({
    super.key,
    required this.featureName,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Animated icon container
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withAlpha(20),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 48,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),

            // Feature name
            Text(
              featureName,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Description
            Text(
              'Tính năng này đang được phát triển.\nVui lòng quay lại sau!',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Coming soon badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF59E0B).withAlpha(20),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: const Color(0xFFF59E0B).withAlpha(60)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.construction_rounded, size: 16, color: Color(0xFFF59E0B)),
                  SizedBox(width: 6),
                  Text(
                    'Đang phát triển',
                    style: TextStyle(
                      color: Color(0xFFF59E0B),
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
