import 'package:flutter/material.dart';
import '../theme/design_system.dart';

class BottomNavBar extends StatelessWidget {
  final int? currentIndex;
  final ValueChanged<int>? onTap;
  final double? height;
  final double? iconSize;

  const BottomNavBar({
    super.key,
    this.currentIndex,
    this.onTap,
    this.height,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.background,
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: height ?? kBottomNavigationBarHeight,
          child: BottomNavigationBar(
            iconSize: iconSize ?? 24,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            currentIndex: currentIndex ?? 0,
            onTap: (index) {
              if (onTap != null) return onTap!(index);
              // Default navigation behavior when no onTap provided
              switch (index) {
                case 0:
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil('/home', (route) => false);
                  break;
                case 1:
                  Navigator.of(context).pushNamed('/charge');
                  break;
                case 2:
                  Navigator.of(context).pushNamed('/qr-scanner');
                  break;
                case 3:
                  Navigator.of(context).pushNamed('/history');
                  break;
              }
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: AppColors.background,
            selectedItemColor: AppColors.primaryBlue,
            unselectedItemColor: AppColors.primaryBlue.withValues(alpha: 0.5),
            showSelectedLabels: false,
            showUnselectedLabels: false,
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add_circle_outline),
                activeIcon: Icon(Icons.add_circle),
                label: 'Charge',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.qr_code_scanner),
                label: 'Scan',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.access_time),
                activeIcon: Icon(Icons.access_time_filled),
                label: 'History',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
