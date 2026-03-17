import 'package:bullatech/common/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AnimatedNumberButton extends StatefulWidget {
  final String number;
  final VoidCallback onPressed;

  const AnimatedNumberButton({
    super.key,
    required this.number,
    required this.onPressed,
  });

  @override
  State<AnimatedNumberButton> createState() => AnimatedNumberButtonState();
}

class AnimatedNumberButtonState extends State<AnimatedNumberButton> {
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
            _scale = isPressed ? 1.15 : 1.0;
          });
        },
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
            child: Text(
              widget.number,
              style: const TextStyle(
                fontSize: AppSizes.pincodeKeyboardIconSize,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F2937),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
