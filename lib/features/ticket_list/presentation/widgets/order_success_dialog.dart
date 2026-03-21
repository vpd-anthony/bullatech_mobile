import 'package:bullatech/core/theme/app_colors.dart';
import 'package:bullatech/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class OrderSuccessDialog extends StatelessWidget {
  const OrderSuccessDialog({super.key});

  @override
  Widget build(final BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(width: 0.5, color: Colors.white),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              const Icon(
                Icons.check_circle_outline,
                size: 56,
                color: AppColors.success,
              ),
              const SizedBox(height: 12),
              Text(
                'Ticket Order Accepted!',
                textAlign: TextAlign.center,
                style: AppTheme.textTheme.titleSmall?.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.success,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'You have successfully accepted \n the ticket order.',
                textAlign: TextAlign.center,
                style: AppTheme.textTheme.titleSmall?.copyWith(
                  fontSize: 16,
                  color: AppColors.textHint,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Head to the pickup point.',
                textAlign: TextAlign.center,
                style: AppTheme.textTheme.titleSmall?.copyWith(
                  fontSize: 14,
                  color: AppColors.textHint,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: const BorderSide(color: Colors.white, width: 1),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Navigate to pickup',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
