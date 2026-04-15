// lib/widgets/results/results_view.dart

import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../services/speed_test_service.dart';
import '../common/meta_label.dart';
import 'speed_block.dart';
import 'ping_row.dart';
import 'ip_block.dart';

/// Full results dashboard — shown when TestState.finished.
class ResultsView extends StatelessWidget {
  final SpeedTestService service;

  const ResultsView({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    final d = service.details;

    return SingleChildScrollView(
      key: const ValueKey('finished'),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          // ── Main Card ───────────────────────────────────────────────
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.07)),
            ),
            child: Column(
              children: [
                // Download / Upload
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: SpeedBlock(
                          label: 'Download',
                          value: service.downloadSpeed,
                          color: AppColors.accent,
                          icon: Icons.arrow_downward_rounded,
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 80,
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        color: AppColors.divider,
                      ),
                      Expanded(
                        child: SpeedBlock(
                          label: 'Upload',
                          value: service.uploadSpeed,
                          color: AppColors.accentGreen,
                          icon: Icons.arrow_upward_rounded,
                        ),
                      ),
                    ],
                  ),
                ),

                // Triple Ping
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                  child: PingRow(
                    idlePing:     service.ping,
                    downloadPing: service.downloadPing,
                    uploadPing:   service.uploadPing,
                  ),
                ),

                const SizedBox(height: 20),
                const Divider(height: 1, color: AppColors.divider),

                // Connection meta + IPs
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Left col
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const MetaLabel('CONNECTIONS'),
                                const Text('Multi',
                                    style: TextStyle(
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                    )),
                                const SizedBox(height: 14),
                                const MetaLabel('SERVER'),
                                Text(d.sponsor,
                                    style: const TextStyle(
                                      color: AppColors.accent,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                    )),
                                Text(d.city,
                                    style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 12,
                                    )),
                                const SizedBox(height: 14),
                                const MetaLabel('TEST SERVER'),
                                Text(d.serverName,
                                    style: const TextStyle(
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    )),
                              ],
                            ),
                          ),
                          // Right col
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const MetaLabel('YOUR ISP'),
                                Text(d.isp,
                                    style: const TextStyle(
                                      color: AppColors.accent,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                    ),
                                    textAlign: TextAlign.end),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(height: 1, color: AppColors.divider),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(child: IpBlock(label: 'IPv4', ip: d.publicIPv4)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: IpBlock(
                              label: 'IPv6',
                              ip: d.publicIPv6 != '--'
                                  ? d.publicIPv6
                                  : 'Not available',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      IpBlock(
                        label: 'PRIVATE IP (LOCAL NETWORK)',
                        ip: d.privateIP != '--' ? d.privateIP : 'Not available on Web',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Test Again
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => service.reset(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: AppColors.background,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              child: const Text(
                'TEST AGAIN',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
