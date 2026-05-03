// lib/widgets/common/info_bar_tile.dart

import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// A single tile inside the persistent InfoBar.
class InfoBarTile extends StatelessWidget {
  final String label;
  final String value;
  final String sub;
  final IconData icon;
  final bool mono;

  const InfoBarTile({
    super.key,
    required this.label,
    required this.value,
    this.sub = '',
    required this.icon,
    this.mono = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 11, color: AppColors.textDim),
              const SizedBox(width: 4),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 9,
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              fontFamily: mono ? 'monospace' : null,
              letterSpacing: mono ? 0.5 : 0,
            ),
          ),
          if (sub.isNotEmpty)
            Text(
              sub,
              style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
            ),
        ],
      ),
    );
  }
}
