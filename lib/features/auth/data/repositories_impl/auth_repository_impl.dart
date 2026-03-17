import 'package:bullatech/core/models/auth_user.dart';
import 'package:bullatech/features/auth/application/services/biometric_service.dart';
import 'package:bullatech/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:bullatech/features/auth/data/datasources/local/auth_user_storage.dart';
import 'package:bullatech/features/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:bullatech/features/auth/data/dtos/login_request_dto.dart';
import 'package:bullatech/features/auth/data/dtos/password_only_login_request_dto.dart';
import 'package:bullatech/features/auth/data/repositories/auth_repository.dart';
import 'package:bullatech/features/auth/domain/models/login_response.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;
  final BiometricService _biometricService;

  AuthRepositoryImpl(
      this._remoteDataSource, this._localDataSource, this._biometricService);

  @override
  Future<LoginResponse> login(final LoginRequestDto dto) async {
    try {
      final response = await _remoteDataSource.login(dto);

      final biometricAvailable = await _biometricService.isBiometricAvailable();
      final biometricEnabled = await _biometricService.isBiometricEnabled();
      final isBiometricAvailable = biometricAvailable && !biometricEnabled;

      await _remoteDataSource.employeeUserDevice(response.authorisation.token,
          isBiometricAvailable ? 1 : 0, response.user);

      await _localDataSource.saveEmployeeUser(response.user);
      await _localDataSource.saveAuthToken(
          type: response.authorisation.type,
          token: response.authorisation.token);

      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<LoginResponse> passwordOnlylogin(
      final PasswordOnlyLoginRequestDto dto) async {
    try {
      final response = await _remoteDataSource.passwordOnlylogin(dto);

      final biometricAvailable = await _biometricService.isBiometricAvailable();
      final biometricEnabled = await _biometricService.isBiometricEnabled();
      final isBiometricAvailable = biometricAvailable && !biometricEnabled;

      await _remoteDataSource.employeeUserDevice(response.authorisation.token,
          isBiometricAvailable ? 1 : 0, response.user);

      await _localDataSource.saveEmployeeUser(response.user);
      await _localDataSource.saveAuthToken(
          type: response.authorisation.type,
          token: response.authorisation.token);

      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    return await _localDataSource.isLoggedIn();
  }

  @override
  Future<AuthUser?> getEmployeeUser() async {
    return await _localDataSource.getEmployeeUser();
  }

  @override
  Future<void> logDetailedEmployeeUserData() async {
    await _localDataSource.logDetailedEmployeeUserData();
  }

  @override
  Future<void> clearAllData() async {
    await _localDataSource.clearAllData();
  }
}
