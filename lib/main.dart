import 'package:bullatech/app.dart';
import 'package:bullatech/core/providers/theme_provider.dart';
import 'package:bullatech/core/routing/app_router.dart';
import 'package:bullatech/core/services/notification_service.dart';
import 'package:bullatech/core/theme/app_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationService.init();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: AppColors.background,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    if (kDebugMode) {
      debugPrint('.env file not found: $e');
    }
  }

  final container = ProviderContainer();

  await container.read(appThemeModeNotifierProvider.notifier).loadSavedTheme();

  final router = container.read(appRouterProvider);

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: MyApp(router: router),
    ),
  );
}
