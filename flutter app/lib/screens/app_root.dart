import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/bottom_nav_bar.dart';
import '../tab_router.dart';
import 'home_screen.dart';
import 'charge_screen.dart';
import 'history_screen.dart';

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  static const int _maxTabHistory = 20;

  int _currentIndex = 0;
  DateTime? _lastBackPressed;
  final List<int> _tabHistory = [0];

  // One navigator key per real tab (0=Home, 1=Charge, 3=History).
  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(), // 0 – Home
    GlobalKey<NavigatorState>(), // 1 – Charge
    GlobalKey<NavigatorState>(), // 2 – QR (unused, action-only)
    GlobalKey<NavigatorState>(), // 3 – History
  ];

  void _appendTabHistory(int index) {
    if (_tabHistory.isNotEmpty && _tabHistory.last == index) return;
    _tabHistory.add(index);
    if (_tabHistory.length > _maxTabHistory) {
      _tabHistory.removeRange(0, _tabHistory.length - _maxTabHistory);
    }
  }

  int _previousTabOrHome() {
    for (int i = _tabHistory.length - 2; i >= 0; i--) {
      final candidate = _tabHistory[i];
      if (candidate != _currentIndex) return candidate;
    }
    return 0;
  }

  void _trimHistoryAfterBack(int targetIndex) {
    while (_tabHistory.length > 1 && _tabHistory.last != targetIndex) {
      _tabHistory.removeLast();
    }
    if (_tabHistory.isEmpty || _tabHistory.last != targetIndex) {
      _appendTabHistory(targetIndex);
    }
  }

  void _onTabTapped(int index) {
    if (index == 2) {
      // QR: push full-screen on root navigator so camera covers everything.
      Navigator.of(context).pushNamed('/qr-scanner');
      return;
    }
    if (index == _currentIndex) {
      // Tapping the active tab again pops back to its root screen.
      _navigatorKeys[index].currentState?.popUntil((r) => r.isFirst);
      return;
    }

    setState(() {
      _currentIndex = index;
      _appendTabHistory(index);
    });
  }

  void _navigateToChargeFromHome() {
    _onTabTapped(1);
  }

  /// Intercept Android back button — pop within the tab's Navigator first.
  Future<bool> _onWillPop() async {
    final nav = _navigatorKeys[_currentIndex].currentState;
    if (nav != null && nav.canPop()) {
      nav.pop();
      return false; // handled within tab
    }

    // At a non-home tab root, go back to the previously visited tab.
    if (_currentIndex != 0) {
      setState(() {
        final target = _previousTabOrHome();
        _currentIndex = target;
        _trimHistoryAfterBack(target);
      });
      return false;
    }

    // Home root: double-back to exit.
    final now = DateTime.now();
    if (_lastBackPressed == null ||
        now.difference(_lastBackPressed!) > const Duration(seconds: 2)) {
      _lastBackPressed = now;
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('もう一度押すと終了します'),
            duration: Duration(seconds: 2),
          ),
        );
      }
      return false;
    }
    return true;
  }

  Widget _buildTabNavigator(int index, Widget rootScreen) {
    return Navigator(
      key: _navigatorKeys[index],
      onGenerateRoute: (settings) {
        // First check routes that live inside a tab (bar stays visible).
        final tabRoute = generateTabRoute(settings);
        if (tabRoute != null) return tabRoute;
        // Fallback: render the root screen for this tab (initial route).
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => rootScreen,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final shouldPop = await _onWillPop();
        if (shouldPop && context.mounted) SystemNavigator.pop();
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: IndexedStack(
          index: _currentIndex,
          children: [
            _buildTabNavigator(
              0,
              HomeScreen(onNavigateToCharge: _navigateToChargeFromHome),
            ), // 0 – Home
            _buildTabNavigator(1, const ChargeScreen()), // 1 – Charge
            const SizedBox.shrink(), // 2 – QR (action only)
            _buildTabNavigator(3, const HistoryScreen()), // 3 – History
          ],
        ),
        bottomNavigationBar: BottomNavBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          height: 80,
          iconSize: 28,
        ),
      ),
    );
  }
}
