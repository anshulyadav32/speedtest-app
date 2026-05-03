import 'package:flutter/material.dart';

class MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final bool isHighlight;
  final Widget? subMetrics;

  const MetricCard({
    super.key,
    required this.label,
    required this.value,
    this.unit = '',
    this.isHighlight = false,
    this.subMetrics,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: isHighlight 
            ? Theme.of(context).colorScheme.primary.withOpacity(0.05)
            : const Color(0xFF16162D).withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isHighlight 
              ? Theme.of(context).colorScheme.primary 
              : Colors.white.withOpacity(0.1),
          width: isHighlight ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Colors.white.withOpacity(0.6),
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Montserrat',
                      color: isHighlight ? Theme.of(context).colorScheme.primary : Colors.white,
                    ),
                  ),
                ),
              ),
              if (unit.isNotEmpty) ...[
                const SizedBox(width: 4),
                Text(
                  unit,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
              ],
            ],
          ),
          if (subMetrics != null) ...[
            const SizedBox(height: 12),
            subMetrics!,
          ],
        ],
      ),
    );
  }
}
