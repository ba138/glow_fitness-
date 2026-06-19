import 'package:flutter/material.dart';

import '../data/sample_data.dart';
import '../models/fitness_data.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';

class WorkoutsScreen extends StatelessWidget {
  const WorkoutsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = ['All', 'HIIT', 'Strength', 'Cardio', 'Mobility'];
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        const Text(
          'Workouts',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 26,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, _) => const SizedBox(width: 10),
            itemBuilder: (context, i) {
              final selected = i == 0;
              return GlassCard(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                borderRadius: 20,
                gradient: selected ? AppColors.primaryGradient : null,
                child: Center(
                  child: Text(
                    categories[i],
                    style: TextStyle(
                      color: selected ? Colors.white : AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
        for (final w in SampleData.workouts) ...[
          _workoutCard(context, w),
          const SizedBox(height: 16),
        ],
      ],
    );
  }

  Widget _workoutCard(BuildContext context, Workout w) {
    return GlassCard(
      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Opening ${w.title}…')),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: LinearGradient(colors: w.colors),
            ),
            child: Icon(w.icon, color: Colors.white, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  w.category.toUpperCase(),
                  style: TextStyle(
                    color: w.colors.first,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  w.title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _chip(Icons.schedule_rounded, '${w.durationMinutes} min'),
                    const SizedBox(width: 12),
                    _chip(Icons.local_fire_department_rounded,
                        '${w.calories} kcal'),
                    const SizedBox(width: 12),
                    _chip(Icons.signal_cellular_alt_rounded, w.level),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
        ],
      ),
    );
  }

  Widget _chip(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.textMuted),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
          ),
        ),
      ],
    );
  }
}
