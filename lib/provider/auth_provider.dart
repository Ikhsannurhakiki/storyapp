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

  Future<void> login(String email, String password) async {
    isLoadingLogin = true;
    _user = await authRepository.login(email, password);
    if (_user != null) {
      isLoggedIn = true;
    }
    notifyListeners();
    isLoadingLogin = false;
    notifyListeners();
  }

  // Future<bool> logout() async {
  //   isLoadingLogout = true;
  //   notifyListeners();
  //   final logout = await authRepository.logout();
  //   if (logout) {
  //     await authRepository.deleteUser();
  //   }
  //   isLoggedIn = await authRepository.isLoggedIn();
  //   isLoadingLogout = false;
  //   notifyListeners();
  //   return !isLoggedIn;
  // }

  Future<bool> register(username, email, password) async {
    isLoadingRegister = true;
    notifyListeners();
    final userState = await authRepository.register(username, email, password);
    isLoadingRegister = false;
    notifyListeners();
    return userState.error;
  }

  Future<bool> getUser() async {
    isLoadingRegister = true;
    _user = await authRepository.getUser();
    if (_user != null) {
      isLoggedIn = true;
    }else{
       isLoggedIn = false;
    }
    isLoadingRegister = false;
    _isInitialized = true;
    notifyListeners();
    return isLoggedIn;
  }
}
