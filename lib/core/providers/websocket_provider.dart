import 'package:bullatech/core/services/websocket_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'websocket_provider.g.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

@riverpod
WebSocketService websocketService(final Ref ref) {
  final service = WebSocketService();

  Future.microtask(() async {
    await service.init(navigatorKey);
  });

  return service;
}
