import 'package:bullatech/features/auth/presentation/providers/auth_providers.dart';
import 'package:bullatech/features/auth/presentation/providers/pincode_providers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AuthRedirect {
  const AuthRedirect();

  Future<String?> call(final Ref ref, final GoRouterState state) async {
    final authService = ref.read(authServiceProvider);

    final location = state.uri.toString();

    final employeeUser = await authService.getEmployeeUser();

    if (kDebugMode || employeeUser == null) {
      await authService.logEmployeeUserDetails();
    }

    const passwordOnlyLogin = '/password-only-login';

    // 🔒 Handle passwordExpired → redirect to password-only-login
    // if (customer != null && customer.account.isPasswordExpired) {
    //   if (!location.startsWith(passwordOnlyLogin)) {
    //     return passwordOnlyLogin;
    //   }
    //   return null; // Already on the password reset page
    // }

    // Already on password-only-login → allow
    if (location.startsWith(passwordOnlyLogin)) return null;

    // Normal pincode flow
    final pincodeService = ref.read(pincodeServiceProvider);

    final hasPincode = await pincodeService.hasPincode();

    final isHelpdesk = location.startsWith('/helpdesk');
    final isPincodeLogin = location == '/pincode-login';
    final isPincodeSetup = location == '/pincode-setup';

    if (employeeUser != null) {
      // Already inside allowed routes → allow
      if (isHelpdesk) return null;

      // Correct pincode screens → allow
      if (hasPincode && isPincodeLogin) return null;
      if (!hasPincode && isPincodeSetup) return null;

      // Force correct pincode routes
      return hasPincode ? '/pincode-login' : '/pincode-setup';
    }

    // Not logged in → allow normal routes (login, signup, etc.)
    return null;
  }
}
