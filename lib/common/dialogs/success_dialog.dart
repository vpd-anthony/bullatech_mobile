import 'package:bullatech/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class SuccessDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? buttonText;
  final VoidCallback? onPressed;

  const SuccessDialog({
    super.key,
    this.title = 'Success',
    required this.message,
    this.buttonText,
    this.onPressed,
  });

  static Future<void> show(
    final BuildContext context, {
    final String? title,
    required final String message,
    final String? buttonText,
    final VoidCallback? onPressed,
  }) {
    return showDialog(
      context: context,
      builder: (final context) => SuccessDialog(
        title: title ?? 'Success',
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          const Icon(Icons.check_circle_outline,
              color: AppColors.success, size: 28),
          const SizedBox(width: 12),
          Text(title),
        ],
      ),
      content: Text(message),
      actions: [
        ElevatedButton(
          onPressed: onPressed ?? () => Navigator.of(context).pop(),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.success,
          ),
          child: Text(buttonText ?? 'OK'),
        ),
      ],
    );
  }
}
