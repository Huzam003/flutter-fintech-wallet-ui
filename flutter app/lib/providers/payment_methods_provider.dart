import 'package:flutter/foundation.dart';

/// Provider for managing registered payment methods
/// Persists bank account and credit card registration state
class PaymentMethodsProvider with ChangeNotifier {
  bool _hasBankAccount = false;
  bool _hasCreditCard = false;

  // Bank account details
  String? _bankName;
  String? _accountNumber;

  // Credit card details
  String? _cardNumber;

  // Getters
  bool get hasBankAccount => _hasBankAccount;
  bool get hasCreditCard => _hasCreditCard;
  String? get bankName => _bankName;
  String? get bankAccountLast4 =>
      _accountNumber?.length != null && _accountNumber!.length >= 4
      ? '••••${_accountNumber!.substring(_accountNumber!.length - 4)}'
      : null;
  String? get cardLast4 =>
      _cardNumber?.length != null && _cardNumber!.length >= 4
      ? '••••${_cardNumber!.substring(_cardNumber!.length - 4)}'
      : null;

  /// Register a bank account
  Future<void> registerBankAccount({
    required String bankName,
    required String branchName,
    required String accountNumber,
    required String accountType,
    required String holderName,
  }) async {
    // Perform any async persistence or API call here if needed.
    _bankName = bankName;
    _accountNumber = accountNumber;
    _hasBankAccount = true;
    notifyListeners();
    // ensure this method is async-compatible for callers
    return Future.value();
  }

  /// Register a credit card
  void registerCreditCard({
    required String cardNumber,
    required String expiry,
    required String holderName,
  }) {
    _cardNumber = cardNumber.replaceAll(' ', '');
    _hasCreditCard = true;
    notifyListeners();
  }

  /// Remove bank account
  void removeBankAccount() {
    _bankName = null;
    _accountNumber = null;
    _hasBankAccount = false;
    notifyListeners();
  }

  /// Remove credit card
  void removeCreditCard() {
    _cardNumber = null;
    _hasCreditCard = false;
    notifyListeners();
  }
}
