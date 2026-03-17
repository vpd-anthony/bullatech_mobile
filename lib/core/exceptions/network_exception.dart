import 'package:bullatech/core/exceptions/app_exception.dart';
import 'package:dio/dio.dart';

class NetworkException extends AppException {
  const NetworkException(
    super.message, {
    super.originalError,
    super.stackTrace,
  });

  factory NetworkException.fromDio(final DioException e) {
    return NetworkException(
      switch (e.type) {
        DioExceptionType.connectionTimeout => 'Connection timed out.',
        DioExceptionType.sendTimeout => 'Request timed out.',
        DioExceptionType.receiveTimeout => 'Response timed out.',
        DioExceptionType.connectionError => 'No internet connection.',
        _ => 'Network error occurred',
      },
      originalError: e,
    );
  }
}
