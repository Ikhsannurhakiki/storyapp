import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  final SharedPreferences _preferences;

  SharedPreferencesService(this._preferences);

  static const String _keyIsDarkMode = 'isDarkMode';

  Future<void> saveTheme(bool isDark) async {
    try {
      await _preferences.setBool(_keyIsDarkMode, isDark);
    } catch (e) {
      throw Exception("Shared preferences cannot save the theme value.");
    }
  }

  Future<bool> getTheme() async {
    try {
      return _preferences.getBool(_keyIsDarkMode) ?? false;
    } catch (e) {
      throw Exception("Shared preferences cannot get the theme value.");
    }
  }
}
