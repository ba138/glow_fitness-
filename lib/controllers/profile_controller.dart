import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum HeightUnit { cm, ft }

class ProfileController extends GetxController {
  static const _nameKey = 'profile_name';
  static const _weightKey = 'profile_weight';
  static const _heightKey = 'profile_height';
  static const _heightUnitKey = 'profile_height_unit';
  static const _ageKey = 'profile_age';
  static const _detailsCompletedKey = 'profile_details_completed';

  final name = 'Basit Ali'.obs;
  final weight = 72.0.obs;
  final height = 178.0.obs;
  final heightUnit = HeightUnit.cm.obs;
  final age = 26.obs;
  final detailsCompleted = false.obs;
  final loaded = false.obs;

  String get firstName {
    final trimmed = name.value.trim();
    if (trimmed.isEmpty) {
      return 'there';
    }
    return trimmed.split(RegExp(r'\s+')).first;
  }

  String get formattedWeight {
    final value = weight.value;
    return value % 1 == 0 ? value.toStringAsFixed(0) : value.toStringAsFixed(1);
  }

  String get formattedHeight {
    final value = height.value;
    final precision = heightUnit.value == HeightUnit.cm || value % 1 == 0
        ? 0
        : 1;
    return value.toStringAsFixed(precision);
  }

  String get heightUnitLabel => heightUnit.value == HeightUnit.cm ? 'cm' : 'ft';

  Future<void> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final savedName = prefs.getString(_nameKey);
    final savedWeight = prefs.getDouble(_weightKey);
    final savedHeight = prefs.getDouble(_heightKey);
    final savedHeightUnit = prefs.getString(_heightUnitKey);
    final savedAge = prefs.getInt(_ageKey);
    final savedDetailsCompleted = prefs.getBool(_detailsCompletedKey) ?? false;

    if (savedName != null && savedName.trim().isNotEmpty) {
      name.value = savedName;
    }
    if (savedWeight != null) {
      weight.value = savedWeight;
    }
    if (savedHeight != null) {
      height.value = savedHeight;
    }
    if (savedHeightUnit != null) {
      heightUnit.value = savedHeightUnit == HeightUnit.ft.name
          ? HeightUnit.ft
          : HeightUnit.cm;
    }
    if (savedAge != null) {
      age.value = savedAge;
    }

    detailsCompleted.value = savedDetailsCompleted;
    loaded.value = true;
  }

  Future<void> updateProfile({
    required String newName,
    required double newWeight,
    required double newHeight,
    required HeightUnit newHeightUnit,
    required int newAge,
  }) async {
    final trimmedName = newName.trim();
    name.value = trimmedName;
    weight.value = newWeight;
    height.value = newHeight;
    heightUnit.value = newHeightUnit;
    age.value = newAge;
    detailsCompleted.value = true;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nameKey, trimmedName);
    await prefs.setDouble(_weightKey, newWeight);
    await prefs.setDouble(_heightKey, newHeight);
    await prefs.setString(_heightUnitKey, newHeightUnit.name);
    await prefs.setInt(_ageKey, newAge);
    await prefs.setBool(_detailsCompletedKey, true);
  }
}
