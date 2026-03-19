import 'package:flutter/material.dart';

class ExtraInfoWidget extends StatelessWidget {
  const ExtraInfoWidget({
    super.key,
    required this.iconData,
    required this.title,
    required this.subtitle,
  });
  final IconData iconData;
  final String title, subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Icon(
          iconData,
          size: 30,
        ),
        SizedBox(width: 5),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                subtitle,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 15),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
