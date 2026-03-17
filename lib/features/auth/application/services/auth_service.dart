import 'package:bullatech/core/models/auth_user.dart';
import 'package:bullatech/features/auth/data/dtos/login_request_dto.dart';
import 'package:bullatech/features/auth/data/dtos/password_only_login_request_dto.dart';
import 'package:bullatech/features/auth/data/repositories/auth_repository.dart';
import 'package:bullatech/features/auth/domain/models/login_response.dart';

class AuthService {
  final AuthRepository _repository;

  AuthService(this._repository);

  Future<LoginResponse> login(final LoginRequestDto request) async {
    final response = await _repository.login(request);
    return response;
  }

  Future<LoginResponse> passwordOnlylogin(
      final PasswordOnlyLoginRequestDto request) async {
    final response = await _repository.passwordOnlylogin(request);
    return response;
  }

  Future<bool> isLoggedIn() {
    return _repository.isLoggedIn();
  }

  /// Get employee user data
  Future<AuthUser?> getEmployeeUser() => _repository.getEmployeeUser();

  /// Log detailed employee user JSON
  Future<void> logEmployeeUserDetails() =>
      _repository.logDetailedEmployeeUserData();

  Future<void> clearAllData() => _repository.clearAllData();
}
