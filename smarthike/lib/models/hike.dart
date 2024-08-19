import 'dart:convert';
import 'package:logger/web.dart';

class Hike {
  final int id;
  final BigInt osmId;
  final String name;
  final String firstNodeLat;
  final String firstNodeLon;
  final String lastNodeLat;
  final String lastNodeLon;
  final String? distance;
  final String? positiveAltitude;
  final String? negativeAltitude;
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
    this.distance = "0",
    this.positiveAltitude = "0",
    this.negativeAltitude = "0",
    this.difficulty = 0,
    this.hikingTime = 0,
    this.imageUrl = "",
  });

  factory Hike.fromJson(Map<String, dynamic> json) {
    Logger logger = Logger();
    try {
      Hike hike = Hike(
        id: json['id'] as int,
        osmId: BigInt.parse(json['osmId'].toString()),
        name: json['name'] as String,
        firstNodeLat: json['firstNodeLat'] as String,
        firstNodeLon: json['firstNodeLon'] as String,
        lastNodeLat: json['lastNodeLat'] as String,
        lastNodeLon: json['lastNodeLon'] as String,
        distance: (json['distance'] as String?),
        positiveAltitude: (json['positiveAltitude'] as String?),
        negativeAltitude: (json['negativeAltitude'] as String?),
        difficulty: json['difficulty'] as int?,
        hikingTime: json['hikingTime'] as int?,
        imageUrl:
            json['imageUrl'] as String? ?? 'assets/images/hikeImageWaiting.jpg',
      );
      return hike;
    } catch (e) {
      logger.e("Erreur lors de la création de la randonnée: $e");
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'osmId': osmId,
        'name': name,
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
}
