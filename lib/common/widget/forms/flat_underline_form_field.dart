import 'package:bullatech/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class FlatUnderlineFormField extends StatelessWidget {
  const FlatUnderlineFormField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icon,
    this.validator,
    this.textInputAction = TextInputAction.next,
    this.keyboardType,
    this.onFieldSubmitted,
    this.enabled = true,
  });

  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final String? Function(String?)? validator;
  final TextInputAction textInputAction;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onFieldSubmitted;
  final bool enabled;

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: controller,
      enabled: enabled,
      cursorColor: AppColors.transparent,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      validator: validator,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: Colors.grey[900],
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: theme.textTheme.bodyMedium?.copyWith(
          color: Colors.grey[400],
        ),
        filled: true,
        fillColor: AppColors.transparent,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        prefixIcon: Icon(
          icon,
          color: enabled
              ? AppColors.primary
              : AppColors.normalColor.withOpacity(0.5),
          size: 22,
        ),
        border: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.normalColor,
            width: 1.2,
          ),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.normalColor,
            width: 1.2,
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.normalColor,
            width: 2,
          ),
        ),
      ),
    );
  }
}
