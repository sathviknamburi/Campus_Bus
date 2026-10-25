import 'package:flutter/material.dart';

/// Centralized, ultra-vibrant color palette for SRKR Campus Bus Tracker.
/// Features high-contrast modern surfaces, multi-tone gradients, and
/// route-specific chromatic identities for all 7 regional transit corridors.
class AppColors {
  // Brand Primary: Electric Sapphire & Indigo
  static const Color primary = Color(0xFF4F46E5); // Electric Indigo
  static const Color primaryDark = Color(0xFF3730A3); // Deep Royal Indigo
  static const Color primaryLight = Color(0xFF818CF8); // Bright Periwinkle
  static const Color primarySoft = Color(0xFFEEF2FF); // Soft Lavender Mist
  static const Color primaryGlow = Color(0x334F46E5);

  // Vibrant Secondary Accent: Radiant Sunset Coral
  static const Color secondary = Color(0xFFFF5E1E); // Vivid Tangerine
  static const Color secondaryDark = Color(0xFFD94406);
  static const Color secondaryLight = Color(0xFFFF8533);
  static const Color secondarySoft = Color(0xFFFFF1EB);
  static const Color orangeGlow = Color(0x33FF5E1E);

  // Status & Telemetry Indicators
  static const Color liveGreen = Color(0xFF10B981); // Emerald Active/Live
  static const Color liveGreenGlow = Color(0xFF34D399);
  static const Color warningAmber = Color(0xFFF59E0B); // Delays / Alerts
  static const Color dangerRed = Color(0xFFEF4444); // Cancelled / Emergency
  static const Color accentGold = Color(0xFFFBBF24); // Gold Verified Badge
  static const Color accentCyan = Color(0xFF06B6D4); // Cyan / Compass
  static const Color accentViolet = Color(0xFF8B5CF6); // Royal Violet
  static const Color accentRose = Color(0xFFF43F5E); // Electric Rose

  // Background & Surfaces (Crisp Pearl Slate & Pure White)
  static const Color backgroundLight = Color(0xFFF8FAFC); // Clean pearl-slate backdrop
  static const Color surfaceLight = Colors.white;
  static const Color cardBorder = Color(0xFFE2E8F0); // Crisp hairline border
  static const Color cardBorderOrange = Color(0xFFFFD8C2); // Coral accent border
  static const Color cardBorderIndigo = Color(0xFFC7D2FE); // Indigo accent border

  // Dark Mode Surfaces
  static const Color backgroundDark = Color(0xFF0F172A); // Deep slate midnight
  static const Color surfaceDark = Color(0xFF1E293B); // Elevated midnight card
  static const Color cardBorderDark = Color(0xFF334155);

  // Typography / Neutral Text
  static const Color textPrimary = Color(0xFF0F172A); // Deep slate high-contrast
  static const Color textSecondary = Color(0xFF475569); // Crisp medium slate
  static const Color textMuted = Color(0xFF94A3B8); // Subtle slate hint

  // Distinct Route Corridors (7 Regional Paths)
  static const Color routePalakollu = Color(0xFF2563EB); // Royal Blue
  static const Color routeTanuku = Color(0xFF10B981); // Emerald Green
  static const Color routeTadepalligudem = Color(0xFFF97316); // Sunset Coral
  static const Color routeNarsapur = Color(0xFF8B5CF6); // Vivid Violet
  static const Color routeAkividu = Color(0xFF06B6D4); // Electric Cyan
  static const Color routeUndi = Color(0xFFEC4899); // Neon Pink
  static const Color routeMaruteru = Color(0xFFE11D48); // Rose Crimson

  // Modern Multi-Tone Linear Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient orangeGradient = LinearGradient(
    colors: [Color(0xFFFF5E1E), Color(0xFFFF8A00)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF1E1B4B), Color(0xFF312E81), Color(0xFF4338CA)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient sunsetGradient = LinearGradient(
    colors: [Color(0xFFFF5E1E), Color(0xFFF59E0B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient emeraldGradient = LinearGradient(
    colors: [Color(0xFF059669), Color(0xFF10B981)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient oceanGradient = LinearGradient(
    colors: [Color(0xFF0284C7), Color(0xFF06B6D4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient violetGradient = LinearGradient(
    colors: [Color(0xFF6D28D9), Color(0xFF8B5CF6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient pinkGradient = LinearGradient(
    colors: [Color(0xFFDB2777), Color(0xFFEC4899)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient roseGradient = LinearGradient(
    colors: [Color(0xFFBE123C), Color(0xFFF43F5E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient auroraGradient = LinearGradient(
    colors: [Color(0xFF4F46E5), Color(0xFF06B6D4), Color(0xFF10B981)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGlowGradient = LinearGradient(
    colors: [Color(0xFFF8FAFC), Colors.white],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// Resolves the dedicated vibrant color for any of the 7 regional corridors.
  static Color getRouteColor(String? routeNameOrId) {
    if (routeNameOrId == null) return primary;
    final lower = routeNameOrId.toLowerCase();
    if (lower.contains('palakollu') || lower.contains('r1') || lower.contains('_01')) {
      return routePalakollu;
    }
    if (lower.contains('tanuku') || lower.contains('r2') || lower.contains('_02')) {
      return routeTanuku;
    }
    if (lower.contains('tadepalligudem') || lower.contains('r3') || lower.contains('_03')) {
      return routeTadepalligudem;
    }
    if (lower.contains('narsapur') || lower.contains('r4') || lower.contains('_04')) {
      return routeNarsapur;
    }
    if (lower.contains('akividu') || lower.contains('r5') || lower.contains('_05')) {
      return routeAkividu;
    }
    if (lower.contains('undi') || lower.contains('r6') || lower.contains('_06')) {
      return routeUndi;
    }
    if (lower.contains('maruteru') || lower.contains('r7') || lower.contains('_07')) {
      return routeMaruteru;
    }
    return primary;
  }

  /// Resolves the 2-stop linear gradient for any of the 7 regional corridors.
  static LinearGradient getRouteGradient(String? routeNameOrId) {
    final c = getRouteColor(routeNameOrId);
    if (c == routePalakollu) {
      return const LinearGradient(
        colors: [Color(0xFF1D4ED8), Color(0xFF3B82F6)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
    if (c == routeTanuku) {
      return emeraldGradient;
    }
    if (c == routeTadepalligudem) {
      return orangeGradient;
    }
    if (c == routeNarsapur) {
      return violetGradient;
    }
    if (c == routeAkividu) {
      return oceanGradient;
    }
    if (c == routeUndi) {
      return pinkGradient;
    }
    if (c == routeMaruteru) {
      return roseGradient;
    }
    return primaryGradient;
  }

  /// Resolves a soft translucent tint for chips and indicator backgrounds.
  static Color getRouteSoftColor(String? routeNameOrId) {
    return getRouteColor(routeNameOrId).withValues(alpha: 0.12);
  }
}
