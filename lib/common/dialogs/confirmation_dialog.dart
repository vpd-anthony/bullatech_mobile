import 'package:bullatech/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final bool isDangerous;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    this.onConfirm,
    this.onCancel,
    this.isDangerous = false,
  });

  /// Show dialog
  static Future<bool?> show(
    final BuildContext context, {
    required final String title,
    required final String message,
    final String confirmText = 'Confirm',
    final String cancelText = 'Cancel',
    final bool isDangerous = false,
    final VoidCallback? onConfirm,
    final VoidCallback? onCancel,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (final context) => ConfirmationDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        isDangerous: isDangerous,
        onConfirm: onConfirm,
        onCancel: onCancel,
      ),
    );
  }

  @override
  Widget build(final BuildContext context) {
    return AlertDialog(
      surfaceTintColor: Colors.white,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 8,
      titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      contentPadding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
      actionsPadding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      title: Row(
        children: [
          Icon(
            isDangerous ? Icons.warning_amber_rounded : Icons.help_outline,
            color: isDangerous ? AppColors.error : AppColors.primary,
            size: 30,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
        ],
      ),
      content: Text(
        message,
        style: const TextStyle(fontSize: 15, height: 1.4),
      ),
      actions: [
        OutlinedButton(
          onPressed: () {
            onCancel?.call();
            WidgetsBinding.instance.addPostFrameCallback((final _) {
              Navigator.of(context).pop(false);
            });
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.textPrimary,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Cancel',
          ),
        ),
        ElevatedButton(
          onPressed: () {
            onConfirm?.call();
            Navigator.of(context).pop(true);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: isDangerous ? AppColors.error : AppColors.primary,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            confirmText,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
