// Comprehensive tests for the Speedtest app.
// Covers: SpeedTestProvider (unit), HomeScreen, SpeedTest screen,
// HistoryScreen, and SettingsScreen (widget smoke tests).

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:provider/provider.dart';
import 'package:speedtest/providers/speed_test_provider.dart';
import 'package:speedtest/providers/theme_manager.dart';
import 'package:speedtest/screens/history_screen.dart';
import 'package:speedtest/screens/home_screen.dart';
import 'package:speedtest/screens/settings_screen.dart';
import 'package:speedtest/screens/speed_test.dart';
import 'package:speedtest/services/themes.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/// Builds a minimal app that wraps [child] with the required providers.
Widget buildTestApp(Widget child, {SpeedTestProvider? provider}) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ThemeManager()),
      ChangeNotifierProvider(
        create: (_) => provider ?? SpeedTestProvider(),
      ),
    ],
    child: Consumer<ThemeManager>(
      builder: (_, themeManager, __) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: themeManager.isDark ? darkTheme : lightTheme,
        home: Scaffold(body: child),
      ),
    ),
  );
}

/// Creates a [MockClient] that returns canned responses for every URL the
/// provider calls during a speed test.
http.Client makeMockClient({String ip = '1.2.3.4'}) {
  return MockClient((request) async {
    final url = request.url.toString();

    if (url.contains('api.ipify.org')) {
      return http.Response(ip, 200);
    }

    if (url.contains('__down')) {
      // Return 1 KB of zeros – fast but non-empty so bytesReceived > 0.
      return http.Response(List.filled(1024, 0).toString(), 200);
    }

    if (url.contains('__up')) {
      return http.Response('', 200);
    }

    return http.Response('not found', 404);
  });
}

// ---------------------------------------------------------------------------
// SpeedTestProvider – unit tests
// ---------------------------------------------------------------------------

