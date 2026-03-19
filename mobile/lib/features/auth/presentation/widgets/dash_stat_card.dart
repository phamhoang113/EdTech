import 'package:flutter/material.dart';
import '../../../../../app/theme.dart';

/// Thẻ thống kê nhỏ dùng chung cho cả 3 dashboards
class DashStatCard extends StatelessWidget {
  final String value, label, emoji;
  final Color accent;
  const DashStatCard({
    super.key,
    required this.value,
    required this.label,
    required this.emoji,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.surface : Colors.white,
        border: Border.all(color: isDark ? Colors.white12 : Colors.grey.shade200),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
            blurRadius: 8, offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: accent.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(child: Text(emoji, style: const TextStyle(fontSize: 17))),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(value, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: accent)),
                Text(label, style: TextStyle(fontSize: 10, color: Colors.grey[500]), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
