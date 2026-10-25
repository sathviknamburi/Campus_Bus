import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

/// Severity level of transit announcements.
enum AlertSeverity {
  info,
  warning,
  critical,
}

/// Represents a live campus bus bulletin, delay notice, or maintenance broadcast.
class TransitAlert {
  final String id;
  final String title;
  final String message;
  final String? routeAffected;
  final AlertSeverity severity;
  final DateTime timestamp;
  final bool isRead;

  const TransitAlert({
    required this.id,
    required this.title,
    required this.message,
    this.routeAffected,
    required this.severity,
    required this.timestamp,
    this.isRead = false,
  });

  /// Icon corresponding to the alert severity
  IconData get icon {
    switch (severity) {
      case AlertSeverity.info:
        return Icons.info_outline;
      case AlertSeverity.warning:
        return Icons.warning_amber_rounded;
      case AlertSeverity.critical:
        return Icons.dangerous_rounded;
    }
  }

  /// Color corresponding to the alert severity
  Color get color {
    switch (severity) {
      case AlertSeverity.info:
        return AppColors.accentCyan;
      case AlertSeverity.warning:
        return AppColors.warningAmber;
      case AlertSeverity.critical:
        return AppColors.dangerRed;
    }
  }

  TransitAlert copyWith({
    String? id,
    String? title,
    String? message,
    String? routeAffected,
    AlertSeverity? severity,
    DateTime? timestamp,
    bool? isRead,
  }) {
    return TransitAlert(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      routeAffected: routeAffected ?? this.routeAffected,
      severity: severity ?? this.severity,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
    );
  }
}
