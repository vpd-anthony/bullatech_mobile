class AppConstants {
  static const String globalErrMsg =
      "Error has occured, need to restart the app.";
  static const String loginExpiredMsg =
      "Your login has expired. Please contact Bullatech Support.";
  static const int idleDuration = 180; // 180 = 3mins

  static const String locationsCollection = 'driver_locations';

  // Map defaults
  static const double defaultZoom = 16.0;
  static const double routeZoom = 12.0;

  // Google Maps
  static const String directionsBaseUrl =
      'https://maps.googleapis.com/maps/api/directions/json';

  // Animation durations
  static const Duration markerAnimationDuration = Duration(milliseconds: 1500);
  static const Duration pageTransitionDuration = Duration(milliseconds: 300);

  // Location update interval
  static const int locationUpdateIntervalMs = 3000;
}
