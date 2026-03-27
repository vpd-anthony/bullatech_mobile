import 'package:bullatech/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  final bool hasRoute;
  const TopBar({super.key, required this.hasRoute});

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xCC0A0F1E),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.borderMaps),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: hasRoute ? AppColors.info : AppColors.successMaps,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      hasRoute
                          ? 'Route active · navigate to pickup'
                          : 'Online — waiting for orders',
                      style: TextStyle(
                        color: hasRoute
                            ? AppColors.textPrimaryMaps
                            : AppColors.textSecondaryMaps,
                        fontSize: 12,
                        fontWeight:
                            hasRoute ? FontWeight.w600 : FontWeight.normal,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
