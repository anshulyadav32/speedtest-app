// lib/core/utils/ip_utils.dart

class IpUtils {
  IpUtils._();

  /// Shorten an IPv6 address for compact display.
  /// e.g. "2401:4900:1c5a:5e9b:..." → "2401:4900:1c5a:…:e9b"
  static String shortenIPv6(String ip) {
    if (ip.isEmpty || ip == '--') return '—';
    final parts = ip.split(':');
    if (parts.length <= 4) return ip;
    return '${parts.take(3).join(':')}:…:${parts.last}';
  }

  /// Returns true if the value looks like a real IPv6 address.
  static bool isIPv6(String ip) => ip.contains(':');
}
