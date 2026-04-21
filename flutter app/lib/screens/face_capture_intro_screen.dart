import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import '../theme/design_system.dart';
import 'face_capture_screen.dart';

class FaceCaptureIntroScreen extends StatelessWidget {
  const FaceCaptureIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          '顔写真の撮影（セルフィー）',
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 32),
              Text(
                '本人確認用の顔写真を撮影',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              const _FaceScanIllustration(),
              const Spacer(),
              Center(
                child: SizedBox(
                  width: 287,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const FaceCaptureScreen(),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      '開始',
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

class _FaceScanIllustration extends StatelessWidget {
  const _FaceScanIllustration();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/icons/face_scan_illustration.png',
      width: 280,
      height: 280,
      fit: BoxFit.contain,
    );
  }
}

