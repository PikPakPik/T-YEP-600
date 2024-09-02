import 'dart:async';
import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_compass/flutter_map_compass.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_map_marker_cluster_2/flutter_map_marker_cluster.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:smarthike/components/button.dart';
import 'package:smarthike/components/hike/horizontal_card.dart';
import 'package:smarthike/constants.dart';
import 'package:smarthike/core/init/gen/translations.g.dart';
import 'package:smarthike/main.dart';
import 'package:smarthike/models/hike.dart';
import 'package:smarthike/services/hike_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  late List<Marker> startAndEndMarkers = [];
  late final tileProvider = const FMTCStore('mapStore').getTileProvider();
  bool _isFollowing = true;
  Stream<LocationMarkerPosition>? _positionStream;
  Position? currentLocation;
  List<dynamic> points = [];
  List<Hike> hikes = [];
  double _dragScrollSheetExtent = 0;

  double _widgetHeight = 0;
  double _fabPosition = 0;
  final double _fabPositionPadding = 10;

  List<Polyline> selectedPolylines = [];

  bool _isLoading = true;
  bool _showCompletionMessage = false;

  final PageController _pageController = PageController(viewportFraction: 1);

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    hikeService = Provider.of<HikeService>(context, listen: false);
    _initializeAsync();
    _setupPageController();

    _animationController = AnimationController(
      duration: Duration(seconds: 10),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
  }

  @override
  void dispose() {
    _pageController.removeListener(_onPageViewScroll);
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _initializeAsync() async {
    await _initLocationService();
    await _loadHikesFromStorage();
    _updateLoadingState(false, showCompletion: true);
  }

  Future<void> _loadHikesFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final String? hikesJson = prefs.getString('hikes');

    if (hikesJson != null) {
      _updateHikes(Hike.fromJsonList(hikesJson));
    }
  }

  Future<void> _initLocationService() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return;
    }
    _positionStream = Geolocator.getPositionStream().map(_mapPosition);
  }

  Future<void> _loadHikes() async {
    try {
      final response = await hikeService.getAllHikes();
      _updateHikes(response);
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('hikes', Hike.toJsonList(response));
    } catch (e) {
      throw Exception('Erreur lors du chargement des randonnées : $e');
    }
  }

  void _updateHikes(List<Hike> hikes) {
    setState(() {
      this.hikes = hikes;
      markers = _createMarkersFromHikes(hikes);
    });
  }

  void _updateLoadingState(bool isLoading, {bool showCompletion = false}) {
    setState(() {
      _isLoading = isLoading;
      _showCompletionMessage = showCompletion;
    });
    if (showCompletion) {
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _showCompletionMessage = false;
        });
      });
    }
  }

  void _setupPageController() {
    _pageController.addListener(_onPageViewScroll);
  }

  void _onPageViewScroll() {
    int currentPage = _pageController.page!.round();
    if (currentPage >= 0 && currentPage < hikes.length) {
      _moveToHike(hikes[currentPage]);
    }
  }

  void _moveToHike(Hike hike) {
    LatLng newPosition = LatLng(
      double.parse(hike.firstNodeLat),
      double.parse(hike.firstNodeLon),
    );
    setState(() {
      _isFollowing = false;
    });
    mapController.move(newPosition, mapController.camera.zoom);
  }

  LocationMarkerPosition _mapPosition(Position position) {
    return LocationMarkerPosition(
      latitude: position.latitude,
      longitude: position.longitude,
      accuracy: position.accuracy,
    );
  }

  List<Marker> _createMarkersFromHikes(List<Hike> hikes) {
    return hikes
        .asMap()
        .map((index, hike) {
          return MapEntry(
              index,
              Marker(
                point: LatLng(double.parse(hike.firstNodeLat),
                    double.parse(hike.firstNodeLon)),
                child: GestureDetector(
                  onTap: () {
                    _pageController.jumpToPage(index);
                    _fetchHikeGeometry(hike.id);
                  },
                  child: const Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 40.0,
                  ),
                ),
              ));
        })
        .values
        .toList();
  }

  Future<void> _fetchHikeGeometry(int hikeId) async {
    final response = await hikeService.getHikeGeometry(hikeId);
    setState(() {
      startAndEndMarkers.clear();
      selectedPolylines.clear();

      const int minDuration = 5;
      const int maxDuration = 60;
      int duration = response.length.clamp(minDuration, maxDuration);
      _animationController.duration = Duration(seconds: duration);
      _animationController.reset(); // Réinitialiser l'animation
      _animationController.forward(); // Démarrer l'animation

      _animationController.repeat(); // Répéter l'animation
      for (var i = 0; i < response.length; i++) {
        var way = response[i];
        selectedPolylines.add(
          Polyline(
              points: way.points,
              strokeWidth: 5.0,
              borderColor: Colors.black,
              borderStrokeWidth: 2.0,
              color: Colors.deepOrange),
        );
      }
      if (response.isNotEmpty) {
        _addStartAndEndMarkers(
            response.first.points.first, response.last.points.last);
      }
    });
  }

  void _addStartAndEndMarkers(LatLng start, LatLng end) {
    setState(() {
      startAndEndMarkers.add(
        Marker(
          width: 30,
          height: 30,
          point: start,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
          ),
        ),
      );
      startAndEndMarkers.add(
        Marker(
          point: end,
          width: 20,
          height: 20,
          child: Container(
            width: 40,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              image: const DecorationImage(
                image: AssetImage('assets/images/checkerboard_pattern.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildMap(),
          _buildLoadingOverlay(),
          _buildCompletionMessage(),
          _buildUIControls(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildMap() {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        onMapReady: () => _onMapCreated(mapController),
        initialCenter: const LatLng(48.83333, 2.33333),
        interactionOptions: _isLoading
            ? const InteractionOptions(flags: InteractiveFlag.none)
            : const InteractionOptions(flags: InteractiveFlag.all),
        initialZoom: 15.0,
        maxZoom: 20,
        onPositionChanged: _handlePositionChange,
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
            builder: _buildClusterMarker,
            polygonOptions: const PolygonOptions(
                color: Colors.transparent,
                borderColor: Colors.red,
                borderStrokeWidth: 2,
                pattern: StrokePattern.dotted()),
          ),
        ),
        if (_positionStream != null)
          CurrentLocationLayer(
            focalPoint: const FocalPoint(
              ratio: Point(0.0, 1.0),
              offset: Point(0.0, -60.0),
            ),
            alignPositionOnUpdate:
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
        _buildAnimatedPolyline(),
        if (startAndEndMarkers.isNotEmpty)
          MarkerLayer(
            markers: startAndEndMarkers,
          ),
        const Positioned(
          left: 0,
          top: 30,
          child: MapCompass.cupertino(
            hideIfRotatedNorth: true,
          ),
        ),
      ],
    );
  }

  Widget _buildClusterMarker(BuildContext context, List<Marker> markers) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.blue),
      child: Center(
        child: Text(
          markers.length.toString(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    if (!_isLoading) return SizedBox.shrink();
    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            strokeWidth: 8.0,
          ),
        ),
      ),
    );
  }

  Widget _buildCompletionMessage() {
    if (!_showCompletionMessage) return SizedBox.shrink();
    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: const Center(
          child: Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 100,
          ),
        ),
      ),
    );
  }

  Widget _buildUIControls() {
    return Stack(
      children: [
        if (!_isLoading && !_showCompletionMessage)
          Positioned(
            top: 50,
            left: MediaQuery.of(context).size.width / 2 - 100,
            right: MediaQuery.of(context).size.width / 2 - 100,
            child: CustomButton(
              text: LocaleKeys.hike_reload_hikes.tr(),
              backgroundColor: Colors.red,
              textColor: Colors.white,
              radius: 40,
              onPressed: _reloadHikes,
            ),
          ),
        if (!_isLoading && !_showCompletionMessage)
          NotificationListener<DraggableScrollableNotification>(
            onNotification: _handleDraggableScrollNotification,
            child: DraggableScrollableSheet(
              initialChildSize: 0.1,
              maxChildSize: 0.3,
              minChildSize: 0.1,
              builder: _buildScrollableSheet,
            ),
          ),
        if (!_isLoading && !_showCompletionMessage)
          Positioned(
            bottom: _fabPosition == 0 ? 70 : _fabPosition,
            right: _fabPositionPadding,
            width: 100,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!_isFollowing)
                  FloatingActionButton(
                    onPressed: _followUserLocation,
                    child: const Icon(Icons.my_location),
                  ),
                CustomButton(
                  text: LocaleKeys.hike_see_hikes.tr(),
                  backgroundColor: Constants.primaryColor,
                  textColor: Colors.black,
                  radius: 5,
                  onPressed: () {
                    SmartHikeApp.navBarKey.currentState?.navigateToPage(9);
                  },
                ),
              ],
            ),
          ),
      ],
    );
  }

  void _reloadHikes() async {
    setState(() {
      _isLoading = true;
    });
    await _loadHikes();
    setState(() {
      _isLoading = false;
    });
  }

  bool _handleDraggableScrollNotification(
      DraggableScrollableNotification notification) {
    setState(() {
      _widgetHeight = context.size!.height;
      _dragScrollSheetExtent = notification.extent;
      _fabPosition = _dragScrollSheetExtent * _widgetHeight;
    });
    return true;
  }

  Widget _buildScrollableSheet(
      BuildContext context, ScrollController scrollController) {
    return SingleChildScrollView(
      controller: scrollController,
      child: SizedBox(
        height: 200,
        child: PageView.builder(
          itemCount: hikes.length,
          controller: _pageController,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: HorizontalCard(hike: hikes[index]),
            );
          },
        ),
      ),
    );
  }

  void _followUserLocation() {
    setState(() {
      _isFollowing = true;
    });
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((pickedCurrentLocation) {
      setState(() {
        currentLocation = pickedCurrentLocation;
      });
      mapController.move(
          LatLng(currentLocation!.latitude, currentLocation!.longitude), 20);
    });
  }

  void _handlePositionChange(MapCamera position, bool hasGesture) {
    if (hasGesture && _isFollowing) {
      setState(() {
        _isFollowing = false;
      });
    }
  }

  void _onMapCreated(MapController controller) {
    controllerCompleter.complete(controller);
  }

  List<LatLng> _getOrderedPoints(List<Polyline> polylines) {
    List<LatLng> orderedPoints = [];

    for (var polyline in polylines) {
      if (orderedPoints.isEmpty) {
        orderedPoints.addAll(polyline.points);
      } else {
        LatLng lastPoint = orderedPoints.last;
        LatLng firstPoint = polyline.points.first;

        if (lastPoint.latitude == firstPoint.latitude &&
            lastPoint.longitude == firstPoint.longitude) {
          orderedPoints.addAll(polyline.points.sublist(1));
        } else {
          orderedPoints.addAll(polyline.points.reversed.toList());
        }
      }
    }

    return orderedPoints;
  }

  Widget _buildAnimatedPolyline() {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        if (selectedPolylines.isEmpty) return SizedBox.shrink();

        List<LatLng> allPoints = _getOrderedPoints(selectedPolylines);

        double totalDistance = 0;
        for (int i = 0; i < allPoints.length - 1; i++) {
          totalDistance += _calculateDistance(allPoints[i], allPoints[i + 1]);
        }

        double progress = min(_animation.value * totalDistance, totalDistance);
        LatLng animatedPosition =
            _getPositionAlongPolyline(allPoints, progress);
        return MarkerLayer(
          markers: [
            Marker(
              point: animatedPosition,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.8),
                  border: Border.all(color: Colors.red, width: 10),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  double _calculateDistance(LatLng start, LatLng end) {
    const double earthRadius = 6371000;
    double dLat = _degreesToRadians(end.latitude - start.latitude);
    double dLon = _degreesToRadians(end.longitude - start.longitude);
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(start.latitude)) *
            cos(_degreesToRadians(end.latitude)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }

  LatLng _getPositionAlongPolyline(List<LatLng> points, double distance) {
    double traveled = 0;

    for (int i = 0; i < points.length - 1; i++) {
      double segmentDistance = _calculateDistance(points[i], points[i + 1]);
      if (traveled + segmentDistance >= distance) {
        double remainingDistance = distance - traveled;
        double ratio = remainingDistance / segmentDistance;

        return LatLng(
          points[i].latitude +
              (points[i + 1].latitude - points[i].latitude) * ratio,
          points[i].longitude +
              (points[i + 1].longitude - points[i].longitude) * ratio,
        );
      }
      traveled += segmentDistance;
    }

    return points.last;
  }
}
