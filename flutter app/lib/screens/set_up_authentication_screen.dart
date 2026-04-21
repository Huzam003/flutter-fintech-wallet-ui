import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../theme/design_system.dart';

class SetUpAuthenticationScreen extends StatefulWidget {
  const SetUpAuthenticationScreen({super.key});

  @override
  State<SetUpAuthenticationScreen> createState() =>
      _SetUpAuthenticationScreenState();
}

class _SetUpAuthenticationScreenState extends State<SetUpAuthenticationScreen> {
  final LocalAuthentication _localAuth = LocalAuthentication();
  bool _isBiometricSupported = false;
  bool _biometricEnabled = false;
  bool _passcodeEnabled = false;

  @override
  void initState() {
    super.initState();
    _checkBiometricSupport();
  }

  Future<void> _checkBiometricSupport() async {
    try {
      final isSupported = await _localAuth.isDeviceSupported();
      final canCheckBiometrics = await _localAuth.canCheckBiometrics;
      final availableBiometrics = await _localAuth.getAvailableBiometrics();

      debugPrint(
        'Biometric check: isSupported=$isSupported, canCheck=$canCheckBiometrics, available=$availableBiometrics',
      );

      if (mounted) {
        setState(() {
          // More permissive check - if device supports biometrics or has some available
          _isBiometricSupported =
              isSupported ||
              canCheckBiometrics ||
              availableBiometrics.isNotEmpty;
        });
      }
    } catch (e) {
      debugPrint('Biometric check error: $e');
      if (mounted) {
        setState(() {
          _isBiometricSupported = false;
        });
      }
    }
  }

  Future<void> _toggleBiometric(bool value) async {
    debugPrint(
      '_toggleBiometric called with value=$value, supported=$_isBiometricSupported',
    );

    if (value) {
      try {
        debugPrint('Attempting biometric authentication...');

        // We attempt authentication regardless of specific available biometrics
        // to allow for device credential fallback (PIN/Pattern) if supported.

        final didAuthenticate = await _localAuth.authenticate(
          localizedReason: '生体認証を有効にするために認証してください',
          options: const AuthenticationOptions(
            stickyAuth: true,
            biometricOnly: false, // Allow PIN/pattern as fallback
          ),
        );
        debugPrint('Authentication result: $didAuthenticate');
        if (didAuthenticate && mounted) {
          setState(() => _biometricEnabled = true);
          context.read<SettingsProvider>().isBiometricEnabled = true;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('生体認証が有効になりました')));
        }
      } catch (e) {
        debugPrint('Biometric auth error: $e');
        if (mounted) {
          String errorMessage = '生体認証の設定に失敗しました';
          if (e.toString().contains('NotAvailable')) {
            errorMessage = 'この端末では生体認証が利用できません';
          } else if (e.toString().contains('NotEnrolled')) {
            errorMessage = 'デバイスに生体情報が登録されていません';
          } else if (e.toString().contains('LockedOut')) {
            errorMessage = '認証に複数回失敗しました。しばらく待ってからお試しください';
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    } else {
      setState(() => _biometricEnabled = false);
      if (mounted) {
        context.read<SettingsProvider>().isBiometricEnabled = false;
      }
    }
  }

  void _continue() {
    final args = ModalRoute.of(context)?.settings.arguments;
    String? next;
    if (args is Map) {
      next = args['next'] as String?;
    }

    if (next != null && next.isNotEmpty) {
      // Replace this screen with the next screen in the flow
      Navigator.of(context).pushReplacementNamed(next);
    } else {
      Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          '認証設定',
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Subtitle
            Text(
              'セキュリティ設定を強化',
              style: GoogleFonts.inter(fontSize: 14, color: Colors.white70),
            ),

            const SizedBox(height: 40),

            // Fingerprint icon
            const SizedBox(
              width: 212,
              height: 212,
              child: Center(
                child: Icon(
                  Icons.fingerprint,
                  size: 212,
                  color: AppColors.primaryBlue,
                ),
              ),
            ),

            const SizedBox(height: 60),

            // Biometric toggle
            _buildToggleCard(
              title: '生体認証を有効にする',
              subtitle: '指紋',
              value: _biometricEnabled,
              enabled: _isBiometricSupported,
              onChanged: _toggleBiometric,
            ),

            const SizedBox(height: 16),

            // Passcode toggle
            _buildToggleCard(
              title: 'パスコードを有効にする',
              subtitle: 'デバイスロック',
              value: _passcodeEnabled,
              enabled: true,
              onChanged: (value) => setState(() => _passcodeEnabled = value),
            ),

            const Spacer(),

            // Skip button
            TextButton(
              onPressed: _continue,
              child: Text(
                'スキップしてホームへ',
                style: GoogleFonts.inter(
                  color: Colors.grey,
                  fontSize: 14,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Continue button
            Center(
              child: SizedBox(
                width: 287,
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _continue,
                  child: Text(
                    '設定を保存',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleCard({
    required String title,
    required String subtitle,
    required bool value,
    required bool enabled,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  color: enabled ? Colors.white : Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppColors.primaryBlue,
                ),
              ),
            ],
          ),
          Switch(
            value: value,
            activeThumbColor: AppColors.primaryBlue,
            activeTrackColor: AppColors.primaryBlue.withValues(alpha: 0.3),
            inactiveThumbColor: Colors.grey,
            inactiveTrackColor: Colors.grey.withValues(alpha: 0.3),
            onChanged: enabled ? onChanged : null,
          ),
        ],
      ),
    );
  }
}
