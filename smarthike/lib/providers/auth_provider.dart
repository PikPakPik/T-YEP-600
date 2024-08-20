import 'package:flutter/material.dart';
import 'package:logger/web.dart';
import 'package:smarthike/models/user.dart';
import 'package:smarthike/services/auth_service.dart';
import 'package:smarthike/utils/shared_preferences_util.dart';

class AuthProvider extends ChangeNotifier {
  User? _user;
  final AuthService authService;

  AuthProvider({required this.authService});

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

  Future<void> deleteUser() async {
    _user = null;
    await authService.deleteUser();
    await SharedPreferencesUtil.instance.setString('token', '');
    notifyListeners();
  }

  Future<void> logout() async {
    _user = await authService.logout();
    notifyListeners();
  }

  Future<void> updateUser(User user) async {
    logger.i("Début de la mise à jour de l'utilisateur dans AuthProvider.");
    try {
      logger.i("Appel à authService.updateUser.");
      final updatedUser = await authService.updateUser(user);
      _user = updatedUser;
      notifyListeners();
      logger.i(
          "Mise à jour de l'utilisateur réussie et notification des écouteurs.");
    } catch (e) {
      logger.e("Erreur lors de la mise à jour de l'utilisateur : $e");
      throw Exception('Failed to update user');
    }
  }
}
