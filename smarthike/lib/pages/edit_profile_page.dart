import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarthike/models/user.dart';
import 'package:smarthike/providers/user_provider.dart';
import 'package:smarthike/constants.dart';
import 'package:smarthike/main.dart'; // Assurez-vous que ce fichier contient la classe NavigationBarApp

class EditProfilePage extends StatefulWidget {
  final User user;

  const EditProfilePage({super.key, required this.user});

  @override
  EditProfilePageState createState() => EditProfilePageState();
}

class EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late String _firstname;
  late String _lastname;
  late String _email;

  @override
  void initState() {
    super.initState();
    _firstname = widget.user.firstname;
    _lastname = widget.user.lastname;
    _email = widget.user.email;
  }

  void _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      User updatedUser = User(
        id: widget.user.id,
        firstname: _firstname,
        lastname: _lastname,
        email: _email,
      );

      await Provider.of<UserProvider>(context, listen: false)
          .updateUser(updatedUser);

      SmartHikeApp.navBarKey.currentState?.navigateToSpecificPage(2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.thirdColor,
      body: Center(
        child: SingleChildScrollView(
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
                        initialValue: _firstname,
                        decoration: InputDecoration(labelText: 'Prénom'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer votre prénom';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _firstname = value!;
                        },
                      ),
                      TextFormField(
                        initialValue: _lastname,
                        decoration:
                            InputDecoration(labelText: 'Nom de famille'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer votre nom de famille';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _lastname = value!;
                        },
                      ),
                      TextFormField(
                        initialValue: _email,
                        decoration: InputDecoration(labelText: 'Email'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer votre email';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Veuillez entrer un email valide';
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
                        child: Text('Enregistrer'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
