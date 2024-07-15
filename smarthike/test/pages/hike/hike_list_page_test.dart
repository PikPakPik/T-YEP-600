import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarthike/pages/hike/hike_list_page.dart';
import 'package:smarthike/providers/hike_provider.dart';
import 'package:smarthike/data/hike/mock_list_hikes_data.dart';

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
    when(hikeProvider.currentPage).thenReturn(1);
    when(hikeProvider.totalPages).thenReturn(1);

    // Build the widget tree
    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('fr'), Locale('es')],
        path: 'assets/locales',
        fallbackLocale: const Locale('en'),
        child: ChangeNotifierProvider<HikeProvider>(
          create: (_) => hikeProvider,
          child: const MaterialApp(
            home: HikeListPage(),
          ),
        ),
      ),
    );

    // Trigger a frame
    await tester.pumpAndSettle();

    // Verify the hikes info is displayed initially
    for (final hike in mockData.items) {
      await tester.dragUntilVisible(
        find.text(hike.name),
        find.byType(ListView),
        const Offset(0, -300),
      );
      expect(find.text(hike.name), findsOneWidget);
    }
  });
}
