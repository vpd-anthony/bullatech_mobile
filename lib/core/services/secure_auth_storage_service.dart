import 'package:bullatech/core/enums/auth/auth_status.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureAuthStorageService {
  final _storage = const FlutterSecureStorage();
  static const _key = 'auth_status';

  /// Save auth status securely
  Future<void> setAuthStatus(final AuthStatus status) async {
    await _storage.write(key: _key, value: status.name);
  }

  /// Load auth status, returns null if not saved
  Future<AuthStatus?> getAuthStatus() async {
    final value = await _storage.read(key: _key);
    if (value == null) return null;
    return AuthStatus.values.firstWhere((final e) => e.name == value);
  }

  /// Clear auth status (logout)
  Future<void> clear() async {
    await _storage.delete(key: _key);
  }
}
