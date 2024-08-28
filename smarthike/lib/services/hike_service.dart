import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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
  final Dio _dio = Dio();

  HikeService({required this.apiService});

  Future<List<String>> searchCities(String query) async {
    // Vérifier que la requête est valide avant de l'envoyer
    if (query.length < 3 || !RegExp(r'^[a-zA-Z0-9]').hasMatch(query)) {
      return [];
    }

    try {
      final response = await _dio.get(
        'https://api-adresse.data.gouv.fr/search/',
        queryParameters: {
          'q': query,
          'limit': 5,
          'type': 'municipality',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> features = response.data['features'];
        return features
            .map((feature) => feature['properties']['city'] as String)
            .toList();
      } else {
        print(
            'Error response: ${response.statusCode}, ${response.statusMessage}');
        print('Response data: ${response.data}');
        return [];
      }
    } on DioException catch (e) {
      print('DioException: ${e.message}');
      print(
          'Error response: ${e.response?.statusCode}, ${e.response?.statusMessage}');
      print('Error data: ${e.response?.data}');
      return [];
    } catch (e) {
      print('Unexpected error: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> getCityCoordinates(String cityName) async {
    try {
      final response = await _dio.get(
        'https://api-adresse.data.gouv.fr/search/',
        queryParameters: {
          'q': cityName,
          'limit': 1,
          'type': 'municipality',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> features = response.data['features'];
        if (features.isNotEmpty) {
          final coordinates = features[0]['geometry']['coordinates'];
          return {
            'latitude': coordinates[1],
            'longitude': coordinates[0],
          };
        }
      }
      return null;
    } catch (e) {
      print('Error getting city coordinates: $e');
      return null;
    }
  }

  Future<PaginatedHike?> getListHikes(int page,
      {required Map<String, dynamic> filters}) async {
    try {
      String url = '/hikes?page=$page&limit=25&distance=30';

      filters.forEach((key, value) {
        if (value != null) {
          if (value is RangeValues) {
            value = '${value.start.toInt()};${value.end.toInt()}';
          }
          if (key == 'difficulty' && value == '0') {
            return;
          }
          if (key == 'hiking_time' && value == '0;86400') {
            return;
          }
          if (key == 'hike_distance' && value == '0;1000') {
            return;
          }
          url += '&$key=$value';
        }
      });

      final response = await apiService.get(url);
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
        hasNextPage = response['nextPage'] != null;
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
