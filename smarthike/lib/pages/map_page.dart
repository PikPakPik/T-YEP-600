import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_map_marker_cluster_2/flutter_map_marker_cluster.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart'; 
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:smarthike/components/button.dart';
import 'package:smarthike/main.dart';
import 'package:smarthike/services/hike_service.dart';
import 'package:smarthike/models/hike_api.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  MapPageState createState() => MapPageState();
}

class MapPageState extends State<MapPage> with SingleTickerProviderStateMixin {
  late final MapController mapController;
  late HikeService hikeService;
  late Completer<MapController> controllerCompleter = Completer();
  late List<Marker> markers = [];
  late final tileProvider = const FMTCStore('mapStore').getTileProvider();
  bool _isFollowing = true;
  Stream<LocationMarkerPosition>? _positionStream;
  Dio dio = Dio();
  List<dynamic> points = [];
  List<Polyline> polylines = [];
  bool showPolylines = false;
  List<HikeApi> hikes = [];

  List<Polyline> selectedPolylines = [];
  // ignore: unused_field
  bool _shouldZoom = false;

  bool _isLoading = true;
  bool _showCompletionMessage = false;

  void _onMapCreated(MapController controller) async {
    controllerCompleter.complete(controller);
  }

  @override
  void initState() {
    mapController = MapController();
    hikeService = Provider.of<HikeService>(context, listen: false);
    _initializeAsync();

    super.initState();
    _positionStream?.listen((position) {
      if (_isFollowing) {
        mapController.move(LatLng(position.latitude, position.longitude),
            mapController.camera.zoom);
        _shouldZoom = false;
      }
    });
  }

  Future<void> _initializeAsync() async {
    await _initLocationService();
    await getHikes();
    setState(() {
      _isLoading = false;
      _showCompletionMessage = true;
    });
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _showCompletionMessage = false;
    });
  }

  Future<void> _initLocationService() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      // Handle permission denied
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

  Future<void> getHikes() async {
    try {
      final response = await hikeService.getAllHikes();

      setState(() {
        hikes = response;

        markers = hikes.map((hike) {
          return Marker(
            point: LatLng(double.parse(hike.firstNodeLat),
                double.parse(hike.firstNodeLon)),
            child: const Icon(
              Icons.location_on,
              color: Colors.red,
              size: 40.0,
            ),
          );
        }).toList();
      });
      // ignore: empty_catches
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              onMapReady: () => _onMapCreated(mapController),
              initialCenter: const LatLng(48.83333, 2.33333),
              interactionOptions: _isLoading
                  ? const InteractionOptions(flags: InteractiveFlag.none)
                  : const InteractionOptions(flags: InteractiveFlag.all),
              initialZoom: 15.0,
              maxZoom: 20,
              onPositionChanged: (position, hasGesture) {
                if (hasGesture && _isFollowing) {
                  setState(() {
                    _isFollowing = false;
                  });
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                tileProvider: tileProvider,
              ),
              MarkerClusterLayerWidget(
                options: MarkerClusterLayerOptions(
                  maxClusterRadius: 45,
                  size: const Size(40, 40),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(50),
                  maxZoom: 15,
                  markers: markers,
                  builder: (context, markers) {
                    return Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.blue),
                      child: Center(
                        child: Text(
                          markers.length.toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (_positionStream != null)
                CurrentLocationLayer(
                  alignPositionOnUpdate:
                      _isFollowing ? AlignOnUpdate.always : AlignOnUpdate.never,
                  alignDirectionOnUpdate:
                      _isFollowing ? AlignOnUpdate.always : AlignOnUpdate.never,
                  positionStream: _positionStream!,
                  style: const LocationMarkerStyle(
                    marker: DefaultLocationMarker(
                      color: Colors.green,
                      child: Icon(
                        Icons.hiking_rounded,
                        color: Colors.white,
                      ),
                    ),
                    markerSize: Size.square(40),
                  ),
                ),
              if (selectedPolylines.isNotEmpty)
                PolylineLayer(
                  polylines: selectedPolylines,
                ),
            ],
          ),
          if (_isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                        strokeWidth: 8.0,
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Chargement des randonnées...",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          if (!_isLoading && _showCompletionMessage)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 100,
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Toutes les randonnées chargées !",
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          if (!_isLoading)
            Positioned(
              bottom: 20,
              right: 20,
              width: 100,
              child: CustomButton(
                text: "Voir tout",
                backgroundColor: Colors.blue,
                onPressed: () {
                  setState(() {
                    SmartHikeApp.navBarKey.currentState
                        ?.navigateToSpecificPage(9);
                  });
                },
              ),
            ),
          if (!_isFollowing)
            Positioned(
              bottom: 100,
              right: 20,
              child: FloatingActionButton(
                onPressed: () {
                  setState(() {
                    _isFollowing = true;
                    _shouldZoom = true;
                    mapController.move(
                      LatLng(mapController.camera.center.latitude,
                          mapController.camera.center.longitude),
                      20.0,
                    );
                  });
                },
                child: const Icon(Icons.my_location),
              ),
            ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
