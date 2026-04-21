import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/design_system.dart';

class LoadingSpinner extends StatefulWidget {
  /// Diameter of the overall spinner.
  final double size;

  /// Radius of each individual dot.
  final double dotRadius;

  /// Number of dots arranged in a circle.
  final int dotCount;

  /// Color of the dots (defaults to AppColors.primaryBlue).
  final Color color;

  /// Duration of one full rotation cycle.
  final Duration duration;

  const LoadingSpinner({
    super.key,
    this.size = 42,
    this.dotRadius = 4,
    this.dotCount = 8,
    this.color = AppColors.primaryBlue,
    this.duration = const Duration(milliseconds: 900),
  });

  @override
  State<LoadingSpinner> createState() => _LoadingSpinnerState();
}

class _LoadingSpinnerState extends State<LoadingSpinner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, _) => CustomPaint(
          painter: _DotSpinnerPainter(
            progress: _controller.value,
            dotCount: widget.dotCount,
            dotRadius: widget.dotRadius,
            color: widget.color,
          ),
        ),
      ),
    );
  }
}

class _DotSpinnerPainter extends CustomPainter {
  final double progress;
  final int dotCount;
  final double dotRadius;
  final Color color;

  _DotSpinnerPainter({
    required this.progress,
    required this.dotCount,
    required this.dotRadius,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    // Orbit radius — leave room for the dots themselves.
    final orbitRadius = (size.width / 2) - dotRadius;
    final paint = Paint()..style = PaintingStyle.fill;

    // How far along the dot ring we are (continuous, not snapped).
    final offset = progress * dotCount;

    for (int i = 0; i < dotCount; i++) {
      // Angle starts at top (−π/2) and goes clockwise.
      final angle = -math.pi / 2 + (2 * math.pi / dotCount) * i;

      // Continuous steps behind the lead position, wrapping around.
      final stepsBack = ((i - offset) % dotCount + dotCount) % dotCount;

      // Opacity: lead dot is full, trailing dots fade out linearly.
      final opacity = 1.0 - (stepsBack / dotCount);

      // Scale: sharper tail — lead dot is largest, tail nearly vanishes.
      final scale = 0.2 + 0.8 * (1.0 - stepsBack / dotCount);

      final dotCenter = Offset(
        center.dx + orbitRadius * math.cos(angle),
        center.dy + orbitRadius * math.sin(angle),
      );

      paint.color = color.withValues(alpha: opacity.clamp(0.08, 1.0));
      canvas.drawCircle(dotCenter, dotRadius * scale, paint);
    }
  }

  @override
  bool shouldRepaint(_DotSpinnerPainter old) =>
      old.progress != progress ||
      old.dotCount != dotCount ||
      old.dotRadius != dotRadius ||
      old.color != color;
}
