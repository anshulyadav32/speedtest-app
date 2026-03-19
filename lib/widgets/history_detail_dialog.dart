import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:speedtest/providers/theme_manager.dart';
import 'package:speedtest/widgets/extra_info_widget.dart';
import 'package:speedtest/widgets/radial_gauge.dart';

import 'dialog_share_close_button.dart';

class HistoryDetailDialog extends StatelessWidget {
  const HistoryDetailDialog({
    super.key,
    required this.time,
    required this.networkType,
    required this.ping,
    required this.download,
    required this.upload,
    required this.ip,
    required this.location,
    required this.wifiName,
  });
  final String time;
  final String ip;
  final String location;
  final String wifiName;
  final IconData networkType;
  final int ping;
  final double download;
  final double upload;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Color themedColor = isLightTheme(context) ? Colors.black : Colors.white;
    TextTheme textTheme = Theme.of(context).textTheme;
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 25, vertical: 100),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            style: BorderStyle.solid,
            color: Theme.of(context).colorScheme.secondary,
          )),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                UploadPingWidget(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  size: size,
                  textTheme: textTheme,
                  themedColor: themedColor,
                  ping: upload,
                  iconData: FontAwesomeIcons.circleUp,
                  iconColor: Colors.orange.shade700,
                  label: ' Upload',
                  unit: 'Mbps',
                ),
                UploadPingWidget(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  size: size,
                  textTheme: textTheme,
                  themedColor: themedColor,
                  ping: ping.toDouble(),
                  iconData: Icons.sync,
                  iconColor: Colors.red.shade500,
                  label: ' Ping',
                  unit: 'ms',
                ),
              ],
            ),
            SizedBox(height: size.height * 0.01),
            Expanded(
              child: SizedBox(
                width: size.width * 0.7,
                child: Stack(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              FontAwesomeIcons.circleDown,
                              size: size.height * 0.025,
                              color: Colors.green.shade700,
                            ),
                            Text(
                              ' Download',
                              style: (textTheme.titleLarge ?? const TextStyle())
                                  .copyWith(
                                fontWeight: FontWeight.w400,
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              '$download',
                              style:
                                  (textTheme.displaySmall ?? const TextStyle())
                                      .copyWith(
                                color: themedColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Mbps',
                              style: textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Positioned(
                      top: size.height * 0.1,
                      width: size.width * 0.7,
                      child: RadialGauge(
                        showAnnotation: false,
                        value: download,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ExtraInfoWidget(
                  iconData: Icons.wifi,
                  title: 'Wifi',
                  subtitle: wifiName,
                ),
                ExtraInfoWidget(
                  iconData: Icons.router,
                  title: 'IP Address',
                  subtitle: ip,
                ),
              ],
            ),
            SizedBox(height: size.height * 0.015),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ExtraInfoWidget(
                  iconData: Icons.location_on,
                  title: 'Location',
                  subtitle: location,
                ),
                ExtraInfoWidget(
                  iconData: Icons.schedule,
                  title: 'Time',
                  subtitle: time,
                ),
              ],
            ),
            SizedBox(height: size.height * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                DialogShareCloseButton(
                    size: size,
                    label: 'Share',
                    iconData: Icons.share,
                    onPress: () {}),
                DialogShareCloseButton(
                  size: size,
                  label: 'Close',
                  iconData: Icons.close,
                  onPress: () => Navigator.pop(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class UploadPingWidget extends StatelessWidget {
  const UploadPingWidget({
    super.key,
    required this.themedColor,
    required this.ping,
    required this.label,
    required this.unit,
    required this.iconData,
    required this.iconColor,
    required this.textTheme,
    required this.crossAxisAlignment,
    required this.size,
  });

  final CrossAxisAlignment crossAxisAlignment;
  final TextTheme textTheme;
  final Color themedColor;
  final Size size;
  final double ping;
  final String label, unit;
  final IconData iconData;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: <Widget>[
        Row(
          children: <Widget>[
            Icon(
              iconData,
              size: size.height * 0.025,
              color: Colors.red.shade500,
            ),
            Text(
              label,
              style: (textTheme.titleLarge ?? const TextStyle())
                  .copyWith(color: themedColor, fontWeight: FontWeight.w400),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Text(
              '$ping',
              style: (textTheme.headlineMedium ?? const TextStyle())
                  .copyWith(color: themedColor, fontWeight: FontWeight.bold),
            ),
            Text(
              unit,
              style: (textTheme.titleLarge ?? const TextStyle())
                  .copyWith(fontWeight: FontWeight.w400, color: themedColor),
            ),
          ],
        ),
      ],
    );
  }
}
