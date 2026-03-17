import 'package:bullatech/common/constants/app_constants.dart';
import 'package:bullatech/core/exceptions/server_exception.dart';
import 'package:bullatech/core/extensions/dio_extensions.dart';
import 'package:bullatech/core/models/auth_user.dart';
import 'package:bullatech/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:bullatech/features/auth/data/datasources/local/auth_user_storage.dart';
import 'package:bullatech/features/auth/data/dtos/login_request_dto.dart';
import 'package:bullatech/features/auth/data/dtos/password_only_login_request_dto.dart';
import 'package:bullatech/features/auth/domain/models/login_response.dart';
import 'package:dio/dio.dart';

class AuthRemoteDatasource {
  final Dio dio;
  final AuthLocalDataSource authLocalDataSource;

  AuthRemoteDatasource({
    required this.dio,
    required this.authLocalDataSource,
  });

  Future<LoginResponse> login(final LoginRequestDto dto) async {
    final data = await dio
        .post(
          '/user/login',
          data: dto.toMap(),
        )
        .asMessage<Map<String, dynamic>>();

    if (data['status'] == 'error') {
      throw ServerException.fromJson(data);
    }

    return LoginResponse.fromJson(data);
  }

  Future<LoginResponse> passwordOnlylogin(
      final PasswordOnlyLoginRequestDto dto) async {
    final employeeUser = await authLocalDataSource.getEmployeeUser();

    if (employeeUser == null) {
      throw Exception(AppConstants.globalErrMsg);
    }

    final requestData = dto.toMap()
      ..['employee_code'] = employeeUser.employeeuser?.employee?.employeeCode
      ..['userName'] = employeeUser.username
      ..['email'] = employeeUser.email;

    final data = await dio
        .post(
          '/user/login',
          data: requestData,
        )
        .asMessage<Map<String, dynamic>>();

    if (data['status'] == 'error') {
      throw ServerException.fromJson(data);
    }

    return LoginResponse.fromJson(data);
  }

  Future<void> employeeUserDevice(
      final String token, final int hasBiometrics, final AuthUser? user) async {
    final deviceId = await authLocalDataSource.getDeviceId();

    await dio.post(
      '/user/device',
      data: {
        'user_id': user?.id,
        'device_id': deviceId,
        'token': token,
        'has_biometrics': hasBiometrics,
      },
    ).asMessage<Map<String, dynamic>>();
  }
}
