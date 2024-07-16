import 'package:dio/dio.dart';
import 'package:smarthike/models/fav_hike.dart';
import 'package:smarthike/utils/shared_preferences_util.dart';

class UserService {
  final Dio dio;
  final SharedPreferencesUtil sharedPreferencesUtil;

  UserService({required this.dio, required this.sharedPreferencesUtil});

  Future<List<HikeFav>> getFavHikes() async {
    final token = await sharedPreferencesUtil.getString('token');
    if (token == null) {
      throw Exception('No token found');
    }
    try {
      final response = await dio.get('/hike/favorites');

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
}
