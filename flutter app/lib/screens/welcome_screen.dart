import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/design_system.dart';
import 'terms_of_use_screen.dart';
import 'privacy_policy_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Map && args['showAgreement'] == true) {
        _showAgreementDialog();
      }
    });
  }

  void _showAgreementDialog() {
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _AgreementDialog(
        onAgree: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.background,
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 2),

              // Logo - larger and more prominent
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 1800),
                curve: Curves.easeOutBack,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Opacity(
                      opacity: value.clamp(0.0, 1.0),
                      child: child,
                    ),
                  );
                },
                child: Image.asset(
                  'assets/icons/fts_logo.png',
                  height: 331,
                  width: 331,
                ),
              ),

              const Spacer(flex: 3),

              // Action Buttons - matching the design
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  children: [
                    // Primary button - 新規登録 (New Registration)
                    SizedBox(
                      width: 287,
                      height: 60,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: AppColors.primaryBlue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () =>
                            Navigator.of(context).pushNamed('/register'),
                        child: Text(
                          '新規登録',
                          style: GoogleFonts.inter(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 56),
                    // Secondary button - ログイン (Login) as text link
                    GestureDetector(
                      onTap: () => Navigator.of(context).pushNamed('/login'),
                      child: Text(
                        'ログイン',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}

class _AgreementDialog extends StatefulWidget {
  final VoidCallback onAgree;

  const _AgreementDialog({required this.onAgree});

  @override
  State<_AgreementDialog> createState() => _AgreementDialogState();
}

class _AgreementDialogState extends State<_AgreementDialog> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF101D2D),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      contentPadding: const EdgeInsets.all(24),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '同意が必要です',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 16),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: GoogleFonts.inter(color: Colors.white70, fontSize: 14),
              children: const [
                TextSpan(text: '本サービスをご利用いただくには、\n'),
                TextSpan(
                  text: '利用規約',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(text: 'および'),
                TextSpan(
                  text: 'プライバシーポリシー',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(text: 'への同\n意が必要です。'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Checkbox row
          Row(
            children: [
              GestureDetector(
                onTap: () => setState(() => _isChecked = !_isChecked),
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white54),
                    borderRadius: BorderRadius.circular(4),
                    color: _isChecked
                        ? AppColors.primaryBlue
                        : Colors.transparent,
                  ),
                  child: _isChecked
                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                      : null,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: GoogleFonts.inter(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                    children: const [
                      TextSpan(
                        text: '利用規約',
                        style: TextStyle(color: Colors.white),
                      ),
                      TextSpan(text: 'および'),
                      TextSpan(
                        text: 'プライバシーポリシー',
                        style: TextStyle(color: Colors.white),
                      ),
                      TextSpan(text: 'に同意します'),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Links row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const TermsOfUseScreen(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                            const begin = Offset(0.0, 0.1);
                            const end = Offset.zero;
                            const curve = Curves.easeOutCubic;
                            var tween = Tween(
                              begin: begin,
                              end: end,
                            ).chain(CurveTween(curve: curve));
                            var offsetAnimation = animation.drive(tween);
                            var fadeAnimation = animation.drive(
                              Tween(begin: 0.0, end: 1.0),
                            );
                            return FadeTransition(
                              opacity: fadeAnimation,
                              child: SlideTransition(
                                position: offsetAnimation,
                                child: child,
                              ),
                            );
                          },
                      transitionDuration: const Duration(milliseconds: 400),
                    ),
                  );
                },
                child: Text(
                  '（利用規約）',
                  style: GoogleFonts.inter(
                    color: AppColors.primaryBlue,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const PrivacyPolicyScreen(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                            const begin = Offset(0.0, 0.1);
                            const end = Offset.zero;
                            const curve = Curves.easeOutCubic;
                            var tween = Tween(
                              begin: begin,
                              end: end,
                            ).chain(CurveTween(curve: curve));
                            var offsetAnimation = animation.drive(tween);
                            var fadeAnimation = animation.drive(
                              Tween(begin: 0.0, end: 1.0),
                            );
                            return FadeTransition(
                              opacity: fadeAnimation,
                              child: SlideTransition(
                                position: offsetAnimation,
                                child: child,
                              ),
                            );
                          },
                      transitionDuration: const Duration(milliseconds: 400),
                    ),
                  );
                },
                child: Text(
                  '（プライバシーポリシー）',
                  style: GoogleFonts.inter(
                    color: AppColors.primaryBlue,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Agree button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _isChecked
                    ? AppColors.primaryBlue
                    : const Color(0xFF2C2C2E),
                disabledBackgroundColor: const Color(0xFF2C2C2E),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: _isChecked ? widget.onAgree : null,
              child: Text(
                '同意して開始',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  color: _isChecked ? Colors.white : Colors.white24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
