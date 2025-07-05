import 'package:flutter/material.dart';

import '../service/shared_preferences_service.dart';

class ProfileProvider extends ChangeNotifier{
  final SharedPreferencesService _service;

  ProfileProvider(this._service);

  bool isDark = false;
  String _message = '';
  String get message => _message;

  Future<void> saveTheme(bool isDark) async {
    try {
      await _service.saveTheme(isDark);
      isDark = isDark;
    } catch (e) {
      _message = e.toString();
    }
    notifyListeners();
  }

  Future<void> getTheme() async {
    try {
      isDark = await _service.getTheme();
    } catch (e) {
      _message = e.toString();
    }
    notifyListeners();
  }

}