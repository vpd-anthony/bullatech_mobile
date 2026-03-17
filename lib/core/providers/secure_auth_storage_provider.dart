import 'package:bullatech/core/services/secure_auth_storage_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'secure_auth_storage_provider.g.dart';

@riverpod
SecureAuthStorageService secureAuthStorage(final SecureAuthStorageRef ref) {
  return SecureAuthStorageService();
}
