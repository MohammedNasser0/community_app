import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../widgets/member_marker.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static const cairo = LatLng(30.0444, 31.2357);
  late final Set<Marker> markers;
  @override
  void initState() {
    super.initState();
    markers = MemberMarker.buildMarkers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Community Map',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(target: cairo, zoom: 3.5),
        markers: markers,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        mapToolbarEnabled: false,
      ),
    );
  }
}
