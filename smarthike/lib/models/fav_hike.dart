import 'dart:convert';
import 'package:logger/web.dart';
import 'package:smarthike/models/base_hike.dart';
import 'package:smarthike/models/hike_file.dart';

class HikeFav extends BaseHike {
  HikeFav({
    required super.id,
    required super.osmId,
    required super.name,
    super.files = const [],
  });

  factory HikeFav.fromJson(Map<String, dynamic> json) {
    Logger logger = Logger();
    try {
      return HikeFav(
        id: json['id'] as int,
        osmId: json['osmId'] as int,
        name: json['name'] as String,
        files: (json['files'] as List<dynamic>?)
                ?.map((item) => HikeFile.fromJson(item))
                .toList() ??
            [],
      );
    } catch (e) {
      logger.e("Erreur lors de la création de la randonnée favorite: $e");
      rethrow;
    }
  }

  factory HikeFav.fromRawJson(String str) => HikeFav.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());
}
