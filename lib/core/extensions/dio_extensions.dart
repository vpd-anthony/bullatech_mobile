import 'package:dio/dio.dart';

import '../exceptions/app_exception.dart';

extension DioFriendly on Future<Response> {
  /// Automatically throws a proper Exception if DioException occurs
  Future<T> asMessage<T>() async {
    try {
      final response = await this;
      return response.data as T;
    } on DioException catch (e) {
      final message = (e.error is AppException)
          ? (e.error as AppException).message
          : 'Network error occurred';
      throw AppException(message); // <-- throw proper exception
    } catch (e) {
      final message = e is AppException ? e.message : e.toString();
      throw AppException(message); // <-- throw proper exception
    }
  }
}
