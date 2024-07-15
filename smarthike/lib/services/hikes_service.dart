import 'package:dio/dio.dart';
import 'package:smarthike/models/paginated_hike.dart';

class HikeService {
  final Dio dio;

  HikeService({required this.dio});

  Future<PaginatedHike?> getListHikes(int page) async {
    try {
      final response = await dio.get('/hikes?page=$page&limit=25');
      if (response.statusCode == 200) {
        return PaginatedHike.fromJson(response.data);
      }
    } catch (e) {
      throw Exception(e);
    }
    return null;
  }
}
