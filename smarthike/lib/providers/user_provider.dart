import 'package:flutter/material.dart';
import 'package:logger/web.dart';
import 'package:smarthike/models/user.dart';
import 'package:smarthike/services/auth_service.dart';
import 'package:smarthike/utils/shared_preferences_util.dart';

class UserProvider extends ChangeNotifier {
  User? _user;
  final AuthService authService;

  UserProvider({required this.authService});

  User? get user => _user;

  Logger logger = Logger();

  Future<void> loadUserData() async {
    final token = await SharedPreferencesUtil.instance.getString('token');
    if (token != null) {
      _user = await authService.getUserData(token);
      notifyListeners();
    }
  }

  Future<void> login(String? email, String? password) async {
    if (email == null || password == null) {
      throw Exception('Email and password are required');
    }
    try {
      _user = await authService.login(email, password);
    } catch (e) {
      throw Exception(e.toString());
    }
    notifyListeners();
  }

  Future<void> register(String? firstname, String? lastname, String? email,
      String? password) async {
    if (firstname == null ||
        lastname == null ||
        email == null ||
        password == null) {
      throw Exception('All fields are required');
    }
    try {
      _user = await authService.register(firstname, lastname, email, password);
    } catch (e) {
      throw Exception(e.toString());
    }
    notifyListeners();
  }

  Future<void> logout() async {
    _user = await authService.logout();
    notifyListeners();
  }

  Future<void> updateUser(User user) async {
    notifyListeners();
  }
}
