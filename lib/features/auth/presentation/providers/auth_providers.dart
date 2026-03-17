import 'package:bullatech/core/providers/dio_provider.dart';
import 'package:bullatech/core/providers/flutter_secure_storage_provider.dart';
import 'package:bullatech/features/auth/application/services/auth_service.dart';
import 'package:bullatech/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:bullatech/features/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:bullatech/features/auth/data/repositories/auth_repository.dart';
import 'package:bullatech/features/auth/data/repositories_impl/auth_repository_impl.dart';
import 'package:bullatech/features/auth/presentation/providers/biometric_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_providers.g.dart';

@Riverpod(keepAlive: true)
AuthLocalDataSource authLocalDataSource(final Ref ref) {
  return AuthLocalDataSource(ref.watch(secureStorageProvider));
}

@Riverpod(keepAlive: true)
AuthRemoteDatasource authRemoteDataSource(final Ref ref) {
  return AuthRemoteDatasource(
    dio: ref.watch(dioProvider),
    authLocalDataSource: ref.watch(authLocalDataSourceProvider),
  );
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(final Ref ref) {
  return AuthRepositoryImpl(
    ref.watch(authRemoteDataSourceProvider),
    ref.watch(authLocalDataSourceProvider),
    ref.watch(biometricServiceProvider),
  );
}

@Riverpod(keepAlive: true)
AuthService authService(final Ref ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthService(repository);
}
