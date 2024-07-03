import 'dart:io';

import 'package:dio/dio.dart';

import '../models/user.dart';
import '../utils/shared_preferences_util.dart';

class AuthService {
  final Dio dio;
  final SharedPreferencesUtil sharedPreferencesUtil;

  AuthService({required this.dio, required this.sharedPreferencesUtil});

  Future<User?> login(String email, String password) async {
    try {
      var formData = FormData.fromMap({
        'email': email,
        'password': password,
      });
      final response = await dio.post('/login', data: formData);
      if (response.statusCode == 200) {
        final token = response.data['token'];
        await SharedPreferencesUtil.instance.setString('token', token);

        return await getUserData(token);
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data['i18n']);
      } else {
        throw DioException.connectionError(
            requestOptions: e.requestOptions, reason: "Internal server error");
      }
    }
    return null;
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
      final response = await dio.post('/register', data: formData);
      if (response.statusCode == 200) {
        final token = response.data['token'];
        await SharedPreferencesUtil.instance.setString('token', token);
        return await getUserData(token);
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data['i18n']);
      } else {
        throw DioException.connectionError(
            requestOptions: e.requestOptions, reason: "Internal server error");
      }
    }
    return null;
  }

  Future<void> deleteUser() async {
    final token = await SharedPreferencesUtil.instance.getString('token');
    await dio.delete('/user',
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
          },
        ));
  }

  Future<User?> logout() async {
    await SharedPreferencesUtil.instance.setString('token', '');
    return null;
  }

  Future<User?> getUserData(String token) async {
    try {
      final response = await dio.get('/user',
          options: Options(
            headers: {
              HttpHeaders.authorizationHeader: 'Bearer $token',
            },
          ));
      if (response.statusCode == 200) {
        return User.fromJson(response.data);
      }
    } catch (e) {
      await SharedPreferencesUtil.instance.setString('token', '');
      throw Exception(e);
    }
    return null;
  }
}
