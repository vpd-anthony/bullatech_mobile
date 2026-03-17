// core/interceptors/auth_interceptor.dart
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _secureStorage;

  AuthInterceptor(this._secureStorage);

  @override
  void onRequest(
    final RequestOptions options,
    final RequestInterceptorHandler handler,
  ) async {
    final token = await _secureStorage.read(key: 'AUTH_TOKEN');
    final tokenType = await _secureStorage.read(key: 'AUTH_TYPE') ?? 'Bearer';

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = '$tokenType $token';
    }

    handler.next(options);
  }
}
