import 'package:bullatech/core/providers/flutter_secure_storage_provider.dart';
import 'package:bullatech/features/auth/application/services/pincode_service.dart';
import 'package:bullatech/features/auth/data/datasources/local/pincode_local_datasource.dart';
import 'package:bullatech/features/auth/data/repositories/pincode_repository.dart';
import 'package:bullatech/features/auth/data/repositories_impl/pincode_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pincode_providers.g.dart';

@Riverpod(keepAlive: true)
PincodeLocalDataSource pincodeLocalDataSource(final Ref ref) {
  return PincodeLocalDataSource(ref.watch(secureStorageProvider));
}

@Riverpod(keepAlive: true)
PincodeRepository pincodeRepository(final Ref ref) {
  return PincodeRepositoryImpl(ref.watch(pincodeLocalDataSourceProvider));
}

@Riverpod(keepAlive: true)
PincodeService pincodeService(final Ref ref) {
  final repository = ref.watch(pincodeRepositoryProvider);
  return PincodeService(repository);
}

@riverpod
Future<bool> hasPincode(final Ref ref) async {
  return await ref.watch(pincodeServiceProvider).hasPincode();
}
