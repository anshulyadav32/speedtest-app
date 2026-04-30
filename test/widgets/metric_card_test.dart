import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:net_speed_test/widgets/metric_card.dart';

void main() {
  Widget createWidgetUnderTest(Widget child) {
    return MaterialApp(
      home: Scaffold(
        body: child,
      ),
    );
  }

  group('MetricCard Tests', () {
    testWidgets('renders all provided information correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        const MetricCard(
          label: 'DOWNLOAD',
          value: '100.5',
          unit: 'Mbps',
        ),
      ));

      expect(find.text('DOWNLOAD'), findsOneWidget);
      expect(find.text('100.5'), findsOneWidget);
      expect(find.text('Mbps'), findsOneWidget);
    });

    testWidgets('renders with empty value gracefully', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        const MetricCard(
          label: 'PING',
          value: '--',
          unit: 'ms',
        ),
      ));

      expect(find.text('PING'), findsOneWidget);
      expect(find.text('--'), findsOneWidget);
      expect(find.text('ms'), findsOneWidget);
    });
  });
}
