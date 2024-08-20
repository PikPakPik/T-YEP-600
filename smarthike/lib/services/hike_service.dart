import 'dart:io';

import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';
import 'package:smarthike/api/smarthike_api.dart';
import 'package:smarthike/models/hike.dart';
import 'package:smarthike/models/paginated_hike.dart';
import 'package:http_parser/http_parser.dart';

class Ways {
  final List<LatLng> points;

  Ways({required this.points});

  factory Ways.fromJson(Map<String, dynamic> json) {
    // Création d'un point LatLng à partir des valeurs lat et lon
    var point = LatLng(json['lat'] as double, json['lon'] as double);
    // Retourne un HikeGeometry avec ce point
    return Ways(points: [point]);
  }
}

class HikeService {
  final ApiService apiService;

  HikeService({required this.apiService});

  Future<PaginatedHike?> getListHikes(int page) async {
    try {
      final response = await apiService.get('/hikes?page=$page&limit=25');
      return PaginatedHike.fromJson(response);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<Ways>> getHikeGeometry(int hikeId) async {
    try {
      final response = await apiService.get('/hike/$hikeId/geometry');
      List<dynamic> ways = response;
      return ways.map((way) {
        List<LatLng> points = (way as List<dynamic>)
            .map((pointJson) =>
                LatLng(pointJson['lat'] as double, pointJson['lon'] as double))
            .toList();
        return Ways(points: points);
      }).toList();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<Hike>> getAllHikes() async {
    List<dynamic> items = [];
    int page = 1;
    bool hasNextPage = true;

    try {
      while (hasNextPage) {
        final response = await apiService.get('/hikes?limit=1000&page=$page');
        items.addAll(response['items']);
        hasNextPage = false;
        page++;
      }
      return items
          .map((e) => Hike.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data['i18n']);
      } else {
        throw DioException.connectionError(
            requestOptions: e.requestOptions, reason: "Internal server error");
      }
    }
  }

  Future<String> uploadHikeImage(int hikeId, File file) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path,
          filename: file.path, contentType: MediaType('image', 'jpeg')),
      'id': hikeId,
    });

    try {
      final response = await apiService.post(
        '/hike/$hikeId/image',
        data: formData,
      );
      return response['i18n'];
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data['i18n']);
      } else {
        throw DioException.connectionError(
            requestOptions: e.requestOptions, reason: "Internal server error");
      }
    }
  }

  Future<Hike> getHike(int? hikeId) async {
    try {
      final response = await apiService.get('/hike/$hikeId');
      return Hike.fromJson(response);
    } catch (e) {
      throw Exception(e);
    }
  }
}
