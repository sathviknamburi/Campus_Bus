import 'package:flutter/material.dart';
import '../models/bus_model.dart';
import '../models/route_model.dart';
import '../models/alert_model.dart';
import '../models/student_model.dart';

/// Pre-populated transit dataset for SRKR Engineering College, Bhimavaram, Andhra Pradesh.
/// Connects the Chinna Amiram campus with 7 major nearby destinations.
class MockTransitData {
  // College coordinates (Chinna Amiram, Bhimavaram)
  static const double collegeLat = 16.5407;
  static const double collegeLng = 81.5228;

  /// Designated campus transit stops along the 7 regional routes
  static const List<BusStop> stops = [
    // -------------------------------------------------------------
    // Route 1 Stops: Palakollu ⇄ SRKR Engineering College (~21 km)
    // -------------------------------------------------------------
    BusStop(
      id: 'stop_101',
      name: 'Palakollu RTC Bus Complex',
      latitude: 16.5298,
      longitude: 81.7335,
      sequence: 1,
      minutesFromOrigin: 0,
      isMajorHub: true,
      nearbyBuilding: 'Palakollu Bus Depot',
    ),
    BusStop(
      id: 'stop_102',
      name: 'Ksheerarama Temple Center',
      latitude: 16.5330,
      longitude: 81.7250,
      sequence: 2,
      minutesFromOrigin: 6,
      nearbyBuilding: 'Pancharama Kshethram',
    ),
    BusStop(
      id: 'stop_103',
      name: 'Poolapalli Cross Roads',
      latitude: 16.5360,
      longitude: 81.6850,
      sequence: 3,
      minutesFromOrigin: 14,
      nearbyBuilding: 'Poolapalli Junction',
    ),
    BusStop(
      id: 'stop_104',
      name: 'Veeravasaram Center',
      latitude: 16.5385,
      longitude: 81.6320,
      sequence: 4,
      minutesFromOrigin: 22,
      isMajorHub: true,
      nearbyBuilding: 'Veeravasaram Panchayat Office',
    ),
    BusStop(
      id: 'stop_105',
      name: 'SRKR Engineering College Campus',
      latitude: collegeLat,
      longitude: collegeLng,
      sequence: 5,
      minutesFromOrigin: 32,
      isMajorHub: true,
      nearbyBuilding: 'Chinna Amiram Main Gate',
    ),

    // -------------------------------------------------------------
    // Route 2 Stops: Tanuku ⇄ SRKR Engineering College (~34 km)
    // -------------------------------------------------------------
    BusStop(
      id: 'stop_201',
      name: 'Tanuku RTC Complex',
      latitude: 16.7570,
      longitude: 81.6817,
      sequence: 1,
      minutesFromOrigin: 0,
      isMajorHub: true,
      nearbyBuilding: 'Tanuku Railway Station Road',
    ),
    BusStop(
      id: 'stop_202',
      name: 'Velpur Junction',
      latitude: 16.7150,
      longitude: 81.6520,
      sequence: 2,
      minutesFromOrigin: 10,
      nearbyBuilding: 'Velpur Bridge',
    ),
    BusStop(
      id: 'stop_203',
      name: 'Attili Center & Bus Stop',
      latitude: 16.6850,
      longitude: 81.6020,
      sequence: 3,
      minutesFromOrigin: 20,
      isMajorHub: true,
      nearbyBuilding: 'Attili RTC Shelter',
    ),
    BusStop(
      id: 'stop_204',
      name: 'Pippara Cross Roads',
      latitude: 16.6350,
      longitude: 81.5620,
      sequence: 4,
      minutesFromOrigin: 32,
      nearbyBuilding: 'Pippara Canal Point',
    ),
    BusStop(
      id: 'stop_205',
      name: 'SRKR Engineering College Campus',
      latitude: collegeLat,
      longitude: collegeLng,
      sequence: 5,
      minutesFromOrigin: 45,
      isMajorHub: true,
      nearbyBuilding: 'Mechanical Block Parking',
    ),

    // -------------------------------------------------------------
    // Route 3 Stops: Tadepalligudem ⇄ SRKR Engineering College (~42 km)
    // -------------------------------------------------------------
    BusStop(
      id: 'stop_301',
      name: 'TPG Railway Junction / Bus Station',
      latitude: 16.8143,
      longitude: 81.5273,
      sequence: 1,
      minutesFromOrigin: 0,
      isMajorHub: true,
      nearbyBuilding: 'Tadepalligudem Station Road',
    ),
    BusStop(
      id: 'stop_302',
      name: 'Pentapadu Center',
      latitude: 16.7620,
      longitude: 81.5300,
      sequence: 2,
      minutesFromOrigin: 12,
      nearbyBuilding: 'Pentapadu College Road',
    ),
    BusStop(
      id: 'stop_303',
      name: 'Alampuram Cross',
      latitude: 16.7020,
      longitude: 81.5280,
      sequence: 3,
      minutesFromOrigin: 24,
      nearbyBuilding: 'Highway Toll Cross',
    ),
    BusStop(
      id: 'stop_304',
      name: 'Ganapavaram Center',
      latitude: 16.6320,
      longitude: 81.5260,
      sequence: 4,
      minutesFromOrigin: 36,
      isMajorHub: true,
      nearbyBuilding: 'Ganapavaram Gandhi Statue',
    ),
    BusStop(
      id: 'stop_305',
      name: 'SRKR Engineering College Campus',
      latitude: collegeLat,
      longitude: collegeLng,
      sequence: 5,
      minutesFromOrigin: 50,
      isMajorHub: true,
      nearbyBuilding: 'Admin Block Portico',
    ),

    // -------------------------------------------------------------
    // Route 4 Stops: Narsapur ⇄ SRKR Engineering College (~31 km)
    // -------------------------------------------------------------
    BusStop(
      id: 'stop_401',
      name: 'Narsapur RTC Bus Depot',
      latitude: 16.4418,
      longitude: 81.6963,
      sequence: 1,
      minutesFromOrigin: 0,
      isMajorHub: true,
      nearbyBuilding: 'Narsapur Main Depot',
    ),
    BusStop(
      id: 'stop_402',
      name: 'Rustumbada Center',
      latitude: 16.4550,
      longitude: 81.6880,
      sequence: 2,
      minutesFromOrigin: 7,
      nearbyBuilding: 'Rustumbada Junction',
    ),
    BusStop(
      id: 'stop_403',
      name: 'Mogalthur Road Cross',
      latitude: 16.4820,
      longitude: 81.6700,
      sequence: 3,
      minutesFromOrigin: 16,
      nearbyBuilding: 'Mogalthur Highway Point',
    ),
    BusStop(
      id: 'stop_404',
      name: 'Srungavruksham Junction',
      latitude: 16.5120,
      longitude: 81.6150,
      sequence: 4,
      minutesFromOrigin: 28,
      isMajorHub: true,
      nearbyBuilding: 'Srungavruksham Temple Center',
    ),
    BusStop(
      id: 'stop_405',
      name: 'SRKR Engineering College Campus',
      latitude: collegeLat,
      longitude: collegeLng,
      sequence: 5,
      minutesFromOrigin: 40,
      isMajorHub: true,
      nearbyBuilding: 'Civil Block Entrance',
    ),

    // -------------------------------------------------------------
    // Route 5 Stops: Akividu ⇄ SRKR Engineering College (~17 km)
    // -------------------------------------------------------------
    BusStop(
      id: 'stop_501',
      name: 'Akividu Bus Station',
      latitude: 16.5867,
      longitude: 81.3814,
      sequence: 1,
      minutesFromOrigin: 0,
      isMajorHub: true,
      nearbyBuilding: 'Akividu Clock Tower Center',
    ),
    BusStop(
      id: 'stop_502',
      name: 'Kolleru Cross Roads',
      latitude: 16.5750,
      longitude: 81.4150,
      sequence: 2,
      minutesFromOrigin: 8,
      nearbyBuilding: 'Kolleru Lake View Point',
    ),
    BusStop(
      id: 'stop_503',
      name: 'Cherukuvada Center',
      latitude: 16.5620,
      longitude: 81.4500,
      sequence: 3,
      minutesFromOrigin: 15,
      nearbyBuilding: 'Cherukuvada Panchayat',
    ),
    BusStop(
      id: 'stop_504',
      name: 'Gollavanitippa Junction',
      latitude: 16.5510,
      longitude: 81.4880,
      sequence: 4,
      minutesFromOrigin: 22,
      nearbyBuilding: 'Canal Crossing',
    ),
    BusStop(
      id: 'stop_505',
      name: 'SRKR Engineering College Campus',
      latitude: collegeLat,
      longitude: collegeLng,
      sequence: 5,
      minutesFromOrigin: 28,
      isMajorHub: true,
      nearbyBuilding: 'Library & Central Lawn',
    ),

    // -------------------------------------------------------------
    // Route 6 Stops: Undi ⇄ SRKR Engineering College (~10 km)
    // -------------------------------------------------------------
    BusStop(
      id: 'stop_601',
      name: 'Undi Centre & Railway Gate',
      latitude: 16.5786,
      longitude: 81.4554,
      sequence: 1,
      minutesFromOrigin: 0,
      isMajorHub: true,
      nearbyBuilding: 'Undi Main Bazaar',
    ),
    BusStop(
      id: 'stop_602',
      name: 'Vandram Junction',
      latitude: 16.5680,
      longitude: 81.4720,
      sequence: 2,
      minutesFromOrigin: 5,
      nearbyBuilding: 'Vandram Bus Shelter',
    ),
    BusStop(
      id: 'stop_603',
      name: 'Yendagandi Center',
      latitude: 16.5580,
      longitude: 81.4900,
      sequence: 3,
      minutesFromOrigin: 10,
      nearbyBuilding: 'Yendagandi Arch',
    ),
    BusStop(
      id: 'stop_604',
      name: 'Chinna Amiram Village Center',
      latitude: 16.5450,
      longitude: 81.5120,
      sequence: 4,
      minutesFromOrigin: 15,
      nearbyBuilding: 'Amiram Lake Road',
    ),
    BusStop(
      id: 'stop_605',
      name: 'SRKR Engineering College Campus',
      latitude: collegeLat,
      longitude: collegeLng,
      sequence: 5,
      minutesFromOrigin: 18,
      isMajorHub: true,
      nearbyBuilding: 'Chinna Amiram College Main Gate',
    ),

    // -------------------------------------------------------------
    // Route 7 Stops: Maruteru ⇄ SRKR Engineering College (~24 km)
    // -------------------------------------------------------------
    BusStop(
      id: 'stop_701',
      name: 'Maruteru Agricultural Center',
      latitude: 16.6346,
      longitude: 81.7360,
      sequence: 1,
      minutesFromOrigin: 0,
      isMajorHub: true,
      nearbyBuilding: 'Maruteru Rice Research Center',
    ),
    BusStop(
      id: 'stop_702',
      name: 'Penumantra Junction',
      latitude: 16.6020,
      longitude: 81.7050,
      sequence: 2,
      minutesFromOrigin: 9,
      nearbyBuilding: 'Penumantra Clock Center',
    ),
    BusStop(
      id: 'stop_703',
      name: 'Veeravasaram Bypass',
      latitude: 16.5680,
      longitude: 81.6500,
      sequence: 3,
      minutesFromOrigin: 19,
      nearbyBuilding: 'Veeravasaram Flyover',
    ),
    BusStop(
      id: 'stop_704',
      name: 'Rayalam Cross',
      latitude: 16.5450,
      longitude: 81.5650,
      sequence: 4,
      minutesFromOrigin: 28,
      nearbyBuilding: 'Rayalam Temple Arch',
    ),
    BusStop(
      id: 'stop_705',
      name: 'SRKR Engineering College Campus',
      latitude: collegeLat,
      longitude: collegeLng,
      sequence: 5,
      minutesFromOrigin: 35,
      isMajorHub: true,
      nearbyBuilding: 'SRKR College Bus Bay 7',
    ),
  ];

