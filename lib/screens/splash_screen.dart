import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/profile_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/aurora_background.dart';
import 'home_shell.dart';
import 'profilescreens/personal_details_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final _profile = Get.put(ProfileController());

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _controller.forward();
    Timer(const Duration(milliseconds: 2200), _openNextScreen);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _openNextScreen() async {
    await _profile.loadProfile();
    if (!mounted) return;

    final nextScreen = _profile.detailsCompleted.value
        ? const HomeShell()
        : const PersonalDetailsScreen(isOnboarding: true);

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (_, _, _) => nextScreen,
        transitionsBuilder: (_, animation, _, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: AuroraBackground(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // SizedBox(
                //   width: 100,
                //   height: 100,
                //   child: Image.asset(
                //     'assets/glow_fitness_luxury_logo.png',
                //     fit: BoxFit.contain,
                //   ),
                // ),
                // Icon(
                //   Icons.fitness_center_rounded,
                //   size: 72,
                //   color: AppColors.primary,
                // ),
                const SizedBox(height: 28),
                Text(
                  'Glow Fitness',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'A modern workout experience with motion and glow.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
