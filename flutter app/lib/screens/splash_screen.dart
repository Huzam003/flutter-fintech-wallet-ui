import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../theme/design_system.dart';
import '../widgets/loading_spinner.dart';
import 'terms_of_use_screen.dart';
import 'privacy_policy_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2200),
      vsync: this,
    );
    _opacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();

    // Navigate after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _checkAuthAndNavigate();
      }
    });
  }

  void _checkAuthAndNavigate() {
    if (!mounted) return;
    final authProvider = context.read<AuthProvider>();
    if (authProvider.isLoggedIn) {
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      // Navigate to welcome and tell it to show the agreement
      Navigator.of(
        context,
      ).pushReplacementNamed('/welcome', arguments: {'showAgreement': true});
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.mainGradient),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 3),
              FadeTransition(
                opacity: _opacity,
                child: Image.asset(
                  'assets/icons/fts_logo.png',
                  height: 337,
                  width: 337,
                ),
              ),
              const Spacer(flex: 3),
              const Padding(
                padding: EdgeInsets.only(bottom: 40),
                child: LoadingSpinner(),
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
                  text: 'プライバシーポリシーへ',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(text: 'の同意が必要です。'),
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
              const SizedBox(width: 16),
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
