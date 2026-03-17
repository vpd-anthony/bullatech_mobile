import 'package:bullatech/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget {
  final String? message;

  const LoadingDialog({super.key, this.message});

  /// Show dialog
  static Future<void> show(
    final BuildContext context, {
    final String? message,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (final _) => LoadingDialog(message: message),
    );
  }

  /// Hide dialog
  ///
  /// [fallbackPop] → if true, pop current route when dialog is not present
  /// [fallbackPopCount] → how many routes to pop (default = 1)
  static void hide(
    final BuildContext context, {
    final bool fallbackPop = false,
    final int fallbackPopCount = 1,
  }) {
    final navigator = Navigator.of(context, rootNavigator: true);

    if (navigator.canPop()) {
      navigator.pop(); // close loading dialog
      return;
    }

    // Optional fallback: pop screen(s)
    if (fallbackPop && fallbackPopCount > 0) {
      var popped = 0;
      while (navigator.canPop() && popped < fallbackPopCount) {
        navigator.pop();
        popped++;
      }
    }
  }

  @override
  Widget build(final BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Disable back button
      child: AlertDialog(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
            if (message != null) ...[
              const SizedBox(height: 20),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
