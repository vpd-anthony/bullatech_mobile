import 'package:bullatech/core/enums/theme/app_theme_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/providers/theme_provider.dart';
import 'core/theme/app_theme.dart';

class MyApp extends ConsumerWidget {
  final GoRouter router;
  const MyApp({super.key, required this.router});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final themeMode = ref.watch(appThemeModeNotifierProvider);
    return MaterialApp.router(
      title: 'Bullatech',
      routerConfig: router,
      theme: AppTheme.getThemeByMode(themeMode),
      darkTheme: AppTheme.darkTheme,
      themeMode:
          themeMode == AppThemeMode.dark ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner: false,
    );
  }
}
