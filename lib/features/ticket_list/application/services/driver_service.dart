import 'package:bullatech/features/ticket_list/data/repositories/driver_repository.dart';

class DriverService {
  final DriverRepository _repository;

  DriverService(this._repository);
  Future<void> updateTicketTechnicalAssignsLocationsStatus(
          final int ticketId, final String newStatus) =>
      _repository.updateTicketTechnicalAssignsLocationsStatus(
          ticketId, newStatus);
}
