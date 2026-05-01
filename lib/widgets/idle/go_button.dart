// lib/widgets/idle/go_button.dart

import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// The animated pulsing GO button shown on the idle screen.
class GoButton extends StatelessWidget {
  final Animation<double> pulseAnimation;
  final VoidCallback onTap;

  const GoButton({
    super.key,
    required this.pulseAnimation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final double buttonSize =
        (MediaQuery.of(context).size.width * 0.45).clamp(120.0, 200.0);
    return Center(
      key: const ValueKey('idle'),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ScaleTransition(
            scale: pulseAnimation,
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                width: buttonSize,
                height: buttonSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.accent, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accent.withOpacity(0.15),
                      blurRadius: 40,
                      spreadRadius: 8,
                    ),
                  ],
                ),
                child: Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.accent.withOpacity(0.05),
                  ),
                  child: Center(
                    child: Text(
                      'GO',
                      style: TextStyle(
                        fontSize: buttonSize * 0.25,
                        fontWeight: FontWeight.w900,
                        color: AppColors.accent,
                        letterSpacing: 4,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 28),
          const Text(
            'Tap GO to start your speed test',
            style: TextStyle(color: AppColors.textDim, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
