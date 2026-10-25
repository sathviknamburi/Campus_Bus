import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/responsive.dart';
import '../models/bus_model.dart';
import '../models/route_model.dart';
import '../models/student_model.dart';
import '../providers/auth_provider.dart';
import '../providers/transit_provider.dart';
import '../widgets/bus_card.dart';
import 'login_screen.dart';

/// The Home Dashboard tab for SRKR Engineering College Bus Tracking.
///
/// Features Responsive Multi-Accent Design System via [MediaQuery]:
/// - Student Login: ONLY the student's assigned bus is displayed with full telemetry!
/// - Non-Users / Guests: Overview of all 7 campus routes with chromatic corridor filters.
/// - Responsive Split Layout: 2-column on Tablet/Desktop, fluid single column on Mobile.
class HomeTab extends StatelessWidget {
  final void Function(int) onNavigateToTab;

  const HomeTab({
    super.key,
    required this.onNavigateToTab,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final transitProvider = context.watch<TransitProvider>();
    final isStudent = authProvider.isStudentAuthenticated;
    final student = authProvider.currentStudent;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: isStudent && student != null
            ? _buildStudentAssignedBusView(context, authProvider, transitProvider, student)
            : _buildGuestExplorerView(context, authProvider, transitProvider),
      ),
    );
  }

  // ===========================================================================
  // 1. STUDENT VIEW: ONLY THE ASSIGNED BUS IS DISPLAYED (RESPONSIVE)
  // ===========================================================================

  Widget _buildStudentAssignedBusView(
    BuildContext context,
    AuthProvider auth,
    TransitProvider transit,
    StudentModel student,
  ) {
    final assignedBus = transit.getAssignedBus(student.assignedBusId);
    final route = assignedBus != null ? transit.getRouteById(assignedBus.routeId) : null;
    final routeColor = assignedBus != null
        ? AppColors.getRouteColor(assignedBus.routeName)
        : AppColors.primary;
    final routeGradient = assignedBus != null
        ? AppColors.getRouteGradient(assignedBus.routeName)
        : AppColors.primaryGradient;
    final isWide = MediaQuery.sizeOf(context).width >= 900;
    final horizontalPadding = context.responsivePadding;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: Responsive.maxContentWidth),
        child: CustomScrollView(
          slivers: [
            // App Bar & Student Header
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(horizontalPadding, 16, horizontalPadding, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Identity & Simulation Status
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(9),
                                decoration: BoxDecoration(
                                  gradient: AppColors.primaryGradient,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primary.withValues(alpha: 0.35),
                                      blurRadius: 10,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: const Icon(Icons.school_rounded, color: Colors.white, size: 22),
                              ),
                              const SizedBox(width: 12),
                              const Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'SRKR Engineering College',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 16,
                                        color: AppColors.textPrimary,
                                        letterSpacing: -0.3,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      'Autonomous • Chinna Amiram, Bhimavaram',
                                      style: TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Simulation live indicator
                        InkWell(
                          onTap: transit.toggleSimulation,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: transit.isSimulationRunning
                                  ? AppColors.liveGreen.withValues(alpha: 0.12)
                                  : AppColors.warningAmber.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: transit.isSimulationRunning
                                    ? AppColors.liveGreen.withValues(alpha: 0.5)
                                    : AppColors.warningAmber.withValues(alpha: 0.5),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: transit.isSimulationRunning ? AppColors.liveGreen : AppColors.warningAmber,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      if (transit.isSimulationRunning)
                                        BoxShadow(
                                          color: AppColors.liveGreen.withValues(alpha: 0.6),
                                          blurRadius: 4,
                                          spreadRadius: 1,
                                        ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  transit.isSimulationRunning ? 'LIVE (3s)' : 'PAUSED',
                                  style: TextStyle(
                                    color: transit.isSimulationRunning ? AppColors.liveGreen : AppColors.warningAmber,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // Official SRKR Engineering College Aerial Campus Banner
                    _buildCampusHeroBanner(context),

                    const SizedBox(height: 14),

                    // Student Identity Card (Vibrant Holographic Pass)
                    _buildStudentPassCard(student),

                    const SizedBox(height: 20),

                    // Assigned Bus Section Title Banner
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Icon(Icons.directions_bus_filled_rounded, color: routeColor, size: 22),
                              const SizedBox(width: 8),
                              const Expanded(
                                child: Text(
                                  'Your Designated College Bus',
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
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                          decoration: BoxDecoration(
                            color: routeColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: routeColor.withValues(alpha: 0.3)),
                          ),
                          child: Text(
                            'ONLY ASSIGNED',
                            style: TextStyle(
                              color: routeColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Per SRKR transport policy, only your assigned vehicle telemetry is displayed below:',
                      style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),

            // Assigned Bus Card Presentation (Responsive 2-Column or 1-Column)
            if (assignedBus == null)
              const SliverFillRemaining(
                child: Center(child: Text('Assigned bus record could not be loaded.')),
              )
            else if (isWide)
              // Widescreen Tablet / Desktop 2-Column Layout
              SliverPadding(
                padding: EdgeInsets.fromLTRB(horizontalPadding, 0, horizontalPadding, 24),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left Column: Bus Hero Card
                      Expanded(
                        flex: 6,
                        child: _buildAssignedBusHeroCard(context, transit, assignedBus, route, student, routeColor, routeGradient),
                      ),
                      const SizedBox(width: 18),
                      // Right Column: Boarding point ETA, driver info, and alerts
                      Expanded(
                        flex: 5,
                        child: Column(
                          children: [
                            _buildBoardingPointEtaCard(transit, assignedBus, student, routeColor),
                            const SizedBox(height: 18),
                            _buildDriverActionCard(context, assignedBus, routeColor, routeGradient),
                            const SizedBox(height: 18),
                            _buildAssignedRouteAlerts(transit, assignedBus, routeColor),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              // Mobile Fluid Stacked Layout
              SliverPadding(
                padding: EdgeInsets.fromLTRB(horizontalPadding, 0, horizontalPadding, 24),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildAssignedBusHeroCard(context, transit, assignedBus, route, student, routeColor, routeGradient),
                    const SizedBox(height: 18),
                    _buildBoardingPointEtaCard(transit, assignedBus, student, routeColor),
                    const SizedBox(height: 18),
                    _buildDriverActionCard(context, assignedBus, routeColor, routeGradient),
                    const SizedBox(height: 18),
                    _buildAssignedRouteAlerts(transit, assignedBus, routeColor),
                  ]),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentPassCard(StudentModel student) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: AppColors.heroGradient,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(
                  gradient: AppColors.sunsetGradient,
                  shape: BoxShape.circle,
                ),
                child: const CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person_rounded, color: AppColors.primary, size: 30),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            student.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            gradient: AppColors.sunsetGradient,
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.secondary.withValues(alpha: 0.4),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: const Text(
                            'VERIFIED PASS',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Reg: ${student.regNo} • ${student.branch}',
                      style: const TextStyle(color: Color(0xFFC7D2FE), fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      student.year,
                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
            ),
            child: Row(
              children: [
                const Icon(Icons.place_rounded, size: 16, color: Color(0xFFFF9E0B)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Designated Stop: ${student.boardingStop}',
                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Text(
                  '⇄ Campus Hub',
                  style: TextStyle(color: Color(0xFFC7D2FE), fontSize: 11, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Hero Card for Assigned Bus with Chromatic Gradient
  Widget _buildAssignedBusHeroCard(
    BuildContext context,
    TransitProvider transit,
    BusModel bus,
    BusRoute? route,
    StudentModel student,
    Color routeColor,
    LinearGradient routeGradient,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: routeColor.withValues(alpha: 0.25), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: routeColor.withValues(alpha: 0.14),
            blurRadius: 22,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Ribbon with Route Gradient
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              gradient: routeGradient,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.directions_bus_rounded, color: Colors.white, size: 18),
                            const SizedBox(width: 6),
                            Text(
                              bus.busNumber,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 14,
                                letterSpacing: 0.6,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.12),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 7,
                                height: 7,
                                decoration: BoxDecoration(
                                  color: bus.statusColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Flexible(
                                child: Text(
                                  bus.statusLabel,
                                  style: TextStyle(
                                    color: bus.statusColor,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 11,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'SRKR FLEET',
                    style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900),
                  ),
                ),
              ],
            ),
          ),

          // Main Card Body
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bus.routeName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 2),
                const Row(
                  children: [
                    Icon(Icons.hub_outlined, size: 13, color: AppColors.textMuted),
                    SizedBox(width: 4),
                    Text(
                      'Dedicated Regional Route Corridor',
                      style: TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Next Approaching Stop Banner
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: routeColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: routeColor.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: routeColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.near_me_rounded, size: 16, color: Colors.white),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'NEXT APPROACHING STOP',
                              style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.textSecondary, letterSpacing: 0.5),
                            ),
                            Text(
                              bus.nextStopName,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          gradient: routeGradient,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: routeColor.withValues(alpha: 0.35),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          '${bus.nextStopEtaMinutes} MIN ETA',
                          style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w900),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Seating Occupancy & Speed metrics
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.airline_seat_recline_normal_rounded, size: 16, color: bus.occupancyColor),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              '${bus.occupiedSeats}/${bus.totalCapacity} Seats Taken (${bus.occupancyPercentage}%)',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: bus.occupancyColor,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.speed_rounded, size: 16, color: AppColors.textSecondary),
                        const SizedBox(width: 6),
                        Text(
                          '${bus.speedKmh.toStringAsFixed(0)} km/h',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: bus.occupancyRatio,
                    minHeight: 6,
                    backgroundColor: const Color(0xFFF1F5F9),
                    valueColor: AlwaysStoppedAnimation<Color>(bus.occupancyColor),
                  ),
                ),

                const SizedBox(height: 16),

                // Live Telemetry Coordinates Grid (3 Micro Cards)
                Row(
                  children: [
                    Expanded(child: _buildCoordCard('LATITUDE', bus.currentLatitude.toStringAsFixed(4), routeColor, Icons.my_location)),
                    const SizedBox(width: 8),
                    Expanded(child: _buildCoordCard('LONGITUDE', bus.currentLongitude.toStringAsFixed(4), routeColor, Icons.location_on_outlined)),
                    const SizedBox(width: 8),
                    Expanded(child: _buildCoordCard('HEADING', '${bus.heading.toStringAsFixed(0)}°', routeColor, Icons.explore_outlined)),
                  ],
                ),

                const SizedBox(height: 18),

                // Live Track CTA Button
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: routeGradient,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: routeColor.withValues(alpha: 0.35),
                          blurRadius: 14,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () {
                        transit.selectBus(bus);
                        onNavigateToTab(1); // Go to Track Tab
                      },
                      icon: const Icon(Icons.navigation_rounded, size: 18),
                      label: const Text(
                        'TRACK YOUR ASSIGNED BUS LIVE ON MAP',
                        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 0.5),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoordCard(String label, String value, Color accent, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          Icon(icon, size: 14, color: accent),
          const SizedBox(height: 3),
          Text(label, style: const TextStyle(fontSize: 9, color: AppColors.textMuted, letterSpacing: 0.5, fontWeight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
        ],
      ),
    );
  }

  Widget _buildBoardingPointEtaCard(TransitProvider transit, BusModel bus, StudentModel student, Color routeColor) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.departure_board_rounded, color: routeColor, size: 20),
                  const SizedBox(width: 8),
                  const Text(
                    'Your Boarding Point Status',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: AppColors.textPrimary),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.liveGreen.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'CONFIRMED STOP',
                  style: TextStyle(color: AppColors.liveGreen, fontSize: 10, fontWeight: FontWeight.w900),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: routeColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.location_on, color: routeColor, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student.boardingStop,
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Bus arrives at morning pickup schedule (07:15 AM - 08:00 AM)',
                      style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 24, color: AppColors.cardBorder),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('College Campus Arrival:', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                  Text('SRKR Chinna Amiram', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.schedule, size: 14, color: routeColor),
                    const SizedBox(width: 4),
                    const Text(
                      'Target: 08:35 AM',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDriverActionCard(BuildContext context, BusModel bus, Color routeColor, LinearGradient routeGradient) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: routeGradient,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                bus.driverName.substring(0, 1),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bus.driverName,
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: AppColors.textPrimary),
                ),
                Text(
                  'Designated Driver • ${bus.driverPhone}',
                  style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: routeColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Dialing driver ${bus.driverName} (${bus.driverPhone})...'),
                  backgroundColor: routeColor,
                ),
              );
            },
            icon: const Icon(Icons.call, size: 14),
            label: const Text('Call', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildAssignedRouteAlerts(TransitProvider transit, BusModel bus, Color routeColor) {
    final alerts = transit.alerts;
    if (alerts.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Route Bulletins & Advisories',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 8),
        ...alerts.take(2).map((alert) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: alert.color.withValues(alpha: 0.3)),
              boxShadow: [
                BoxShadow(
                  color: alert.color.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: alert.color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(alert.icon, color: alert.color, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(alert.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary)),
                      const SizedBox(height: 2),
                      Text(alert.message, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // ===========================================================================
  // 2. GUEST / NON-USER VIEW (RESPONSIVE GRID)
  // ===========================================================================

  Widget _buildGuestExplorerView(
    BuildContext context,
    AuthProvider auth,
    TransitProvider transit,
  ) {
    final buses = transit.filteredBuses;
    final routes = transit.routes;
    final horizontalPadding = context.responsivePadding;
    final columns = Responsive.gridColumns(context, mobile: 1, tablet: 2, desktop: 2);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: Responsive.maxContentWidth),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(horizontalPadding, 16, horizontalPadding, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Identity & Simulation Status
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'SRKR Engineering College',
                                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 17, color: AppColors.textPrimary, letterSpacing: -0.3),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'Campus Transit Guest Directory',
                                style: TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            elevation: 0,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
                            );
                          },
                          child: const Text('Student Login', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900)),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // Official SRKR Engineering College Aerial Campus Banner
                    _buildCampusHeroBanner(context),

                    const SizedBox(height: 14),

                    // Guest Banner Prompting Student Login
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 18,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.22),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'GUEST MODE',
                                  style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Expanded(
                                child: Text(
                                  '7 Regional Corridors Active',
                                  textAlign: TextAlign.end,
                                  style: TextStyle(color: Color(0xFFC7D2FE), fontSize: 11, fontWeight: FontWeight.w600),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Student Bus Isolation',
                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Log in with your 24B91AXXXX registration number to view only your assigned college bus and live stop ETA.',
                            style: TextStyle(color: Color(0xFFE0E7FF), fontSize: 12),
                          ),
                          const SizedBox(height: 14),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              elevation: 0,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
                              );
                            },
                            icon: const Icon(Icons.login_rounded, size: 16),
                            label: const Text('Login as Student (24B91AXXXX)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900)),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Search Field
                    TextField(
                      onChanged: transit.setSearchQuery,
                      decoration: InputDecoration(
                        hintText: 'Search destination, bus number, or driver...',
                        hintStyle: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                        prefixIcon: const Icon(Icons.search_rounded, size: 20, color: AppColors.primary),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.cardBorder)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.cardBorder)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.primary, width: 2.0)),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Route Filter Chips with Chromatic Colors
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          ChoiceChip(
                            label: const Text('All 7 Corridors'),
                            selected: transit.selectedRouteId == null,
                            onSelected: (_) => transit.selectRouteFilter(null),
                            selectedColor: AppColors.primary,
                            backgroundColor: Colors.white,
                            side: BorderSide(
                              color: transit.selectedRouteId == null ? AppColors.primary : AppColors.cardBorder,
                            ),
                            labelStyle: TextStyle(
                              color: transit.selectedRouteId == null ? Colors.white : AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                              fontSize: 11,
                            ),
                          ),
                          const SizedBox(width: 8),
                          ...routes.map((r) {
                            final isSelected = transit.selectedRouteId == r.id;
                            final rColor = AppColors.getRouteColor(r.routeName);
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                label: Text(r.routeCode),
                                selected: isSelected,
                                onSelected: (_) => transit.selectRouteFilter(r.id),
                                selectedColor: rColor,
                                backgroundColor: Colors.white,
                                side: BorderSide(
                                  color: isSelected ? rColor : AppColors.cardBorder,
                                ),
                                labelStyle: TextStyle(
                                  color: isSelected ? Colors.white : AppColors.textPrimary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11,
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Campus Fleet Buses (${buses.length})',
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Live GPS Connected',
                          style: TextStyle(fontSize: 11, color: AppColors.liveGreen, fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),

            // Bus List: Responsive Column / Grid Layout
            if (columns > 1)
              // 2-Column Responsive Layout for Tablet & Desktop
              SliverPadding(
                padding: EdgeInsets.fromLTRB(horizontalPadding, 0, horizontalPadding, 24),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, rowIndex) {
                      final firstIndex = rowIndex * 2;
                      final secondIndex = firstIndex + 1;
                      final bus1 = buses[firstIndex];
                      final bus2 = secondIndex < buses.length ? buses[secondIndex] : null;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: BusCard(
                                bus: bus1,
                                isFavorite: transit.isFavorite(bus1.id),
                                onFavoriteToggle: () => transit.toggleFavorite(bus1.id),
                                onTrackTap: () {
                                  transit.selectBus(bus1);
                                  onNavigateToTab(1);
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            if (bus2 != null)
                              Expanded(
                                child: BusCard(
                                  bus: bus2,
                                  isFavorite: transit.isFavorite(bus2.id),
                                  onFavoriteToggle: () => transit.toggleFavorite(bus2.id),
                                  onTrackTap: () {
                                    transit.selectBus(bus2);
                                    onNavigateToTab(1);
                                  },
                                ),
                              )
                            else
                              const Expanded(child: SizedBox()),
                          ],
                        ),
                      );
                    },
                    childCount: (buses.length / 2).ceil(),
                  ),
                ),
              )
            else
              // Single Column Layout for Mobile
              SliverPadding(
                padding: EdgeInsets.fromLTRB(horizontalPadding, 0, horizontalPadding, 24),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final bus = buses[index];
                      return BusCard(
                        bus: bus,
                        isFavorite: transit.isFavorite(bus.id),
                        onFavoriteToggle: () => transit.toggleFavorite(bus.id),
                        onTrackTap: () {
                          transit.selectBus(bus);
                          onNavigateToTab(1);
                        },
                      );
                    },
                    childCount: buses.length,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Official SRKR Engineering College Aerial Campus Banner with Emblem.
  Widget _buildCampusHeroBanner(BuildContext context) {
    final bannerRatio = Responsive.bannerAspectRatio(context);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.cardBorder, width: 1.4),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.12),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: AspectRatio(
          aspectRatio: bannerRatio,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/images/srkr_campus.jpg',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: const BoxDecoration(
                      gradient: AppColors.heroGradient,
                    ),
                    child: const Center(
                      child: Icon(Icons.school_rounded, size: 64, color: Colors.white),
                    ),
                  );
                },
              ),
              // Gradient overlays for text readability
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.4),
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.8),
                    ],
                    stops: const [0.0, 0.45, 1.0],
                  ),
                ),
              ),
              // Top Badges
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.school, color: Colors.white, size: 13),
                      SizedBox(width: 5),
                      Text(
                        'SRKR ENGINEERING COLLEGE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.95),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'ESTD. 1980',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              // Bottom Details
              Positioned(
                bottom: 12,
                left: 14,
                right: 14,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Chinna Amiram, Bhimavaram',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              shadows: [
                                Shadow(color: Colors.black87, blurRadius: 6),
                              ],
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Central Campus Bus Bay • 7 Regional Corridors',
                            style: TextStyle(
                              color: Color(0xFFE0E7FF),
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              shadows: [
                                Shadow(color: Colors.black87, blurRadius: 6),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.circle, color: Color(0xFF10B981), size: 8),
                          SizedBox(width: 5),
                          Text(
                            'Fleet Active',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
