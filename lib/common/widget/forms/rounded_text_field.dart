import 'package:bullatech/core/helpers/text_formatters.dart';
import 'package:bullatech/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RoundedTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final bool requiredField;
  final String? hint;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final int? minLines;
  final int? maxLines;
  final bool autovalidate;
  final bool obscureText;
  final bool uppercase;
  final String? helperText;

  final bool showFocusBorder;
  final Color? focusBorderColor;

  final bool isMobile;
  final bool lockPrefix;

  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onChanged;

  const RoundedTextField({
    super.key,
    required this.controller,
    required this.label,
    this.requiredField = false,
    this.hint,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.minLines = 1,
    this.maxLines = 1,
    this.autovalidate = false,
    this.obscureText = false,
    this.showFocusBorder = false,
    this.focusBorderColor,
    this.isMobile = false,
    this.lockPrefix = false,
    this.inputFormatters,
    this.onChanged,
    this.uppercase = false,
    this.helperText,
  });

  @override
  State<RoundedTextField> createState() => _RoundedTextFieldState();
}

class _RoundedTextFieldState extends State<RoundedTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    final normalBorderColor = Colors.grey.shade300;
    final errorBorderColor = Colors.red.shade400;

    OutlineInputBorder border(final Color color) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: color, width: 1.2),
        );

    final labelStyle = theme.textTheme.bodyMedium?.copyWith(
      fontWeight: FontWeight.w600,
      color: Colors.grey[800],
    );

    final hintStyle = theme.textTheme.bodyMedium?.copyWith(
      color: Colors.grey[400],
    );

    final helperStyle = theme.textTheme.bodySmall?.copyWith(
      color: Colors.grey[500],
      fontSize: 12,
    );

    final inputTextStyle = theme.textTheme.bodyMedium?.copyWith(
      color: Colors.grey[900],
    );

    final formatters = <TextInputFormatter>[
      ...?widget.inputFormatters,
      if (widget.uppercase) TextFormatters.uppercaseFormatter(),
    ];

    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      minLines: widget.minLines,
      maxLines: widget.maxLines,
      obscureText: _obscureText,
      cursorColor: AppColors.transparent,
      autovalidateMode: widget.autovalidate
          ? AutovalidateMode.onUserInteraction
          : AutovalidateMode.disabled,
      inputFormatters: formatters,
      style: inputTextStyle,
      decoration: InputDecoration(
        label: RichText(
          text: TextSpan(
            text: widget.label,
            style: labelStyle,
            children: widget.requiredField
                ? const [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ]
                : [],
          ),
        ),
        hintText: widget.hint,
        hintStyle: hintStyle,

        // ✅ HELPER TEXT ADDED HERE
        helperText: widget.helperText ??
            (!widget.requiredField ? 'Put N/A if not applicable.' : null),
        helperStyle: helperStyle,

        filled: true,
        fillColor: Colors.grey.shade100,
        border: border(normalBorderColor),
        enabledBorder: border(normalBorderColor),
        focusedBorder: border(
          widget.showFocusBorder
              ? (widget.focusBorderColor ?? theme.primaryColor)
              : normalBorderColor,
        ),
        errorBorder: border(errorBorderColor),
        focusedErrorBorder: border(errorBorderColor),
        contentPadding: const EdgeInsets.all(16),
        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey[600],
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
      ),
      validator: widget.validator,
      onChanged: (final value) {
        var newText = value;

        if (widget.isMobile) {
          newText = newText.replaceAll(RegExp(r'^(?:\+63|0)?9'), '');
          newText = '+639$newText';

          if (widget.lockPrefix && !newText.startsWith('+639')) {
            newText = '+639';
          }
        }

        if (widget.uppercase && !widget.isMobile) {
          newText = newText.toUpperCase();
        }

        if (newText != widget.controller.text) {
          widget.controller.value = widget.controller.value.copyWith(
            text: newText,
            selection: TextSelection.collapsed(offset: newText.length),
          );
        }

        if (widget.onChanged != null) {
          widget.onChanged!(widget.controller.text);
        }
      },
    );
  }
}
