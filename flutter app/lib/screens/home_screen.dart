import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/auth_provider.dart';
import '../providers/verification_provider.dart';
import '../providers/payment_methods_provider.dart';
import '../models/user.dart';
import '../theme/design_system.dart';
import '../widgets/loading_spinner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.onNavigateToCharge});

  final VoidCallback? onNavigateToCharge;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isBalanceVisible = true;
  bool _isRefreshing = false;
  double _refreshTurns = 0;

  Future<void> _refreshBalance() async {
    if (_isRefreshing) return;
    setState(() {
      _isRefreshing = true;
      _refreshTurns += 1;
    });

    await Future.delayed(const Duration(milliseconds: 900));

    if (!mounted) return;
    setState(() => _isRefreshing = false);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vp = context.read<VerificationProvider>();
      if (vp.pendingReviewDialog) {
        vp.markDialogShown();
        _showVerificationReviewDialog();
      }
    });
  }

  void _showVerificationReviewDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF0D1B2A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: AppColors.error,
                  size: 32,
                ),
                GestureDetector(
                  onTap: () => Navigator.of(ctx).pop(),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white54,
                    size: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '本人確認によるチャージ限度額の引き上げ',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(color: Colors.white, fontSize: 13),
            ),
            const SizedBox(height: 24),
            Center(
              child: SizedBox(
                width: 123,
                height: 42,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    padding: EdgeInsets.zero,
                    fixedSize: const Size(123, 42),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text(
                    '今すぐ確認',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
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

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _buildHomeContent(context, user),
    );
  }

  Widget _buildHomeContent(BuildContext context, User? user) {
    final paymentMethods = context.watch<PaymentMethodsProvider>();
    final bool hasPayment =
        paymentMethods.hasBankAccount || paymentMethods.hasCreditCard;
    final displayName = (user?.name?.trim().isNotEmpty ?? false)
        ? user!.name!.trim()
        : '村田夕季';
    return SafeArea(
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.settings_outlined,
                    color: Colors.white54,
                    size: 24,
                  ),
                  onPressed: () => Navigator.of(context).pushNamed('/settings'),
                ),
              ],
            ),
          ),

          // Main content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const Spacer(flex: 1),

                  // Profile Avatar
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 148,
                          height: 148,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFFD4D4D4),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.person,
                            size: 148,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          displayName,
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Balance Label
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Text(
                          'ポイント残高',
                          style: GoogleFonts.inter(
                            color: AppColors.primaryBlue,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Balance Card
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0A1628),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _isBalanceVisible
                            ? AppColors.primaryBlue.withValues(alpha: 0.5)
                            : Colors.transparent,
                        width: 1,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AnimatedRotation(
                              turns: _refreshTurns,
                              duration: const Duration(milliseconds: 600),
                              child: GestureDetector(
                                onTap: _refreshBalance,
                                child: Icon(
                                  Icons.refresh_outlined,
                                  color: _isRefreshing
                                      ? Colors.white70
                                      : AppColors.primaryBlue,
                                  size: 26,
                                ),
                              ),
                            ),
                          ),
                        ),

                        Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () => setState(
                                () => _isBalanceVisible = !_isBalanceVisible,
                              ),
                              child: Icon(
                                _isBalanceVisible
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: AppColors.primaryBlue,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 24,
                              horizontal: 24,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (_isRefreshing)
                                  const LoadingSpinner(
                                    size: 42,
                                    dotRadius: 4,
                                    color: AppColors.primaryBlue,
                                  )
                                else
                                  Text(
                                    _isBalanceVisible ? '10,000 P' : '****** P',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.inter(
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                const SizedBox(height: 8),
                                Text(
                                  '月末失効ポイント 0P',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    color: AppColors.error,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 48),

                  // Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildCircleAction(context, Icons.add, 'ポイントチャージ', () {
                        widget.onNavigateToCharge?.call();
                      }, enabled: hasPayment),
                      const SizedBox(width: 48),
                      _buildCircleAction(
                        context,
                        Icons.arrow_outward,
                        'ポイント支払い',
                        () {
                          Navigator.of(
                            context,
                            rootNavigator: true,
                          ).pushNamed('/qr-scanner');
                        },
                      ),
                    ],
                  ),

                  const Spacer(flex: 2),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircleAction(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap, {
    bool enabled = true,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: enabled ? onTap : null,
          child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: enabled
                  ? const Color(0xFF1B263B)
                  : const Color(0xFF2C2C2E),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.1),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: enabled ? Colors.white : Colors.white24,
              size: 32,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          label,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
