abstract class DriverRepository {
  Future<void> updateTicketTechnicalAssignsLocationsStatus(
      final int ticketId, final String newStatus);
}
