import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;
import 'package:net_speed_test/services/speed_test_service.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  setUpAll(() {
    registerFallbackValue(Uri());
  });

  group('SpeedTestService Tests', () {
    late SpeedTestService service;
    late MockClient mockClient;

    setUp(() {
      mockClient = MockClient();
      
      // Default stubbing for fetchNetworkDetails
      when(() => mockClient.get(Uri.parse('https://api4.ipify.org?format=json')))
          .thenAnswer((_) async => http.Response('{"ip":"1.2.3.4"}', 200));
      when(() => mockClient.get(Uri.parse('https://api6.ipify.org?format=json')))
          .thenAnswer((_) async => http.Response('{"ip":"fe80::1"}', 200));
      when(() => mockClient.get(Uri.parse('https://ipapi.co/json/'), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response('{"org":"Test ISP","city":"Test City","ip":"1.2.3.4"}', 200));

      service = SpeedTestService(client: mockClient);
    });

    test('Initial state should be idle', () {
      expect(service.state, TestState.idle);
      expect(service.downloadSpeed, 0.0);
      expect(service.uploadSpeed, 0.0);
      expect(service.ping, 0);
      expect(service.progress, 0.0);
    });

    test('reset() should clear all values', () {
      service.reset();
      expect(service.state, TestState.idle);
      expect(service.progress, 0.0);
      expect(service.downloadSpeed, 0.0);
    });

    test('fetchNetworkDetails populates correct data', () async {
      // Need to wait for the constructor's async call to finish
      await Future.delayed(const Duration(milliseconds: 100));
      
      expect(service.details.publicIPv4, '1.2.3.4');
      expect(service.details.publicIPv6, 'fe80::1');
      expect(service.details.isp, 'Test ISP');
      expect(service.details.city, 'Test City');
      expect(service.details.serverName, 'Test ISP - Test City');
    });

    test('fetchNetworkDetails handles failure gracefully', () async {
      // Create a failing client
      final failClient = MockClient();
      when(() => failClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      
      final failService = SpeedTestService(client: failClient);
      await Future.delayed(const Duration(milliseconds: 100));
      
      expect(failService.details.publicIPv4, '--');
      expect(failService.details.publicIPv6, '--');
      expect(failService.details.isp, 'Unknown ISP');
    });

    test('runTest() progresses through all states', () async {
      when(() => mockClient.get(Uri.parse('https://www.google.com/favicon.ico')))
          .thenAnswer((_) async => http.Response('', 200));

      final testFuture = service.runTest();
      expect(service.state, TestState.latency);
      
      // Wait a bit to move to download
      await Future.delayed(const Duration(milliseconds: 1500));
      expect(service.state, TestState.download);

      // We won't wait the full 22 seconds for the complete test, 
      // but we can verify state transitions.
    });
  });
}
