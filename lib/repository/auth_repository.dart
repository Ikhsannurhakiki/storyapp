import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../model/auth_response.dart';
import '../model/user.dart';

class AuthRepository {
  final SharedPreferences _pref;
  final String stateKey = "state";
  final String userKey = "user";
  static const String _baseUrl = "https://story-api.dicoding.dev/v1";

  AuthRepository(this._pref);

  Future<User> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/login"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"email": email, "password": password}),
    );

    final data = jsonDecode(response.body);
    print(password);
    if (response.statusCode == 200 || response.statusCode == 201) {
      final loginResult = data['loginResult'];
      final user = User.fromMap(loginResult);
      _pref.setBool(stateKey, true);
      saveUser(user);
      return user;
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Failed to login');

    }

  }

  Future<bool> saveUser(User user) async {
    return _pref.setString(userKey, user.toJson());
  }

  Future<bool> deleteUser() async{
    return _pref.remove(userKey);
  }


  Future<User?> getUser() async {
    await Future.delayed(const Duration(seconds: 2));
    final json = _pref.getString(userKey) ?? "";
    User? user;
    try {
      user = User.fromJson(json);
    } catch (e) {
      user = null;
    }
    return user;
  }

  Future<RegisterResponse> register(
    String name,
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/register"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"name": name, "email": email, "password": password}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return RegisterResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to register: ${response.body}');
    }
  }

  Future<bool> isLoggedIn() async {
    await Future.delayed(const Duration(seconds: 2));
    return _pref.getBool(stateKey) ?? false;
  }

  Future<bool> logout() async {
    await Future.delayed(const Duration(seconds: 2));
    return _pref.setBool(stateKey, false);
  }

  Future<String?> getToken() => getUser().then((user) => user?.token);

}
