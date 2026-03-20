import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:speedtest/providers/speed_test_provider.dart';
import 'package:speedtest/widgets/extra_info_widget.dart';
import 'package:speedtest/widgets/radial_gauge.dart';
import 'package:speedtest/widgets/testing_units_widget.dart';

class SpeedTest extends StatelessWidget {
  const SpeedTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SpeedTestProvider>(
      builder: (context, provider, _) {
        final Size size = MediaQuery.of(context).size;
        final bool isIdle = provider.phase == TestPhase.idle;
        final bool isDone = provider.phase == TestPhase.done;

        String phaseLabel = '';
        if (provider.phase == TestPhase.ping) phaseLabel = 'Testing Ping...';
        if (provider.phase == TestPhase.download) {
          phaseLabel = 'Testing Download...';
        }
        if (provider.phase == TestPhase.upload) {
          phaseLabel = 'Testing Upload...';
        }

        // Normalize to 0-100 for the gauge (max expected speed 500 Mbps)
        final double gaugeDisplay =
            (provider.gaugeValue / 500 * 100).clamp(0.0, 100.0);

        return Padding(
          padding: const EdgeInsets.only(left: 5, right: 5, bottom: 15),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TestingUnitsWidget(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    iconData: FontAwesomeIcons.circleUp,
                    iconColor: Colors.orange.shade700,
                    digit: provider.upload.toStringAsFixed(1),
                    title: 'Upload',
                    unit: 'Mbps',
                    isDownload: false,
                  ),
                  TestingUnitsWidget(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    iconData: FontAwesomeIcons.circleDown,
                    iconColor: Colors.green.shade700,
                    digit: provider.download.toStringAsFixed(1),
                    title: 'Download',
                    unit: 'Mbps',
                    isDownload: true,
                  ),
                  TestingUnitsWidget(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    iconData: Icons.sync,
                    iconColor: Colors.red,
                    digit: '${provider.ping}',
                    title: 'Ping',
                    unit: 'ms',
                    isDownload: false,
                  ),
                ],
              ),
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: size.width * 0.85,
                      child: RadialGauge(
                        value: gaugeDisplay,
                        showAnnotation: false,
                      ),
                    ),
                    if (isIdle || isDone)
                      ElevatedButton(
                        onPressed: () =>
                            context.read<SpeedTestProvider>().startTest(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(24),
                        ),
                        child: Text(
                          isIdle ? 'GO' : 'RETRY',
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ),
                    if (provider.isTesting)
                      Text(
                        phaseLabel,
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ),
              if (!isIdle)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Expanded(
                      child: ExtraInfoWidget(
                        iconData: provider.networkIcon,
                        title: provider.isWifi ? 'Wi-Fi' : 'Operator',
                        subtitle: provider.networkName,
                      ),
                    ),
                    Expanded(
                      child: ExtraInfoWidget(
                        iconData: Icons.router,
                        title: 'IP Address',
                        subtitle: provider.publicIp,
                      ),
                    ),
                    Expanded(
                      child: ExtraInfoWidget(
                        iconData: provider.integrityStatus == 'certified'
                            ? Icons.verified_user
                            : Icons.shield_outlined,
                        title: 'Device',
                        subtitle: provider.integrityStatus == 'certified'
                            ? 'Certified'
                            : provider.integrityStatus == 'uncertified'
                                ? 'Not Verified'
                                : 'Checking...',
                      ),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}
