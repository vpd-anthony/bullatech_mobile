import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class WebSocketService {
  final PusherChannelsFlutter _pusher = PusherChannelsFlutter();

  Future<void> init(final GlobalKey<NavigatorState> navigatorKey) async {
    final apiKey = dotenv.env['PUSHER_APP_KEY'];
    final cluster = dotenv.env['PUSHER_APP_CLUSTER'];

    if (apiKey == null ||
        apiKey.isEmpty ||
        cluster == null ||
        cluster.isEmpty) {
      debugPrint(
          'PUSHER_APP_KEY or PUSHER_APP_CLUSTER not set in .env. Skipping Pusher initialization.');
      return;
    }

    await _pusher.init(
      apiKey: apiKey,
      cluster: cluster,
      onConnectionStateChange: (final currentState, final previousState) {
        debugPrint("Connection: $currentState");
      },
      onError: (final message, final code, final e) {
        debugPrint("Error: $message");
      },
      onEvent: (final event) {
        final data = jsonDecode(event.data);
        debugPrint('Event: $data');

        _handleTicketTechnicalAssignedEvent(data, navigatorKey);
      },
    );

    await _pusher.subscribe(channelName: 'tickets');
    await _pusher.connect();
  }

  void _handleTicketTechnicalAssignedEvent(
    final Map<String, dynamic> data,
    final GlobalKey<NavigatorState> navigatorKey,
  ) {
    final context = navigatorKey.currentContext;
    if (context == null) return;

    showDialog(
      context: context,
      builder: (final _) => AlertDialog(
        title: const Text('New Assignment'),
        content: Text(
          'Ticket #${data['ticketId']} assigned\nTech IDs: ${data['technicalIds']}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
