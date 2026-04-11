import 'package:flutter/material.dart';

import '../../../../app/router.dart';

import '../../../../app/theme.dart';
import '../../../../shared/widgets/animated_counter.dart';

/// Hero banner + Stats row for Guest Home (mockup 01).
///
/// Shows gradient hero card "Tìm Gia Sư Tinh Hoa" with CTA,
/// followed by stats row (500+ Gia sư, 200+ Lớp học, 98% Hài lòng).
class GuestHeroSection extends StatelessWidget {
  const GuestHeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeroBanner(context),
        const SizedBox(height: AppTheme.spacingMd),
        _buildStatsRow(context),
      ],
    );
  }

  Widget _buildHeroBanner(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: AppTheme.heroGradient,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.heroGradient.first.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tìm Gia Sư\nTinh Hoa',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Kết nối 1-1 với gia sư chất lượng cao',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.85),
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 16),
            _buildCtaButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCtaButton(BuildContext context) {
    return GestureDetector(
      onTap: () => showAuthGuard(context, onSuccess: () {}),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.person_add_rounded, size: 18, color: AppTheme.primary),
            const SizedBox(width: 8),
            Text(
              'ĐĂNG KÝ NGAY',
              style: TextStyle(
                color: AppTheme.primary,
                fontWeight: FontWeight.w700,
                fontSize: 13,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
      child: Row(
        children: [
          Expanded(
            child: _StatBlock(
              value: 500,
              suffix: '+',
              label: 'Gia sư',
              isDark: isDark,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _StatBlock(
              value: 200,
              suffix: '+',
              label: 'Lớp học',
              isDark: isDark,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _StatBlock(
              value: 98,
              suffix: '%',
              label: 'Hài lòng',
              isDark: isDark,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatBlock extends StatelessWidget {
  final int value;
  final String suffix;
  final String label;
  final bool isDark;

  const _StatBlock({
    required this.value,
    required this.suffix,
    required this.label,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2334) : const Color(0xFF2D2B55),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: AnimatedCounter(
        targetValue: value,
        suffix: suffix,
        label: label,
        valueStyle: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
        labelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Colors.white.withValues(alpha: 0.7),
        ),
      ),
    );
  }
}
