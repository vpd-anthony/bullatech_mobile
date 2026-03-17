import 'package:flutter/material.dart';

class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  // ========== Primary Colors ========== FF7D29
  static const Color primary = Color.fromRGBO(255, 125, 41, 1); // Blue

  static const Color primaryLight = Color(0xFF64B5F6);
  static const Color primaryDark = Color(0xFF222222);

  // ========== Secondary Colors ==========
  static const Color secondary = Color(0xFFFF9800); // Orange
  static const Color secondaryLight = Color(0xFFFFB74D);
  static const Color secondaryDark = Color(0xFFF57C00);

  // ========== Custom Colors ==========
  static const Color primaryIndigo = Color(0xFF6366F1);
  static const Color backgroundWhite = Colors.white;

  // ========== Status Colors ==========
  static const Color success = Color(0xFF4CAF50); // Green
  static const Color error = Color(0xFFF44336); // Red
  static const Color warning = Color(0xFFFF9800); // Orange
  static const Color info = Color(0xFF2196F3); // Blue

  // ========== Text Colors ==========
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFF9E9E9E);
  static const Color textWhite = Color(0xFFFFFFFF);

  static const Color transparent = Colors.transparent;

  // ========== Background Colors ==========
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFFAFAFA);

  // ========== Border Colors ==========
  static const Color border = Color(0xFFE0E0E0);
  static const Color divider = Color(0xFFBDBDBD);

  // ========== Gradient Colors ==========
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF66BB6A), Color(0xFF43A047)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient errorGradient = LinearGradient(
    colors: [Color(0xFFEF5350), Color(0xFFE53935)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ========== Shadow Colors ==========
  static const Color shadow = Color(0x1A000000);
  static final Color shadowLight = Colors.black.withOpacity(0.05);
  static final Color shadowMedium = Colors.black.withOpacity(0.1);
  static final Color shadowDark = Colors.black.withOpacity(0.2);

  // ========== Overlay Colors ==========
  static final Color overlay = Colors.black.withOpacity(0.5);
  static final Color overlayLight = Colors.black.withOpacity(0.3);

  static const normalColor = Color.fromARGB(255, 204, 204, 204);
}
