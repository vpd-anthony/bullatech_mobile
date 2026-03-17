class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;
  final StackTrace? stackTrace;

  const AppException(
    this.message, {
    this.code,
    this.originalError,
    this.stackTrace,
  });

  @override
  String toString() => message;

  factory AppException.fromError(
    final dynamic error, [
    final StackTrace? stackTrace,
  ]) {
    if (error is AppException) {
      return error;
    }

    return AppException(
      error.toString(),
      originalError: error,
      stackTrace: stackTrace,
    );
  }
}
