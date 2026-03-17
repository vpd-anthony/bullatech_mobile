import 'package:bullatech/common/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AnimatedIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const AnimatedIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  State<AnimatedIconButton> createState() => AnimatedIconButtonState();
}

class AnimatedIconButtonState extends State<AnimatedIconButton> {
  double _scale = 1.0;

  @override
  Widget build(final BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () {
          HapticFeedback.lightImpact();
          widget.onPressed();
        },
        onHighlightChanged: (final isPressed) {
          setState(() {
            _scale = isPressed ? 0.85 : 1.0;
          });
        },
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: AnimatedScale(
          scale: _scale,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
          child: Container(
            width: AppSizes.pincodeKeyboardButton,
            height: AppSizes.pincodeKeyboardButton,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFF3F4F6),
              border: Border.all(
                color: const Color(0xFFE5E7EB),
                width: AppSizes.pincodeKeyboardBorderWidth,
              ),
            ),
            alignment: Alignment.center,
            child: Icon(
              widget.icon,
              color: const Color(0xFF6B7280),
              size: AppSizes.pincodeKeyboardIconSize,
            ),
          ),
        ),
      ),
    );
  }
}
