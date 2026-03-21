import 'dart:convert';
import 'package:bullatech/core/notifiers/auth_status_notifier.dart';
import 'package:bullatech/features/ticket_list/presentation/widgets/ticket_order_widget.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bullatech/core/enums/auth/auth_status.dart';

class WebSocketService {
  IOWebSocketChannel? _channel;

  /// Channels to subscribe
  final List<String> _channels = ['tickets'];

  /// Queue events before login
  final List<Map<String, dynamic>> _queuedEvents = [];

  /// Connect to WebSocket immediately
  Future<void> connect(
    final GlobalKey<NavigatorState> navigatorKey,
    final ProviderContainer container, // <-- Use ProviderContainer
  ) async {
    if (_channel != null) return; // Already connected

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

    // Subscribe to channels
    for (final channel in _channels) {
      final subscribeMessage = {
        'event': 'pusher:subscribe',
        'data': {'channel': channel}
      };
      _channel!.sink.add(jsonEncode(subscribeMessage));
      debugPrint('[WebSocketService] Subscribed to channel: $channel');
    }

    // Listen for incoming messages
    _channel!.stream.listen(
      (final message) {
        try {
          final data = jsonDecode(message);

          if (data['event'] == 'technical.assigned' &&
              data['channel'] == 'tickets') {
            final eventData = jsonDecode(data['data']);
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

  /// Close connection
  void disconnect() {
    _channel?.sink.close(status.normalClosure);
    _channel = null;
  }

  /// Handle ticket event
  void _handleTicketTechnicalAssignedEvent(
    final Map<String, dynamic> data,
    final GlobalKey<NavigatorState> navigatorKey,
    final ProviderContainer container,
  ) {
    final context = navigatorKey.currentContext;
    if (context == null) return;

    // Check auth status
    // final authStatus = container.read(authStatusNotifierProvider);
    // if (authStatus != AuthStatus.authenticated) {
    //   // Queue for later
    //   return;
    // }
    _queuedEvents.add(data);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (final _) => const TicketOrderWidget(
        order: sampleOrder, // make sure sampleOrder is defined
      ),
    );
  }

  /// Call this after login to flush queued events
  void flushQueuedEvents(
    final GlobalKey<NavigatorState> navigatorKey,
    final ProviderContainer container,
  ) {
    if (_queuedEvents.isEmpty) return;

    for (final event in _queuedEvents) {
      _handleTicketTechnicalAssignedEvent(event, navigatorKey, container);
    }
    _queuedEvents.clear();
  }
}
