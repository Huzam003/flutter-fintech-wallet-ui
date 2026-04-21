import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/animated_success_indicator.dart';
import '../theme/design_system.dart';

class ChargeSuccessScreen extends StatefulWidget {
  final String type;
  final int? amount;
  final String? method;
  final String? customMessage;

  const ChargeSuccessScreen({
    super.key,
    this.type = 'charge',
    this.amount,
    this.method,
    this.customMessage,
  });

  @override
  State<ChargeSuccessScreen> createState() => _ChargeSuccessScreenState();
}

class _ChargeSuccessScreenState extends State<ChargeSuccessScreen> {
  String get _title {
    switch (widget.type) {
      case 'charge':
        return 'チャージ完了';
      case 'registration':
        return '登録完了';
      default:
        return '完了';
    }
  }

  String get _message {
    if (widget.customMessage != null) return widget.customMessage!;
    switch (widget.type) {
      case 'charge':
        return 'チャージが完了しました';
      case 'registration':
        return '登録が完了しました';
      default:
        return '処理が完了しました';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use registration-style layout for registration success or bank transfers
    if (widget.type == 'registration' || widget.method == 'bank') {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(
            _title,
            style: GoogleFonts.inter(
              color: AppColors.primaryBlue,
              fontWeight: FontWeight.w700,
              fontSize: 24,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: AppColors.primaryBlue,
            ),
            onPressed: () =>
                Navigator.of(context).popUntil((route) => route.isFirst),
          ),
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
                  _message,
                  style: GoogleFonts.inter(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
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
                const SizedBox(height: 148),
              ],
            ),
          ),
        ),
      );
    }

    // Fallback to existing generic layout for other types
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          _title,
          style: GoogleFonts.inter(
            color: AppColors.primaryBlue,
            fontWeight: FontWeight.w700,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.primaryBlue),
          onPressed: () =>
              Navigator.of(context).popUntil((route) => route.isFirst),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              // Success icon with decorative dots
              const AnimatedSuccessIndicator(),

              const SizedBox(height: 30),

              // Success text
              Text(
                _message,
                style: GoogleFonts.inter(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),

              const Spacer(flex: 2),

              // Complete button
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
              const SizedBox(height: 148),
            ],
          ),
        ),
      ),
    );
  }
}