  /// 7 Bus corridors connecting nearby towns with SRKR Engineering College
  static final List<BusRoute> routes = [
    BusRoute(
      id: 'route_palakollu',
      routeCode: 'R1 - Palakollu',
      routeName: 'Palakollu Express',
      startHub: 'Palakollu RTC Bus Complex',
      endHub: 'SRKR Engineering College, Bhimavaram',
      themeColor: const Color(0xFF2563EB), // Vibrant Blue
      totalDistanceKm: 21.4,
      averageDurationMinutes: 35,
      stops: stops.where((s) => s.id.startsWith('stop_1')).toList(),
      dailySchedules: const [
        '07:15 AM (Morning Pickup)',
        '07:45 AM (Regular Pickup)',
        '08:00 AM (Final Pickup)',
        '04:30 PM (Evening Return)',
        '05:15 PM (Extended Return)',
      ],
    ),
    BusRoute(
      id: 'route_tanuku',
      routeCode: 'R2 - Tanuku',
      routeName: 'Tanuku Highway Connector',
      startHub: 'Tanuku RTC Complex',
      endHub: 'SRKR Engineering College, Bhimavaram',
      themeColor: const Color(0xFF10B981), // Emerald Green
      totalDistanceKm: 34.2,
      averageDurationMinutes: 48,
      stops: stops.where((s) => s.id.startsWith('stop_2')).toList(),
      dailySchedules: const [
        '07:00 AM (Early Pickup)',
        '07:30 AM (Regular Pickup)',
        '04:30 PM (Evening Return)',
        '05:15 PM (Extended Return)',
      ],
    ),
    BusRoute(
      id: 'route_tadepalligudem',
      routeCode: 'R3 - Tadepalligudem',
      routeName: 'Tadepalligudem Express',
      startHub: 'TPG Railway Junction / Bus Station',
      endHub: 'SRKR Engineering College, Bhimavaram',
      themeColor: const Color(0xFFF59E0B), // Warm Amber
      totalDistanceKm: 42.0,
      averageDurationMinutes: 52,
      stops: stops.where((s) => s.id.startsWith('stop_3')).toList(),
      dailySchedules: const [
        '06:50 AM (Early Pickup)',
        '07:20 AM (Regular Pickup)',
        '04:30 PM (Evening Return)',
        '05:15 PM (Extended Return)',
      ],
    ),
    BusRoute(
      id: 'route_narsapur',
      routeCode: 'R4 - Narsapur',
      routeName: 'Narsapur Coastal Link',
      startHub: 'Narsapur RTC Bus Depot',
      endHub: 'SRKR Engineering College, Bhimavaram',
      themeColor: const Color(0xFF8B5CF6), // Royal Purple
      totalDistanceKm: 31.5,
      averageDurationMinutes: 42,
      stops: stops.where((s) => s.id.startsWith('stop_4')).toList(),
      dailySchedules: const [
        '07:10 AM (Regular Pickup)',
        '07:40 AM (Express Pickup)',
        '04:30 PM (Evening Return)',
        '05:15 PM (Extended Return)',
      ],
    ),
    BusRoute(
      id: 'route_akividu',
      routeCode: 'R5 - Akividu',
      routeName: 'Akividu Lake Route',
      startHub: 'Akividu Bus Station',
      endHub: 'SRKR Engineering College, Bhimavaram',
      themeColor: const Color(0xFF06B6D4), // Cyan
      totalDistanceKm: 17.8,
      averageDurationMinutes: 30,
      stops: stops.where((s) => s.id.startsWith('stop_5')).toList(),
      dailySchedules: const [
        '07:30 AM (Regular Pickup)',
        '08:00 AM (Fast Track Pickup)',
        '04:30 PM (Evening Return)',
        '05:15 PM (Extended Return)',
      ],
    ),
    BusRoute(
      id: 'route_undi',
      routeCode: 'R6 - Undi',
      routeName: 'Undi Suburban Shuttle',
      startHub: 'Undi Centre & Railway Gate',
      endHub: 'SRKR Engineering College, Bhimavaram',
      themeColor: const Color(0xFFEC4899), // Pink
      totalDistanceKm: 10.5,
      averageDurationMinutes: 20,
      stops: stops.where((s) => s.id.startsWith('stop_6')).toList(),
      dailySchedules: const [
        '07:45 AM (Morning Batch 1)',
        '08:15 AM (Morning Batch 2)',
        '04:30 PM (Evening Return)',
        '05:15 PM (Extended Return)',
      ],
    ),
    BusRoute(
      id: 'route_maruteru',
      routeCode: 'R7 - Maruteru',
      routeName: 'Maruteru Link',
      startHub: 'Maruteru Agricultural Center',
      endHub: 'SRKR Engineering College, Bhimavaram',
      themeColor: const Color(0xFFE11D48), // Rose
      totalDistanceKm: 24.0,
      averageDurationMinutes: 38,
      stops: stops.where((s) => s.id.startsWith('stop_7')).toList(),
      dailySchedules: const [
        '07:15 AM (Regular Pickup)',
        '07:45 AM (Express Pickup)',
        '04:30 PM (Evening Return)',
        '05:15 PM (Extended Return)',
      ],
    ),
  ];

