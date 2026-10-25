import 'package:flutter_test/flutter_test.dart';
import 'package:campus_bus_tracker/core/constants/app_constants.dart';
import 'package:campus_bus_tracker/data/mock_transit_data.dart';
import 'package:campus_bus_tracker/providers/auth_provider.dart';
import 'package:campus_bus_tracker/providers/transit_provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  group('SRKR Engineering College Constants & Routes Tests', () {
    test('Verify 7 regional destination locations', () {
      expect(AppConstants.nearbyLocations.length, 7);
      expect(AppConstants.nearbyLocations, contains('Palakollu'));
      expect(AppConstants.nearbyLocations, contains('Tanuku'));
      expect(AppConstants.nearbyLocations, contains('Tadepalligudem'));
      expect(AppConstants.nearbyLocations, contains('Narsapur'));
      expect(AppConstants.nearbyLocations, contains('Akividu'));
      expect(AppConstants.nearbyLocations, contains('Undi'));
      expect(AppConstants.nearbyLocations, contains('Maruteru'));
    });

    test('Verify all 7 routes have SRKR College as common destination', () {
      final routes = MockTransitData.routes;
      expect(routes.length, 7);
      for (final route in routes) {
        expect(route.endHub, contains('SRKR Engineering College'));
        expect(route.stops.last.name, contains('SRKR Engineering College'));
      }
    });

    test('Verify 7 active fleet buses correspond to 7 routes', () {
      final buses = MockTransitData.getInitialBuses();
      expect(buses.length, 7);
      expect(buses.map((b) => b.busNumber).toSet().length, 7);
    });
  });

  group('Student Registration Number Pattern & Auth Tests', () {
    test('Regex correctly matches 24B91AXXXX format', () {
      expect(AppConstants.studentRegNoRegex.hasMatch('24B91A0501'), isTrue);
      expect(AppConstants.studentRegNoRegex.hasMatch('24b91a0501'), isTrue); // case-insensitive
      expect(AppConstants.studentRegNoRegex.hasMatch('24B91A1234'), isTrue);
      expect(AppConstants.studentRegNoRegex.hasMatch('24B91A05H9'), isTrue);

      // Rejections
      expect(AppConstants.studentRegNoRegex.hasMatch('23B91A0501'), isFalse); // wrong year prefix
      expect(AppConstants.studentRegNoRegex.hasMatch('24B91'), isFalse); // too short
      expect(AppConstants.studentRegNoRegex.hasMatch('24B91A05011'), isFalse); // too long
      expect(AppConstants.studentRegNoRegex.hasMatch('random_user'), isFalse);
    });

    test('AuthProvider login validation works properly', () async {
      final auth = AuthProvider();

      // Test 1: Empty credentials rejection
      final errorEmpty = await auth.login(regNo: '', password: '');
      expect(errorEmpty, contains('Please enter'));

      // Test 2: Invalid pattern rejection
      final errorPattern = await auth.login(regNo: '23B91A0501', password: '23B91A0501');
      expect(errorPattern, contains('24B91AXXXX'));

      // Test 3: Password mismatch rejection
      final errorMismatch = await auth.login(regNo: '24B91A0501', password: 'WrongPassword');
      expect(errorMismatch, contains('Password must be identical'));

      // Test 4: Successful login
      final success = await auth.login(regNo: '24B91A0501', password: '24B91A0501');
      expect(success, isNull);
      expect(auth.isLoggedIn, isTrue);
      expect(auth.isStudentAuthenticated, isTrue);
      expect(auth.currentStudent?.regNo, '24B91A0501');
      expect(auth.currentStudent?.assignedBusNumber, 'SRKR-BUS-01');
      expect(auth.currentStudent?.assignedRouteName, 'Palakollu Express');
    });

    test('Student assigned bus isolation test', () async {
      final transit = TransitProvider();

      // Student 1 (Palakollu)
      final student1 = MockTransitData.getStudentByRegNo('24B91A0501');
      expect(student1.assignedBusId, 'bus_srkr_01');
      final bus1 = transit.getAssignedBus(student1.assignedBusId);
      expect(bus1?.busNumber, 'SRKR-BUS-01');
      expect(bus1?.routeName, contains('Palakollu'));

      // Student 2 (Tanuku)
      final student2 = MockTransitData.getStudentByRegNo('24B91A0502');
      expect(student2.assignedBusId, 'bus_srkr_02');
      final bus2 = transit.getAssignedBus(student2.assignedBusId);
      expect(bus2?.busNumber, 'SRKR-BUS-02');
      expect(bus2?.routeName, contains('Tanuku'));

      // Student 3 (Tadepalligudem)
      final student3 = MockTransitData.getStudentByRegNo('24B91A0503');
      expect(student3.assignedBusId, 'bus_srkr_03');
      final bus3 = transit.getAssignedBus(student3.assignedBusId);
      expect(bus3?.busNumber, 'SRKR-BUS-03');
      expect(bus3?.routeName, contains('Tadepalligudem'));
    });
  });
}
