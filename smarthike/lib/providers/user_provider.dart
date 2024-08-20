import 'package:flutter/material.dart';
import 'package:smarthike/models/hike.dart';
import 'package:smarthike/services/user_service.dart';

class UserProvider extends ChangeNotifier {
  final UserService userService;

  UserProvider({required this.userService});

  Future<void> addHikeToFavorite(Hike hike) async {
    await userService.addHikeToFavorite(hike);
    notifyListeners();
  }

  Future<void> removeHikeToFavorite(Hike hike) async {
    await userService.removeHikeToFavorite(hike);
    notifyListeners();
  }
}
