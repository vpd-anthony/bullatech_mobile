import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DirectionsService {
  static final String _apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';

  static Future<List<LatLng>> getRoute({
    required final LatLng origin,
    required final LatLng destination,
    final List<LatLng>? waypoints,
  }) async {
    if (_apiKey.isEmpty) {
      throw Exception('Google Maps API key is not set in .env');
    }

    /// ✅ Optimize waypoint order (better routing)
    final waypointsParam = (waypoints != null && waypoints.isNotEmpty)
        ? '&waypoints=optimize:true|${waypoints.map((final w) => '${w.latitude},${w.longitude}').join('|')}'
        : '';

    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/directions/json'
      '?origin=${origin.latitude},${origin.longitude}'
      '&destination=${destination.latitude},${destination.longitude}'
      '$waypointsParam'
      '&mode=driving'
      '&alternatives=false'
      '&key=$_apiKey',
    );

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch directions: ${response.statusCode}');
    }

    final data = jsonDecode(response.body);

    if (data['routes'] == null || data['routes'].isEmpty) {
      return [];
    }

    /// 🔥 HIGH PRECISION: Use STEP polylines instead of overview
    final legs = data['routes'][0]['legs'] as List;

    final routePoints = <LatLng>[];

    for (final leg in legs) {
      final steps = leg['steps'] as List;

      for (final step in steps) {
        final encoded = step['polyline']['points'];
        routePoints.addAll(_decodePolyline(encoded));
      }
    }

    return routePoints;
  }

  /// ✅ High-precision polyline decoder
  static List<LatLng> _decodePolyline(final String encoded) {
    final poly = <LatLng>[];

    var index = 0;
    var lat = 0;
    var lng = 0;

    while (index < encoded.length) {
      var shift = 0;
      var result = 0;

      int b;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);

      final dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;

      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);

      final dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      poly.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return poly;
  }
}
