import 'package:flutter/material.dart';
import '../models/transaction.dart';

class TransactionProvider with ChangeNotifier {
  double _balance = 10000.0;
  final List<Transaction> _transactions = [
    Transaction(
      id: 'TXN123456789',
      amount: 10000.0,
      type: 'charge',
      method: 'bank',
      date: DateTime.now().subtract(const Duration(days: 3)),
      status: 'success',
      description: '初期残高チャージ',
    ),
    Transaction(
      id: 'TXN987654321',
      amount: 1000.0,
      type: 'payment',
      method: 'qr',
      date: DateTime.now().subtract(const Duration(days: 1)),
      status: 'success',
      description: 'コンビニ支払い',
    ),
  ];

  double get balance => _balance;
  List<Transaction> get transactions => List.unmodifiable(_transactions.reversed);

  void addTransaction({
    required double amount,
    required String type,
    required String method,
    String? description,
  }) {
    final newTransaction = Transaction(
      id: 'TXN${DateTime.now().millisecondsSinceEpoch}',
      amount: amount,
      type: type,
      method: method,
      date: DateTime.now(),
      status: 'success',
      description: description,
    );

    _transactions.add(newTransaction);
    
    if (type == 'charge') {
      _balance += amount;
    } else if (type == 'payment') {
      _balance -= amount;
    }

    notifyListeners();
  }
}
