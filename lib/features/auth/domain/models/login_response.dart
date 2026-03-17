import 'package:bullatech/core/models/auth_user.dart';
import 'package:bullatech/features/auth/domain/models/authorisation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_response.freezed.dart';
part 'login_response.g.dart';

@freezed
class LoginResponse with _$LoginResponse {
  const factory LoginResponse({
    required final String status,
    required final Authorisation authorisation,
    required final AuthUser user,
  }) = _LoginResponse;
  factory LoginResponse.fromJson(final Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}
