import 'package:flutter/material.dart';

/// A single named activity ring shown on the dashboard (e.g. Move, Steps).
class ActivityRing {
  const ActivityRing({
    required this.label,
    required this.value,
    required this.goal,
    required this.unit,
    required this.color,
    required this.icon,
  });

  final String label;
  final double value;
  final double goal;
  final String unit;
  final Color color;
  final IconData icon;

  double get progress => goal == 0 ? 0 : (value / goal).clamp(0.0, 1.0);
}

/// A workout template the user can browse and start.
class Workout {
  const Workout({
    required this.title,
    required this.category,
    required this.durationMinutes,
    required this.calories,
    required this.level,
    required this.icon,
    required this.colors,
  });

  final String title;
  final String category;
  final int durationMinutes;
  final int calories;
  final String level;
  final IconData icon;
  final List<Color> colors;
}

/// One day's calorie burn, used by the weekly progress chart.
class DayStat {
  const DayStat(this.day, this.calories);

  final String day;
  final int calories;
}
