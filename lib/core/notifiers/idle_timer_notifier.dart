import 'dart:async';

import 'package:bullatech/common/constants/app_constants.dart';
import 'package:bullatech/core/providers/websocket_provider.dart';
import 'package:bullatech/core/services/notification_service.dart';
import 'package:bullatech/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'idle_timer_notifier.g.dart';

@Riverpod(keepAlive: true)
class IdleTimerNotifier extends _$IdleTimerNotifier {
  Timer? _countdownTimer;
  int _remainingSeconds = 0;
  bool _isActive = false;

  @override
  void build() {
    // Cleanup timer automatically when provider is disposed
    ref.onDispose(() {
      _countdownTimer?.cancel();
      _isActive = false;
    });
  }

  /// Check if the idle timer is currently active
  bool get isActive => _isActive;

  /// Start the idle timer
  void start() {
    if (_isActive) {
      return; // Already active
    }

    _isActive = true;
    reset();
  }

  /// Stop the idle timer
  void stop() {
    _countdownTimer?.cancel();
    _isActive = false;
    _remainingSeconds = 0;
  }

  /// Reset the idle timer and start countdown
  void reset() {
    if (!_isActive) return; // Only reset if active

    _countdownTimer?.cancel();
    _remainingSeconds = AppConstants.idleDuration;

    _countdownTimer =
        Timer.periodic(const Duration(seconds: 1), (final timer) async {
      if (!_isActive) {
        timer.cancel();
        return;
      }

      _remainingSeconds--;
      debugPrint(
          'Idle countdown: $_remainingSeconds seconds remaining (active: $_isActive)');

      if (_remainingSeconds <= 0) {
        timer.cancel();
        await _onIdleTimeout();
      }
    });
  }

  /// Fired when user has been idle too long
  Future<void> _onIdleTimeout() async {
    _isActive = false;

    await NotificationService.showIdleLogoutNotification();

    // Use navigator key instead of context
    if (navigatorKey.currentState != null) {
      GoRouter.of(navigatorKey.currentContext!).go('/'); // redirect safely
    }
  }

  /// Get remaining seconds (useful for debugging or UI display)
  int get remainingSeconds => _remainingSeconds;
}
