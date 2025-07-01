import 'package:flutter/material.dart';
import 'package:storyapp/repository/auth_repository.dart';

import '../model/user.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository authRepository;
  User? _user;
  AuthProvider(this.authRepository);

  bool isLoadingLogin = false;
  bool isLoadingLogout = false;
  bool isLoadingRegister = false;
  bool _isInitialized = false;
  bool _isInitializing = false;
  bool get isInitialized => _isInitialized;
  bool isLoggedIn = false;
  User? get user => _user;
  String _message = "";
  String get message => _message;

  Future<bool> init() async {
    if (_isInitialized || _isInitializing) return isLoggedIn;

    _isInitializing = true;
    isLoggedIn = await authRepository.isLoggedIn();
    _isInitialized = true;
    _isInitializing = false;

    notifyListeners();
    return isLoggedIn;
  }

  Future<bool> login(String email, String password) async {
    isLoadingLogin = true;
    notifyListeners();

    try {
      _user = await authRepository.login(email, password);
      if (_user != null) {
        isLoggedIn = await authRepository.isLoggedIn();
        _message = "Login successful!";
      } else {
        _message = "Login failed. Please try again.";
      }
    } catch (e) {
      _message = e.toString();
      isLoggedIn = false;
    }

    isLoadingLogin = false;
    notifyListeners();
    return isLoggedIn;
  }

  Future<bool> logout() async {
    isLoadingLogout = true;
    notifyListeners();

    try {
      final logoutSuccess = await authRepository.logout();
      if (logoutSuccess) {
        await authRepository.deleteUser();
        _message = "Logout successful.";
      } else {
        _message = "Logout failed. Please try again.";
      }

      isLoggedIn = await authRepository.isLoggedIn();
    } catch (e) {
      _message = "An error occurred during logout: ${e.toString()}";
      isLoggedIn = false;
    }

    isLoadingLogout = false;
    notifyListeners();
    return isLoggedIn;
  }


  Future<bool> register(String username, String email, String password) async {
    isLoadingRegister = true;
    notifyListeners();

    try {
      final userState = await authRepository.register(username, email, password);
      _message = userState.message;

      return !userState.error;
    } catch (e) {
      _message = "An error occurred: ${e.toString()}";
      return false;
    } finally {
      isLoadingRegister = false;
      notifyListeners();
    }
  }


  Future<void> getUser() async {
    isLoadingRegister = true;
    _user = await authRepository.getUser();
    isLoadingRegister = false;
    notifyListeners();
  }
}
