import 'package:bullatech/core/models/employee/employee_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'employee_user_model.freezed.dart';
part 'employee_user_model.g.dart';

@freezed
class EmployeeUserModel with _$EmployeeUserModel {
  const factory EmployeeUserModel({
    required final int id,
    required final int userId,
    required final int employeeId,
    required final int discussionCreate,
    final DateTime? createdAt,
    final DateTime? updatedAt,
    final EmployeeModel? employee,
  }) = _EmployeeUserModel;
  factory EmployeeUserModel.fromJson(final Map<String, dynamic> json) =>
      _$EmployeeUserModelFromJson(json);
}
