import 'package:bullatech/core/theme/app_colors.dart';
import 'package:bullatech/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const RoundedButton({
    super.key,
    required this.label,
    this.onPressed,
  });

  @override
  Widget build(final BuildContext context) {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: AppTheme.textTheme.titleSmall
              ?.copyWith(fontSize: 16, color: AppColors.textWhite),
        ),
      ),
    );
  }
}
