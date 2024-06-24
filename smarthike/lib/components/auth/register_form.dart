import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:smarthike/components/button.dart';
import 'package:smarthike/providers/user_provider.dart';

class RegisterForm extends StatelessWidget {
  final _formRegisterKey = GlobalKey<FormState>();
  final _emailRegisterController = TextEditingController();
  final _passwordRegisterController = TextEditingController();
  final _confirmPasswordRegisterController = TextEditingController();
  final _firstnameRegisterController = TextEditingController();
  final _lastnameRegisterController = TextEditingController();

  RegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Material(
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: _formRegisterKey,
        child: Column(
          children: [
            TextFormField(
              key: const Key('firstname_register_field'),
              controller: _firstnameRegisterController,
              decoration: const InputDecoration(labelText: 'Prénom'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer votre prénom';
                }
                return null;
              },
            ),
            TextFormField(
              key: const Key('lastname_register_field'),
              controller: _lastnameRegisterController,
              decoration: const InputDecoration(labelText: 'Nom'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer votre nom';
                }
                return null;
              },
            ),
            TextFormField(
              key: const Key('email_register_field'),
              controller: _emailRegisterController,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer votre email';
                }
                if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                    .hasMatch(value)) {
                  return 'Email invalide';
                }
                return null;
              },
            ),
            TextFormField(
              key: const Key('password_register_field'),
              controller: _passwordRegisterController,
              decoration: const InputDecoration(labelText: 'Mot de passe'),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer votre mot de passe';
                }
                String pattern =
                    r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$';
                RegExp regExp = RegExp(pattern);
                if (!regExp.hasMatch(value)) {
                  return 'Le mot de passe doit contenir au moins 8 caractères, \ndont des chiffres, des lettres majuscules et minuscules, \net des symboles spéciaux';
                }
                return null;
              },
            ),
            TextFormField(
              key: const Key('confirm_password_register_field'),
              controller: _confirmPasswordRegisterController,
              decoration:
                  const InputDecoration(labelText: 'Confirmer le mot de passe'),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez confirmer votre mot de passe';
                }
                if (value != _passwordRegisterController.text) {
                  return 'Les mots de passe ne correspondent pas';
                }
                return null;
              },
            ),
            CustomButton(
              key: const Key('register_button'),
              text: 'Inscription',
              backgroundColor: Colors.blue,
              onPressed: () async {
                if (_formRegisterKey.currentState!.validate()) {
                  try {
                    await userProvider.register(
                        _firstnameRegisterController.text,
                        _lastnameRegisterController.text,
                        _emailRegisterController.text,
                        _passwordRegisterController.text);
                    if (context.mounted) Navigator.of(context).pop();
                  } catch (e) {
                    if (e is Exception) {
                      Fluttertoast.showToast(
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        msg: e.toString(),
                        toastLength: Toast.LENGTH_SHORT,
                      );
                    } else if (e is DioException) {
                      Fluttertoast.showToast(
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        msg: e.error?.toString() ?? 'Erreur inconnue',
                        toastLength: Toast.LENGTH_SHORT,
                      );
                    }
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
