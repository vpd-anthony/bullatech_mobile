import 'package:bullatech/core/enums/theme/app_theme_mode.dart';
import 'package:bullatech/core/theme/storage/theme_storage_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_provider.g.dart';

final themeStorageServiceProvider = Provider<ThemeStorageService>((final ref) {
  return ThemeStorageService();
});

@riverpod
class AppThemeModeNotifier extends _$AppThemeModeNotifier {
  @override
  AppThemeMode build() {
    // Default to light theme initially
    _loadSavedTheme(); // async load saved theme
    return AppThemeMode.light;
  }

  // Inject storage service
  late final _storage = ThemeStorageService();

  // Load saved theme
  Future<void> _loadSavedTheme() async {
    final savedTheme = await _storage.loadThemeMode();
    if (savedTheme != null) state = savedTheme;
  }

  // Public method for main.dart
  Future<void> loadSavedTheme() async => await _loadSavedTheme();

  // Set theme methods
  void setLight() {
    state = AppThemeMode.light;
    _storage.saveThemeMode(state);
  }

  void setDark() {
    state = AppThemeMode.dark;
    _storage.saveThemeMode(state);
  }

  void setCustom() {
    state = AppThemeMode.custom;
    _storage.saveThemeMode(state);
  }
}

//Usage
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../core/providers/theme_provider.dart';

// class ThemeSettingsPage extends ConsumerWidget {
//   const ThemeSettingsPage({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final currentTheme = ref.watch(appThemeModeNotifierProvider);

//     return Scaffold(
//       appBar: AppBar(title: const Text('Theme Settings')),
//       body: Column(
//         children: [
//           ListTile(
//             title: const Text('Light Theme'),
//             leading: Radio<AppThemeMode>(
//               value: AppThemeMode.light,
//               groupValue: currentTheme,
//               onChanged: (value) {
//                 if (value != null) {
//                   ref.read(appThemeModeNotifierProvider.notifier).setLight();
//                 }
//               },
//             ),
//           ),
//           ListTile(
//             title: const Text('Dark Theme'),
//             leading: Radio<AppThemeMode>(
//               value: AppThemeMode.dark,
//               groupValue: currentTheme,
//               onChanged: (value) {
//                 if (value != null) {
//                   ref.read(appThemeModeNotifierProvider.notifier).setDark();
//                 }
//               },
//             ),
//           ),
//           ListTile(
//             title: const Text('Custom Theme'),
//             leading: Radio<AppThemeMode>(
//               value: AppThemeMode.custom,
//               groupValue: currentTheme,
//               onChanged: (value) {
//                 if (value != null) {
//                   ref.read(appThemeModeNotifierProvider.notifier).setCustom();
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
