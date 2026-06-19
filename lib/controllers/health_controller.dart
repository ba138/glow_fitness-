import 'package:get/get.dart';
import 'package:health/health.dart';

class HealthController extends GetxController {
  final Health _health = Health();

  final authorized = false.obs;

  // Primary measurements
  final steps = 0.0.obs;
  final activeEnergy = 0.0.obs; // kcal
  final heartRate = 0.0.obs; // bpm
  final sleepHours = 0.0.obs; // hours
  final waterLiters = 0.0.obs; // liters

  Future<bool> requestPermissions() async {
    final types = [
      HealthDataType.STEPS,
      HealthDataType.ACTIVE_ENERGY_BURNED,
      HealthDataType.HEART_RATE,
      HealthDataType.SLEEP_ASLEEP,
      HealthDataType.WATER,
    ];

    try {
      await _health.configure();
      final ok = await _health.requestAuthorization(types);
      authorized.value = ok;
      if (authorized.value) {
        await fetchTodayData();
      }
      return authorized.value;
    } catch (e) {
      authorized.value = false;
      return false;
    }
  }

  Future<void> fetchTodayData() async {
    if (!authorized.value) return;
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);

    try {
      final types = [
        HealthDataType.STEPS,
        HealthDataType.ACTIVE_ENERGY_BURNED,
        HealthDataType.HEART_RATE,
        HealthDataType.SLEEP_ASLEEP,
        HealthDataType.WATER,
      ];

      final data = await _health.getHealthDataFromTypes(
        startTime: midnight,
        endTime: now,
        types: types,
      );

      double stepsTotal = 0.0;
      double kcalTotal = 0.0;
      double hrLast = 0.0;
      double sleepMinutes = 0.0;
      double waterMl = 0.0;

      for (final e in data) {
        switch (e.type) {
          case HealthDataType.STEPS:
            stepsTotal += (e.value is num) ? (e.value as num).toDouble() : 0.0;
            break;
          case HealthDataType.ACTIVE_ENERGY_BURNED:
            kcalTotal += (e.value is num) ? (e.value as num).toDouble() : 0.0;
            break;
          case HealthDataType.HEART_RATE:
            hrLast = (e.value is num) ? (e.value as num).toDouble() : hrLast;
            break;
          case HealthDataType.SLEEP_ASLEEP:
            // Health package represents sleep samples as duration in minutes
            sleepMinutes += (e.value is num)
                ? (e.value as num).toDouble()
                : 0.0;
            break;
          case HealthDataType.WATER:
            waterMl += (e.value is num) ? (e.value as num).toDouble() : 0.0;
            break;
          default:
            break;
        }
      }

      steps.value = stepsTotal;
      activeEnergy.value = kcalTotal;
      heartRate.value = hrLast;
      sleepHours.value = sleepMinutes / 60.0;
      waterLiters.value = waterMl / 1000.0;
    } catch (e) {
      // ignore errors but keep previous values
    }
  }
}
