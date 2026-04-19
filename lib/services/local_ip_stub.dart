// lib/services/local_ip_stub.dart
// Stub for non-web platforms — local IP is fetched via network_info_plus instead.

Future<String> getWebLocalIP() async => '--';
