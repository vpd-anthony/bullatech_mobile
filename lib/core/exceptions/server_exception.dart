import 'package:bullatech/core/exceptions/app_exception.dart';

class ServerException extends AppException {
  const ServerException(
    super.message, {
    // ⚠ positional
    super.code,
    super.originalError,
    super.stackTrace,
  });

  /// Creates ServerException from any server response
  factory ServerException.fromJson(final dynamic json) {
    if (json is Map<String, dynamic>) {
      final message = json['message']?.toString() ??
          json['error']?.toString() ??
          'Server error occurred';
      final code = json['status']?.toString(); // optional string

      return ServerException(
        message,
        code: code,
        originalError: json,
      );
    }

    return ServerException(
      json?.toString() ?? 'Server error occurred',
      code: null,
      originalError: json,
    );
  }
}
