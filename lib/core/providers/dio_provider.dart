import 'package:bullatech/core/interceptors/api_error_interceptor.dart';
import 'package:bullatech/core/interceptors/auth_interceptor.dart';
import 'package:bullatech/core/providers/flutter_secure_storage_provider.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../common/constants/api_constants.dart';

part 'dio_provider.g.dart';

@Riverpod(keepAlive: true)
Dio dio(final DioRef ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: ApiConstants.connectionTimeout,
      receiveTimeout: ApiConstants.receiveTimeout,
      headers: ApiConstants.defaultHeaders,
    ),
  );

  final secureStorage = ref.read(secureStorageProvider);
  dio.interceptors.add(
    ApiErrorInterceptor(
      onUnauthorized: () async {},
      onUnauthenticated: () {},
    ),
  );

  dio.interceptors.add(AuthInterceptor(secureStorage));

  if (ApiConstants.isDevelopment) {
    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
        requestHeader: true,
        responseHeader: false,
      ),
    );
  }

  return dio;
}
