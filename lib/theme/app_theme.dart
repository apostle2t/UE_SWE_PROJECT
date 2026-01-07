import 'package:flutter/material.dart';
import 'app_colors.dart';

/// App theme configuration
class AppTheme {
  AppTheme._();

  /// Light theme configuration
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.primaryGreen,
      scaffoldBackgroundColor: AppColors.darkGreen,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryGreen,
        secondary: AppColors.lightGreen,
        surface: AppColors.white,
      ),
      useMaterial3: true,
    );
  }

  /// Dark theme configuration
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.primaryGreen,
      scaffoldBackgroundColor: AppColors.darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryGreen,
        secondary: AppColors.lightGreen,
        surface: AppColors.darkCard,
      ),
      useMaterial3: true,
    );
  }
}
