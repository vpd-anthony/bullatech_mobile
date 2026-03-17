import 'package:bullatech/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class BlockingLoadingDialog {
  static bool _isShowing = false;

  static void show(final BuildContext context, {final Widget? loader}) {
    if (_isShowing) return;
    _isShowing = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor:
          AppColors.primaryDark.withOpacity(0.85), // full dark overlay
      builder: (final context) => Center(
        child: loader ??
            const CircularProgressIndicator(
              strokeWidth: 3,
            ),
      ),
    );
  }

  static void hide(final BuildContext context) {
    if (!_isShowing) return;
    _isShowing = false;

    Navigator.of(context, rootNavigator: true).pop();
  }
}
