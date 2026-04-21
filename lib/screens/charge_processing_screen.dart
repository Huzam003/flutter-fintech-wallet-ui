import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/design_system.dart';
import '../widgets/loading_spinner.dart';

class ChargeProcessingScreen extends StatefulWidget {
  final int amount;
  final String method;

  const ChargeProcessingScreen({
    super.key,
    required this.amount,
    required this.method,
  });

  @override
  State<ChargeProcessingScreen> createState() => _ChargeProcessingScreenState();
}

class _ChargeProcessingScreenState extends State<ChargeProcessingScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(
          '/charge-success',
          arguments: {'amount': widget.amount, 'method': widget.method},
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'チャージ処理中',
          style: GoogleFonts.inter(
            color: AppColors.primaryBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 120,
              height: 120,
              child: LoadingSpinner(
                size: 120,
                dotRadius: 14,
                color: AppColors.primaryBlue,
                duration: Duration(milliseconds: 900),
              ),
            ),

            const SizedBox(height: 60),

            Text(
              'チャージ処理中です。',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '完了するまで画面を閉じないでください。',
              style: GoogleFonts.inter(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
