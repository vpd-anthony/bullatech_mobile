import 'package:freezed_annotation/freezed_annotation.dart';

part 'branch_model.freezed.dart';
part 'branch_model.g.dart';

@freezed
class BranchModel with _$BranchModel {
  const factory BranchModel({
    required final int id,
    required final int companyId,
    required final String name,
    final String? owner,
    required final String address,
    final String? logo,
    required final int status,
    final DateTime? deletedAt,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _BranchModel;
  factory BranchModel.fromJson(final Map<String, dynamic> json) =>
      _$BranchModelFromJson(json);
}
