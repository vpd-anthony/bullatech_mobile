import 'package:bullatech/common/widget/blocking_loading_overlay.dart';
import 'package:bullatech/core/theme/app_colors.dart';
import 'package:bullatech/core/theme/app_theme.dart';
import 'package:bullatech/features/auth/presentation/controllers/biometric_controller.dart';
import 'package:bullatech/features/auth/presentation/controllers/pincode_controller.dart';
import 'package:bullatech/features/auth/presentation/providers/biometric_providers.dart';
import 'package:bullatech/features/auth/presentation/widgets/layouts/auth_card.dart';
import 'package:bullatech/features/auth/presentation/widgets/layouts/auth_scaffold.dart';
import 'package:bullatech/features/auth/presentation/widgets/pincode_input.dart';
import 'package:bullatech/features/auth/presentation/widgets/pincode_keyboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PincodeLoginScreen extends ConsumerStatefulWidget {
  const PincodeLoginScreen({super.key});

  @override
  ConsumerState<PincodeLoginScreen> createState() => _PincodeLoginScreenState();
}

class _PincodeLoginScreenState extends ConsumerState<PincodeLoginScreen> {
  String pincode = '';
  bool isError = false;
  String errorMessage = '';
  bool isShaking = false;
  bool _biometricTriggered = false;

  void handleNumberPressed(final String number) {
    if (pincode.length < 6) {
      setState(() {
        pincode += number;
        isError = false;
        errorMessage = '';
      });
      if (pincode.length == 6) _verifyPincode();
    }
  }

  void handleBackspace() {
    if (pincode.isNotEmpty) {
      setState(() {
        pincode = pincode.substring(0, pincode.length - 1);
        isError = false;
        errorMessage = '';
      });
    }
  }

  @override
  Widget build(final BuildContext context) {
    final biometricAvailableAsync = ref.watch(isBiometricAvailableProvider);
    final biometricEnabledAsync = ref.watch(isBiometricEnabledProvider);

    final showBiometric = biometricAvailableAsync.when(
      data: (final available) {
        return biometricEnabledAsync.when(
          data: (final enabled) => available && enabled,
          loading: () => false,
          error: (final _, final __) => false,
        );
      },
      loading: () => false,
      error: (final _, final __) => false,
    );

    // Auto-trigger biometric once resolved
    if (showBiometric && !_biometricTriggered) {
      _biometricTriggered = true;
      Future.microtask(() => _handleBiometric());
    }

    return AuthScaffold(
      child: AuthCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10),
            Text(
              'Enter Pincode',
              textAlign: TextAlign.center,
              style: AppTheme.textTheme.titleLarge?.copyWith(fontSize: 28),
            ),
            const SizedBox(height: 8),
            Text(
              'Enter your 6-digit pincode',
              textAlign: TextAlign.center,
              style: AppTheme.textTheme.titleSmall
                  ?.copyWith(fontSize: 16, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 10),
            AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              transform: Matrix4.translationValues(
                isShaking ? 10.0 : 0.0,
                0.0,
                0.0,
              ),
              child: PincodeInput(
                pincode: pincode,
                length: 6,
                obscureText: true,
                activeColor: isError ? AppColors.error : null,
                inactiveColor:
                    isError ? AppColors.error.withOpacity(0.3) : null,
              ),
            ),
            if (isError) ...[
              const SizedBox(height: 10),
              AnimatedOpacity(
                opacity: isError ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Text(
                  errorMessage,
                  style: AppTheme.textTheme.titleSmall?.copyWith(
                    fontSize: 14,
                    color: AppColors.error,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 16),
            PincodeKeyboard(
              onNumberPressed: handleNumberPressed,
              onBackspacePressed: handleBackspace,
              onBiometricPressed: showBiometric ? _handleBiometric : null,
              showBiometric: showBiometric,
            ),
            const SizedBox(height: 32),
            // TextButton(
            //   onPressed: () => context.go('/pincode-setup'),
            //   child: Text(
            //     'Forgot Pincode? Setup again.',
            //     style: AppTheme.textTheme.titleSmall
            //         ?.copyWith(fontStyle: FontStyle.italic),
            //   ),
            // ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Future<void> _verifyPincode() async {
    BlockingLoadingDialog.show(context);

    setState(() {
      isError = false;
      errorMessage = '';
    });

    final isValid = await ref
        .read(pincodeControllerProvider.notifier)
        .verifyPincode(pincode);

    if (!mounted) return;

    // Always hide dialog before navigating
    BlockingLoadingDialog.hide(context);

    if (isValid) {
      HapticFeedback.mediumImpact();

      // Safe navigation after dialog hidden
      WidgetsBinding.instance.addPostFrameCallback((final _) {
        context.go('/helpdesk/dashboard');
      });
    } else {
      HapticFeedback.vibrate();
      setState(() {
        isError = true;
        errorMessage = 'Incorrect pincode';
      });

      // Shake animation
      for (var i = 0; i < 2; i++) {
        setState(() => isShaking = true);
        await Future.delayed(const Duration(milliseconds: 100));
        setState(() => isShaking = false);
        await Future.delayed(const Duration(milliseconds: 100));
      }

      await Future.delayed(const Duration(milliseconds: 500));
      setState(() => pincode = '');
    }

    if (!mounted) return;
    BlockingLoadingDialog.hide(context);
  }

  Future<void> _handleBiometric() async {
    BlockingLoadingDialog.show(context);
    final success =
        await ref.read(biometricControllerProvider.notifier).authenticate();

    if (success && mounted) {
      HapticFeedback.mediumImpact();
      context.go('/helpdesk/dashboard');
    } else {
      if (!mounted) return;
      setState(() {
        pincode = '';
      });
    }

    if (!mounted) return;
    BlockingLoadingDialog.hide(context);
  }
}
