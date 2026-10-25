/// Model representing an authenticated SRKR student and their assigned bus.
class StudentModel {
  final String regNo;
  final String name;
  final String branch;
  final String year;
  final String assignedBusId;
  final String assignedBusNumber;
  final String assignedRouteId;
  final String assignedRouteName;
  final String boardingStop;
  final String destination;
  final String studentPhone;
  final String parentPhone;
  final String busPassValidity;

  const StudentModel({
    required this.regNo,
    required this.name,
    required this.branch,
    required this.year,
    required this.assignedBusId,
    required this.assignedBusNumber,
    required this.assignedRouteId,
    required this.assignedRouteName,
    required this.boardingStop,
    this.destination = 'SRKR Engineering College, Bhimavaram',
    this.studentPhone = '+91 98765 43210',
    this.parentPhone = '+91 98765 01234',
    this.busPassValidity = 'Valid for Academic Year 2024-2025',
  });

  Map<String, dynamic> toJson() {
    return {
      'regNo': regNo,
      'name': name,
      'branch': branch,
      'year': year,
      'assignedBusId': assignedBusId,
      'assignedBusNumber': assignedBusNumber,
      'assignedRouteId': assignedRouteId,
      'assignedRouteName': assignedRouteName,
      'boardingStop': boardingStop,
      'destination': destination,
      'studentPhone': studentPhone,
      'parentPhone': parentPhone,
      'busPassValidity': busPassValidity,
    };
  }

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      regNo: json['regNo'] as String? ?? '24B91A0501',
      name: json['name'] as String? ?? 'SRKR Student',
      branch: json['branch'] as String? ?? 'CSE',
      year: json['year'] as String? ?? '1st Year',
      assignedBusId: json['assignedBusId'] as String? ?? 'bus_srkr_01',
      assignedBusNumber: json['assignedBusNumber'] as String? ?? 'SRKR-BUS-01',
      assignedRouteId: json['assignedRouteId'] as String? ?? 'route_palakollu',
      assignedRouteName: json['assignedRouteName'] as String? ?? 'Palakollu Express',
      boardingStop: json['boardingStop'] as String? ?? 'Palakollu RTC Bus Complex',
      destination: json['destination'] as String? ?? 'SRKR Engineering College, Bhimavaram',
      studentPhone: json['studentPhone'] as String? ?? '+91 98765 43210',
      parentPhone: json['parentPhone'] as String? ?? '+91 98765 01234',
      busPassValidity: json['busPassValidity'] as String? ?? 'Valid for Academic Year 2024-2025',
    );
  }
}
