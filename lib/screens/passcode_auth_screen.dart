import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/design_system.dart';
import '../widgets/number_keypad.dart';

class PasscodeAuthScreen extends StatefulWidget {
  const PasscodeAuthScreen({super.key});

  @override
  State<PasscodeAuthScreen> createState() => _PasscodeAuthScreenState();
}

class _PasscodeAuthScreenState extends State<PasscodeAuthScreen> {
  final TextEditingController _controller = TextEditingController();
  String _passcode = '';
  bool _showLastChar = false;
  Timer? _hideTimer;

  @override
  void dispose() {
    _hideTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _updateDisplay() {
    final display = _passcode.isEmpty
        ? ''
        : _showLastChar
        ? '•' * (_passcode.length - 1) + _passcode[_passcode.length - 1]
        : '•' * _passcode.length;
    _controller.value = TextEditingValue(
      text: display,
      selection: TextSelection.collapsed(offset: display.length),
    );
  }

  void _onKeyPressed(String value) {
    if (_passcode.length >= 4) return;

    _hideTimer?.cancel();
    setState(() {
      _passcode += value;
      _showLastChar = true;
      _updateDisplay();
    });

    _hideTimer = Timer(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() {
          _showLastChar = false;
          _updateDisplay();
        });
      }
    });
  }

  void _onBackspace() {
    if (_passcode.isEmpty) return;

    _hideTimer?.cancel();
    setState(() {
      _passcode = _passcode.substring(0, _passcode.length - 1);
      _showLastChar = false;
      _updateDisplay();
    });
  }

  void _verifyPasscode() {
    if (_passcode.length != 4) return;

    final args = ModalRoute.of(context)?.settings.arguments;
    final purpose = args is Map ? args['purpose'] as String? : null;
    final email = args is Map ? args['email'] as String? : null;
    final resetSource = args is Map ? args['resetSource'] as String? : null;

    if (purpose == 'password_reset') {
      Navigator.of(context).pushReplacementNamed(
        '/otp',
        arguments: {
          'email': email ?? '',
          'isPasswordReset': true,
          'resetSource': resetSource,
        },
      );
      return;
    }

    Navigator.of(
      context,
    ).pushReplacementNamed('/processing', arguments: 'payment');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'パスコード認証',
          style: GoogleFonts.inter(
            color: AppColors.primaryBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.primaryBlue),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 40),

          // Instructions
          Text(
            'パスコードの入力をお願いします',
            style: GoogleFonts.inter(fontSize: 16, color: Colors.white),
          ),

          const SizedBox(height: 40),

          // Passcode input
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: TextField(
              controller: _controller,
              readOnly: true,
              style: GoogleFonts.inter(color: Colors.white, fontSize: 24),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF0D1B2A),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primaryBlue),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primaryBlue),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primaryBlue),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
              ),
            ),
          ),

          const SizedBox(height: 40),

          // Confirm button
          Center(
            child: SizedBox(
              width: 287,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _passcode.length == 4
                      ? AppColors.primaryBlue
                      : const Color(0xFF2C2C2E),
                  disabledBackgroundColor: const Color(0xFF2C2C2E),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                onPressed: _passcode.length == 4 ? _verifyPasscode : null,
                child: Text(
                  '完了確認',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _passcode.length == 4
                        ? Colors.white
                        : Colors.white24,
                  ),
                ),
              ),
            ),
          ),

          const Spacer(),

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
}
