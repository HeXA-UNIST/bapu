import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LocalStorageService {
  static SharedPreferences? _preferences;

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future setValue(String key, dynamic value) async {
    String jsonString = jsonEncode(value);
    await _preferences?.setString(key, jsonString);
  }

  static dynamic getValue(String key, {dynamic defaultValue}) {
    String? jsonString = _preferences?.getString(key);
    if (jsonString == null || jsonString.isEmpty) {
      return defaultValue;
    } else {
      return jsonDecode(jsonString);
    }
  }
}
