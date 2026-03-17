import 'package:bullatech/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? buttonText;
  final VoidCallback? onPressed;

  const ErrorDialog({
    super.key,
    this.title = 'Error',
    required this.message,
    this.buttonText,
    this.onPressed,
  });

  /// Show error dialog
  static Future<void> show(
    final BuildContext context, {
    final String? title,
    required final String message,
    final String? buttonText,
    final VoidCallback? onPressed,
  }) {
    return showDialog(
      context: context,
      builder: (final _) => ErrorDialog(
        title: title ?? 'Error',
        message: message,
        buttonText: buttonText,
        onPressed: onPressed,
      ),
    );
  }

  @override
  Widget build(final BuildContext context) {
    return AlertDialog(
      surfaceTintColor: Colors.white,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.error, size: 28),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: Text(
        message,
        style: const TextStyle(color: Colors.black87),
      ),
      actions: [
        TextButton(
          onPressed: onPressed ?? () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(
            foregroundColor: AppColors.textPrimary,
          ),
          child: Text(buttonText ?? 'Okay'),
        ),
      ],
    );
  }
}


// simple error
// ErrorDialog.show(
//   context,
//   message: 'Something went wrong. Please try again.',
// );

// Retry case
// ErrorDialog.show(
//   context,
//   title: 'Failed to load dashboard',
//   message: error.toString(),
//   buttonText: 'Retry',
//   onPressed: () {
//     ref.invalidate(dashboardControllerProvider);
//   },
// );

// Blocking error
// ErrorDialog.show(
//   context,
//   title: 'Session expired',
//   message: 'Please login again.',
//   barrierDismissible: false,
//   onPressed: logout,
// );

