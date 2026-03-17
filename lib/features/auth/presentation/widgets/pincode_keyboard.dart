import 'package:bullatech/common/constants/app_sizes.dart';
import 'package:bullatech/features/auth/presentation/widgets/layouts/animated_icon_button.dart';
import 'package:bullatech/features/auth/presentation/widgets/layouts/animated_number_button.dart';
import 'package:flutter/material.dart';

class PincodeKeyboard extends StatelessWidget {
  final void Function(String) onNumberPressed;
  final VoidCallback onBackspacePressed;
  final VoidCallback? onBiometricPressed;
  final bool showBiometric;

  const PincodeKeyboard({
    super.key,
    required this.onNumberPressed,
    required this.onBackspacePressed,
    this.onBiometricPressed,
    this.showBiometric = false,
  });

  @override
  Widget build(final BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildNumberRow(['1', '2', '3']),
        const SizedBox(height: AppSizes.pincodeKeyboardSpacing),
        _buildNumberRow(['4', '5', '6']),
        const SizedBox(height: AppSizes.pincodeKeyboardSpacing),
        _buildNumberRow(['7', '8', '9']),
        const SizedBox(height: AppSizes.pincodeKeyboardSpacing),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildBiometricButton(),
            AnimatedNumberButton(
              number: '0',
              onPressed: () => onNumberPressed('0'),
            ),
            AnimatedIconButton(
              icon: Icons.backspace_outlined,
              onPressed: onBackspacePressed,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNumberRow(final List<String> numbers) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: numbers
          .map(
            (final number) => AnimatedNumberButton(
              number: number,
              onPressed: () => onNumberPressed(number),
            ),
          )
          .toList(),
    );
  }

  Widget _buildBiometricButton() {
    if (showBiometric && onBiometricPressed != null) {
      return AnimatedIconButton(
        icon: Icons.fingerprint,
        onPressed: onBiometricPressed!,
      );
    }

    // Keeps layout perfectly aligned
    return const SizedBox(
      width: AppSizes.pincodeKeyboardButton,
      height: AppSizes.pincodeKeyboardButton,
    );
  }
}
