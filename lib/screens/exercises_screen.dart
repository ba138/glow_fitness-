import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/exercises_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/aurora_background.dart';
import '../widgets/glass_card.dart';

class ExercisesScreen extends StatelessWidget {
  ExercisesScreen({
    super.key,
    this.title = 'Full Body Fat Burn',
    List<(String, int)>? exercises,
  }) : controller = Get.put(
         ExercisesController(exercises: exercises),
         tag: title,
       );

  final String title;
  final ExercisesController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isCompleted.value) {
        return _buildCompletedView();
      }

      return Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: AuroraBackground(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              children: [
                _topBar(context),
                const SizedBox(height: 16),

                _activeExerciseCard(),
                const SizedBox(height: 24),
                _controlButtons(),
                const SizedBox(height: 24),
                const Text(
                  'Next Exercises',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                for (
                  int i = controller.currentIndex.value;
                  i < controller.exercises.length;
                  i++
                ) ...[
                  _exerciseListItem(
                    i,
                    controller.exercises[i].$1,
                    controller.exercises[i].$2,
                  ),
                  if (i < controller.exercises.length - 1)
                    const SizedBox(height: 10),
                ],
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildCompletedView() {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: AuroraBackground(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppColors.accentGradient,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Workout Complete!',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Great job completing all exercises!',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 32),
                GlassCard(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  gradient: AppColors.primaryGradient,
                  child: GestureDetector(
                    onTap: () => controller.resetWorkout(),
                    child: const Text(
                      'Start Again',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _topBar(BuildContext context) {
    return Row(
      children: [
        GlassCard(
          padding: const EdgeInsets.all(10),
          borderRadius: 16,
          child: GestureDetector(
            onTap: () => Navigator.maybePop(context),
            child: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
        ),
        SizedBox(width: 30),
        Text(
          title,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _activeExerciseCard() {
    return Obx(() {
      final progress = controller.getProgress();
      return GlassCard(
        gradient: AppColors.primaryGradient,
        child: Column(
          children: [
            const Text(
              'Current Exercise',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              controller.getCurrentExerciseName(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox.expand(
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 8,
                      backgroundColor: Colors.white.withValues(alpha: 0.1),
                      valueColor: AlwaysStoppedAnimation(
                        progress > 0.5 ? AppColors.lime : AppColors.accent,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        controller.formatTime(
                          controller.remainingSeconds.value,
                        ),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 48,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Courier',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                    child: Text(
                      '${controller.getCurrentExerciseNumber()}/${controller.getTotalExercises()}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _controlButtons() {
    return Obx(
      () => Row(
        children: [
          Expanded(
            child: GlassCard(
              padding: const EdgeInsets.symmetric(vertical: 14),
              borderRadius: 14,
              onTap: controller.isActive.value
                  ? () => controller.pauseWorkout()
                  : () => controller.startWorkout(),
              gradient: controller.isActive.value
                  ? const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppColors.accent, AppColors.amber],
                    )
                  : AppColors.primaryGradient,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    controller.isActive.value
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    controller.isActive.value ? 'Pause' : 'Start',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          GlassCard(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            borderRadius: 14,
            onTap: () => controller.resetWorkout(),
            child: const Icon(Icons.refresh_rounded, color: AppColors.lime),
          ),
        ],
      ),
    );
  }

  Widget _exerciseListItem(int index, String name, int duration) {
    return Obx(() {
      final isCurrentExercise = index == controller.currentIndex.value;
      return GlassCard(
        padding: const EdgeInsets.all(14),
        borderRadius: 16,
        gradient: isCurrentExercise ? AppColors.primaryGradient : null,
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCurrentExercise
                    ? Colors.white.withValues(alpha: 0.2)
                    : Colors.white.withValues(alpha: 0.1),
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    color: isCurrentExercise
                        ? Colors.white
                        : AppColors.textSecondary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      color: isCurrentExercise
                          ? Colors.white
                          : AppColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    controller.formatTime(duration),
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            if (isCurrentExercise)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.lime.withValues(alpha: 0.2),
                ),
                child: const Text(
                  'Now',
                  style: TextStyle(
                    color: AppColors.lime,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }
}
