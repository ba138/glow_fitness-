import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glow_fitness/screens/exercises_screen.dart';

import '../data/sample_data.dart';
import '../models/fitness_data.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';

/// 👉 IMPORT SCREENS

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

        /// CATEGORY BAR
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, _) => const SizedBox(width: 10),
            itemBuilder: (context, i) {
              final selected = i == 0;

              return GlassCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 8,
                ),
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

        /// WORKOUT LIST
        for (final w in SampleData.workouts) ...[
          _workoutCard(w),
          const SizedBox(height: 16),
        ],
      ],
    );
  }

  /// =========================
  /// WORKOUT CARD + GETX NAV
  /// =========================
  Widget _workoutCard(Workout w) {
    return GlassCard(
      onTap: () {
        switch (w.category.toLowerCase()) {
          case 'hiit':
            Get.to(() => ExercisesScreen());
            break;

          case 'strength':
            Get.to(
              () => ExercisesScreen(
                title: w.title,
                exercises: [
                  ('Arm Circles', 60),
                  ('Jumping Jacks', 60),
                  ('Shoulder Rolls', 60),
                  ('Light Push-ups', 60),
                  ('Chest Opener Stretch', 60),

                  ('Push-Ups', 180),
                  ('Incline Push-Ups', 180),
                  ('Pike Push-Ups (Shoulders)', 180),
                  ('Tricep Dips', 180),
                  ('Diamond Push-Ups', 180),

                  ('Plank Shoulder Taps', 180),
                  ('Arm Plank Hold', 180),
                  ('Bicep Curls (Water Bottles/Dumbbells)', 180),
                  ('Shoulder Press', 180),
                  ('Lateral Raises', 180),

                  ('Close-Grip Push-Ups', 180),
                  ('Slow Tempo Push-Ups', 180),

                  ('Chest Stretch', 120),
                  ('Triceps Stretch', 120),
                  ('Shoulder Stretch', 120),
                ],
              ),
            );
            break;

          case 'cardio':
            Get.to(
              () => ExercisesScreen(
                title: w.title,
                exercises: [
                  ('Jumping Jacks', 60),
                  ('High Knees', 60),
                  ('Butt Kicks', 60),
                  ('Mountain Climbers', 60),

                  ('Fast Feet Run in Place', 60),
                  ('Skater Jumps', 60),
                  ('Burpees', 90),
                  ('Jump Squats', 60),

                  ('Boxer Shuffle', 60),
                  ('Punches (Shadow Boxing)', 60),

                  ('Side-to-Side Hops', 60),
                  ('Plank Jacks', 60),

                  ('Speed Skaters', 60),
                  ('Mountain Climbers (Fast)', 60),

                  ('Burpees (Final Burn)', 90),
                  ('Cool Down Walk', 120),
                ],
              ),
            );
            break;

          case 'mobility':
            Get.to(
              () => ExercisesScreen(
                title: w.title,
                exercises: [
                  ('Downward-Facing Dog', 60),
                  ('Sun Salutation Flow', 180),
                  ('Warrior I · Right', 60),
                  ('Warrior I · Left', 60),
                  ('Warrior II · Right', 60),
                  ('Warrior II · Left', 60),
                  ('Tree Pose · Right', 45),
                  ('Tree Pose · Left', 45),
                  ('Cobra Pose', 60),
                  ('Bridge Pose', 60),
                  ('Plank Pose', 60),
                  ('Low Lunge Stretch · Right', 60),
                  ('Low Lunge Stretch · Left', 60),
                  ('Seated Forward Fold', 90),
                ],
              ),
            );
            break;

          default:
          // Get.to(() => WorkoutDetailScreen(workout: w));
        }
      },

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
                    const SizedBox(width: 8),
                    _chip(
                      Icons.local_fire_department_rounded,
                      '${w.calories} kcal',
                    ),
                    const SizedBox(width: 8),
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
