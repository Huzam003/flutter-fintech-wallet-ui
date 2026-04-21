import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/payment_methods_provider.dart';
import '../providers/verification_provider.dart';
import '../theme/design_system.dart';

class AccountInfoScreen extends StatelessWidget {
  const AccountInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final paymentMethods = context.watch<PaymentMethodsProvider>();
    final verification = context.watch<VerificationProvider>();

    const dailyLimit = '10,000,000Yen/Day';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          '設定',
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Profile header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.grey[300],
                    child: const Icon(
                      Icons.person,
                      color: Colors.grey,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ユーザー名',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Builder(
                          builder: (context) {
                            final pm = context.watch<PaymentMethodsProvider>();
                            final isFullyVerified =
                                verification.isVerified &&
                                (pm.hasBankAccount || pm.hasCreditCard);
                            final badgeColor = isFullyVerified
                                ? AppColors.success
                                : AppColors.error;
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: badgeColor,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Text(
                                '確認済み',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      LucideIcons.squarePen,
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: () =>
                        Navigator.of(context).pushNamed('/profile'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Bank Account Section
            _buildSection(
              context: context,
              title: '銀行口座',
              icon: Icons.account_balance,
              isRegistered: paymentMethods.hasBankAccount,
              registeredInfo: paymentMethods.hasBankAccount
                  ? '${paymentMethods.bankName ?? ''}\n${paymentMethods.bankAccountLast4 ?? ''}'
                  : null,
              onAdd: () => Navigator.of(
                context,
                rootNavigator: true,
              ).pushNamed('/register-bank'),
            ),

            const SizedBox(height: 16),

            // Credit Card Section
            _buildSection(
              context: context,
              title: 'クレジットカード',
              icon: Icons.credit_card,
              isRegistered: paymentMethods.hasCreditCard,
              registeredInfo: paymentMethods.hasCreditCard
                  ? paymentMethods.cardLast4
                  : null,
              onAdd: () => Navigator.of(
                context,
                rootNavigator: true,
              ).pushNamed('/register-credit-card'),
            ),

            const SizedBox(height: 16),

            // ID Verification Section
            GestureDetector(
              onTap: () => Navigator.of(
                context,
                rootNavigator: true,
              ).pushNamed('/verification-camera'),
              child: Container(
                constraints: const BoxConstraints(minHeight: 140),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '本人確認',
                            style: GoogleFonts.inter(
                              color: AppColors.primaryBlue,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            dailyLimit,
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Status icon: checkmark when verified, arrow when not
                    verification.isVerified
                        ? const Icon(
                            Icons.check_circle,
                            color: AppColors.primaryBlue,
                            size: 28,
                          )
                        : const Icon(
                            Icons.chevron_right,
                            color: AppColors.primaryBlue,
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required BuildContext context,
    required String title,
    required IconData icon,
    required bool isRegistered,
    String? registeredInfo,
    required VoidCallback onAdd,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: IntrinsicHeight(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    color: AppColors.primaryBlue,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(icon, color: Colors.white, size: 36),
                        const SizedBox(height: 3),
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(
                            LucideIcons.squarePen,
                            color: Colors.white,
                            size: 23,
                          ),
                          onPressed: onAdd,
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: isRegistered
                          ? Text(
                              registeredInfo ?? '',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            )
                          : const SizedBox(),
                    ),
                  ],
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerRight,
              child: isRegistered
                  ? const Icon(
                      Icons.check_circle,
                      color: AppColors.primaryBlue,
                      size: 28,
                    )
                  : const Icon(Icons.cancel, color: Colors.red, size: 28),
            ),
          ],
        ),
      ),
    );
  }
}
