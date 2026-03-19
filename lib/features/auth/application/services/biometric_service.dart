import 'package:bullatech/core/enums/auth/biometric_icon.dart';
import 'package:bullatech/features/auth/data/repositories/biometric_repository.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class BiometricService {
  final BiometricRepository repository;
  final LocalAuthentication _auth = LocalAuthentication();

  BiometricService(this.repository);

  Future<bool> isBiometricEnabled() => repository.isBiometricEnabled();

  Future<void> setBiometricEnabled(final bool enabled) =>
      repository.setBiometricEnabled(enabled);

  /// Check if device supports biometric authentication
  Future<bool> isBiometricAvailable() async {
    try {
      final biometrics = await _auth.getAvailableBiometrics();
      final enrolled = biometrics.isNotEmpty;
      final supported = await _auth.isDeviceSupported();

      return enrolled && supported;
    } catch (e) {
      return false;
    }
  }

  /// Get available biometric types
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } catch (e) {
      return [];
    }
  }

  /// Authenticate using biometrics
  Future<bool> authenticate({
    final String localizedReason = '',
    final bool useErrorDialogs = true,
    final bool stickyAuth = true,
  }) async {
    try {
      return await _auth.authenticate(
        localizedReason: localizedReason,
        options: AuthenticationOptions(
          useErrorDialogs: useErrorDialogs,
          stickyAuth: stickyAuth,
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  /// Check if biometric is enrolled
  Future<bool> isBiometricEnrolled() async {
    try {
      final biometrics = await getAvailableBiometrics();
      return biometrics.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Get biometric icon based on available type
  Future<BiometricIcon> getBiometricIcon() async {
    final biometrics = await getAvailableBiometrics();

    if (biometrics.contains(BiometricType.face)) {
      return BiometricIcon.face;
    } else if (biometrics.contains(BiometricType.fingerprint)) {
      return BiometricIcon.fingerprint;
    } else if (biometrics.contains(BiometricType.iris)) {
      return BiometricIcon.iris;
    }

    return BiometricIcon.fingerprint;
  }

  /// Get biometric name for display
  Future<String> getBiometricName() async {
    final biometrics = await getAvailableBiometrics();

    if (biometrics.contains(BiometricType.face)) {
      return 'Face ID';
    } else if (biometrics.contains(BiometricType.fingerprint)) {
      return 'Fingerprint';
    } else if (biometrics.contains(BiometricType.iris)) {
      return 'Iris';
    }

    return 'Biometric';
  }
}
