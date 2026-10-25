import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/responsive.dart';
import '../models/bus_model.dart';
import '../models/route_model.dart';
import '../models/student_model.dart';
import '../providers/auth_provider.dart';
import '../providers/transit_provider.dart';

/// The Live Tracking tab for SRKR Campus Transit.
/// - Vibrant Multi-Accent Design System with Route Chromatic Identities.
/// - Responsive Split Layout via [MediaQuery]: 2-column on Tablet/Desktop, fluid single column on Mobile.
/// - Authenticated students: automatically locks onto assigned bus and boarding point.
/// - Guests: allows selecting any of the 7 regional corridor buses.
class TrackTab extends StatelessWidget {
  const TrackTab({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final transitProvider = context.watch<TransitProvider>();
    final isStudent = authProvider.isStudentAuthenticated;
    final student = authProvider.currentStudent;

    // Determine target bus: student's assigned bus takes absolute precedence
    BusModel? targetBus;
    if (isStudent && student != null) {
      targetBus = transitProvider.getAssignedBus(student.assignedBusId);
    } else {
      targetBus = transitProvider.selectedBus;
    }

    if (targetBus == null) {
      return const Scaffold(
        body: Center(child: Text('No active SRKR bus available for tracking.')),
      );
    }

    final route = transitProvider.getRouteById(targetBus.routeId);
    final allBuses = transitProvider.allBuses;
    final routeColor = AppColors.getRouteColor(targetBus.routeName);
    final routeGradient = AppColors.getRouteGradient(targetBus.routeName);
    final isWide = MediaQuery.sizeOf(context).width >= 900;
    final horizontalPadding = context.responsivePadding;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: routeGradient),
        ),
        foregroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.location_searching_rounded, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 10),
            Text(
              isStudent ? 'Your Assigned Bus Tracking' : 'SRKR Fleet Telemetry',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              transitProvider.isSimulationRunning ? Icons.pause_circle_filled_rounded : Icons.play_circle_fill_rounded,
              color: Colors.white,
              size: 26,
            ),
            tooltip: transitProvider.isSimulationRunning ? 'Pause GPS Telemetry' : 'Resume GPS Telemetry',
            onPressed: transitProvider.toggleSimulation,
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: Responsive.maxContentWidth),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Student Banner or Fleet Vehicle Selector
                if (isStudent && student != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: routeColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: routeColor.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.verified_user_rounded, color: routeColor, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Student Mode: Tracking assigned ${targetBus.busNumber} (${student.regNo})',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: routeColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ] else ...[
                  const Text(
                    'Select Regional Fleet Vehicle',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: allBuses.map((bus) {
                        final isSelected = bus.id == targetBus!.id;
                        final bColor = AppColors.getRouteColor(bus.routeName);
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            selected: isSelected,
                            label: Text('${bus.busNumber} (${bus.statusLabel})'),
                            labelStyle: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: isSelected ? Colors.white : AppColors.textPrimary,
                            ),
                            selectedColor: bColor,
                            backgroundColor: Colors.white,
                            side: BorderSide(color: isSelected ? bColor : AppColors.cardBorder),
                            checkmarkColor: Colors.white,
                            onSelected: (_) => transitProvider.selectBus(bus),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Responsive 2-Column (Widescreen) vs 1-Column (Mobile)
                if (isWide)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left Column: Telemetry HUD & Radar Visualizer
                      Expanded(
                        flex: 6,
                        child: Column(
                          children: [
                            _buildTelemetryHud(targetBus, routeColor, routeGradient, transitProvider),
                            const SizedBox(height: 20),
                            _buildRouteMapVisualizer(targetBus, route, routeColor),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      // Right Column: Waypoint Stops Sequence & Driver Info
                      Expanded(
                        flex: 5,
                        child: Column(
                          children: [
                            _buildWaypointsList(targetBus, route, isStudent, student, routeColor),
                            const SizedBox(height: 20),
                            _buildDriverInfoCard(targetBus, routeColor, routeGradient, context),
                          ],
                        ),
                      ),
                    ],
                  )
                else
                  // Mobile Single-Column Stack
                  Column(
                    children: [
                      _buildTelemetryHud(targetBus, routeColor, routeGradient, transitProvider),
                      const SizedBox(height: 20),
                      _buildRouteMapVisualizer(targetBus, route, routeColor),
                      const SizedBox(height: 20),
                      _buildWaypointsList(targetBus, route, isStudent, student, routeColor),
                      const SizedBox(height: 20),
                      _buildDriverInfoCard(targetBus, routeColor, routeGradient, context),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTelemetryHud(
    BusModel targetBus,
    Color routeColor,
    LinearGradient routeGradient,
    TransitProvider transitProvider,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: routeGradient,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: routeColor.withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          targetBus.busNumber,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'SRKR FLEET',
                            style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w900),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      targetBus.routeName,
                      style: const TextStyle(color: Color(0xFFE0E7FF), fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 6,
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
                        color: targetBus.statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      targetBus.statusLabel,
                      style: TextStyle(
                        color: targetBus.statusColor,
                        fontWeight: FontWeight.w900,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const Divider(color: Color(0x33FFFFFF), height: 26),

          // Real-time Coordinates & Heading Matrix
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTelemetryCell(
                label: 'LATITUDE',
                value: targetBus.currentLatitude.toStringAsFixed(4),
                icon: Icons.my_location,
              ),
              _buildTelemetryCell(
                label: 'LONGITUDE',
                value: targetBus.currentLongitude.toStringAsFixed(4),
                icon: Icons.location_on_outlined,
              ),
              _buildTelemetryCell(
                label: 'LIVE SPEED',
                value: '${targetBus.speedKmh.toStringAsFixed(0)} km/h',
                icon: Icons.speed,
              ),
            ],
          ),

          const SizedBox(height: 14),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTelemetryCell(
                label: 'HEADING',
                value: '${targetBus.heading.toStringAsFixed(0)}°',
                icon: Icons.explore_outlined,
              ),
              _buildTelemetryCell(
                label: 'CAPACITY',
                value: '${targetBus.occupiedSeats}/${targetBus.totalCapacity} (${targetBus.occupancyPercentage}%)',
                icon: Icons.people_outline,
              ),
              _buildTelemetryCell(
                label: 'TELEMETRY',
                value: transitProvider.isSimulationRunning ? '3s Active' : 'Paused',
                icon: Icons.sync,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWaypointsList(
    BusModel targetBus,
    BusRoute? route,
    bool isStudent,
    StudentModel? student,
    Color routeColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: Text(
                'Route Waypoints & Next Arrival',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: routeColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '${route?.stops.length ?? 0} Stops',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: routeColor),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (route != null)
          Container(
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
              children: route.stops.map((stop) {
                final isNextStop = stop.name == targetBus.nextStopName;
                final isStudentStop = isStudent && student != null && stop.name.contains(student.boardingStop);
                final isCollege = stop.sequence == route.stops.length;

                final nodeColor = isNextStop
                    ? routeColor
                    : (isCollege
                        ? AppColors.liveGreen
                        : (isStudentStop ? AppColors.accentGold : Colors.white));

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Timeline indicator column
                    Column(
                      children: [
                        Container(
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                            color: nodeColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isNextStop
                                  ? routeColor
                                  : (isCollege ? AppColors.liveGreen : (isStudentStop ? AppColors.accentGold : AppColors.cardBorder)),
                              width: 2.2,
                            ),
                            boxShadow: [
                              if (isNextStop || isCollege || isStudentStop)
                                BoxShadow(
                                  color: nodeColor.withValues(alpha: 0.4),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                            ],
                          ),
                          child: Center(
                            child: isNextStop
                                ? const Icon(Icons.directions_bus, size: 14, color: Colors.white)
                                : (isCollege
                                    ? const Icon(Icons.school, size: 14, color: Colors.white)
                                    : (isStudentStop ? const Icon(Icons.person, size: 14, color: Colors.white) : null)),
                          ),
                        ),
                        if (!isCollege)
                          Container(
                            width: 2.5,
                            height: 40,
                            color: isNextStop ? routeColor : AppColors.cardBorder,
                          ),
                      ],
                    ),
                    const SizedBox(width: 14),

                    // Stop details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  stop.name,
                                  style: TextStyle(
                                    fontWeight: (isNextStop || isCollege || isStudentStop) ? FontWeight.w900 : FontWeight.w600,
                                    fontSize: 13,
                                    color: isNextStop
                                        ? routeColor
                                        : (isCollege ? AppColors.liveGreen : AppColors.textPrimary),
                                  ),
                                ),
                              ),
                              if (isNextStop)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: routeColor,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    'ETA: ${targetBus.nextStopEtaMinutes} MIN',
                                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900),
                                  ),
                                ),
                              if (isStudentStop && !isNextStop)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: AppColors.accentGold.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: AppColors.accentGold),
                                  ),
                                  child: const Text(
                                    'YOUR STOP',
                                    style: TextStyle(color: Color(0xFFB45309), fontSize: 9, fontWeight: FontWeight.w900),
                                  ),
                                ),
                            ],
                          ),
                          if (stop.nearbyBuilding != null)
                            Text(
                              stop.nearbyBuilding!,
                              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                            ),
                          const SizedBox(height: 18),
                        ],
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildDriverInfoCard(
    BusModel targetBus,
    Color routeColor,
    LinearGradient routeGradient,
    BuildContext context,
  ) {
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
                targetBus.driverName.substring(0, 1),
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
                  targetBus.driverName,
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: AppColors.textPrimary),
                ),
                Text(
                  'Driver (${targetBus.driverPhone})',
                  style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: routeColor,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Contacting driver ${targetBus.driverName} (${targetBus.driverPhone})...'),
                  backgroundColor: routeColor,
                ),
              );
            },
            child: const Text('Contact', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteMapVisualizer(BusModel bus, BusRoute? route, Color routeColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: routeColor.withValues(alpha: 0.25), width: 1.4),
        boxShadow: [
          BoxShadow(
            color: routeColor.withValues(alpha: 0.08),
            blurRadius: 14,
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
                  Icon(Icons.map_rounded, color: routeColor, size: 20),
                  const SizedBox(width: 8),
                  const Text(
                    'Regional Transit Corridor Radar',
                    style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w900, fontSize: 14),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: routeColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Delta Region',
                  style: TextStyle(color: routeColor, fontSize: 10, fontWeight: FontWeight.w900),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Schematic Node Representation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Origin Town
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: routeColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: routeColor.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      route?.startHub.split(' ').first ?? 'Origin',
                      style: TextStyle(color: routeColor, fontSize: 11, fontWeight: FontWeight.w900),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text('Morning Start Point', style: TextStyle(color: AppColors.textSecondary, fontSize: 10)),
                ],
              ),

              // Animated Transit In-between Line
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(height: 3, color: routeColor.withValues(alpha: 0.2)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: routeColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: routeColor.withValues(alpha: 0.4),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.directions_bus, size: 11, color: Colors.white),
                            const SizedBox(width: 4),
                            Text(
                              '${bus.speedKmh.toStringAsFixed(0)} km/h',
                              style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w900),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Destination: SRKR Engineering College
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.liveGreen.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.liveGreen.withValues(alpha: 0.3)),
                    ),
                    child: const Text(
                      'SRKR Campus',
                      style: TextStyle(color: AppColors.liveGreen, fontSize: 11, fontWeight: FontWeight.w900),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text('Chinna Amiram, BVLM', style: TextStyle(color: AppColors.textSecondary, fontSize: 10)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'GPS Sync: Lat ${bus.currentLatitude.toStringAsFixed(4)}, Lon ${bus.currentLongitude.toStringAsFixed(4)}',
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.w500),
                ),
                Text(
                  'Dist: ~${route?.totalDistanceKm ?? 0} km',
                  style: TextStyle(color: routeColor, fontSize: 11, fontWeight: FontWeight.w900),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTelemetryCell({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 12, color: Colors.white70),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 9, color: Color(0xFFC7D2FE), letterSpacing: 0.5, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Colors.white),
        ),
      ],
    );
  }
}
