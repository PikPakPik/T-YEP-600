import 'package:flutter/material.dart';
import 'package:smarthike/models/hike.dart';
import 'package:smarthike/services/hike_service.dart';

class HikeProvider extends ChangeNotifier {
  final List<Hike> _hikes = [];
  int? _nextPage;
  int? _previousPage;
  int _currentPage = 1;
  int _totalPages = 1;
  bool _isLoading = false;

  final HikeService hikeService;

  HikeProvider({required this.hikeService});

  List<Hike> get hikes => _hikes;
  int? get nextPage => _nextPage;
  int? get previousPage => _previousPage;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  bool get isLoading => _isLoading;

  Future<void> loadPaginatedHikesData(int page) async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      final paginatedHike = await hikeService.getListHikes(page);
      if (paginatedHike != null) {
        _hikes.addAll(paginatedHike.items);
        _nextPage = paginatedHike.nextPage;
        _previousPage = paginatedHike.previousPage;
        _currentPage = paginatedHike.currentPage;
        _totalPages = paginatedHike.totalPages;
      }
    } catch (e) {
      throw Exception('Error fetching hikes: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
