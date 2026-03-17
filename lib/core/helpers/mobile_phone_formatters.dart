import 'package:flutter/services.dart';

class MobilePhoneFormatters extends TextInputFormatter {
  final bool lockPrefix;

  MobilePhoneFormatters({this.lockPrefix = true});

  @override
  TextEditingValue formatEditUpdate(
      final TextEditingValue oldValue, final TextEditingValue newValue) {
    var text = newValue.text;

    // Remove everything except digits
    text = text.replaceAll(RegExp(r'[^\d+]'), '');

    // Ensure +63 prefix
    if (!text.startsWith('+63')) {
      // Remove leading 0 if pasted like 09123456789
      text = text.replaceFirst(RegExp(r'^0+'), '');
      text = '+63$text';
    }

    // Lock prefix if enabled
    if (lockPrefix && !text.startsWith('+63')) {
      text = '+63';
    }

    // Remove +63 from formatting logic
    var digits = text.substring(3);

    // Limit to max 10 digits after +63
    if (digits.length > 10) {
      digits = digits.substring(0, 10);
    }

    // Format: XXX-XXX-XXXX or XXX-XXX-XXX for shorter
    var formatted = '';
    for (var i = 0; i < digits.length; i++) {
      if (i == 3 || i == 6) formatted += '-';
      formatted += digits[i];
    }

    text = '+63 $formatted';

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  /// Check if complete
  static bool isComplete(final String value) {
    // 10 digits after +63
    final digits = value.replaceAll(RegExp(r'[^\d]'), '');
    return digits.length == 12; // +63 + 10 digits = 12
  }
}
