import 'dart:convert';
import 'package:logger/logger.dart';

class User {
  final int id;
  final String firstname;
  final String lastname;
  final String email;

  User({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    Logger logger = Logger();
    logger.i("Création d'un utilisateur à partir de JSON : $json");
    try {
      int id = json['id'] is int ? json['id'] : int.parse(json['id']);
      User user = User(
        id: id,
        firstname: json['firstname'] as String,
        lastname: json['lastname'] as String,
        email: json['email'] as String,
      );
      logger.i("Utilisateur créé : $user");
      return user;
    } catch (e) {
      logger.e("Erreur lors de la création de l'utilisateur : $e");
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    final data = {
      'id': id,
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
    };
    Logger().i("Conversion de l'utilisateur en JSON : $data");
    return data;
  }

  factory User.fromRawJson(String str) {
    Logger().i("Conversion de la chaîne brute en utilisateur.");
    return User.fromJson(json.decode(str));
  }

  String toRawJson() {
    final jsonStr = json.encode(toJson());
    Logger().i("Conversion de l'utilisateur en chaîne brute JSON : $jsonStr");
    return jsonStr;
  }
}
