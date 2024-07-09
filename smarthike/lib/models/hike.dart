import 'dart:convert';

import 'package:logger/web.dart';

class Hike {
  final String name;
  final double distance;
  final int heightDiff;
  final double maxAlt;
  final double minAlt;
  final int difficulty;
  final int hikingTime;
  final String imageUrl;

  Hike(
      {required this.name,
      this.distance = 0,
      this.heightDiff = 0,
      this.maxAlt = 0,
      this.minAlt = 0,
      this.difficulty = 0,
      this.hikingTime = 0,
      this.imageUrl = ""});

  factory Hike.fromJson(Map<String, dynamic> json) {
    Logger logger = Logger();
    try {
      Hike hike = Hike(
        name: json['name'] as String,
        distance: json['distance'] as double,
        heightDiff: json['heightDiff'] as int,
        maxAlt: json['maxAlt'] as double,
        minAlt: json['minAlt'] as double,
        difficulty: json['difficulty'] as int,
        hikingTime: json['hikingTime'] as int,
        imageUrl: json['imageUrl'] as String,
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
        'heightDiff': heightDiff,
        'maxAlt': maxAlt,
        'minAlt': minAlt,
        'difficulty': difficulty,
        'hikingTime': hikingTime,
        'imageUrl': imageUrl,
      };

  factory Hike.fromRawJson(String str) => Hike.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());
}
