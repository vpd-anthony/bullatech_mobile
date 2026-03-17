import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

@pragma('vm:entry-point')
void notificationTapBackground(
    final NotificationResponse notificationResponse) async {
  debugPrint(
      'Notification tapped in background: ${notificationResponse.payload}');
  if (notificationResponse.payload != null) {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'notification_payload', notificationResponse.payload!);
  }
}

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin
        ?.createNotificationChannel(const AndroidNotificationChannel(
      'idle_channel',
      'Idle Logout',
      description: 'User is logged out due to inactivity',
      importance: Importance.max,
    ));

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse:
          (final NotificationResponse response) async {
        debugPrint(' Foreground tap payload: ${response.payload}');

        if (response.payload != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('notification_payload', response.payload!);
        }

        // When use click the notifications of 'session timed out' this will fire
        if (response.payload == 'idle_logout') {
          // navigatorKey.currentState?.pushReplacement(
          //   MaterialPageRoute(builder: (_) => const LoginPage()),
          // );
        }
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }

  /// Ask user permission to allow notifications (Android 13+ and iOS)
  static Future<bool> requestPermission(final BuildContext context) async {
    final navigator = Navigator.of(context);

    if (Platform.isAndroid) {
      final status = await Permission.notification.status;
      if (status.isGranted) return true;

      final result = await Permission.notification.request();
      if (result.isGranted) return true;

      if (result.isPermanentlyDenied) {
        WidgetsBinding.instance.addPostFrameCallback((final _) async {
          await _showSettingsDialog(navigator.context);
        });
      }
      return false;
    }

    if (Platform.isIOS) {
      final iosPlugin = _plugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      if (iosPlugin != null) {
        final granted = await iosPlugin.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
        if (granted ?? false) return true;

        WidgetsBinding.instance.addPostFrameCallback((final _) async {
          await _showSettingsDialog(navigator.context);
        });
        return false;
      }
    }

    return false;
  }

  static Future<void> _showSettingsDialog(final BuildContext context) async {
    if (!context.mounted) return;

    await showDialog(
      context: context,
      builder: (final ctx) => AlertDialog(
        title: const Text('Enable Notifications'),
        content: const Text(
          'Please enable notifications in your settings to receive alerts.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  /// Requests notification permission **without using BuildContext**.
  static Future<bool> requestPermissionWithoutContext() async {
    if (Platform.isAndroid) {
      final status = await Permission.notification.status;
      if (status.isGranted) return true;

      final result = await Permission.notification.request();
      return result.isGranted;
    }

    if (Platform.isIOS) {
      final iosPlugin = _plugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      if (iosPlugin != null) {
        final granted = await iosPlugin.requestPermissions(
            alert: true, badge: true, sound: true);
        return granted ?? false;
      }
    }

    return false;
  }

  /// Local notification for idle logout
  static Future<void> showIdleLogoutNotification() async {
    debugPrint(' Showing Idle Logout Notification...');
    const androidDetails = AndroidNotificationDetails(
        'idle_channel', 'Idle Logout',
        channelDescription: 'User is logged out due to inactivity',
        importance: Importance.max,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
        color: Color.fromRGBO(34, 40, 49, 1));

    const notificationDetails = NotificationDetails(android: androidDetails);

    await _plugin.show(
      0,
      'Bullatech Session Timed Out',
      'Oops! You forgot to use Bullatech. For your security, we closed the app. Just log in again to continue.',
      notificationDetails,
      payload: 'idle_logout',
    );
  }

  /// Optional helper to show a local notification for testing
  static Future<void> showWelcomeNotification() async {
    const androidDetails = AndroidNotificationDetails(
      'general_channel',
      'General Notifications',
      channelDescription: 'General app notifications',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );
    const notificationDetails = NotificationDetails(android: androidDetails);
    await _plugin.show(
      1,
      'Welcome Back 👋',
      'Notifications are enabled — stay updated with Bullatech.',
      notificationDetails,
    );
  }

  /// Call this on app startup to handle previously tapped notification
  static Future<void> handlePendingNotificationTap() async {
    final prefs = await SharedPreferences.getInstance();
    final payload = prefs.getString('notification_payload');
    if (payload != null) {
      debugPrint(' Handling stored notification payload: $payload');
      await prefs.remove('notification_payload');

      if (payload == 'idle_logout') {
        // navigatorKey.currentState?.pushReplacement(
        //   MaterialPageRoute(builder: (final _) => const LoginPage()),
        // );
      }
    }
  }
}
