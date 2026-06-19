import 'package:flutter/material.dart';

/// Central palette and theme for the Glow Fitness app.
///
/// The look is a dark, vibrant gradient backdrop layered behind frosted
/// "glass" surfaces. Colors are intentionally saturated so the blur and
/// translucency read clearly.
class AppColors {
  AppColors._();

  static const Color background = Color(0xFF0B1020);
  static const Color backgroundAlt = Color(0xFF131A33);

  static const Color primary = Color(0xFF7C5CFF);
  static const Color secondary = Color(0xFF22D3EE);
  static const Color accent = Color(0xFFFF6FB5);
  static const Color lime = Color(0xFFA3E635);
  static const Color amber = Color(0xFFFFC062);

  static const Color textPrimary = Color(0xFFF5F6FF);
  static const Color textSecondary = Color(0xB3F5F6FF);
  static const Color textMuted = Color(0x80F5F6FF);

  static const Color glassFill = Color(0x1AFFFFFF);
  static const Color glassStroke = Color(0x33FFFFFF);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, secondary],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accent, amber],
  );
}

class AppTheme {
  AppTheme._();

  static ThemeData get dark {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.backgroundAlt,
      ),
      textTheme: base.textTheme.apply(
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
      ),
      splashFactory: InkRipple.splashFactory,
    );
  }
}
