abstract class BiometricRepository {
  Future<void> setBiometricEnabled(final bool enabled);
  Future<bool> isBiometricEnabled();
}
