import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/responsive.dart';
import '../models/route_model.dart';
import '../providers/auth_provider.dart';
import '../providers/transit_provider.dart';

/// The Routes tab listing the 7 regional bus corridors serving SRKR Engineering College.
/// Responsive via [MediaQuery]: 2-column card layout on Tablet/Desktop, fluid list on Mobile.
class RoutesTab extends StatelessWidget {
  final void Function(int) onNavigateToTab;

  const RoutesTab({
    super.key,
    required this.onNavigateToTab,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final transitProvider = context.watch<TransitProvider>();
    final routes = transitProvider.routes;
    final isStudent = authProvider.isStudentAuthenticated;
    final student = authProvider.currentStudent;
    final isWide = MediaQuery.sizeOf(context).width >= 900;
    final horizontalPadding = context.responsivePadding;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        ),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Row(
          children: [
            Icon(Icons.alt_route_rounded, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text('SRKR Bus Routes & Timetable', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
          ],
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: Responsive.maxContentWidth),
          child: isWide
              ? ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
                  itemCount: (routes.length / 2).ceil(),
                  itemBuilder: (context, rowIndex) {
                    final firstIndex = rowIndex * 2;
                    final secondIndex = firstIndex + 1;
                    final r1 = routes[firstIndex];
                    final r2 = secondIndex < routes.length ? routes[secondIndex] : null;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _buildRouteCard(context, r1, transitProvider, isStudent, student, firstIndex),
                          ),
                          const SizedBox(width: 16),
                          if (r2 != null)
                            Expanded(
                              child: _buildRouteCard(context, r2, transitProvider, isStudent, student, secondIndex),
                            )
                          else
                            const Expanded(child: SizedBox()),
                        ],
                      ),
                    );
                  },
                )
              : ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
                  itemCount: routes.length,
                  itemBuilder: (context, index) {
                    final route = routes[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildRouteCard(context, route, transitProvider, isStudent, student, index),
                    );
                  },
                ),
        ),
      ),
    );
  }

  Widget _buildRouteCard(
    BuildContext context,
    BusRoute route,
    TransitProvider transitProvider,
    bool isStudent,
    dynamic student,
    int index,
  ) {
    final busesOnRoute = transitProvider.allBuses.where((b) => b.routeId == route.id).toList();
    final isStudentAssignedRoute = isStudent && student != null && route.id == student.assignedRouteId;
    final routeColor = AppColors.getRouteColor(route.routeName);
    final routeGradient = AppColors.getRouteGradient(route.routeName);

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isStudentAssignedRoute ? routeColor : AppColors.cardBorder,
          width: isStudentAssignedRoute ? 2.0 : 1.2,
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: isStudentAssignedRoute || (!isStudent && index == 0),
          tilePadding: const EdgeInsets.all(16),
          leading: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: routeGradient,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: routeColor.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: Text(
                route.routeCode.split(' ').first,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  route.routeName,
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: AppColors.textPrimary),
                ),
              ),
              if (isStudentAssignedRoute)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: routeColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'YOUR ROUTE',
                    style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w900),
                  ),
                ),
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Wrap(
              spacing: 6,
              runSpacing: 4,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${route.totalDistanceKm} km',
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '~${route.averageDurationMinutes} min',
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: routeColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${route.stopCount} stops',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: routeColor),
                  ),
                ),
              ],
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(color: AppColors.cardBorder),

                  // Corridor Origin to College
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.trip_origin, size: 16, color: routeColor),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            route.startHub,
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.textPrimary),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Icon(Icons.arrow_forward_rounded, size: 16, color: AppColors.textMuted),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'SRKR College, Chinna Amiram',
                            textAlign: TextAlign.right,
                            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.textPrimary),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.school, size: 16, color: AppColors.liveGreen),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Active fleet running on this route
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Active Fleet Buses on Corridor:',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
                      ),
                      Text(
                        '${busesOnRoute.length} Active',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: routeColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: busesOnRoute.map((bus) {
                      return ActionChip(
                        backgroundColor: routeColor.withValues(alpha: 0.1),
                        side: BorderSide(color: routeColor.withValues(alpha: 0.3)),
                        avatar: Icon(Icons.directions_bus, size: 14, color: routeColor),
                        label: Text('${bus.busNumber} (${bus.statusLabel})'),
                        labelStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: routeColor),
                        onPressed: () {
                          transitProvider.selectBus(bus);
                          onNavigateToTab(1); // Go to Track Tab
                        },
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 16),

                  // Departure Schedule Times
                  const Text(
                    'Daily College Timetable & Pickup Times:',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: route.dailySchedules.map((time) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.cardBorder),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.schedule, size: 13, color: routeColor),
                            const SizedBox(width: 5),
                            Text(
                              time,
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
