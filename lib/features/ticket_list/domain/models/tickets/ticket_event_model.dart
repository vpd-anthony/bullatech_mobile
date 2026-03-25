import 'package:bullatech/features/ticket_list/domain/models/tickets/ticket_data_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'ticket_event_model.freezed.dart';
part 'ticket_event_model.g.dart';

@freezed
class TicketEvent with _$TicketEvent {
  const factory TicketEvent({
    required final TicketData ticket,
  }) = _TicketEvent;
  factory TicketEvent.fromJson(final Map<String, dynamic> json) =>
      _$TicketEventFromJson(json);
}
