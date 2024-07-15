import 'dart:convert';

import 'package:logger/web.dart';

class HikeApi {
  final int id;
  final int osmId;
  final String name;
  final String firstNodeLat;
  final String firstNodeLon;
  final String lastNodeLat;
  final String lastNodeLon;

  HikeApi({
    required this.id,
    required this.osmId,
    required this.name,
    required this.firstNodeLat,
    required this.firstNodeLon,
    required this.lastNodeLat,
    required this.lastNodeLon,
  });

  factory HikeApi.fromJson(Map<String, dynamic> json) {
    Logger logger = Logger();
    try {
      HikeApi hike = HikeApi(
        id: json['id'] as int,
        osmId: json['osmId'] as int,
        name: json['name'] as String,
        firstNodeLat: json['firstNodeLat'] as String,
        firstNodeLon: json['firstNodeLon'] as String,
        lastNodeLat: json['lastNodeLat'] as String,
        lastNodeLon: json['lastNodeLon'] as String,
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
      };

  factory HikeApi.fromRawJson(String str) => HikeApi.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());
}
