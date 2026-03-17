import 'package:bullatech/core/theme/app_colors.dart';
import 'package:bullatech/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class PincodeInput extends StatelessWidget {
  final String pincode;
  final int length;
  final bool obscureText;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? filledColor;

  const PincodeInput({
    super.key,
    required this.pincode,
    this.length = 6,
    this.obscureText = true,
    this.activeColor,
    this.inactiveColor,
    this.filledColor,
  });

  @override
  Widget build(final BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Each box has horizontal margin of 4px on each side
    const horizontalMargin = 4;

    final totalSpacing = (length - 1) * horizontalMargin * 2;
    final boxWidth = (screenWidth - totalSpacing - 32) / length;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(length, (final index) {
        final isFilled = index < pincode.length;
        final isActive = index == pincode.length;

        return Flexible(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
            width: boxWidth,
            height: 32,
            decoration: BoxDecoration(
              border: Border.all(
                color: isActive
                    ? (activeColor ?? AppColors.primary)
                    : (inactiveColor ?? AppColors.border),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: obscureText && isFilled
                  ? Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    )
                  : Text(
                      isFilled ? pincode[index] : '',
                      style: AppTheme.textTheme.titleMedium
                          ?.copyWith(fontSize: 24, color: AppColors.textWhite),
                    ),
            ),
          ),
        );
      }),
    );
  }
}
