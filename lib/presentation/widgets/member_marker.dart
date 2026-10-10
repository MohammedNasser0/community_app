import 'package:google_maps_flutter/google_maps_flutter.dart';

class MemberMarker {
  MemberMarker._();

  static Set<Marker> buildMarkers() => {
    const Marker(
      markerId: MarkerId('cairo'),
      position: LatLng(30.0444, 31.2357),
      infoWindow: InfoWindow(title: 'Mariam Hassan', snippet: 'Cairo, Egypt'),
    ),
    const Marker(
      markerId: MarkerId('riyadh'),
      position: LatLng(24.7136, 46.6753),
      infoWindow: InfoWindow(
        title: 'Omar Khalil',
        snippet: 'Riyadh, Saudi Arabia',
      ),
    ),
    const Marker(
      markerId: MarkerId('london'),
      position: LatLng(51.5074, -0.1278),
      infoWindow: InfoWindow(
        title: 'Bruno Pham',
        snippet: 'London, United Kingdom',
      ),
    ),
  };
}
