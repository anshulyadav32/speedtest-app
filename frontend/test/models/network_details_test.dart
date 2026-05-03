import 'package:flutter_test/flutter_test.dart';
import 'package:net_speed_test/models/network_details.dart';

void main() {
  group('NetworkDetails', () {
    test('should instantiate with correct values', () {
      const details = NetworkDetails(
        publicIPv4: '192.168.1.1',
        publicIPv6: '2001:0db8:85a3:0000:0000:8a2e:0370:7334',
        privateIP: '10.0.0.2',
        isp: 'Test ISP',
        city: 'Test City',
        deviceName: 'Test Device',
        sponsor: 'Test Sponsor',
        serverName: 'Test Server',
      );

      expect(details.publicIPv4, '192.168.1.1');
      expect(details.publicIPv6, '2001:0db8:85a3:0000:0000:8a2e:0370:7334');
      expect(details.privateIP, '10.0.0.2');
      expect(details.isp, 'Test ISP');
      expect(details.city, 'Test City');
      expect(details.deviceName, 'Test Device');
      expect(details.sponsor, 'Test Sponsor');
      expect(details.serverName, 'Test Server');
    });

    test('empty() should return default empty values', () {
      final details = NetworkDetails.empty();

      expect(details.publicIPv4, '--');
      expect(details.publicIPv6, '--');
      expect(details.privateIP, '--');
      expect(details.isp, 'Detecting...');
      expect(details.city, 'Detecting...');
      expect(details.deviceName, 'Unknown Device');
      expect(details.sponsor, 'Detecting...');
      expect(details.serverName, 'Detecting...');
    });
  });
}
