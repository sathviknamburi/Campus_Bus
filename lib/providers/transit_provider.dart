import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/bus_model.dart';
import '../models/route_model.dart';
import '../models/alert_model.dart';
import '../data/mock_transit_data.dart';
import '../core/constants/app_constants.dart';

/// Central state management for SRKR Campus Bus Tracking system using Provider.
///
/// Features across phases:
/// - Phase 2: Decoupled telemetry state & dynamic simulation
/// - Phase 3: Favorites & stop caching
/// - Phase 4: Driver mode controls (telemetry update, occupancy adjustment, delay broadcasting)
/// - Phase 5: Proximity geofencing, distance calculation & arrival notifications
/// - Phase 6: Interactive route geometry & stop waypoints
/// - Phase 7: Student-specific assigned bus filtering & isolation
class TransitProvider extends ChangeNotifier {
  List<BusModel> _buses = [];
  List<BusRoute> _routes = [];
  List<TransitAlert> _alerts = [];
  final Set<String> _favoriteBusIds = {'bus_srkr_01'};

  String? _selectedRouteId;
  String _searchQuery = '';
  BusModel? _selectedBus;
  bool _isSimulationRunning = true;
  Timer? _simulationTimer;
  final Random _random = Random();

  // Notification / Proximity state (Phase 5)
  String? _latestProximityNotice;

  TransitProvider() {
    _initializeData();
    _startSimulation();
  }

  // ===========================================================================
  // GETTERS
  // ===========================================================================

  List<BusModel> get allBuses => List.unmodifiable(_buses);
  List<BusRoute> get routes => List.unmodifiable(_routes);
  List<TransitAlert> get alerts => List.unmodifiable(_alerts);
  Set<String> get favoriteBusIds => Set.unmodifiable(_favoriteBusIds);
  String? get selectedRouteId => _selectedRouteId;
  String get searchQuery => _searchQuery;
  BusModel? get selectedBus => _selectedBus ?? (_buses.isNotEmpty ? _buses.first : null);
  bool get isSimulationRunning => _isSimulationRunning;
  String? get latestProximityNotice => _latestProximityNotice;

