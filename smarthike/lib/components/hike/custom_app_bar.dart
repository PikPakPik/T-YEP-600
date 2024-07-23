import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:smarthike/core/init/gen/translations.g.dart';
import 'package:smarthike/main.dart';
import 'package:smarthike/constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isFilterPage;
  final bool isHikeListPage;
  final VoidCallback? onFilterButtonPressed;

  const CustomAppBar(
      {super.key,
      this.isFilterPage = false,
      this.isHikeListPage = false,
      this.onFilterButtonPressed});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Constants.thirdColor,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
          if (isFilterPage) {
            SmartHikeApp.navBarKey.currentState?.navigateToPage(9);
          } else if (isHikeListPage) {
            SmartHikeApp.navBarKey.currentState?.navigateToPage(0);
          }
        },
      ),
      title: isFilterPage
          ? Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 5,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            LocaleKeys.hike_all_hikes.tr(),
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.tune, color: Colors.black),
                          onPressed: () {
                            SmartHikeApp.navBarKey.currentState
                                ?.navigateToPage(10);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 10.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                      hintText: LocaleKeys.hike_all_hikes.tr(),
                      prefixIcon: Icon(Icons.search, color: Colors.black),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.tune, color: Colors.black),
                        onPressed: () {
                          onFilterButtonPressed!();
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
