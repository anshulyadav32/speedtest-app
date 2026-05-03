// lib/widgets/results/ping_row.dart

import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// The triple-ping row (Idle / Download / Upload) shown in results.
class PingRow extends StatelessWidget {
  final int idlePing;
  final int downloadPing;
  final int uploadPing;

  const PingRow({
    super.key,
    required this.idlePing,
    required this.downloadPing,
    required this.uploadPing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.network_ping_rounded,
              size: 13, color: AppColors.textSecondary),
          const SizedBox(width: 6),
          const Text(
            'Ping',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
          const Spacer(),
          _PingChip(label: 'Idle',     ms: idlePing),
          const SizedBox(width: 20),
          _PingChip(label: 'Download', ms: downloadPing),
          const SizedBox(width: 20),
          _PingChip(label: 'Upload',   ms: uploadPing),
        ],
      ),
    );
  }
}

class _PingChip extends StatelessWidget {
  final String label;
  final int ms;

  const _PingChip({required this.label, required this.ms});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          ms > 0 ? '$ms' : '--',
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(label,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 9)),
        const Text('ms',
            style: TextStyle(color: AppColors.textDim, fontSize: 9)),
      ],
    );
  }
}
