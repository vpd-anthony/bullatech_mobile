class FormFieldFormatters {
  FormFieldFormatters._();

  static String formatPhoneNumber(final String phone) {
    final cleaned = phone.replaceAll(RegExp(r'\D'), '');

    if (cleaned.length == 10) {
      return '(${cleaned.substring(0, 3)}) ${cleaned.substring(3, 6)}-${cleaned.substring(6)}';
    } else if (cleaned.length == 11) {
      return '+${cleaned.substring(0, 1)} (${cleaned.substring(1, 4)}) ${cleaned.substring(4, 7)}-${cleaned.substring(7)}';
    }

    return phone;
  }
}
