import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/design_system.dart';
import '../widgets/loading_spinner.dart';

/// 3D Secure authentication screen
/// Shows a redirect message while simulating 3D Secure verification
class ThreeDSecureScreen extends StatefulWidget {
  const ThreeDSecureScreen({super.key});

  @override
  State<ThreeDSecureScreen> createState() => _ThreeDSecureScreenState();
}

class _ThreeDSecureScreenState extends State<ThreeDSecureScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(
      begin: 0.9,
      end: 1.1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Simulate 3D Secure verification delay
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        final args = ModalRoute.of(context)?.settings.arguments;
        // Check if this is a charge flow or registration flow
        if (args is Map<String, dynamic> && args['type'] == 'charge') {
          Navigator.of(
            context,
          ).pushReplacementNamed('/charge-success', arguments: args);
        } else {
          // Default to registration success
          Navigator.of(context).pushReplacementNamed(
            '/charge-success',
            arguments: {'type': 'registration', 'message': 'クレジットカードが登録されました'},
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          '3Dセキュア認証',
          style: GoogleFonts.inter(
            color: AppColors.primaryBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.primaryBlue),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated shield icon with lock overlay (proportionally sized)
            ScaleTransition(
              scale: _pulseAnimation,
              child: SizedBox(
                width: 190,
                height: 190,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Icon(
                      Icons.shield,
                      size: 190,
                      color: AppColors.primaryBlue,
                    ),
                    // Lock sized proportionally to the shield so it remains centered
                    FractionallySizedBox(
                      widthFactor: 0.48,
                      heightFactor: 0.48,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: const Icon(
                          Icons.lock_outline,
                          color: AppColors.background,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),

            Text(
              '3Dセキュア認証にリダイレクト中',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: 42,
              height: 42,
              child: LoadingSpinner(
                size: 42,
                dotRadius: 5,
                color: AppColors.primaryBlue,
                duration: Duration(milliseconds: 900),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
