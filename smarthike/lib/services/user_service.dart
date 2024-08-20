import 'package:dio/dio.dart';
import 'package:smarthike/api/smarthike_api.dart';
import 'package:smarthike/models/fav_hike.dart';
import 'package:smarthike/models/hike.dart';
import 'package:smarthike/utils/shared_preferences_util.dart';

class UserService {
  final SharedPreferencesUtil sharedPreferencesUtil;
  final ApiService apiService;

  UserService({required this.sharedPreferencesUtil, required this.apiService});

  Future<List<HikeFav>> getFavHikes() async {
    final token = await sharedPreferencesUtil.getString('token');
    if (token == null) {
      throw Exception('No token found');
    }
    try {
      final response = await apiService.get('/hike/favorites');

      if (response.statusCode == 200) {
        return (response.data['items'] as List)
            .map((item) => HikeFav.fromJson(item))
            .toList();
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data['i18n']);
      } else {
        throw DioException.connectionError(
            requestOptions: e.requestOptions, reason: "Internal server error");
      }
    }
    return [];
  }

  Future<void> addHikeToFavorite(Hike hike) async {
    try {
      await apiService.post('/hike/${hike.id}/favorite');
    } catch (e) {
      throw Exception('Failed to add hike in favorite $e');
    }
  }

  Future<void> removeHikeToFavorite(Hike hike) async {
    try {
      await apiService.delete('/hike/${hike.id}/favorite');
    } catch (e) {
      throw Exception('Failed to remove hike from favorite $e');
    }
  }
}
