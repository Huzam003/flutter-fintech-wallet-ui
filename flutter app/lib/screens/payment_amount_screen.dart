import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/design_system.dart';
import '../widgets/number_keypad.dart';

class PaymentAmountScreen extends StatefulWidget {
  final String? merchantData;

  const PaymentAmountScreen({super.key, this.merchantData});

  @override
  State<PaymentAmountScreen> createState() => _PaymentAmountScreenState();
}

class _PaymentAmountScreenState extends State<PaymentAmountScreen> {
  String _amount = '';
  final int _currentBalance = 10000;

  bool get _isValid =>
      _amount.isNotEmpty &&
      int.tryParse(_amount) != null &&
      int.parse(_amount) > 0 &&
      int.parse(_amount) <= _currentBalance;

  void _onKeyPressed(String value) {
    setState(() {
      if (_amount.length < 7) {
        // Max 7 digits
        _amount += value;
      }
    });
  }

  void _onBackspace() {
    setState(() {
      if (_amount.isNotEmpty) {
        _amount = _amount.substring(0, _amount.length - 1);
      }
    });
  }

  void _proceed() {
    if (!_isValid) return;

    // Navigate to biometric auth with payment details
    Navigator.of(context).pushNamed(
      '/biometric-auth',
      arguments: {'amount': int.parse(_amount), 'merchant': _getMerchantName()},
    );
  }

  String _getMerchantName() {
    if (widget.merchantData != null && widget.merchantData!.isNotEmpty) {
      // In real app, parse merchant name from QR data
      return 'Abcストア';
    }
    return 'Abcストア';
  }

  String get _formattedAmount {
    if (_amount.isEmpty) return '0';
    return int.parse(_amount).toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          '支払い処理中',
          style: GoogleFonts.inter(
            color: AppColors.primaryBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.primaryBlue,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 30),

                  // Merchant name
                  Text(
                    '${_getMerchantName()}でのお支払い',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Amount label
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'ポイントを入力',
                      style: GoogleFonts.inter(
                        color: AppColors.primaryBlue,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Amount display
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D1B2A),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primaryBlue),
                    ),
                    child: Text(
                      _formattedAmount,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Current balance
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '現在の残高 ${_formatNumber(_currentBalance)}P',
                      style: GoogleFonts.inter(
                        color: Colors.grey[500],
                        fontSize: 12,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Pay button
                  Center(
                    child: SizedBox(
                      width: 287,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: _isValid ? _proceed : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isValid
                              ? AppColors.primaryBlue
                              : const Color(0xFF2C2C2E),
                          disabledBackgroundColor: const Color(0xFF2C2C2E),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'ポイントで支払う',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _isValid ? Colors.white : Colors.white24,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Numpad
          _buildNumpad(),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildNumpad() {
    return NumberKeypad(onKeyPressed: _onKeyPressed, onBackspace: _onBackspace);
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
  }
}
