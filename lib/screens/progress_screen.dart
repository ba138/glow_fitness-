import 'package:flutter/material.dart';

import '../data/sample_data.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/weekly_bar_chart.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final total = SampleData.week.fold<int>(0, (s, d) => s + d.calories);
    final avg = (total / SampleData.week.length).round();

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        const Text(
          'Progress',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 26,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Calories burned this week',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 4),
              Text(
                '$total kcal',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 24),
              WeeklyBarChart(data: SampleData.week),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _summary('Daily avg', '$avg', 'kcal', AppColors.accent),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _summary('Workouts', '5', 'this week', AppColors.lime),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Streak',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (final d in SampleData.week)
                    Column(
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: d.calories > 400
                                ? AppColors.primaryGradient
                                : null,
                            color: d.calories > 400
                                ? null
                                : Colors.white.withValues(alpha: 0.08),
                          ),
                          child: Icon(
                            d.calories > 400
                                ? Icons.check_rounded
                                : Icons.remove_rounded,
                            size: 16,
                            color: d.calories > 400
                                ? Colors.white
                                : AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          d.day,
                          style: const TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _summary(String label, String value, String unit, Color color) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: TextStyle(
                  color: color,
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                unit,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
