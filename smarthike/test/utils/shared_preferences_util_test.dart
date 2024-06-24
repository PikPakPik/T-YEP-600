import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarthike/utils/shared_preferences_util.dart';

void main() {
  SharedPreferencesUtil sharedPreferencesUtil;

  setUp(() {
    sharedPreferencesUtil = SharedPreferencesUtil.instance;
  });

  test('set and get string', () async {
    SharedPreferences.setMockInitialValues({});
    sharedPreferencesUtil = SharedPreferencesUtil.instance;
    await sharedPreferencesUtil.setString('key', 'value');
    final value = await sharedPreferencesUtil.getString('key');
    expect(value, 'value');
  });
  test('get null for non-existing key', () async {
    SharedPreferences.setMockInitialValues({});
    sharedPreferencesUtil = SharedPreferencesUtil.instance;
    final value = await sharedPreferencesUtil.getString('non_existing_key');
    expect(value, isNull);
  });
}
