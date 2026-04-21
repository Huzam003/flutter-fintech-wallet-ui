import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/design_system.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text('ポイント支払い', style: AppTextStyles.headlineMedium),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.primaryBlue),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
        child: Column(
          children: [
             // QR Code Placeholder
             Container(
               width: 200,
               height: 200,
               decoration: BoxDecoration(
                 color: Colors.white, // QR code needs white usually
                 borderRadius: BorderRadius.circular(16),
               ),
               child: Center(
                 child: Icon(Icons.qr_code_2, size: 150, color: Colors.black),
               ),
             ),
             const SizedBox(height: 20),
             const Text(
               'お店のQRコードをスキャン',
               style: TextStyle(color: Colors.white, fontSize: 16),
             ),
             
             const Spacer(),
             
             // Amount Input
             TextField(
               controller: _amountController,
               textAlign: TextAlign.center,
               style: GoogleFonts.inter(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
               decoration: InputDecoration(
                 hintText: '0',
                 hintStyle: TextStyle(color: Colors.grey[700]),
                 prefix: const Text('¥ ', style: TextStyle(color: AppColors.primaryBlue, fontSize: 40)),
                 filled: false,
                 border: InputBorder.none,
               ),
               keyboardType: TextInputType.number,
             ),
             
             const SizedBox(height: 40),
             
             ElevatedButton.icon(
               onPressed: () {},
               icon: const Icon(Icons.qr_code_scanner),
               label: const Text('スキャンして支払う'), // "Scan to pay"
               style: ElevatedButton.styleFrom(
                 minimumSize: const Size(double.infinity, 56),
                 backgroundColor: AppColors.primaryBlue,
                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
               ),
             )
          ],
        ),
      ),
    );
  }
}
