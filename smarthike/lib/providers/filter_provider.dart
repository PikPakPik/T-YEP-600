import 'package:flutter/material.dart';

class FilterProvider with ChangeNotifier {
  Map<String, dynamic> _filters = {};

  Map<String, dynamic> get filters => _filters;

  String get cityName => _filters['cityName'] ?? '';

  bool get hasActiveFilters {
    return _filters.isNotEmpty &&
        (_filters['hike_distance'] != '0;1000' ||
            _filters['difficulty'] != '0' ||
            _filters['hiking_time'] != '0;86400' ||
            _filters['latitude'] != null ||
            _filters['longitude'] != null);
  }

  void setFilters(Map<String, dynamic> filters) {
    _filters = filters;
    notifyListeners();
  }

  void setCityName(String cityName) {
    _filters['cityName'] = cityName;
    notifyListeners();
  }

  void resetFilters() {
    _filters = {};
    notifyListeners();
  }
}
