import 'dart:convert';
import 'package:logger/web.dart';

class Hike {
  final String name;
  final double? distance;
  final double? elevationGain;
  final double? maxAlt;
  final double? minAlt;
  final int? difficulty;
  final int? hikingTime;
  final String imageUrl;

  Hike({
    required this.name,
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
        name: json['name'] as String? ?? '',
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

  factory Hike.fromFavJSON(Map<String, dynamic> json) {
    Logger logger = Logger();
    try {
      Hike hike = Hike(
        name: json['name'] as String,
      );
      return hike;
    } catch (e) {
      logger.e("Erreur lors de la création de la randonnée: $e");
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
        'name': name,
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
