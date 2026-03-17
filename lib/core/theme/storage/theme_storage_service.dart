import 'package:bullatech/core/enums/theme/app_theme_mode.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeStorageService {
  static const _keyThemeMode = 'themeMode';

  Future<void> saveThemeMode(final AppThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyThemeMode, mode.index);
  }

  Future<AppThemeMode?> loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final index = prefs.getInt(_keyThemeMode);
    if (index == null || index < 0 || index >= AppThemeMode.values.length) {
      return null;
    }
    return AppThemeMode.values[index];
  }
}
