import 'dart:convert';
import 'package:logger/web.dart';

class HikeFile {
  final int id;
  final String link;

  HikeFile({
    required this.id,
    required this.link,
  });

  factory HikeFile.fromJson(Map<String, dynamic> json) {
    Logger logger = Logger();
    try {
      HikeFile hike = HikeFile(
        id: json['id'] as int,
        link: json['link'] as String,
      );
      return hike;
    } catch (e) {
      logger.e("Erreur lors de la création de la randonnée favorite: $e");
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
        'id' : id,
        'link': link,
      };

  factory HikeFile.fromRawJson(String str) => HikeFile.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());
}
