import 'package:bullatech/common/widget/blocking_loading_overlay.dart';
import 'package:bullatech/core/enums/auth/pincode_setup.dart';
import 'package:bullatech/core/providers/websocket_provider.dart';
import 'package:bullatech/core/theme/app_colors.dart';
import 'package:bullatech/core/theme/app_theme.dart';
import 'package:bullatech/features/auth/presentation/controllers/biometric_controller.dart';
import 'package:bullatech/features/auth/presentation/controllers/pincode_controller.dart';
import 'package:bullatech/features/auth/presentation/providers/biometric_providers.dart';
import 'package:bullatech/features/auth/presentation/widgets/layouts/auth_card.dart';
import 'package:bullatech/features/auth/presentation/widgets/layouts/auth_scaffold.dart';
import 'package:bullatech/features/auth/presentation/widgets/pincode_input.dart';
import 'package:bullatech/features/auth/presentation/widgets/pincode_keyboard.dart';
import 'package:bullatech/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PincodeSetupScreen extends ConsumerStatefulWidget {
  const PincodeSetupScreen({super.key});

  @override
  ConsumerState<PincodeSetupScreen> createState() => _PincodeSetupScreenState();
}

class _PincodeSetupScreenState extends ConsumerState<PincodeSetupScreen> {
  SetupStep currentStep = SetupStep.create;
  String createPincode = '';
  String confirmPincode = '';
  bool isError = false;
  String errorMessage = '';
  bool isShaking = false;
  bool _biometricTriggered = false;

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
      WidgetsBinding.instance.addPostFrameCallback((final _) async {
        await _handleBiometric();
      });
    }

    String getCurrentPincode() {
      return currentStep == SetupStep.create ? createPincode : confirmPincode;
    }

    void handleNumberPressed(final String number) {
      if (currentStep == SetupStep.biometric) return;

      setState(() {
        if (currentStep == SetupStep.create) {
          if (createPincode.length < 6) createPincode += number;
        } else {
          if (confirmPincode.length < 6) confirmPincode += number;
        }
        isError = false;
        errorMessage = '';
      });

      if (getCurrentPincode().length == 6) {
        if (currentStep == SetupStep.create) {
          Future.delayed(const Duration(milliseconds: 300), () {
            setState(() => currentStep = SetupStep.confirm);
          });
        } else {
          _verifyMatch();
        }
      }
    }

    void handleBackspace() {
      if (currentStep == SetupStep.biometric) return;

      setState(() {
        if (currentStep == SetupStep.create && createPincode.isNotEmpty) {
          createPincode = createPincode.substring(0, createPincode.length - 1);
        } else if (currentStep == SetupStep.confirm &&
            confirmPincode.isNotEmpty) {
          confirmPincode =
              confirmPincode.substring(0, confirmPincode.length - 1);
        }
        isError = false;
        errorMessage = '';
      });
    }

    return AuthScaffold(
      child: AuthCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10),
            _buildProgressIndicator(currentStep),
            const SizedBox(height: 20),
            // Title
            Text(
              currentStep == SetupStep.create
                  ? 'Create Pincode'
                  : 'Confirm Pincode',
              style: AppTheme.textTheme.titleLarge?.copyWith(
                fontSize: 28,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),

            // Subtitle
            Text(
              currentStep == SetupStep.create
                  ? 'Enter a 6-digit pincode'
                  : 'Re-enter your pincode',
              style: AppTheme.textTheme.titleSmall?.copyWith(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),

            // Pincode Input
            AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              transform: Matrix4.translationValues(
                isShaking ? 10.0 : 0.0,
                0.0,
                0.0,
              ),
              child: PincodeInput(
                pincode: getCurrentPincode(),
                length: 6,
                obscureText: true,
                activeColor: isError ? AppColors.error : null,
                inactiveColor:
                    isError ? AppColors.error.withOpacity(0.3) : null,
              ),
            ),
            // Error Message
            if (isError) ...[
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
              const SizedBox(height: 10),
            ],

            PincodeKeyboard(
              onNumberPressed: handleNumberPressed,
              onBackspacePressed: handleBackspace,
              onBiometricPressed: showBiometric ? _handleBiometric : null,
              showBiometric: showBiometric,
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(final SetupStep step) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 64),
      child: Row(
        children: [
          _buildProgressDot(true),
          Expanded(
            child: Container(
              height: 2,
              color: step == SetupStep.biometric
                  ? AppColors.primary
                  : const Color(0xFFE5E7EB),
            ),
          ),
          _buildProgressDot(
              step == SetupStep.confirm || step == SetupStep.biometric),
        ],
      ),
    );
  }

  Widget _buildProgressDot(final bool isActive) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : const Color(0xFFE5E7EB),
        shape: BoxShape.circle,
      ),
    );
  }

  Future<void> _verifyMatch() async {
    BlockingLoadingDialog.show(context);

    if (createPincode == confirmPincode) {
      HapticFeedback.mediumImpact();

      final isValid = await ref
          .read(pincodeControllerProvider.notifier)
          .setupPincode(createPincode);

      if (!mounted) return;

      if (isValid) {
        // final wsService = ref.read(websocketServiceProvider);
        // await wsService.init(navigatorKey, channels: [
        //   'tickets',
        // ]);

        WidgetsBinding.instance.addPostFrameCallback((final _) {
          context.go('/helpdesk/employee/ticket-list');
        });
      } else {
        HapticFeedback.vibrate();
        setState(() {
          isError = true;
          errorMessage = 'Failed to setup pincode';
        });
      }
    } else {
      HapticFeedback.vibrate();
      setState(() => isError = true);

      for (var i = 0; i < 2; i++) {
        setState(() => isShaking = true);
        await Future.delayed(const Duration(milliseconds: 100));
        setState(() => isShaking = false);
        await Future.delayed(const Duration(milliseconds: 100));
      }

      await Future.delayed(const Duration(milliseconds: 500));
      setState(() {
        createPincode = '';
        confirmPincode = '';
        currentStep = SetupStep.create;
        isError = false;
        errorMessage = '';
      });
    }

    if (!mounted) return;
    BlockingLoadingDialog.hide(context);
  }

  Future<void> _handleBiometric() async {
    BlockingLoadingDialog.show(context);
    final success =
        await ref.read(biometricControllerProvider.notifier).authenticate();

    if (success) {
      HapticFeedback.mediumImpact();

      // final wsService = ref.read(websocketServiceProvider);
      // await wsService.init(navigatorKey, channels: [
      //   'tickets',
      // ]);

      if (!mounted) return;
      context.go('/helpdesk/employee/ticket-list');
    } else {
      setState(() {
        createPincode = '';
      });
    }

    if (!mounted) return;
    BlockingLoadingDialog.hide(context);
  }
}