  /// Returns buses filtered by selected route and search query (for guest/admin directory)
  List<BusModel> get filteredBuses {
    return _buses.where((bus) {
      if (_selectedRouteId != null && bus.routeId != _selectedRouteId) {
        return false;
      }
      if (_searchQuery.trim().isNotEmpty) {
        final query = _searchQuery.toLowerCase().trim();
        final matchesNumber = bus.busNumber.toLowerCase().contains(query);
        final matchesRoute = bus.routeName.toLowerCase().contains(query);
        final matchesDriver = bus.driverName.toLowerCase().contains(query);
        final matchesStop = bus.nextStopName.toLowerCase().contains(query);
        if (!matchesNumber && !matchesRoute && !matchesDriver && !matchesStop) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  /// Returns ONLY the student's assigned bus (Phase 7 Student Isolation)
  BusModel? getAssignedBus(String? assignedBusId) {
    if (assignedBusId == null) return null;
    try {
      return _buses.firstWhere((b) => b.id == assignedBusId);
    } catch (_) {
      return _buses.isNotEmpty ? _buses.first : null;
    }
  }

  /// Active buses currently in transit
  int get activeBusesCount => _buses.where((b) => b.status != BusStatus.outOfService).length;

  /// Percentage of operational buses that are strictly on time
  int get onTimePercentage {
    final active = _buses.where((b) => b.status != BusStatus.outOfService).toList();
    if (active.isEmpty) return 100;
    final onTimeCount = active.where((b) => b.status == BusStatus.onTime || b.status == BusStatus.arriving).length;
    return ((onTimeCount / active.length) * 100).round();
  }

  /// Total unread announcements
  int get unreadAlertsCount => _alerts.where((a) => !a.isRead).length;

  // ===========================================================================
  // INITIALIZATION & REAL-TIME SIMULATION
  // ===========================================================================

  void _initializeData() {
    _routes = MockTransitData.routes;
    _buses = MockTransitData.getInitialBuses();
    _alerts = MockTransitData.getInitialAlerts();
    if (_buses.isNotEmpty) {
      _selectedBus = _buses.first;
    }
  }

  /// Real-time ticker: periodically nudges bus coordinates & simulates realistic transit movement
  void _startSimulation() {
    _simulationTimer?.cancel();
    _simulationTimer = Timer.periodic(
      const Duration(seconds: AppConstants.simulationIntervalSeconds),
      (_) => _simulateTick(),
    );
    _isSimulationRunning = true;
    notifyListeners();
  }

  void _simulateTick() {
    if (!_isSimulationRunning) return;

    _buses = _buses.map((bus) {
      if (bus.status == BusStatus.outOfService) return bus;

      // Realistic minute GPS drift (towards SRKR campus or respective hubs)
      final latDelta = (_random.nextDouble() - 0.49) * 0.00035;
      final lngDelta = (_random.nextDouble() - 0.49) * 0.00035;

      // Smooth speed fluctuation (+/- 2.0 km/h)
      final speedDelta = (_random.nextDouble() - 0.5) * 2.0;
      final newSpeed = (bus.speedKmh + speedDelta).clamp(20.0, 55.0);

      // Random micro-occupancy changes (students boarding at stops)
      int newOccupancy = bus.occupiedSeats;
      if (_random.nextDouble() < 0.20) {
        final change = _random.nextInt(3) - 1; // -1, 0, +1
        newOccupancy = (bus.occupiedSeats + change).clamp(5, bus.totalCapacity);
      }

      // Small compass heading drift
      final newHeading = (bus.heading + (_random.nextDouble() * 4 - 2)) % 360.0;

      return bus.copyWith(
        currentLatitude: bus.currentLatitude + latDelta,
        currentLongitude: bus.currentLongitude + lngDelta,
        speedKmh: double.parse(newSpeed.toStringAsFixed(1)),
        heading: double.parse(newHeading.toStringAsFixed(1)),
        occupiedSeats: newOccupancy,
        lastUpdated: DateTime.now(),
      );
    }).toList();

    // Sync selected bus reference
    if (_selectedBus != null) {
      final updated = _buses.firstWhere(
        (b) => b.id == _selectedBus!.id,
        orElse: () => _selectedBus!,
      );
      _selectedBus = updated;
    }

    notifyListeners();
  }

  // ===========================================================================
  // PHASE 4: DRIVER / CONDUCTOR FLEET CONTROLS
  // ===========================================================================

  /// Allows a driver or transport staff to update occupied seat count
  void updateBusOccupancy(String busId, int newCount) {
    _buses = _buses.map((bus) {
      if (bus.id == busId) {
        return bus.copyWith(
          occupiedSeats: newCount.clamp(0, bus.totalCapacity),
          lastUpdated: DateTime.now(),
        );
      }
      return bus;
    }).toList();
    notifyListeners();
  }

  /// Allows a driver to update their status (e.g., Delay due to traffic, arriving)
  void updateBusStatus(String busId, BusStatus newStatus) {
    _buses = _buses.map((bus) {
      if (bus.id == busId) {
        return bus.copyWith(
          status: newStatus,
          lastUpdated: DateTime.now(),
        );
      }
      return bus;
    }).toList();
    notifyListeners();
  }

  /// Driver broadcasts a live transit advisory / alert
  void broadcastAlert({
    required String title,
    required String message,
    required String routeAffected,
    required AlertSeverity severity,
  }) {
    final newAlert = TransitAlert(
      id: 'alert_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      message: message,
      routeAffected: routeAffected,
      severity: severity,
      timestamp: DateTime.now(),
    );
    _alerts.insert(0, newAlert);
    _latestProximityNotice = title;
    notifyListeners();
  }

  // ===========================================================================
  // PHASE 5: GEOFENCING & PROXIMITY CALCULATIONS
  // ===========================================================================

  /// Calculates approximate distance (in kilometers) between two coordinates using Haversine formula
  double calculateDistanceKm(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadiusKm = 6371.0;
    final dLat = _degreesToRadians(lat2 - lat1);
    final dLon = _degreesToRadians(lon2 - lon1);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) * cos(_degreesToRadians(lat2)) *
        sin(dLon / 2) * sin(dLon / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadiusKm * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180.0;
  }

  /// Calculates ETA in minutes from a bus to a target stop based on current speed
  int calculateEtaMinutes(BusModel bus, double targetLat, double targetLon) {
    final distanceKm = calculateDistanceKm(
      bus.currentLatitude,
      bus.currentLongitude,
      targetLat,
      targetLon,
    );
    final effectiveSpeed = bus.speedKmh > 10 ? bus.speedKmh : 30.0;
    final hours = distanceKm / effectiveSpeed;
    final minutes = (hours * 60).round();
    return minutes.clamp(1, 120);
  }

  // ===========================================================================
  // GENERAL USER ACTIONS / MUTATIONS
  // ===========================================================================

  void toggleSimulation() {
    _isSimulationRunning = !_isSimulationRunning;
    notifyListeners();
  }

  void selectRouteFilter(String? routeId) {
    _selectedRouteId = routeId;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void selectBus(BusModel bus) {
    _selectedBus = bus;
    notifyListeners();
  }

  void toggleFavorite(String busId) {
    if (_favoriteBusIds.contains(busId)) {
      _favoriteBusIds.remove(busId);
    } else {
      _favoriteBusIds.add(busId);
    }
    notifyListeners();
  }

  bool isFavorite(String busId) => _favoriteBusIds.contains(busId);

  void markAllAlertsAsRead() {
    _alerts = _alerts.map((a) => a.copyWith(isRead: true)).toList();
    notifyListeners();
  }

  BusRoute? getRouteById(String routeId) {
    try {
      return _routes.firstWhere((r) => r.id == routeId);
    } catch (_) {
      return null;
    }
  }

  BusModel? getBusById(String busId) {
    try {
      return _buses.firstWhere((b) => b.id == busId);
    } catch (_) {
      return null;
    }
  }

  @override
  void dispose() {
    _simulationTimer?.cancel();
    super.dispose();
  }
}
