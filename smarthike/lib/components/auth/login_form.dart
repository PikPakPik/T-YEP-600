import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:smarthike/components/button.dart';
import 'package:smarthike/providers/user_provider.dart';

class LoginForm extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Material(
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              key: const Key('email_login_field'),
              controller: _emailController,
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
              key: const Key('password_login_field'),
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Mot de passe'),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer votre mot de passe';
                }
                return null;
              },
            ),
            CustomButton(
              key: const Key('login_button'),
              text: 'Connexion',
              backgroundColor: Colors.blue,
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  try {
                    await userProvider.login(
                        _emailController.text, _passwordController.text);
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
