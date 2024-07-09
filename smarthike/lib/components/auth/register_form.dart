import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:smarthike/components/button.dart';
import 'package:smarthike/components/dropdown.dart';
import 'package:smarthike/components/input.dart';
import 'package:smarthike/constants.dart';
import 'package:smarthike/main.dart';
import 'package:smarthike/providers/user_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:smarthike/core/init/gen/translations.g.dart';

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
                  hintText: LocaleKeys.register_form_firstname.tr(),
                  controller: _firstnameRegisterController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return LocaleKeys.register_form_error_firstname_required
                          .tr();
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                CustomInput(
                  key: const Key('lastname_register_field'),
                  hintText: LocaleKeys.register_form_lastname.tr(),
                  controller: _lastnameRegisterController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return LocaleKeys.register_form_error_lastname_required
                          .tr();
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                CustomInput(
                  key: const Key('email_register_field'),
                  hintText: LocaleKeys.register_form_email.tr(),
                  controller: _emailRegisterController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return LocaleKeys.register_form_error_email_required.tr();
                    }
                    if (!RegExp(
                            r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                        .hasMatch(value)) {
                      return LocaleKeys.register_form_error_email_invalid.tr();
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                CustomInput(
                  key: const Key('password_register_field'),
                  hintText: LocaleKeys.register_form_password.tr(),
                  controller: _passwordRegisterController,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return LocaleKeys.register_form_error_password_required
                          .tr();
                    }
                    String pattern =
                        r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$';
                    RegExp regExp = RegExp(pattern);
                    if (!regExp.hasMatch(value)) {
                      return LocaleKeys.register_form_error_password_invalid
                          .tr();
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                CustomInput(
                  key: const Key('confirm_password_register_field'),
                  hintText: LocaleKeys.register_form_confirm_password.tr(),
                  controller: _confirmPasswordRegisterController,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return LocaleKeys
                          .register_form_error_confirm_password_required
                          .tr();
                    }
                    if (value != _passwordRegisterController.text) {
                      return LocaleKeys
                          .register_form_error_passwords_do_not_match
                          .tr();
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                CustomButton(
                  key: const Key('next_button'),
                  text: LocaleKeys.register_form_next.tr(),
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
                  hintText: LocaleKeys.register_form_age.tr(),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  controller: _ageRegisterController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return LocaleKeys.register_form_error_age_required.tr();
                    }
                    if (int.tryParse(value) == null) {
                      return LocaleKeys.register_form_error_age_invalid.tr();
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                CustomDropdown(
                  key: const Key('frequency_register_field'),
                  hintText: LocaleKeys.register_form_frequency.tr(),
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
                      return LocaleKeys.register_form_error_frequency_required
                          .tr();
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                CustomDropdown(
                  key: const Key('level_register_field'),
                  hintText: LocaleKeys.register_form_level.tr(),
                  selectedItem: _selectedLevel,
                  items: const ['Débutant', 'Intermédiaire', 'Avancé'],
                  onChanged: (newValue) {
                    setState(() {
                      _selectedLevel = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return LocaleKeys.register_form_error_level_required.tr();
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                CustomButton(
                  key: const Key('back_button'),
                  text: LocaleKeys.register_form_back.tr(),
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
                  text: LocaleKeys.register_form_register.tr(),
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
                        if (context.mounted) {
                          SmartHikeApp.navBarKey.currentState
                              ?.navigateToSpecificPage(2);
                        }
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
                            msg: e.error?.toString() ??
                                LocaleKeys.api_error_unknown.tr(),
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
