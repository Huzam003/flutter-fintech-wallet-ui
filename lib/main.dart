import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:user_app/l10n/app_localizations.dart';
import 'providers/auth_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/payment_methods_provider.dart';
import 'providers/verification_provider.dart';
import 'screens/welcome_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/otp_screen.dart';
import 'screens/app_root.dart';
import 'screens/charge_screen.dart';
import 'screens/payment_screen.dart';
import 'screens/history_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/security_screen.dart';
import 'screens/privacy_policy_screen.dart';
import 'screens/terms_of_use_screen.dart';
import 'screens/id_document_camera_screen.dart';
import 'screens/registration_success_screen.dart';
import 'screens/business_info_screen.dart';
import 'screens/set_up_authentication_screen.dart';
import 'screens/register_bank_account_screen.dart';
import 'screens/register_credit_card_screen.dart';
import 'screens/processing_screen.dart';
import 'screens/charge_success_screen.dart';
// New imports
import 'screens/forgot_password_screen.dart';
import 'screens/password_reset_success_screen.dart';
import 'screens/set_password_screen.dart';
import 'screens/qr_scanner_screen.dart';
import 'screens/biometric_auth_screen.dart';
import 'screens/passcode_auth_screen.dart';
import 'screens/account_info_screen.dart';
import 'screens/selfie_capture_screen.dart';
import 'screens/payment_amount_screen.dart';
import 'screens/upload_success_screen.dart';
import 'screens/three_d_secure_screen.dart';
import 'screens/charge_amount_screen.dart';
import 'screens/charge_processing_screen.dart';
import 'screens/payment_success_screen.dart';
import 'screens/full_history_screen.dart';
import 'theme/design_system.dart';
import 'widgets/nav_observer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => PaymentMethodsProvider()),
        ChangeNotifierProvider(create: (_) => VerificationProvider()),
      ],
      child: MaterialApp(
        title: 'ユーザーアプリ',
        navigatorObservers: [navObserver],
        builder: (context, child) {
          return child!;
        },
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: AppColors.background,

          colorScheme: const ColorScheme.dark(
            primary: AppColors.primaryBlue,
            secondary: AppColors.neonBlue,
            surface: AppColors.surface,
            error: AppColors.error,
            onPrimary: Colors.white,
            onSecondary: Colors.white,
            onSurface: AppColors.textPrimary,
          ),

          textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme)
              .apply(
                bodyColor: AppColors.textPrimary,
                displayColor: AppColors.textPrimary,
              ),

          appBarTheme: AppBarTheme(
            backgroundColor: AppColors.background,
            elevation: 0,
            iconTheme: const IconThemeData(color: AppColors.textPrimary),
            titleTextStyle: AppTextStyles.headlineMedium,
          ),

          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              ),
              textStyle: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: AppColors.surfaceLight,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              borderSide: const BorderSide(color: AppColors.neonBlue, width: 1),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              borderSide: const BorderSide(color: AppColors.error, width: 1),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 18,
            ),
            hintStyle: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),

          useMaterial3: true,
        ),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('ja'), Locale('en')],
        locale: const Locale('ja'),
        home: const _AuthWrapper(),
        onGenerateRoute: (settings) {
          // Handle routes that need arguments
          switch (settings.name) {
            case '/three-d-secure':
              return MaterialPageRoute(
                builder: (_) => const ThreeDSecureScreen(),
              );
            case '/charge-amount':
              final method = settings.arguments as String? ?? 'bank';
              return MaterialPageRoute(
                builder: (_) => ChargeAmountScreen(paymentMethod: method),
              );
            case '/charge-processing':
              final args = settings.arguments as Map<String, dynamic>? ?? {};
              return MaterialPageRoute(
                builder: (_) => ChargeProcessingScreen(
                  amount: args['amount'] ?? 0,
                  method: args['method'] ?? 'bank',
                ),
              );
            case '/charge-success':
              final args = settings.arguments;
              if (args is Map<String, dynamic>) {
                return MaterialPageRoute(
                  builder: (_) => ChargeSuccessScreen(
                    type: args['type'] ?? 'charge',
                    amount: args['amount'],
                    method: args['method'],
                    customMessage: args['message'], // Pass custom message
                  ),
                );
              } else {
                return MaterialPageRoute(
                  builder: (_) =>
                      ChargeSuccessScreen(type: args?.toString() ?? 'charge'),
                );
              }
            case '/processing':
              final args = settings.arguments;
              if (args is Map<String, dynamic>) {
                return MaterialPageRoute(
                  builder: (_) => ProcessingScreen(
                    type: args['type'] ?? 'payment',
                    amount: args['amount'],
                  ),
                );
              } else {
                return MaterialPageRoute(
                  builder: (_) =>
                      ProcessingScreen(type: args?.toString() ?? 'payment'),
                );
              }
            case '/payment-success':
              final args = settings.arguments as Map<String, dynamic>? ?? {};
              return MaterialPageRoute(
                builder: (_) => PaymentSuccessScreen(
                  amount: args['amount'] ?? 0,
                  transactionId: args['transactionId'] ?? '000000000',
                ),
              );
            case '/payment-amount':
              final merchant = settings.arguments as String?;
              return MaterialPageRoute(
                builder: (_) => PaymentAmountScreen(merchantData: merchant),
              );
            case '/biometric-auth':
              final args = settings.arguments as Map<String, dynamic>? ?? {};
              return MaterialPageRoute(
                builder: (_) => BiometricAuthScreen(
                  amount: args['amount'],
                  merchantInfo: args['merchant'],
                  purpose: args['purpose'] ?? 'payment',
                  email: args['email'],
                ),
              );
            case '/set-password':
              final args = settings.arguments as Map<String, dynamic>? ?? {};
              return MaterialPageRoute(
                builder: (_) =>
                    SetPasswordScreen(isReset: args['isReset'] == true),
              );
            case '/password-reset-success':
              final args = settings.arguments as Map<String, dynamic>? ?? {};
              return MaterialPageRoute(
                builder: (_) => PasswordResetSuccessScreen(
                  resetSource: args['resetSource'] as String?,
                ),
              );
            default:
              return null; // Fall through to routes map
          }
        },
        routes: {
          '/splash': (_) => const SplashScreen(),
          '/welcome': (_) => const WelcomeScreen(),
          '/login': (_) => const LoginScreen(),
          '/register': (_) => const RegisterScreen(),
          '/otp': (_) => const OTPScreen(),
          '/home': (_) => const AppRoot(),
          '/charge': (_) => const ChargeScreen(),
          '/payment': (_) => const PaymentScreen(),
          '/history': (_) => const HistoryScreen(),
          '/profile': (_) => const ProfileScreen(),
          '/settings': (_) => const SettingsScreen(),
          '/security': (_) => const SecurityScreen(),
          '/privacy': (_) => const PrivacyPolicyScreen(),
          '/terms': (_) => const TermsOfUseScreen(),
          '/verification-camera': (_) => const IdDocumentCameraScreen(),
          '/registration-success': (_) => const RegistrationSuccessScreen(),
          '/business-info': (_) => const BusinessInfoScreen(),
          '/set-up-auth': (_) => const SetUpAuthenticationScreen(),
          '/register-bank': (_) => const RegisterBankAccountScreen(),
          '/register-credit-card': (_) => const RegisterCreditCardScreen(),
          '/forgot-password': (_) => const ForgotPasswordScreen(),
          '/qr-scanner': (_) => const QRScannerScreen(),
          '/passcode-auth': (_) => const PasscodeAuthScreen(),
          '/otp-auth': (_) => const OTPScreen(),
          '/account-info': (_) => const AccountInfoScreen(),
          '/selfie-capture': (_) => const SelfieCaptureScreen(),
          '/upload-success': (_) => const UploadSuccessScreen(),
          '/full-history': (_) => const FullHistoryScreen(),
        },
      ),
    );
  }
}

class _AuthWrapper extends StatelessWidget {
  const _AuthWrapper();

  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}
