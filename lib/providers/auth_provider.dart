import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  User? get user => _authService.currentUser;
  bool get isLoggedIn => _authService.isLoggedIn;

  Future<void> initialize() async {
    await _authService.initializeAuth();
  }

  Future<bool> login(String email, String password) async {
    debugPrint('AuthProvider: login called with email=$email');
    try {
      final success = await _authService.login(email, password);
      debugPrint('AuthProvider: login result=$success');
      notifyListeners();
      return success;
    } catch (e) {
      debugPrint('AuthProvider: login error=$e');
      return false;
    }
  }

  Future<bool> biometricLogin() async {
    final success = await _authService.biometricLogin();
    notifyListeners();
    return success;
  }

  Future<bool> register(
    String email,
    String password,
    String confirmPassword,
    String name,
    String furigana,
    String phoneNumber,
  ) async {
    final success = await _authService.register(
      email,
      password,
      confirmPassword,
      name,
      furigana,
      phoneNumber,
    );
    notifyListeners();
    return success;
  }

  Future<bool> verifyOTP(String otp) async {
    final success = await _authService.verifyOTP(otp);
    notifyListeners();
    return success;
  }

  Future<bool> updateProfile({
    required String name,
    required String furigana,
    required String phoneNumber,
    required String email,
  }) async {
    final success = await _authService.updateProfile(
      name: name,
      furigana: furigana,
      phoneNumber: phoneNumber,
      email: email,
    );
    notifyListeners();
    return success;
  }

  Future<bool> updatePassword(String password) async {
    final success = await _authService.updatePassword(password);
    notifyListeners();
    return success;
  }

  void logout() {
    _authService.logout();
    notifyListeners();
  }
}
