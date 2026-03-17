import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  // Private constructor to prevent instantiation
  ApiConstants._();

  // ========== Base Configuration ==========
  static final bool isDevelopment =
      dotenv.env['IS_DEVELOPMENT']?.toLowerCase() == 'true';

  static final String baseUrl = isDevelopment
      ? (dotenv.env['BASE_URL_DEV'] ?? '')
      : (dotenv.env['BASE_URL_PROD'] ?? '');

  // ========== Timeouts ==========
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // ========== Headers ==========
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // ========== File Upload Limits ==========
  static const int maxFileSize = 10 * 1024 * 1024; // 10 MB
  static const List<String> allowedFileTypes = [
    'image/jpeg',
    'image/png',
    'image/gif',
    'application/pdf',
    'application/msword',
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    'application/vnd.ms-excel',
    'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    'text/plain',
    'text/csv',
  ];
}
