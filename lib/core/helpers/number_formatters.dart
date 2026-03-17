import 'package:intl/intl.dart';

class NumberFormatters {
  NumberFormatters._();

  static String formatNumber(final num number) {
    return NumberFormat('#,###').format(number);
  }

  static String formatCurrency(final num amount, {final String symbol = '\$'}) {
    return NumberFormat.currency(symbol: symbol).format(amount);
  }

  static String formatPercentage(final num value, {final int decimals = 0}) {
    return '${(value * 100).toStringAsFixed(decimals)}%';
  }
}
