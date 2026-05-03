// lib/widgets/common/meta_label.dart

import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// Small ALL-CAPS section label (e.g. "SERVER", "YOUR ISP").
class MetaLabel extends StatelessWidget {
  final String text;
  const MetaLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 9,
          color: AppColors.textMuted,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
