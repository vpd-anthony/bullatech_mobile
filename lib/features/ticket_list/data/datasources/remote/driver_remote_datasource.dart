import 'package:bullatech/core/extensions/dio_extensions.dart';
import 'package:dio/dio.dart';

class DriverRemoteDatasource {
  final Dio dio;

  DriverRemoteDatasource({
    required this.dio,
  });

  Future<void> updateTicketTechnicalAssignsLocationsStatus(
      final int ticketId, final String newStatus) async {
    await dio.post(
      '/tickets/$ticketId/technical-assigns-locations/status',
      data: {
        'status': newStatus,
      },
    ).asMessage<Map<String, dynamic>>();
  }
}
