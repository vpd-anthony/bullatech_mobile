import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'technical_assign_model.freezed.dart';
part 'technical_assign_model.g.dart';

@freezed
class TechnicalAssign with _$TechnicalAssign {
  const factory TechnicalAssign({
    required final int id,
    required final String name,
    required final int assignedBy,
  }) = _TechnicalAssign;
  factory TechnicalAssign.fromJson(final Map<String, dynamic> json) =>
      _$TechnicalAssignFromJson(json);
}
