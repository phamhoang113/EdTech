import 'package:flutter/material.dart';

/// Section header row dùng chung
class DashSectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final String actionLabel;
  const DashSectionHeader({
    super.key,
    required this.title,
    this.onTap,
    this.actionLabel = 'Xem tất cả',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
        const Spacer(),
        if (onTap != null)
          TextButton(
            onPressed: onTap,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              actionLabel,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
      ],
    );
  }
}
