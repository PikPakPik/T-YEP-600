import 'package:flutter/material.dart';
import 'package:smarthike/models/hike.dart';
import 'package:smarthike/services/hike_service.dart';

class HikeProvider extends ChangeNotifier {
  final List<Hike> _hikes = [];
  Hike? _selectedHike;
  int? _nextPage;
  int? _previousPage;
  int _currentPage = 1;
  int _totalPages = 1;
  bool _isLoading = false;
  Map<String, dynamic> _currentFilters = {};

  final HikeService hikeService;

  HikeProvider({required this.hikeService});

  List<Hike> get hikes => _hikes;
  Hike? get selectedHike => _selectedHike;
  int? get nextPage => _nextPage;
  int? get previousPage => _previousPage;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  bool get isLoading => _isLoading;
  Map<String, dynamic> get currentFilters => _currentFilters;

  Future<void> loadPaginatedHikesData(int page,
      {Map<String, dynamic>? filters, required bool reset}) async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      if (filters != null) {
        _currentFilters = filters;
        _hikes.clear();
        _currentPage = 1;
      }

      final paginatedHike = await hikeService.getListHikes(_currentPage,
          filters: _currentFilters);
      if (paginatedHike != null) {
        if (_currentPage == 1) {
          _hikes.clear();
        }
        _hikes.addAll(paginatedHike.items);
        _nextPage = paginatedHike.nextPage;
        _previousPage = paginatedHike.previousPage;
        _currentPage = paginatedHike.currentPage;
        _totalPages = paginatedHike.totalPages;
      }
    } catch (e) {
      print('Error fetching hikes: $e');
      // Vous pourriez vouloir gérer l'erreur différemment ici, par exemple en définissant un état d'erreur
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectHike(Hike hike) {
    _selectedHike = hike;
    notifyListeners();
  }

  void clearFilters() {
    _currentFilters.clear();
    loadPaginatedHikesData(1, reset: false);
  }

  Future<void> loadNextPage() async {
    if (_nextPage != null) {
      await loadPaginatedHikesData(_nextPage!, reset: false);
    }
  }

  Future<void> loadPreviousPage() async {
    if (_previousPage != null) {
      await loadPaginatedHikesData(_previousPage!, reset: false);
    }
  }

  Future<void> refreshHikes() async {
    await loadPaginatedHikesData(1, filters: _currentFilters, reset: false);
  }

  void updateFilters(Map<String, dynamic> newFilters) {
    _currentFilters = newFilters;
    loadPaginatedHikesData(1, reset: false);
  }

  // Nouvelle méthode pour vérifier si des filtres sont appliqués
  bool get hasFilters => _currentFilters.isNotEmpty;

  // Nouvelle méthode pour obtenir une description des filtres appliqués
  String getAppliedFiltersDescription() {
    List<String> appliedFilters = [];

    if (_currentFilters.containsKey('difficulty')) {
      appliedFilters.add('Difficulté: ${_currentFilters['difficulty']}');
    }
    if (_currentFilters.containsKey('hiking_time')) {
      appliedFilters.add('Temps: ${_currentFilters['hiking_time']} minutes');
    }
    if (_currentFilters.containsKey('hike_distance')) {
      appliedFilters
          .add('Distance max: ${_currentFilters['hike_distance']} km');
    }

    return appliedFilters.join(', ');
  }
}
