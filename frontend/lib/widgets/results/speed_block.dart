// lib/widgets/results/speed_block.dart

import 'package:flutter/material.dart';

/// Large speed display for Download or Upload on the results card.
class SpeedBlock extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  final IconData icon;

  const SpeedBlock({
    super.key,
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 13, color: color.withOpacity(0.7)),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                color: color.withOpacity(0.7),
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          value.toStringAsFixed(2),
          style: TextStyle(
            color: color,
            fontSize: 42,
            fontWeight: FontWeight.w900,
            height: 1,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Mbps',
          style: TextStyle(color: Colors.white38, fontSize: 12),
        ),
      ],
    );
  }
}
