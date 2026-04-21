import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/user.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/foundation.dart'; // For debugPrint

class AuthService {
  static final AuthService _instance = AuthService._internal();

  factory AuthService() {
    return _instance;
  }

  AuthService._internal();

  User? _currentUser;

  User? get currentUser => _currentUser;

  bool get isLoggedIn => _currentUser != null;

  Future<void> initializeAuth() async {
    // Load dummy user data from assets
    try {
      final String jsonString = await rootBundle.loadString('assets/data/dummy_users.json');
      // For initialization, we just verify the dummy data exists by loading it
      jsonDecode(jsonString);
    } catch (e) {
      debugPrint('Error loading dummy users: $e');
    }
  }

  Future<bool> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Accept any non-empty credentials for testing
    // Original test account: user@example.com / password123
    if (email.isNotEmpty && password.isNotEmpty) {
      _currentUser = User(
        id: '1',
        email: email,
        password: password,
        isVerified: true,
        balance: 10000.0,
      );
      return true;
    }
    return false;
  }

  Future<bool> biometricLogin() async {
    try {
      final LocalAuthentication auth = LocalAuthentication();
      final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
      final bool canAuthenticate = canAuthenticateWithBiometrics || await auth.isDeviceSupported();

      if (!canAuthenticate) {
        debugPrint('Device not supported for biometrics');
        return false;
      }

      final bool didAuthenticate = await auth.authenticate(
        localizedReason: 'ログインするには認証してください',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false, // Allow PIN/Pattern as backup
        ),
      );

      if (didAuthenticate) {
          // Log in as the default dummy user
          _currentUser = User(
            id: '1',
            email: 'user@example.com',
            password: 'password123',
            isVerified: true,
            balance: 10000.0,
          );
          return true;
      }
      return false;
    } catch (e) {
      debugPrint('Biometric error: $e');
      return false;
    }
  }

  Future<bool> register(
      String email,
      String password,
      String confirmPassword,
      String name,
      String furigana,
      String phoneNumber) async {
    if (password != confirmPassword) {
      return false;
    }

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    _currentUser = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email,
      password: password,
      name: name,
      furigana: furigana,
      phoneNumber: phoneNumber,
      isVerified: false,
      balance: 0.0,
    );
    return true;
  }

  Future<bool> updateProfile({
    required String name,
    required String furigana,
    required String phoneNumber,
    required String email,
  }) async {
    if (_currentUser == null) return false;

    _currentUser = _currentUser!.copyWith(
      name: name,
      furigana: furigana,
      phoneNumber: phoneNumber,
      email: email,
    );
    return true;
  }

  Future<bool> updatePassword(String password) async {
    if (_currentUser == null) return false;

    _currentUser = _currentUser!.copyWith(password: password);
    return true;
  }

  void logout() {
    _currentUser = null;
  }

  Future<bool> verifyOTP(String otp) async {
    // Dummy OTP verification
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (otp.length == 6) {
      _currentUser = _currentUser?.copyWith(isVerified: true);
      return true;
    }
    return false;
  }
}
