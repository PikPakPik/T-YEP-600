import 'package:flutter/material.dart';
import 'package:smarthike/components/hike/custom_app_bar.dart';
import 'package:smarthike/constants.dart';
import 'package:smarthike/components/dynamic_range_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../core/init/gen/translations.g.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  FilterPageState createState() => FilterPageState();
}

class FilterPageState extends State<FilterPage> {
  String _difficulty = tr(LocaleKeys.hike_details_difficulty);
  String _location = tr(LocaleKeys.filter_location);
  double min = 0, max = 2090;
  RangeValues distanceRangeValues = RangeValues(0, 2090);
  RangeValues timeRangeValues = RangeValues(0, 10);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.thirdColor,
      appBar: CustomAppBar(
        isFilterPage: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            constraints: const BoxConstraints(
              maxHeight: 650,
              maxWidth: 400,
            ),
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
            child: Column(
              children: [
                DynamicRangeSlider(
                  label: tr(LocaleKeys.filter_distance),
                  currentRangeValues: distanceRangeValues,
                  min: min,
                  max: max,
                  onChanged: (values) {
                    setState(() {
                      distanceRangeValues = values;
                    });
                  },
                ),
                const SizedBox(height: 47),
                DynamicRangeSlider(
                  label: tr(LocaleKeys.filter_time),
                  currentRangeValues: timeRangeValues,
                  min: 0,
                  max: 10,
                  onChanged: (values) {
                    setState(() {
                      timeRangeValues = values;
                    });
                  },
                ),
                const SizedBox(height: 47),
                _buildDropdown(tr(LocaleKeys.filter_difficulty), _difficulty,
                    (value) {
                  setState(() {
                    _difficulty = value!;
                  });
                }),
                const SizedBox(height: 47),
                _buildTextField(tr(LocaleKeys.filter_location), _location,
                    (value) {
                  setState(() {
                    _location = value;
                  });
                }),
                const Spacer(),
                _buildApplyFiltersButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(
      String label, String currentValue, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.black)),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          isExpanded: true,
          value: currentValue,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: Colors.black),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: Colors.black),
            ),
          ),
          items: <String>[
            tr(LocaleKeys.hike_details_difficulty),
            tr(LocaleKeys.hike_details_difficulty_steps_easy),
            tr(LocaleKeys.hike_details_difficulty_steps_medium),
            tr(LocaleKeys.hike_details_difficulty_steps_difficult),
            tr(LocaleKeys.hike_details_difficulty_steps_very_difficult),
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(value),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildTextField(
      String label, String currentValue, ValueChanged<String> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.black)),
        const SizedBox(height: 10),
        TextField(
          key: Key('locationField'),
          decoration: InputDecoration(
            hintText: currentValue,
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: Colors.black),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: Colors.black),
            ),
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildApplyFiltersButton() {
    return SizedBox(
      width: 205,
      height: 32,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Constants.primaryColor,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        child: Center(
          child: Text(
            tr(LocaleKeys.filter_apply_filters),
            style: TextStyle(color: Colors.black, fontSize: 16.0),
          ),
        ),
      ),
    );
  }
}
