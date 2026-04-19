import 'package:flutter_test/flutter_test.dart';
import 'package:netspeed/services/speed_test_service.dart';

void main() {
  group('SpeedTestService Tests', () {
    late SpeedTestService service;

    setUp(() {
      service = SpeedTestService();
    });

    test('Initial state should be idle', () {
      expect(service.state, TestState.idle);
      expect(service.downloadSpeed, 0.0);
      expect(service.uploadSpeed, 0.0);
      expect(service.ping, 0);
      expect(service.progress, 0.0);
    });

    test('reset() should clear all values', () {
      // Manually trigger some progress
      service.reset();
      expect(service.state, TestState.idle);
      expect(service.progress, 0.0);
      expect(service.downloadSpeed, 0.0);
    });

    test('runTest() should transition through all states', () async {
      // Since runTest is asynchronous and triggers timers/delays, we can verify it starts.
      // Note: Real network calls in fetchNetworkDetails might need mocking for more robust tests.
      
      final testFuture = service.runTest();
      
      // Initially it should move to latency
      expect(service.state, TestState.latency);
      
      await testFuture;
      
      expect(service.state, TestState.finished);
      expect(service.progress, closeTo(1.0, 0.1));
    });
  });
}
