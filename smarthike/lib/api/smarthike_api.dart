import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:smarthike/utils/shared_preferences_util.dart';

class ApiService {
  final String _baseURL = Platform.isAndroid
      ? dotenv.env['API_URL_ANDROID']!
      : dotenv.env['API_URL_OTHER']!;
  Dio _dio = Dio();

  ApiService({Dio? dio}) {
    _dio = dio ?? Dio();

    _dio.options.baseUrl = _baseURL;

    _initializeHeaders();
  }

  Future<void> _initializeHeaders() async {
    String? savedToken =
        await SharedPreferencesUtil.instance.getString('token');

    _dio.options.headers = {
      HttpHeaders.userAgentHeader: 'dio',
      'Authorization': 'Bearer $savedToken',
      'common-header': 'xx',
      'Content-Type': 'application/json',
    };

    _dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90));
  }

  Future<void> updateToken(String newToken) async {
    await SharedPreferencesUtil.instance.setString('token', newToken);
    _updateHeaders(newToken);
  }

  void _updateHeaders(String newToken) {
    _dio.options.headers['Authorization'] = 'Bearer $newToken';
  }

  Future<dynamic> get(String path) async {
    dynamic responseJson;
    try {
      final response = await _dio.get(_baseURL + path);
      responseJson = returnResponse(response);
    } on SocketException {
      throw Exception('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> post(String path, dynamic data) async {
    dynamic responseJson;
    try {
      final response = await _dio.post(_baseURL + path,
          data: data,
          options: Options()..headers = {'Content-Type': 'application/json'});
      responseJson = returnResponse(response);
    } on SocketException {
      throw Exception('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> delete(String path) async {
    dynamic responseJson;
    try {
      final response = await _dio.delete(_baseURL + path);
      responseJson = returnResponse(response);
    } on SocketException {
      throw Exception('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> put(String path, dynamic data) async {
    dynamic responseJson;
    data = FormData.fromMap(data);
    try {
      final response = await _dio.put(_baseURL + path, data: data);
      responseJson = returnResponse(response);
    } on SocketException {
      throw Exception('No Internet connection');
    }
    return responseJson;
  }

  dynamic returnResponse(Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
      case 404:
        return response.data;
      case 400:
        throw Exception(response.data.toString());
      case 401:
      case 403:
        throw Exception(response.data.toString());
      case 500:
      default:
        throw Exception(
          'Error occurred while Communication with Server with StatusCode : ${response.statusCode}',
        );
    }
  }
}
