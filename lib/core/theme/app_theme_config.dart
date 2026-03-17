import 'package:bullatech/core/enums/theme/app_theme_mode.dart';
import 'package:flutter/material.dart';

class AppThemeConfig {
  // Current mode
  static AppThemeMode mode = AppThemeMode.light;

  // Optional colors for custom theme
  static Color? customPrimary;
  static Color? customSecondary;

  // Toggle theme
  static void toggleTheme() {
    mode = mode == AppThemeMode.light ? AppThemeMode.dark : AppThemeMode.light;
  }
}
