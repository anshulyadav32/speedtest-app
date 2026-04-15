// lib/widgets/running/running_view.dart

import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../services/speed_test_service.dart';
import '../gauge.dart';
import '../metric_card.dart';

/// Full test-in-progress screen: phase label, metric cards, gauge, progress bar.
class RunningView extends StatelessWidget {
  final SpeedTestService service;

  const RunningView({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    final String phase = switch (service.state) {
      TestState.latency  => 'TESTING PING...',
      TestState.download => 'TESTING DOWNLOAD...',
      _                  => 'TESTING UPLOAD...',
    };

    return Column(
      key: const ValueKey('running'),
      children: [
        const SizedBox(height: 16),
        Text(
          phase,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(
                child: MetricCard(
                  label: 'Download',
                  value: service.downloadSpeed.toStringAsFixed(2),
                  unit: 'Mbps',
                  isHighlight: service.state == TestState.download,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: MetricCard(
                  label: 'Upload',
                  value: service.uploadSpeed.toStringAsFixed(2),
                  unit: 'Mbps',
                  isHighlight: service.state == TestState.upload,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        SpeedGauge(speed: service.currentLiveSpeed),
        const Spacer(),
        if (service.state == TestState.latency && service.ping > 0)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: '${service.ping}',
                  style: const TextStyle(
                    color: AppColors.accent,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text: ' ms',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                ),
              ]),
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: service.progress,
              minHeight: 3,
              backgroundColor: Colors.white10,
              valueColor: const AlwaysStoppedAnimation(AppColors.accent),
            ),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
