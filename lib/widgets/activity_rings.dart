import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/fitness_data.dart';
import '../theme/app_theme.dart';

/// Concentric animated progress rings (Apple-Watch style) drawn with a
/// [CustomPainter] so the app needs no charting dependency.
class ActivityRings extends StatelessWidget {
  const ActivityRings({super.key, required this.rings, this.size = 180});

  final List<ActivityRing> rings;
  final double size;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 1100),
      curve: Curves.easeOutCubic,
      builder: (context, t, _) {
        return SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _RingsPainter(rings: rings, animation: t),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${(rings.first.progress * 100 * t).round()}%',
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Text(
                    'of goal',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _RingsPainter extends CustomPainter {
  _RingsPainter({required this.rings, required this.animation});

  final List<ActivityRing> rings;
  final double animation;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    const stroke = 14.0;
    const gap = 6.0;

    for (var i = 0; i < rings.length; i++) {
      final radius = size.width / 2 - stroke / 2 - i * (stroke + gap);
      final rect = Rect.fromCircle(center: center, radius: radius);

      final track = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round
        ..color = Colors.white.withValues(alpha: 0.08);
      canvas.drawArc(rect, -math.pi / 2, 2 * math.pi, false, track);

      final sweep = 2 * math.pi * rings[i].progress * animation;
      final progress = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round
        ..shader = SweepGradient(
          startAngle: -math.pi / 2,
          endAngle: 3 * math.pi / 2,
          colors: [
            rings[i].color.withValues(alpha: 0.6),
            rings[i].color,
          ],
        ).createShader(rect);
      canvas.drawArc(rect, -math.pi / 2, sweep, false, progress);
    }
  }

  @override
  bool shouldRepaint(covariant _RingsPainter old) =>
      old.animation != animation || old.rings != rings;
}
