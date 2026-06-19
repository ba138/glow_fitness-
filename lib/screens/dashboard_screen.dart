import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glow_fitness/screens/exercises_screen.dart';

import '../controllers/health_controller.dart';
import '../data/sample_data.dart';
import '../models/fitness_data.dart';
import '../theme/app_theme.dart';
import '../widgets/activity_rings.dart';
import '../widgets/glass_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final health = Get.put(HealthController());

    return Obx(
      () => ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          _header(),
          const SizedBox(height: 24),
          _ringsCard(health),
          const SizedBox(height: 16),
          _statsRow(health),
          const SizedBox(height: 16),
          _todayPlan(context),
        ],
      ),
    );
  }

  Widget _header() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Good morning,',
                style: TextStyle(color: AppColors.textMuted, fontSize: 14),
              ),
              SizedBox(height: 2),
              Text(
                'Basit',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 48,
          height: 48,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppColors.accentGradient,
          ),
          child: const Icon(Icons.person_rounded, color: Colors.white),
        ),
      ],
    );
  }

  Widget _ringsCard(HealthController health) {
    final rings = [
      ActivityRing(
        label: 'Move',
        value: health.activeEnergy.value,
        goal: 500,
        unit: 'kcal',
        color: AppColors.accent,
        icon: Icons.local_fire_department_rounded,
      ),
      ActivityRing(
        label: 'Steps',
        value: health.steps.value,
        goal: 10000,
        unit: 'steps',
        color: AppColors.primary,
        icon: Icons.directions_walk_rounded,
      ),
      ActivityRing(
        label: 'Stand',
        value: health.standHours.value,
        goal: 12,
        unit: 'hrs',
        color: AppColors.lime,
        icon: Icons.self_improvement_rounded,
      ),
      ActivityRing(
        label: 'Heart',
        value: health.heartRate.value,
        goal: 120,
        unit: 'bpm',
        color: AppColors.secondary,
        icon: Icons.favorite_rounded,
      ),
    ];

    return GlassCard(
      child: Row(
        children: [
          ActivityRings(rings: rings, size: 120),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final r in rings) ...[
                  _ringLegend(r),
                  if (r != rings.last) const SizedBox(height: 14),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _ringLegend(ActivityRing r) {
    return Row(
      children: [
        Icon(r.icon, color: r.color, size: 20),
        // const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              r.label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
            Text(
              '${r.value.round()} / ${r.goal.round()} ${r.unit}',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _statsRow(HealthController health) {
    return Row(
      children: [
        Expanded(
          child: _miniStat(
            Icons.favorite_rounded,
            '${health.heartRate.value.round()}',
            'Avg BPM',
            AppColors.accent,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _miniStat(
            Icons.water_drop_rounded,
            '${health.waterLiters.value.toStringAsFixed(1)}L',
            'Water',
            AppColors.secondary,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _miniStat(
            Icons.bedtime_rounded,
            '${health.sleepHours.value.toStringAsFixed(1)}h',
            'Sleep',
            AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _miniStat(IconData icon, String value, String label, Color color) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      borderRadius: 20,
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _todayPlan(BuildContext context) {
    final workout = SampleData.workouts.first;
    return GlassCard(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          workout.colors.first.withValues(alpha: 0.45),
          workout.colors.last.withValues(alpha: 0.25),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Today's Session",
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  workout.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${workout.durationMinutes} min · ${workout.calories} kcal',
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 14),
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.background,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ExercisesScreen()),
                    );
                  },
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('Start'),
                ),
              ],
            ),
          ),
          Icon(
            workout.icon,
            size: 64,
            color: Colors.white.withValues(alpha: 0.85),
          ),
        ],
      ),
    );
  }
}
