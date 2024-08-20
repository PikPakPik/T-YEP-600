import 'package:logger/web.dart';
import 'package:smarthike/models/hike.dart';

class PaginatedHike {
  final List<Hike> items;
  final int? previousPage;
  final int? nextPage;
  final int totalPages;
  final int totalItems;
  final int currentPage;

  PaginatedHike({
    required this.items,
    this.nextPage,
    this.previousPage,
    required this.totalItems,
    required this.totalPages,
    required this.currentPage,
  });

  factory PaginatedHike.fromJson(Map<String, dynamic> json) {
    Logger logger = Logger();
    try {
      return PaginatedHike(
        items: List<Hike>.from(json['items'].map((x) => Hike.fromJson(x))),
        nextPage: json['nextPage'] as int?,
        previousPage: json['previousPage'] as int?,
        totalItems: json['totalItems'] as int,
        totalPages: json['totalPages'] as int,
        currentPage: json['currentPage'] as int,
      );
    } catch (e) {
      logger.e("Erreur lors de la création de la liste de la randonnée: $e");
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
        'items': List<dynamic>.from(items.map((x) => x.toJson())),
        'nextPage': nextPage,
        'previousPage': previousPage,
        'totalItems': totalItems,
        'totalPages': totalPages,
        'currentPage': currentPage,
      };
}
