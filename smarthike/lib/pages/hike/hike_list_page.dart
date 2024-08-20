import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarthike/components/hike/custom_app_bar.dart';
import 'package:smarthike/components/hike/horizontal_card.dart';
import 'package:smarthike/constants.dart';
import 'package:smarthike/providers/hike_paginated_provider.dart';

class HikeListPage extends StatefulWidget {
  final VoidCallback onDetailsPressed;
  final VoidCallback onFilterButtonPressed;

  const HikeListPage({
    super.key,
    required this.onFilterButtonPressed,
    required this.onDetailsPressed,
  });

  @override
  HikeListPageState createState() => HikeListPageState();
}

class HikeListPageState extends State<HikeListPage> {
  final ScrollController _scrollController = ScrollController();
  late VoidCallback onDetailsPressed;

  @override
  void initState() {
    super.initState();
    onDetailsPressed = widget.onDetailsPressed;
    Future.delayed(Duration.zero, () {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final hikeProvider = Provider.of<HikeProvider>(context, listen: false);
        hikeProvider.loadPaginatedHikesData(1);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.thirdColor,
      appBar: CustomAppBar(
        onFilterButtonPressed: widget.onFilterButtonPressed,
        isHikeListPage: true,
      ),
      body: Consumer<HikeProvider>(
        builder: (context, hikeProvider, child) {
          final hikes = hikeProvider.hikes;
          return NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (!hikeProvider.isLoading &&
                  scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent &&
                  hikeProvider.currentPage < hikeProvider.totalPages) {
                hikeProvider
                    .loadPaginatedHikesData(hikeProvider.currentPage + 1);
              }
              return false;
            },
            child: ListView.builder(
              controller: _scrollController,
              itemCount: hikes.length + 1,
              itemBuilder: (context, index) {
                if (index == hikes.length) {
                  return _buildProgressIndicator(hikeProvider.isLoading);
                } else {
                  final hike = hikes[index];
                  return HorizontalCard(
                    key: Key(hike.id.toString()),
                    hike: hike,
                    onPressed: () {
                      hikeProvider.selectHike(hike);
                      onDetailsPressed();
                    },
                  );
                }
              },
            ),
          );
        },
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

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildProgressIndicator(bool isLoading) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 100.0),
      child: Center(
        child: isLoading
            ? const CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(Constants.secondaryColor),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}
