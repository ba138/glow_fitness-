import 'package:get/get.dart';

enum HeightUnit { cm, ft }

class ProfileController extends GetxController {
  final name = 'Basit Ali'.obs;
  final weight = 72.0.obs;
  final height = 178.0.obs;
  final heightUnit = HeightUnit.cm.obs;
  final age = 26.obs;
  final detailsCompleted = false.obs;

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

  void updateProfile({
    required String newName,
    required double newWeight,
    required double newHeight,
    required HeightUnit newHeightUnit,
    required int newAge,
  }) {
    name.value = newName.trim();
    weight.value = newWeight;
    height.value = newHeight;
    heightUnit.value = newHeightUnit;
    age.value = newAge;
    detailsCompleted.value = true;
  }
}
