import 'package:dio/dio.dart';
import 'package:smarthike/api/smarthike_api.dart';
import 'package:smarthike/models/hike_api.dart';
import 'package:smarthike/models/paginated_hike.dart';

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

  Future<List<HikeApi>> getAllHikes() async {
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
          .map((e) => HikeApi.fromJson(e as Map<String, dynamic>))
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
}
