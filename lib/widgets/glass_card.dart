import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// A frosted-glass surface: a blurred, semi-transparent rounded container
/// with a subtle light stroke and top highlight. The core building block of
/// the app's glassmorphism look.
class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.borderRadius = 24,
    this.blur = 18,
    this.onTap,
    this.gradient,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final double blur;
  final VoidCallback? onTap;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(borderRadius);
    return ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: radius,
            gradient: gradient ??
                LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withValues(alpha: 0.16),
                    Colors.white.withValues(alpha: 0.04),
                  ],
                ),
            border: Border.all(color: AppColors.glassStroke, width: 1.2),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: radius,
              child: Padding(padding: padding, child: child),
            ),
          ),
        ),
      ),
    );
  }
}
