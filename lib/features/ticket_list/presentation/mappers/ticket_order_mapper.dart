import 'package:bullatech/features/ticket_list/presentation/mappers/customer_info_mapper.dart';
import 'package:bullatech/features/ticket_list/presentation/mappers/technical_assign_location_mapper.dart';

class TicketOrder {
  final String orderId;
  final String ticketNo;
  final TechnicalAssignLocation departure;
  final TechnicalAssignLocation arrival;
  final CustomerInfo customer;
  final String distanceKm;
  final String estimatedMinutes;

  const TicketOrder({
    required this.orderId,
    required this.ticketNo,
    required this.departure,
    required this.arrival,
    required this.customer,
    required this.distanceKm,
    required this.estimatedMinutes,
  });
}
