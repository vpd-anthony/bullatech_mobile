import 'package:flutter/services.dart';

class TextFormatters {
  TextFormatters._();

  static String truncate(final String text, final int maxLength,
      {final String ellipsis = '...'}) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}$ellipsis';
  }

  static String capitalize(final String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  static String capitalizeWords(final String text) {
    return text.split(' ').map((final word) => capitalize(word)).join(' ');
  }

  static TextInputFormatter uppercaseFormatter() {
    return TextInputFormatter.withFunction(
      (final oldValue, final newValue) => TextEditingValue(
        text: newValue.text.toUpperCase(),
        selection: newValue.selection,
        composing: newValue.composing,
      ),
    );
  }
}
