import 'package:shared_preferences/shared_preferences.dart';

class SharePrefs {
  static void setValue(String key, bool value) async {
    await SharedPreferences.getInstance()
        .then((pref) => pref.setBool(key, value));
  }

  static Future<bool> getValue(String key) async {
    return await SharedPreferences.getInstance()
        .then((pref) => pref.getBool(key) ?? false);
  }
}
