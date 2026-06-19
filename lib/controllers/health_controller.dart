import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';

class HealthController extends GetxController with WidgetsBindingObserver {
  final Health _health = Health();
  bool _healthPermissionRequested = false;

  final authorized = false.obs;

  // Primary measurements
  final steps = 0.0.obs;
  final activeEnergy = 0.0.obs; // kcal
  final heartRate = 0.0.obs; // bpm
  final sleepHours = 0.0.obs; // hours
  final waterLiters = 0.0.obs; // liters
  final standHours = 0.0.obs; // hours

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onReady() {
    super.onReady();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tryRequestPermissionsOnResume();
    });
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _tryRequestPermissionsOnResume();
    }
  }

  void _tryRequestPermissionsOnResume() {
    if (!_healthPermissionRequested && !authorized.value) {
      _healthPermissionRequested = true;
      requestPermissions();
    }
  }

  Future<bool> requestPermissions() async {
    final types = [
      HealthDataType.STEPS,
      HealthDataType.ACTIVE_ENERGY_BURNED,
      HealthDataType.HEART_RATE,
      HealthDataType.SLEEP_ASLEEP,
      HealthDataType.WATER,
      if (Platform.isIOS) HealthDataType.APPLE_STAND_HOUR,
    ];

    final permissions = types
        .map((_) => HealthDataAccess.READ)
        .toList(growable: false);

    try {
      await _health.configure();

      if (Platform.isAndroid) {
        await Permission.activityRecognition.request();

        final sdkStatus = await _health.getHealthConnectSdkStatus();

        if (sdkStatus != HealthConnectSdkStatus.sdkAvailable) {
          try {
            await _health.installHealthConnect();
          } catch (_) {}
          authorized.value = false;
          return false;
        }

        // Give the plugin time to attach its activity and launcher before authorization.
        await Future<void>.delayed(const Duration(milliseconds: 500));
      }

      await _health.hasPermissions(types, permissions: permissions);

      var ok = false;
      const retryCount = 5;
      for (var attempt = 1; attempt <= retryCount; attempt++) {
        ok = await _health.requestAuthorization(
          types,
          permissions: permissions,
        );
        if (ok) {
          break;
        }
        if (attempt < retryCount) {
          final delayMillis = 300 * attempt;
          await Future<void>.delayed(Duration(milliseconds: delayMillis));
        }
      }

      if (ok) {
        await _health.requestHealthDataHistoryAuthorization();
        await _health.requestHealthDataInBackgroundAuthorization();
      }

      authorized.value = ok;
      if (authorized.value) {
        await fetchTodayData();
      }
      return authorized.value;
    } catch (_) {
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
        if (Platform.isIOS) HealthDataType.APPLE_STAND_HOUR,
      ];

      final data = await _health.getHealthDataFromTypes(
        startTime: midnight,
        endTime: now,
        types: types,
      );
      double stepsTotal = 0.0;
      double kcalTotal = 0.0;
      double hrSum = 0.0;
      int hrCount = 0;
      double sleepMinutes = 0.0;
      double waterMl = 0.0;
      double standTotal = 0.0;

      for (final e in data) {
        switch (e.type) {
          case HealthDataType.STEPS:
            stepsTotal += (e.value is num) ? (e.value as num).toDouble() : 0.0;
            break;
          case HealthDataType.ACTIVE_ENERGY_BURNED:
            kcalTotal += (e.value is num) ? (e.value as num).toDouble() : 0.0;
            break;
          case HealthDataType.HEART_RATE:
            if (e.value is num) {
              hrSum += (e.value as num).toDouble();
              hrCount++;
            }
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
          case HealthDataType.APPLE_STAND_HOUR:
            standTotal += (e.value is num) ? (e.value as num).toDouble() : 0.0;
            break;
          default:
            break;
        }
      }

      steps.value = stepsTotal;
      activeEnergy.value = kcalTotal;
      heartRate.value = hrCount > 0 ? hrSum / hrCount : 0.0;
      sleepHours.value = sleepMinutes / 60.0;
      waterLiters.value = waterMl / 1000.0;
      standHours.value = standTotal;
    } catch (_) {
      // ignore errors but keep previous values
    }
  }
}
