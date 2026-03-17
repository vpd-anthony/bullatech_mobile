import 'package:bullatech/core/enums/auth/auth_status.dart';
import 'package:bullatech/core/providers/secure_auth_storage_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_status_notifier.g.dart';

@Riverpod(keepAlive: true)
class AuthStatusNotifier extends _$AuthStatusNotifier {
  @override
  AuthStatus build() {
    _loadAuthStatus();
    return AuthStatus.unauthenticated;
  }

  Future<void> _loadAuthStatus() async {
    final saved = await ref.read(secureAuthStorageProvider).getAuthStatus();
    if (saved != null && saved != state) {
      state = saved;
    }
  }

  /// Mark user as authenticated
  Future<void> authenticated() async {
    state = AuthStatus.authenticated;
    await ref.read(secureAuthStorageProvider).setAuthStatus(state);
  }

  /// Mark user as unauthenticated
  Future<void> unauthenticated() async {
    state = AuthStatus.unauthenticated;
    await ref.read(secureAuthStorageProvider).setAuthStatus(state);
  }

  /// Mark user as password expired
  Future<void> passwordExpired() async {
    state = AuthStatus.passwordExpired;
    await ref.read(secureAuthStorageProvider).setAuthStatus(state);
  }

  /// Optional: clear storage (logout)
  Future<void> clear() async {
    state = AuthStatus.unauthenticated;
    await ref.read(secureAuthStorageProvider).clear();
  }
}
