import 'package:bullatech/core/providers/flutter_secure_storage_provider.dart';
import 'package:bullatech/features/auth/application/services/biometric_service.dart';
import 'package:bullatech/features/auth/data/datasources/local/biometric_local_datasource.dart';
import 'package:bullatech/features/auth/data/repositories/biometric_repository.dart';
import 'package:bullatech/features/auth/data/repositories_impl/biometric_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'biometric_providers.g.dart';

@Riverpod(keepAlive: true)
BiometricLocalDataSource biometricLocalDataSource(final Ref ref) {
  return BiometricLocalDataSource(ref.watch(secureStorageProvider));
}

@Riverpod(keepAlive: true)
BiometricRepository biometricRepository(final Ref ref) {
  return BiometricRepositoryImpl(ref.watch(biometricLocalDataSourceProvider));
}

@Riverpod(keepAlive: true)
BiometricService biometricService(final Ref ref) {
  final repository = ref.watch(biometricRepositoryProvider);
  return BiometricService(repository);
}

@riverpod
Future<bool> isBiometricAvailable(final Ref ref) async {
  final service = ref.read(biometricServiceProvider); // <-- read, not watch
  return await service.isBiometricAvailable();
}

@riverpod
Future<bool> isBiometricEnabled(final Ref ref) async {
  final service = ref.read(biometricServiceProvider); // <-- read, not watch
  return await service.isBiometricEnabled();
}
