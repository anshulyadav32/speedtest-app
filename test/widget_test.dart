import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:netspeed/main.dart';
import 'package:netspeed/services/speed_test_service.dart';

void main() {
  testWidgets('NetSpeed App Smoke Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => SpeedTestService()),
        ],
        child: const NetSpeedApp(),
      ),
    );

    // Verify that the title "NETSPEED" is present.
    expect(find.text('NETSPEED'), findsOneWidget);

    // Verify that the "GO" button is present in idle state.
    expect(find.text('GO'), findsOneWidget);

    // Verify that "APPS" and "ANALYSIS" buttons are present in AppBar.
    expect(find.text('APPS'), findsOneWidget);
    expect(find.text('ANALYSIS'), findsOneWidget);
  });
}
