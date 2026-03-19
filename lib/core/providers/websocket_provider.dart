import 'package:bullatech/core/services/websocket_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'websocket_provider.g.dart';

@riverpod
WebSocketService websocketService(final Ref ref) {
  return WebSocketService();
}