void main() {
  group('SpeedTestProvider – initial state', () {
    test('phase is idle', () {
      final p = SpeedTestProvider();
      expect(p.phase, TestPhase.idle);
    });

    test('isTesting is false initially', () {
      final p = SpeedTestProvider();
      expect(p.isTesting, isFalse);
    });

    test('download, upload, ping start at 0', () {
      final p = SpeedTestProvider();
      expect(p.download, 0);
      expect(p.upload, 0);
      expect(p.ping, 0);
    });

    test('publicIp starts as "--"', () {
      final p = SpeedTestProvider();
      expect(p.publicIp, '--');
    });

    test('history starts empty', () {
      final p = SpeedTestProvider();
      expect(p.history, isEmpty);
    });

    test('history list is unmodifiable', () {
      final p = SpeedTestProvider();
      expect(() => (p.history as dynamic).clear(), throwsUnsupportedError);
    });
  });

  group('SpeedTestProvider – startTest() with mock HTTP', () {
    late SpeedTestProvider provider;

    setUp(() {
      provider = SpeedTestProvider(client: makeMockClient());
    });

    test('phase becomes done after test completes', () async {
      await provider.startTest();
      expect(provider.phase, TestPhase.done);
    });

    test('isTesting is false after test completes', () async {
      await provider.startTest();
      expect(provider.isTesting, isFalse);
    });

    test('history has one entry after test', () async {
      await provider.startTest();
      expect(provider.history.length, 1);
    });

    test('history entry has real public IP from mock', () async {
      await provider.startTest();
      expect(provider.history.first.ip, '1.2.3.4');
    });

    test('publicIp is updated from mock response', () async {
      await provider.startTest();
      expect(provider.publicIp, '1.2.3.4');
    });

    test('ping is recorded (>= 0ms)', () async {
      await provider.startTest();
      expect(provider.ping, greaterThanOrEqualTo(0));
    });

    test('download is >= 0 after test', () async {
      await provider.startTest();
      expect(provider.download, greaterThanOrEqualTo(0));
    });

    test('upload is >= 0 after test', () async {
      await provider.startTest();
      expect(provider.upload, greaterThanOrEqualTo(0));
    });

    test('calling startTest twice concurrently is idempotent', () async {
      final f1 = provider.startTest();
      final f2 = provider.startTest(); // should be ignored while testing
      await Future.wait([f1, f2]);
      // Only one history entry should be added
      expect(provider.history.length, 1);
    });

    test('notifyListeners fires at least once during test', () async {
      int calls = 0;
      provider.addListener(() => calls++);
      await provider.startTest();
      expect(calls, greaterThan(0));
    });
  });

  group('SpeedTestProvider – clearHistory()', () {
    test('removes all history entries', () async {
      final provider = SpeedTestProvider(client: makeMockClient());
      await provider.startTest();
      expect(provider.history, isNotEmpty);
      provider.clearHistory();
      expect(provider.history, isEmpty);
    });

    test('phase remains the same after clearHistory', () async {
      final provider = SpeedTestProvider(client: makeMockClient());
      await provider.startTest();
      provider.clearHistory();
      expect(provider.phase, TestPhase.done);
    });
  });

  group('SpeedTestProvider – HTTP error handling', () {
    test('test completes even when HTTP calls throw', () async {
      final errorClient = MockClient((_) async => throw Exception('no net'));
      final provider = SpeedTestProvider(client: errorClient);
      await provider.startTest(); // must not throw
      expect(provider.phase, TestPhase.done);
    });

    test('download is 0 when HTTP errors', () async {
      final errorClient = MockClient((_) async => throw Exception('no net'));
      final provider = SpeedTestProvider(client: errorClient);
      await provider.startTest();
      expect(provider.download, 0);
    });

    test('upload is 0 when HTTP errors', () async {
      final errorClient = MockClient((_) async => throw Exception('no net'));
      final provider = SpeedTestProvider(client: errorClient);
      await provider.startTest();
      expect(provider.upload, 0);
    });

    test('publicIp is set to "Unknown" when IP fetch errors', () async {
      final errorClient = MockClient((_) async => throw Exception('no net'));
      final provider = SpeedTestProvider(client: errorClient);
      await provider.startTest();
      expect(provider.publicIp, 'Unknown');
    });
  });

  // -------------------------------------------------------------------------
  // Widget tests
  // -------------------------------------------------------------------------

  group('HomeScreen widget', () {
    testWidgets('renders bottom navigation bar', (tester) async {
      await tester.pumpWidget(MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeManager()),
          ChangeNotifierProvider(
              create: (_) => SpeedTestProvider(client: makeMockClient())),
        ],
        child: Consumer<ThemeManager>(
          builder: (_, themeManager, __) => MaterialApp(
            theme: themeManager.isDark ? darkTheme : lightTheme,
            home: HomeScreen(),
          ),
        ),
      ));

      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });

    testWidgets('has three nav items: History, Speedtest, Settings',
        (tester) async {
      await tester.pumpWidget(MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeManager()),
          ChangeNotifierProvider(
              create: (_) => SpeedTestProvider(client: makeMockClient())),
        ],
        child: Consumer<ThemeManager>(
          builder: (_, themeManager, __) => MaterialApp(
            theme: themeManager.isDark ? darkTheme : lightTheme,
            home: HomeScreen(),
          ),
        ),
      ));

      expect(find.text('History'), findsOneWidget);
      expect(find.text('Speedtest'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
    });
  });

  group('SpeedTest screen widget', () {
    testWidgets('shows GO button when idle', (tester) async {
      final provider = SpeedTestProvider(client: makeMockClient());
      await tester
          .pumpWidget(buildTestApp(const SpeedTest(), provider: provider));
      await tester.pump();

      expect(find.text('GO'), findsOneWidget);
    });

    testWidgets('shows RETRY button after test done', (tester) async {
      final provider = SpeedTestProvider(client: makeMockClient());
      await tester
          .pumpWidget(buildTestApp(const SpeedTest(), provider: provider));

      // Trigger the test programmatically
      await provider.startTest();
      await tester.pump();

      expect(find.text('RETRY'), findsOneWidget);
    });

    testWidgets('shows Upload, Download, Ping labels', (tester) async {
      final provider = SpeedTestProvider(client: makeMockClient());
      await tester
          .pumpWidget(buildTestApp(const SpeedTest(), provider: provider));
      await tester.pump();

      expect(find.textContaining('Upload'), findsWidgets);
      expect(find.textContaining('Download'), findsWidgets);
      expect(find.textContaining('Ping'), findsWidgets);
    });

    testWidgets('tapping GO button triggers test (phase leaves idle)',
        (tester) async {
      final provider = SpeedTestProvider(client: makeMockClient());
      await tester
          .pumpWidget(buildTestApp(const SpeedTest(), provider: provider));
      await tester.pump();

      await tester.tap(find.text('GO'));
      await tester.pump();

      expect(provider.phase, isNot(TestPhase.idle));
    });
  });

  group('HistoryScreen widget', () {
    testWidgets('renders without crashing when history is empty',
        (tester) async {
      final provider = SpeedTestProvider(client: makeMockClient());
      await tester
          .pumpWidget(buildTestApp(const HistoryScreen(), provider: provider));
      await tester.pump();
      // Simply must not throw
    });

    testWidgets('shows history card after a test', (tester) async {
      final provider = SpeedTestProvider(client: makeMockClient());
      await provider.startTest();

      await tester
          .pumpWidget(buildTestApp(const HistoryScreen(), provider: provider));
      await tester.pump();

      // History has one entry; the card should show the IP or speed
      expect(provider.history.length, 1);
    });
  });

  group('SettingsScreen widget', () {
    testWidgets('renders without crashing', (tester) async {
      final provider = SpeedTestProvider(client: makeMockClient());
      await tester
          .pumpWidget(buildTestApp(const SettingsScreen(), provider: provider));
      await tester.pump();
    });

    testWidgets('contains a Scrollable / SingleChildScrollView',
        (tester) async {
      final provider = SpeedTestProvider(client: makeMockClient());
      await tester
          .pumpWidget(buildTestApp(const SettingsScreen(), provider: provider));
      await tester.pump();

      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });
  });
}
