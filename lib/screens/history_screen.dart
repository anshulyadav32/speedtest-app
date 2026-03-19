import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speedtest/providers/speed_test_provider.dart';
import 'package:speedtest/widgets/history_card_widget.dart';
import 'package:speedtest/widgets/history_detail_dialog.dart';
import 'package:speedtest/widgets/radial_gauge.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SpeedTestProvider>(
      builder: (context, provider, _) {
        final history = provider.history;
        if (history.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                RadialGauge(showAnnotation: true, value: 0),
                SizedBox(height: 12),
                Text('No tests yet. Tap GO to run a speed test.'),
              ],
            ),
          );
        }
        return ListView.builder(
          itemCount: history.length,
          itemBuilder: (context, index) {
            final item = history[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: GestureDetector(
                onTap: () {
                  showModal(
                    context: context,
                    builder: (BuildContext context) {
                      return HistoryDetailDialog(
                        time: item.time,
                        networkType: item.networkType,
                        ping: item.ping,
                        download: item.download,
                        upload: item.upload,
                        ip: item.ip,
                        location: item.location,
                        wifiName: item.wifiName,
                      );
                    },
                  );
                },
                child: HistoryCardWidget(
                  time: item.time,
                  network: item.networkType,
                  ping: item.ping,
                  download: item.download,
                  upload: item.upload,
                  ip: item.ip,
                  location: item.location,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
