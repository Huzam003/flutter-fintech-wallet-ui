import 'package:flutter/material.dart';

final navObserver = NavObserver();

/// Routes on which [AppRoot]'s bottom nav bar should be hidden.
const hideNavBarRoutes = {
  '/qr-scanner',
  '/biometric-auth',
  '/passcode-auth',
  '/processing',
  '/verification-camera',
  '/selfie-capture',
  '/payment-success',
  '/registration-success',
  '/upload-success',
  '/password-reset-success',
};

class NavObserver extends NavigatorObserver {
  /// The name of the current top-most route.
  final ValueNotifier<String?> currentRoute = ValueNotifier<String?>('/home');

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    currentRoute.value = route.settings.name;
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    currentRoute.value = previousRoute?.settings.name;
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    currentRoute.value = newRoute?.settings.name;
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    currentRoute.value = previousRoute?.settings.name;
  }
}
