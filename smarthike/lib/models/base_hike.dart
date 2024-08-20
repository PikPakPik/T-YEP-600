import 'package:logger/web.dart';
import 'package:smarthike/models/hike_file.dart';

class BaseHike {
  final int id;
  final int osmId;
  final String name;
  final List<HikeFile> files;

  BaseHike({
    required this.id,
    required this.osmId,
    required this.name,
    this.files = const [],
  });

  factory BaseHike.fromJson(Map<String, dynamic> json) {
    Logger logger = Logger();
    try {
      return BaseHike(
        id: json['id'] as int,
        osmId: json['osmId'] as int,
        name: json['name'] as String,
        files: (json['files'] as List<dynamic>?)
                ?.map((item) => HikeFile.fromJson(item))
                .toList() ??
            [],
      );
    } catch (e) {
      logger.e("Erreur lors de la création de la randonnée: $e");
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'osmId': osmId,
        'name': name,
        'files': files.map((image) => image.toJson()).toList(),
      };
}
