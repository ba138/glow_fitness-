import 'dart:async';
import 'package:get/get.dart';

class YogaController extends GetxController {
  final poses = <(String, int)>[
    ('Downward-Facing Dog', 60),
    ('Sun Salutation Flow', 180),
    ('Warrior I · Right', 60),
    ('Warrior I · Left', 60),
    ('Warrior II · Right', 60),
    ('Warrior II · Left', 60),
    ('Tree Pose · Right', 45),
    ('Tree Pose · Left', 45),
    ('Cobra Pose', 60),
    ('Bridge Pose', 60),
    ('Plank Pose', 60),
    ('Low Lunge Stretch · Right', 60),
    ('Low Lunge Stretch · Left', 60),
    ('Seated Forward Fold', 90),
  ];

  final currentIndex = 0.obs;
  final remainingSeconds = 0.obs;
  final isActive = false.obs;
  final isCompleted = false.obs;

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    remainingSeconds.value = poses[0].$2;
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void startWorkout() {
    if (remainingSeconds.value <= 0) return;

    isActive.value = true;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      remainingSeconds.value--;

      if (remainingSeconds.value <= 0) {
        if (currentIndex.value < poses.length - 1) {
          currentIndex.value++;
          remainingSeconds.value = poses[currentIndex.value].$2;
        } else {
          isActive.value = false;
          isCompleted.value = true;
          timer.cancel();
        }
      }
    });
  }

  void pauseWorkout() {
    _timer?.cancel();
    isActive.value = false;
  }

  void resetWorkout() {
    _timer?.cancel();
    currentIndex.value = 0;
    remainingSeconds.value = poses[0].$2;
    isActive.value = false;
    isCompleted.value = false;
  }

  double getProgress() {
    final currentPose = poses[currentIndex.value];
    return 1.0 - (remainingSeconds.value / currentPose.$2);
  }

  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  String getCurrentPoseName() => poses[currentIndex.value].$1;

  int getCurrentPoseDuration() => poses[currentIndex.value].$2;

  int getTotalPoses() => poses.length;

  int getCurrentPoseNumber() => currentIndex.value + 1;
}
