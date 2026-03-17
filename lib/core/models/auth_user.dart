import 'package:bullatech/core/helpers/base64_converter.dart';
import 'package:bullatech/core/models/branch/branch_model.dart';
import 'package:bullatech/core/models/company/company_model.dart';
import 'package:bullatech/core/models/employee/employee_user_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'auth_user.freezed.dart';
part 'auth_user.g.dart';

@freezed
class AuthUser with _$AuthUser {
  const factory AuthUser({
    required final int id,
    required final String name,
    required final String username,
    required final String email,
    final String? emailVerifiedAt,
    final String? userImage,
    required final int companyId,
    required final int branchId,
    final String? accessControl,
    required final String userStatus,
    required final int status,
    final String? createdAt,
    final String? updatedAt,
    @Base64Converter() final Uint8List? profileImage,
    final CompanyModel? company,
    final BranchModel? branch,
    final EmployeeUserModel? employeeuser,
  }) = _AuthUser;
  factory AuthUser.fromJson(final Map<String, dynamic> json) =>
      _$AuthUserFromJson(json);
}
