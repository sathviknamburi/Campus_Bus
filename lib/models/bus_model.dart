import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

/// Operational status of a campus bus.
enum BusStatus {
  onTime,
  delayed,
  arriving,
  departed,
  outOfService,
}

/// Passenger load / seating availability.
enum OccupancyLevel {
  low,      // < 40% full (Green)
  moderate, // 40% - 75% full (Amber)
  high,     // > 75% full (Orange)
  full,     // 100% full (Red)
}

/// Represents an individual campus transit bus with live telemetry and schedule data.
class BusModel {
  final String id;
  final String busNumber;
  final String routeId;
  final String routeName;
  final String driverName;
  final String driverPhone;
  final double currentLatitude;
  final double currentLongitude;
  final double speedKmh;
  final double heading; // Compass degree 0 - 360
  final int totalCapacity;
  final int occupiedSeats;
  final BusStatus status;
  final String nextStopName;
  final int nextStopEtaMinutes;
  final DateTime lastUpdated;

  const BusModel({
    required this.id,
    required this.busNumber,
    required this.routeId,
    required this.routeName,
    required this.driverName,
    required this.driverPhone,
    required this.currentLatitude,
    required this.currentLongitude,
    required this.speedKmh,
    required this.heading,
    required this.totalCapacity,
    required this.occupiedSeats,
    required this.status,
    required this.nextStopName,
    required this.nextStopEtaMinutes,
    required this.lastUpdated,
  });

  /// Fraction of seats occupied (0.0 to 1.0)
  double get occupancyRatio {
    if (totalCapacity == 0) return 0.0;
    return (occupiedSeats / totalCapacity).clamp(0.0, 1.0);
  }

  /// Percentage of capacity as an integer
  int get occupancyPercentage => (occupancyRatio * 100).round();

  /// Determine categorized occupancy level
  OccupancyLevel get occupancyLevel {
    final ratio = occupancyRatio;
    if (ratio >= 0.95) return OccupancyLevel.full;
    if (ratio >= 0.70) return OccupancyLevel.high;
    if (ratio >= 0.35) return OccupancyLevel.moderate;
    return OccupancyLevel.low;
  }

  /// UI Color for occupancy indicator
  Color get occupancyColor {
    switch (occupancyLevel) {
      case OccupancyLevel.low:
        return AppColors.liveGreen;
      case OccupancyLevel.moderate:
        return AppColors.warningAmber;
      case OccupancyLevel.high:
        return const Color(0xFFF97316); // Vibrant orange
      case OccupancyLevel.full:
        return AppColors.dangerRed;
    }
  }

  /// Human-friendly status label
  String get statusLabel {
    switch (status) {
      case BusStatus.onTime:
        return 'On Time';
      case BusStatus.delayed:
        return 'Delayed';
      case BusStatus.arriving:
        return 'Arriving Soon';
      case BusStatus.departed:
        return 'En Route';
      case BusStatus.outOfService:
        return 'Out of Service';
    }
  }

  /// UI Badge Color for bus status
  Color get statusColor {
    switch (status) {
      case BusStatus.onTime:
        return AppColors.liveGreen;
      case BusStatus.delayed:
        return AppColors.warningAmber;
      case BusStatus.arriving:
        return AppColors.accentCyan;
      case BusStatus.departed:
        return AppColors.primaryLight;
      case BusStatus.outOfService:
        return AppColors.textMuted;
    }
  }

  /// Creates a copy of [BusModel] with optional fields updated
  BusModel copyWith({
    String? id,
    String? busNumber,
    String? routeId,
    String? routeName,
    String? driverName,
    String? driverPhone,
    double? currentLatitude,
    double? currentLongitude,
    double? speedKmh,
    double? heading,
    int? totalCapacity,
    int? occupiedSeats,
    BusStatus? status,
    String? nextStopName,
    int? nextStopEtaMinutes,
    DateTime? lastUpdated,
  }) {
    return BusModel(
      id: id ?? this.id,
      busNumber: busNumber ?? this.busNumber,
      routeId: routeId ?? this.routeId,
      routeName: routeName ?? this.routeName,
      driverName: driverName ?? this.driverName,
      driverPhone: driverPhone ?? this.driverPhone,
      currentLatitude: currentLatitude ?? this.currentLatitude,
      currentLongitude: currentLongitude ?? this.currentLongitude,
      speedKmh: speedKmh ?? this.speedKmh,
      heading: heading ?? this.heading,
      totalCapacity: totalCapacity ?? this.totalCapacity,
      occupiedSeats: occupiedSeats ?? this.occupiedSeats,
      status: status ?? this.status,
      nextStopName: nextStopName ?? this.nextStopName,
      nextStopEtaMinutes: nextStopEtaMinutes ?? this.nextStopEtaMinutes,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
