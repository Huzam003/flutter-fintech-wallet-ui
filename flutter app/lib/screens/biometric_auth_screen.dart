import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth/local_auth.dart';
import '../theme/design_system.dart';
import '../widgets/loading_spinner.dart';

class BiometricAuthScreen extends StatefulWidget {
  final String? merchantInfo;
  final int? amount;
  final String purpose;
  final String? email;

  const BiometricAuthScreen({
    super.key,
    this.merchantInfo,
    this.amount,
    this.purpose = 'payment',
    this.email,
  });

  @override
  State<BiometricAuthScreen> createState() => _BiometricAuthScreenState();
}

class _BiometricAuthScreenState extends State<BiometricAuthScreen> {
  final LocalAuthentication _localAuth = LocalAuthentication();
  bool _isAuthenticating = false;

  @override
  void initState() {
    super.initState();
    // Start authentication automatically
    WidgetsBinding.instance.addPostFrameCallback((_) => _authenticate());
  }

  Future<void> _authenticate() async {
    if (_isAuthenticating) return;

    setState(() => _isAuthenticating = true);

    try {
      final isSupported = await _localAuth.isDeviceSupported();
      final canCheckBiometrics = await _localAuth.canCheckBiometrics;

      if (!isSupported || !canCheckBiometrics) {
        _showFallbackOptions();
        return;
      }

      final didAuthenticate = await _localAuth.authenticate(
        localizedReason: widget.purpose == 'password_reset'
            ? 'パスワード再設定の本人確認'
            : '生体認証による支払い確認',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );

      if (didAuthenticate && mounted) {
        if (widget.purpose == 'password_reset') {
          Navigator.of(context).pushReplacementNamed(
            '/otp',
            arguments: {
              'email': widget.email ?? '',
              'isPasswordReset': true,
              'resetSource': 'profile',
            },
          );
        } else {
          // Success - proceed with payment
          Navigator.of(context).pushReplacementNamed(
            '/processing',
            arguments: {'type': 'payment', 'amount': widget.amount},
          );
        }
      } else {
        _showFallbackOptions();
      }
    } catch (e) {
      _showFallbackOptions();
    } finally {
      if (mounted) {
        setState(() => _isAuthenticating = false);
      }
    }
  }

  void _showFallbackOptions() {
    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF0D1B2A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: AppColors.error,
                  size: 36,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '生体認証を利用できなかったか、認証に失敗しました。',
                    style: GoogleFonts.inter(color: Colors.white, fontSize: 14),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Padding(
                    padding: EdgeInsets.only(left: 12.0),
                    child: Icon(Icons.close, color: Colors.white54, size: 20),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '以下のいずれかの方法にて、引き続きお支払いを完了してください。',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(color: Colors.white70, fontSize: 12),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushReplacementNamed(
                        '/passcode-auth',
                        arguments: {
                          'purpose': widget.purpose,
                          'email': widget.email,
                          'resetSource': 'profile',
                        },
                      );
                    },
                    child: Text(
                      'パスコード',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                if (widget.purpose != 'password_reset') ...[
                  const SizedBox(width: 12),
                  Text('または', style: GoogleFonts.inter(color: Colors.grey)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: AppColors.primaryBlue),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pushReplacementNamed(
                          '/otp-auth',
                          arguments: {
                            'purpose': 'payment',
                            'amount': widget.amount,
                          },
                        );
                      },
                      child: Text(
                        'OTP',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          '認証',
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '生体認証による支払い確認',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 60),

            // Fingerprint icon
            GestureDetector(
              onTap: _authenticate,
              child: SizedBox(
                width: 212,
                height: 212,
                child: const Icon(
                  Icons.fingerprint,
                  size: 212,
                  color: AppColors.primaryBlue,
                ),
              ),
            ),

            const SizedBox(height: 60),

            // Loading indicator
            if (_isAuthenticating) const LoadingSpinner(),

            const SizedBox(height: 40),

            // Retry button
            TextButton(
              onPressed: _authenticate,
              child: Text(
                '再試行',
                style: GoogleFonts.inter(
                  color: AppColors.primaryBlue,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
