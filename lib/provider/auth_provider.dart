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
  bool get isInitialized => _isInitialized;
  bool isLoggedIn = false;
  User? get user => _user;

  Future<bool> init() async {
    isLoggedIn = await authRepository.isLoggedIn();
    print(isLoggedIn);
    _isInitialized = true;
    notifyListeners();
    return isLoggedIn;
  }

  Future<bool> login(String email, String password) async {
    isLoadingLogin = true;
    _user = await authRepository.login(email, password);
    if (_user != null) {
      isLoggedIn = await authRepository.isLoggedIn();
    }
    notifyListeners();
    isLoadingLogin = false;
    notifyListeners();
    return isLoggedIn;
  }

  Future<bool> logout() async {
    isLoadingLogout = true;
    notifyListeners();
    final logout = await authRepository.logout();
    if (logout) {
      await authRepository.deleteUser();
    }
    isLoggedIn = await authRepository.isLoggedIn();
    isLoadingLogout = false;
    notifyListeners();
    return isLoggedIn;
  }

  Future<bool> register(username, email, password) async {
    isLoadingRegister = true;
    notifyListeners();
    final userState = await authRepository.register(username, email, password);
    isLoadingRegister = false;
    notifyListeners();
    return userState.error;
  }

  Future<void> getUser() async {
    isLoadingRegister = true;
    _user = await authRepository.getUser();
    isLoadingRegister = false;
    _isInitialized = true;
    notifyListeners();
  }
}
