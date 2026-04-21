import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/design_system.dart';
import '../widgets/number_keypad.dart';

class OTPScreen extends StatefulWidget {
  final String phoneNumber;

  const OTPScreen({super.key, this.phoneNumber = ''});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  Timer? _timer;
  final List<String> _otpDigits = ['', '', '', '', '', ''];
  int _currentIndex = 0;
  int _resendSeconds = 30;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_resendSeconds > 0) {
          _resendSeconds--;
        } else {
          _timer?.cancel();
          _canResend = true;
          _showErrorDialog();
        }
      });
    });
  }

  void _onKeyPressed(String value) {
    if (_resendSeconds == 0 && !_canResend) {
      return; // Prevent input if expired and not reset
    }

    setState(() {
      if (_currentIndex < 6) {
        _otpDigits[_currentIndex] = value;
        _currentIndex++;

        // Auto-submit when all digits are entered
        if (_currentIndex == 6) {
          _verifyOTP();
        }
      }
    });
  }

  void _onBackspace() {
    setState(() {
      if (_currentIndex > 0) {
        _currentIndex--;
        _otpDigits[_currentIndex] = '';
      }
    });
  }

  void _verifyOTP() {
    final otp = _otpDigits.join();
    // Mock verification - accept any 6 digit code
    if (otp.length == 6) {
      final args = ModalRoute.of(context)?.settings.arguments;
      bool isPasswordReset = false;
      String? resetSource;
      String? purpose;
      int? amount;
      if (args is Map) {
        isPasswordReset = args['isPasswordReset'] ?? false;
        resetSource = args['resetSource'] as String?;
        purpose = args['purpose'] as String?;
        amount = args['amount'] as int?;
      }

      if (isPasswordReset) {
        Navigator.of(context).pushReplacementNamed(
          '/set-password',
          arguments: {'isReset': true, 'resetSource': resetSource},
        );
      } else if (purpose == 'payment') {
        Navigator.of(context).pushReplacementNamed(
          '/processing',
          arguments: {'type': 'payment', 'amount': amount},
        );
      } else {
        // Registration OTP flow
        Navigator.of(context).pushReplacementNamed(
          '/set-up-auth',
          arguments: {'next': '/registration-success'},
        );
      }
    } else {
      _showErrorDialog();
    }
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: const Color(0xFF0D1B2A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        insetPadding: const EdgeInsets.all(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: AppColors.error,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      '認証コードが正しくないか、有効期限が切れています。',
                      style: GoogleFonts.inter(
                        color: AppColors.error,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Center(
                child: SizedBox(
                  width: 287,
                  height: 60,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _resendOTP();
                    },
                    child: Text(
                      'もう一度やり直してください',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _resendOTP() {
    setState(() {
      _resendSeconds = 30;
      _canResend = false;
      _otpDigits.fillRange(0, 6, '');
      _currentIndex = 0;
    });
    _startResendTimer();
  }

  String _getMaskedPhone() {
    if (widget.phoneNumber.isEmpty) {
      return '+81 *****00';
    }
    final phone = widget.phoneNumber;
    if (phone.length > 4) {
      return '+81 *****${phone.substring(phone.length - 2)}';
    }
    return '+81 *****00';
  }

  String _maskEmailSafe(String email) {
    if (email.isEmpty) return '';
    final parts = email.split('@');
    if (parts.length != 2) return email;
    final local = parts[0];
    final domain = parts[1];
    if (local.isEmpty) return email;
    final first = local.substring(0, 1);
    return '$first***@$domain';
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final bool isPasswordReset = args?['isPasswordReset'] == true;
    final String? email = args?['email'] as String?;
    return Scaffold(
      backgroundColor: AppColors
          .background, // Assumes background provided by main wrapper or theme
      appBar: AppBar(
        title: Text(
          'OTPの確認',
          style: GoogleFonts.inter(
            color: AppColors.primaryBlue,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
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
          const SizedBox(height: 50),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              isPasswordReset
                  ? (email != null && email.isNotEmpty
                        ? '${_maskEmailSafe(email)} に送信された確認コード（6桁）を入力してください。'
                        : 'パスワード再設定用の確認コード（6桁）を入力してください。')
                  : '${_getMaskedPhone()}にコードを送信済み',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              softWrap: true,
            ),
          ),

          const SizedBox(height: 50),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (index) => _buildOTPBox(index)),
            ),
          ),

          const SizedBox(height: 50),

          GestureDetector(
            onTap: _canResend ? _resendOTP : null,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'コードを再送します',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 14,
                        decoration: _canResend
                            ? TextDecoration.underline
                            : null,
                        decorationColor: Colors.white,
                      ),
                    ),
                    if (!_canResend) ...[
                      const SizedBox(width: 8),
                      Text(
                        '($_resendSeconds秒後)',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          const Spacer(),

          _buildNumpad(),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildOTPBox(int index) {
    final hasValue = _otpDigits[index].isNotEmpty;
    final isActive = index == _currentIndex;

    return Container(
      width: 44,
      height: 52,
      decoration: BoxDecoration(
        color: const Color(0xFF1B263B),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isActive ? AppColors.primaryBlue : Colors.transparent,
          width: isActive ? 2 : 0,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        hasValue ? _otpDigits[index] : '',
        style: GoogleFonts.inter(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildNumpad() {
    return NumberKeypad(onKeyPressed: _onKeyPressed, onBackspace: _onBackspace);
  }
}
