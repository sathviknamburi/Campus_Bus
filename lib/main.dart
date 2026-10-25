import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_constants.dart';
import 'core/theme/app_colors.dart';
import 'providers/auth_provider.dart';
import 'providers/transit_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/intro_welcome_screen.dart';
import 'screens/main_navigation_screen.dart';

/// ============================================================================
/// SRKR CAMPUS BUS TRACKING SYSTEM
/// ============================================================================
///
/// Features:
/// 1. Sagi Rama Krishnam Raju (SRKR) Engineering College, Chinna Amiram, Bhimavaram, AP.
/// 2. 7 Regional Bus Corridors: Palakollu, Tanuku, Tadepalligudem, Narsapur, Akividu, Undi, Maruteru.
/// 3. Student Authentication:
///    - Reg No Pattern: 24B91AXXXX (10 characters)
///    - Password: Same as Registration Number
///    - Student Isolation: strictly displays ONLY the assigned bus for logged-in students.
/// 4. Vibrant Multi-Accent Design System with Route Chromatic Identities.
/// 5. Real-time GPS simulation with animated telemetry HUD.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Graceful fallback for layout warnings to prevent red screen crashes
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Material(
      color: Colors.white,
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.airport_shuttle_rounded, color: AppColors.primary, size: 48),
                const SizedBox(height: 12),
                const Text(
                  'SRKR Campus Bus Tracker',
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 8),
                Text(
                  details.exceptionAsString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  };

  runApp(const CampusBusApp());
}

/// [CampusBusApp] is the root of the application.
/// Injects [AuthProvider], [TransitProvider], and [ThemeProvider].
class CampusBusApp extends StatelessWidget {
  const CampusBusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => TransitProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer2<ThemeProvider, AuthProvider>(
        builder: (context, themeProvider, authProvider, _) {
          return MaterialApp(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            themeMode: themeProvider.themeMode,
            theme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.light,
              scaffoldBackgroundColor: AppColors.backgroundLight,
              colorScheme: ColorScheme.fromSeed(
                seedColor: AppColors.primary,
                brightness: Brightness.light,
                primary: AppColors.primary,
                secondary: AppColors.secondary,
                surface: AppColors.surfaceLight,
              ),
              textTheme: GoogleFonts.plusJakartaSansTextTheme(ThemeData.light().textTheme),
              appBarTheme: const AppBarTheme(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                centerTitle: false,
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.dark,
              scaffoldBackgroundColor: AppColors.backgroundDark,
              colorScheme: ColorScheme.fromSeed(
                seedColor: AppColors.primary,
                brightness: Brightness.dark,
                primary: AppColors.primaryLight,
                secondary: AppColors.secondary,
                surface: AppColors.surfaceDark,
              ),
              textTheme: GoogleFonts.plusJakartaSansTextTheme(ThemeData.dark().textTheme),
              appBarTheme: const AppBarTheme(
                backgroundColor: AppColors.surfaceDark,
                foregroundColor: Colors.white,
                elevation: 0,
              ),
            ),
            // Dynamic entry based on authentication state
            home: _resolveHomeScreen(authProvider),
          );
        },
      ),
    );
  }

  Widget _resolveHomeScreen(AuthProvider authProvider) {
    // 1. Initializing SharedPreferences session
    if (!authProvider.isInitialized) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(Icons.directions_bus_rounded, color: Colors.white, size: 48),
              ),
              const SizedBox(height: 24),
              const Text(
                'SRKR Campus Bus Tracker',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Syncing live fleet telemetry...',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
            ],
          ),
        ),
      );
    }

    // 2. If student is authenticated or browsing as guest, load main shell
    if (authProvider.isLoggedIn || authProvider.isGuestMode) {
      return const MainNavigationScreen();
    }

    // 3. For non-users / unauthenticated visitors, show the rich app introduction
    return const IntroWelcomeScreen();
  }
}
