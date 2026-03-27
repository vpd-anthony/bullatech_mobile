import 'package:bullatech/common/constants/app_constants.dart';
import 'package:bullatech/core/theme/app_colors.dart';
import 'package:bullatech/features/ticket_list/presentation/widgets/idle_bottom_sheet_widget.dart';
import 'package:bullatech/features/ticket_list/presentation/widgets/top_bar.dart';
import 'package:bullatech/features/ticket_list/presentation/widgets/waiting_overlay_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWidget extends StatelessWidget {
  final LatLng? position;
  final bool hasRoute;
  final bool isLoading;
  final String? errorMsg;
  final GoogleMapController? mapController;
  final Set<Marker> markers;
  final Set<Polyline> polylines;
  final LatLng? currentDriverPosition;
  final Animation<double>? pulseAnim;
  final Animation<double>? ringAnim;
  final Animation<double>? idleSheetAnim;
  final void Function(GoogleMapController)? onMapCreated;

  const MapWidget({
    super.key,
    this.position,
    this.hasRoute = false,
    this.isLoading = false,
    this.errorMsg,
    this.mapController,
    this.markers = const {},
    this.polylines = const {},
    this.currentDriverPosition,
    this.pulseAnim,
    this.ringAnim,
    this.idleSheetAnim,
    this.onMapCreated,
  });

  @override
  Widget build(final BuildContext context) {
    if (isLoading) return _buildLoadingScaffold();
    if (errorMsg != null) return _buildErrorScaffold(errorMsg!);
    if (position == null) return _buildLoadingScaffold();

    return _buildMapWidget(position!, hasRoute);
  }

  Widget _buildMapWidget(final LatLng position, final bool hasRoute) {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: position,
            zoom: AppConstants.defaultZoom,
          ),
          onMapCreated: onMapCreated,
          markers: markers,
          polylines: polylines,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          mapType: MapType.hybrid,
          compassEnabled: false,
          zoomControlsEnabled: false,
        ),
        TopBar(hasRoute: hasRoute),
        if (!hasRoute && pulseAnim != null && ringAnim != null)
          WaitingOverlay(pulseAnim: pulseAnim!, ringAnim: ringAnim!),
        Positioned(
          right: 16,
          bottom: 280,
          child: _MapActions(
            onRecenter: () {
              if (currentDriverPosition != null && mapController != null) {
                mapController!.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: currentDriverPosition!,
                      zoom: AppConstants.defaultZoom,
                    ),
                  ),
                );
              }
            },
            mapController: mapController,
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: hasRoute
              ? const SizedBox.shrink()
              : IdleBottomSheet(animation: idleSheetAnim),
        ),
      ],
    );
  }

  Widget _buildLoadingScaffold() => const Scaffold(
        backgroundColor: AppColors.bgMaps,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: AppColors.info),
              ),
              SizedBox(height: 16),
              Text(
                'Acquiring location…',
                style: TextStyle(
                    color: AppColors.textSecondaryMaps,
                    fontSize: 13,
                    letterSpacing: 0.4),
              ),
            ],
          ),
        ),
      );

  Widget _buildErrorScaffold(final String msg) => Scaffold(
        backgroundColor: AppColors.bgMaps,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.location_off_rounded,
                    color: AppColors.textMuted, size: 40),
                const SizedBox(height: 16),
                Text(msg,
                    style: const TextStyle(
                        color: AppColors.textSecondaryMaps, fontSize: 13),
                    textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      );
}

class _MapActions extends StatelessWidget {
  final VoidCallback onRecenter;
  final GoogleMapController? mapController;

  const _MapActions({required this.onRecenter, this.mapController});

  @override
  Widget build(final BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _GlassIconButton(icon: Icons.my_location_rounded, onTap: onRecenter),
          const SizedBox(height: 8),
          _GlassIconButton(
            icon: Icons.zoom_in_rounded,
            onTap: () {
              if (mapController != null) {
                mapController!.animateCamera(CameraUpdate.zoomIn());
              }
            },
          ),
          const SizedBox(height: 8),
          _GlassIconButton(
            icon: Icons.zoom_out_rounded,
            onTap: () {
              if (mapController != null) {
                mapController!.animateCamera(CameraUpdate.zoomOut());
              }
            },
          ),
        ],
      );
}

class _GlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _GlassIconButton({required this.icon, required this.onTap});

  @override
  Widget build(final BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xCC0A0F1E),
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.borderMaps),
        ),
        child: Icon(icon, color: AppColors.textPrimaryMaps, size: 18),
      ),
    );
  }
}
