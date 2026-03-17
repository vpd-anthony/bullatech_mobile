import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'date_range_provider.g.dart';

@Riverpod(keepAlive: true)
class DateRange extends _$DateRange {
  @override
  DateTimeRange? build(final String key) => null;

  void setDateRange(final DateTimeRange range) {
    state = range;
  }

  void clear() {
    state = null;
  }

  /// Converts the current range into API payload
  Map<String, String>? get asApiPayload {
    if (state == null) return null;

    final formatter = DateFormat('yyyy-MM-dd');
    return {
      'start_date': formatter.format(state!.start),
      'end_date': formatter.format(state!.end),
    };
  }
}
