import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Animated gradient backdrop with soft floating color "blobs".
///
/// This is what gives the frosted-glass surfaces something colourful and
/// moving to blur over.
class AuroraBackground extends StatefulWidget {
  const AuroraBackground({super.key, required this.child});

  final Widget child;

  @override
  State<AuroraBackground> createState() => _AuroraBackgroundState();
}

class _AuroraBackgroundState extends State<AuroraBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.background, AppColors.backgroundAlt],
        ),
      ),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final t = _controller.value;
          return Stack(
            children: [
              _blob(
                color: AppColors.primary,
                alignment: Alignment(-0.9 + t * 0.4, -0.9 + t * 0.2),
                size: 320,
              ),
              _blob(
                color: AppColors.accent,
                alignment: Alignment(0.9 - t * 0.3, -0.4 + t * 0.5),
                size: 260,
              ),
              _blob(
                color: AppColors.secondary,
                alignment: Alignment(-0.6 + t * 0.5, 0.9 - t * 0.3),
                size: 300,
              ),
              child!,
            ],
          );
        },
        child: widget.child,
      ),
    );
  }

  Widget _blob({
    required Color color,
    required Alignment alignment,
    required double size,
  }) {
    return Align(
      alignment: alignment,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color.withValues(alpha: 0.55), color.withValues(alpha: 0)],
          ),
        ),
      ),
    );
  }
}
