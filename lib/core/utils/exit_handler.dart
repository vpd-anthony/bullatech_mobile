import 'package:flutter/material.dart';

class ExitHandler {
  // Private constructor to prevent instantiation
  ExitHandler._();

  static DateTime? _lastBackPressTime;

  /// Call this inside WillPopScope's onWillPop
  static Future<bool> showExitDialog(final BuildContext context) async {
    final now = DateTime.now();

    if (_lastBackPressTime == null ||
        now.difference(_lastBackPressTime!) > const Duration(seconds: 2)) {
      _lastBackPressTime = now;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Press back again to exit.'),
          duration: Duration(seconds: 2),
        ),
      );

      return Future.value(false);
    }

    return Future.value(true);
  }
}
