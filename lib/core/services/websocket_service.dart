import 'dart:convert';
import 'package:bullatech/core/providers/google/route_provider.dart';
import 'package:bullatech/features/ticket_list/domain/models/tickets/ticket_data_model.dart';
import 'package:bullatech/features/ticket_list/domain/models/tickets/ticket_event_model.dart';
import 'package:bullatech/features/ticket_list/presentation/mappers/customer_info_mapper.dart';
import 'package:bullatech/features/ticket_list/presentation/mappers/technical_assign_location_mapper.dart';
import 'package:bullatech/features/ticket_list/presentation/mappers/ticket_order_mapper.dart';
import 'package:bullatech/features/ticket_list/presentation/screens/drive_home_screen.dart';
import 'package:bullatech/features/ticket_list/presentation/widgets/ticket_order_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WebSocketService {
  IOWebSocketChannel? _channel;
  final List<String> _channels = ['tickets'];
  final List<Map<String, dynamic>> _queuedEvents = [];

  Future<void> connect(
    final GlobalKey<NavigatorState> navigatorKey,
    final ProviderContainer container,
  ) async {
    if (_channel != null) return;

    final scheme = dotenv.env['WS_SCHEME'];
    final host = dotenv.env['WS_HOST'];
    final port = dotenv.env['WS_PORT'];
    final rawKey = dotenv.env['WS_APP_KEY'] ?? '';
    final protocol = dotenv.env['WS_PROTOCOL'];

    if ([scheme, host, port, rawKey, protocol]
        .any((final e) => e == null || e.isEmpty)) {
      debugPrint('[WebSocketService] Missing WS environment variables.');
      return;
    }

    final url =
        '$scheme://$host:$port/app/${Uri.encodeComponent(rawKey)}?protocol=$protocol&client=flutter&version=1.0';

    _channel = IOWebSocketChannel.connect(url);

    for (final channel in _channels) {
      _channel!.sink.add(jsonEncode({
        'event': 'pusher:subscribe',
        'data': {'channel': channel}
      }));
      debugPrint('[WebSocketService] Subscribed to channel: $channel');
    }

    _channel!.stream.listen(
      (final message) {
        try {
          final decoded = jsonDecode(message);
          if (decoded['event'] == 'technical.assigned') {
            final rawData = decoded['data'];
            final eventData = rawData is String ? jsonDecode(rawData) : rawData;
            _handleTicketTechnicalAssignedEvent(
              Map<String, dynamic>.from(eventData),
              navigatorKey,
              container,
            );
          }
        } catch (e) {
          debugPrint('WebSocket decode error: $e');
        }
      },
      onError: (final error) => debugPrint('WebSocket error: $error'),
      onDone: () {
        debugPrint('WebSocket connection closed, reconnecting in 3s...');
        _channel = null;
        Future.delayed(const Duration(seconds: 3), () {
          connect(navigatorKey, container);
        });
      },
    );

    debugPrint('WebSocketService connected and listening to channels.');
  }

  void disconnect() {
    _channel?.sink.close(status.normalClosure);
    _channel = null;
  }

  void _handleTicketTechnicalAssignedEvent(
    final Map<String, dynamic> data,
    final GlobalKey<NavigatorState> navigatorKey,
    final ProviderContainer container,
  ) {
    final context = navigatorKey.currentContext;
    if (context == null) return;

    try {
      final ticketEvent = TicketEvent.fromJson(data);
      final ticket = ticketEvent.ticket;

      final loc = ticket.technicalAssignsLocation;
      final departure = LatLng(loc!.departureLat, loc.departureLng);
      final arrival = LatLng(loc.arrivalLat, loc.arrivalLng);

      final order = _mapToTicketOrder(ticket);

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (final _) => TicketOrderWidget(
          order: order,
          onAccepted: () {
            debugPrint('Ticket ${order.orderId} accepted');

            final driverScreenState =
                DriverHomeScreen.driverHomeKey.currentState;
            final currentPos =
                driverScreenState?.currentDriverPosition ?? departure;
            driverScreenState?.drawRouteExternally(
                currentPos, departure, arrival);

            container
                .read(activeRouteProvider.notifier)
                .setRoute(departure, arrival);
          },
        ),
      );
    } catch (e) {
      debugPrint('Ticket parsing error: $e');
    }
  }

  TicketOrder _mapToTicketOrder(final TicketData ticket) {
    final loc = ticket.technicalAssignsLocation;

    return TicketOrder(
      orderId: ticket.id.toString(),
      ticketNo: ticket.ticketNo,
      departure: TechnicalAssignLocation(
        label: 'Departure',
        name: 'Departure',
        lat: loc!.departureLat,
        lng: loc.departureLng,
        address: loc.departureAddress,
      ),
      arrival: TechnicalAssignLocation(
        label: 'Arrival',
        name: 'Arrival',
        lat: loc.arrivalLat,
        lng: loc.arrivalLng,
        address: loc.arrivalAddress,
      ),
      distanceKm: loc.distance,
      estimatedMinutes: loc.eta,
      customer: CustomerInfo(
        name: ticket.customer?.name ?? 'Unknown',
        phone: ticket.customer?.mobileNo ?? 'Unknown',
      ),
    );
  }

  void flushQueuedEvents(
    final GlobalKey<NavigatorState> navigatorKey,
    final ProviderContainer container,
  ) {
    for (final event in _queuedEvents) {
      _handleTicketTechnicalAssignedEvent(event, navigatorKey, container);
    }
    _queuedEvents.clear();
  }
}
