import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:smarthike/core/init/gen/translations.g.dart';
import 'package:smarthike/main.dart';
import 'package:smarthike/constants.dart';
import 'package:smarthike/providers/filter_provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isHikeListPage;
  final bool isFilterPage;
  final bool hasActiveFilters;
  final VoidCallback? onFilterButtonPressed;
  final VoidCallback? onBackPressed;

  const CustomAppBar({
    super.key,
    this.isHikeListPage = false,
    this.isFilterPage = false,
    this.hasActiveFilters = false,
    this.onFilterButtonPressed,
    this.onBackPressed,
  });

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Consumer<FilterProvider>(
      builder: (context, filterProvider, child) {
        return AppBar(
          backgroundColor: Constants.thirdColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: onBackPressed ??
                () {
                  if (isHikeListPage) {
                    SmartHikeApp.navBarKey.currentState?.navigateToPage(0);
                  } else {
                    SmartHikeApp.navBarKey.currentState?.navigateToPage(9);
                  }
                },
          ),
          title: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    enabled: isHikeListPage,
                    filled: true,
                    fillColor: Colors.grey[200],
                    contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                    hintText: LocaleKeys.hike_all_hikes.tr(),
                    prefixIcon: Icon(Icons.search, color: Colors.black),
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.tune,
                        color: hasActiveFilters ? Colors.blue : Colors.grey,
                      ),
                      onPressed: onFilterButtonPressed,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
