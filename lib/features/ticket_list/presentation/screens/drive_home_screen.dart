import 'dart:async';
import 'package:bullatech/common/constants/app_constants.dart';
import 'package:bullatech/core/providers/google/route_provider.dart';
import 'package:bullatech/core/services/google/directions_service.dart';
import 'package:bullatech/core/theme/app_colors.dart';
import 'package:bullatech/features/ticket_list/presentation/providers/location_provider.dart';
import 'package:bullatech/features/ticket_list/presentation/widgets/map_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DriverHomeScreen extends ConsumerStatefulWidget {
  static final GlobalKey<DriverHomeScreenState> driverHomeKey =
      GlobalKey<DriverHomeScreenState>();

  DriverHomeScreen() : super(key: driverHomeKey);

  @override
  ConsumerState<DriverHomeScreen> createState() => DriverHomeScreenState();
}

class DriverHomeScreenState extends ConsumerState<DriverHomeScreen>
    with TickerProviderStateMixin {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  LatLng? _prevDriverPosition;
  LatLng? _currentDriverPosition;
  AnimationController? _markerAnimController;
  Animation<double>? _markerAnim;
  (LatLng, LatLng)? _lastRoute;

  List<LatLng> _fullRoutePoints = [];

  late AnimationController _polylineAnimController;
  late Animation<double> _polylineAnim;

  late AnimationController _pulseController;
  late AnimationController _ringController;
  late AnimationController _idleSheetController;
  late Animation<double> _pulseAnim;
  late Animation<double> _ringAnim;
  late Animation<double> _idleSheetAnim;

  LatLng? get currentDriverPosition => _currentDriverPosition;

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

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _ringController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();
    _ringAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _ringController, curve: Curves.easeOut),
    );

    _idleSheetController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _idleSheetAnim = CurvedAnimation(
      parent: _idleSheetController,
      curve: Curves.easeOutCubic,
    );
    _idleSheetController.forward();

    _polylineAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _polylineAnim = CurvedAnimation(
      parent: _polylineAnimController,
      curve: Curves.easeInOut,
    )..addListener(_animatePolyline);
  }

  @override
  void dispose() {
    _mapController?.dispose();
    _markerAnimController?.dispose();
    _pulseController.dispose();
    _ringController.dispose();
    _idleSheetController.dispose();
    _polylineAnimController.dispose();
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
    final pos = LatLng(lat, lng);
    _updateDriverMarker(pos);
    _mapController?.animateCamera(CameraUpdate.newLatLng(pos));
  }

  void _updateDriverMarker(final LatLng position) {
    if (!mounted) return;
    setState(() {
      if (_polylines.isEmpty) {
        _markers.removeWhere((final m) => m.markerId.value == 'driver');
        _markers.add(Marker(
          markerId: const MarkerId('driver'),
          position: position,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: const InfoWindow(title: 'You'),
          zIndex: 2,
        ));
      }
    });
  }

  void _animatePolyline() {
    if (_fullRoutePoints.isEmpty) return;

    final count = (_fullRoutePoints.length * _polylineAnim.value).toInt();

    final visiblePoints = _fullRoutePoints.take(count).toList();

    setState(() {
      _polylines
        ..clear()
        ..add(Polyline(
          polylineId: const PolylineId('route'),
          color: AppColors.info,
          width: 5,
          points: visiblePoints,
        ));
    });
  }

  Future<void> _drawRoute(
    final LatLng origin,
    final LatLng departure,
    final LatLng arrival,
  ) async {
    if (_mapController == null) return;

    try {
      final points = await DirectionsService.getRoute(
        origin: origin,
        destination: arrival,
        waypoints: [departure],
      );

      if (points.isEmpty || !mounted) return;

      /// 🔥 Smooth + dense route
      _fullRoutePoints = _interpolate(points, 5);

      /// 🔥 Animate polyline instead of instant draw
      _polylineAnimController.forward(from: 0);

      setState(() {
        /// ❌ DO NOT remove driver marker (prevents flicker)
        _markers.removeWhere((final m) =>
            m.markerId.value == 'departure' || m.markerId.value == 'arrival');

        _markers.addAll([
          Marker(
            markerId: const MarkerId('departure'),
            position: departure,
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
            infoWindow: const InfoWindow(title: 'Departure'),
          ),
          Marker(
            markerId: const MarkerId('arrival'),
            position: arrival,
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen),
            infoWindow: const InfoWindow(title: 'Arrival'),
          ),
        ]);
      });

      /// 📍 Fit camera AFTER route loads
      _fitBounds(points);
    } catch (e) {
      debugPrint('[Route] Error: $e');
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
    final latP = (maxLat - minLat) * 0.12;
    final lngP = (maxLng - minLng) * 0.12;
    _mapController!.animateCamera(CameraUpdate.newLatLngBounds(
      LatLngBounds(
        southwest: LatLng(minLat - latP, minLng - lngP),
        northeast: LatLng(maxLat + latP, maxLng + lngP),
      ),
      60,
    ));
  }

  void _clearRoute() {
    if (!mounted) return;

    /// 🔥 Stop animation safely
    _polylineAnimController.stop();

    setState(() {
      _polylines.clear();
      _fullRoutePoints.clear();

      /// Remove only route markers
      _markers.removeWhere((final m) =>
          m.markerId.value == 'departure' || m.markerId.value == 'arrival');
    });

    /// 🎯 Keep camera centered on driver
    if (_mapController != null && _currentDriverPosition != null) {
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: _currentDriverPosition!,
            zoom: AppConstants.defaultZoom,
          ),
        ),
      );
    }
  }

  /// External method to trigger route drawing
  void drawRouteExternally(
      final LatLng origin, final LatLng departure, final LatLng arrival) {
    _drawRoute(origin, departure, arrival);
  }

  List<LatLng> _interpolate(final List<LatLng> points, final int factor) {
    final result = <LatLng>[];

    for (var i = 0; i < points.length - 1; i++) {
      final start = points[i];
      final end = points[i + 1];

      for (var j = 0; j < factor; j++) {
        final t = j / factor;

        result.add(LatLng(
          start.latitude + (end.latitude - start.latitude) * t,
          start.longitude + (end.longitude - start.longitude) * t,
        ));
      }
    }

    result.add(points.last);
    return result;
  }

  @override
  Widget build(final BuildContext context) {
    final locationAsync = ref.watch(currentLocationProvider);
    final route = ref.watch(activeRouteProvider);

    return locationAsync.when(
      data: (final position) {
        if (_currentDriverPosition != position) {
          _prevDriverPosition = _currentDriverPosition ?? position;
          _currentDriverPosition = position;

          _markerAnimController?.forward(from: 0);

          /// 🚨 Remove outdated route when driver moves
          if (_polylines.isNotEmpty) {
            _clearRoute();

            if (route != null) {
              WidgetsBinding.instance.addPostFrameCallback((final _) {
                _drawRoute(_currentDriverPosition!, route.$1, route.$2);
              });
            }
          }
        }

        if (_currentDriverPosition != null && route != null) {
          if (_lastRoute == null ||
              _lastRoute!.$1 != route.$1 ||
              _lastRoute!.$2 != route.$2) {
            _lastRoute = route;
            WidgetsBinding.instance.addPostFrameCallback((final _) {
              _drawRoute(_currentDriverPosition!, route.$1, route.$2);
            });
          }
        }

        if (route == null && _polylines.isNotEmpty) {
          WidgetsBinding.instance
              .addPostFrameCallback((final _) => _clearRoute());
        }

        return MapWidget(
          position: position,
          hasRoute: _polylines.isNotEmpty,
          mapController: _mapController,
          markers: _markers,
          polylines: _polylines,
          currentDriverPosition: _currentDriverPosition,
          pulseAnim: _pulseAnim,
          ringAnim: _ringAnim,
          idleSheetAnim: _idleSheetAnim,
          onMapCreated: _onMapCreated,
        );
      },
      loading: () => const MapWidget(isLoading: true),
      error: (final err, final _) => MapWidget(errorMsg: err.toString()),
    );
  }
}
