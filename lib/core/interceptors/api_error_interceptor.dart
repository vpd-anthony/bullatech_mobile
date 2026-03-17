import 'dart:async';

import 'package:dio/dio.dart';

import '../exceptions/network_exception.dart';
import '../exceptions/server_exception.dart';

typedef OnUnauthorized = Future<void> Function();
typedef OnUnauthenticated = void Function();

class ApiErrorInterceptor extends Interceptor {
  final OnUnauthorized onUnauthorized;
  final OnUnauthenticated onUnauthenticated;

  bool _handling401 = false;

  ApiErrorInterceptor({
    required this.onUnauthorized,
    required this.onUnauthenticated,
  });

  @override
  void onError(
      final DioException err, final ErrorInterceptorHandler handler) async {
    final response = err.response;
    // final data = err.response?.data;

    // final rawMessage = data['message']?.toString();
    // final message = (rawMessage == "Unauthenticated.")
    //     ? AppConstants.loginExpiredMsg.toString()
    //     : rawMessage ?? 'Unknown error';

    // Handle 401 → unauthorized / token expired
    if (response?.statusCode == 401 && !_handling401) {
      _handling401 = true;

      // Mark user as unauthenticated
      onUnauthenticated();

      // Fire-and-forget unauthorized logic
      unawaited(() async {
        try {
          await onUnauthorized();
        } finally {
          _handling401 = false;
        }
      }());

      // Reject with a wrapped 401 error
      handler.reject(
        err.copyWith(
          error: ServerException(
            response?.data['message']?.toString() ??
                'Unauthorized, please login again',
            code: '401',
            originalError: response?.data,
          ),
        ),
      );
      return;
    }

    // If the server returned a response
    if (response != null) {
      final data = response.data;

      // If the data is a Map with status='error', use ServerException.fromJson
      if (data is Map<String, dynamic> && data['status'] == 'error') {
        handler.reject(
          err.copyWith(
            error: ServerException.fromJson(data),
          ),
        );
        return;
      }

      // Otherwise, wrap any other server response into ServerException
      handler.reject(
        err.copyWith(
          error: ServerException(
            data.toString(), // ⚠ positional
            code: response.statusCode?.toString(),
            originalError: data,
          ),
        ),
      );

      return;
    }

    // If there is no response → treat as network error (offline, timeout, etc.)
    handler.reject(
      err.copyWith(
        error: NetworkException.fromDio(err),
      ),
    );
  }

  @override
  void onResponse(
      final Response response, final ResponseInterceptorHandler handler) {
    final data = response.data;

    if (data is Map<String, dynamic> && data['status'] == 'error') {
      handler.reject(
        DioException(
          requestOptions: response.requestOptions,
          error: ServerException.fromJson(data),
        ),
      );
      return;
    }

    handler.next(response);
  }
}
