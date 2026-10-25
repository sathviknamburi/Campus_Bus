import 'package:flutter_test/flutter_test.dart';
import 'package:campus_bus_tracker/main.dart';

void main() {
  testWidgets('SRKR CampusBusApp smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const CampusBusApp());
    await tester.pump(const Duration(milliseconds: 300));

    // Verify app renders SRKR Engineering College branding or app title
    expect(find.textContaining('SRKR'), findsWidgets);
  });
}
