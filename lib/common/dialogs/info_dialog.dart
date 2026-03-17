import 'package:bullatech/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class InfoDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? buttonText;
  final VoidCallback? onPressed;

  const InfoDialog({
    super.key,
    required this.title,
    required this.message,
    this.buttonText,
    this.onPressed,
  });

  static Future<void> show(
    final BuildContext context, {
    required final String title,
    required final String message,
    final String? buttonText,
    final VoidCallback? onPressed,
  }) {
    return showDialog(
      context: context,
      builder: (final context) => InfoDialog(
        title: title,
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
          const Icon(Icons.info_outline, color: AppColors.info, size: 28),
          const SizedBox(width: 12),
          Text(title),
        ],
      ),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: onPressed ?? () => Navigator.of(context).pop(),
          child: Text(buttonText ?? 'OK'),
        ),
      ],
    );
  }
}
