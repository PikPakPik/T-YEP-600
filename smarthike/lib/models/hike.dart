import 'dart:convert';
import 'package:logger/web.dart';

class Hike {
  final int id;
  final int osmId;
  final String name;
  final String firstNodeLat;
  final String firstNodeLon;
  final String lastNodeLat;
  final String lastNodeLon;
  final double? distance;
  final double? elevationGain;
  final double? maxAlt;
  final double? minAlt;
  final int? difficulty;
  final int? hikingTime;
  final String imageUrl;

  Hike({
    required this.id,
    required this.osmId,
    required this.name,
    required this.firstNodeLat,
    required this.firstNodeLon,
    required this.lastNodeLat,
    required this.lastNodeLon,
    this.distance = 0,
    this.elevationGain = 0,
    this.maxAlt = 0,
    this.minAlt = 0,
    this.difficulty = 0,
    this.hikingTime = 0,
    this.imageUrl = "",
  });

  factory Hike.fromJson(Map<String, dynamic> json) {
    Logger logger = Logger();
    try {
      Hike hike = Hike(
        id: json['id'] as int,
        osmId: json['osmId'] as int,
        name: json['name'] as String,
        firstNodeLat: json['firstNodeLat'] as String,
        firstNodeLon: json['firstNodeLon'] as String,
        lastNodeLat: json['lastNodeLat'] as String,
        lastNodeLon: json['lastNodeLon'] as String,
        distance: (json['distance'] as num?)?.toDouble(),
        elevationGain: (json['elevationGain'] as num?)?.toDouble(),
        maxAlt: (json['maxAlt'] as num?)?.toDouble(),
        minAlt: (json['minAlt'] as num?)?.toDouble(),
        difficulty: json['difficulty'] as int?,
        hikingTime: json['hikingTime'] as int?,
        imageUrl: json['imageUrl'] as String? ?? 'assets/images/hikeImageWaiting.jpg',
      );
      return hike;
    } catch (e) {
      logger.e("Erreur lors de la création de la randonnée: $e");
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
        'id' : id,
        'osmId': osmId,
        'name': name,
        'firstNodeLat': firstNodeLat,
        'firstNodeLon': firstNodeLon,
        'lastNodeLat': lastNodeLat,
        'lastNodeLon': lastNodeLon,
        'distance': distance,
        'elevationGain': elevationGain,
        'maxAlt': maxAlt,
        'minAlt': minAlt,
        'difficulty': difficulty,
        'hikingTime': hikingTime,
        'imageUrl': imageUrl,
      };

  factory Hike.fromRawJson(String str) => Hike.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());
}
