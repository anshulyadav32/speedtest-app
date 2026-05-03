// lib/widgets/results/ip_block.dart

import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// Displays a single IP address (v4 or v6) in a labelled monospace block.
class IpBlock extends StatelessWidget {
  final String label;
  final String ip;

  const IpBlock({super.key, required this.label, required this.ip});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 9,
              color: AppColors.textMuted,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            ip,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.white70,
              fontFamily: 'monospace',
              letterSpacing: 0.5,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