  /// 7 Active SRKR College Buses serving the 7 destinations
  static List<BusModel> getInitialBuses() {
    return [
      BusModel(
        id: 'bus_srkr_01',
        busNumber: 'SRKR-BUS-01',
        routeId: 'route_palakollu',
        routeName: 'Palakollu ⇄ SRKR Engineering College',
        driverName: 'K. Satyanarayana',
        driverPhone: '+91 98480 11223',
        currentLatitude: 16.5365,
        currentLongitude: 81.6750,
        speedKmh: 42.0,
        heading: 260.0,
        totalCapacity: 55,
        occupiedSeats: 38,
        status: BusStatus.onTime,
        nextStopName: 'Veeravasaram Center',
        nextStopEtaMinutes: 6,
        lastUpdated: DateTime.now(),
      ),
      BusModel(
        id: 'bus_srkr_02',
        busNumber: 'SRKR-BUS-02',
        routeId: 'route_tanuku',
        routeName: 'Tanuku ⇄ SRKR Engineering College',
        driverName: 'M. Venkateswara Rao',
        driverPhone: '+91 98480 22334',
        currentLatitude: 16.6720,
        currentLongitude: 81.5950,
        speedKmh: 45.0,
        heading: 215.0,
        totalCapacity: 55,
        occupiedSeats: 48,
        status: BusStatus.arriving,
        nextStopName: 'Pippara Cross Roads',
        nextStopEtaMinutes: 8,
        lastUpdated: DateTime.now(),
      ),
      BusModel(
        id: 'bus_srkr_03',
        busNumber: 'SRKR-BUS-03',
        routeId: 'route_tadepalligudem',
        routeName: 'Tadepalligudem ⇄ SRKR Engineering College',
        driverName: 'P. Srinivasa Raju',
        driverPhone: '+91 98480 33445',
        currentLatitude: 16.6850,
        currentLongitude: 81.5270,
        speedKmh: 38.0,
        heading: 180.0,
        totalCapacity: 55,
        occupiedSeats: 52, // High occupancy
        status: BusStatus.delayed,
        nextStopName: 'Ganapavaram Center',
        nextStopEtaMinutes: 12,
        lastUpdated: DateTime.now(),
      ),
      BusModel(
        id: 'bus_srkr_04',
        busNumber: 'SRKR-BUS-04',
        routeId: 'route_narsapur',
        routeName: 'Narsapur ⇄ SRKR Engineering College',
        driverName: 'Ch. Subba Rao',
        driverPhone: '+91 98480 44556',
        currentLatitude: 16.4950,
        currentLongitude: 81.6450,
        speedKmh: 46.5,
        heading: 320.0,
        totalCapacity: 50,
        occupiedSeats: 32,
        status: BusStatus.onTime,
        nextStopName: 'Srungavruksham Junction',
        nextStopEtaMinutes: 9,
        lastUpdated: DateTime.now(),
      ),
      BusModel(
        id: 'bus_srkr_05',
        busNumber: 'SRKR-BUS-05',
        routeId: 'route_akividu',
        routeName: 'Akividu ⇄ SRKR Engineering College',
        driverName: 'G. Appa Rao',
        driverPhone: '+91 98480 55667',
        currentLatitude: 16.5580,
        currentLongitude: 81.4650,
        speedKmh: 36.0,
        heading: 110.0,
        totalCapacity: 50,
        occupiedSeats: 25,
        status: BusStatus.departed,
        nextStopName: 'Gollavanitippa Junction',
        nextStopEtaMinutes: 5,
        lastUpdated: DateTime.now(),
      ),
      BusModel(
        id: 'bus_srkr_06',
        busNumber: 'SRKR-BUS-06',
        routeId: 'route_undi',
        routeName: 'Undi ⇄ SRKR Engineering College',
        driverName: 'B. Krishna Murthy',
        driverPhone: '+91 98480 66778',
        currentLatitude: 16.5510,
        currentLongitude: 81.5020,
        speedKmh: 30.0,
        heading: 135.0,
        totalCapacity: 45,
        occupiedSeats: 20,
        status: BusStatus.onTime,
        nextStopName: 'Chinna Amiram Village Center',
        nextStopEtaMinutes: 4,
        lastUpdated: DateTime.now(),
      ),
      BusModel(
        id: 'bus_srkr_07',
        busNumber: 'SRKR-BUS-07',
        routeId: 'route_maruteru',
        routeName: 'Maruteru ⇄ SRKR Engineering College',
        driverName: 'V. Rama Rao',
        driverPhone: '+91 98480 77889',
        currentLatitude: 16.5820,
        currentLongitude: 81.6780,
        speedKmh: 44.0,
        heading: 245.0,
        totalCapacity: 50,
        occupiedSeats: 35,
        status: BusStatus.onTime,
        nextStopName: 'Veeravasaram Bypass',
        nextStopEtaMinutes: 7,
        lastUpdated: DateTime.now(),
      ),
    ];
  }

