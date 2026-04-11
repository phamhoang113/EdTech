import 'package:flutter/material.dart';

import '../../app/theme.dart';

/// Gradient hero card used for greeting section on Home screens.
///
/// Displays greeting text, user name, role chip, and optional illustration.
/// Follows mockups 01, 04, 06, 07.
class GradientHeroCard extends StatelessWidget {
  final String greeting;
  final String userName;
  final String? roleLabel;
  final IconData? roleIcon;
  final Widget? trailing;
  final List<Color>? gradientColors;

  const GradientHeroCard({
    super.key,
    required this.greeting,
    required this.userName,
    this.roleLabel,
    this.roleIcon,
    this.trailing,
    this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    final colors = gradientColors ?? AppTheme.heroGradient;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
        boxShadow: [
          BoxShadow(
            color: colors.first.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greeting,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  userName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                if (roleLabel != null) ...[
                  const SizedBox(height: 10),
                  _buildRoleChip(),
                ],  // ignore: use_null_aware_elements
              ],
            ),
          ),
          if (trailing != null) trailing!, // ignore: use_null_aware_elements
        ],
      ),
    );
  }

  Widget _buildRoleChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (roleIcon != null) ...[
            Icon(roleIcon, size: 14, color: Colors.white),
            const SizedBox(width: 4),
          ], // ignore: use_null_aware_elements
          Text(
            roleLabel!,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
