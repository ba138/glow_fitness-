import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';

class HealthController extends GetxController with WidgetsBindingObserver {
  final Health _health = Health();
  bool _healthPermissionRequested = false;

  Timer? _healthTimer;

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
    _stopHealthMonitoring();
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      _tryRequestPermissionsOnResume();

      if (authorized.value) {
        fetchTodayData();
        _startHealthMonitoring();
      }
    }

    if (state == AppLifecycleState.paused) {
      _stopHealthMonitoring();
    }
  }

  void _tryRequestPermissionsOnResume() {
    if (!_healthPermissionRequested && !authorized.value) {
      _healthPermissionRequested = true;
      requestPermissions();
    }
  }

  void _startHealthMonitoring() {
    _healthTimer?.cancel();

    _healthTimer = Timer.periodic(const Duration(seconds: 10), (_) async {
      if (authorized.value) {
        await fetchTodayData();
      }
    });
  }

  void _stopHealthMonitoring() {
    _healthTimer?.cancel();
    _healthTimer = null;
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

        await Future<void>.delayed(const Duration(milliseconds: 500));
      }

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
        _startHealthMonitoring();
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
      final totalSteps = await _health.getTotalStepsInInterval(midnight, now);

      steps.value = totalSteps?.toDouble() ?? 0.0;

      final types = [
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

      double kcalTotal = 0.0;
      double hrSum = 0.0;
      int hrCount = 0;
      double sleepMinutes = 0.0;
      double waterLitersTotal = 0.0;
      double standTotal = 0.0;

      for (final e in data) {
        double value = 0.0;

        try {
          if (e.value is NumericHealthValue) {
            value = (e.value as NumericHealthValue).numericValue.toDouble();
          } else if (e.value is num) {
            value = (e.value as num).toDouble();
          }
        } catch (_) {}

        switch (e.type) {
          case HealthDataType.ACTIVE_ENERGY_BURNED:
            kcalTotal += value;
            break;

          case HealthDataType.HEART_RATE:
            hrSum += value;
            hrCount++;
            break;

          case HealthDataType.SLEEP_ASLEEP:
            sleepMinutes += value;
            break;

          case HealthDataType.WATER:
            waterLitersTotal += value;
            break;

          case HealthDataType.APPLE_STAND_HOUR:
            standTotal += value;
            break;

          default:
            break;
        }
      }
      debugPrint(
        'Health data: kcal=$kcalTotal, hr=${hrCount > 0 ? hrSum / hrCount : 0.0}, sleep=${sleepMinutes / 60.0}, water=$waterLitersTotal, stand=$standTotal',
      );
      activeEnergy.value = kcalTotal;
      heartRate.value = hrCount > 0 ? hrSum / hrCount : 0.0;
      sleepHours.value = sleepMinutes / 60.0;
      waterLiters.value = waterLitersTotal;
      standHours.value = standTotal;
    } catch (_) {}
  }
}
