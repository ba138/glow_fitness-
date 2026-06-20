import 'package:get/get.dart';

import '../data/sample_data.dart';
import '../models/fitness_data.dart';

class ProgressController extends GetxController {
  final week = <DayStat>[].obs;
  final totalCalories = 0.obs;
  final averageCalories = 0.obs;
  final workoutsThisWeek = 5.obs;
  final streakThreshold = 400.obs;

  @override
  void onInit() {
    super.onInit();
    week.value = SampleData.week;
    _updateStats();
  }

  void _updateStats() {
    final total = week.fold<int>(0, (sum, day) => sum + day.calories);
    totalCalories.value = total;
    averageCalories.value = week.isEmpty ? 0 : (total / week.length).round();
  }

  bool isStreakDay(DayStat day) => day.calories > streakThreshold.value;
}
