import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'route_provider.g.dart';

@riverpod
class ActiveRoute extends _$ActiveRoute {
  @override
  (LatLng, LatLng)? build() {
    return null; // initial state
  }

  void setRoute(final LatLng departure, final LatLng arrival) {
    state = (departure, arrival);
  }

  void clearRoute() {
    state = null;
  }
}
