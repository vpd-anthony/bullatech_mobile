import 'package:bullatech/core/theme/app_colors.dart';
import 'package:bullatech/features/ticket_list/presentation/mappers/technical_assign_location_mapper.dart';
import 'package:bullatech/features/ticket_list/presentation/widgets/dash_line_painter_widget.dart';
import 'package:flutter/material.dart';

class StopRow extends StatelessWidget {
  final TechnicalAssignLocation stop;
  final IconData icon; // <-- Changed from String to IconData
  final Color iconBg;
  final bool showLine;
  final Color noteBg;
  final Color noteText;

  const StopRow({
    super.key,
    required this.stop,
    required this.icon,
    required this.iconBg,
    required this.showLine,
    required this.noteBg,
    required this.noteText,
  });

  @override
  Widget build(final BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
              child: Center(
                child: Icon(
                  icon,
                  size: 18,
                  color: noteText,
                ),
              ),
            ),
            if (showLine)
              Container(
                width: 2,
                height: 46,
                margin: const EdgeInsets.symmetric(vertical: 3),
                child: CustomPaint(painter: DashedLinePainter()),
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stop.label.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8,
                    color: AppColors.primaryDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  stop.address,
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
