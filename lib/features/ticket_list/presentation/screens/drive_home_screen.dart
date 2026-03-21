import 'dart:async';

import 'package:bullatech/common/constants/app_constants.dart';
import 'package:bullatech/features/ticket_list/presentation/providers/location_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DriverHomeScreen extends ConsumerStatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  ConsumerState<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends ConsumerState<DriverHomeScreen>
    with TickerProviderStateMixin {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  Timer? _markerAnimTimer;
  LatLng? _prevDriverPosition;
  LatLng? _currentDriverPosition;
  AnimationController? _markerAnimController;
  Animation<double>? _markerAnim;

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

  void _animateMarker() {
    if (_prevDriverPosition == null || _currentDriverPosition == null) return;
    final t = _markerAnim!.value;
    final animatedLat = _prevDriverPosition!.latitude +
        (_currentDriverPosition!.latitude - _prevDriverPosition!.latitude) * t;
    final animatedLng = _prevDriverPosition!.longitude +
        (_currentDriverPosition!.longitude - _prevDriverPosition!.longitude) *
            t;
    _updateDriverMarker(LatLng(animatedLat, animatedLng));
  }

  void _updateDriverMarker(final LatLng position) {
    setState(() {
      _markers.removeWhere((final m) => m.markerId == const MarkerId('driver'));
      _markers.add(
        Marker(
          markerId: const MarkerId('driver'),
          position: position,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: const InfoWindow(title: 'You (Driver)'),
          zIndex: 2,
        ),
      );
    });
  }

  @override
  void dispose() {
    _mapController?.dispose();
    _markerAnimTimer?.cancel();
    _markerAnimController?.dispose();
    super.dispose();
  }

  void _onMapCreated(final GoogleMapController controller) {
    _mapController = controller;
  }

  @override
  Widget build(final BuildContext context) {
    final locationAsync = ref.watch(currentLocationProvider);

    return locationAsync.when(
      data: (final position) {
        // Update driver marker position
        if (_currentDriverPosition != position) {
          _prevDriverPosition = _currentDriverPosition ?? position;
          _currentDriverPosition = position;
          _markerAnimController?.forward(from: 0);
        }

        WidgetsBinding.instance.addPostFrameCallback((final _) {
          _mapController?.animateCamera(
            CameraUpdate.newLatLng(position),
          );
        });

        return GoogleMap(
          initialCameraPosition: CameraPosition(
            target: position,
            zoom: AppConstants.defaultZoom,
          ),
          onMapCreated: _onMapCreated,
          markers: {..._markers},
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
