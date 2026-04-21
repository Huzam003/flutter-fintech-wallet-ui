import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/design_system.dart';
import '../widgets/loading_spinner.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  bool get _isValid => _emailController.text.contains('@');

  Future<void> _sendCode() async {
    if (!_isValid) return;

    setState(() => _isLoading = true);

    // Simulate sending code
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() => _isLoading = false);
      // Navigate to OTP with reset password flag
      Navigator.of(context).pushNamed(
        '/otp',
        arguments: {'email': _emailController.text, 'isPasswordReset': true},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const SizedBox.shrink(),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.primaryBlue),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Logo
            Center(
              child: Image.asset('assets/icons/fts_logo.png', height: 148),
            ),

            const SizedBox(height: 12),

            Text(
              'パスワードを再設定',
              style: GoogleFonts.inter(
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 72),

            // Instructions
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'ご登録のメールアドレスを入力してください。',
                style: GoogleFonts.inter(fontSize: 14, color: Colors.white),
                textAlign: TextAlign.left,
              ),
            ),

            const SizedBox(height: 24),

            // Email field
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              style: GoogleFonts.inter(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'example@gmail.com',
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

            const SizedBox(height: 12),

            // Helper text
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '確認コードを送信します。',
                style: GoogleFonts.inter(fontSize: 13, color: Colors.white),
                textAlign: TextAlign.left,
              ),
            ),

            const SizedBox(height: 120),

            // Send button
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
                  onPressed: _isValid && !_isLoading ? _sendCode : null,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: LoadingSpinner(
                            size: 20,
                            dotRadius: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          '確認コードを送信',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _isValid ? Colors.white : Colors.white24,
                          ),
                        ),
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
