import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_constants.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/responsive.dart';
import '../models/alert_model.dart';
import '../models/bus_model.dart';
import '../models/student_model.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/transit_provider.dart';
import 'login_screen.dart';

/// The Profile tab managing student identity, assigned bus preferences,
/// Phase 4 driver controls, and session logout.
/// Fully responsive via [MediaQuery]: 2-column split on Tablet/Desktop, fluid list on Mobile.
class ProfileTab extends StatelessWidget {
  final void Function(int) onNavigateToTab;

  const ProfileTab({
    super.key,
    required this.onNavigateToTab,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final transitProvider = context.watch<TransitProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final isStudent = authProvider.isStudentAuthenticated;
    final student = authProvider.currentStudent;
    final isWide = MediaQuery.sizeOf(context).width >= 900;
    final horizontalPadding = context.responsivePadding;

    final assignedBus = isStudent && student != null
        ? transitProvider.getAssignedBus(student.assignedBusId)
        : null;

    final routeColor = assignedBus != null
        ? AppColors.getRouteColor(assignedBus.routeName)
        : AppColors.primary;
    final routeGradient = assignedBus != null
        ? AppColors.getRouteGradient(assignedBus.routeName)
        : AppColors.primaryGradient;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        ),
        foregroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            const Icon(Icons.person_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              isStudent ? 'Student Transit Profile' : 'Campus Transit Guest Portal',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
            ),
          ],
        ),
        actions: [
          if (isStudent)
            IconButton(
              icon: const Icon(Icons.logout_rounded, color: Colors.white),
              tooltip: 'Logout',
              onPressed: () => _confirmLogout(context, authProvider),
            ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: Responsive.maxContentWidth),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
            child: isWide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left Column: Identity & Assigned Bus Info
                      Expanded(
                        flex: 6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (isStudent && student != null)
                              _buildStudentProfileCard(context, student, assignedBus, routeColor, routeGradient)
                            else
                              _buildGuestProfileCard(context),
                            const SizedBox(height: 20),
                            if (isStudent && student != null && assignedBus != null) ...[
                              const Text(
                                'Assigned Bus & Seat Allocation',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
                              ),
                              const SizedBox(height: 10),
                              _buildAssignedBusDetailsCard(assignedBus, student, routeColor),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      // Right Column: Controls, Preferences & Logout
                      Expanded(
                        flex: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Phase 4: Driver / Telemetry Controls',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
                            ),
                            const SizedBox(height: 10),
                            if (assignedBus != null)
                              _buildDriverSimulationControls(context, transitProvider, assignedBus, routeColor)
                            else
                              _buildGeneralDriverSimulation(context, transitProvider),
                            const SizedBox(height: 20),
                            const Text(
                              'System Settings & Preferences',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
                            ),
                            const SizedBox(height: 10),
                            _buildPreferencesCard(transitProvider, themeProvider),
                            const SizedBox(height: 20),
                            _buildCompletedPhasesCard(),
                            const SizedBox(height: 20),
                            if (isStudent)
                              _buildLogoutButton(context, authProvider),
                            const SizedBox(height: 20),
                            const Center(
                              child: Text(
                                '${AppConstants.collegeShortName} • ${AppConstants.appName} v${AppConstants.appVersion}',
                                style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isStudent && student != null)
                        _buildStudentProfileCard(context, student, assignedBus, routeColor, routeGradient)
                      else
                        _buildGuestProfileCard(context),
                      const SizedBox(height: 20),
                      if (isStudent && student != null && assignedBus != null) ...[
                        const Text(
                          'Assigned Bus & Seat Allocation',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
                        ),
                        const SizedBox(height: 10),
                        _buildAssignedBusDetailsCard(assignedBus, student, routeColor),
                        const SizedBox(height: 20),
                      ],
                      const Text(
                        'Phase 4: Driver / Telemetry Controls',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 10),
                      if (assignedBus != null)
                        _buildDriverSimulationControls(context, transitProvider, assignedBus, routeColor)
                      else
                        _buildGeneralDriverSimulation(context, transitProvider),
                      const SizedBox(height: 20),
                      const Text(
                        'System Settings & Preferences',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 10),
                      _buildPreferencesCard(transitProvider, themeProvider),
                      const SizedBox(height: 20),
                      _buildCompletedPhasesCard(),
                      const SizedBox(height: 20),
                      if (isStudent)
                        _buildLogoutButton(context, authProvider),
                      const SizedBox(height: 20),
                      const Center(
                        child: Text(
                          '${AppConstants.collegeShortName} • ${AppConstants.appName} v${AppConstants.appVersion}',
                          style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildAssignedBusDetailsCard(BusModel assignedBus, StudentModel student, Color routeColor) {
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
        children: [
          _buildInfoRow('Assigned Bus No.', assignedBus.busNumber, isBold: true, valueColor: routeColor),
          const Divider(height: 18, color: AppColors.cardBorder),
          _buildInfoRow('Route Corridor', assignedBus.routeName),
          const Divider(height: 18, color: AppColors.cardBorder),
          _buildInfoRow('Designated Boarding Stop', student.boardingStop),
          const Divider(height: 18, color: AppColors.cardBorder),
          _buildInfoRow('Destination Hub', student.destination),
          const Divider(height: 18, color: AppColors.cardBorder),
          _buildInfoRow('Assigned Driver', '${assignedBus.driverName} (${assignedBus.driverPhone})'),
          const Divider(height: 18, color: AppColors.cardBorder),
          _buildInfoRow('Pass Status', student.busPassValidity, valueColor: AppColors.liveGreen),
        ],
      ),
    );
  }

  Widget _buildPreferencesCard(TransitProvider transitProvider, ThemeProvider themeProvider) {
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: AppColors.cardBorder),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          SwitchListTile(
            title: const Text('Real-Time GPS Simulation', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
            subtitle: const Text('Periodically updates telemetry every 3 seconds', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
            value: transitProvider.isSimulationRunning,
            onChanged: (_) => transitProvider.toggleSimulation(),
            activeThumbColor: AppColors.primary,
          ),
          const Divider(height: 1, indent: 16, endIndent: 16, color: AppColors.cardBorder),
          SwitchListTile(
            title: const Text('Dark Mode Theme', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
            subtitle: const Text('Toggle between Light and Dark palette', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
            value: themeProvider.isDarkMode,
            onChanged: (_) => themeProvider.toggleTheme(),
            activeThumbColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, AuthProvider authProvider) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFFEF4444),
          side: const BorderSide(color: Color(0xFFFCA5A5)),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: () => _confirmLogout(context, authProvider),
        icon: const Icon(Icons.logout_rounded, size: 18),
        label: const Text('Logout Student Session', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
      ),
    );
  }

  Widget _buildStudentProfileCard(
    BuildContext context,
    StudentModel student,
    BusModel? assignedBus,
    Color routeColor,
    LinearGradient routeGradient,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: AppColors.heroGradient,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              gradient: routeGradient,
              shape: BoxShape.circle,
            ),
            child: const CircleAvatar(
              radius: 28,
              backgroundColor: Colors.white,
              child: Icon(Icons.school_rounded, color: AppColors.primary, size: 28),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.name,
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  'Reg No: ${student.regNo}',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFC7D2FE)),
                ),
                Text(
                  '${student.branch} • ${student.year}',
                  style: const TextStyle(fontSize: 11, color: Color(0xFFE0E7FF)),
                ),
                const SizedBox(height: 4),
                const Text(
                  'SRKR Engineering College, Bhimavaram',
                  style: TextStyle(fontSize: 11, color: Colors.white70),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
            decoration: BoxDecoration(
              gradient: AppColors.sunsetGradient,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'STUDENT',
              style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuestProfileCard(BuildContext context) {
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
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: AppColors.primarySoft,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person_outline_rounded, color: AppColors.primary, size: 28),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Guest / Visitor Mode',
                      style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: AppColors.textPrimary),
                    ),
                    Text(
                      'Viewing general campus timetable & 7 routes',
                      style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
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
                child: const Text('Login', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isBold = false, Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: valueColor ?? AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDriverSimulationControls(BuildContext context, TransitProvider provider, BusModel bus, Color routeColor) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Driver Telemetry Simulation (${bus.busNumber})',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: routeColor),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.liveGreen.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text('ACTIVE', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.liveGreen)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Passenger Occupancy: ${bus.occupiedSeats} / ${bus.totalCapacity}', style: const TextStyle(fontSize: 12, color: AppColors.textPrimary, fontWeight: FontWeight.w700)),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline, size: 22, color: AppColors.textSecondary),
                    onPressed: () => provider.updateBusOccupancy(bus.id, bus.occupiedSeats - 5),
                  ),
                  IconButton(
                    icon: Icon(Icons.add_circle_outline, size: 22, color: routeColor),
                    onPressed: () => provider.updateBusOccupancy(bus.id, bus.occupiedSeats + 5),
                  ),
                ],
              ),
            ],
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: routeColor,
                  side: BorderSide(color: routeColor),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  final newStatus = bus.status == BusStatus.delayed ? BusStatus.onTime : BusStatus.delayed;
                  provider.updateBusStatus(bus.id, newStatus);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Bus ${bus.busNumber} status updated to: ${newStatus.name}'),
                      backgroundColor: routeColor,
                    ),
                  );
                },
                child: Text(
                  bus.status == BusStatus.delayed ? 'Clear Delay' : 'Simulate Delay',
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primaryLight),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  provider.broadcastAlert(
                    title: 'Driver Advisory: Road Congestion',
                    message: 'Driver reported heavy traffic on corridor. Arrival may be delayed by 5 mins.',
                    routeAffected: bus.routeName,
                    severity: AlertSeverity.warning,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Driver broadcast alert sent to all students on route!'),
                      backgroundColor: AppColors.primary,
                    ),
                  );
                },
                child: const Text('Broadcast Alert', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGeneralDriverSimulation(BuildContext context, TransitProvider provider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: const Text(
        'Log in as a student to test driver passenger updates and delay simulations on your assigned bus.',
        style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
      ),
    );
  }

  Widget _buildCompletedPhasesCard() {
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
              Icon(Icons.check_circle_rounded, color: AppColors.liveGreen, size: 20),
              SizedBox(width: 8),
              Text(
                'All Development Phases Completed',
                style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w900, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _buildPhaseCheck('Phase 1: Project Architecture & Setup', 'COMPLETED'),
          _buildPhaseCheck('Phase 2: Provider State & Real-Time Simulation', 'COMPLETED'),
          _buildPhaseCheck('Phase 3: SharedPreferences Offline Persistence', 'COMPLETED'),
          _buildPhaseCheck('Phase 4: Driver Fleet Controls & Passenger Counters', 'COMPLETED'),
          _buildPhaseCheck('Phase 5: Proximity Geofencing & ETA Calculations', 'COMPLETED'),
          _buildPhaseCheck('Phase 6: Regional Route Visualizer & Delta Coordinates', 'COMPLETED'),
          _buildPhaseCheck('Phase 7: Student Authentication (24B91AXXXX) & Assigned Bus Isolation', 'COMPLETED'),
        ],
      ),
    );
  }

  Widget _buildPhaseCheck(String title, String status) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(title, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.w500)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.liveGreen.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              status,
              style: const TextStyle(color: Color(0xFF047857), fontSize: 9, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmLogout(BuildContext context, AuthProvider auth) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout Student Session?'),
        content: const Text('You will be logged out and returned to the SRKR Campus Transit Intro screen.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444)),
            onPressed: () {
              Navigator.pop(ctx);
              auth.logout();
            },
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
