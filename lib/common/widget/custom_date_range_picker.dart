import 'package:bullatech/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CustomDateRangePicker extends StatefulWidget {
  final DateTimeRange initialRange;
  final DateTime lastDay;
  final ValueChanged<DateTimeRange> onRangeSelected;

  const CustomDateRangePicker({
    super.key,
    required this.initialRange,
    required this.lastDay,
    required this.onRangeSelected,
  });

  @override
  CustomDateRangePickerState createState() => CustomDateRangePickerState();

  static Future<void> show(
    final BuildContext context, {
    required final DateTimeRange initialRange,
    required final DateTime lastDay,
    required final ValueChanged<DateTimeRange> onRangeSelected,
  }) async {
    final picked = await showModalBottomSheet<DateTimeRange>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // make modal background transparent
      builder: (final _) => Material(
        // Material controls surfaceTintColor
        color: AppColors.backgroundWhite,
        surfaceTintColor: AppColors.backgroundWhite,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        child: CustomDateRangePicker(
          initialRange: initialRange,
          lastDay: lastDay,
          onRangeSelected: onRangeSelected,
        ),
      ),
    );

    if (picked != null) {
      onRangeSelected(picked);
    }
  }
}

class CustomDateRangePickerState extends State<CustomDateRangePicker> {
  DateTime? rangeStart;
  DateTime? rangeEnd;

  @override
  void initState() {
    super.initState();
    rangeStart = widget.initialRange.start;
    rangeEnd = widget.initialRange.end;
  }

  String _formatDate(final DateTime? date) {
    if (date == null) return '--';
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Start',
                        style: TextStyle(color: AppColors.textSecondary)),
                    Text(_formatDate(rangeStart),
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('End',
                        style: TextStyle(color: AppColors.textSecondary)),
                    Text(_formatDate(rangeEnd),
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),

          // Calendar
          SizedBox(
            height: 400,
            child: TableCalendar(
              firstDay: DateTime(1900),
              lastDay: widget.lastDay,
              focusedDay: rangeStart ?? DateTime.now(),
              availableCalendarFormats: const {CalendarFormat.month: 'Month'},
              rangeStartDay: rangeStart,
              rangeEndDay: rangeEnd,
              rangeSelectionMode: RangeSelectionMode.enforced,
              onRangeSelected: (final start, final end, final focusedDay) {
                setState(() {
                  rangeStart = start;
                  rangeEnd = end;
                });
              },
              calendarStyle: CalendarStyle(
                rangeHighlightColor: AppColors.primaryDark.withOpacity(0.3),
                rangeStartDecoration: const BoxDecoration(
                  color: AppColors.primaryDark,
                  shape: BoxShape.circle,
                ),
                rangeEndDecoration: const BoxDecoration(
                  color: AppColors.primaryDark,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: AppColors.primaryDark.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),

          // Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: AppColors.textPrimary),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if (rangeStart != null && rangeEnd != null) {
                      Navigator.pop(context,
                          DateTimeRange(start: rangeStart!, end: rangeEnd!));
                    }
                  },
                  child: const Text(
                    'OK',
                    style: TextStyle(color: AppColors.textPrimary),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
