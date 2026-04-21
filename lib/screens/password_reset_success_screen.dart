import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/design_system.dart';
import '../widgets/animated_success_indicator.dart';

class PasswordResetSuccessScreen extends StatelessWidget {
  final String? resetSource;

  const PasswordResetSuccessScreen({super.key, this.resetSource});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'パスワード更新完了',
          style: GoogleFonts.inter(
            color: AppColors.primaryBlue,
            fontWeight: FontWeight.w700,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.background,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              const AnimatedSuccessIndicator(),

              const SizedBox(height: 30),

              Text(
                'パスワードが更新されました。',
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              Text(
                '新しいパスワードでログイン',
                style: GoogleFonts.inter(fontSize: 24, color: Colors.white),
                textAlign: TextAlign.center,
              ),

              const Spacer(flex: 2),

              Center(
                child: SizedBox(
                  width: 287,
                  height: 60,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      final target = resetSource == 'profile' ? '/home' : '/login';
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        target,
                        (route) => false,
                      );
                    },
                    child: Text(
                      resetSource == 'profile' ? 'ホームへ戻る' : 'ログインへ',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 148),
            ],
          ),
        ),
      ),
    );
  }
}
