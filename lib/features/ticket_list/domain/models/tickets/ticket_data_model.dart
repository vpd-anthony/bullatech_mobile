import 'package:bullatech/features/ticket_list/domain/models/customer_model.dart';
import 'package:bullatech/features/ticket_list/domain/models/tickets/technical_assign_location_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'ticket_data_model.freezed.dart';
part 'ticket_data_model.g.dart';

@freezed
class TicketData with _$TicketData {
  const factory TicketData({
    required final int id,
    required final String ticketNo,
    required final Customer? customer,
    required final TechnicalAssignLocation? technicalAssignsLocation,
  }) = _TicketData;
  factory TicketData.fromJson(final Map<String, dynamic> json) =>
      _$TicketDataFromJson(json);
}
