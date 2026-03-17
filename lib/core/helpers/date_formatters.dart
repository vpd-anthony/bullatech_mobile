import 'package:intl/intl.dart';

class DateFormatters {
  DateFormatters._();

  static String formatDate(final DateTime date,
      {final String format = 'MMM dd, yyyy'}) {
    return DateFormat(format).format(date);
  }

  static String formatDateTime(final DateTime date,
      {final String format = 'MMM dd, yyyy HH:mm'}) {
    return DateFormat(format).format(date);
  }

  static String formatTime(final DateTime date,
      {final String format = 'HH:mm'}) {
    return DateFormat(format).format(date);
  }

  static String timeAgo(final DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'Just now';
    }
  }
}
