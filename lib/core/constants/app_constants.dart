/// App-wide static constants for SRKR Engineering College Campus Bus Tracker.
/// Centrally maintains college identity, coordinates, 7 nearby locations, and auth rules.
class AppConstants {
  static const String appName = 'SRKR Campus Bus Tracker';
  static const String appVersion = '1.0.0';
  static const String collegeName = 'Sagi Rama Krishnam Raju Engineering College';
  static const String collegeShortName = 'SRKR Engineering College';
  static const String campusLocation = 'Chinna Amiram, Bhimavaram, Andhra Pradesh - 534204';
  static const String tagline = 'Real-time Campus Transit & Fleet Telemetry';

  // College Geographic Coordinates (Central Hub)
  static const double collegeLatitude = 16.5407;
  static const double collegeLongitude = 81.5228;

  // 7 Nearby Destination Locations connecting to SRKR College
  static const List<String> nearbyLocations = [
    'Palakollu',
    'Tanuku',
    'Tadepalligudem',
    'Narsapur',
    'Akividu',
    'Undi',
    'Maruteru',
  ];

  // Student Authentication Pattern (e.g. 24B91A0501)
  // Starts with 24B91A followed by exactly 4 alphanumeric characters (total 10 chars)
  static const String studentRegNoPrefix = '24B91A';
  static final RegExp studentRegNoRegex = RegExp(r'^24B91A[0-9A-Z]{4}$', caseSensitive: false);

  // Navigation tab titles
  static const String tabHome = 'Home';
  static const String tabTrack = 'Track';
  static const String tabRoutes = 'Routes';
  static const String tabAnnouncements = 'Alerts';
  static const String tabProfile = 'Profile';

  // Transport Cell Contact Details
  static const String transportIncharge = 'Sri. K. V. Satyanarayana Raju';
  static const String transportPhone = '+91 94401 23456';
  static const String transportOfficePhone = '08816 - 223344';
  static const String transportEmail = 'transport@srkr.edu.in';
  static const String emergencyHelpline = '1800 425 7757';

  // Simulation settings
  static const int simulationIntervalSeconds = 3;
}

