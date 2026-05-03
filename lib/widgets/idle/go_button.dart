// lib/widgets/idle/go_button.dart

import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// The animated pulsing GO button shown on the idle screen.
class GoButton extends StatelessWidget {
  final Animation<double> pulseAnimation;
  final double availableHeight;
  final VoidCallback onTap;

  const GoButton({
    super.key,
    required this.pulseAnimation,
    required this.availableHeight,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final compactLayout = availableHeight < 180;
    final buttonSize = [
      mediaQuery.size.width * 0.45,
      availableHeight * (compactLayout ? 0.6 : 0.58),
      200.0,
    ].reduce((value, element) => value < element ? value : element).clamp(
          56.0,
          200.0,
        );
    final effectivePulse = compactLayout ? const AlwaysStoppedAnimation(1.0) : pulseAnimation;
    final showSubtitle = availableHeight > 240;

    return Center(
      key: const ValueKey('idle'),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ScaleTransition(
            scale: effectivePulse,
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
          if (showSubtitle) ...[
            const SizedBox(height: 28),
            const Text(
              'Tap GO to start your speed test',
              style: TextStyle(color: AppColors.textDim, fontSize: 13),
            ),
          ],
        ],
      ),
    );
  }
}
