// lib/models/network_details.dart

class NetworkDetails {
  final String publicIPv4;
  final String publicIPv6;
  final String privateIP;
  final String isp;
  final String city;
  final String deviceName;
  final String sponsor;
  final String serverName;

  const NetworkDetails({
    required this.publicIPv4,
    required this.publicIPv6,
    required this.privateIP,
    required this.isp,
    required this.city,
    required this.deviceName,
    required this.sponsor,
    required this.serverName,
  });

  static NetworkDetails empty() => const NetworkDetails(
    publicIPv4: '--',
    publicIPv6: '--',
    privateIP:  '--',
    isp:        'Detecting...',
    city:       'Detecting...',
    deviceName: 'Unknown Device',
    sponsor:    'Detecting...',
    serverName: 'Detecting...',
  );

  bool get isDetected => isp != 'Detecting...';
}
