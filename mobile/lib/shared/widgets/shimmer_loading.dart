import 'package:flutter/material.dart';

/// Shimmer loading placeholder that replaces `CircularProgressIndicator`.
///
/// Creates a pulsing gradient animation over rectangular blocks.
class ShimmerLoading extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerLoading({
    super.key,
    this.width = double.infinity,
    this.height = 16,
    this.borderRadius = 8,
  });

  /// Convenience constructor for a card-shaped shimmer block.
  const ShimmerLoading.card({
    super.key,
    this.width = double.infinity,
    this.height = 120,
    this.borderRadius = 16,
  });

  /// Convenience constructor for a circular shimmer (avatar).
  const ShimmerLoading.circle({
    super.key,
    this.width = 48,
    this.height = 48,
    this.borderRadius = 999,
  });

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? const Color(0xFF2A2F3E) : const Color(0xFFE2E8F0);
    final highlightColor = isDark ? const Color(0xFF3D4455) : const Color(0xFFF1F5F9);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment(-1.0 + 2.0 * _controller.value, 0),
              end: Alignment(1.0 + 2.0 * _controller.value, 0),
              colors: [baseColor, highlightColor, baseColor],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        );
      },
    );
  }
}

/// Multi-line shimmer placeholder for loading screens.
class ShimmerGroup extends StatelessWidget {
  final int lines;
  final double spacing;

  const ShimmerGroup({super.key, this.lines = 3, this.spacing = 12});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(lines, (index) {
        final isLast = index == lines - 1;
        return Padding(
          padding: EdgeInsets.only(bottom: isLast ? 0 : spacing),
          child: ShimmerLoading(
            width: isLast ? MediaQuery.of(context).size.width * 0.6 : double.infinity,
            height: 14,
          ),
        );
      }),
    );
  }
}
