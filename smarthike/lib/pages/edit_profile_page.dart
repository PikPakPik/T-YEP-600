import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarthike/core/init/gen/translations.g.dart';
import 'package:smarthike/models/user.dart';
import 'package:smarthike/providers/auth_provider.dart';
import 'package:smarthike/constants.dart';
import 'package:smarthike/main.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  EditProfilePageState createState() => EditProfilePageState();
}

class EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late User _user;
  late String _email;
  late String _firstname;
  late String _lastname;

  @override
  void initState() {
    super.initState();
  }

  void _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      User updatedUser = User(
        id: _user.id,
        firstname: _firstname,
        lastname: _lastname,
        email: _email,
      );

      await Provider.of<AuthProvider>(context, listen: false)
          .updateUser(updatedUser);

      SmartHikeApp.navBarKey.currentState?.navigateToPage(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Constants.thirdColor,
        body: Center(
          child:
              Consumer<AuthProvider>(builder: (context, authProvider, child) {
            _user = authProvider.user!;
            return SingleChildScrollView(
              child: Container(
                width: 350,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 5,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          AssetImage('assets/images/LogoSmartHike.png'),
                    ),
                    const SizedBox(height: 20),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            initialValue: _user.firstname,
                            decoration: InputDecoration(
                                labelText:
                                    LocaleKeys.register_form_firstname.tr()),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return LocaleKeys
                                    .register_form_error_firstname_required
                                    .tr();
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _firstname = value!;
                            },
                          ),
                          TextFormField(
                            initialValue: _user.lastname,
                            decoration: InputDecoration(
                                labelText:
                                    LocaleKeys.register_form_lastname.tr()),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return LocaleKeys
                                    .register_form_error_lastname_required
                                    .tr();
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _lastname = value!;
                            },
                          ),
                          TextFormField(
                            initialValue: _user.email,
                            decoration: InputDecoration(
                                labelText: LocaleKeys.register_form_email.tr()),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return LocaleKeys
                                    .login_form_error_email_required
                                    .tr();
                              }
                              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                  .hasMatch(value)) {
                                return LocaleKeys.login_form_error_email_invalid
                                    .tr();
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _email = value!;
                            },
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _saveProfile,
                            child:
                                Text(LocaleKeys.register_form_form_save.tr()),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ));
  }
}
