import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:net_speed_test/main.dart';
import 'package:net_speed_test/services/speed_test_service.dart';

// Simple mock that doesn't start real timers
class MockSpeedTestService extends SpeedTestService {
  TestState _mockState = TestState.idle;

  @override
  TestState get state => _mockState;

  void setMockState(TestState s) {
    _mockState = s;
    notifyListeners();
  }

  @override
  Future<void> runTest() async {
    // No-op for mock
  }

  @override
  Future<void> fetchNetworkDetails() async {
    // No-op for mock
  }
}

void main() {
  testWidgets('Test State Transition UI Logic', (WidgetTester tester) async {
    final mockService = MockSpeedTestService();
    
    await tester.pumpWidget(
      ChangeNotifierProvider<SpeedTestService>.value(
        value: mockService,
        child: const NetSpeedApp(),
      ),
    );

    // 1. Initial State (Idle)
    expect(find.text('GO'), findsOneWidget);

    // 2. Set to Latency State
    mockService.setMockState(TestState.latency);
    await tester.pump(const Duration(milliseconds: 500)); 

    expect(find.text('TESTING PING...'), findsOneWidget);
    expect(find.text('DOWNLOAD'), findsOneWidget);
    expect(find.text('UPLOAD'), findsOneWidget);
    expect(find.text('GO'), findsNothing);

    // 3. Set to Finished State
    mockService.setMockState(TestState.finished);
    await tester.pump(const Duration(milliseconds: 500)); 

    // ResultsView components - use .last because InfoBar also has 'CONNECTIONS'
    expect(find.text('TEST AGAIN'), findsOneWidget);
    expect(find.text('CONNECTIONS'), findsAtLeast(1));
    expect(find.text('YOUR ISP'), findsOneWidget);
  });
}
