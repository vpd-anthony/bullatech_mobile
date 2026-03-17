import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BiometricLocalDataSource {
  final FlutterSecureStorage _secureStorage;
  static const _keyBiometricEnabled = 'biometric_enabled';

  BiometricLocalDataSource(this._secureStorage);

  /// Enable/disable biometric
  Future<void> setBiometricEnabled(final bool enabled) async {
    await _secureStorage.write(
      key: _keyBiometricEnabled,
      value: enabled.toString(),
    );
  }

  /// Check if biometric is enabled
  Future<bool> isBiometricEnabled() async {
    final value = await _secureStorage.read(key: _keyBiometricEnabled);
    return value == 'true';
  }
}
