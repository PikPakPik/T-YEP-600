import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:smarthike/components/button.dart';
import 'package:smarthike/constants.dart';
import 'package:smarthike/core/init/gen/translations.g.dart';
import 'package:smarthike/main.dart';
import 'package:smarthike/providers/user_provider.dart';

class DeleteAccountWarningPage extends StatefulWidget {
  const DeleteAccountWarningPage({super.key});

  @override
  DeleteAccountWarningPageState createState() =>
      DeleteAccountWarningPageState();
}

class Item {
  Item({
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
}

class DeleteAccountWarningPageState extends State<DeleteAccountWarningPage> {
  final List<Item> _data = [
    Item(
      headerValue: LocaleKeys.settings_delete_account_warning_section1.tr(),
      expandedValue:
          LocaleKeys.settings_delete_account_warning_section1_detail.tr(),
    ),
    Item(
      headerValue: LocaleKeys.settings_delete_account_warning_section2.tr(),
      expandedValue:
          LocaleKeys.settings_delete_account_warning_section2_detail.tr(),
    ),
    Item(
      headerValue: LocaleKeys.settings_delete_account_warning_section3.tr(),
      expandedValue:
          LocaleKeys.settings_delete_account_warning_section3_detail.tr(),
    ),
  ];

  void _showConfirmationBottomSheet(
      BuildContext context, UserProvider userProvider) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Text(
                    LocaleKeys.settings_delete_account_confirmation_message
                        .tr(),
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.red),
                          onPressed: () {
                            userProvider.deleteUser();
                            Navigator.pop(context);
                            Fluttertoast.showToast(
                                textColor: Colors.white,
                                backgroundColor: Colors.red,
                                timeInSecForIosWeb: 5,
                                msg: LocaleKeys.settings_delete_account_success
                                    .tr());
                            SmartHikeApp.navBarKey.currentState
                                ?.navigateToPage(1);
                          },
                          child: Text(LocaleKeys
                              .settings_delete_account_confirm_button
                              .tr())),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(LocaleKeys
                              .settings_delete_account_cancel_button
                              .tr())),
                    ])
              ]));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Constants.thirdColor,
        body: Consumer<UserProvider>(builder: (context, userProvider, child) {
          return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 80),
                  Center(
                    child: Image.asset(
                      'assets/images/LogoSmartHike.png',
                      height: 100,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    LocaleKeys.settings_delete_account_warning_message.tr(),
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  ExpansionPanelList(
                    expansionCallback: (int index, bool isExpanded) {
                      setState(() {
                        _data[index].isExpanded = isExpanded;
                      });
                    },
                    children: List.generate(
                        3,
                        (index) => ExpansionPanel(
                              isExpanded: _data[index].isExpanded,
                              headerBuilder:
                                  (BuildContext context, bool isExpanded) {
                                return ListTile(
                                  title: Text(_data[index].headerValue),
                                );
                              },
                              backgroundColor: Constants.primaryColor,
                              body: ListTile(
                                title: Text(_data[index].expandedValue),
                              ),
                            )),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: CustomButton(
                      backgroundColor: Colors.red,
                      text: LocaleKeys.settings_delete_account_confirm_button
                          .tr(),
                      onPressed: () {
                        _showConfirmationBottomSheet(context, userProvider);
                      },
                    ),
                  ),
                ],
              )));
        }));
  }
}
