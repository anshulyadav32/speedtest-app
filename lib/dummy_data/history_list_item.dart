import 'package:flutter/material.dart';

class Items {
  const Items({
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
}

List<Items> historyItemList = [
  Items(
    time:
        '${DateTime.now().month}/${DateTime.now().day} ${DateTime.now().hour}:${DateTime.now().minute}',
    networkType: Icons.wifi,
    ping: 28,
    download: 87.7,
    upload: 4.2,
    ip: '127.0.0.1',
    location: 'Dallas, TX',
    wifiName: 'Khalid 5G',
  ),
  Items(
    time:
        '${DateTime.now().month}/${DateTime.now().day} ${DateTime.now().hour}:${DateTime.now().minute}',
    networkType: Icons.speaker_phone,
    ping: 84,
    download: 42.1,
    upload: 5.9,
    ip: '63.5.1.1',
    location: 'Minneapolis, MN',
    wifiName: 'Starbucks\' guest',
  ),
  Items(
    time:
        '${DateTime.now().month}/${DateTime.now().day} ${DateTime.now().hour}:${DateTime.now().minute}',
    networkType: Icons.wifi,
    ping: 11,
    download: 257.1,
    upload: 61.3,
    ip: '15.49.81.3',
    location: 'Los Angeles, CA',
    wifiName: 'The Good Neighbor',
  ),
  Items(
    time:
        '${DateTime.now().month}/${DateTime.now().day} ${DateTime.now().hour}:${DateTime.now().minute}',
    networkType: Icons.wifi,
    ping: 28,
    download: 51.4,
    upload: 4.2,
    ip: '127.0.0.1',
    location: 'Dallas, TX',
    wifiName: 'Bob',
  ),
  Items(
    time:
        '${DateTime.now().month}/${DateTime.now().day} ${DateTime.now().hour}:${DateTime.now().minute}',
    networkType: Icons.speaker_phone,
    ping: 84,
    download: 5.6,
    upload: 5.9,
    ip: '63.5.1.1',
    location: 'Minneapolis, MN',
    wifiName: 'MN Rules',
  ),
  Items(
    time:
        '${DateTime.now().month}/${DateTime.now().day} ${DateTime.now().hour}:${DateTime.now().minute}',
    networkType: Icons.wifi,
    ping: 11,
    download: 21.8,
    upload: 3.1,
    ip: '15.49.81.3',
    location: 'Los Angeles, CA',
    wifiName: 'I H8 Winter',
  ),
  Items(
    time:
        '${DateTime.now().month}/${DateTime.now().day} ${DateTime.now().hour}:${DateTime.now().minute}',
    networkType: Icons.wifi,
    ping: 11,
    download: 349.8,
    upload: 84.3,
    ip: '15.49.81.3',
    location: 'Los Angeles, CA',
    wifiName: 'I H8 Winter',
  ),
  Items(
    time:
        '${DateTime.now().month}/${DateTime.now().day} ${DateTime.now().hour}:${DateTime.now().minute}',
    networkType: Icons.wifi,
    ping: 28,
    download: 87.7,
    upload: 4.2,
    ip: '127.0.0.1',
    location: 'Dallas, TX',
    wifiName: 'Jesus Not Jesus',
  ),
  Items(
    time:
        '${DateTime.now().month}/${DateTime.now().day} ${DateTime.now().hour}:${DateTime.now().minute}',
    networkType: Icons.speaker_phone,
    ping: 84,
    download: 42.1,
    upload: 5.9,
    ip: '63.5.1.1',
    location: 'Minneapolis, MN',
    wifiName: 'Bob\'s Bedroom',
  ),
  Items(
    time:
        '${DateTime.now().month}/${DateTime.now().day} ${DateTime.now().hour}:${DateTime.now().minute}',
    networkType: Icons.wifi,
    ping: 28,
    download: 87.7,
    upload: 4.2,
    ip: '127.0.0.1',
    location: 'Dallas, TX',
    wifiName: 'Master haxer',
  ),
  Items(
    time:
        '${DateTime.now().month}/${DateTime.now().day} ${DateTime.now().hour}:${DateTime.now().minute}',
    networkType: Icons.speaker_phone,
    ping: 84,
    download: 42.1,
    upload: 5.9,
    ip: '63.5.1.1',
    location: 'Minneapolis, MN',
    wifiName: 'Don\'t hack me plz',
  ),
  Items(
    time:
        '${DateTime.now().month}/${DateTime.now().day} ${DateTime.now().hour}:${DateTime.now().minute}',
    networkType: Icons.wifi,
    ping: 11,
    download: 435.6,
    upload: 84.3,
    ip: '15.49.81.3',
    location: 'Los Angeles, CA',
    wifiName: 'xfinity',
  ),
  Items(
    time:
        '${DateTime.now().month}/${DateTime.now().day} ${DateTime.now().hour}:${DateTime.now().minute}',
    networkType: Icons.wifi,
    ping: 11,
    download: 136.84,
    upload: 84.3,
    ip: '15.49.81.3',
    location: 'Los Angeles, CA',
    wifiName: 'NETGEAR00',
  ),
];
