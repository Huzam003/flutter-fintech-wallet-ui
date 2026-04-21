import 'package:flutter/material.dart';
import 'package:animated_checkmark/animated_checkmark.dart';
import '../theme/design_system.dart';

class AnimatedSuccessIndicator extends StatefulWidget {
  /// Width/height of the indicator container (default: 280)
  final double size;

  /// Diameter of the blue success circle (default: 190)
  final double circleDiameter;

  /// Checkmark weight/thickness (default: 23)
  final double checkmarkWeight;

  /// Background color of the body/screen (used for checkmark color contrast)
  final Color checkmarkColor;

  /// Color of the circle and particles (default: primaryBlue)
  final Color accentColor;

  /// Duration of the scale-in animation (default: 600ms)
  final Duration animationDuration;

  const AnimatedSuccessIndicator({
    super.key,
    this.size = 280,
    this.circleDiameter = 190,
    this.checkmarkWeight = 23,
    this.checkmarkColor = const Color(0xFF070E17),
    this.accentColor = AppColors.primaryBlue,
    this.animationDuration = const Duration(milliseconds: 600),
  });

  @override
  State<AnimatedSuccessIndicator> createState() =>
      _AnimatedSuccessIndicatorState();
}

class _AnimatedSuccessIndicatorState extends State<AnimatedSuccessIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Builds a single decorative particle at the given offset and size.
  Widget _buildParticle(double dx, double dy, double size) {
    return Transform.translate(
      offset: Offset(dx, dy),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: widget.accentColor.withValues(alpha: 0.51),
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Scattered decorative particles (fixed positions)
          _buildParticle(-84, -108, 24), // top-left large
          _buildParticle(10, -116, 6), // top center small
          _buildParticle(-110, -44, 4), // left small
          _buildParticle(30, 110, 4), // bottom-right small
          _buildParticle(116, 6, 6), // right small
          _buildParticle(104, 86, 6), // bottom-right medium
          _buildParticle(109, -94, 18), // top-right large
          _buildParticle(-112, 49, 16), // left medium
          _buildParticle(-50, 114, 13), // bottom-left medium
          // Animated checkmark circle
          ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              width: widget.circleDiameter,
              height: widget.circleDiameter,
              decoration: BoxDecoration(
                color: widget.accentColor,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: RawCheckmark(
                  color: widget.checkmarkColor,
                  weight: widget.checkmarkWeight,
                  rounded: true,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
