import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtil {
  static SharedPreferencesUtil instance = SharedPreferencesUtil._();

  SharedPreferencesUtil._();

  Future<void> setString(String? key, String? value) async {
    if (key == null || value == null) {
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future<String?> getString(String? key) async {
    if (key == null) {
      return null;
    }
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }
}
