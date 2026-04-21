import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/design_system.dart';
import '../widgets/loading_spinner.dart';

class ProcessingScreen extends StatefulWidget {
  final String type;
  final int? amount;

  const ProcessingScreen({super.key, this.type = 'charge', this.amount});

  @override
  State<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends State<ProcessingScreen> {
  String get _title {
    switch (widget.type) {
      case 'payment':
        return '支払い処理中';
      case 'charge':
        return 'チャージ処理中';
      default:
        return '処理中';
    }
  }

  String get _message {
    switch (widget.type) {
      case 'payment':
        return '支払い処理中です。';
      case 'charge':
        return 'チャージ処理中です。';
      default:
        return '処理中です。';
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        if (widget.type == 'payment') {
          // Navigate to payment success
          Navigator.of(context).pushReplacementNamed(
            '/payment-success',
            arguments: {
              'amount': widget.amount ?? 1000,
              'transactionId': '123456789',
            },
          );
        } else {
          // Navigate to charge success
          Navigator.of(
            context,
          ).pushReplacementNamed('/charge-success', arguments: widget.type);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          _title,
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
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(),

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

              // Processing text
              Text(
                _message,
                style: GoogleFonts.inter(fontSize: 16, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                '完了するまで画面を閉じないでください。',
                style: GoogleFonts.inter(fontSize: 14, color: Colors.white70),
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
