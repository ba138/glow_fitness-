import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/fitness_data.dart';
import '../theme/app_theme.dart';
import 'health_controller.dart';

class DashboardController extends GetxController {
  final health = Get.put(HealthController());

  final rings = <ActivityRing>[].obs;
  final todayWorkout = Workout(
    title: 'Quick Burn',
    category: 'Cardio',
    durationMinutes: 20,
    calories: 120,
    level: 'Beginner',
    icon: Icons.local_fire_department_rounded,
    colors: [AppColors.accent, AppColors.primary],
  ).obs;

  @override
  void onInit() {
    super.onInit();
    // initialize with health values when available
    ever(health.authorized, (_) async {
      if (health.authorized.value) {
        await health.fetchTodayData();
        _updateFromHealth();
      }
    });
    // request permissions on init
    health.requestPermissions();
  }

  void _updateFromHealth() {
    final steps = health.steps.value;
    final kcal = health.activeEnergy.value;
    final hr = health.heartRate.value;

    rings.value = [
      ActivityRing(
        label: 'Move',
        value: kcal,
        goal: 500,
        unit: 'kcal',
        color: AppColors.accent,
        icon: Icons.local_fire_department_rounded,
      ),
      ActivityRing(
        label: 'Steps',
        value: steps,
        goal: 10000,
        unit: 'steps',
        color: AppColors.primary,
        icon: Icons.directions_walk_rounded,
      ),
      ActivityRing(
        label: 'Heart',
        value: hr,
        goal: 120,
        unit: 'bpm',
        color: AppColors.secondary,
        icon: Icons.favorite_rounded,
      ),
    ];

    // update today workout to reflect current kcal
    todayWorkout.value = Workout(
      title: 'Today',
      category: 'Personal',
      durationMinutes: todayWorkout.value.durationMinutes,
      calories: kcal.round(),
      level: todayWorkout.value.level,
      icon: Icons.local_fire_department_rounded,
      colors: todayWorkout.value.colors,
    );
  }
}
