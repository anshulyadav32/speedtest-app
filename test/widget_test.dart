import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:net_speed_test/main.dart';
import 'package:net_speed_test/services/speed_test_service.dart';

void main() {
  testWidgets('NET Speed Test App Smoke Test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => SpeedTestService()),
        ],
        child: const NetSpeedApp(),
      ),
    );

    expect(find.text('NET Speed Test'), findsOneWidget);
    expect(find.text('GO'), findsOneWidget);
    expect(find.text('APPS'), findsOneWidget);
    expect(find.text('ANALYSIS'), findsOneWidget);
  });

  testWidgets('Footer Navigation Test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => SpeedTestService()),
        ],
        child: const NetSpeedApp(),
      ),
    );

    final aboutLink = find.text('ABOUT');
    final privacyLink = find.text('PRIVACY POLICY');
    final termsLink = find.text('TERMS & CONDITIONS');

    // 1. Test ABOUT Navigation
    await tester.tap(aboutLink);
    await tester.pump(const Duration(seconds: 1)); 
    
    expect(find.text('ABOUT'), findsAtLeast(1));
    expect(find.textContaining('CONNECTION'), findsAtLeast(1));
    
    // Pop the page
    Navigator.pop(tester.element(find.text('ABOUT').last));
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('GO'), findsOneWidget);

    // 2. Test PRIVACY Navigation
    await tester.tap(privacyLink);
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('PRIVACY POLICY'), findsAtLeast(1));

    Navigator.pop(tester.element(find.text('PRIVACY POLICY').last));
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('GO'), findsOneWidget);

    // 3. Test TERMS Navigation
    await tester.tap(termsLink);
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('TERMS & CONDITIONS'), findsAtLeast(1));

    Navigator.pop(tester.element(find.text('TERMS & CONDITIONS').last));
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('GO'), findsOneWidget);
  });
}
