import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:health/health.dart';

import 'health_controller.dart';
import '../models/fitness_data.dart';

class ProgressController extends GetxController {
  late final HealthController healthController;
  final Health health = Health();

  final totalCalories = 0.obs;
  final averageCalories = 0.obs;

  final workoutsThisWeek = 0.obs;
  final workoutMinutes = 0.obs;

  final week = <DayStat>[].obs;

  @override
  void onInit() {
    super.onInit();

    healthController = Get.find<HealthController>();

    _initEmptyWeek(); // ✅ prevents "No element" crash

    if (healthController.authorized.value) {
      loadProgress();
    }

    ever(healthController.authorized, (bool auth) {
      if (auth) loadProgress();
    });
  }

  /// =========================
  /// INITIAL SAFE STATE
  /// =========================
  void _initEmptyWeek() {
    week.assignAll([
      const DayStat('Mon', 0),
      const DayStat('Tue', 0),
      const DayStat('Wed', 0),
      const DayStat('Thu', 0),
      const DayStat('Fri', 0),
      const DayStat('Sat', 0),
      const DayStat('Sun', 0),
    ]);
  }

  /// =========================
  /// MAIN LOAD FUNCTION
  /// =========================
  Future<void> loadProgress() async {
    await Future.wait([_loadWeeklyCalories(), _loadWorkoutStats()]);
  }

  /// =========================
  /// WEEKLY CALORIES (REAL DATA)
  /// =========================
  Future<void> _loadWeeklyCalories() async {
    try {
      final now = DateTime.now();

      int total = 0;
      final List<DayStat> tempWeek = [];

      for (int i = 6; i >= 0; i--) {
        final day = now.subtract(Duration(days: i));

        final start = DateTime(day.year, day.month, day.day);
        final end = start.add(const Duration(days: 1));

        final data = await health.getHealthDataFromTypes(
          startTime: start,
          endTime: end,
          types: [HealthDataType.ACTIVE_ENERGY_BURNED],
        );

        int calories = 0;

        for (final item in data) {
          if (item.value is num) {
            calories += (item.value as num).toInt();
          }
        }

        total += calories;

        tempWeek.add(DayStat(_dayName(day.weekday), calories));
      }

      week.assignAll(tempWeek);

      totalCalories.value = total;
      averageCalories.value = (total / 7).round();
    } catch (e) {
      debugPrint("Calories error: $e");
    }
  }

  /// =========================
  /// REAL WORKOUT DATA
  /// =========================
  Future<void> _loadWorkoutStats() async {
    try {
      final now = DateTime.now();

      final startOfWeek = now.subtract(Duration(days: now.weekday - 1));

      final workouts = await health.getHealthDataFromTypes(
        startTime: startOfWeek,
        endTime: now,
        types: [HealthDataType.WORKOUT],
      );

      workoutsThisWeek.value = workouts.length;

      int minutes = 0;

      for (final w in workouts) {
        minutes += w.dateTo.difference(w.dateFrom).inMinutes;
      }

      workoutMinutes.value = minutes;
    } catch (e) {
      debugPrint("Workout error: $e");
    }
  }

  /// =========================
  /// STREAK LOGIC
  /// =========================
  bool isStreakDay(DayStat day) => day.calories > 0;

  /// =========================
  /// DAY FORMATTER
  /// =========================
  String _dayName(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'Mon';
      case DateTime.tuesday:
        return 'Tue';
      case DateTime.wednesday:
        return 'Wed';
      case DateTime.thursday:
        return 'Thu';
      case DateTime.friday:
        return 'Fri';
      case DateTime.saturday:
        return 'Sat';
      case DateTime.sunday:
        return 'Sun';
      default:
        return '';
    }
  }
}
