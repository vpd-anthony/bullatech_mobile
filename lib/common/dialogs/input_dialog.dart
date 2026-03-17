import 'package:flutter/material.dart';

class InputDialog extends StatefulWidget {
  final String title;
  final String? message;
  final String? hint;
  final String? initialValue;
  final String confirmText;
  final String cancelText;
  final TextInputType? keyboardType;
  final int? maxLines;
  final String? Function(String?)? validator;

  const InputDialog({
    super.key,
    required this.title,
    this.message,
    this.hint,
    this.initialValue,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    this.keyboardType,
    this.maxLines = 1,
    this.validator,
  });

  static Future<String?> show(
    final BuildContext context, {
    required final String title,
    final String? message,
    final String? hint,
    final String? initialValue,
    final String confirmText = 'Confirm',
    final String cancelText = 'Cancel',
    final TextInputType? keyboardType,
    final int? maxLines,
    final String? Function(String?)? validator,
  }) {
    return showDialog<String>(
      context: context,
      builder: (final context) => InputDialog(
        title: title,
        message: message,
        hint: hint,
        initialValue: initialValue,
        confirmText: confirmText,
        cancelText: cancelText,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
      ),
    );
  }

  @override
  State<InputDialog> createState() => _InputDialogState();
}

class _InputDialogState extends State<InputDialog> {
  late final TextEditingController _controller;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return AlertDialog(
      surfaceTintColor: Colors.white,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(widget.title),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.message != null) ...[
              Text(widget.message!),
              const SizedBox(height: 16),
            ],
            TextFormField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: widget.hint,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              keyboardType: widget.keyboardType,
              maxLines: widget.maxLines,
              validator: widget.validator,
              autofocus: true,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(widget.cancelText),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState?.validate() ?? true) {
              Navigator.of(context).pop(_controller.text);
            }
          },
          child: Text(widget.confirmText),
        ),
      ],
    );
  }
}
