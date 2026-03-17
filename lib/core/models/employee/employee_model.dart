import 'package:freezed_annotation/freezed_annotation.dart';

part 'employee_model.freezed.dart';
part 'employee_model.g.dart';

@freezed
class EmployeeModel with _$EmployeeModel {
  const factory EmployeeModel({
    required final int id,
    required final int departmentId,
    required final int jobId,
    required final int scheduleId,
    final String? role,
    required final String employeeCode,
    required final String firstName,
    final String? middleName,
    required final String lastName,
    final String? suffix,
    required final String birthdate,
    required final String civilStatus,
    required final double contactNumber,
    required final String gender,
    required final String email,
    final String? address,
    final String? permanentAddress,
    final String? elementary,
    final String? highschool,
    final String? college,
    final String? yearElementary,
    final String? yearHighschool,
    final String? yearCollege,
    final String? degree,
    final String? sss,
    final String? tin,
    final String? pagibig,
    final String? philhealth,
    final String? employeeImage,
    final String? jobLevel,
    required final DateTime hiredDate,
    final int? workArrangement,
    final String? separationDate,
    required final String employeeStatus,
    final String? compressWorkWeek,
    final String? terminationStatus,
    final int? createdBy,
    final int? updatedBy,
    required final int companyId,
    required final int branchId,
    final DateTime? deletedAt,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _EmployeeModel;

  factory EmployeeModel.fromJson(final Map<String, dynamic> json) =>
      _$EmployeeModelFromJson(json);
}
