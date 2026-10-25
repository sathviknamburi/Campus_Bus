import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/responsive.dart';
import '../providers/transit_provider.dart';
import 'home_tab.dart';
import 'track_tab.dart';
import 'routes_tab.dart';
import 'alerts_tab.dart';
import 'profile_tab.dart';

/// Master navigation shell hosting the 5 primary tabs of Campus Bus Tracker.
/// Dynamically adapts using [MediaQuery]:
/// - Desktop / Tablet (>650px): Elegant side [NavigationRail] with college branding.
/// - Mobile (<650px): Modern elevated bottom [NavigationBar].
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  void _navigateToTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final unreadAlerts = context.watch<TransitProvider>().unreadAlertsCount;
    final isDesktopOrTablet = !context.isMobile;

    final List<Widget> screens = [
      HomeTab(onNavigateToTab: _navigateToTab),
      const TrackTab(),
      RoutesTab(onNavigateToTab: _navigateToTab),
      const AlertsTab(),
      ProfileTab(onNavigateToTab: _navigateToTab),
    ];

    if (isDesktopOrTablet) {
      return Scaffold(
        body: Row(
          children: [
            // Responsive Side Navigation Rail
            NavigationRail(
              selectedIndex: _currentIndex,
              onDestinationSelected: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              backgroundColor: Colors.white,
              indicatorColor: AppColors.primarySoft,
              extended: context.screenWidth >= 1150,
              minExtendedWidth: 200,
              elevation: 4,
              leading: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.school_rounded, color: Colors.white, size: 20),
                    ),
                    if (context.screenWidth >= 1150) ...[
                      const SizedBox(width: 10),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SRKR TRANSIT',
                            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: AppColors.textPrimary),
                          ),
                          Text(
                            'Fleet Telemetry',
                            style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              destinations: [
                const NavigationRailDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home_rounded, color: AppColors.primary),
                  label: Text('Home'),
                ),
                const NavigationRailDestination(
                  icon: Icon(Icons.near_me_outlined),
                  selectedIcon: Icon(Icons.near_me_rounded, color: AppColors.primary),
                  label: Text('Live Track'),
                ),
                const NavigationRailDestination(
                  icon: Icon(Icons.alt_route_outlined),
                  selectedIcon: Icon(Icons.alt_route_rounded, color: AppColors.primary),
                  label: Text('Routes'),
                ),
                NavigationRailDestination(
                  icon: Badge(
                    isLabelVisible: unreadAlerts > 0,
                    label: Text('$unreadAlerts'),
                    backgroundColor: AppColors.secondary,
                    child: const Icon(Icons.notifications_none_rounded),
                  ),
                  selectedIcon: Badge(
                    isLabelVisible: unreadAlerts > 0,
                    label: Text('$unreadAlerts'),
                    backgroundColor: AppColors.secondary,
                    child: const Icon(Icons.notifications_rounded, color: AppColors.primary),
                  ),
                  label: const Text('Alerts'),
                ),
                const NavigationRailDestination(
                  icon: Icon(Icons.person_outline_rounded),
                  selectedIcon: Icon(Icons.person_rounded, color: AppColors.primary),
                  label: Text('Profile'),
                ),
              ],
            ),
            const VerticalDivider(thickness: 1, width: 1, color: AppColors.cardBorder),
            // Primary Screen Content
            Expanded(
              child: IndexedStack(
                index: _currentIndex,
                children: screens,
              ),
            ),
          ],
        ),
      );
    }

    // Mobile Viewport Navigation
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: const Border(
            top: BorderSide(color: AppColors.cardBorder, width: 1.2),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: Colors.white,
          indicatorColor: AppColors.primarySoft,
          elevation: 0,
          height: 68,
          destinations: [
            const NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded, color: AppColors.primary),
              label: 'Home',
            ),
            const NavigationDestination(
              icon: Icon(Icons.near_me_outlined),
              selectedIcon: Icon(Icons.near_me_rounded, color: AppColors.primary),
              label: 'Track',
            ),
            const NavigationDestination(
              icon: Icon(Icons.alt_route_outlined),
              selectedIcon: Icon(Icons.alt_route_rounded, color: AppColors.primary),
              label: 'Routes',
            ),
            NavigationDestination(
              icon: Badge(
                isLabelVisible: unreadAlerts > 0,
                label: Text('$unreadAlerts'),
                backgroundColor: AppColors.secondary,
                child: const Icon(Icons.notifications_none_rounded),
              ),
              selectedIcon: Badge(
                isLabelVisible: unreadAlerts > 0,
                label: Text('$unreadAlerts'),
                backgroundColor: AppColors.secondary,
                child: const Icon(Icons.notifications_rounded, color: AppColors.primary),
              ),
              label: 'Alerts',
            ),
            const NavigationDestination(
              icon: Icon(Icons.person_outline_rounded),
              selectedIcon: Icon(Icons.person_rounded, color: AppColors.primary),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
