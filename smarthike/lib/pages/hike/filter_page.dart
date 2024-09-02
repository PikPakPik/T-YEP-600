import 'package:flutter/material.dart';
import 'package:smarthike/api/smarthike_api.dart';
import 'package:smarthike/components/hike/custom_app_bar.dart';
import 'package:smarthike/constants.dart';
import 'package:smarthike/components/dynamic_range_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:smarthike/main.dart';
import 'package:smarthike/services/hike_service.dart';
import '../../core/init/gen/translations.g.dart';
import 'package:provider/provider.dart';
import 'package:smarthike/providers/filter_provider.dart';

class FilterPage extends StatefulWidget {
  final void Function(Map<String, dynamic> filters) onApplyFilters;

  const FilterPage({super.key, required this.onApplyFilters});

  @override
  FilterPageState createState() => FilterPageState();
}

class FilterPageState extends State<FilterPage> {
  String _difficulty = tr(LocaleKeys.hike_details_difficulty);
  RangeValues hikesDistance = RangeValues(0, 1000);
  RangeValues timeRangeValues = RangeValues(0, 24);
  final TextEditingController _cityController = TextEditingController();
  List<String> _suggestedCities = [];
  final HikeService _hikeService = HikeService(apiService: ApiService());

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final filterProvider = Provider.of<FilterProvider>(context);
    final filters = filterProvider.filters;

    setState(() {
      _difficulty = filters['difficulty'] ?? "0";
      _cityController.text = filterProvider.cityName;

      if (filters['hike_distance'] != null) {
        List<String> distanceParts = filters['hike_distance'].split(';');
        hikesDistance = RangeValues(
            double.parse(distanceParts[0]), double.parse(distanceParts[1]));
      }

      if (filters['hiking_time'] != null) {
        List<String> timeParts = filters['hiking_time'].split(';');
        timeRangeValues = RangeValues(double.parse(timeParts[0]) / 3600,
            double.parse(timeParts[1]) / 3600);
      }
    });
  }

  void _searchCities(String query) async {
    if (query.length >= 3 && RegExp(r'^[a-zA-Z0-9]').hasMatch(query)) {
      try {
        final cities = await _hikeService.searchCities(query);
        if (!mounted) return;
        setState(() {
          _suggestedCities = cities;
        });
      } catch (e) {
        print('Error searching cities: $e');
        setState(() {
          _suggestedCities = [];
        });
      }
    } else {
      setState(() {
        _suggestedCities = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.thirdColor,
      appBar: CustomAppBar(
        isHikeListPage: false,
        hasActiveFilters: false,
        isFilterPage: false,
        onBackPressed: () {},
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.9,
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
                  currentRangeValues: hikesDistance,
                  min: 0,
                  max: 1000,
                  divisions: 1000,
                  onChanged: (values) {
                    setState(() {
                      hikesDistance = values;
                    });
                  },
                  initialRangeValues: RangeValues(0, 1000),
                ),
                const SizedBox(height: 20), // Reduced height
                DynamicRangeSlider(
                  label: tr(LocaleKeys.filter_time),
                  currentRangeValues: timeRangeValues,
                  min: 0,
                  max: 24,
                  divisions: 24,
                  unit: 'heures',
                  onChanged: (values) {
                    setState(() {
                      timeRangeValues = values;
                    });
                  },
                  initialRangeValues: RangeValues(0, 24),
                ),
                const SizedBox(height: 47),
                _buildDropdown(tr(LocaleKeys.filter_difficulty), _difficulty,
                    (value) {
                  setState(() {
                    _difficulty = value!;
                  });
                }),
                const SizedBox(height: 47),
                _buildCityAutocomplete(),
                const SizedBox(height: 20),
                _buildResetButton(),
                const SizedBox(height: 20),
                _buildApplyFiltersButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCityAutocomplete() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Consumer<FilterProvider>(
          builder: (context, filterProvider, child) {
            return Autocomplete<String>(
              initialValue: TextEditingValue(text: filterProvider.cityName),
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text.length < 3 ||
                    !RegExp(r'^[a-zA-Z0-9]').hasMatch(textEditingValue.text)) {
                  return const Iterable<String>.empty();
                }
                _searchCities(textEditingValue.text);
                return _suggestedCities;
              },
              onSelected: (String selection) {
                setState(() {
                  _cityController.text = selection;
                });
                filterProvider.setCityName(selection);
              },
              fieldViewBuilder: (BuildContext context,
                  TextEditingController fieldTextEditingController,
                  FocusNode fieldFocusNode,
                  VoidCallback onFieldSubmitted) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (fieldTextEditingController.text !=
                      filterProvider.cityName) {
                    fieldTextEditingController.text = filterProvider.cityName;
                  }
                });
                return TextField(
                  controller: fieldTextEditingController,
                  focusNode: fieldFocusNode,
                  decoration: InputDecoration(
                    hintText: tr(LocaleKeys.filter_filter_location),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  onChanged: (value) {
                    filterProvider.setCityName(value);
                  },
                );
              },
            );
          },
        ),
      ],
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
          items: {
            '0': tr(LocaleKeys.hike_details_difficulty),
            '1;4': tr(LocaleKeys.hike_details_difficulty_steps_easy),
            '5;7': tr(LocaleKeys.hike_details_difficulty_steps_medium),
            '8;9': tr(LocaleKeys.hike_details_difficulty_steps_difficult),
            '10': tr(LocaleKeys.hike_details_difficulty_steps_very_difficult),
          }.entries.map((entry) {
            return DropdownMenuItem<String>(
              value: entry.key,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(entry.value),
              ),
            );
          }).toList(),
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
        onPressed: () async {
          final filters = {
            'hike_distance':
                "${hikesDistance.start.toInt()};${hikesDistance.end.toInt()}",
            'difficulty': _difficulty,
            'hiking_time':
                "${(timeRangeValues.start * 3600).toInt()};${(timeRangeValues.end * 3600).toInt()}",
          };

          if (_cityController.text.isNotEmpty) {
            final coordinates =
                await _hikeService.getCityCoordinates(_cityController.text);
            if (coordinates != null) {
              filters['latitude'] = coordinates['latitude'].toString();
              filters['longitude'] = coordinates['longitude'].toString();
            }
          }

          if (!mounted) {
            return;
          }
          Provider.of<FilterProvider>(context, listen: false)
              .setFilters(filters);
          widget.onApplyFilters(filters);

          SmartHikeApp.navBarKey.currentState?.navigateToPage(9);
        },
        style: ButtonStyle(
          backgroundColor:
              WidgetStateProperty.all<Color>(Constants.primaryColor),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
          ),
        ),
        child: Text(
          tr(LocaleKeys.filter_apply_filters),
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildResetButton() {
    return SizedBox(
      width: 200,
      child: TextButton(
        onPressed: () {
          setState(() {
            hikesDistance = RangeValues(0, 1000);
            timeRangeValues = RangeValues(0, 24);
            _difficulty = '0';
            _cityController.clear();
          });

          Provider.of<FilterProvider>(context, listen: false).resetFilters();
        },
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.all<Color>(Colors.red),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
              side: BorderSide(color: Colors.red),
            ),
          ),
        ),
        child: Text(
          tr(LocaleKeys.filter_reset_filters),
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }
}
