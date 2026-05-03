import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:net_speed_test/widgets/gauge.dart';

void main() {
  Widget createWidgetUnderTest(Widget child) {
    return MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: 300,
          height: 300,
          child: child,
        ),
      ),
    );
  }

  group('SpeedGauge Tests', () {
    testWidgets('renders properly with 0 speed', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        const SpeedGauge(speed: 0.0),
      ));

      // The CustomPaint should be present
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('renders properly with 50.0 speed', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        const SpeedGauge(speed: 50.0),
      ));

      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('renders properly with 100.0 speed', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        const SpeedGauge(speed: 100.0),
      ));

      expect(find.byType(CustomPaint), findsWidgets);
    });
  });
}
