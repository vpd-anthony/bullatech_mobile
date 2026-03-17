import 'package:bullatech/core/enums/theme/app_theme_mode.dart';
import 'package:bullatech/core/theme/app_theme_config.dart';
import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  // Private constructor
  AppTheme._();

  // ====================== GET CURRENT THEME ======================
  static ThemeData get theme => getThemeByMode(
        AppThemeConfig.mode,
        customPrimary: AppThemeConfig.customPrimary,
        customSecondary: AppThemeConfig.customSecondary,
      );

  // ====================== GET CURRENT TEXT THEME ==================
  static TextTheme get textTheme => theme.textTheme;

  // ====================== LIGHT THEME ======================
  static ThemeData get lightTheme {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primary,
        onPrimary: AppColors.textWhite,
        secondary: AppColors.secondary,
        onSecondary: AppColors.textWhite,
        error: AppColors.error,
        onError: AppColors.textWhite,
        background: AppColors.background,
        onBackground: AppColors.textPrimary,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
      ),
      fontFamily: AppTextStyles.fontRegular,
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textWhite,
        elevation: 0,
        titleTextStyle: AppTextStyles.headline6.copyWith(
          color: AppColors.textWhite,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardTheme(
        color: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: AppTextStyles.button,
        ),
      ),
      textTheme: TextTheme(
        displayLarge: AppTextStyles.headline1,
        displayMedium: AppTextStyles.headline2,
        displaySmall: AppTextStyles.headline3,
        headlineMedium: AppTextStyles.headline4,
        headlineSmall: AppTextStyles.headline5,
        titleLarge: AppTextStyles.headline6,
        bodyLarge: AppTextStyles.bodyText1,
        bodyMedium:
            AppTextStyles.bodyText2.copyWith(color: AppColors.textSecondary),
        bodySmall:
            AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
        labelLarge: AppTextStyles.button.copyWith(color: AppColors.textPrimary),
      ),
    );

    return base.copyWith(
      inputDecorationTheme: base.inputDecorationTheme,
      switchTheme: base.switchTheme,
      sliderTheme: base.sliderTheme,
      bottomNavigationBarTheme: base.bottomNavigationBarTheme,
      tabBarTheme: base.tabBarTheme,
      floatingActionButtonTheme: base.fabTheme,
      expansionTileTheme: base.expansionTileTheme,
    );
  }

  // ====================== DARK THEME ======================
  static ThemeData get darkTheme {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        onPrimary: Colors.black,
        secondary: AppColors.secondary,
        onSecondary: Colors.black,
        error: AppColors.error,
        onError: AppColors.textWhite,
        background: Color(0xFF121212),
        onBackground: AppColors.textWhite,
        surface: Color(0xFF1E1E1E),
        onSurface: AppColors.textWhite,
      ),
      fontFamily: AppTextStyles.fontRegular,
      scaffoldBackgroundColor: const Color(0xFF121212),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF1E1E1E),
        foregroundColor: AppColors.textWhite,
        elevation: 0,
        titleTextStyle: AppTextStyles.headline6.copyWith(
          color: AppColors.textWhite,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardTheme(
        color: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: AppTextStyles.button,
        ),
      ),
      textTheme: TextTheme(
        displayLarge:
            AppTextStyles.headline1.copyWith(color: AppColors.textWhite),
        displayMedium:
            AppTextStyles.headline2.copyWith(color: AppColors.textWhite),
        displaySmall:
            AppTextStyles.headline3.copyWith(color: AppColors.textWhite),
        headlineMedium:
            AppTextStyles.headline4.copyWith(color: AppColors.textWhite),
        headlineSmall:
            AppTextStyles.headline5.copyWith(color: AppColors.textWhite),
        titleLarge:
            AppTextStyles.headline6.copyWith(color: AppColors.textWhite),
        bodyLarge: AppTextStyles.bodyText1.copyWith(color: AppColors.textWhite),
        bodyMedium:
            AppTextStyles.bodyText2.copyWith(color: AppColors.textWhite),
        bodySmall: AppTextStyles.caption.copyWith(color: AppColors.textWhite),
        labelLarge: AppTextStyles.button.copyWith(color: AppColors.textWhite),
      ),
    );

    return base.copyWith(
      inputDecorationTheme: base.inputDecorationTheme,
      switchTheme: base.switchTheme,
      sliderTheme: base.sliderTheme,
      bottomNavigationBarTheme: base.bottomNavigationBarTheme,
      tabBarTheme: base.tabBarTheme,
      floatingActionButtonTheme: base.fabTheme,
      expansionTileTheme: base.expansionTileTheme,
    );
  }

  // ====================== CUSTOM THEME ======================
  static ThemeData customTheme({
    required final Color primaryColor,
    required final Color secondaryColor,
    required final Brightness brightness,
  }) {
    final isDark = brightness == Brightness.dark;

    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: primaryColor,
        onPrimary: isDark ? Colors.black : AppColors.textWhite,
        secondary: secondaryColor,
        onSecondary: isDark ? Colors.black : AppColors.textWhite,
        error: AppColors.error,
        onError: AppColors.textWhite,
        background: isDark ? Colors.black : AppColors.textWhite,
        onBackground: isDark ? AppColors.textWhite : Colors.black87,
        surface: isDark ? Colors.grey[900]! : Colors.grey[50]!,
        onSurface: isDark ? AppColors.textWhite : Colors.black87,
      ),
      fontFamily: AppTextStyles.fontRegular,
      scaffoldBackgroundColor: isDark ? Colors.black : Colors.grey[50],
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: isDark ? Colors.black : AppColors.textWhite,
        elevation: 0,
        titleTextStyle: AppTextStyles.headline6.copyWith(
          color: isDark ? Colors.black : AppColors.textWhite,
          fontWeight: FontWeight.w600,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: isDark ? Colors.black : AppColors.textWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: AppTextStyles.button,
        ),
      ),
      textTheme: TextTheme(
        displayLarge: AppTextStyles.headline1
            .copyWith(color: isDark ? AppColors.textWhite : Colors.black),
        displayMedium: AppTextStyles.headline2
            .copyWith(color: isDark ? AppColors.textWhite : Colors.black),
        displaySmall: AppTextStyles.headline3
            .copyWith(color: isDark ? AppColors.textWhite : Colors.grey[900]),
        headlineMedium: AppTextStyles.headline4
            .copyWith(color: isDark ? AppColors.textWhite : Colors.grey[800]),
        headlineSmall: AppTextStyles.headline5
            .copyWith(color: isDark ? AppColors.textWhite : Colors.grey[800]),
        titleLarge: AppTextStyles.headline6
            .copyWith(color: isDark ? AppColors.textWhite : Colors.grey[900]),
        bodyLarge: AppTextStyles.bodyText1
            .copyWith(color: isDark ? AppColors.textWhite : Colors.grey[800]),
        bodyMedium: AppTextStyles.bodyText2
            .copyWith(color: isDark ? AppColors.textWhite : Colors.grey[700]),
        bodySmall: AppTextStyles.caption
            .copyWith(color: isDark ? AppColors.textWhite : Colors.grey[600]),
        labelLarge: AppTextStyles.button
            .copyWith(color: isDark ? AppColors.textWhite : Colors.grey[900]),
      ),
    );

    return base.copyWith(
      inputDecorationTheme: base.inputDecorationTheme,
      switchTheme: base.switchTheme,
      sliderTheme: base.sliderTheme,
      bottomNavigationBarTheme: base.bottomNavigationBarTheme,
      tabBarTheme: base.tabBarTheme,
      floatingActionButtonTheme: base.fabTheme,
      expansionTileTheme: base.expansionTileTheme,
    );
  }

  // ====================== GET THEME BY MODE ======================
  static ThemeData getThemeByMode(
    final AppThemeMode mode, {
    final Color? customPrimary,
    final Color? customSecondary,
  }) {
    switch (mode) {
      case AppThemeMode.light:
        return lightTheme;
      case AppThemeMode.dark:
        return darkTheme;
      case AppThemeMode.custom:
        return customTheme(
          primaryColor: customPrimary ?? AppColors.primary,
          secondaryColor: customSecondary ?? AppColors.secondary,
          brightness: Brightness.light,
        );
    }
  }
}

