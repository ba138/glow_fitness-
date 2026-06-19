import 'package:flutter/material.dart';

import '../models/fitness_data.dart';
import '../theme/app_theme.dart';

/// Static demo content so the UI is populated without a backend.
class SampleData {
  SampleData._();

  static const List<ActivityRing> rings = [
    ActivityRing(
      label: 'Move',
      value: 540,
      goal: 700,
      unit: 'kcal',
      color: AppColors.accent,
      icon: Icons.local_fire_department_rounded,
    ),
    ActivityRing(
      label: 'Steps',
      value: 8200,
      goal: 10000,
      unit: 'steps',
      color: AppColors.secondary,
      icon: Icons.directions_walk_rounded,
    ),
    ActivityRing(
      label: 'Stand',
      value: 9,
      goal: 12,
      unit: 'hrs',
      color: AppColors.lime,
      icon: Icons.self_improvement_rounded,
    ),
  ];

  static const List<Workout> workouts = [
    Workout(
      title: 'Full Body Burn',
      category: 'HIIT',
      durationMinutes: 32,
      calories: 420,
      level: 'Intermediate',
      icon: Icons.bolt_rounded,
      colors: [AppColors.accent, AppColors.amber],
    ),
    Workout(
      title: 'Power Yoga Flow',
      category: 'Mobility',
      durationMinutes: 25,
      calories: 180,
      level: 'All levels',
      icon: Icons.self_improvement_rounded,
      colors: [AppColors.secondary, AppColors.primary],
    ),
    Workout(
      title: 'Upper Body Strength',
      category: 'Strength',
      durationMinutes: 45,
      calories: 360,
      level: 'Advanced',
      icon: Icons.fitness_center_rounded,
      colors: [AppColors.primary, AppColors.accent],
    ),
    Workout(
      title: 'Morning Cardio',
      category: 'Cardio',
      durationMinutes: 20,
      calories: 240,
      level: 'Beginner',
      icon: Icons.directions_run_rounded,
      colors: [AppColors.lime, AppColors.secondary],
    ),
  ];

  static const List<DayStat> week = [
    DayStat('Mon', 380),
    DayStat('Tue', 520),
    DayStat('Wed', 290),
    DayStat('Thu', 610),
    DayStat('Fri', 450),
    DayStat('Sat', 700),
    DayStat('Sun', 540),
  ];
}
