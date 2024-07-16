import 'dart:convert';
import 'package:logger/web.dart';

class HikeFav {
  final int id;
  final int osmId;
  final String name;

  HikeFav({
    required this.id,
    required this.osmId,
    required this.name,
  });

  factory HikeFav.fromJson(Map<String, dynamic> json) {
    Logger logger = Logger();
    try {
      HikeFav hike = HikeFav(
        id: json['id'] as int,
        osmId: json['osmId'] as int,
        name: json['name'] as String,
      );
      return hike;
    } catch (e) {
      logger.e("Erreur lors de la création de la randonnée favorite: $e");
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
        'id' : id,
        'osmId': osmId,
        'name': name,
      };

  factory HikeFav.fromRawJson(String str) => HikeFav.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());
}
