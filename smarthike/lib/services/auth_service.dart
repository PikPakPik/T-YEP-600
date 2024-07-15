import 'package:dio/dio.dart';
import 'package:smarthike/api/smarthike_api.dart';

import '../models/user.dart';
import '../utils/shared_preferences_util.dart';
import 'package:logger/logger.dart';

class AuthService {
  final ApiService apiService;
  final SharedPreferencesUtil sharedPreferencesUtil;
  final Logger logger = Logger();

  AuthService({required this.apiService, required this.sharedPreferencesUtil});

  Future<User?> login(String email, String password) async {
    try {
      var formData = FormData.fromMap({
        'email': email,
        'password': password,
      });

      final response = await apiService.post('/login', formData);
      final token = response['token'];
      await apiService.updateToken(token);

      return await getUserData(token);
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data['i18n']);
      } else {
        throw DioException.connectionError(
            requestOptions: e.requestOptions, reason: "Internal server error");
      }
    }
  }

  Future<User?> register(
      String firstname, String lastname, String email, String password) async {
    try {
      var formData = FormData.fromMap({
        'firstname': firstname,
        'lastname': lastname,
        'email': email,
        'password': password
      });

      final response = await apiService.post('/register', formData);
      final token = response['token'];
      await apiService.updateToken(token);

      return await getUserData(token);
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data['i18n']);
      } else {
        throw DioException.connectionError(
            requestOptions: e.requestOptions, reason: "Internal server error");
      }
    }
  }

  Future<void> deleteUser() async {
    await apiService.delete('/user');
  }

  Future<User?> logout() async {
    await SharedPreferencesUtil.instance.setString('token', '');
    return null;
  }

  Future<User?> getUserData(String token) async {
    try {
      final response = await apiService.get('/user');
      return User.fromJson(response);
    } catch (e) {
      await SharedPreferencesUtil.instance.setString('token', '');
      throw Exception(e);
    }
  }

  Future<User> updateUser(User user) async {
    final requestData = user.toJson();

    try {
      final response = await apiService.put('/user', requestData);
      return User.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update user $e');
    }
  }
}
