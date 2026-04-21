import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/payment_methods_provider.dart';
import '../theme/design_system.dart';

class ChargeAmountScreen extends StatefulWidget {
  final String paymentMethod;

  const ChargeAmountScreen({super.key, required this.paymentMethod});

  @override
  State<ChargeAmountScreen> createState() => _ChargeAmountScreenState();
}

class _ChargeAmountScreenState extends State<ChargeAmountScreen> {
  final _amountController = TextEditingController();
  final List<int> _presetAmounts = [1000, 3000, 5000, 10000, 20000, 50000];
  String _selectedPayment = '';

  @override
  void initState() {
    super.initState();
    _selectedPayment = widget.paymentMethod;
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _onAmountSelected(int amount) {
    setState(() {
      _amountController.text = amount.toString();
    });
  }

  bool get _hasEnteredAmount => _amountController.text.isNotEmpty;

  bool _isPaymentMethodAvailable(
    PaymentMethodsProvider paymentMethods,
    String methodId,
  ) {
    if (methodId == 'bank') {
      return paymentMethods.hasBankAccount;
    }
    if (methodId == 'card') {
      return paymentMethods.hasCreditCard;
    }
    return false;
  }

  void _startCharge() {
    final paymentMethods = context.read<PaymentMethodsProvider>();
    if (!_hasEnteredAmount ||
        !_isPaymentMethodAvailable(paymentMethods, _selectedPayment)) {
      return;
    }

    if (_selectedPayment == 'card') {
      // Credit card charge flow: Amount -> 3D Secure -> Success (handled in 3D secure)
      Navigator.of(context).pushNamed(
        '/three-d-secure',
        arguments: {
          'amount': int.parse(_amountController.text),
          'method': _selectedPayment,
          'type':
              'charge', // Specify type for 3D secure to route to correct success
        },
      );
    } else {
      // Bank charge flow: Amount -> Processing -> Success
      Navigator.of(context).pushNamed(
        '/charge-processing',
        arguments: {
          'amount': int.parse(_amountController.text),
          'method': _selectedPayment,
        },
      );
    }
  }

  String get _methodTitle {
    return 'チャージ方法選択';
  }

  @override
  Widget build(BuildContext context) {
    final paymentMethods = context.watch<PaymentMethodsProvider>();
    final isChargeButtonEnabled =
        _hasEnteredAmount &&
        _isPaymentMethodAvailable(paymentMethods, _selectedPayment);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          _methodTitle,
          style: GoogleFonts.inter(
            color: AppColors.primaryBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.primaryBlue,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildSelectionButton(
                    icon: Icons.account_balance,
                    iconSize: 30,
                    label: 'Bank Transfer',
                    isSelected: _selectedPayment == 'bank',
                    onTap: () => setState(() => _selectedPayment = 'bank'),
                    enabled: paymentMethods.hasBankAccount,
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: _buildSelectionButton(
                    icon: Icons.credit_card,
                    iconSize: 30,
                    label: 'Credit Card',
                    isSelected: _selectedPayment == 'card',
                    onTap: () => setState(() => _selectedPayment = 'card'),
                    enabled: paymentMethods.hasCreditCard,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 78),
            Text(
              'チャージポイントを選択',
              style: GoogleFonts.inter(
                color: AppColors.primaryBlue,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Amount Grid
            GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 2.2,
              ),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _presetAmounts.length,
              itemBuilder: (context, index) {
                final amount = _presetAmounts[index];
                final isSelected = _amountController.text == amount.toString();
                return GestureDetector(
                  onTap: () => _onAmountSelected(amount),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryBlue
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primaryBlue
                            : Colors.grey[700]!,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '¥${_formatNumber(amount)}',
                        style: GoogleFonts.inter(
                          color: isSelected ? Colors.white : Colors.grey[400],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            Text(
              'ポイントを指定してチャージ',
              style: GoogleFonts.inter(
                color: AppColors.primaryBlue,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),
            // Custom Amount Input
            TextField(
              controller: _amountController,
              style: GoogleFonts.inter(color: Colors.white, fontSize: 18),
              decoration: InputDecoration(
                hintText: '1,000 to 10,000,000',
                hintStyle: GoogleFonts.inter(color: Colors.grey[600]),
                filled: true,
                fillColor: const Color(0xFF0D1B2A),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              keyboardType: TextInputType.number,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 8),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '現在の残高: ',
                    style: GoogleFonts.inter(
                      color: AppColors.primaryBlue,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: '10000P',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Charge Button
            Center(
              child: SizedBox(
                width: 287,
                height: 60,
                child: ElevatedButton(
                  onPressed: isChargeButtonEnabled ? _startCharge : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isChargeButtonEnabled
                        ? AppColors.primaryBlue
                        : const Color(0xFF2C2C2E),
                    disabledBackgroundColor: const Color(0xFF2C2C2E),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'チャージする',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isChargeButtonEnabled
                          ? Colors.white
                          : Colors.white24,
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

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
  }

  // Builds a selection button widget with icon and label
  Widget _buildSelectionButton({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    bool enabled = true,
    double iconSize = 22,
    double horizontalPadding = 10,
    double borderRadius = 14,
    double height = 60,
  }) {
    final Color backgroundColor = isSelected
        ? AppColors.primaryBlue
        : enabled
        ? const Color(0xFF0D1B2A)
        : const Color(0xFF2C2C2E);
    final Color borderColor = isSelected
        ? AppColors.primaryBlue
        : enabled
        ? Colors.grey[700]!
        : Colors.grey[800]!;
    final Color foregroundColor = isSelected
        ? Colors.white
        : enabled
        ? Colors.white
        : Colors.white24;

    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        height: height,
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: borderColor, width: 2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: iconSize, color: foregroundColor),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                style: GoogleFonts.inter(
                  color: foregroundColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
