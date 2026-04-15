// lib/widgets/common/info_bar.dart

import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/ip_utils.dart';
import '../../models/network_details.dart';
import 'info_bar_tile.dart';

/// Persistent bar shown at the top of every screen —
/// displays Connections, Server, ISP, IPv4, IPv6.
class InfoBar extends StatelessWidget {
  final NetworkDetails details;

  const InfoBar({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.surfaceDeep,
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.06)),
        ),
      ),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 0,
        runSpacing: 8,
        children: [
          InfoBarTile(
            label: 'CONNECTIONS',
            value: 'Multi',
            icon: Icons.swap_horiz_rounded,
          ),
          _sep(),
          InfoBarTile(
            label: 'SERVER',
            value: details.isDetected ? details.sponsor : '—',
            sub: details.city.isNotEmpty ? details.city : '',
            icon: Icons.dns_rounded,
          ),
          _sep(),
          InfoBarTile(
            label: 'ISP',
            value: details.isDetected ? details.isp : '—',
            icon: Icons.business_rounded,
          ),
          _sep(),
          InfoBarTile(
            label: 'IPv4',
            value: details.publicIPv4,
            icon: Icons.router_rounded,
            mono: true,
          ),
          _sep(),
          InfoBarTile(
            label: 'IPv6',
            value: details.publicIPv6 != '--'
                ? IpUtils.shortenIPv6(details.publicIPv6)
                : '—',
            icon: Icons.router_rounded,
            mono: true,
          ),
          _sep(),
          InfoBarTile(
            label: 'PRIVATE IP',
            value: details.privateIP != '--' ? details.privateIP : '—',
            icon: Icons.lock_rounded,
            mono: true,
          ),
          _sep(),
          InfoBarTile(
            label: 'TEST SERVER',
            value: details.isDetected ? details.serverName : '—',
            icon: Icons.speed_rounded,
          ),
        ],
      ),
    );
  }

  Widget _sep() => Container(
        width: 1,
        height: 32,
        color: Colors.white.withOpacity(0.07),
      );
}
