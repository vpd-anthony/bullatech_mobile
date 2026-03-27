import 'package:bullatech/features/ticket_list/data/datasources/remote/driver_remote_datasource.dart';
import 'package:bullatech/features/ticket_list/data/repositories/driver_repository.dart';

class DriverRepositoryImpl implements DriverRepository {
  final DriverRemoteDatasource _driverRemoteDataSource;

  DriverRepositoryImpl(this._driverRemoteDataSource);

  @override
  Future<void> updateTicketTechnicalAssignsLocationsStatus(
      final int ticketId, final String newStatus) async {
    await _driverRemoteDataSource.updateTicketTechnicalAssignsLocationsStatus(
        ticketId, newStatus);
  }
}
