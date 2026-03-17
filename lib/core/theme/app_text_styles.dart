import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyles {
  // Private constructor to prevent instantiation
  AppTextStyles._();

  // ================= FONT FAMILY =================
  static const String fontRegular = 'InterTight-Regular';
  static const String fontBold = 'InterTight-Bold';

  // ================= HEADLINES =================
  static const TextStyle headline1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    fontFamily: fontBold,
  );

  static const TextStyle headline2 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    fontFamily: fontBold,
  );

  static const TextStyle headline3 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    fontFamily: fontRegular,
  );

  static const TextStyle headline4 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    fontFamily: fontRegular,
  );

  static const TextStyle headline5 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    fontFamily: fontRegular,
  );

  static const TextStyle headline6 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    fontFamily: fontRegular,
  );

  // ================= BODY TEXT =================
  static const TextStyle bodyText1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    fontFamily: fontRegular,
    height: 1.5,
  );

  static const TextStyle bodyText2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    fontFamily: fontRegular,
    height: 1.5,
  );

  // ================= SUBTITLES =================
  static const TextStyle subtitle1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    fontFamily: fontRegular,
  );

  static const TextStyle subtitle2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    fontFamily: fontRegular,
  );

  // ================= BUTTONS =================
  static const TextStyle button = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    fontFamily: fontRegular,
  );

  static const TextStyle buttonLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    fontFamily: fontRegular,
  );

  static const TextStyle buttonSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    fontFamily: fontRegular,
  );

  // ================= CAPTION & OVERLINE =================
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    fontFamily: fontRegular,
  );

  static const TextStyle overline = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    fontFamily: fontRegular,
  );
}
