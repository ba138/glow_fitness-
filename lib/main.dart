import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const GlowFitnessApp());
}

class GlowFitnessApp extends StatelessWidget {
  const GlowFitnessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Glow Fitness',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const SplashScreen(),
    );
  }
}
