import 'package:bullatech/common/widget/forms/rounded_button.dart';
import 'package:bullatech/common/widget/forms/rounded_text_field.dart';
import 'package:bullatech/core/listeners/api_response_listener.dart';
import 'package:bullatech/core/notifiers/idle_timer_notifier.dart';
import 'package:bullatech/core/providers/websocket_provider.dart';
import 'package:bullatech/core/theme/app_colors.dart';
import 'package:bullatech/core/theme/app_theme.dart';
import 'package:bullatech/features/auth/data/dtos/password_only_login_request_dto.dart';
import 'package:bullatech/features/auth/domain/models/login_response.dart';
import 'package:bullatech/features/auth/presentation/controllers/auth_login_controller.dart';
import 'package:bullatech/features/auth/presentation/providers/biometric_providers.dart';
import 'package:bullatech/features/auth/presentation/widgets/layouts/auth_card.dart';
import 'package:bullatech/features/auth/presentation/widgets/layouts/auth_scaffold.dart';
import 'package:bullatech/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PasswordOnlyLoginScreen extends ConsumerStatefulWidget {
  const PasswordOnlyLoginScreen({super.key});

  @override
  ConsumerState<PasswordOnlyLoginScreen> createState() =>
      _PasswordOnlyLoginScreenState();
}

class _PasswordOnlyLoginScreenState
    extends ConsumerState<PasswordOnlyLoginScreen> {
  late final TextEditingController _passwordController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
    ref.read(idleTimerNotifierProvider.notifier).stop();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _clearForm() {
    FocusScope.of(context).unfocus();

    _passwordController.clear();

    WidgetsBinding.instance.addPostFrameCallback((final _) {
      _formKey.currentState?.reset();
    });
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final controller = ref.read(authLoginControllerProvider.notifier);

    final dto = PasswordOnlyLoginRequestDto(
      password: _passwordController.text,
    );

    await controller.passwordOnlylogin(dto);
  }

  @override
  Widget build(final BuildContext context) {
    watchApiWithDialogs(
      ref: ref,
      provider: authLoginControllerProvider,
      context: context,
      loadingMessage: 'Please wait while we sign you in.',
    );

    ref.listen<AsyncValue<LoginResponse?>>(
      authLoginControllerProvider,
      (final previous, final next) {
        next.whenData((final loginResponse) async {
          if (loginResponse == null) return;

          // Capture mounted before async calls
          if (!mounted) return;

          // final wsService = ref.read(websocketServiceProvider);
          // await wsService.init(navigatorKey, channels: [
          //   'tickets',
          // ]);

          final biometricAvailable =
              await ref.read(biometricServiceProvider).isBiometricAvailable();
          final biometricEnabled =
              await ref.read(biometricServiceProvider).isBiometricEnabled();

          // Show confirmation dialog to enable biometrics
          if (biometricAvailable && !biometricEnabled && mounted) {
            await ref.read(biometricServiceProvider).setBiometricEnabled(true);
            ref.invalidate(isBiometricEnabledProvider);
          }

          if (!mounted) return;
          context.go('/helpdesk/employee/ticket-list');

          _clearForm();
        });
      },
    );

    return AuthScaffold(
      child: Align(
        alignment: Alignment.center,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Form(
            key: _formKey,
            child: AuthCard(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Password Login',
                    textAlign: TextAlign.center,
                    style: AppTheme.textTheme.titleSmall?.copyWith(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sign in to access your Helpdesk dashboard. Manage tickets, track requests, and stay updated.',
                    textAlign: TextAlign.center,
                    style: AppTheme.textTheme.titleMedium?.copyWith(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 32),
                  RoundedTextField(
                    controller: _passwordController,
                    label: 'Password',
                    hint: 'Enter your password',
                    autovalidate: true,
                    requiredField: true,
                    obscureText: true,
                    validator: (final value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 8) {
                        return 'Password must be at least 8 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Need a new password? Reach out to Veracity Support.',
                    style: AppTheme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                      fontStyle: FontStyle.italic,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 20),
                  RoundedButton(
                    label: 'Sign In',
                    onPressed: () => _handleLogin(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
