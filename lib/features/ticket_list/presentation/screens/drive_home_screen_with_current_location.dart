import 'dart:async';

import 'package:bullatech/common/constants/app_constants.dart';
import 'package:bullatech/core/providers/google/route_provider.dart';
import 'package:bullatech/core/services/google/directions_service.dart';
import 'package:bullatech/features/ticket_list/presentation/providers/location_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DriverHomeScreenWithCurrentLocation extends ConsumerStatefulWidget {
  const DriverHomeScreenWithCurrentLocation({super.key});

  @override
  ConsumerState<DriverHomeScreenWithCurrentLocation> createState() =>
      _DriverHomeScreenWithCurrentLocationState();
}

class _DriverHomeScreenWithCurrentLocationState
    extends ConsumerState<DriverHomeScreenWithCurrentLocation>
    with TickerProviderStateMixin {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  LatLng? _prevDriverPosition;
  LatLng? _currentDriverPosition;
  AnimationController? _markerAnimController;
  Animation<double>? _markerAnim;

  (LatLng, LatLng)? _lastRoute;

  @override
  void initState() {
    super.initState();
    _markerAnimController = AnimationController(
      duration: AppConstants.markerAnimationDuration,
      vsync: this,
    );
    _markerAnim = CurvedAnimation(
      parent: _markerAnimController!,
      curve: Curves.easeInOut,
    );
    _markerAnim!.addListener(_animateMarker);
  }

  @override
  void dispose() {
    _mapController?.dispose();
    _markerAnimController?.dispose();
    super.dispose();
  }

  void _onMapCreated(final GoogleMapController controller) {
    _mapController = controller;
  }

  void _animateMarker() {
    if (_prevDriverPosition == null || _currentDriverPosition == null) return;

    final t = _markerAnim!.value;
    final lat = _prevDriverPosition!.latitude +
        (_currentDriverPosition!.latitude - _prevDriverPosition!.latitude) * t;
    final lng = _prevDriverPosition!.longitude +
        (_currentDriverPosition!.longitude - _prevDriverPosition!.longitude) *
            t;

    final newPosition = LatLng(lat, lng);
    _updateDriverMarker(newPosition);

    // Smoothly move camera to follow the driver
    _mapController?.animateCamera(
      CameraUpdate.newLatLng(newPosition),
    );
  }

  void _updateDriverMarker(final LatLng position) {
    setState(() {
      // Only show driver marker if route is not active
      if (_polylines.isEmpty) {
        _markers.removeWhere((final m) => m.markerId.value == 'driver');
        _markers.add(
          Marker(
            markerId: const MarkerId('driver'),
            position: position,
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueRed,
            ),
            infoWindow: const InfoWindow(title: 'You (Driver)'),
            zIndex: 2,
          ),
        );
      }
    });
  }

  Future<void> _drawRoute(final LatLng departure, final LatLng arrival) async {
    if (_mapController == null) return;

    try {
      final points = await DirectionsService.getRoute(
        origin: departure,
        destination: arrival,
      );

      if (points.isEmpty) return;

      final polyline = Polyline(
        polylineId: const PolylineId('route'),
        color: Colors.blue,
        width: 6,
        points: points,
      );

      setState(() {
        _polylines.clear();
        _polylines.add(polyline);

        // Remove driver marker temporarily
        _markers.removeWhere((final m) => m.markerId.value == 'driver');

        // Add departure & arrival markers
        _markers.removeWhere((final m) =>
            m.markerId.value == 'departure' || m.markerId.value == 'arrival');

        _markers.addAll([
          Marker(
            markerId: const MarkerId('departure'),
            position: departure,
            infoWindow: const InfoWindow(title: 'Departure'),
          ),
          Marker(
            markerId: const MarkerId('arrival'),
            position: arrival,
            infoWindow: const InfoWindow(title: 'Arrival'),
          ),
        ]);
      });

      _fitBounds(points);
    } catch (e) {
      debugPrint('[Route] Error drawing route: $e');
    }
  }

  void _fitBounds(final List<LatLng> points) {
    if (_mapController == null || points.isEmpty) return;

    var minLat = points.first.latitude;
    var maxLat = points.first.latitude;
    var minLng = points.first.longitude;
    var maxLng = points.first.longitude;

    for (final p in points) {
      if (p.latitude < minLat) minLat = p.latitude;
      if (p.latitude > maxLat) maxLat = p.latitude;
      if (p.longitude < minLng) minLng = p.longitude;
      if (p.longitude > maxLng) maxLng = p.longitude;
    }

    // Expand bounds by ~10% for better view
    final latPadding = (maxLat - minLat) * 0.1;
    final lngPadding = (maxLng - minLng) * 0.1;

    final bounds = LatLngBounds(
      southwest: LatLng(minLat - latPadding, minLng - lngPadding),
      northeast: LatLng(maxLat + latPadding, maxLng + lngPadding),
    );

    _mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 50), // 50 px padding
    );
  }

  void _resetCamera() {
    if (_mapController == null || _currentDriverPosition == null) return;

    _mapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: _currentDriverPosition!,
          zoom: AppConstants.defaultZoom,
        ),
      ),
    );
  }

  void _clearRoute() {
    setState(() {
      _polylines.clear();
      _markers.removeWhere(
        (final m) =>
            m.markerId.value == 'departure' || m.markerId.value == 'arrival',
      );
      _updateDriverMarker(_currentDriverPosition!);
    });

    _resetCamera();
  }

  @override
  Widget build(final BuildContext context) {
    final locationAsync = ref.watch(currentLocationProvider);
    final route = ref.watch(activeRouteProvider);

    // Draw route if active and changed
    if (route != null && route != _lastRoute) {
      _lastRoute = route;
      WidgetsBinding.instance.addPostFrameCallback((final _) {
        _drawRoute(route.$1, route.$2);
      });
    }

    // Clear route automatically if it disappears
    if (route == null && _polylines.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((final _) {
        _clearRoute();
      });
    }

    return locationAsync.when(
      data: (final position) {
        // Animate driver marker if route is not active
        if (_currentDriverPosition != position) {
          _prevDriverPosition = _currentDriverPosition ?? position;
          _currentDriverPosition = position;

          if (_polylines.isEmpty) {
            _markerAnimController?.forward(from: 0);
          }
        }

        return GoogleMap(
          initialCameraPosition: CameraPosition(
            target: position,
            zoom: AppConstants.defaultZoom,
          ),
          onMapCreated: _onMapCreated,
          markers: {..._markers},
          polylines: {..._polylines},
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          mapType: MapType.hybrid,
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (final err, final _) => Scaffold(
        body: Center(child: Text(err.toString())),
      ),
    );
  }
}
