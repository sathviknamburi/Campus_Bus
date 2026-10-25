import 'package:flutter/material.dart';

/// Represents a designated campus transit stop along a route.
class BusStop {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final int sequence;
  final int minutesFromOrigin;
  final bool isMajorHub;
  final String? nearbyBuilding;

  const BusStop({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.sequence,
    required this.minutesFromOrigin,
    this.isMajorHub = false,
    this.nearbyBuilding,
  });
}

/// Represents a defined campus bus route connecting various campus zones.
class BusRoute {
  final String id;
  final String routeCode;
  final String routeName;
  final String startHub;
  final String endHub;
  final Color themeColor;
  final List<BusStop> stops;
  final List<String> dailySchedules; // e.g. ["07:30 AM", "08:15 AM", ...]
  final double totalDistanceKm;
  final int averageDurationMinutes;
  final bool isActive;

  const BusRoute({
    required this.id,
    required this.routeCode,
    required this.routeName,
    required this.startHub,
    required this.endHub,
    required this.themeColor,
    required this.stops,
    required this.dailySchedules,
    required this.totalDistanceKm,
    required this.averageDurationMinutes,
    this.isActive = true,
  });

  /// Total number of transit stops on this route
  int get stopCount => stops.length;
}
