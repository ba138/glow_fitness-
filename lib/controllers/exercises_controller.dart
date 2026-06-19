import 'dart:async';
import 'package:get/get.dart';

class ExercisesController extends GetxController {
  final exercises = <(String, int)>[
    ('Jumping Jacks', 180),
    ('High Knees', 180),
    ('Burpees', 240),
    ('Mountain Climbers', 240),
    ('Squat Jumps', 240),
    ('Push-Ups', 240),
    ('Lunges', 240),
    ('Bear Crawls', 180),
    ('Plank', 180),
  ];

  final currentIndex = 0.obs;
  final remainingSeconds = 0.obs;
  final isActive = false.obs;
  final isCompleted = false.obs;

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    remainingSeconds.value = exercises[0].$2;
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
        if (currentIndex.value < exercises.length - 1) {
          currentIndex.value++;
          remainingSeconds.value = exercises[currentIndex.value].$2;
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
    remainingSeconds.value = exercises[0].$2;
    isActive.value = false;
    isCompleted.value = false;
  }

  double getProgress() {
    final currentExercise = exercises[currentIndex.value];
    return 1.0 - (remainingSeconds.value / currentExercise.$2);
  }

  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  String getCurrentExerciseName() => exercises[currentIndex.value].$1;

  int getCurrentExerciseDuration() => exercises[currentIndex.value].$2;

  int getTotalExercises() => exercises.length;

  int getCurrentExerciseNumber() => currentIndex.value + 1;
}
