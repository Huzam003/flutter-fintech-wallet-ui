import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/design_system.dart';
import '../widgets/animated_success_indicator.dart';

class RegistrationSuccessScreen extends StatelessWidget {
  const RegistrationSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Match the registration background color
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          '登録完了',
          style: GoogleFonts.inter(
            color: AppColors.primaryBlue,
            fontWeight: FontWeight.w700,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        backgroundColor:
            AppColors.background, // Match the registration background color
        elevation: 0,
        automaticallyImplyLeading: false, // Hide back button for success screen
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Centers elements vertically
            children: [
              const Spacer(flex: 2),

              // Animated Success Icon with decorative elements
              const AnimatedSuccessIndicator(),

              const SizedBox(height: 30),

              // Large White Success text
              Text(
                '登録完了',
                style: GoogleFonts.inter(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),

              const Spacer(flex: 2),

              // "Finish" Button - Matched style to Registration screen
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
                        borderRadius: BorderRadius.circular(
                          12,
                        ), // 12 for the rounded-rect look
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      // Navigate to home and clear the navigation stack
                      Navigator.of(
                        context,
                      ).pushNamedAndRemoveUntil('/home', (route) => false);
                    },
                    child: Text(
                      '完了',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 148), // Padding from bottom of screen
            ],
          ),
        ),
      ),
    );
  }
}
