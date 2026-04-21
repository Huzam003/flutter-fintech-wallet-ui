import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../theme/design_system.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  final LocalAuthentication _localAuth = LocalAuthentication();
  bool _isBiometricSupported = false;

  @override
  void initState() {
    super.initState();
    _checkBiometricSupport();
  }

  Future<void> _checkBiometricSupport() async {
    try {
      final isSupported = await _localAuth.isDeviceSupported();
      final canCheckBiometrics = await _localAuth.canCheckBiometrics;
      if (mounted) {
        setState(() {
          _isBiometricSupported = isSupported && canCheckBiometrics;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isBiometricSupported = false;
        });
      }
    }
  }

  Future<void> _toggleBiometricAuth(
    bool value,
    SettingsProvider settings,
  ) async {
    if (value) {
      try {
        final didAuthenticate = await _localAuth.authenticate(
          localizedReason: '生体認証を有効にするために認証してください',
          options: const AuthenticationOptions(
            stickyAuth: true,
            biometricOnly: true,
          ),
        );
        if (didAuthenticate) {
          settings.isBiometricEnabled = true;
        }
      } catch (e) {
        settings.isBiometricEnabled = false;
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('生体認証の設定に失敗しました')));
        }
      }
    } else {
      settings.isBiometricEnabled = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = context.watch<SettingsProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'セキュリティ',
          style: GoogleFonts.inter(
            color: AppColors.primaryBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.primaryBlue),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
        child: Align(
          alignment: Alignment.center,
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: AppDimensions.paddingM),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
            padding: const EdgeInsets.all(AppDimensions.paddingM),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),

                // Header section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'セキュリティ',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '支払いなどの重要な操作を行う前に、本人確認を行います',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Biometric toggle
                _buildSecurityToggle(
                  title: '生体認証を有効にする',
                  subtitle: '指紋認証で本人確認を行います',
                  value: settingsProvider.isBiometricEnabled,
                  enabled: _isBiometricSupported,
                  onChanged: (value) =>
                      _toggleBiometricAuth(value, settingsProvider),
                ),

                const SizedBox(height: 12),

                // Passcode toggle
                _buildSecurityToggle(
                  title: 'パスコードを有効にする',
                  subtitle: '生体認証が使えない場合に使用します',
                  value: settingsProvider.isPasscodeEnabled,
                  enabled: true,
                  onChanged: (value) =>
                      settingsProvider.isPasscodeEnabled = value,
                ),

                const SizedBox(height: 12),

                // OTP toggle
                _buildSecurityToggle(
                  title: 'ワンタイム認証（OTP）を有効にする',
                  subtitle: '決済時に追加の認証を行います',
                  value: settingsProvider.isOtpEnabled,
                  enabled: true,
                  onChanged: (value) => settingsProvider.isOtpEnabled = value,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSecurityToggle({
    required String title,
    required String subtitle,
    required bool value,
    required bool enabled,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(
        minHeight:
            kMinInteractiveDimension +
            AppDimensions.paddingXL +
            AppDimensions.paddingXL,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingM,
        vertical: AppDimensions.paddingL,
      ),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: enabled ? Colors.white : Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  enabled ? subtitle : 'このデバイスではサポートされていません',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.textSecondary.withValues(
                      alpha: enabled ? 0.7 : 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            activeThumbColor: Colors.white,
            activeTrackColor: AppColors.primaryBlue,
            inactiveThumbColor: Colors.grey,
            inactiveTrackColor: Colors.grey.withValues(alpha: 0.3),
            onChanged: enabled ? onChanged : null,
          ),
        ],
      ),
    );
  }
}
