import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AuthRoutes {
  /// Returns a list of all public/auth routes
  static List<GoRoute> get routes => [
        // GoRoute(
        //   path: '/',
        //   pageBuilder: (final context, final state) => MaterialPage(
        //     key: state.pageKey,
        //     child: const WelcomeScreen(),
        //   ),
        // ),
        // GoRoute(
        //   path: '/initial-login',
        //   pageBuilder: (final context, final state) =>
        //       AppPageTransition.slideRightWithFade(
        //     child: const InitialLoginScreen(),
        //   ),
        // ),
        // GoRoute(
        //   path: '/pincode-setup',
        //   pageBuilder: (final context, final state) =>
        //       AppPageTransition.slideRightWithFade(
        //     child: const PincodeSetupScreen(),
        //   ),
        // ),
        // GoRoute(
        //   path: '/pincode-login',
        //   pageBuilder: (final context, final state) =>
        //       AppPageTransition.slideRightWithFade(
        //     child: const PincodeLoginScreen(),
        //   ),
        // ),
        // GoRoute(
        //   path: '/password-only-login',
        //   pageBuilder: (final context, final state) =>
        //       AppPageTransition.slideRightWithFade(
        //     child: const PasswordOnlyLoginScreen(),
        //   ),
        // ),
      ];
}
