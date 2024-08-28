import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarthike/pages/hike/hike_list_page.dart';
import 'package:smarthike/providers/hike_paginated_provider.dart';
import 'package:smarthike/providers/filter_provider.dart';
import '../../data/hike/mock_list_hikes_data.dart';

import 'hike_list_page_test.mocks.dart';

@GenerateMocks([HikeProvider, FilterProvider])
void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  await EasyLocalization.ensureInitialized();

  late MockHikeProvider mockHikeProvider;
  late MockFilterProvider mockFilterProvider;

  setUp(() {
    mockHikeProvider = MockHikeProvider();
    mockFilterProvider = MockFilterProvider();
  });

  Widget createTestWidget({required Widget child}) {
    return EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('fr'), Locale('es')],
      path: 'assets/locales',
      fallbackLocale: const Locale('en'),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<HikeProvider>.value(value: mockHikeProvider),
          ChangeNotifierProvider<FilterProvider>.value(
              value: mockFilterProvider),
        ],
        child: MaterialApp(home: child),
      ),
    );
  }

  testWidgets('ListHikePage shows hikes info', (WidgetTester tester) async {
    final mockData = getMockHikesData();

    when(mockHikeProvider.hikes).thenReturn(mockData.items);
    when(mockHikeProvider.isLoading).thenReturn(false);
    when(mockHikeProvider.currentPage).thenReturn(mockData.currentPage);
    when(mockHikeProvider.totalPages).thenReturn(mockData.totalPages);
    when(mockFilterProvider.filters).thenReturn({});
    when(mockFilterProvider.hasActiveFilters).thenReturn(false);

    await tester.pumpWidget(
      createTestWidget(
        child: HikeListPage(
          onFilterButtonPressed: () {},
          onDetailsPressed: () {},
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify the ListView is present
    expect(find.byType(ListView), findsOneWidget);

    // Verify at least one hike name is displayed
    expect(find.text(mockData.items.first.name), findsOneWidget);

    // Optional: Verify that multiple hike names are displayed
    expect(
        find.byWidgetPredicate((widget) =>
            widget is Text &&
            mockData.items.any((hike) => hike.name == widget.data)),
        findsWidgets);
  });
}
