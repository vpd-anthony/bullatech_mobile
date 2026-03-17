import 'package:bullatech/core/routing/app_page_transition.dart';
import 'package:bullatech/features/auth/presentation/screens/initial_login_screen.dart';
import 'package:bullatech/features/auth/presentation/screens/password_only_login_screen.dart';
import 'package:bullatech/features/auth/presentation/screens/pincode_login_screen.dart';
import 'package:bullatech/features/auth/presentation/screens/pincode_setup_screen.dart';
import 'package:go_router/go_router.dart';

class AuthRoutes {
  /// Returns a list of all public/auth routes
  static List<GoRoute> get routes => [
        GoRoute(
          path: '/',
          pageBuilder: (final context, final state) =>
              AppPageTransition.slideRightWithFade(
            child: const InitialLoginScreen(),
          ),
        ),
        GoRoute(
          path: '/pincode-setup',
          pageBuilder: (final context, final state) =>
              AppPageTransition.slideRightWithFade(
            child: const PincodeSetupScreen(),
          ),
        ),
        GoRoute(
          path: '/pincode-login',
          pageBuilder: (final context, final state) =>
              AppPageTransition.slideRightWithFade(
            child: const PincodeLoginScreen(),
          ),
        ),
        GoRoute(
          path: '/password-only-login',
          pageBuilder: (final context, final state) =>
              AppPageTransition.slideRightWithFade(
            child: const PasswordOnlyLoginScreen(),
          ),
        ),
      ];
}
