import 'dart:convert';

import 'package:logger/web.dart';

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
    try {
      User user = User(
        id: json['id'] as int,
        firstname: json['firstname'] as String,
        lastname: json['lastname'] as String,
        email: json['email'] as String,
      );
      return user;
    } catch (e) {
      logger.e("Erreur lors de la création de l'utilisateur: $e");
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'firstname': firstname,
        'lastname': lastname,
        'email': email,
      };

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());
}
