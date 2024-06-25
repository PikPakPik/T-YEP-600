import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:smarthike/components/button.dart';
import 'package:smarthike/components/dropdown.dart';
import 'package:smarthike/components/input.dart';
import 'package:smarthike/constants.dart';
import 'package:smarthike/providers/user_provider.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  RegisterFormState createState() => RegisterFormState();
}

class RegisterFormState extends State<RegisterForm> {
  final _formRegisterKey = GlobalKey<FormState>();
  final _emailRegisterController = TextEditingController();
  final _passwordRegisterController = TextEditingController();
  final _confirmPasswordRegisterController = TextEditingController();
  final _firstnameRegisterController = TextEditingController();
  final _lastnameRegisterController = TextEditingController();
  final _ageRegisterController = TextEditingController();

  String? _selectedFrequency = 'Occasionnellement';
  String? _selectedLevel = 'Intermédiaire';
  bool _isFirstStep = true;

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Material(
      color: Colors.transparent,
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: _formRegisterKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (_isFirstStep) ...[
                CustomInput(
                  key: const Key('firstname_register_field'),
                  hintText: 'Prénom',
                  controller: _firstnameRegisterController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre prénom';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                CustomInput(
                  key: const Key('lastname_register_field'),
                  hintText: 'Nom',
                  controller: _lastnameRegisterController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre nom';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                CustomInput(
                  key: const Key('email_register_field'),
                  hintText: 'Email',
                  controller: _emailRegisterController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre email';
                    }
                    if (!RegExp(
                            r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                        .hasMatch(value)) {
                      return 'Email invalide';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                CustomInput(
                  key: const Key('password_register_field'),
                  hintText: 'Mot de passe',
                  controller: _passwordRegisterController,
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
                const SizedBox(height: 15),
                CustomInput(
                  key: const Key('confirm_password_register_field'),
                  hintText: 'Confirmer le mot de passe',
                  controller: _confirmPasswordRegisterController,
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
                const SizedBox(height: 15),
                CustomButton(
                  key: const Key('next_button'),
                  text: 'Suivant',
                  backgroundColor: Constants.primaryColor,
                  textColor: Colors.black,
                  onPressed: () {
                    if (_formRegisterKey.currentState!.validate()) {
                      setState(() {
                        _isFirstStep = false;
                      });
                    }
                  },
                ),
              ] else ...[
                CustomInput(
                  key: const Key('age_register_field'),
                  hintText: 'Âge',
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  controller: _ageRegisterController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre âge';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Veuillez entrer un âge valide';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                CustomDropdown(
                  key: const Key('frequency_register_field'),
                  hintText: 'Fréquence de sport',
                  selectedItem: _selectedFrequency,
                  items: const [
                    'Rarement',
                    'Occasionnellement',
                    'Régulièrement'
                  ],
                  onChanged: (newValue) {
                    setState(() {
                      _selectedFrequency = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Veuillez sélectionner une fréquence de sport';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                CustomDropdown(
                  key: const Key('level_register_field'),
                  hintText: 'Niveau de sport',
                  selectedItem: _selectedLevel,
                  items: const ['Débutant', 'Intermédiaire', 'Avancé'],
                  onChanged: (newValue) {
                    setState(() {
                      _selectedLevel = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Veuillez sélectionner un niveau de sport';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                CustomButton(
                  key: const Key('back_button'),
                  text: 'Retour',
                  backgroundColor: Colors.grey,
                  textColor: Colors.black,
                  onPressed: () {
                    setState(() {
                      _isFirstStep = true;
                    });
                  },
                ),
                const SizedBox(height: 15),
                CustomButton(
                  key: const Key('register_button'),
                  text: 'Inscription',
                  backgroundColor: Constants.primaryColor,
                  textColor: Colors.black,
                  onPressed: () async {
                    if (_formRegisterKey.currentState!.validate()) {
                      try {
                        await userProvider.register(
                          _firstnameRegisterController.text,
                          _lastnameRegisterController.text,
                          _emailRegisterController.text,
                          _passwordRegisterController.text,
                        );
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
            ],
          ),
        ),
      ),
    );
  }
}
