import 'package:flutter/material.dart';
import 'screens/settings_screen.dart';
import 'screens/account_info_screen.dart';
import 'screens/security_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/terms_of_use_screen.dart';
import 'screens/privacy_policy_screen.dart';
import 'screens/business_info_screen.dart';
import 'screens/full_history_screen.dart';
import 'screens/charge_amount_screen.dart';
import 'screens/charge_processing_screen.dart';
import 'screens/charge_success_screen.dart';
import 'screens/transaction_detail_screen.dart';
import 'screens/history_screen.dart';
import 'screens/three_d_secure_screen.dart';

/// Generates routes that should appear **inside** a tab's [Navigator],
/// keeping AppRoot's bottom nav bar visible.
///
/// Any route not handled here returns `null` — callers should fall back to
/// the root [MaterialApp] navigator for full-screen flows.
Route<dynamic>? generateTabRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/charge-amount':
      final method = settings.arguments as String? ?? 'bank';
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => ChargeAmountScreen(paymentMethod: method),
      );

    case '/three-d-secure':
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => const ThreeDSecureScreen(),
      );

    case '/charge-processing':
      final args = settings.arguments as Map<String, dynamic>? ?? {};
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => ChargeProcessingScreen(
          amount: args['amount'] ?? 0,
          method: args['method'] ?? 'bank',
        ),
      );

    case '/charge-success':
      final args = settings.arguments;
      if (args is Map<String, dynamic>) {
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => ChargeSuccessScreen(
            type: args['type'] ?? 'charge',
            amount: args['amount'],
            method: args['method'],
            customMessage: args['message'],
          ),
        );
      }
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => ChargeSuccessScreen(type: args?.toString() ?? 'charge'),
      );

    case '/settings':
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => const SettingsScreen(),
      );
    case '/account-info':
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => const AccountInfoScreen(),
      );
    case '/security':
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => const SecurityScreen(),
      );
    case '/profile':
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => const ProfileScreen(),
      );
    case '/terms':
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => const TermsOfUseScreen(),
      );
    case '/privacy':
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => const PrivacyPolicyScreen(),
      );
    case '/business-info':
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => const BusinessInfoScreen(),
      );
    case '/full-history':
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => const FullHistoryScreen(),
      );
    case '/transaction-detail':
      final transaction = settings.arguments as Transaction?;
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => TransactionDetailScreen(transaction: transaction),
      );
    default:
      return null;
  }
}
