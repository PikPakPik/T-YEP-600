import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarthike/pages/hike/hike_list_page.dart';
import 'package:smarthike/providers/hike_paginated_provider.dart';
import '../../data/hike/mock_list_hikes_data.dart';

import 'hike_list_page_test.mocks.dart';

@GenerateMocks([HikeProvider])
void main() async {
  SharedPreferences.setMockInitialValues({});
  await EasyLocalization.ensureInitialized();
  late MockHikeProvider hikeProvider;

  setUp(() {
    hikeProvider = MockHikeProvider();
  });

  testWidgets('ListHikePage shows hikes info', (WidgetTester tester) async {
    // Get mock data
    final mockData = getMockHikesData();

    // Mock the hikes property to return the mock data items
    when(hikeProvider.hikes).thenReturn(mockData.items);
    when(hikeProvider.isLoading).thenReturn(false);
    when(hikeProvider.currentPage).thenReturn(mockData.currentPage);
    when(hikeProvider.totalPages).thenReturn(mockData.totalPages);

    // Build the widget tree
    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('fr'), Locale('es')],
        path: 'assets/locales',
        fallbackLocale: const Locale('en'),
        child: ChangeNotifierProvider<HikeProvider>(
          create: (_) => hikeProvider,
          child: MaterialApp(
            home: HikeListPage(
              onFilterButtonPressed: () {
                // Add your filter button logic here for the test
              },
              onDetailsPressed: () {},
            ),
          ),
        ),
      ),
    );

    // Trigger a frame
    await tester.pumpAndSettle();

    // Verify the hikes info is displayed initially
    for (final hike in mockData.items) {
      await tester.dragUntilVisible(
        find.byKey(Key(hike.id.toString())),
        find.byType(ListView),
        const Offset(0, -300),
      );

      // Verify the hike name is displayed within the HorizontalCard
      expect(
        find.text(hike.name),
        findsOneWidget,
      );
    }
  });
}
