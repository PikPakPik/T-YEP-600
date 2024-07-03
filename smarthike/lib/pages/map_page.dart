import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late final MapController mapController;
  Stream<LocationMarkerPosition>? _positionStream;

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    _initLocationService();
  }

  Future<void> _initLocationService() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      // Gestion de l'autorisation refusée
      return;
    }

    _positionStream =
        Geolocator.getPositionStream().map((position) => LocationMarkerPosition(
              latitude: position.latitude,
              longitude: position.longitude,
              accuracy: position.accuracy,
            ));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        mapController: mapController,
        options: const MapOptions(
          initialCenter: LatLng(47.21, -1.55),
          initialZoom: 13.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          if (_positionStream != null)
            CurrentLocationLayer(
              alignPositionOnUpdate: AlignOnUpdate.always,
              alignDirectionOnUpdate: AlignOnUpdate.never,
              positionStream: _positionStream!,
              style: const LocationMarkerStyle(
                marker: DefaultLocationMarker(
                  child: Icon(
                    Icons.navigation,
                    color: Colors.white,
                  ),
                ),
                markerSize: Size(40, 40),
                markerDirection: MarkerDirection.heading,
              ),
            ),
        ],
      ),
    );
  }
}
