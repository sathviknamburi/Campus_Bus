import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_constants.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/responsive.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';

/// Comprehensive Introduction & Welcome Portal for Non-Users and Students.
/// Transformed to a high-vibrancy, modern multi-accent campus transit aesthetic
/// with full [MediaQuery] responsiveness across Mobile, Tablet, and Desktop displays.
class IntroWelcomeScreen extends StatelessWidget {
  const IntroWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    final isWidescreen = context.screenWidth >= 850;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top Hero Banner with Vibrant Indigo-Violet Gradient
              Container(
                decoration: const BoxDecoration(
                  gradient: AppColors.heroGradient,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x334F46E5),
                      blurRadius: 22,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 960),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        context.isMobile ? 20 : 32,
                        24,
                        context.isMobile ? 20 : 32,
                        28,
                      ),
                      child: Column(
                        children: [
                          // College Crest / Badge
                          Container(
                            width: 88,
                            height: 88,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.25),
                                  blurRadius: 18,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/images/srkr_campus.jpg',
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const Icon(
                                  Icons.school_rounded,
                                  color: AppColors.primary,
                                  size: 48,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),

                          // College Title
                          const Text(
                            'SRKR ENGINEERING COLLEGE',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.1,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Autonomous • Affiliated to JNTUK • Estd. 1980',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFFC7D2FE),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.location_on_rounded, size: 14, color: Color(0xFFFF9E0B)),
                                SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    'Chinna Amiram, Bhimavaram, AP - 534204',
                                    style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 18),

                          // SRKR Campus Aerial Card with responsive aspect ratio
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.8), width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 18,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: AspectRatio(
                                aspectRatio: Responsive.bannerAspectRatio(context),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Image.asset(
                                      'assets/images/srkr_campus.jpg',
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => const Center(
                                        child: Icon(Icons.school_rounded, size: 48, color: AppColors.primary),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.transparent,
                                            Colors.black.withValues(alpha: 0.75),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const Positioned(
                                      bottom: 12,
                                      left: 14,
                                      right: 14,
                                      child: Text(
                                        'SRKR Central Campus • Bhimavaram',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w900,
                                          shadows: [
                                            Shadow(color: Colors.black, blurRadius: 6),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 18),

                          // Official Intro Card
                          Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 14,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        gradient: AppColors.primaryGradient,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(Icons.directions_bus_rounded, color: Colors.white, size: 24),
                                    ),
                                    const SizedBox(width: 12),
                                    const Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Official Campus Transit Portal',
                                            style: TextStyle(
                                              color: AppColors.textPrimary,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w900,
                                              letterSpacing: -0.3,
                                            ),
                                          ),
                                          Text(
                                            'Live GPS Telemetry & Student Tracking',
                                            style: TextStyle(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  'Welcome to the SRKR Engineering College smart transit system. '
                                  'Our fleet connects over 4,000 day scholars daily across West Godavari '
                                  'district with real-time GPS telemetry, seat vacancy alerts, and exact arrival times.',
                                  style: TextStyle(color: AppColors.textSecondary, fontSize: 12, height: 1.45),
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Light Content Body (Vibrant Responsive Styling)
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1050),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.isMobile ? 16 : 28,
                      vertical: 24,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Section 1: 7 Connected Nearby Locations
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppColors.primarySoft,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.hub_rounded, color: AppColors.primary, size: 20),
                            ),
                            const SizedBox(width: 10),
                            const Expanded(
                              child: Text(
                                '7 Regional Bus Corridors',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.textPrimary,
                                  letterSpacing: -0.3,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'All corridors connect directly to SRKR Engineering College Campus as the common destination:',
                          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 14),

                        // Grid of 7 locations with individual chromatic accents & dynamic MediaQuery columns
                        _buildDestinationsGrid(),

                        const SizedBox(height: 24),

                        // Section 2: Key Features of the App (responsive multi-column)
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppColors.secondarySoft,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.bolt_rounded, color: AppColors.secondary, size: 20),
                            ),
                            const SizedBox(width: 10),
                            const Expanded(
                              child: Text(
                                'Key Transit Capabilities',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.textPrimary,
                                  letterSpacing: -0.3,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        _buildFeaturesGrid(context),

                        const SizedBox(height: 24),

                        // Section 3 & 4: Call to Action + Demos + Helpline
                        // Adaptive layout: 2-column split on desktop/tablet, stacked vertically on mobile
                        if (isWidescreen)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 6,
                                child: _buildLoginCtaCard(context, authProvider),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                flex: 5,
                                child: Column(
                                  children: [
                                    _buildQuickDemosCard(context),
                                    const SizedBox(height: 16),
                                    _buildHelplineCard(),
                                  ],
                                ),
                              ),
                            ],
                          )
                        else ...[
                          _buildLoginCtaCard(context, authProvider),
                          const SizedBox(height: 20),
                          _buildQuickDemosCard(context),
                          const SizedBox(height: 20),
                          _buildHelplineCard(),
                        ],

                        const SizedBox(height: 28),
                        const Center(
                          child: Text(
                            '© S.R.K.R. Engineering College • Bhimavaram',
                            style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDestinationsGrid() {
    final destinations = [
      {'name': '1. Palakollu', 'dist': '21 km', 'bus': 'SRKR-01', 'color': AppColors.routePalakollu},
      {'name': '2. Tanuku', 'dist': '34 km', 'bus': 'SRKR-02', 'color': AppColors.routeTanuku},
      {'name': '3. Tadepalligudem', 'dist': '42 km', 'bus': 'SRKR-03', 'color': AppColors.routeTadepalligudem},
      {'name': '4. Narsapur', 'dist': '31 km', 'bus': 'SRKR-04', 'color': AppColors.routeNarsapur},
      {'name': '5. Akividu', 'dist': '17 km', 'bus': 'SRKR-05', 'color': AppColors.routeAkividu},
      {'name': '6. Undi', 'dist': '10 km', 'bus': 'SRKR-06', 'color': AppColors.routeUndi},
      {'name': '7. Maruteru', 'dist': '24 km', 'bus': 'SRKR-07', 'color': AppColors.routeMaruteru},
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        final int crossAxisCount = totalWidth >= 880 ? 4 : (totalWidth >= 520 ? 3 : 2);
        const spacing = 8.0;
        final itemWidth = (totalWidth - (spacing * (crossAxisCount - 1))) / crossAxisCount;

        return Column(
          children: [
            Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: destinations.map((dest) {
                final color = dest['color'] as Color;
                return SizedBox(
                  width: itemWidth,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: color.withValues(alpha: 0.3)),
                      boxShadow: [
                        BoxShadow(
                          color: color.withValues(alpha: 0.06),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: color.withValues(alpha: 0.5),
                                blurRadius: 4,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                dest['name'] as String,
                                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: AppColors.textPrimary),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                '${dest['dist']} • ${dest['bus']}',
                                style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            // Common Hub banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.school, size: 18, color: AppColors.liveGreen),
                  SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'Common Destination: SRKR Engineering College (Chinna Amiram)',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFeaturesGrid(BuildContext context) {
    final features = [
      (
        icon: Icons.person_pin_circle_rounded,
        iconColor: AppColors.primary,
        title: 'Personalized Student Bus Isolation',
        description: 'When students log in with their 24B91AXXXX registration number, '
            'only their assigned bus is displayed for maximum clarity.',
      ),
      (
        icon: Icons.satellite_alt_rounded,
        iconColor: AppColors.liveGreen,
        title: 'Live 3-Second GPS Telemetry',
        description: 'Real-time vehicle coordinates, speed, and heading simulation along '
            'highways towards Chinna Amiram campus.',
      ),
      (
        icon: Icons.airline_seat_recline_normal_rounded,
        iconColor: AppColors.secondary,
        title: 'Live Seating Occupancy Gauge',
        description: 'Check seat availability in real time before boarding at your local stop.',
      ),
      (
        icon: Icons.contact_emergency_rounded,
        iconColor: AppColors.accentViolet,
        title: 'Driver Contact & Emergency SOS',
        description: 'Direct phone dialer to your bus driver and the 24/7 SRKR Transport Helpline.',
      ),
    ];

    if (context.screenWidth >= 720) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [
                _buildFeatureItem(
                  icon: features[0].icon,
                  iconColor: features[0].iconColor,
                  title: features[0].title,
                  description: features[0].description,
                ),
                _buildFeatureItem(
                  icon: features[2].icon,
                  iconColor: features[2].iconColor,
                  title: features[2].title,
                  description: features[2].description,
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              children: [
                _buildFeatureItem(
                  icon: features[1].icon,
                  iconColor: features[1].iconColor,
                  title: features[1].title,
                  description: features[1].description,
                ),
                _buildFeatureItem(
                  icon: features[3].icon,
                  iconColor: features[3].iconColor,
                  title: features[3].title,
                  description: features[3].description,
                ),
              ],
            ),
          ),
        ],
      );
    }

    return Column(
      children: features
          .map(
            (f) => _buildFeatureItem(
              icon: f.icon,
              iconColor: f.iconColor,
              title: f.title,
              description: f.description,
            ),
          )
          .toList(),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginCtaCard(BuildContext context, AuthProvider authProvider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.cardBorder, width: 1.4),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.lock_person_rounded, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SRKR Student Portal Login',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      'Pattern: 24B91AXXXX',
                      style: TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Students enter their 10-character Registration Number (format: 24B91AXXXX). '
            'Your default password is identical to your registration number.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12, height: 1.45),
          ),
          const SizedBox(height: 16),

          Container(
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
                );
              },
              icon: const Icon(Icons.login_rounded, size: 18),
              label: const Text(
                'STUDENT LOGIN (24B91AXXXX)',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 0.5),
              ),
            ),
          ),

          const SizedBox(height: 10),

          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.textPrimary,
              side: const BorderSide(color: AppColors.cardBorder, width: 1.4),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              authProvider.continueAsGuest();
            },
            icon: const Icon(Icons.explore_outlined, size: 18, color: AppColors.primary),
            label: const Text(
              'Explore Routes & Timetable as Guest',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickDemosCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.touch_app_rounded, color: AppColors.primary, size: 18),
              SizedBox(width: 8),
              Text(
                'Quick Demo Logins (1-Tap Test):',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 13,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildQuickLoginChip(context, '24B91A0501', 'Palakollu (CSE)', AppColors.routePalakollu),
              _buildQuickLoginChip(context, '24B91A0502', 'Tanuku (ECE)', AppColors.routeTanuku),
              _buildQuickLoginChip(context, '24B91A0503', 'TPG (IT)', AppColors.routeTadepalligudem),
              _buildQuickLoginChip(context, '24B91A0504', 'Narsapur (AI&DS)', AppColors.routeNarsapur),
              _buildQuickLoginChip(context, '24B91A0505', 'Akividu (Mech)', AppColors.routeAkividu),
              _buildQuickLoginChip(context, '24B91A0506', 'Undi (Civil)', AppColors.routeUndi),
              _buildQuickLoginChip(context, '24B91A0507', 'Maruteru (CSD)', AppColors.routeMaruteru),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHelplineCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'SRKR Transport Cell Helpline',
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 10),
          _buildContactRow(Icons.person, 'Transport Incharge: ${AppConstants.transportIncharge}'),
          _buildContactRow(Icons.phone_rounded, 'Mobile: ${AppConstants.transportPhone}'),
          _buildContactRow(Icons.call, 'Office: ${AppConstants.transportOfficePhone}'),
          _buildContactRow(Icons.support_agent_rounded, 'Toll Free: ${AppConstants.emergencyHelpline}'),
          _buildContactRow(Icons.email_outlined, 'Email: ${AppConstants.transportEmail}'),
        ],
      ),
    );
  }

  Widget _buildQuickLoginChip(BuildContext context, String regNo, String label, Color chipColor) {
    return ActionChip(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      side: BorderSide(color: chipColor.withValues(alpha: 0.35)),
      avatar: Icon(Icons.login_rounded, size: 14, color: chipColor),
      label: Text(
        '$regNo ($label)',
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: chipColor),
      ),
      onPressed: () {
        context.read<AuthProvider>().login(regNo: regNo, password: regNo);
      },
    );
  }

  Widget _buildContactRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 15, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}
