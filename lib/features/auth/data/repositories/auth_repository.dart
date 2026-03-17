import 'package:bullatech/core/models/auth_user.dart';
import 'package:bullatech/features/auth/data/dtos/login_request_dto.dart';
import 'package:bullatech/features/auth/data/dtos/password_only_login_request_dto.dart';
import 'package:bullatech/features/auth/domain/models/login_response.dart';

abstract class AuthRepository {
  Future<LoginResponse> login(final LoginRequestDto dto);
  Future<LoginResponse> passwordOnlylogin(
      final PasswordOnlyLoginRequestDto dto);
  Future<bool> isLoggedIn();
  Future<AuthUser?> getEmployeeUser();
  Future<void> logDetailedEmployeeUserData();
  Future<void> clearAllData();
}
