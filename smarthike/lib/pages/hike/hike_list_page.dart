import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarthike/components/hike/custom_app_bar.dart';
import 'package:smarthike/components/hike/horizontal_card.dart';
import 'package:smarthike/constants.dart';
import 'package:smarthike/core/init/gen/translations.g.dart';
import 'package:smarthike/providers/hike_paginated_provider.dart';
import 'package:smarthike/providers/filter_provider.dart';

class HikeListPage extends StatefulWidget {
  final VoidCallback onDetailsPressed;
  final VoidCallback onFilterButtonPressed;

  const HikeListPage({
    super.key,
    required this.onFilterButtonPressed,
    required this.onDetailsPressed,
    Map<String, dynamic>? filters,
  });

  @override
  HikeListPageState createState() => HikeListPageState();
}

class HikeListPageState extends State<HikeListPage> {
  final ScrollController _scrollController = ScrollController();
  late HikeProvider _hikeProvider;
  late FilterProvider _filterProvider;
  bool _isInitialLoad = true;

  @override
  void initState() {
    super.initState();
    _hikeProvider = Provider.of<HikeProvider>(context, listen: false);
    _filterProvider = Provider.of<FilterProvider>(context, listen: false);

    _loadInitialHikes();

    _scrollController.addListener(_onScroll);
  }

  void _loadInitialHikes() {
    final filters = _filterProvider.filters;
    _hikeProvider.loadPaginatedHikesData(1, filters: filters, reset: true);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_hikeProvider.isLoading &&
        _hikeProvider.currentPage < _hikeProvider.totalPages) {
      _hikeProvider.loadPaginatedHikesData(
        _hikeProvider.currentPage + 1,
        filters: _filterProvider.filters,
        reset: false,
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialLoad) return;

    _filterProvider = Provider.of<FilterProvider>(context);
    _hikeProvider = Provider.of<HikeProvider>(context);

    _loadInitialHikes(); // Charger les randonnées avec les filtres
    _isInitialLoad = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.thirdColor,
      appBar: CustomAppBar(
          onFilterButtonPressed: widget.onFilterButtonPressed,
          isHikeListPage: true,
          hasActiveFilters: _filterProvider.hasActiveFilters,
          isFilterPage: false,
          onBackPressed: () {}),
      body: Column(
        children: [
          _buildResetFiltersButton(),
          Expanded(
            child: Consumer<HikeProvider>(
              builder: (context, hikeProvider, child) {
                final hikes = hikeProvider.hikes;

                if (hikeProvider.isLoading && hikes.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Constants.secondaryColor),
                    ),
                  );
                }

                if (hikes.isEmpty) {
                  return Center(
                    child: Text(
                      'Aucune randonnée trouvée.',
                      style: TextStyle(
                        color: Constants.secondaryColor,
                        fontSize: 18,
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    await _hikeProvider.loadPaginatedHikesData(1,
                        filters: _filterProvider.filters, reset: true);
                  },
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: hikes.length + (hikeProvider.isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == hikes.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Constants.secondaryColor),
                            ),
                          ),
                        );
                      } else {
                        final hike = hikes[index];
                        return HorizontalCard(
                          key: Key(hike.id.toString()),
                          hike: hike,
                          onPressed: () {
                            hikeProvider.selectHike(hike);
                            widget.onDetailsPressed();
                          },
                        );
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _scrollToTop,
        backgroundColor: Constants.primaryColor,
        child: const Icon(
          Icons.arrow_upward,
          color: Constants.secondaryColor,
        ),
      ),
    );
  }

  Widget _buildResetFiltersButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ElevatedButton(
        onPressed: () {
          final filterProvider =
              Provider.of<FilterProvider>(context, listen: false);
          filterProvider.resetFilters();
          _loadInitialHikes();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Constants.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          minimumSize: Size(120, 36),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.refresh, size: 18, color: Colors.black),
            SizedBox(width: 4),
            Text(
              tr(LocaleKeys.filter_hike_reset_filters),
              style: TextStyle(color: Colors.black, fontSize: 14.0),
            ),
          ],
        ),
      ),
    );
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