// ====================== WIDGET THEMES EXTENSION ======================
extension AppThemeWidgets on ThemeData {
  InputDecorationTheme get inputDecorationTheme => InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.error, width: 2),
        ),
        hintStyle: AppTextStyles.bodyText2.copyWith(color: AppColors.textHint),
        labelStyle:
            AppTextStyles.bodyText2.copyWith(color: AppColors.textSecondary),
      );

  SwitchThemeData get switchTheme => SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((final states) =>
            states.contains(MaterialState.selected)
                ? colorScheme.primary
                : Colors.grey),
        trackColor: MaterialStateProperty.resolveWith((final states) =>
            states.contains(MaterialState.selected)
                ? colorScheme.primary.withOpacity(0.5)
                : Colors.grey.shade400),
      );

  SliderThemeData get sliderTheme => SliderThemeData(
        activeTrackColor: colorScheme.primary,
        inactiveTrackColor: colorScheme.primary.withOpacity(0.3),
        thumbColor: colorScheme.primary,
        overlayColor: colorScheme.primary.withOpacity(0.2),
        valueIndicatorTextStyle:
            AppTextStyles.bodyText2.copyWith(color: AppColors.textWhite),
      );

  BottomNavigationBarThemeData get bottomNavigationBarTheme =>
      BottomNavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurface.withOpacity(0.6),
        selectedLabelStyle:
            AppTextStyles.button.copyWith(color: colorScheme.primary),
        unselectedLabelStyle: AppTextStyles.button
            .copyWith(color: colorScheme.onSurface.withOpacity(0.6)),
        type: BottomNavigationBarType.fixed,
      );

  TabBarTheme get tabBarTheme => TabBarTheme(
        labelColor: colorScheme.primary,
        unselectedLabelColor: colorScheme.onSurface.withOpacity(0.6),
        labelStyle: AppTextStyles.button.copyWith(color: colorScheme.primary),
        unselectedLabelStyle: AppTextStyles.button
            .copyWith(color: colorScheme.onSurface.withOpacity(0.6)),
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
      );

  FloatingActionButtonThemeData get fabTheme => FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      );

  ExpansionTileThemeData get expansionTileTheme => const ExpansionTileThemeData(
        iconColor: AppColors.primaryDark, // expanded arrow
        collapsedIconColor: AppColors.primaryDark, // collapsed arrow
        textColor: AppColors.primaryDark, // expanded title color
        collapsedTextColor: AppColors.textPrimary,
        childrenPadding: EdgeInsets.only(left: 24),
      );
}
