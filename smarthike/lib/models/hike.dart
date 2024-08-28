import 'dart:convert';
import 'package:logger/web.dart';
import 'package:smarthike/models/hike_file.dart';
import 'package:smarthike/models/base_hike.dart';

class Hike extends BaseHike {
  final String firstNodeLat;
  final String firstNodeLon;
  final String lastNodeLat;
  final String lastNodeLon;
  final String imageUrl;
  final double? distance;
  final String? positiveAltitude;
  final String? negativeAltitude;
  final int? difficulty;
  final int? hikingTime;

  Hike({
    required super.id,
    required super.osmId,
    required super.name,
    required this.firstNodeLat,
    required this.firstNodeLon,
    required this.lastNodeLat,
    required this.lastNodeLon,
    this.imageUrl = 'assets/images/hikeImageWaiting.jpg',
    this.distance = 0,
    this.positiveAltitude = "0",
    this.negativeAltitude = "0",
    this.difficulty = 0,
    this.hikingTime = 0,
    super.files = const [],
  }) : super();

  factory Hike.fromJson(Map<String, dynamic> json) {
    Logger logger = Logger();
    try {
      return Hike(
        id: json['id'] as int,
        osmId: json['osmId'] as int,
        name: json['name'] as String,
        firstNodeLat: json['firstNodeLat'] as String,
        firstNodeLon: json['firstNodeLon'] as String,
        lastNodeLat: json['lastNodeLat'] as String,
        lastNodeLon: json['lastNodeLon'] as String,
        distance: (json['distance'] as double?),
        positiveAltitude: (json['positiveAltitude'] as String?),
        negativeAltitude: (json['negativeAltitude'] as String?),
        difficulty: json['difficulty'] as int?,
        hikingTime: json['hikingTime'] as int?,
        files: (json['files'] as List<dynamic>?)
                ?.map((item) => HikeFile.fromJson(item))
                .toList() ??
            [],
        imageUrl:
            json['imageUrl'] as String? ?? 'assets/images/hikeImageWaiting.jpg',
      );
    } catch (e) {
      logger.e("Erreur lors de la création de la randonnée: $e");
      rethrow;
    }
  }

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'firstNodeLat': firstNodeLat,
        'firstNodeLon': firstNodeLon,
        'lastNodeLat': lastNodeLat,
        'lastNodeLon': lastNodeLon,
        'distance': distance,
        'positiveAltitude': positiveAltitude,
        'negativeAltitude': negativeAltitude,
        'difficulty': difficulty,
        'hikingTime': hikingTime,
        'imageUrl': imageUrl,
      };

  factory Hike.fromRawJson(String str) => Hike.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  static List<Hike> fromJsonList(String hikesJson) {
    return (json.decode(hikesJson) as List)
        .map((item) => Hike.fromJson(item))
        .toList();
  }

  static String toJsonList(List<Hike> response) {
    return json.encode(response.map((item) => item.toJson()).toList());
  }
}
