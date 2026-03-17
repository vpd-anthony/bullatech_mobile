import 'package:flutter/material.dart';

import 'app_theme.dart';

class AppThemeQr {
  const AppThemeQr._();

  static Color get moduleColor {
    final isDark = AppTheme.theme.brightness == Brightness.dark;
    return isDark ? Colors.white : Colors.black;
  }

  static Color get backgroundColor {
    final isDark = AppTheme.theme.brightness == Brightness.dark;
    return isDark ? Colors.black : Colors.white;
  }
}
