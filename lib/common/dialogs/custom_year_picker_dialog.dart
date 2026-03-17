import 'package:bullatech/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CustomYearPickerDialog {
  static Future<void> show(
    final BuildContext context, {
    required final Function(DateTimeRange) onYearSelected,
  }) async {
    final picked = await showDialog<DateTime>(
      context: context,
      builder: (final BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.backgroundWhite,
          surfaceTintColor: AppColors.backgroundWhite,
          title: const Text('Select Year'),
          content: SizedBox(
            width: 300,
            height: 300,
            child: YearPicker(
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
              selectedDate: DateTime.now(),
              onChanged: (final DateTime dateTime) {
                Navigator.pop(context, dateTime);
              },
            ),
          ),
        );
      },
    );

    if (picked != null) {
      final startDate = DateTime(picked.year, 1, 1);
      final endDate = DateTime(picked.year, 12, 31);
      final yearRange = DateTimeRange(start: startDate, end: endDate);
      onYearSelected(yearRange);
    }
  }
}
