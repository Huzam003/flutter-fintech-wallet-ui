import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../theme/design_system.dart';

class SetPasswordScreen extends StatefulWidget {
  final bool isReset;

  const SetPasswordScreen({super.key, this.isReset = false});

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool get _isResetFlow {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map && args['isReset'] == true) {
      return true;
    }
    return widget.isReset;
  }

  String? get _resetSource {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map) {
      return args['resetSource'] as String?;
    }
    return null;
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  bool get _hasLetter => RegExp(r'[a-zA-Z]').hasMatch(_passwordController.text);
  bool get _hasNumber => RegExp(r'[0-9]').hasMatch(_passwordController.text);
  bool get _hasSymbol =>
      RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(_passwordController.text);
  bool get _isLengthValid => _passwordController.text.length >= 8;
  bool get _passwordsMatch =>
      _passwordController.text == _confirmController.text &&
      _confirmController.text.isNotEmpty;

  bool get _isValid =>
      _hasLetter &&
      _hasNumber &&
      _hasSymbol &&
      _isLengthValid &&
      _passwordsMatch;

  Future<void> _updatePassword() async {
    if (!_isValid) return;

    if (_isResetFlow) {
      await context.read<AuthProvider>().updatePassword(
        _passwordController.text,
      );
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(
        '/password-reset-success',
        arguments: {'resetSource': _resetSource},
      );
    } else {
      // Registration - go to auth setup
      Navigator.of(context).pushReplacementNamed('/set-up-auth');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          '新しいパスワードを設定',
          style: GoogleFonts.inter(
            color: AppColors.primaryBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.primaryBlue),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // New password label
            Text(
              '新しいパスワード',
              style: GoogleFonts.inter(fontSize: 14, color: Colors.white),
            ),
            const SizedBox(height: 8),

            // Password field
            TextField(
              controller: _passwordController,
              style: GoogleFonts.inter(color: Colors.white),
              obscureText: true,
              decoration: InputDecoration(
                hintText: '例.abc@12',
                hintStyle: GoogleFonts.inter(color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFF0D1B2A),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.primaryBlue),
                ),
              ),
              onChanged: (_) => setState(() {}),
            ),

            const SizedBox(height: 8),

            // Password hint
            Text(
              '8文字以上、英字・数字・記号を各1文字以上（大文字・小文字を区別）',
              style: GoogleFonts.inter(fontSize: 11, color: Colors.white70),
            ),

            const SizedBox(height: 24),

            // Confirm password label
            Text(
              'パスワードを認証',
              style: GoogleFonts.inter(fontSize: 14, color: Colors.white),
            ),
            const SizedBox(height: 8),

            // Confirm password field
            TextField(
              controller: _confirmController,
              style: GoogleFonts.inter(color: Colors.white),
              obscureText: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF0D1B2A),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.primaryBlue),
                ),
              ),
              onChanged: (_) => setState(() {}),
            ),

            const SizedBox(height: 24),

            // Password requirements
            _buildRequirement('英字を１文字以上', _hasLetter),
            const SizedBox(height: 8),
            _buildRequirement('数字を1文字以上', _hasNumber),
            const SizedBox(height: 8),
            _buildRequirement('記号を1文字以上', _hasSymbol),

            const SizedBox(height: 60),

            // Update button
            Center(
              child: SizedBox(
                width: 287,
                height: 60,
                child: ElevatedButton(
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
                  onPressed: _isValid ? _updatePassword : null,
                  child: Text(
                    'パスワードを更新',
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
    );
  }

  Widget _buildRequirement(String text, bool isMet) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: GoogleFonts.inter(fontSize: 13, color: Colors.white70),
      ),
    );
  }
}
