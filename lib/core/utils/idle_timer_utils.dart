import 'package:bullatech/core/notifiers/idle_timer_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IdleTimerUtils {
  // Make this method static
  static void resetIdleTimer(final WidgetRef ref) {
    final idleController = ref.read(idleTimerNotifierProvider.notifier);
    if (idleController.isActive) {
      debugPrint(
          'User interaction detected in Bullatech - resetting idle timer');
      idleController.reset();
    }
  }
}
