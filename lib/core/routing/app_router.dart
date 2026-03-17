import 'package:bullatech/core/routing/routes/auth_routes.dart';
import 'package:bullatech/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

@Riverpod(keepAlive: true)
GoRouter appRouter(final Ref ref) {
  // const authRedirect = AuthRedirect();

  return GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: '/',
    debugLogDiagnostics: true,
    // redirect: (final context, final state) {
    //   return authRedirect(ref, state);
    // },
    routes: [...AuthRoutes.routes],
  );
}
