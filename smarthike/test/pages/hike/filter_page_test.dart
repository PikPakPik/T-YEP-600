import 'package:flutter_test/flutter_test.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarthike/providers/filter_provider.dart';

class MockFilterProvider extends Mock implements FilterProvider {
  @override
  Map<String, dynamic> get filters => <String, dynamic>{};

  @override
  String get cityName => '';
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });
}
