import 'package:bullatech/common/widget/forms/rounded_button.dart';
import 'package:bullatech/common/widget/forms/rounded_text_field.dart';
import 'package:bullatech/core/listeners/api_response_listener.dart';
import 'package:bullatech/core/theme/app_colors.dart';
import 'package:bullatech/core/theme/app_theme.dart';
import 'package:bullatech/features/auth/data/dtos/login_request_dto.dart';
import 'package:bullatech/features/auth/domain/models/login_response.dart';
import 'package:bullatech/features/auth/presentation/controllers/auth_login_controller.dart';
import 'package:bullatech/features/auth/presentation/providers/biometric_providers.dart';
import 'package:bullatech/features/auth/presentation/widgets/layouts/auth_card.dart';
import 'package:bullatech/features/auth/presentation/widgets/layouts/auth_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class InitialLoginScreen extends ConsumerStatefulWidget {
  const InitialLoginScreen({super.key});

  @override
  ConsumerState<InitialLoginScreen> createState() => _InitialLoginScreenState();
}

class _InitialLoginScreenState extends ConsumerState<InitialLoginScreen> {
  late final TextEditingController _employeeCodeController;
  late final TextEditingController _usernameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _employeeCodeController = TextEditingController();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _employeeCodeController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _clearForm() {
    FocusScope.of(context).unfocus();

    _employeeCodeController.clear();
    _usernameController.clear();
    _emailController.clear();
    _passwordController.clear();

    WidgetsBinding.instance.addPostFrameCallback((final _) {
      _formKey.currentState?.reset();
    });
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final controller = ref.read(authLoginControllerProvider.notifier);

    final dto = LoginRequestDto(
      employeeCode: _employeeCodeController.text.trim(),
      username: _usernameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    await controller.login(dto);
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

          if (!mounted) return;
          context.go('/helpdesk/employee/ticket-list');

          final biometricAvailable =
              await ref.read(biometricServiceProvider).isBiometricAvailable();
          final biometricEnabled =
              await ref.read(biometricServiceProvider).isBiometricEnabled();

          // Show confirmation dialog to enable biometrics
          if (biometricAvailable && !biometricEnabled && mounted) {
            await ref.read(biometricServiceProvider).setBiometricEnabled(true);
            ref.invalidate(isBiometricEnabledProvider);
          }

          _clearForm();
        });
      },
    );

    return AuthScaffold(
      child: Form(
        key: _formKey,
        child: AuthCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Welcome Back 👋',
                textAlign: TextAlign.center,
                style: AppTheme.textTheme.titleSmall?.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Sign in to continue using Bullatech. \nTrack your ticket requests and get the support you need.',
                style: AppTheme.textTheme.titleMedium?.copyWith(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 32),
              RoundedTextField(
                controller: _employeeCodeController,
                label: 'Employee Code',
                hint: 'Enter your employee code',
                autovalidate: true,
                requiredField: true,
                validator: (final value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter employee code';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              RoundedTextField(
                controller: _usernameController,
                label: 'Username',
                hint: 'Enter your username',
                autovalidate: true,
                requiredField: true,
                validator: (final value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter username';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              RoundedTextField(
                controller: _emailController,
                label: 'Email',
                hint: 'Enter your email',
                autovalidate: true,
                requiredField: true,
                validator: (final value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter email';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
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
              RoundedButton(
                label: 'Sign In',
                onPressed: () => _handleLogin(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
