import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'location_provider.g.dart';

@riverpod
Stream<LatLng> currentLocation(final Ref ref) async* {
  // Check permission
  var permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }

  if (permission == LocationPermission.deniedForever) {
    throw Exception('Location permission permanently denied');
  }

  const locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 5,
  );

  await for (final position
      in Geolocator.getPositionStream(locationSettings: locationSettings)) {
    yield LatLng(position.latitude, position.longitude);
  }
}
