import 'package:bullatech/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class EmptyDataPage extends StatefulWidget {
  final String message;

  const EmptyDataPage({
    super.key,
    this.message = 'No data available',
  });

  @override
  EmptyDataPageState createState() => EmptyDataPageState();
}

class EmptyDataPageState extends State<EmptyDataPage> {
  @override
  Widget build(final BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.inbox_rounded,
                color: AppColors.warning,
                size: 48,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              widget.message,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'There is currently no data to display.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
