import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/payment_methods_provider.dart';
import '../theme/design_system.dart';

class ChargeScreen extends StatefulWidget {
  const ChargeScreen({super.key});

  @override
  State<ChargeScreen> createState() => _ChargeScreenState();
}

class _ChargeScreenState extends State<ChargeScreen> {
  void _onMethodSelected(String methodId) {
    final paymentMethods = context.read<PaymentMethodsProvider>();

    // Check if payment method is registered
    if (methodId == 'bank' && !paymentMethods.hasBankAccount) {
      _showRegisterPrompt('銀行口座', '/register-bank');
      return;
    }
    if (methodId == 'card' && !paymentMethods.hasCreditCard) {
      _showRegisterPrompt('クレジットカード', '/register-credit-card');
      return;
    }

    // Navigate to amount selection screen (full-screen, root navigator).
    Navigator.of(context).pushNamed('/charge-amount', arguments: methodId);
  }

  void _showRegisterPrompt(String type, String route) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF0D1B2A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          '$typeを登録',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'この支払い方法を使用するには、まず$typeを登録してください。',
          style: GoogleFonts.inter(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('キャンセル', style: GoogleFonts.inter(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              padding: const EdgeInsets.all(8.0),
            ),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
              Navigator.of(context, rootNavigator: true).pushNamed(route);
            },
            child: Text(
              '登録する',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'チャージ方法選択',
          style: GoogleFonts.inter(
            color: AppColors.primaryBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.background,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Bank Transfer Option
              _buildMethodCard(
                icon: Icons.account_balance,
                label: 'Bank Transfer',
                methodId: 'bank',
              ),

              const SizedBox(height: 16),

              // Credit Card Option
              _buildMethodCard(
                icon: Icons.credit_card,
                label: 'Credit card',
                methodId: 'card',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMethodCard({
    required IconData icon,
    required String label,
    required String methodId,
  }) {
    return GestureDetector(
      onTap: () => _onMethodSelected(methodId),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        decoration: BoxDecoration(
          color: const Color(0xFF0D1B2A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: AppColors.primaryBlue,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
