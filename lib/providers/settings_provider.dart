import 'package:flutter/material.dart';

class SettingsProvider with ChangeNotifier {
  bool _isBiometricEnabled = false;
  bool _isPasscodeEnabled = false;
  bool _isOtpEnabled = false;

  bool get isBiometricEnabled => _isBiometricEnabled;
  bool get isPasscodeEnabled => _isPasscodeEnabled;
  bool get isOtpEnabled => _isOtpEnabled;

  set isBiometricEnabled(bool value) {
    _isBiometricEnabled = value;
    notifyListeners();
    // In a real app, you would also save this preference to the device's storage.
    // e.g., using shared_preferences
  }

  set isPasscodeEnabled(bool value) {
    _isPasscodeEnabled = value;
    notifyListeners();
  }

  set isOtpEnabled(bool value) {
    _isOtpEnabled = value;
    notifyListeners();
  }
}
