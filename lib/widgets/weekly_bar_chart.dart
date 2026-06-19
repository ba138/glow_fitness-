import 'package:flutter/material.dart';

import '../models/fitness_data.dart';
import '../theme/app_theme.dart';

/// Simple animated weekly bar chart built from plain widgets so no external
/// charting package is required.
class WeeklyBarChart extends StatelessWidget {
  const WeeklyBarChart({super.key, required this.data});

  final List<DayStat> data;

  @override
  Widget build(BuildContext context) {
    final maxValue =
        data.map((d) => d.calories).reduce((a, b) => a > b ? a : b).toDouble();

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeOutCubic,
      builder: (context, t, _) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (final d in data)
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${d.calories}',
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      height: 120 * (d.calories / maxValue) * t,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        gradient: const LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [AppColors.primary, AppColors.secondary],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      d.day,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}
