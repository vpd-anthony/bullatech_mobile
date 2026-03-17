import 'package:bullatech/features/auth/data/datasources/local/biometric_local_datasource.dart';
import 'package:bullatech/features/auth/data/repositories/biometric_repository.dart';

class BiometricRepositoryImpl implements BiometricRepository {
  final BiometricLocalDataSource localDataSource;

  BiometricRepositoryImpl(this.localDataSource);

  @override
  Future<void> setBiometricEnabled(final bool enabled) =>
      localDataSource.setBiometricEnabled(enabled);

  @override
  Future<bool> isBiometricEnabled() => localDataSource.isBiometricEnabled();
}
