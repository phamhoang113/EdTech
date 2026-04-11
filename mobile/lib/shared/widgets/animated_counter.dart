import 'package:flutter/material.dart';

/// Animated number counter that slides up from 0 to the target value.
///
/// Used for stats like "500+ Gia sư", "200+ Lớp học", "98% Hài lòng".
class AnimatedCounter extends StatefulWidget {
  final int targetValue;
  final String? suffix;
  final String label;
  final TextStyle? valueStyle;
  final TextStyle? labelStyle;
  final Duration duration;
  final Widget? icon;

  const AnimatedCounter({
    super.key,
    required this.targetValue,
    required this.label,
    this.suffix,
    this.valueStyle,
    this.labelStyle,
    this.duration = const Duration(milliseconds: 1200),
    this.icon,
  });

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant AnimatedCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.targetValue != widget.targetValue) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultValueStyle = theme.textTheme.headlineSmall?.copyWith(
      fontWeight: FontWeight.w800,
      letterSpacing: -0.5,
    );
    final defaultLabelStyle = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurface.withOpacity(0.6),
      fontWeight: FontWeight.w500,
    );

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final currentValue = (_animation.value * widget.targetValue).round();
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.icon != null) ...[
              widget.icon!,
              const SizedBox(height: 6),
            ],
            Text(
              '$currentValue${widget.suffix ?? ''}',
              style: widget.valueStyle ?? defaultValueStyle,
            ),
            const SizedBox(height: 2),
            Text(
              widget.label,
              style: widget.labelStyle ?? defaultLabelStyle,
              textAlign: TextAlign.center,
            ),
          ],
        );
      },
    );
  }
}
