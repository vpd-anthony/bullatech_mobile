import 'package:bullatech/features/ticket_list/domain/models/tickets/technical_assign_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'technical_assign_location_model.freezed.dart';
part 'technical_assign_location_model.g.dart';

@freezed
class TechnicalAssignLocation with _$TechnicalAssignLocation {
  const factory TechnicalAssignLocation({
    required final int id,
    required final double departureLat,
    required final double departureLng,
    required final String departureAddress,
    required final double arrivalLat,
    required final double arrivalLng,
    required final String arrivalAddress,
    required final String distance,
    required final String eta,
    final int? technicalHeadId,
    final String? status,
    required final List<TechnicalAssign> technicalAssigns,
  }) = _TechnicalAssignLocation;
  factory TechnicalAssignLocation.fromJson(final Map<String, dynamic> json) =>
      _$TechnicalAssignLocationFromJson(json);
}