  /// Campus transit bulletins and announcements for SRKR
  static List<TransitAlert> getInitialAlerts() {
    return [
      TransitAlert(
        id: 'alert_srkr_01',
        title: 'Road Maintenance on Veeravasaram Stretch',
        message: 'Culvert repairs on Veeravasaram - Bhimavaram road may cause 5-7 min delay for Palakollu & Maruteru buses.',
        routeAffected: 'Palakollu & Maruteru Routes',
        severity: AlertSeverity.warning,
        timestamp: DateTime.now().subtract(const Duration(minutes: 20)),
      ),
      TransitAlert(
        id: 'alert_srkr_02',
        title: 'Evening College Return Buses at 4:30 PM & 5:15 PM',
        message: 'All 7 destination buses will depart strictly from the SRKR Chinna Amiram Bus Bay at 4:30 PM. Special lab batch at 5:15 PM.',
        routeAffected: 'All 7 Routes',
        severity: AlertSeverity.info,
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      TransitAlert(
        id: 'alert_srkr_03',
        title: 'Monsoon Safety Speed Regulation',
        message: 'Due to rains in Godavari delta, drivers instructed to observe 40 km/h speed limit. Students requested to board safely at designated shelters.',
        routeAffected: 'College-wide Fleet',
        severity: AlertSeverity.critical,
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      ),
    ];
  }

  /// Pre-configured registered student accounts for testing & instant evaluation.
  /// Any 24B91AXXXX is also programmatically supported!
  static final Map<String, StudentModel> preConfiguredStudents = {
    '24B91A0501': const StudentModel(
      regNo: '24B91A0501',
      name: 'Sai Krishna Namburi',
      branch: 'Computer Science & Engineering (CSE)',
      year: '1st Year (2024 Batch)',
      assignedBusId: 'bus_srkr_01',
      assignedBusNumber: 'SRKR-BUS-01',
      assignedRouteId: 'route_palakollu',
      assignedRouteName: 'Palakollu Express',
      boardingStop: 'Palakollu RTC Bus Complex',
      studentPhone: '+91 98491 55667',
      parentPhone: '+91 98491 00112',
    ),
    '24B91A0502': const StudentModel(
      regNo: '24B91A0502',
      name: 'Priya Varma Datla',
      branch: 'Electronics & Communication (ECE)',
      year: '1st Year (2024 Batch)',
      assignedBusId: 'bus_srkr_02',
      assignedBusNumber: 'SRKR-BUS-02',
      assignedRouteId: 'route_tanuku',
      assignedRouteName: 'Tanuku Highway Connector',
      boardingStop: 'Tanuku RTC Complex',
      studentPhone: '+91 98492 66778',
      parentPhone: '+91 98492 11223',
    ),
    '24B91A0503': const StudentModel(
      regNo: '24B91A0503',
      name: 'Venkat Raju Penmatsa',
      branch: 'Information Technology (IT)',
      year: '1st Year (2024 Batch)',
      assignedBusId: 'bus_srkr_03',
      assignedBusNumber: 'SRKR-BUS-03',
      assignedRouteId: 'route_tadepalligudem',
      assignedRouteName: 'Tadepalligudem Express',
      boardingStop: 'TPG Railway Junction / Bus Station',
      studentPhone: '+91 98493 77889',
      parentPhone: '+91 98493 22334',
    ),
    '24B91A0504': const StudentModel(
      regNo: '24B91A0504',
      name: 'Sneha Reddy Bhupathiraju',
      branch: 'Artificial Intelligence & Data Science (AI&DS)',
      year: '1st Year (2024 Batch)',
      assignedBusId: 'bus_srkr_04',
      assignedBusNumber: 'SRKR-BUS-04',
      assignedRouteId: 'route_narsapur',
      assignedRouteName: 'Narsapur Coastal Link',
      boardingStop: 'Narsapur RTC Bus Depot',
      studentPhone: '+91 98494 88990',
      parentPhone: '+91 98494 33445',
    ),
    '24B91A0505': const StudentModel(
      regNo: '24B91A0505',
      name: 'Akhil Varma Sagi',
      branch: 'Mechanical Engineering (ME)',
      year: '1st Year (2024 Batch)',
      assignedBusId: 'bus_srkr_05',
      assignedBusNumber: 'SRKR-BUS-05',
      assignedRouteId: 'route_akividu',
      assignedRouteName: 'Akividu Lake Route',
      boardingStop: 'Akividu Bus Station',
      studentPhone: '+91 98495 99001',
      parentPhone: '+91 98495 44556',
    ),
    '24B91A0506': const StudentModel(
      regNo: '24B91A0506',
      name: 'Divya Sri Gokaraju',
      branch: 'Civil Engineering (CE)',
      year: '1st Year (2024 Batch)',
      assignedBusId: 'bus_srkr_06',
      assignedBusNumber: 'SRKR-BUS-06',
      assignedRouteId: 'route_undi',
      assignedRouteName: 'Undi Suburban Shuttle',
      boardingStop: 'Undi Centre & Railway Gate',
      studentPhone: '+91 98496 00112',
      parentPhone: '+91 98496 55667',
    ),
    '24B91A0507': const StudentModel(
      regNo: '24B91A0507',
      name: 'Kalyan Ram Kanumuri',
      branch: 'Computer Science & Design (CSD)',
      year: '1st Year (2024 Batch)',
      assignedBusId: 'bus_srkr_07',
      assignedBusNumber: 'SRKR-BUS-07',
      assignedRouteId: 'route_maruteru',
      assignedRouteName: 'Maruteru Link',
      boardingStop: 'Maruteru Agricultural Center',
      studentPhone: '+91 98497 11223',
      parentPhone: '+91 98497 66778',
    ),
  };

  /// Returns student profile for any valid 24B91AXXXX registration number.
  /// If it's one of the pre-configured students, returns that exact record.
  /// If it's another valid 24B91AXXXX, deterministically assigns one of the 7 routes based on hash.
  static StudentModel getStudentByRegNo(String normalizedRegNo) {
    if (preConfiguredStudents.containsKey(normalizedRegNo)) {
      return preConfiguredStudents[normalizedRegNo]!;
    }

    // Deterministic route assignment for any new valid 24B91AXXXX
    final hash = normalizedRegNo.hashCode.abs();
    final busIndex = hash % 7; // 0 to 6
    final buses = getInitialBuses();
    final assignedBus = buses[busIndex];
    final route = routes.firstWhere((r) => r.id == assignedBus.routeId);
    final boardingStop = route.stops.first.name;

    return StudentModel(
      regNo: normalizedRegNo,
      name: 'SRKR Student (${normalizedRegNo.substring(6)})',
      branch: 'B.Tech Engineering',
      year: '1st Year (2024 Batch)',
      assignedBusId: assignedBus.id,
      assignedBusNumber: assignedBus.busNumber,
      assignedRouteId: route.id,
      assignedRouteName: route.routeName,
      boardingStop: boardingStop,
      studentPhone: '+91 98480 ${10000 + (hash % 89999)}',
      parentPhone: '+91 98480 ${20000 + (hash % 89999)}',
    );
  }
}
